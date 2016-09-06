package bhvr.views
{
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.display.MovieClip;
	
	public class BobbleHead extends InteractiveObject
	{
		 
		
		public function BobbleHead(container:MovieClip)
		{
			_type = InteractiveObject.BOBBLE_HEAD;
			super(container,_type);
			_collider = _mainObject.bobbleHeadViewMc;
		}
		
		public function collect(allCollected:Boolean) : void
		{
			_collider = null;
			eaze(_mainObject.bobbleHeadViewMc).play("start>end");
			if(allCollected)
			{
				SoundManager.instance.startLongSound(SoundList.PLAYER_COLLECT_LAST_BOBBLEHEAD_SOUND_ID);
			}
			else
			{
				SoundManager.instance.playSound(SoundList.PLAYER_COLLECT_BOBBLEHEAD_SOUND);
			}
		}
	}
}
