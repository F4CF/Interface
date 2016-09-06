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
		
		public function PauseButton(assets:MovieClip)
		{
			super();
			this._assets = assets;
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
		
		public function isTouchOverlapping(touch:Touch) : Boolean
		{
			var bounds:Rectangle = this._assets.getBounds(this._assets.stage);
			return !isNaN(touch.stagePosition.x) && !isNaN(touch.stagePosition.y) && touch.stagePosition.x >= bounds.x && touch.stagePosition.x <= bounds.x + bounds.width && touch.stagePosition.y >= bounds.y && touch.stagePosition.y <= bounds.y + bounds.height;
		}
		
		private function onClicked(e:Event) : void
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
