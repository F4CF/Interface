package bhvr.states
{
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import aze.motion.eaze;
	import aze.motion.EazeTween;
	import flash.display.MovieClip;
	
	public class IntroState extends GameState
	{
		 
		
		public function IntroState(id:int, assets:MovieClip)
		{
			super(id,assets);
		}
		
		override public function enter() : void
		{
			super.enter();
			SoundManager.instance.startSound(SoundList.INTRO_MUSIC_LOOP_SOUND_ID);
			eaze(_assets).play("start>end").onComplete(onNavContinue);
		}
		
		override public function exit() : void
		{
			super.exit();
			SoundManager.instance.stopSound(SoundList.INTRO_MUSIC_LOOP_SOUND_ID);
		}
		
		override public function Pause(paused:Boolean) : void
		{
			super.Pause(paused);
			if(paused)
			{
				EazeTween.pauseAllTweens();
				if(_assets.bossMc)
				{
					_assets.bossMc.stop();
				}
				if(_assets.girlMc)
				{
					_assets.girlMc.stop();
				}
			}
			else
			{
				EazeTween.resumeAllTweens();
				if(_assets.bossMc)
				{
					_assets.bossMc.play();
				}
				if(_assets.girlMc)
				{
					_assets.girlMc.play();
				}
			}
		}
	}
}
