package bhvr.states
{
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import aze.motion.eaze;
	import bhvr.constants.GameConstants;
	import flash.events.Event;
	import aze.motion.EazeTween;
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	
	public class TitleState extends GameState
	{
		
		private static var _skipIntroAnimation:Boolean = false;
		 
		
		public function TitleState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.introAnimMc.instructionsMc.instructionsAnimMc.instructionsTxt.text = LocalizationStrings.START_PROMPT;
		}
		
		private function get hasInputs() : Boolean
		{
			return _assets.introAnimMc.instructionsMc.alpha > 0;
		}
		
		override public function enter() : void
		{
			super.enter();
			SoundManager.instance.startSound(SoundList.INTRO_MUSIC_LOOP_SOUND_ID);
			if(_skipIntroAnimation)
			{
				_assets.introAnimMc.gotoAndStop("introEnd");
				this.onIntroFinished();
			}
			else
			{
				this.playIntroAnimation();
			}
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onStartGame,false,0,true);
		}
		
		override public function exit() : void
		{
			super.exit();
			SoundManager.instance.stopSound(SoundList.INTRO_MUSIC_LOOP_SOUND_ID);
			_skipIntroAnimation = true;
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onStartGame);
		}
		
		private function playIntroAnimation() : void
		{
			eaze(_assets.introAnimMc).play("introStart>introEnd").onComplete(this.onIntroFinished);
		}
		
		private function onIntroFinished() : void
		{
			eaze(this).delay(GameConstants.introAnimIdleDelay).onComplete(this.playIntroAnimation);
		}
		
		private function onStartGame(e:Event) : void
		{
			if(this.hasInputs)
			{
				eaze(this).killTweens();
				SoundManager.instance.playSound(SoundList.PRESS_START_SOUND);
				onNavContinue();
			}
			else
			{
				eaze(_assets.introAnimMc).killTweens();
				_assets.introAnimMc.gotoAndStop("introEnd");
				this.onIntroFinished();
			}
		}
		
		override public function Pause(paused:Boolean) : void
		{
			if(paused)
			{
				EazeTween.pauseAllTweens();
				if(this.hasInputs)
				{
					_assets.introAnimMc.instructionsMc.stop();
				}
				InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onStartGame);
			}
			else
			{
				EazeTween.resumeAllTweens();
				if(this.hasInputs)
				{
					_assets.introAnimMc.instructionsMc.play();
				}
				InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onStartGame,false,0,true);
			}
		}
	}
}
