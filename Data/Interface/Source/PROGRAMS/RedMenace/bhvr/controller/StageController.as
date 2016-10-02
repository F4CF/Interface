package bhvr.controller
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.views.Hero;
	import bhvr.views.Boss;
	import bhvr.views.InteractiveObject;
	import bhvr.views.Helmet;
	import bhvr.views.Ladder;
	import bhvr.views.Girder;
	import bhvr.views.ExtendableLadder;
	import flash.events.Event;
	import bhvr.manager.SoundManager;
	import bhvr.views.Character;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import bhvr.data.GamePersistantData;
	import bhvr.debug.Log;
	import bhvr.data.SoundList;
	import bhvr.views.Bomb;
	import flash.geom.Point;
	import bhvr.views.FlyingBomb;
	import bhvr.views.RollingBomb;
	
	public class StageController extends EventDispatcher
	{
		 
		
		private var stageObject:MovieClip;
		
		protected var _assets:MovieClip;
		
		protected var _helmetsNum:uint = 1;
		
		protected var _laddersNum:uint = 1;
		
		protected var _girdersNum:uint = 1;
		
		protected var _girl:MovieClip;
		
		protected var _hero:Hero;
		
		protected var _boss:Boss;
		
		protected var _winStageZone:InteractiveObject;
		
		protected var _helmets:Vector.<Helmet>;
		
		protected var _ladders:Vector.<Ladder>;
		
		protected var _currentLadder:Ladder;
		
		protected var _girders:Vector.<Girder>;
		
		protected var _currentGirder:Girder;
		
		protected var _currentMusic:uint;
		
		protected var _currentStageMusic:uint;
		
		public function StageController(assets:MovieClip)
		{
			super();
			this._assets = assets;
			this._assets.visible = true;
			this.stageObject = new MovieClip();
			this._girl = this._assets.girlMc;
			this.createInteractiveObjects();
			this._currentMusic = this._currentStageMusic;
		}
		
		public function get hero() : Hero
		{
			return this._hero;
		}
		
		public function get boss() : Boss
		{
			return this._boss;
		}
		
		protected function get isRetractingLadder() : Boolean
		{
			if(this._currentLadder == null)
			{
				return false;
			}
			return this._currentLadder is ExtendableLadder && ExtendableLadder(this._currentLadder).state == ExtendableLadder.RETRACTING_STATE;
		}
		
		public function get heroCanClimbUp() : Boolean
		{
			return this._hero && this._hero.canClimbUp;
		}
		
		public function get heroCanClimbDown() : Boolean
		{
			return this._hero && this._hero.canClimbDown;
		}
		
		public function get heroIsOnLadder() : Boolean
		{
			return this._hero && this._hero.isOnLadder;
		}
		
		public function start() : void
		{
			this.stageObject.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
			this._hero.start();
			this._boss.start();
			SoundManager.instance.startSound(this._currentStageMusic);
		}
		
		public function stop() : void
		{
			this.stageObject.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			this._hero.stop();
			this._boss.stop();
		}
		
		protected function onUpdate() : void
		{
			var wasOnLadder:Boolean = false;
			var couldClimbUp:Boolean = false;
			var couldClimbDown:Boolean = false;
			if(this._hero != null && this._hero.collider != null)
			{
				this._hero.update();
				this._boss.update();
				if(this._hero.colliderPoint != null)
				{
					wasOnLadder = this._hero.isOnLadder;
					couldClimbUp = this._hero.canClimbUp;
					couldClimbDown = this._hero.canClimbDown;
					if(this._hero.state != Character.JUMPING_STATE)
					{
						this.checkCollisionWithLadders();
					}
					this.checkCollisionWithGirders();
					if(wasOnLadder != this._hero.isOnLadder || couldClimbUp != this._hero.canClimbUp || couldClimbDown != this._hero.canClimbDown)
					{
						dispatchEvent(new EventWithParams(GameEvents.HERO_CLIMB_STATUS_UPDATE));
					}
				}
				if(!this._hero.hasPowerArmor)
				{
					this.checkCollisionWithHelmets();
				}
				if(GamePersistantData.stage != GamePersistantData.STAGE_1)
				{
					this.checkCollisionWithBoss();
				}
				if(GamePersistantData.stage != GamePersistantData.STAGE_3)
				{
					this.checkCollisionWithWinZone();
					this.checkCollisionWithBombs();
					if(this.hero.state == Character.JUMPING_STATE)
					{
						this.checkJumpOverBombs();
					}
				}
			}
		}
		
		protected function createInteractiveObjects() : void
		{
			this.createWinStageZone();
			this.createHero();
			this.createHelmets();
			this.createGirders();
			this.createLadders();
			this.createBoss();
		}
		
		protected function createWinStageZone() : void
		{
			if(this._assets.winStageZoneMc != null)
			{
				this._winStageZone = new InteractiveObject(this._assets.winStageZoneMc);
			}
		}
		
		protected function createHero() : void
		{
			this._hero = new Hero(this._assets.pipboyMc);
			this.addHeroListeners();
		}
		
		protected function addHeroListeners() : void
		{
			this._hero.addEventListener(GameEvents.HERO_DAMAGED,this.onHeroDamaged,false,0,true);
			this._hero.addEventListener(GameEvents.HERO_DEAD,dispatchEvent,false,0,true);
			this._hero.addEventListener(GameEvents.POWER_ARMOR_START,this.onPowerArmorStart,false,0,true);
			this._hero.addEventListener(GameEvents.POWER_ARMOR_END,this.onPowerArmorEnd,false,0,true);
		}
		
		protected function removeHeroListeners() : void
		{
			this._hero.removeEventListener(GameEvents.HERO_DAMAGED,this.onHeroDamaged);
			this._hero.removeEventListener(GameEvents.HERO_DEAD,dispatchEvent);
			this._hero.removeEventListener(GameEvents.POWER_ARMOR_START,this.onPowerArmorStart);
			this._hero.removeEventListener(GameEvents.POWER_ARMOR_END,this.onPowerArmorEnd);
		}
		
		protected function createBoss() : void
		{
			this._boss = new Boss(this._assets.bossMc,this._assets.bombsContainerMc,this._ladders,this._girders);
			this.addBossListeners();
		}
		
		protected function addBossListeners() : void
		{
			this._boss.addEventListener(GameEvents.BOSS_LOST_STAGE,dispatchEvent,false,0,true);
			this._boss.addEventListener(GameEvents.GIRL_TELEPORTED,this.onGirlTeleported,false,0,true);
		}
		
		protected function removeBossListeners() : void
		{
			this._boss.removeEventListener(GameEvents.BOSS_LOST_STAGE,dispatchEvent);
			this._boss.removeEventListener(GameEvents.GIRL_TELEPORTED,this.onGirlTeleported);
		}
		
		protected function createHelmets() : void
		{
			var helmetMc:MovieClip = null;
			var helmet:Helmet = null;
			this._helmets = new Vector.<Helmet>();
			for(var i:uint = 0; i < this._helmetsNum; i++)
			{
				helmetMc = this._assets["helmet" + i];
				if(helmetMc)
				{
					helmet = new Helmet(helmetMc);
					this._helmets.push(helmet);
				}
				else
				{
					Log.warn("Helmet MovieClip named \'helmet" + i + "\' doesn\'t exist on Flash stage");
				}
			}
		}
		
		protected function createLadders() : void
		{
			var ladderMc:MovieClip = null;
			var ladder:Ladder = null;
			this._ladders = new Vector.<Ladder>();
			for(var i:uint = 0; i < this._laddersNum; i++)
			{
				ladderMc = this._assets["ladder" + i];
				if(ladderMc)
				{
					ladder = new Ladder(ladderMc);
					this._ladders.push(ladder);
				}
				else
				{
					Log.warn("Ladder MovieClip named \'ladder" + i + "\' doesn\'t exist on Flash stage");
				}
			}
		}
		
		protected function createGirders() : void
		{
			var girderMc:MovieClip = null;
			var girder:Girder = null;
			this._girders = new Vector.<Girder>();
			for(var i:uint = 0; i < this._girdersNum; i++)
			{
				girderMc = this._assets["girder" + i];
				if(girderMc)
				{
					girder = new Girder(this._assets["girder" + i]);
					this._girders.push(girder);
				}
				else
				{
					Log.warn("Girder MovieClip named \'girder" + i + "\' doesn\'t exist on Flash stage");
				}
			}
		}
		
		public function startMusic(musicId:uint) : void
		{
			if(this._currentMusic != musicId)
			{
				if(this._currentMusic == this._currentStageMusic && (musicId == SoundList.POWER_ARMOR_MUSIC_LOOP_SOUND_ID || musicId == SoundList.LOSE_MUSIC_LOOP_SOUND_ID))
				{
					this.stopMusic(this._currentStageMusic);
				}
				SoundManager.instance.startSound(musicId);
				this._currentMusic = musicId;
			}
		}
		
		public function stopMusic(musicId:uint) : void
		{
			if(this._currentMusic == musicId)
			{
				SoundManager.instance.stopSound(musicId);
				if(musicId == SoundList.POWER_ARMOR_MUSIC_LOOP_SOUND_ID || musicId == SoundList.LOSE_MUSIC_LOOP_SOUND_ID)
				{
					this.startMusic(this._currentStageMusic);
				}
			}
		}
		
		protected function checkCollisionWithWinZone() : void
		{
			if(this._winStageZone != null && this._winStageZone.collider != null)
			{
				if(MovieClip(this._winStageZone.collider).hitTestObject(this._hero.collider))
				{
					this._winStageZone.destroy();
					this.endStage();
					dispatchEvent(new EventWithParams(GameEvents.HERO_WIN));
				}
			}
		}
		
		protected function checkCollisionWithBoss() : void
		{
			if(this._boss != null && this._boss.collider != null)
			{
				if(this._boss.collider.hitTestObject(this._hero.collider))
				{
					if(!this._hero.invincible)
					{
						this.damageHero();
					}
				}
			}
		}
		
		protected function checkCollisionWithHelmets() : void
		{
			var helmet:Helmet = null;
			var i:uint = 0;
			if(this._helmets != null && this._helmets.length > 0)
			{
				for(i = 0; i < this._helmets.length; i++)
				{
					helmet = this._helmets[i];
					if(MovieClip(helmet.collider).hitTestObject(this._hero.collider))
					{
						helmet.collect();
						this._hero.collectPowerArmor();
						this._helmets.splice(i,1);
						return;
					}
				}
			}
		}
		
		protected function checkCollisionWithGirders() : void
		{
			var girder:Girder = null;
			var i:uint = 0;
			if(this._currentGirder != null)
			{
				if(this._currentGirder.collider.hitTestPoint(this._hero.colliderPoint.x,this._hero.colliderPoint.y,true))
				{
					this._hero.speedModifier = this._currentGirder.speed;
					if(!this._hero.isOnLadder)
					{
						this._hero.setPosition(this._hero.position.x,this._currentGirder.getYFromX(this._hero.position.x));
					}
				}
				else
				{
					this._currentGirder = null;
					this._hero.speedModifier = 0;
				}
				return;
			}
			if(this._girders != null && this._girders.length > 0)
			{
				for(i = 0; i < this._girders.length; i++)
				{
					girder = this._girders[i];
					if(girder.collider.hitTestPoint(this._hero.colliderPoint.x,this._hero.colliderPoint.y,true))
					{
						this._currentGirder = girder;
						this._hero.speedModifier = this._currentGirder.speed;
						if(!this._hero.isOnLadder)
						{
							this._hero.setPosition(this._hero.position.x,this._currentGirder.getYFromX(this._hero.position.x));
							if(this._hero.state == Character.JUMPING_STATE || this._hero.state == Character.FALLING_STATE)
							{
								this._hero.land();
							}
						}
						return;
					}
				}
				if(this._hero.state != Character.JUMPING_STATE && !this._hero.isOnLadder)
				{
					this._hero.fall();
				}
			}
		}
		
		protected function checkCollisionWithLadders() : void
		{
			var ladder:Ladder = null;
			var i:uint = 0;
			if(this._currentLadder != null)
			{
				if(this._currentLadder.collider.hitTestPoint(this._hero.colliderPoint.x,this._hero.colliderPoint.y))
				{
					this.handleClimb();
				}
				else
				{
					this._hero.canClimb = false;
					this._hero.canRun = true;
					this._hero.canJump = true;
					this._currentLadder = null;
				}
			}
			else if(this._ladders != null && this._ladders.length > 0)
			{
				for(i = 0; i < this._ladders.length; i++)
				{
					ladder = this._ladders[i];
					if(ladder.collider && ladder.collider.hitTestPoint(this._hero.colliderPoint.x,this._hero.colliderPoint.y))
					{
						this._currentLadder = ladder;
						this.handleClimb();
					}
				}
			}
		}
		
		protected function handleClimb() : void
		{
			if(this._hero.position.y <= this._currentLadder.topPosition)
			{
				this._hero.canClimbUp = false;
				this._hero.canClimbDown = true;
				if(this._currentGirder != null)
				{
					this._hero.canRun = true;
					this._hero.canJump = true;
					if(this._hero.isOnLadder && this._hero.direction == Character.UP_DIRECTION && !this.isRetractingLadder)
					{
						this._hero.finishClimbing();
					}
				}
				if(this._hero.isOnLadder && this.isRetractingLadder)
				{
					this._hero.setPosition(this._currentLadder.snapPosition,this._currentLadder.topPosition);
				}
			}
			else if(this._hero.position.y >= this._currentLadder.bottomPosition)
			{
				this._hero.canClimbDown = false;
				this._hero.canClimbUp = true;
				if(this._currentGirder != null)
				{
					this._hero.canRun = true;
					this._hero.canJump = true;
					if(this._hero.isOnLadder && this._hero.direction == Character.DOWN_DIRECTION)
					{
						this._hero.finishClimbing();
					}
				}
			}
			else if(this._hero.isOnLadder)
			{
				this._hero.canClimbDown = true;
				this._hero.canClimbUp = true;
				this._hero.canRun = false;
				this._hero.canJump = false;
				this._hero.setPosition(this._currentLadder.snapPosition,this._hero.position.y);
			}
			else
			{
				this._hero.canClimbDown = Math.abs(this._hero.position.y - this._currentLadder.topPosition) < Math.abs(this._hero.position.y - this._currentLadder.bottomPosition);
				this._hero.canClimbUp = !this._hero.canClimbDown;
			}
		}
		
		protected function checkCollisionWithBombs() : void
		{
			var bomb:Bomb = null;
			var i:uint = 0;
			var collisionPoints:Vector.<Point> = null;
			var pt:Point = null;
			var j:uint = 0;
			var bombs:Vector.<Bomb> = this._boss.activeBombs;
			if(bombs != null && bombs.length > 0)
			{
				for(i = 0; i < bombs.length; i++)
				{
					bomb = bombs[i];
					if(bomb is FlyingBomb)
					{
						collisionPoints = FlyingBomb(bomb).collisionPoints;
						if(bomb.collider && collisionPoints != null)
						{
							for(j = 0; j < collisionPoints.length; j++)
							{
								pt = collisionPoints[j];
								pt = bomb.collider.localToGlobal(pt);
								if(this._hero.colliderShape.hitTestPoint(pt.x,pt.y,true))
								{
									this.handleBombExplosion(bomb);
									break;
								}
							}
						}
					}
					else if(bomb.collider && bomb.collider.hitTestObject(this._hero.collider))
					{
						this.handleBombExplosion(bomb);
					}
				}
			}
		}
		
		private function handleBombExplosion(bomb:Bomb) : void
		{
			this._boss.explodeBomb(bomb);
			if(!this._hero.invincible)
			{
				this.damageHero();
			}
			else
			{
				dispatchEvent(new EventWithParams(GameEvents.BOMB_BONUS,{"target":bomb}));
			}
		}
		
		protected function checkJumpOverBombs() : void
		{
			var bomb:RollingBomb = null;
			var i:uint = 0;
			var bombs:Vector.<RollingBomb> = this._boss.activeRollingBombs;
			if(bombs != null && bombs.length > 0)
			{
				for(i = 0; i < bombs.length; i++)
				{
					bomb = bombs[i];
					if(bomb.jumpOverCollider)
					{
						if(!bomb.hasJumper)
						{
							if(bomb.jumpOverCollider.hitTestObject(this._hero.collider))
							{
								bomb.hasJumper = true;
							}
						}
						else if(!bomb.jumpOverCollider.hitTestObject(this._hero.collider))
						{
							dispatchEvent(new EventWithParams(GameEvents.BOMB_BONUS,{"target":bomb}));
							bomb.hasJumper = false;
						}
					}
				}
			}
		}
		
		protected function damageHero() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.HERO_DAMAGED));
			this._hero.damage();
			this._boss.stop();
		}
		
		protected function endStage() : void
		{
			this._hero.win(this._girl);
			this._boss.lose();
			this.stopMusic(this._currentMusic);
			SoundManager.instance.playSound(SoundList.WIN_STAGE_SOUND);
		}
		
		public function setTimeOver() : void
		{
			this.damageHero();
		}
		
		protected function onHeroDamaged(e:EventWithParams) : void
		{
			dispatchEvent(new EventWithParams(GameEvents.STAGE_RESET));
			this._boss.start();
			this._hero.start();
			this.createHelmets();
			this.stopMusic(SoundList.LOSE_MUSIC_LOOP_SOUND_ID);
		}
		
		protected function onPowerArmorStart(e:EventWithParams) : void
		{
			this.startMusic(SoundList.POWER_ARMOR_MUSIC_LOOP_SOUND_ID);
		}
		
		protected function onPowerArmorEnd(e:EventWithParams) : void
		{
			this.stopMusic(SoundList.POWER_ARMOR_MUSIC_LOOP_SOUND_ID);
		}
		
		protected function onGirlTeleported(e:EventWithParams) : void
		{
			this._girl.visible = false;
		}
		
		public function pause() : void
		{
			var i:uint = 0;
			this.stageObject.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			for(i = 0; i < this._helmets.length; i++)
			{
				this._helmets[i].pause();
			}
			for(i = 0; i < this._girders.length; i++)
			{
				this._girders[i].pause();
			}
			for(i = 0; i < this._ladders.length; i++)
			{
				this._ladders[i].pause();
			}
			if(this._hero)
			{
				this.removeHeroListeners();
				this._hero.pause();
			}
			if(this._boss)
			{
				this.removeBossListeners();
				this._boss.pause();
			}
			this._girl.stop();
		}
		
		public function resume() : void
		{
			var i:uint = 0;
			this.stageObject.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
			for(i = 0; i < this._helmets.length; i++)
			{
				this._helmets[i].resume();
			}
			for(i = 0; i < this._girders.length; i++)
			{
				this._girders[i].resume();
			}
			for(i = 0; i < this._ladders.length; i++)
			{
				this._ladders[i].resume();
			}
			if(this._hero)
			{
				this.addHeroListeners();
				this._hero.resume();
			}
			if(this._boss)
			{
				this.addBossListeners();
				this._boss.resume();
			}
			this._girl.play();
		}
		
		public function dispose() : void
		{
			var i:uint = 0;
			this.stop();
			SoundManager.instance.stopSound(this._currentMusic);
			this._girl.visible = true;
			this._girl = null;
			this.removeHeroListeners();
			this._hero.dispose();
			this._hero = null;
			this.removeBossListeners();
			this._boss.dispose();
			this._boss = null;
			if(this._winStageZone != null)
			{
				this._winStageZone.dispose();
				this._winStageZone = null;
			}
			if(this._helmets != null)
			{
				for(i = 0; i < this._helmets.length; i++)
				{
					this._helmets[i].dispose();
					this._helmets[i] = null;
				}
				this._helmets = null;
			}
			if(this._ladders != null)
			{
				for(i = 0; i < this._ladders.length; i++)
				{
					this._ladders[i].dispose();
					this._ladders[i] = null;
				}
				this._ladders = null;
			}
			if(this._girders != null)
			{
				for(i = 0; i < this._girders.length; i++)
				{
					this._girders[i].dispose();
					this._girders[i] = null;
				}
				this._girders = null;
			}
			this.stageObject = null;
		}
	}
}
