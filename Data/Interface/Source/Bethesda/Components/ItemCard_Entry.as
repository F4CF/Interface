package Components
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class ItemCard_Entry extends MovieClip
	{
		 
		
		public var Label_tf:TextField;
		
		public var Value_tf:TextField;
		
		public var Comparison_mc:MovieClip;
		
		public function ItemCard_Entry()
		{
			super();
			Extensions.enabled = true;
			if(this.Label_tf != null)
			{
				TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			}
			if(this.Value_tf != null)
			{
				TextFieldEx.setTextAutoSize(this.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			}
		}
		
		public static function ShouldShowDifference(param1:Object) : Boolean
		{
			var _loc2_:uint = param1.precision != undefined?uint(param1.precision):uint(0);
			var _loc3_:Number = 1;
			var _loc4_:uint = 0;
			while(_loc4_ < _loc2_)
			{
				_loc3_ = _loc3_ / 10;
				_loc4_++;
			}
			return Math.abs(param1.difference) >= _loc3_;
		}
		
		public function PopulateEntry(param1:Object) : *
		{
			var _loc2_:* = null;
			var _loc3_:Number = NaN;
			var _loc4_:uint = 0;
			var _loc5_:* = undefined;
			if(this.Label_tf != null)
			{
				GlobalFunc.SetText(this.Label_tf,param1.text,false);
			}
			if(this.Value_tf != null)
			{
				if(param1.value is String)
				{
					_loc2_ = param1.value;
				}
				else
				{
					_loc3_ = param1.value;
					if(param1.scaleWithDuration)
					{
						_loc3_ = _loc3_ * param1.duration;
					}
					_loc2_ = _loc3_.toString();
					_loc4_ = param1.precision != undefined?uint(param1.precision):uint(0);
					_loc5_ = _loc2_.indexOf(".");
					if(_loc5_ > -1)
					{
						if(_loc4_)
						{
							_loc2_ = _loc2_.substring(0,Math.min(_loc5_ + _loc4_ + 1,_loc2_.length));
						}
						else
						{
							_loc2_ = _loc2_.substring(0,_loc5_);
						}
					}
					if(param1.showAsPercent)
					{
						_loc2_ = _loc2_ + "%";
					}
				}
				GlobalFunc.SetText(this.Value_tf,_loc2_,false);
			}
			if(this.Comparison_mc != null && ShouldShowDifference(param1))
			{
				switch(param1.diffRating)
				{
					case -3:
						this.Comparison_mc.gotoAndStop("Worst");
						break;
					case -2:
						this.Comparison_mc.gotoAndStop("Worse");
						break;
					case -1:
						this.Comparison_mc.gotoAndStop("Bad");
						break;
					case 1:
						this.Comparison_mc.gotoAndStop("Good");
						break;
					case 2:
						this.Comparison_mc.gotoAndStop("Better");
						break;
					case 3:
						this.Comparison_mc.gotoAndStop("Best");
						break;
					default:
						this.Comparison_mc.gotoAndStop("None");
				}
			}
		}
	}
}
