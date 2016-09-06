package bhvr.views
{
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	import aze.motion.eaze;
	import aze.motion.easing.Linear;
	import bhvr.events.EventWithParams;
	import flash.display.MovieClip;
	
	public class Rope extends InteractiveObject
	{
		
		public static const ROPE_UPDATE_EVENT:String = "RopeUpdateEvent";
		
		public static const ROPE_DIRECTION_CHANGE_EVENT:String = "RopeDirectionChangeEvent";
		 
		
		private const DIRECTION_RIGHT:uint = 0;
		
		private const DIRECTION_LEFT:uint = 1;
		
		private var _direction:uint;
		
		private const LEFT_ANGLE:Number = 40;
		
		private const RIGHT_ANGLE:Number = -40;
		
		private const SWING_DURATION:Number = 2.0;
		
		private const SWING_PAUSE_DELAY:Number = 0.1;
		
		public function Rope(container:MovieClip)
		{
			_type = InteractiveObject.SWINGING_ROPE;
			super(container,_type);
			this.startSwing();
		}
		
		public function get colliderPoint() : Point
		{
			return FlashUtil.localToGlobalPosition(_mainObject.ropeViewMc.colliderPointMc);
		}
		
		public function get rightAnchorPoint() : Point
		{
			return FlashUtil.localToGlobalPosition(_mainObject.ropeViewMc.rightAnchorPointMc);
		}
		
		public function get leftAnchorPoint() : Point
		{
			return FlashUtil.localToGlobalPosition(_mainObject.ropeViewMc.leftAnchorPointMc);
		}
		
		public function get rotation() : Number
		{
			return _mainObject.ropeViewMc.rotation;
		}
		
		private function startSwing() : void
		{
			this._direction = this.DIRECTION_LEFT;
			_mainObject.ropeViewMc.rotation = this.LEFT_ANGLE;
			this.swing();
		}
		
		private function swing() : void
		{
			if(this._direction == this.DIRECTION_LEFT)
			{
				this._direction = this.DIRECTION_RIGHT;
				eaze(_mainObject.ropeViewMc).to(this.SWING_DURATION,{"rotation":this.RIGHT_ANGLE}).easing(Linear.easeNone).onUpdate(this.onUpdate).onComplete(this.swingPause);
				dispatchEvent(new EventWithParams(ROPE_DIRECTION_CHANGE_EVENT));
			}
			else
			{
				this._direction = this.DIRECTION_LEFT;
				eaze(_mainObject.ropeViewMc).to(this.SWING_DURATION,{"rotation":this.LEFT_ANGLE}).easing(Linear.easeNone).onUpdate(this.onUpdate).onComplete(this.swingPause);
				dispatchEvent(new EventWithParams(ROPE_DIRECTION_CHANGE_EVENT));
			}
		}
		
		private function onUpdate() : void
		{
			dispatchEvent(new EventWithParams(ROPE_UPDATE_EVENT,{
				"rightAnchorPoint":new Point(this.rightAnchorPoint.x,this.rightAnchorPoint.y),
				"leftAnchorPoint":new Point(this.leftAnchorPoint.x,this.leftAnchorPoint.y),
				"rotation":this.rotation
			}));
		}
		
		private function swingPause() : void
		{
			eaze(_mainObject.ropeViewMc).delay(this.SWING_PAUSE_DELAY).onComplete(this.swing);
		}
		
		override public function dispose() : void
		{
			if(_mainObject != null)
			{
				eaze(_mainObject.ropeViewMc).killTweens();
			}
			super.dispose();
		}
	}
}
