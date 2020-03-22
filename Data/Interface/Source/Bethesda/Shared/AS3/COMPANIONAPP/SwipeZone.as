package Shared.AS3.COMPANIONAPP
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SwipeZone extends EventDispatcher
	{
		
		public static const SWIPE_NEXT:String = "SwipeNext";
		
		public static const SWIPE_PREV:String = "SwipePrev";
		
		public static const HORIZONTAL:uint = 0;
		
		public static const VERTICAL:uint = 1;
		 
		
		protected var _container:DisplayObject;
		
		protected var _zone:Rectangle;
		
		protected var _mousePressPoint:Point;
		
		protected var _lastValidMousePoint:Point;
		
		protected var _isPressed:Boolean;
		
		protected var _direction:uint;
		
		protected const MIN_SWIPE_DISTANCE:Number = 200;
		
		protected const MAX_SWIPE_OPPOSITE_DIRECTION_RATIO:Number = 1;
		
		public function SwipeZone(param1:DisplayObject, param2:Rectangle = null, param3:uint = 0)
		{
			this._mousePressPoint = new Point();
			this._lastValidMousePoint = new Point();
			super();
			this._container = param1;
			this._zone = param2;
			this._direction = param3;
			this._mousePressPoint = new Point();
			this._isPressed = false;
		}
		
		public function activate() : void
		{
			this._container.addEventListener(MouseEvent.MOUSE_DOWN,this.mousePressHandler,false,0,true);
			this._container.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,false,0,true);
			this._container.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseReleaseHandler,false,0,true);
		}
		
		public function deactivate() : void
		{
			this._container.removeEventListener(MouseEvent.MOUSE_DOWN,this.mousePressHandler);
			this._container.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
			this._container.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseReleaseHandler);
		}
		
		protected function mousePressHandler(param1:MouseEvent) : void
		{
			this._mousePressPoint = new Point(param1.stageX,param1.stageY);
			this._isPressed = true;
		}
		
		protected function mouseMoveHandler(param1:MouseEvent) : void
		{
			if(!isNaN(param1.stageX) && !isNaN(param1.stageY))
			{
				if(isNaN(this._mousePressPoint.x) || isNaN(this._mousePressPoint.y))
				{
					this._mousePressPoint = new Point(param1.stageX,param1.stageY);
				}
				this._lastValidMousePoint = new Point(param1.stageX,param1.stageY);
			}
		}
		
		protected function mouseReleaseHandler(param1:MouseEvent) : void
		{
			var _loc2_:Point = null;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			if(this._isPressed && (this._zone == null || this._mousePressPoint.x >= this._zone.x && this._mousePressPoint.x <= this._zone.x + this._zone.width && this._mousePressPoint.y >= this._zone.y && this._mousePressPoint.y <= this._zone.y + this._zone.height))
			{
				_loc2_ = !isNaN(param1.stageX) && !isNaN(param1.stageY)?new Point(param1.stageX,param1.stageY):this._lastValidMousePoint;
				_loc3_ = this._direction == HORIZONTAL?Number(_loc2_.x - this._mousePressPoint.x):Number(_loc2_.y - this._mousePressPoint.y);
				_loc4_ = Math.abs((this._direction == HORIZONTAL?_loc2_.y - this._mousePressPoint.y:_loc2_.x - this._mousePressPoint.x) / _loc3_);
				if(_loc4_ < this.MAX_SWIPE_OPPOSITE_DIRECTION_RATIO)
				{
					if(_loc3_ > 0)
					{
						if(_loc3_ - this.MIN_SWIPE_DISTANCE > 0)
						{
							dispatchEvent(new Event(SWIPE_PREV));
						}
					}
					else if(_loc3_ + this.MIN_SWIPE_DISTANCE < 0)
					{
						dispatchEvent(new Event(SWIPE_NEXT));
					}
				}
				this._mousePressPoint = new Point();
				this._lastValidMousePoint = new Point();
				this._isPressed = false;
			}
		}
	}
}
