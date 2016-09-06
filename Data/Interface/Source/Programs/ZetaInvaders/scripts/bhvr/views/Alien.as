package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.modules.AlienColumn;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	import bhvr.constatnts.GameConstants;
	import aze.motion.easing.Linear;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.events.Event;
	import bhvr.utils.MathUtil;
	
	public class Alien extends Target
	{
		
		public static const ALIEN_1_TYPE:String = "Alien1Mc";
		
		public static const ALIEN_2_TYPE:String = "Alien2Mc";
		
		public static const ALIEN_UFO_TYPE:String = "AlienUFOMc";
		 
		
		private const BEAM_LINKAGE_ID:String = "BeamMc";
		
		private var _projectileContainer:MovieClip;
		
		private var _beamContainer:MovieClip;
		
		private var _projectile:bhvr.views.AlienProjectile;
		
		private var _parentColumn:AlienColumn;
		
		private var _currentCowAbducted:bhvr.views.Cow;
		
		private var _beamMc:MovieClip;
		
		private var _beamHeight:Number;
		
		private var _moveState:uint;
		
		private const STEP_1_STATE:uint = 0;
		
		private const STEP_2_STATE:uint = 1;
		
		public function Alien(flashAssets:MovieClip, linkageId:String)
		{
			super(flashAssets,linkageId);
			this._projectileContainer = flashAssets;
			_collider = _container.alienViewMc;
			this._moveState = this.STEP_1_STATE;
			this._currentCowAbducted = null;
		}
		
		public function get projectile() : bhvr.views.AlienProjectile
		{
			return this._projectile;
		}
		
		public function get parentColumn() : AlienColumn
		{
			return this._parentColumn;
		}
		
		public function set parentColumn(value:AlienColumn) : void
		{
			this._parentColumn = value;
		}
		
		public function get hasTractorBeam() : Boolean
		{
			return type == ALIEN_UFO_TYPE && this._beamMc != null;
		}
		
		public function move() : void
		{
			if(_collider)
			{
				this._moveState = (this._moveState + 1) % 2;
				_container.alienViewMc.gotoAndPlay("anim" + this._moveState);
			}
		}
		
		public function terminateShoot() : void
		{
			if(this._projectile)
			{
				eaze(this._projectile).killTweens();
				this.removeProjectile();
				this._projectile = null;
				if(!_collider)
				{
					dispatchEvent(new EventWithParams(GameEvents.ALIEN_EXPLODED,{"target":this}));
				}
			}
		}
		
		public function shootBarn(barn:Barn, barnPiece:MovieClip) : void
		{
			var piecePos:Point = null;
			var distance:Number = NaN;
			var speed:Number = NaN;
			var duration:Number = NaN;
			if(_collider)
			{
				this._projectile = new bhvr.views.AlienProjectile(this._projectileContainer);
				this.addProjectile();
				piecePos = FlashUtil.localToGlobalPosition(barnPiece);
				distance = piecePos.y - this._projectile.y;
				speed = this._projectile.type == AlienProjectile.PROJECTILE_SLOW_TYPE?Number(GameConstants.alienSlowProjectileSpeed):Number(GameConstants.alienFastProjectileSpeed);
				duration = distance / speed;
				eaze(this._projectile).to(duration,{"y":piecePos.y}).easing(Linear.easeNone).onComplete(this.onBarnReached,this,barn,barnPiece);
				SoundManager.instance.playSound(SoundList.ALIEN_FIRE_SOUND);
			}
		}
		
		public function shootLaser(underBarnsPosY:Number, continueShooting:Boolean = false) : void
		{
			if(_collider == null && !continueShooting)
			{
				return;
			}
			if(!continueShooting)
			{
				this._projectile = new bhvr.views.AlienProjectile(this._projectileContainer);
				this.addProjectile();
				SoundManager.instance.playSound(SoundList.ALIEN_FIRE_SOUND);
			}
			var distanceAlienToBarn:Number = underBarnsPosY - this._projectile.y;
			var distanceBarnToLaser:Number = GameConstants.STAGE_HEIGHT - underBarnsPosY;
			var speed:Number = this._projectile.type == AlienProjectile.PROJECTILE_SLOW_TYPE?Number(GameConstants.alienSlowProjectileSpeed):Number(GameConstants.alienFastProjectileSpeed);
			var durationAlienToBarn:Number = distanceAlienToBarn / speed;
			var durationBarnToLaser:Number = distanceBarnToLaser / speed;
			if(continueShooting)
			{
				eaze(this._projectile).to(durationBarnToLaser,{"y":GameConstants.STAGE_HEIGHT}).easing(Linear.easeNone).onUpdate(this.onLaserCollisionDetection,this._projectile).onComplete(this.onShootFail);
			}
			else
			{
				eaze(this._projectile).to(durationAlienToBarn,{"y":underBarnsPosY}).easing(Linear.easeNone).to(durationBarnToLaser,{"y":GameConstants.STAGE_HEIGHT}).onUpdate(this.onLaserCollisionDetection,this._projectile).easing(Linear.easeNone).onComplete(this.onShootFail);
			}
		}
		
		private function onBarnReached(alien:Alien, barn:Barn, barnPiece:MovieClip) : void
		{
			dispatchEvent(new EventWithParams(GameEvents.ALIEN_SHOOT_BARN,{
				"alien":alien,
				"barn":barn,
				"piece":barnPiece,
				"posX":this._projectile.x
			}));
		}
		
		private function onLaserCollisionDetection(target:bhvr.views.AlienProjectile) : void
		{
			dispatchEvent(new EventWithParams(GameEvents.ALIEN_SHOOTING_LASER,{"alien":this}));
		}
		
		private function onShootFail() : void
		{
			this.terminateShoot();
		}
		
		private function addProjectile() : void
		{
			this._projectileContainer.addChild(this._projectile);
			var pt:Point = FlashUtil.localToGlobalPosition(_container);
			this._projectile.x = pt.x;
			this._projectile.y = pt.y;
		}
		
		private function removeProjectile() : void
		{
			if(this._projectileContainer.numChildren > 0 && this._projectile != null)
			{
				this._projectileContainer.removeChild(this._projectile);
			}
		}
		
		override public function destroy() : void
		{
			super.destroy();
			if(this.hasTractorBeam)
			{
				this.closeTractorBeam();
			}
			_container.alienViewMc.visible = false;
			eaze(_container.explosionMc).play("start>end").onComplete(this.onAlienDestroyed);
			this.playExplosionSound();
		}
		
		private function playExplosionSound() : void
		{
			var eventName:String = null;
			switch(_type)
			{
				case ALIEN_1_TYPE:
					eventName = SoundList.ALIEN_TYPE1_EXPLOSION_SOUND;
					break;
				case ALIEN_2_TYPE:
					eventName = SoundList.ALIEN_TYPE2_EXPLOSION_SOUND;
					break;
				case ALIEN_UFO_TYPE:
					eventName = SoundList.ALIEN_TYPE2_EXPLOSION_SOUND;
			}
			SoundManager.instance.playSound(eventName);
		}
		
		private function onAlienDestroyed() : void
		{
			if(!this.projectile)
			{
				dispatchEvent(new EventWithParams(GameEvents.ALIEN_EXPLODED,{"target":this}));
			}
		}
		
		public function startTractorBeam(beamContainer:MovieClip, cow:bhvr.views.Cow) : void
		{
			this._beamContainer = beamContainer;
			this._beamMc = FlashUtil.getLibraryItem(this._projectileContainer,this.BEAM_LINKAGE_ID) as MovieClip;
			this._beamContainer.addChild(this._beamMc);
			this._beamHeight = this._beamMc.height;
			this._currentCowAbducted = cow;
			this._currentCowAbducted.fly(true);
			this.openTractorBeam();
			this.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
		}
		
		private function onBeamIntroEnd() : void
		{
			this._beamMc.gotoAndPlay("loop");
			SoundManager.instance.startSound(SoundList.TRACTOR_BEAM_LOOP_SOUND_ID);
			SoundManager.instance.playSound(SoundList.COW_ABDUCTION_SOUND);
		}
		
		private function openTractorBeam() : void
		{
			eaze(this._beamMc).play("introStart>introEnd").onComplete(this.onBeamIntroEnd);
		}
		
		public function closeTractorBeam() : void
		{
			this.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			this._currentCowAbducted = null;
			eaze(this._beamMc).play("outroStart>outroEnd").onComplete(this.removeBeam);
		}
		
		public function stopTractorBeam() : void
		{
			this._currentCowAbducted = null;
		}
		
		public function pauseTractorBeam() : void
		{
			if(this._beamMc)
			{
				this.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
				this._beamMc.stop();
			}
			if(this._currentCowAbducted)
			{
				this._currentCowAbducted.fly(false);
			}
		}
		
		public function resumeTractorBeam() : void
		{
			if(this._beamMc)
			{
				this.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
				this._beamMc.play();
			}
			if(this._currentCowAbducted)
			{
				this._currentCowAbducted.fly(true);
			}
		}
		
		private function onUpdate(e:Event) : void
		{
			var ufoPos:Point = null;
			var cowPos:Point = null;
			var dir:int = 0;
			var cowPosY:Number = NaN;
			var cowPosX:Number = NaN;
			var distance:Number = NaN;
			var scaleFactor:Number = NaN;
			var angle:Number = NaN;
			if(this._currentCowAbducted)
			{
				ufoPos = new Point(_container.alienViewMc.x,_container.alienViewMc.y);
				ufoPos = _container.parent.localToGlobal(ufoPos);
				cowPos = new Point(this._currentCowAbducted.x,this._currentCowAbducted.y);
				if(cowPos.y - GameConstants.tractorBeamSpeed <= ufoPos.y + this._currentCowAbducted.height / 2)
				{
					this._currentCowAbducted.x = ufoPos.x;
					this._currentCowAbducted.y = ufoPos.y;
					this._currentCowAbducted.abduct();
					this.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
					this.removeBeam();
					return;
				}
				this._beamMc.x = ufoPos.x;
				this._beamMc.y = ufoPos.y;
				dir = ufoPos.x > cowPos.x?int(-1):int(1);
				cowPosY = cowPos.y - GameConstants.tractorBeamSpeed;
				cowPosX = cowPos.x + dir * GameConstants.tractorBeamSpeed * Math.tan(MathUtil.getVerticalRadAngle(cowPos,ufoPos));
				this._currentCowAbducted.x = cowPosX;
				this._currentCowAbducted.y = cowPosY;
				distance = MathUtil.getDistance(cowPos,ufoPos);
				scaleFactor = distance / this._beamHeight;
				angle = MathUtil.getVerticalDegAngle(cowPos,ufoPos);
				this._beamMc.scaleX = scaleFactor;
				this._beamMc.scaleY = scaleFactor;
				this._beamMc.rotation = angle;
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			}
		}
		
		public function removeBeam() : void
		{
			if(this._beamContainer.numChildren > 0 && this._beamMc != null)
			{
				SoundManager.instance.stopSound(SoundList.TRACTOR_BEAM_LOOP_SOUND_ID);
				eaze(this._beamMc).killTweens();
				this._beamContainer.removeChild(this._beamMc);
				this._beamMc = null;
			}
			this.stopTractorBeam();
		}
		
		override public function dispose() : void
		{
			this.removeProjectile();
			if(this.hasTractorBeam)
			{
				this.removeBeam();
			}
			super.dispose();
		}
	}
}
