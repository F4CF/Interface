package Holotapes.Common.tutorial
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	public class BaseTutorialOverlay extends Sprite
	{
		 
		
		public function BaseTutorialOverlay()
		{
			super();
			if(stage)
			{
				this.init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,this.init);
			}
		}
		
		private function init(param1:Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,this.init);
			getChildByName("mainMc").visible = false;
			if(ExternalInterface.available)
			{
				ExternalInterface.call.apply(null,["RegisterMovie",this]);
			}
		}
		
		public function SetScreenInfo(param1:int, param2:int, param3:Number) : void
		{
			getChildByName("mainMc").visible = true;
		}
	}
}
