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
		
		public function PropertyVolume(target:Object, property:*, value:*, next:EazeSpecial)
		{
			super(target,property,value,next);
			this.vvalue = value;
		}
		
		public static function register() : void
		{
			EazeTween.specialProperties.volume = PropertyVolume;
		}
		
		override public function init(reverse:Boolean) : void
		{
			var end:Number = NaN;
			this.targetVolume = "soundTransform" in target;
			var st:SoundTransform = !!this.targetVolume?target.soundTransform:SoundMixer.soundTransform;
			if(reverse)
			{
				this.start = this.vvalue;
				end = st.volume;
			}
			else
			{
				end = this.vvalue;
				this.start = st.volume;
			}
			this.delta = end - this.start;
		}
		
		override public function update(ke:Number, isComplete:Boolean) : void
		{
			var st:SoundTransform = !!this.targetVolume?target.soundTransform:SoundMixer.soundTransform;
			st.volume = this.start + this.delta * ke;
			if(this.targetVolume)
			{
				target.soundTransform = st;
			}
			else
			{
				SoundMixer.soundTransform = st;
			}
		}
	}
}
