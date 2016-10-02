package bhvr.states
{
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import flash.events.Event;
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	
	public class TitleState extends GameState
	{
		 
		
		public function TitleState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.instructionsMc.instructionsAnimMc.instructionsTxt.text = LocalizationStrings.START_PROMPT;
		}
		
		override public function enter() : void
		{
			super.enter();
			SoundManager.instance.startSound(SoundList.START_MUSIC_LOOP_SOUND_ID);
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onStartGame,false,0,true);
		}
		
		override public function exit() : void
		{
			super.exit();
			SoundManager.instance.stopSound(SoundList.START_MUSIC_LOOP_SOUND_ID);
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onStartGame);
		}
		
		private function onStartGame(e:Event) : void
		{
			onNavContinue();
		}
		
		override public function Pause(paused:Boolean) : void
		{
			super.Pause(paused);
			if(paused)
			{
				_assets.bossMc.stop();
				_assets.instructionsMc.stop();
			}
			else
			{
				_assets.bossMc.play();
				_assets.instructionsMc.play();
			}
		}
	}
}
