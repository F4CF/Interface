package bhvr.states
{
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import flash.events.MouseEvent;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class TitleState extends GameState
	{
		 
		
		public function TitleState(param1:int, param2:MovieClip)
		{
			super(param1,param2);
		}
		
		override public function enter(param1:Object = null) : void
		{
			super.enter(param1);
			eaze(_assets).play("opening>Stop").onComplete(this.onIntroComplete);
			SoundManager.instance.startSound(SoundList.TITLE_MUSIC_LOOP_SOUND_ID);
		}
		
		private function onIntroComplete() : void
		{
			if(!CompanionAppMode.isOn)
			{
				_assets.stage.addEventListener(MouseEvent.CLICK,this.onContinue,false,0,true);
			}
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onContinue,false,0,true);
		}
		
		override public function exit() : void
		{
			super.exit();
			SoundManager.instance.stopSound(SoundList.TITLE_MUSIC_LOOP_SOUND_ID);
		}
		
		private function onContinue(param1:Event) : void
		{
			if(!CompanionAppMode.isOn)
			{
				_assets.stage.removeEventListener(MouseEvent.CLICK,this.onContinue);
			}
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onContinue);
			SoundManager.instance.playSound(SoundList.NAV_CONTINUE_SOUND);
			eaze(_assets).play("closing>stop").onComplete(onNavContinue);
		}
	}
}
