package aze.motion.specials
{
	import aze.motion.EazeTween;
	import flash.geom.ColorTransform;
	
	public class PropertyTint extends EazeSpecial
	{
		 
		
		private var start:ColorTransform;
		
		private var tvalue:ColorTransform;
		
		private var delta:ColorTransform;
		
		public function PropertyTint(param1:Object, param2:*, param3:*, param4:EazeSpecial)
		{
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			var _loc7_:uint = 0;
			var _loc8_:Array = null;
			super(param1,param2,param3,param4);
			if(param3 === null)
			{
				this.tvalue = new ColorTransform();
			}
			else
			{
				_loc5_ = 1;
				_loc6_ = 0;
				_loc7_ = 0;
				_loc8_ = param3 is Array?param3:[param3];
				if(_loc8_[0] === null)
				{
					_loc5_ = 0;
					_loc6_ = 1;
				}
				else
				{
					if(_loc8_.length > 1)
					{
						_loc5_ = _loc8_[1];
					}
					if(_loc8_.length > 2)
					{
						_loc6_ = _loc8_[2];
					}
					else
					{
						_loc6_ = 1 - _loc5_;
					}
					_loc7_ = _loc8_[0];
				}
				this.tvalue = new ColorTransform();
				this.tvalue.redMultiplier = _loc6_;
				this.tvalue.greenMultiplier = _loc6_;
				this.tvalue.blueMultiplier = _loc6_;
				this.tvalue.redOffset = _loc5_ * (_loc7_ >> 16 & 255);
				this.tvalue.greenOffset = _loc5_ * (_loc7_ >> 8 & 255);
				this.tvalue.blueOffset = _loc5_ * (_loc7_ & 255);
			}
		}
		
		public static function register() : void
		{
			EazeTween.specialProperties.tint = PropertyTint;
		}
		
		override public function init(param1:Boolean) : void
		{
			if(param1)
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
			if(param1)
			{
				this.update(0,false);
			}
		}
		
		override public function update(param1:Number, param2:Boolean) : void
		{
			var _loc3_:ColorTransform = target.transform.colorTransform;
			_loc3_.redMultiplier = this.start.redMultiplier + this.delta.redMultiplier * param1;
			_loc3_.greenMultiplier = this.start.greenMultiplier + this.delta.greenMultiplier * param1;
			_loc3_.blueMultiplier = this.start.blueMultiplier + this.delta.blueMultiplier * param1;
			_loc3_.redOffset = this.start.redOffset + this.delta.redOffset * param1;
			_loc3_.greenOffset = this.start.greenOffset + this.delta.greenOffset * param1;
			_loc3_.blueOffset = this.start.blueOffset + this.delta.blueOffset * param1;
			target.transform.colorTransform = _loc3_;
		}
		
		override public function dispose() : void
		{
			this.start = this.delta = null;
			this.tvalue = null;
			super.dispose();
		}
	}
}
