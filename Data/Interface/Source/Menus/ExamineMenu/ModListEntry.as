package
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ModListEntry extends BSScrollingListEntry
	{
		 
		
		public var count:TextField;
		
		public var taggedIcon_mc:MovieClip;
		
		private var DIMMMED_TEXT_VALUE:Number = 0.3;
		
		public function ModListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			var _loc4_:String = null;
			super.SetEntryText(param1,param2);
			var _loc3_:* = Math.log(param1.filterIndex) / Math.log(2);
			if(param1.usedCount != undefined && param1.componentCountA != undefined && _loc3_ < param1.componentCountA.length)
			{
				if(param1.componentCountA[_loc3_] == undefined)
				{
					param1.componentCountA[_loc3_] = 0;
				}
				this.count.text = (param1.usedCount * param1.componentCountA[_loc3_]).toString() + "/" + param1.componentCountA[_loc3_];
			}
			else
			{
				this.count.text = "";
			}
			if(param1.accountedFor != null && param1.requiredCount != null)
			{
				_loc4_ = param1.text + " " + param1.accountedFor + "/" + param1.requiredCount;
				textField.alpha = param1.betcText != true && param1.accountedFor < param1.requiredCount?Number(this.DIMMMED_TEXT_VALUE):Number(1);
			}
			else
			{
				_loc4_ = param1.text;
				textField.alpha = param1.betcText == true || param1.enabled || param1.hasRequired?Number(1):Number(this.DIMMMED_TEXT_VALUE);
			}
			if(param1.text != undefined)
			{
				if(param1.betcText == true)
				{
					GlobalFunc.SetText(textField,"$More...",false);
					this.count.text = "";
					if(param1.validUnshownMod != true)
					{
						textField.alpha = this.DIMMMED_TEXT_VALUE;
					}
				}
				else
				{
					GlobalFunc.SetText(textField,param1.count > 1?_loc4_ + " (" + param1.count + ")":_loc4_,false);
				}
			}
			if(param1.taggedForSearch == true)
			{
				this.taggedIcon_mc.visible = true;
			}
			else
			{
				this.taggedIcon_mc.visible = false;
			}
			this.count.textColor = 16777215;
			textField.textColor = 16777215;
			border.alpha = 0.25;
		}
	}
}
