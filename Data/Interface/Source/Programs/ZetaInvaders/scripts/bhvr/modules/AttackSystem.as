package bhvr.modules
{
	import flash.events.EventDispatcher;
	import bhvr.interfaces.IGameSystem;
	import flash.display.MovieClip;
	import bhvr.views.MotherShip;
	import bhvr.views.Cow;
	import bhvr.constatnts.GameConstants;
	import bhvr.debug.Log;
	import aze.motion.eaze;
	import bhvr.events.GameEvents;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.views.Alien;
	import flash.geom.Point;
	import bhvr.views.Barn;
	import bhvr.utils.MathUtil;
	import bhvr.utils.FlashUtil;
	import bhvr.events.EventWithParams;
	import aze.motion.easing.Linear;
	
	public class AttackSystem extends EventDispatcher implements IGameSystem
	{
		 
		
		private var _assets:MovieClip;
		
		private var _barnController:bhvr.modules.BarnController;
		
		private var _speedInterval:Number;
		
		private var _shootInterval:Number;
		
		private var _waveCounter:int;
		
		private var _moveCounter:int;
		
		private var _stepDownCounter:int;
		
		private var _maxStepDown:int;
		
		private var _underBarnsPosY:Number;
		
		private var _waveOnBarns:Boolean;
		
		private var _alienWave:bhvr.modules.AlienWave;
		
		private var _motherShip:MotherShip;
		
		private var _cow:Cow;
		
		private var _tractorBeamTimerObject:MovieClip;
		
		private var _gameplayFrozen:Boolean;
		
		public function AttackSystem(assets:MovieClip, barns:bhvr.modules.BarnController)
		{
			super();
			this._assets = assets;
			this._barnController = barns;
			this.initialize();
		}
		
		public function get alienWave() : bhvr.modules.AlienWave
		{
			return this._alienWave;
		}
		
		public function get motherShip() : MotherShip
		{
			return this._motherShip;
		}
		
		public function get cow() : Cow
		{
			return this._cow;
		}
		
		public function initialize() : void
		{
			this._underBarnsPosY = GameConstants.barnsInitialYPosition + GameConstants.NUMBER_OF_BARN_PIECES_ROW * GameConstants.BARN_PIECE_SIZE;
			this._assets.floorMc.y = this._underBarnsPosY;
			this._tractorBeamTimerObject = new MovieClip();
			Log.info("Attack System initialized");
		}
		
		public function start() : void
		{
			this.reset();
			this.attack();
			this.startSpawnTimer();
		}
		
		public function stop() : void
		{
			eaze(this).killTweens();
			if(this._alienWave)
			{
				this._alienWave.dispose();
				this._alienWave.removeEventListener(GameEvents.ALIEN_WAVE_STEP_DOWN,this.onWaveStepDown);
				this._alienWave.removeEventListener(GameEvents.ALIEN_SHOOT_BARN,this.onAlienShootBarn);
				this._alienWave.removeEventListener(GameEvents.ALIEN_SHOOTING_LASER,this.onShootingLaser);
				this._alienWave.removeEventListener(GameEvents.ALIEN_WAVE_DESTROYED,this.onWaveDestroyed);
				this._alienWave = null;
			}
			this.stopMotherShipTimer();
			if(this._motherShip)
			{
				eaze(this._motherShip).killTweens();
				this.deleteMotherShipReference();
				SoundManager.instance.stopSound(SoundList.MOTHERSHIP_LOOP_SOUND_ID);
			}
			this.stopTractorBeamTimer();
			if(this._cow)
			{
				this.deleteCowReference();
			}
		}
		
		public function freeze() : void
		{
			var shooter:Alien = null;
			this._gameplayFrozen = true;
			eaze(this).killTweens();
			var shooters:Vector.<Alien> = this._alienWave.shooters.concat();
			for(var i:uint = 0; i < shooters.length; i++)
			{
				shooter = shooters[i];
				if(shooter.projectile)
				{
					shooter.terminateShoot();
				}
			}
			this.generateShootInterval();
			if(this._motherShip)
			{
				SoundManager.instance.stopSound(SoundList.MOTHERSHIP_LOOP_SOUND_ID);
				eaze(this._motherShip).killTweens();
				this.deleteMotherShipReference();
			}
			if(this._alienWave.alienUfoTractor)
			{
				this._alienWave.alienUfoTractor.pauseTractorBeam();
			}
		}
		
		public function unfreeze() : void
		{
			this._gameplayFrozen = false;
			this.attack();
			if(this._alienWave.alienUfoTractor)
			{
				this._alienWave.alienUfoTractor.resumeTractorBeam();
			}
		}
		
		public function attack() : void
		{
			eaze(this).delay(this._speedInterval).onComplete(this.onWaveMove);
		}
		
		private function shoot() : void
		{
			var alien:Alien = null;
			var i:uint = 0;
			var alienId:uint = 0;
			var alienPos:Point = null;
			var alienPosX:Number = NaN;
			var targetBarn:Barn = null;
			var targetBarnPiece:MovieClip = null;
			if(this._alienWave.activeProjectileNum == GameConstants.MAX_NUMBER_OF_ENEMY_PROJECTILES)
			{
				return;
			}
			var shooters:Vector.<Alien> = this._alienWave.shooters.concat();
			for(i = 0; i < shooters.length; i++)
			{
				if(shooters[i].projectile != null)
				{
					shooters.splice(i,1);
				}
			}
			var maxProjectileNum:uint = Math.min(shooters.length,GameConstants.MAX_NUMBER_OF_ENEMY_PROJECTILES - this._alienWave.activeProjectileNum);
			if(maxProjectileNum == 0)
			{
				return;
			}
			var projectileNum:uint = MathUtil.random(1,maxProjectileNum);
			for(i = 0; i < projectileNum; i++)
			{
				alienId = MathUtil.random(0,shooters.length - 1);
				alien = shooters[alienId];
				if(alien.projectile != null)
				{
					return;
				}
				alienPos = FlashUtil.localToGlobalPosition(alien);
				alienPosX = alienPos.x;
				targetBarn = this._barnController.getBarnfromPosition(alienPosX);
				if(targetBarn)
				{
					targetBarnPiece = targetBarn.getPiecefromPosition(alienPosX,true);
					if(targetBarnPiece)
					{
						alien.shootBarn(targetBarn,targetBarnPiece);
					}
					else
					{
						alien.shootLaser(this._underBarnsPosY);
					}
				}
				else
				{
					alien.shootLaser(this._underBarnsPosY);
				}
				shooters.splice(alienId,1);
			}
		}
		
		private function reset() : void
		{
			this._speedInterval = GameConstants.alienWaveMaxInterval;
			this._waveCounter = 0;
			this.generateShootInterval();
			this._stepDownCounter = 0;
			this._waveOnBarns = false;
			this._gameplayFrozen = false;
			this.createWave();
			this._maxStepDown = Math.ceil((this._underBarnsPosY - (this._alienWave.startPosY + this._alienWave.container.height)) / GameConstants.alienWaveDistMoveVertical);
		}
		
		private function createWave() : void
		{
			this._waveCounter++;
			this._alienWave = new bhvr.modules.AlienWave(this._assets);
			this._alienWave.addEventListener(GameEvents.ALIEN_WAVE_STEP_DOWN,this.onWaveStepDown,false,0,true);
			this._alienWave.addEventListener(GameEvents.ALIEN_SHOOT_BARN,this.onAlienShootBarn,false,0,true);
			this._alienWave.addEventListener(GameEvents.ALIEN_SHOOTING_LASER,this.onShootingLaser,false,0,true);
			this._alienWave.addEventListener(GameEvents.ALIEN_WAVE_DESTROYED,this.onWaveDestroyed,false,0,true);
			this.updateWaveSpeedInterval();
		}
		
		private function updateWaveSpeedInterval() : void
		{
			var currentWaveInterval:Number = GameConstants.alienWaveMaxInterval * Math.pow(1 - GameConstants.alienWaveIntervalMod,this._waveCounter - 1);
			var deltaInterval:Number = currentWaveInterval - GameConstants.alienWaveMinInterval;
			var alienNum:int = this._alienWave.alienCount;
			if(alienNum == 1)
			{
				this._speedInterval = GameConstants.alienWaveIntervalLastAlien;
				return;
			}
			if(deltaInterval <= 0)
			{
				this._speedInterval = GameConstants.alienWaveMinInterval;
				return;
			}
			var initAlienNum:int = GameConstants.NUMBER_OF_ALIEN_COLUMNS * GameConstants.NUMBER_OF_ALIEN_ROWS;
			var intervalAlienRemaining:Number = (1 - GameConstants.alienWaveIntervalRatio) * deltaInterval * ((alienNum - 1) / (initAlienNum - 1));
			var intervalWaveStepDownRemaining:Number = GameConstants.alienWaveIntervalRatio * deltaInterval * ((this._maxStepDown - this._stepDownCounter - 1) / (this._maxStepDown - 1));
			this._speedInterval = intervalAlienRemaining + intervalWaveStepDownRemaining + GameConstants.alienWaveMinInterval;
		}
		
		private function generateShootInterval() : void
		{
			this._moveCounter = 0;
			this._shootInterval = MathUtil.random(GameConstants.alienShootMinInterval,GameConstants.alienShootMaxInterval);
		}
		
		private function onWaveMove() : void
		{
			if(!this._gameplayFrozen && this._alienWave && this._alienWave.alienCount > 0)
			{
				this._moveCounter++;
				this._alienWave.move();
				if(this._alienWave == null)
				{
					return;
				}
				if(this._moveCounter == this._shootInterval)
				{
					this.shoot();
					this.generateShootInterval();
				}
				if(this._waveOnBarns)
				{
					dispatchEvent(new EventWithParams(GameEvents.ALIEN_WAVE_HIT_BARNS));
				}
				this.attack();
			}
		}
		
		private function onWaveDestroyed(e:EventWithParams) : void
		{
			Log.info("-- WAVE DESTROYED --");
			SoundManager.instance.playSound(SoundList.ALIEN_WAVE_DESTRUCTION_SOUND);
			eaze(this).killTweens();
			this.generateShootInterval();
			this._stepDownCounter = 0;
			this._waveOnBarns = false;
			this.createWave();
			this.attack();
		}
		
		private function onWaveStepDown(e:EventWithParams) : void
		{
			var wavePosY:Number = e.params.posY;
			this._stepDownCounter++;
			this.updateWaveSpeedInterval();
			if(wavePosY > GameConstants.barnsInitialYPosition && wavePosY <= this._underBarnsPosY)
			{
				this._waveOnBarns = true;
				dispatchEvent(new EventWithParams(GameEvents.ALIEN_WAVE_HIT_BARNS));
			}
			else if(wavePosY > this._underBarnsPosY)
			{
				dispatchEvent(new EventWithParams(GameEvents.GAME_OVER));
			}
		}
		
		private function onAlienShootBarn(e:EventWithParams) : void
		{
			var alien:Alien = e.params.alien;
			var targetBarn:Barn = e.params.barn;
			var targetPiece:MovieClip = e.params.piece;
			var projectilePosX:Number = e.params.posX;
			if(targetBarn.getPiecefromPosition(projectilePosX,true) == targetPiece)
			{
				targetBarn.destroyPiece(targetPiece);
				alien.terminateShoot();
			}
			else
			{
				alien.shootLaser(this._underBarnsPosY,true);
			}
		}
		
		private function onShootingLaser(e:EventWithParams) : void
		{
			dispatchEvent(e);
		}
		
		public function destroyAlien(alien:Alien) : void
		{
			if(alien)
			{
				this._alienWave.destroyAlien(alien);
				this.updateWaveSpeedInterval();
			}
		}
		
		private function startSpawnTimer() : void
		{
			var randomValue:int = MathUtil.random(0,100);
			if(randomValue < 50)
			{
				this.startMotherShipTimer(true);
			}
			else
			{
				this.startTractorBeamTimer(true);
			}
		}
		
		private function startMotherShipTimer(init:Boolean = false) : void
		{
			var duration:Number = !!init?Number(GameConstants.mothershipInitSpawnTimeInterval):Number(this.getMotherShipSpawnTimerInterval());
			eaze(this._assets.motherShipContainerMc).delay(duration).onComplete(this.spawnMotherShip);
		}
		
		private function stopMotherShipTimer() : void
		{
			eaze(this._assets.motherShipContainerMc).killTweens();
		}
		
		private function getMotherShipSpawnTimerInterval() : Number
		{
			return MathUtil.random(GameConstants.mothershipMinSpawnTimeInterval,GameConstants.mothershipMaxSpawnTimeInterval);
		}
		
		private function spawnMotherShip() : void
		{
			this._motherShip = new MotherShip(this._assets);
			this._motherShip.addEventListener(GameEvents.MOTHERSHIP_EXPLODED,this.onMotherShipExploded,false,0,true);
			var startPosX:Number = MathUtil.random(0,1) > 0?Number(-this._motherShip.width / 2):Number(GameConstants.STAGE_WIDTH + this._motherShip.width / 2);
			var endPosX:Number = startPosX > 0?Number(-this._motherShip.width / 2):Number(GameConstants.STAGE_WIDTH + this._motherShip.width / 2);
			var posY:Number = GameConstants.mothershipYPosition + this._motherShip.height;
			this._assets.motherShipContainerMc.addChild(this._motherShip);
			this._motherShip.x = startPosX;
			this._motherShip.y = posY;
			var duration:Number = Math.abs(endPosX - startPosX) / GameConstants.mothershipSpeed;
			eaze(this._motherShip).to(duration,{
				"x":endPosX,
				"y":posY
			}).easing(Linear.easeNone).onComplete(this.onMotherShipPassed);
			SoundManager.instance.startSound(SoundList.MOTHERSHIP_LOOP_SOUND_ID);
		}
		
		public function destroyMotherShip() : void
		{
			SoundManager.instance.stopSound(SoundList.MOTHERSHIP_LOOP_SOUND_ID);
			this._motherShip.destroy();
			eaze(this._motherShip).killTweens();
		}
		
		private function onMotherShipPassed() : void
		{
			SoundManager.instance.stopSound(SoundList.MOTHERSHIP_LOOP_SOUND_ID);
			this.deleteMotherShipReference();
			this.startTractorBeamTimer();
		}
		
		private function onMotherShipExploded(e:EventWithParams) : void
		{
			this._motherShip.removeEventListener(GameEvents.MOTHERSHIP_EXPLODED,this.onMotherShipExploded);
			this.deleteMotherShipReference();
			this.startTractorBeamTimer();
		}
		
		private function deleteMotherShipReference() : void
		{
			if(this._motherShip)
			{
				this._motherShip.dispose();
				if(this._assets.motherShipContainerMc.numChildren > 0)
				{
					this._assets.motherShipContainerMc.removeChild(this._motherShip);
				}
				this._motherShip = null;
			}
		}
		
		private function startTractorBeamTimer(init:Boolean = false) : void
		{
			var duration:Number = !!init?Number(GameConstants.alienUFOTractorInitSpawnTimeInterval):Number(this.getTractorBeamSpawnTimerInterval());
			eaze(this._tractorBeamTimerObject).delay(duration).onComplete(this.spawnTractorBeam);
		}
		
		private function stopTractorBeamTimer() : void
		{
			eaze(this._tractorBeamTimerObject).killTweens();
		}
		
		private function getTractorBeamSpawnTimerInterval() : Number
		{
			return MathUtil.random(GameConstants.alienUFOTractorMinSpawnTimeInterval,GameConstants.alienUFOTractorMaxSpawnTimeInterval);
		}
		
		private function spawnTractorBeam() : void
		{
			if(this._waveOnBarns || this._alienWave == null || this._alienWave.wavePosY > GameConstants.tractorBeamMinHeight || this._alienWave.activeAlienNum <= 1)
			{
				this.spawnMotherShip();
				return;
			}
			var alienUfo:Alien = this._alienWave.getRandomUfoTractor();
			if(alienUfo == null)
			{
				this.spawnMotherShip();
				return;
			}
			this._cow = new Cow(this._assets);
			this._cow.addEventListener(GameEvents.COW_EXPLODED,this.onCowExploded,false,0,true);
			this._cow.addEventListener(GameEvents.COW_ABDUCTED,this.onCowAbducted,false,0,true);
			this._cow.addEventListener(GameEvents.COW_ABDUCT,dispatchEvent,false,0,true);
			this._assets.cowContainerMc.addChild(this._cow);
			var alienPos:Point = FlashUtil.localToGlobalPosition(alienUfo);
			var cowPosX:Number = alienPos.x > GameConstants.STAGE_WIDTH / 2?Number(-this._cow.width / 2):Number(GameConstants.STAGE_WIDTH + this._cow.width / 2);
			this._cow.x = cowPosX;
			this._cow.y = this._underBarnsPosY - this._cow.heightValue / 2;
			alienUfo.startTractorBeam(this._assets.beamContainerMc,this._cow);
		}
		
		public function releaseCow() : void
		{
			this._cow.release();
			var duration:Number = (this._underBarnsPosY - (this._cow.y + this._cow.heightValue / 2)) / GameConstants.cowReleaseSpeed;
			eaze(this._cow).to(duration,{"y":this._underBarnsPosY - this._cow.heightValue / 2}).easing(Linear.easeNone).onComplete(this.onCowReleased);
		}
		
		private function deleteCowReference() : void
		{
			if(this._cow)
			{
				eaze(this._cow).killTweens();
				this._cow.removeEventListener(GameEvents.COW_EXPLODED,this.onCowExploded);
				this._cow.removeEventListener(GameEvents.COW_ABDUCTED,this.onCowAbducted);
				this._cow.removeEventListener(GameEvents.COW_ABDUCT,dispatchEvent);
				this._cow.dispose();
				if(this._assets.cowContainerMc.numChildren > 0)
				{
					this._assets.cowContainerMc.removeChild(this._cow);
				}
				this._cow = null;
			}
		}
		
		private function onCowReleased() : void
		{
			this._cow.run();
			var duration:Number = (this._cow.x - this._cow.width / 2) / GameConstants.cowRunSpeed;
			eaze(this._cow).to(duration,{"x":-this._cow.width / 2}).easing(Linear.easeNone).onComplete(this.onCowRanAway);
		}
		
		private function onCowRanAway() : void
		{
			this.deleteCowReference();
			this.startMotherShipTimer();
		}
		
		private function onCowExploded(e:EventWithParams) : void
		{
			this.deleteCowReference();
			this.startMotherShipTimer();
		}
		
		private function onCowAbducted(e:EventWithParams) : void
		{
			this.deleteCowReference();
			dispatchEvent(e);
			this.startMotherShipTimer();
		}
		
		public function pause(paused:Boolean) : void
		{
			var shooters:Vector.<Alien> = null;
			var shooter:Alien = null;
			var i:uint = 0;
			if(paused)
			{
				if(this._alienWave && this._alienWave.alienUfoTractor)
				{
					this._alienWave.alienUfoTractor.pauseTractorBeam();
				}
				if(this._motherShip)
				{
					this._motherShip.pauseAnimation();
				}
				if(this._alienWave)
				{
					shooters = this._alienWave.shooters.concat();
					for(i = 0; i < shooters.length; i++)
					{
						shooter = shooters[i];
						if(shooter.projectile)
						{
							shooter.projectile.pauseAnimation();
						}
					}
				}
			}
			else
			{
				if(this._alienWave && this._alienWave.alienUfoTractor)
				{
					this._alienWave.alienUfoTractor.resumeTractorBeam();
				}
				if(this._motherShip)
				{
					this._motherShip.resumeAnimation();
				}
				if(this._alienWave)
				{
					shooters = this._alienWave.shooters.concat();
					for(i = 0; i < shooters.length; i++)
					{
						shooter = shooters[i];
						if(shooter.projectile)
						{
							shooter.projectile.resumeAnimation();
						}
					}
				}
			}
		}
		
		public function dispose() : void
		{
			this.stop();
		}
	}
}
