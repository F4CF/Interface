package bhvr.modules
{
	import flash.events.EventDispatcher;
	import bhvr.interfaces.IGameSystem;
	import flash.display.MovieClip;
	import bhvr.views.Laser;
	import bhvr.events.GameEvents;
	import bhvr.debug.Log;
	import flash.geom.Point;
	import bhvr.constatnts.GameConstants;
	import flash.events.Event;
	import bhvr.manager.InputManager;
	import bhvr.constatnts.GameInputs;
	import bhvr.events.EventWithParams;
	import flash.ui.Keyboard;
	import bhvr.views.Barn;
	import bhvr.data.GamePersistantData;
	import aze.motion.eaze;
	
	public class DefenseSystem extends EventDispatcher implements IGameSystem
	{
		 
		
		private var _assets:MovieClip;
		
		private var _laser:Laser;
		
		private var _barnController:bhvr.modules.BarnController;
		
		private var _laserDirection:int;
		
		private const LEFT_DIRECTION:int = -1;
		
		private const RIGHT_DIRECTION:int = 1;
		
		private const NO_DIRECTION:int = 0;
		
		private var _fireRequest:Boolean;
		
		private const DELAY_BEFORE_RESPAWN:Number = 0.5;
		
		public function DefenseSystem(assets:MovieClip)
		{
			super();
			this._assets = assets;
			this.initialize();
		}
		
		public function get laser() : Laser
		{
			return this._laser;
		}
		
		public function get barnController() : bhvr.modules.BarnController
		{
			return this._barnController;
		}
		
		public function initialize() : void
		{
			this._laser = new Laser(this._assets.laserMc,this._assets.projectileContainerMc);
			this._laser.addEventListener(GameEvents.LASER_DESTROYED,this.onLaserDestroyed,false,0,true);
			this._laser.addEventListener(GameEvents.LASER_RESPAWNED,this.onLaserRespawned,false,0,true);
			this._barnController = new bhvr.modules.BarnController(this._assets);
			Log.info("Defense System initialized");
		}
		
		public function start() : void
		{
			this.reset();
			this.addGameEventListeners();
			this.addInputListeners();
		}
		
		public function stop() : void
		{
			this._laser.terminateShoot();
			this.removeGameEventListeners();
			this.removeInputListeners();
		}
		
		public function freeze() : void
		{
			this.removeGameEventListeners();
			this._laser.terminateShoot();
		}
		
		public function unfreeze() : void
		{
			this.addGameEventListeners();
		}
		
		private function reset() : void
		{
			this._barnController.reset();
			this._laser.reset();
			this._laser.position = new Point(GameConstants.GAME_ZONE_AREA.x + GameConstants.GAME_ZONE_AREA.width / 2,GameConstants.GAME_ZONE_AREA.y + GameConstants.GAME_ZONE_AREA.height - this._laser.height);
			this._laserDirection = this.NO_DIRECTION;
			this._fireRequest = false;
		}
		
		private function addGameEventListeners() : void
		{
			this._assets.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
			this._laser.addEventListener(GameEvents.LASER_SHOOT_BARN,this.onLaserShootBarn,false,0,true);
			this._laser.addEventListener(GameEvents.LASER_SHOOTING_ALIENS,this.onLaserShooting,false,0,true);
		}
		
		private function addInputListeners() : void
		{
			InputManager.instance.addEventListener(GameInputs.MOVE_LEFT,this.onMoveLeft,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_RIGHT,this.onMoveRight,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_MOVE,this.onMoveStop,false,0,true);
			InputManager.instance.addEventListener(GameInputs.FIRE,this.onFireRequest,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_FIRE,this.onStopFire,false,0,true);
		}
		
		private function removeGameEventListeners() : void
		{
			this._assets.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			this._laser.removeEventListener(GameEvents.LASER_SHOOT_BARN,this.onLaserShootBarn);
			this._laser.removeEventListener(GameEvents.LASER_SHOOTING_ALIENS,this.onLaserShooting);
		}
		
		private function removeInputListeners() : void
		{
			InputManager.instance.removeEventListener(GameInputs.MOVE_LEFT,this.onMoveLeft);
			InputManager.instance.removeEventListener(GameInputs.MOVE_RIGHT,this.onMoveRight);
			InputManager.instance.removeEventListener(GameInputs.STOP_MOVE,this.onMoveStop);
			InputManager.instance.removeEventListener(GameInputs.FIRE,this.onFireRequest);
		}
		
		private function onUpdate(e:Event) : void
		{
			if(this._laserDirection == this.LEFT_DIRECTION)
			{
				this._laser.moveLeft();
			}
			else if(this._laserDirection == this.RIGHT_DIRECTION)
			{
				this._laser.moveRight();
			}
			if(this._fireRequest)
			{
				this.fireLaser();
			}
		}
		
		private function onMoveStop(e:EventWithParams) : void
		{
			var keyCode:int = e.params.keyCode;
			if((keyCode == Keyboard.LEFT || keyCode == Keyboard.A || keyCode == InputManager.MOVE_LEFT_CODE) && this._laserDirection == this.LEFT_DIRECTION || (keyCode == Keyboard.RIGHT || keyCode == Keyboard.D || keyCode == InputManager.MOVE_RIGHT_CODE) && this._laserDirection == this.RIGHT_DIRECTION)
			{
				this._laserDirection = this.NO_DIRECTION;
			}
		}
		
		private function onMoveLeft(e:EventWithParams) : void
		{
			this._laserDirection = this.LEFT_DIRECTION;
		}
		
		private function onMoveRight(e:EventWithParams) : void
		{
			this._laserDirection = this.RIGHT_DIRECTION;
		}
		
		private function onStopFire(e:EventWithParams) : void
		{
			this._fireRequest = false;
		}
		
		private function onFireRequest(e:EventWithParams) : void
		{
			this._fireRequest = true;
		}
		
		private function fireLaser() : void
		{
			var laserPosX:Number = NaN;
			var targetBarn:Barn = null;
			var targetBarnPiece:MovieClip = null;
			if(this._laser.canShoot)
			{
				laserPosX = this._laser.position.x;
				targetBarn = this._barnController.getBarnfromPosition(laserPosX);
				if(targetBarn)
				{
					targetBarnPiece = targetBarn.getPiecefromPosition(laserPosX,false);
					if(targetBarnPiece)
					{
						this._laser.shootBarn(targetBarn,targetBarnPiece);
					}
					else
					{
						this._laser.shootAliens();
					}
				}
				else
				{
					this._laser.shootAliens();
				}
			}
		}
		
		private function onLaserShootBarn(e:EventWithParams) : void
		{
			var targetBarn:Barn = e.params.barn;
			var targetPiece:MovieClip = e.params.piece;
			var projectilePosX:Number = e.params.posX;
			if(targetBarn.getPiecefromPosition(projectilePosX,false) == targetPiece)
			{
				targetBarn.destroyPiece(targetPiece);
				this._laser.terminateShoot();
			}
			else
			{
				this._laser.shootAliens(true);
			}
		}
		
		private function onLaserShooting(e:EventWithParams) : void
		{
			dispatchEvent(e);
		}
		
		private function onLaserDestroyed(e:EventWithParams) : void
		{
			if(GamePersistantData.lifeNum > 0)
			{
				eaze(this._assets.laserMc).delay(this.DELAY_BEFORE_RESPAWN).onComplete(this._laser.respawn);
			}
			else
			{
				dispatchEvent(new EventWithParams(GameEvents.GAME_OVER));
			}
		}
		
		private function onLaserRespawned(e:EventWithParams) : void
		{
			dispatchEvent(e);
		}
		
		public function destroyLaser() : void
		{
			GamePersistantData.removeLife();
			Log.info("--> Remaining Lives: " + GamePersistantData.lifeNum);
			this._laser.kill();
		}
		
		public function pause(paused:Boolean) : void
		{
			if(paused)
			{
				this.removeGameEventListeners();
				this.removeInputListeners();
				this._laserDirection = this.NO_DIRECTION;
				this._fireRequest = false;
			}
			else
			{
				this.addGameEventListeners();
				this.addInputListeners();
			}
		}
		
		public function dispose() : void
		{
			this.stop();
			this._laser.removeEventListener(GameEvents.LASER_DESTROYED,this.onLaserDestroyed);
			this._laser.removeEventListener(GameEvents.LASER_RESPAWNED,this.onLaserRespawned);
			this._laser.dispose();
			this._barnController.dispose();
		}
	}
}
