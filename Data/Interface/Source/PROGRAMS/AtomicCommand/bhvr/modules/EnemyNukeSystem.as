package bhvr.modules
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.views.Nuke;
	import bhvr.views.Target;
	import bhvr.views.Bomber;
	import bhvr.views.Projectile;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import bhvr.debug.Log;
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.data.LevelUpVariables;
	import bhvr.constatnts.GameConstants;
	import bhvr.utils.MathUtil;
	import flash.geom.Point;
	import aze.motion.easing.Linear;
	
	public class EnemyNukeSystem extends EventDispatcher
	{
		 
		
		protected var _assets:MovieClip;
		
		protected var _nukeGenerator:bhvr.modules.NukeGenerator;
		
		protected var _availableNukes:Vector.<Nuke>;
		
		protected var _activeNukes:Vector.<Nuke>;
		
		protected var _activeTargets:Vector.<Target>;
		
		protected var _projectileNum:int;
		
		protected var _bomber:Bomber;
		
		protected var _nukeNum:Number;
		
		protected var _nukeInterval:Number;
		
		protected var _nukeSpeed:Number;
		
		protected var _bomberSpeed:Number;
		
		public function EnemyNukeSystem(assets:MovieClip)
		{
			super();
			this._assets = assets;
			this.initialize();
		}
		
		public function get nukeNumberRemaining() : int
		{
			return this._availableNukes.length;
		}
		
		protected function get noAttackRemaining() : Boolean
		{
			return this.nukeNumberRemaining == 0 && this._projectileNum == 0 && this._bomber.hasPassed;
		}
		
		public function get activeProjectiles() : Vector.<Projectile>
		{
			var projectiles:Vector.<Projectile> = null;
			projectiles = Vector.<Projectile>(this._activeNukes);
			if(this._bomber)
			{
				projectiles.push(Projectile(this._bomber));
			}
			return projectiles;
		}
		
		private function get nextNuke() : Nuke
		{
			var nuke:Nuke = this._availableNukes.pop();
			dispatchEvent(new EventWithParams(GameEvents.NUKE_FIRED,{"target":nuke}));
			return nuke;
		}
		
		public function initialize() : void
		{
			Log.info("Enemy Nuke System initialized");
		}
		
		public function setTargets(targets:Vector.<Target>) : void
		{
			this._activeTargets = targets;
		}
		
		public function start() : void
		{
			this.reset();
			this.attack();
		}
		
		public function stop() : void
		{
			var nuke:Nuke = null;
			if(this._availableNukes)
			{
				if(this.nukeNumberRemaining > 0)
				{
					eaze(this).killTweens();
					this._availableNukes.splice(0,this._availableNukes.length);
				}
			}
			if(this._activeNukes)
			{
				while(this._activeNukes.length > 0)
				{
					nuke = this._activeNukes[this._activeNukes.length - 1];
					eaze(nuke.projectileView).killTweens();
					this.deleteNukeReference(nuke);
				}
			}
			if(this._bomber)
			{
				if(!this._bomber.hasPassed)
				{
					SoundManager.instance.stopSound(SoundList.BOMBER_LOOP_SOUND_ID);
					eaze(this._bomber.projectileView).killTweens();
					this.deleteBomberReference();
				}
				this._bomber = null;
			}
		}
		
		public function reset() : void
		{
			this._nukeNum = LevelUpVariables.getStartingNukesNumber();
			this._nukeInterval = LevelUpVariables.getNukeTimerInterval();
			this._nukeSpeed = LevelUpVariables.getNukeSpeed();
			this._bomberSpeed = GameConstants.bomberSpeed;
			this._availableNukes = new Vector.<Nuke>();
			this._activeNukes = new Vector.<Nuke>();
			this._projectileNum = 0;
			if(this._activeTargets)
			{
				this._nukeGenerator = new bhvr.modules.NukeGenerator(this._assets,this._activeTargets,this._nukeNum,Math.floor(this._nukeNum * Math.min(Math.max(0,GameConstants.splitNukePercent),1)));
				this._availableNukes = this._nukeGenerator.getStartingNukes();
			}
			else
			{
				Log.error("EnemyNukeSystem: Need to set enemy targets!");
			}
			this._bomber = null;
		}
		
		public function terminate() : void
		{
			var nuke:Nuke = null;
			var time:Number = NaN;
			var totalTime:Number = NaN;
			var dropTime:Number = NaN;
			this._nukeInterval = Math.max(this._nukeInterval / 2,GameConstants.minNukeInterval);
			this._nukeSpeed = Math.min(2 * this._nukeSpeed,GameConstants.maxNukeSpeed);
			this._bomberSpeed = this._nukeSpeed;
			eaze(this).killTweens();
			for(var i:int = 0; i < this._activeNukes.length; i++)
			{
				nuke = this._activeNukes[i];
				eaze(nuke.projectileView).killTweens();
				if(nuke.collider)
				{
					time = MathUtil.getDistance(new Point(nuke.projectileView.x,nuke.projectileView.y),new Point(nuke.target.position.x,nuke.target.position.y)) / this._nukeSpeed;
					eaze(nuke.projectileView).to(time,{
						"x":nuke.target.position.x,
						"y":nuke.target.position.y
					}).easing(Linear.easeNone).onUpdate(this.onNukeMoving,nuke).onComplete(this.onFinalPositionReached,nuke);
				}
			}
			if(this._bomber && !this._bomber.hasPassed)
			{
				eaze(this._bomber.projectileView).killTweens();
				totalTime = Math.abs(this._bomber.targetPosition.x - this._bomber.projectileView.x) / this._bomberSpeed;
				dropTime = Math.abs(this._bomber.dropPosX - this._bomber.projectileView.x) / this._bomberSpeed;
				if(this._bomber.hasDroppedBomb)
				{
					eaze(this._bomber.projectileView).to(totalTime,{
						"x":this._bomber.targetPosition.x,
						"y":this._bomber.targetPosition.y
					}).easing(Linear.easeNone).onComplete(this.onBomberPassed);
				}
				else
				{
					eaze(this._bomber.projectileView).to(dropTime,{
						"x":this._bomber.dropPosX,
						"y":this._bomber.targetPosition.y
					}).easing(Linear.easeNone).onComplete(this.onDroppingBomb).to(totalTime - dropTime,{
						"x":this._bomber.targetPosition.x,
						"y":this._bomber.targetPosition.y
					}).easing(Linear.easeNone).onComplete(this.onBomberPassed);
				}
			}
			this.attack();
		}
		
		public function attack() : void
		{
			eaze(this).delay(this._nukeInterval).onComplete(this.onFireRequest);
		}
		
		public function playInitialSoundAttack() : void
		{
			SoundManager.instance.startLongSound(SoundList.ROUND_START_SOUND_ID);
		}
		
		private function onFireRequest() : void
		{
			var startPoint:Point = new Point(MathUtil.random(0,GameConstants.STAGE_WIDTH),GameConstants.GAME_AREA_TOP);
			if(this.nukeNumberRemaining > 0)
			{
				this.fireProjectile(this.nextNuke,startPoint);
				SoundManager.instance.playSound(SoundList.NUKE_FIRE_SOUND);
				if(this.nukeNumberRemaining < this._nukeNum * GameConstants.REMAINING_NUKE_PERCENT_TO_FIRE_BOMBER && this._bomber == null)
				{
					this.fireBomber();
				}
				if(this.nukeNumberRemaining > 0)
				{
					this.attack();
				}
				else
				{
					eaze(this).killTweens();
					dispatchEvent(new EventWithParams(GameEvents.NO_NUKE_REMAINING));
				}
			}
		}
		
		protected function fireProjectile(target:Nuke, startPoint:Point) : void
		{
			this._activeNukes.push(target);
			this._projectileNum++;
			var nuke:Nuke = target;
			nuke.addEventListener(GameEvents.NUKE_EXPLODED,this.onNukeExploded,false,0,true);
			nuke.addEventListener(GameEvents.NUKE_DESTROYED,this.onNukeDestroyed,false,0,true);
			var endPoint:Point = new Point(nuke.target.position.x,nuke.target.position.y);
			var distance:Number = MathUtil.getDistance(startPoint,endPoint);
			var time:Number = distance / this._nukeSpeed;
			var degreeAngle:Number = MathUtil.getVerticalDegAngle(startPoint,endPoint);
			nuke.setInitialProperties(startPoint,degreeAngle);
			this._assets.nukesContainerMc.addChild(nuke);
			eaze(nuke.projectileView).to(time,{
				"x":endPoint.x,
				"y":endPoint.y
			}).easing(Linear.easeNone).onUpdate(this.onNukeMoving,nuke).onComplete(this.onFinalPositionReached,nuke);
		}
		
		protected function fireBomber() : void
		{
			this._bomber = this._nukeGenerator.getBomber();
			this._bomber.addEventListener(GameEvents.BOMBER_DESTROYED,this.onBomberDestroyed,false,0,true);
			var startPosX:Number = MathUtil.random(0,1) > 0?Number(-this._bomber.widthValue):Number(GameConstants.STAGE_WIDTH + this._bomber.widthValue);
			var endPosX:Number = startPosX > 0?Number(-this._bomber.widthValue):Number(GameConstants.STAGE_WIDTH + this._bomber.widthValue);
			var posY:Number = MathUtil.random(GameConstants.STAGE_HEIGHT - GameConstants.bomberYMin,GameConstants.STAGE_HEIGHT - GameConstants.bomberYMax);
			var startPoint:Point = new Point(startPosX,posY);
			var endPoint:Point = new Point(endPosX,posY);
			this._bomber.setInitialProperties(startPoint);
			this._bomber.targetPosition = endPoint;
			this._assets.bomberContainerMc.addChild(this._bomber);
			var totalTime:Number = Math.abs(endPosX - startPosX) / this._bomberSpeed;
			var dropTime:Number = Math.abs(this._bomber.dropPosX - startPosX) / this._bomberSpeed;
			eaze(this._bomber.projectileView).to(dropTime,{
				"x":this._bomber.dropPosX,
				"y":endPoint.y
			}).easing(Linear.easeNone).onComplete(this.onDroppingBomb).to(totalTime - dropTime,{
				"x":endPoint.x,
				"y":endPoint.y
			}).easing(Linear.easeNone).onComplete(this.onBomberPassed);
			SoundManager.instance.startSound(SoundList.BOMBER_LOOP_SOUND_ID);
		}
		
		protected function onDroppingBomb() : void
		{
			var currentPos:Point = new Point(this._bomber.projectileView.x,this._bomber.projectileView.y);
			var nuke:Nuke = this._nukeGenerator.getSingleNuke(Projectile.NUKE_TYPE,true);
			nuke.splitHeight = GameConstants.clusterYMin;
			this.fireProjectile(nuke,currentPos);
			SoundManager.instance.playSound(SoundList.NUKE_FIRE_SOUND);
			this._bomber.hasDroppedBomb = true;
		}
		
		protected function onBomberPassed() : void
		{
			this._bomber.hasPassed = true;
			SoundManager.instance.stopSound(SoundList.BOMBER_LOOP_SOUND_ID);
			this.deleteBomberReference();
			if(this.noAttackRemaining)
			{
				dispatchEvent(new EventWithParams(GameEvents.END_OF_ATTACK));
			}
		}
		
		protected function onBomberDestroyed(e:EventWithParams) : void
		{
			this._bomber.hasPassed = true;
			SoundManager.instance.stopSound(SoundList.BOMBER_LOOP_SOUND_ID);
			this.deleteBomberReference();
			dispatchEvent(new EventWithParams(GameEvents.BOMBER_DESTROYED));
			if(this.noAttackRemaining)
			{
				dispatchEvent(new EventWithParams(GameEvents.END_OF_ATTACK));
			}
		}
		
		private function deleteBomberReference() : void
		{
			this._bomber.removeEventListener(GameEvents.BOMBER_DESTROYED,this.onBomberDestroyed);
			this._assets.bomberContainerMc.removeChild(this._bomber);
			this._bomber.dispose();
		}
		
		protected function onNukeMoving(target:Nuke) : void
		{
			var currentPos:Point = null;
			var cluster:Vector.<Nuke> = null;
			var i:uint = 0;
			if(target.projectileView)
			{
				currentPos = new Point(target.projectileView.x,target.projectileView.y);
				target.drawSmoke(currentPos);
				if(target.splitNum > 0 && currentPos.y > GameConstants.STAGE_HEIGHT - target.splitHeight)
				{
					cluster = this._nukeGenerator.getCluster(target,target.splitNum);
					for(i = 0; i < cluster.length; i++)
					{
						this.fireProjectile(cluster[i],currentPos);
					}
					this.splitNuke(target);
				}
			}
		}
		
		protected function onFinalPositionReached(target:Nuke) : void
		{
			if(target.type == Projectile.NUKE_SPLIT_TYPE)
			{
				target.parentRef.childActiveNum--;
			}
			if(target.projectileView)
			{
				target.explode();
			}
			target.target.destroy();
		}
		
		protected function splitNuke(target:Nuke) : void
		{
			eaze(target.projectileView).killTweens();
			target.split();
		}
		
		public function destroyNuke(target:Nuke) : void
		{
			eaze(target.projectileView).killTweens();
			if(target.type == Projectile.NUKE_SPLIT_TYPE)
			{
				target.parentRef.childActiveNum--;
			}
			target.destroy();
		}
		
		public function destroyBomber() : void
		{
			if(this._bomber)
			{
				eaze(this._bomber.projectileView).killTweens();
				this._bomber.destroy();
			}
		}
		
		protected function onNukeExploded(e:EventWithParams) : void
		{
			var target:Nuke = e.params.target;
			this.deleteNukeReference(target);
			if(this.noAttackRemaining)
			{
				dispatchEvent(new EventWithParams(GameEvents.END_OF_ATTACK));
			}
		}
		
		protected function onNukeDestroyed(e:EventWithParams) : void
		{
			var target:Nuke = e.params.target;
			this.deleteNukeReference(target);
			if(this.noAttackRemaining)
			{
				dispatchEvent(new EventWithParams(GameEvents.END_OF_ATTACK));
			}
		}
		
		private function deleteNukeReference(target:Nuke) : void
		{
			target.removeEventListener(GameEvents.NUKE_EXPLODED,this.onNukeExploded);
			target.removeEventListener(GameEvents.NUKE_DESTROYED,this.onNukeDestroyed);
			var layerId:int = this._assets.nukesContainerMc.getChildIndex(target);
			target.dispose();
			this._activeNukes.splice(layerId,1);
			this._projectileNum--;
			this._assets.nukesContainerMc.removeChild(target);
			target = null;
		}
		
		public function dispose() : void
		{
			this.stop();
			this._assets = null;
			if(this._nukeGenerator)
			{
				this._nukeGenerator.dispose();
				this._nukeGenerator = null;
			}
			this._availableNukes = null;
			this._activeNukes = null;
			this._bomber = null;
		}
	}
}
