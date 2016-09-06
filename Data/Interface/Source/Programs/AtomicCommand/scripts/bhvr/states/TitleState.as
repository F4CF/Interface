package bhvr.states
{
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.manager.InputManager;
	import bhvr.constatnts.GameInputs;
	import flash.events.Event;
	import aze.motion.EazeTween;
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	
	public class TitleState extends GameState
	{
		 
		
		private var _introAnimFinished:Boolean = false;
		
		public function TitleState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.instructionsMc.instructionsAnimMc.instructionsTxt.text = LocalizationStrings.PRESS_START_DESCRIPTION;
		}
		
		override public function enter() : void
		{
			super.enter();
			this._introAnimFinished = false;
			eaze(_assets.introAnimationMc).play("start>end").onComplete(this.onIntroFinished);
			_assets.instructionsMc.instructionsAnimMc.visible = false;
			SoundManager.instance.startSound(SoundList.TITLE_SCREEN_SOUND_ID);
		}
		
		override public function exit() : void
		{
			super.exit();
			SoundManager.instance.stopSound(SoundList.TITLE_SCREEN_SOUND_ID);
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onStartGame);
		}
		
		private function onStartGame(e:Event) : void
		{
			onNavContinue();
		}
		
		private function onIntroFinished() : void
		{
			this._introAnimFinished = true;
			_assets.instructionsMc.instructionsAnimMc.visible = true;
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onStartGame,false,0,true);
		}
		
		override public function Pause(paused:Boolean) : void
		{
			if(paused)
			{
				if(this._introAnimFinished)
				{
					_assets.instructionsMc.stop();
					InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onStartGame);
				}
				else
				{
					EazeTween.pauseAllTweens();
				}
			}
			else if(this._introAnimFinished)
			{
				_assets.instructionsMc.play();
				InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onStartGame,false,0,true);
			}
			else
			{
				EazeTween.resumeAllTweens();
			}
		}
	}
}
