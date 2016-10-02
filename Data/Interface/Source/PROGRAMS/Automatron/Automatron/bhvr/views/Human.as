package bhvr.views
{
	import bhvr.ai.Path;
	import bhvr.constants.GameConstants;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import bhvr.events.EventWithParams;
	
	public class Human extends Character
	{
		 
		
		private var _path:Path;
		
		public function Human(param1:MovieClip)
		{
			super(param1,Character.HUMAN_ID,Character.HUMAN);
		}
		
		override protected function initialize() : void
		{
			_collider = _mainObject;
			_speed = GameConstants.humanSpeed;
			_direction = NO_DIRECTION;
			this.setState(STANDING_STATE);
			this._path = new Path(this,Path.RANDOM_ALL_DIR_PATH,true,GameConstants.humanChangeDirectionMinDelay,GameConstants.humanChangeDirectionMaxDelay,GameConstants.humanChangeDirectionAfterStopDelay);
			this._path.addEventListener(Path.STOP_MOVING,this.onStopMoving,false,0,true);
			this._path.addEventListener(Path.MOVING_AFTER_STOP,this.onMovingAfterStop,false,0,true);
			this._path.addEventListener(Path.CHANGING_DIRECTION,this.onChangingDirection,false,0,true);
		}
		
		override public function start() : void
		{
			this._path.start();
		}
		
		override public function stop() : void
		{
			stopMoving();
			this._path.stop();
		}
		
		override public function update(param1:Point) : void
		{
			if(_collider != null)
			{
				this.move();
			}
		}
		
		override protected function setState(param1:uint) : void
		{
			var _loc2_:MovieClip = null;
			if(_state != param1)
			{
				_loc2_ = _mainObject.viewMc;
				switch(param1)
				{
					case STANDING_STATE:
					case STOP_STATE:
						_loc2_.gotoAndStop("stand");
						break;
					case MOVING_STATE:
						_loc2_.gotoAndPlay("walk");
						break;
					case DEATH_STATE:
						_mainObject.gotoAndPlay("death");
				}
			}
			super.setState(param1);
		}
		
		private function move() : void
		{
			var _loc1_:Point = this._path.getNextPosition();
			setPosition(_loc1_.x,_loc1_.y);
		}
		
		override public function destroy() : void
		{
			super.destroy();
			this.stop();
			this.setState(DEATH_STATE);
		}
		
		protected function onStopMoving(param1:EventWithParams) : void
		{
			stopMoving();
		}
		
		protected function onMovingAfterStop(param1:EventWithParams) : void
		{
			this.setState(Character.MOVING_STATE);
		}
		
		protected function onChangingDirection(param1:EventWithParams) : void
		{
			if(param1.params.deltaPos.x > 0)
			{
				_mainObject.viewMc.scaleX = -1;
			}
			else if(param1.params.deltaPos.x < 0)
			{
				_mainObject.viewMc.scaleX = 1;
			}
		}
		
		override public function pause() : void
		{
			super.pause();
			if(_state == Character.MOVING_STATE)
			{
				_mainObject.viewMc.stop();
			}
		}
		
		override public function resume() : void
		{
			super.resume();
			if(_state == Character.MOVING_STATE)
			{
				_mainObject.viewMc.play();
			}
		}
		
		override public function dispose() : void
		{
			this.stop();
			this._path.removeEventListener(Path.STOP_MOVING,this.onStopMoving);
			this._path.removeEventListener(Path.MOVING_AFTER_STOP,this.onMovingAfterStop);
			this._path.removeEventListener(Path.CHANGING_DIRECTION,this.onChangingDirection);
			this._path = null;
			super.dispose();
		}
	}
}
