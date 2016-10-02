package bhvr.states
{
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.manager.InputManager;
	import bhvr.constatnts.GameInputs;
	import flash.events.Event;
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	
	public class TitleState extends GameState
	{
		 
		
		public function TitleState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.introAnimMc.instructionsMc.instructionsAnimMc.instructionsTxt.text = LocalizationStrings.PRESS_START;
		}
		
		override public function enter() : void
		{
			super.enter();
			SoundManager.instance.startSound(SoundList.MAIN_MENU_MUSIC_LOOP_SOUND_ID);
			_assets.introAnimMc.gotoAndPlay("start");
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onStartGame,false,0,true);
		}
		
		override public function exit() : void
		{
			super.exit();
			SoundManager.instance.stopSound(SoundList.MAIN_MENU_MUSIC_LOOP_SOUND_ID);
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onStartGame);
		}
		
		private function onStartGame(e:Event) : void
		{
			SoundManager.instance.playSound(SoundList.PRESS_START_SOUND);
			onNavContinue();
		}
		
		override public function Pause(paused:Boolean) : void
		{
			if(paused)
			{
				_assets.introAnimMc.instructionsMc.stop();
			}
			else
			{
				_assets.introAnimMc.instructionsMc.play();
			}
		}
	}
}
