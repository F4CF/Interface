package bhvr.states
{
	import bhvr.data.LocalizationStrings;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import flash.events.MouseEvent;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import flash.events.Event;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.display.MovieClip;
	
	public class InstructionsState extends GameState
	{
		 
		
		public function InstructionsState(param1:int, param2:MovieClip)
		{
			super(param1,param2);
		}
		
		override public function enter(param1:Object = null) : void
		{
			super.enter(param1);
			_assets.promptsMc.promptsAnimMc.promptsTxt.text = LocalizationStrings.PRESS_START_DESCRIPTION;
			if(!CompanionAppMode.isOn)
			{
				_assets.stage.addEventListener(MouseEvent.CLICK,this.onContinue,false,0,true);
			}
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onContinue,false,0,true);
		}
		
		override public function exit() : void
		{
			super.exit();
			if(!CompanionAppMode.isOn)
			{
				_assets.stage.removeEventListener(MouseEvent.CLICK,this.onContinue);
			}
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onContinue);
		}
		
		private function onContinue(param1:Event) : void
		{
			SoundManager.instance.playSound(SoundList.NAV_START_GAME_SOUND);
			onNavContinue();
		}
		
		override public function Pause(param1:Boolean) : void
		{
			super.Pause(param1);
			if(param1)
			{
				_assets.promptsMc.stop();
			}
			else
			{
				_assets.promptsMc.play();
			}
		}
	}
}
