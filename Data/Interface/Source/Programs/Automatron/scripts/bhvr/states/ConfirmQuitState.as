package bhvr.states
{
	import bhvr.data.LocalizationStrings;
	import scaleform.gfx.TextFieldEx;
	import scaleform.clik.events.ButtonEvent;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import scaleform.clik.managers.FocusHandler;
	import flash.events.Event;
	import bhvr.events.EventWithParams;
	import flash.display.MovieClip;
	
	public class ConfirmQuitState extends GameState
	{
		
		public static const QUIT:String = "Quit";
		
		public static const CANCEL:String = "Cancel";
		 
		
		public function ConfirmQuitState(param1:int, param2:MovieClip)
		{
			super(param1,param2);
		}
		
		public function get isActive() : Boolean
		{
			return _assets.visible;
		}
		
		override public function enter(param1:Object = null) : void
		{
			super.enter();
			_assets.descriptionTxt.text = LocalizationStrings.CONFIRM_QUIT_TEXT;
			TextFieldEx.setVerticalAlign(_assets.descriptionTxt,TextFieldEx.VALIGN_CENTER);
			_assets.btn0.label = LocalizationStrings.CONFIRM_QUIT_YES;
			_assets.btn0.addEventListener(ButtonEvent.CLICK,this.onConfirmed,false,0,true);
			_assets.btn1.label = LocalizationStrings.CONFIRM_QUIT_NO;
			_assets.btn1.addEventListener(ButtonEvent.CLICK,this.onCancelled,false,0,true);
			if(!CompanionAppMode.isOn)
			{
				FocusHandler.instance.setFocus(_assets.btn0);
			}
		}
		
		private function onConfirmed(param1:Event) : void
		{
			_assets.btn0.enabled = false;
			_assets.btn1.enabled = false;
			dispatchEvent(new EventWithParams(QUIT));
		}
		
		private function onCancelled(param1:Event) : void
		{
			dispatchEvent(new EventWithParams(CANCEL));
		}
		
		override public function exit() : void
		{
			_assets.btn0.removeEventListener(ButtonEvent.CLICK,this.onConfirmed);
			_assets.btn1.removeEventListener(ButtonEvent.CLICK,this.onCancelled);
			super.exit();
		}
	}
}
