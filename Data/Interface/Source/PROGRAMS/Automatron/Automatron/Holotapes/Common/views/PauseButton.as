package Holotapes.Common.views
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import scaleform.clik.events.ButtonEvent;
	import Holotapes.Common.touch.Touch;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	public class PauseButton extends EventDispatcher
	{
		
		public static const CLICKED:String = "Clicked";
		
		private static var _instance:Holotapes.Common.views.PauseButton = null;
		 
		
		private var _assets:MovieClip;
		
		public function PauseButton(param1:MovieClip)
		{
			super();
			this._assets = param1;
			_instance = this;
			this.show();
		}
		
		public static function get instance() : Holotapes.Common.views.PauseButton
		{
			return _instance;
		}
		
		public function show() : void
		{
			this._assets.visible = true;
			this._assets.addEventListener(ButtonEvent.CLICK,this.onClicked,false,int.MAX_VALUE,true);
		}
		
		public function hide() : void
		{
			this._assets.removeEventListener(ButtonEvent.CLICK,this.onClicked);
			this._assets.visible = false;
		}
		
		public function isTouchOverlapping(param1:Touch) : Boolean
		{
			var _loc2_:Rectangle = this._assets.getBounds(this._assets.stage);
			return !isNaN(param1.stagePosition.x) && !isNaN(param1.stagePosition.y) && param1.stagePosition.x >= _loc2_.x && param1.stagePosition.x <= _loc2_.x + _loc2_.width && param1.stagePosition.y >= _loc2_.y && param1.stagePosition.y <= _loc2_.y + _loc2_.height;
		}
		
		private function onClicked(param1:Event) : void
		{
			dispatchEvent(new Event(CLICKED,true,true));
		}
		
		public function dispose() : void
		{
			this.hide();
			this._assets = null;
			_instance = null;
		}
	}
}
