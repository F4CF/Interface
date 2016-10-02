package aze.motion.specials
{
	import aze.motion.EazeTween;
	import flash.geom.ColorTransform;
	
	public class PropertyTint extends EazeSpecial
	{
		 
		
		private var start:ColorTransform;
		
		private var tvalue:ColorTransform;
		
		private var delta:ColorTransform;
		
		public function PropertyTint(target:Object, property:*, value:*, next:EazeSpecial)
		{
			var mix:Number = NaN;
			var amix:Number = NaN;
			var color:uint = 0;
			var a:Array = null;
			super(target,property,value,next);
			if(value === null)
			{
				this.tvalue = new ColorTransform();
			}
			else
			{
				mix = 1;
				amix = 0;
				color = 0;
				a = value is Array?value:[value];
				if(a[0] === null)
				{
					mix = 0;
					amix = 1;
				}
				else
				{
					if(a.length > 1)
					{
						mix = a[1];
					}
					if(a.length > 2)
					{
						amix = a[2];
					}
					else
					{
						amix = 1 - mix;
					}
					color = a[0];
				}
				this.tvalue = new ColorTransform();
				this.tvalue.redMultiplier = amix;
				this.tvalue.greenMultiplier = amix;
				this.tvalue.blueMultiplier = amix;
				this.tvalue.redOffset = mix * (color >> 16 & 255);
				this.tvalue.greenOffset = mix * (color >> 8 & 255);
				this.tvalue.blueOffset = mix * (color & 255);
			}
		}
		
		public static function register() : void
		{
			EazeTween.specialProperties.tint = PropertyTint;
		}
		
		override public function init(reverse:Boolean) : void
		{
			if(reverse)
			{
				this.start = this.tvalue;
				this.tvalue = target.transform.colorTransform;
			}
			else
			{
				this.start = target.transform.colorTransform;
			}
			this.delta = new ColorTransform(this.tvalue.redMultiplier - this.start.redMultiplier,this.tvalue.greenMultiplier - this.start.greenMultiplier,this.tvalue.blueMultiplier - this.start.blueMultiplier,0,this.tvalue.redOffset - this.start.redOffset,this.tvalue.greenOffset - this.start.greenOffset,this.tvalue.blueOffset - this.start.blueOffset);
			this.tvalue = null;
			if(reverse)
			{
				this.update(0,false);
			}
		}
		
		override public function update(ke:Number, isComplete:Boolean) : void
		{
			var t:ColorTransform = target.transform.colorTransform;
			t.redMultiplier = this.start.redMultiplier + this.delta.redMultiplier * ke;
			t.greenMultiplier = this.start.greenMultiplier + this.delta.greenMultiplier * ke;
			t.blueMultiplier = this.start.blueMultiplier + this.delta.blueMultiplier * ke;
			t.redOffset = this.start.redOffset + this.delta.redOffset * ke;
			t.greenOffset = this.start.greenOffset + this.delta.greenOffset * ke;
			t.blueOffset = this.start.blueOffset + this.delta.blueOffset * ke;
			target.transform.colorTransform = t;
		}
		
		override public function dispose() : void
		{
			this.start = this.delta = null;
			this.tvalue = null;
			super.dispose();
		}
	}
}
