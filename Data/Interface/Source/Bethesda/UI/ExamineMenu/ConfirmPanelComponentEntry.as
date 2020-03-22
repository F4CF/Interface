package
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ConfirmPanelComponentEntry extends MovieClip
	{
		 
		
		public var textField:TextField;
		
		public var Background_mc:MovieClip;
		
		private var ComponentName:String;
		
		private var ComponentRequiredCount:uint;
		
		private var ComponentInventoryCount:uint;
		
		public function ConfirmPanelComponentEntry(param1:*)
		{
			super();
			this.ComponentName = param1;
			this.ComponentRequiredCount = 0;
			this.ComponentInventoryCount = uint.MAX_VALUE;
		}
		
		public function get componentName() : String
		{
			return this.ComponentName;
		}
		
		public function get componentRequiredCount() : uint
		{
			return this.ComponentRequiredCount;
		}
		
		public function set componentRequiredCount(param1:uint) : *
		{
			this.ComponentRequiredCount = param1;
			this.UpdateText();
		}
		
		public function get componentInventoryCount() : uint
		{
			return this.ComponentInventoryCount;
		}
		
		public function set componentInventoryCount(param1:uint) : *
		{
			this.ComponentInventoryCount = param1;
			this.UpdateText();
		}
		
		public function UpdateText() : *
		{
			if(this.ComponentInventoryCount < uint.MAX_VALUE)
			{
				GlobalFunc.SetText(this.textField,this.ComponentName + " (" + Math.min(this.ComponentInventoryCount,this.ComponentRequiredCount).toString() + "/" + this.ComponentRequiredCount.toString() + ")",false);
			}
			else if(this.ComponentRequiredCount > 1)
			{
				GlobalFunc.SetText(this.textField,this.ComponentName + " (" + this.ComponentRequiredCount.toString() + ")",false);
			}
			else
			{
				GlobalFunc.SetText(this.textField,this.ComponentName,false);
			}
			this.textField.alpha = this.ComponentInventoryCount < this.ComponentRequiredCount?Number(GlobalFunc.DIMMED_ALPHA):Number(1);
			this.Background_mc.visible = this.ComponentName != "";
		}
	}
}
