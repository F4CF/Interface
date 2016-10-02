package aze.motion.specials
{
	import aze.motion.EazeTween;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	
	public class PropertyVolume extends EazeSpecial
	{
		 
		
		private var start:Number;
		
		private var delta:Number;
		
		private var vvalue:Number;
		
		private var targetVolume:Boolean;
		
		public function PropertyVolume(param1:Object, param2:*, param3:*, param4:EazeSpecial)
		{
			super(param1,param2,param3,param4);
			this.vvalue = param3;
		}
		
		public static function register() : void
		{
			EazeTween.specialProperties.volume = PropertyVolume;
		}
		
		override public function init(param1:Boolean) : void
		{
			var _loc3_:Number = NaN;
			this.targetVolume = "soundTransform" in target;
			var _loc2_:SoundTransform = !!this.targetVolume?target.soundTransform:SoundMixer.soundTransform;
			if(param1)
			{
				this.start = this.vvalue;
				_loc3_ = _loc2_.volume;
			}
			else
			{
				_loc3_ = this.vvalue;
				this.start = _loc2_.volume;
			}
			this.delta = _loc3_ - this.start;
		}
		
		override public function update(param1:Number, param2:Boolean) : void
		{
			var _loc3_:SoundTransform = !!this.targetVolume?target.soundTransform:SoundMixer.soundTransform;
			_loc3_.volume = this.start + this.delta * param1;
			if(this.targetVolume)
			{
				target.soundTransform = _loc3_;
			}
			else
			{
				SoundMixer.soundTransform = _loc3_;
			}
		}
	}
}
