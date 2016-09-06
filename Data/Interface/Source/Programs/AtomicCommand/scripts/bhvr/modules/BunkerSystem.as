package bhvr.modules
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.views.CustomCursor;
	import bhvr.views.Missile;
	import bhvr.views.Canon;
	import bhvr.views.Target;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import bhvr.constatnts.GameConstants;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.debug.Log;
	import flash.events.MouseEvent;
	import bhvr.manager.InputManager;
	import bhvr.constatnts.GameInputs;
	import aze.motion.eaze;
	import bhvr.views.Projectile;
	import bhvr.data.CursorType;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import bhvr.utils.MathUtil;
	import flash.events.Event;
	import aze.motion.easing.Linear;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	
	public class BunkerSystem extends EventDispatcher
	{
		 
		
		protected var _assets:MovieClip;
		
		protected var _cursor:CustomCursor;
		
		protected var _limitHeight:Number;
		
		protected var _availableMissiles:Vector.<Missile>;
		
		protected var _activeMissiles:Vector.<Missile>;
		
		protected var _targetCursor:CustomCursor;
		
		private var _canon:Canon;
		
		public function BunkerSystem(assets:MovieClip, cursor:CustomCursor)
		{
			super();
			this._assets = assets;
			this._cursor = cursor;
			this.initialize();
		}
		
		public function get canon() : Target
		{
			return this._canon;
		}
		
		private function get _canFire() : Boolean
		{
			return !this._canon.destroyed;
		}
		
		public function get missileNumberRemaining() : int
		{
			return this._availableMissiles.length;
		}
		
		private function get nexMissile() : Missile
		{
			var missile:Missile = this._availableMissiles.pop();
			dispatchEvent(new EventWithParams(GameEvents.MISSILE_FIRED,{"target":missile}));
			return missile;
		}
		
		public function initialize() : void
		{
			this._canon = new Canon(this._assets.canonMc);
			this._canon.addEventListener(GameEvents.CANON_DESTROYED,this.onCanonDestroyed,false,0,true);
			this._limitHeight = GameConstants.STAGE_HEIGHT - GameConstants.minHeightToFire;
			if(!CompanionAppMode.isOn)
			{
				this.createTargetCursor();
			}
			Log.info("Bunker System initialized");
		}
		
		public function start() : void
		{
			this.reset();
			this._assets.stage.addEventListener(MouseEvent.CLICK,this.onFireRequest,false,0,true);
			if(!CompanionAppMode.isOn)
			{
				this._assets.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove,false,0,true);
				InputManager.instance.addEventListener(GameInputs.FIRE,this.onFireRequest,false,0,true);
				InputManager.instance.addEventListener(GameInputs.LEFT_STICK_POS_UPDATE,this.onLeftStickMove,false,0,true);
				this._targetCursor.show(false);
				this.onCursorMove(this._cursor.getPosition().x,this._cursor.getPosition().y);
			}
		}
		
		public function stop() : void
		{
			var i:int = 0;
			this._assets.stage.removeEventListener(MouseEvent.CLICK,this.onFireRequest);
			if(!CompanionAppMode.isOn)
			{
				this._assets.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
				InputManager.instance.removeEventListener(GameInputs.FIRE,this.onFireRequest);
				InputManager.instance.removeEventListener(GameInputs.LEFT_STICK_POS_UPDATE,this.onLeftStickMove);
				this._targetCursor.hide(false);
			}
			if(this._availableMissiles)
			{
				if(this.missileNumberRemaining > 0)
				{
					this._availableMissiles.splice(0,this._availableMissiles.length);
				}
			}
			if(this._activeMissiles)
			{
				for(i = 0; i < this._activeMissiles.length; i++)
				{
					eaze(this._activeMissiles[i].projectileView).killTweens();
					this.deleteMissileReference(this._activeMissiles[i]);
				}
			}
		}
		
		public function reset() : void
		{
			this._availableMissiles = new Vector.<Missile>();
			this._activeMissiles = new Vector.<Missile>();
			for(var i:uint = 0; i < GameConstants.maxMissileNumber; i++)
			{
				this._availableMissiles[i] = new Missile(this._assets,Projectile.MISSILE_TYPE);
			}
			this._canon.reset();
		}
		
		protected function createTargetCursor() : void
		{
			this._targetCursor = new CustomCursor(this._assets.stage,this._assets,CursorType.CURSOR_TARGET);
			var cursorLayer:DisplayObjectContainer = this._cursor.parent;
			cursorLayer.addChild(this._targetCursor);
		}
		
		protected function onMouseMove(e:MouseEvent) : void
		{
			var posX:Number = e.stageX;
			var posY:Number = e.stageY;
			this.onCursorMove(posX,posY);
		}
		
		protected function onLeftStickMove(e:EventWithParams) : void
		{
			var cursorPosition:Point = this._cursor.getPosition();
			var posX:Number = Math.max(Math.min(cursorPosition.x + e.params.deltaX,GameConstants.STAGE_WIDTH),0);
			var posY:Number = Math.max(Math.min(cursorPosition.y + e.params.deltaY,GameConstants.STAGE_HEIGHT),0);
			this._cursor.setPosition(new Point(posX,posY));
			this.onCursorMove(posX,posY);
		}
		
		protected function onCursorMove(posX:Number, posY:Number) : void
		{
			var targetCursorPosX:Number = NaN;
			var targetCursorPosY:Number = NaN;
			var topLimit:Number = GameConstants.GAME_AREA_TOP + GameConstants.missileMaxRadius;
			if(posY < topLimit || posY > this._limitHeight || posX < 0 || posX > GameConstants.STAGE_WIDTH)
			{
				this._targetCursor.stopMoving();
				targetCursorPosX = Math.max(Math.min(posX,GameConstants.STAGE_WIDTH),0);
				targetCursorPosY = Math.max(Math.min(posY,this._limitHeight),topLimit);
				this._targetCursor.setPosition(new Point(targetCursorPosX,targetCursorPosY));
			}
			else
			{
				this._targetCursor.startMoving();
				this._targetCursor.setPosition(new Point(posX,posY));
			}
			var degreeAngle:Number = MathUtil.getVerticalDegAngle(this._canon.headPosition,this._targetCursor.getPosition());
			this._canon.rotate(degreeAngle);
		}
		
		protected function onCanonDestroyed(e:EventWithParams) : void
		{
			var target:Target = e.params.target as Target;
			if(this.missileNumberRemaining > 0)
			{
				this._availableMissiles.splice(0,this._availableMissiles.length);
				dispatchEvent(new EventWithParams(GameEvents.END_OF_DEFENSE));
			}
			dispatchEvent(new EventWithParams(GameEvents.CANON_DESTROYED,{"target":target}));
			if(this._targetCursor != null)
			{
				this._targetCursor.hide(false);
			}
			Log.info("Canon has been destroyed!");
		}
		
		protected function onFireRequest(e:Event) : void
		{
			var topLimit:Number = NaN;
			var degreeAngle:Number = NaN;
			var posX:Number = NaN;
			var posY:Number = NaN;
			if(CompanionAppMode.isOn && (isNaN(MouseEvent(e).stageX) || isNaN(MouseEvent(e).stageY)))
			{
				return;
			}
			var startPoint:Point = this._canon.headPosition;
			var endPoint:Point = !!CompanionAppMode.isOn?new Point(MouseEvent(e).stageX,MouseEvent(e).stageY):this._targetCursor.getPosition();
			if(CompanionAppMode.isOn)
			{
				topLimit = GameConstants.GAME_AREA_TOP + GameConstants.missileMaxRadius;
				if(endPoint.y < topLimit || endPoint.y > this._limitHeight || endPoint.x < 0 || endPoint.x > GameConstants.STAGE_WIDTH)
				{
					posX = endPoint.x;
					posY = endPoint.y;
					endPoint.x = Math.max(Math.min(posX,GameConstants.STAGE_WIDTH),0);
					endPoint.y = Math.max(Math.min(posY,this._limitHeight),topLimit);
				}
				degreeAngle = MathUtil.getVerticalDegAngle(this._canon.headPosition,endPoint);
				this._canon.rotate(degreeAngle);
			}
			if(this._canFire && this.missileNumberRemaining > 0)
			{
				this.fireProjectile(startPoint,endPoint);
				if(this.missileNumberRemaining == 0)
				{
					if(!CompanionAppMode.isOn)
					{
						this._targetCursor.hide(false);
					}
				}
			}
			else if(!CompanionAppMode.isOn)
			{
				eaze(this._cursor).to(0.1,{"tint":16711680}).to(0.1,{"tint":null});
			}
		}
		
		protected function fireProjectile(startPoint:Point, endPoint:Point) : void
		{
			var distance:Number = MathUtil.getDistance(startPoint,endPoint);
			var time:Number = distance / GameConstants.missileSpeed;
			var degreeAngle:Number = MathUtil.getVerticalDegAngle(startPoint,endPoint);
			this._activeMissiles.push(this.nexMissile);
			var projectile:Missile = this._activeMissiles[this._activeMissiles.length - 1];
			projectile.addEventListener(GameEvents.MISSILE_EXPLODING,this.onMissileExploding);
			projectile.addEventListener(GameEvents.MISSILE_EXPLODED,this.onMissileExploded);
			projectile.setInitialProperties(startPoint,degreeAngle);
			projectile.setTargetPosition(endPoint);
			this._assets.missilesContainerMc.addChild(projectile);
			eaze(projectile.projectileView).to(time,{
				"x":endPoint.x,
				"y":endPoint.y
			}).easing(Linear.easeNone).onUpdate(this.onMissileMoving,projectile).onComplete(this.onFinalPositionReached,projectile);
			SoundManager.instance.playSound(SoundList.MISSILE_FIRE_SOUND);
			if(this.missileNumberRemaining == 0)
			{
				dispatchEvent(new EventWithParams(GameEvents.NO_MISSILE_REMAINING));
			}
		}
		
		protected function onMissileMoving(projectile:Missile) : void
		{
			if(projectile)
			{
				projectile.drawSmoke(new Point(projectile.projectileView.x,projectile.projectileView.y));
			}
		}
		
		protected function onMissileExploding(e:EventWithParams) : void
		{
			dispatchEvent(e);
		}
		
		protected function onMissileExploded(e:EventWithParams) : void
		{
			var target:Missile = e.params.target;
			this.deleteMissileReference(target);
			if(this._availableMissiles && this._activeMissiles)
			{
				if(this.missileNumberRemaining == 0 && this._activeMissiles.length == 0)
				{
					dispatchEvent(new EventWithParams(GameEvents.END_OF_DEFENSE));
				}
			}
		}
		
		private function deleteMissileReference(target:Missile) : void
		{
			target.removeEventListener(GameEvents.MISSILE_EXPLODED,this.onMissileExploded);
			var layerId:int = this._assets.missilesContainerMc.getChildIndex(target);
			if(this._activeMissiles)
			{
				this._activeMissiles[layerId].dispose();
				this._activeMissiles.splice(layerId,1);
			}
			this._assets.missilesContainerMc.removeChild(target);
			target = null;
		}
		
		protected function onFinalPositionReached(projectile:Missile) : void
		{
			if(projectile.projectileView)
			{
				projectile.explode();
			}
		}
		
		public function pause() : void
		{
			this._assets.stage.removeEventListener(MouseEvent.CLICK,this.onFireRequest);
			if(!CompanionAppMode.isOn)
			{
				this._assets.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
				InputManager.instance.removeEventListener(GameInputs.FIRE,this.onFireRequest);
				InputManager.instance.removeEventListener(GameInputs.LEFT_STICK_POS_UPDATE,this.onLeftStickMove);
			}
		}
		
		public function resume() : void
		{
			this._assets.stage.addEventListener(MouseEvent.CLICK,this.onFireRequest,false,0,true);
			if(!CompanionAppMode.isOn)
			{
				this._assets.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove,false,0,true);
				InputManager.instance.addEventListener(GameInputs.FIRE,this.onFireRequest,false,0,true);
				InputManager.instance.addEventListener(GameInputs.LEFT_STICK_POS_UPDATE,this.onLeftStickMove,false,0,true);
			}
		}
		
		public function dispose() : void
		{
			this.stop();
			this._canon.removeEventListener(GameEvents.CANON_DESTROYED,this.onCanonDestroyed);
			this._availableMissiles = null;
			this._activeMissiles = null;
		}
	}
}
