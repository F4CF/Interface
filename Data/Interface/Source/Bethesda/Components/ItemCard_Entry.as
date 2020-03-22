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

		public static function ShouldShowDifference(aInfoObj:Object) : Boolean
		{
			var precision:uint = aInfoObj.precision != undefined?uint(aInfoObj.precision):uint(0);
			var smallestStep:Number = 1;
			for(var radix:uint = 0; radix < precision; radix++)
			{
				smallestStep = smallestStep / 10;
			}
			return Math.abs(aInfoObj.difference) >= smallestStep;
		}

		public function PopulateEntry(aInfoObj:Object) : *
		{
			var valueText:* = null;
			var val:Number = NaN;
			var precision:uint = 0;
			var indexOfDecimal:* = undefined;


			if(this.Label_tf != null)
			{
				GlobalFunc.SetText(this.Label_tf,aInfoObj.text,false);
			}


			if(this.Value_tf != null)
			{
				if(aInfoObj.value is String)
				{
					valueText = aInfoObj.value;
				}
				else
				{
					val = aInfoObj.value;
					if(aInfoObj.scaleWithDuration)
					{
						val = val * aInfoObj.duration;
					}
					valueText = val.toString();
					precision = aInfoObj.precision != undefined?uint(aInfoObj.precision):uint(0);
					indexOfDecimal = valueText.indexOf(".");
					if(indexOfDecimal > -1)
					{
						if(precision)
						{
							valueText = valueText.substring(0,Math.min(indexOfDecimal + precision + 1,valueText.length));
						}
						else
						{
							valueText = valueText.substring(0,indexOfDecimal);
						}
					}
					if(aInfoObj.showAsPercent)
					{
						valueText = valueText + "%";
					}
				}
				GlobalFunc.SetText(this.Value_tf,valueText,false);
			}


			if(this.Comparison_mc != null && ShouldShowDifference(aInfoObj))
			{
				switch(aInfoObj.diffRating)
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
