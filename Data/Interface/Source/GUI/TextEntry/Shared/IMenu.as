package Shared
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import Shared.AS3.BSButtonHelp;
	
	public class IMenu extends MovieClip
	{
		 
		
		var uiPlatform:uint = 4.294967295E9;
		
		var bPS3Switch:Boolean = false;
		
		public function IMenu()
		{
			super();
			addEventListener(BSButtonHelp.BUTTON_INITIALIZED,this.ButtonInitialized);
		}
		
		public function SetPlatform(param1:uint, param2:Boolean) : *
		{
			this.uiPlatform = param1;
			this.bPS3Switch = this.bPS3Switch;
			dispatchEvent(new PlatformChangeEvent(this.uiPlatform,this.bPS3Switch));
		}
		
		public function ButtonInitialized(param1:Event) : *
		{
			param1.target.parentClass = this;
			dispatchEvent(new PlatformChangeEvent(this.uiPlatform,this.bPS3Switch));
		}
	}
}
