package bhvr.views
{
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.display.MovieClip;
	
	public class RadioActivePool extends InteractiveObject
	{
		
		public static const POOL_DELTA_DETECTION:Number = 10;
		 
		
		public function RadioActivePool(container:MovieClip)
		{
			if(_type == InteractiveObject.NONE)
			{
				_type = InteractiveObject.RADIOACTIVE_POOL;
			}
			super(container,_type);
			_collider = _mainObject.colliderMc;
			if(_type == InteractiveObject.RADIOACTIVE_POOL)
			{
				SoundManager.instance.startSound(SoundList.RADIOACTIVE_POOL_LOOP_SOUND_ID);
			}
		}
		
		public function get position() : Number
		{
			return _mainObject.colliderMc.x;
		}
		
		public function get dimension() : Number
		{
			return _mainObject.colliderMc.width;
		}
		
		override public function pause() : void
		{
			if(_mainObject.radioActivePoolMc)
			{
				_mainObject.radioActivePoolMc.stop();
			}
			if(_type == InteractiveObject.RADIOACTIVE_POOL)
			{
				SoundManager.instance.stopSound(SoundList.RADIOACTIVE_POOL_LOOP_SOUND_ID);
			}
		}
		
		override public function resume() : void
		{
			if(_mainObject.radioActivePoolMc)
			{
				_mainObject.radioActivePoolMc.play();
			}
			if(_type == InteractiveObject.RADIOACTIVE_POOL)
			{
				SoundManager.instance.startSound(SoundList.RADIOACTIVE_POOL_LOOP_SOUND_ID);
			}
		}
		
		override public function dispose() : void
		{
			if(_type == InteractiveObject.RADIOACTIVE_POOL)
			{
				SoundManager.instance.stopSound(SoundList.RADIOACTIVE_POOL_LOOP_SOUND_ID);
			}
			super.dispose();
		}
	}
}
