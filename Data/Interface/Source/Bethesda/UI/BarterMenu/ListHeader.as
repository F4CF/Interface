package
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class ListHeader extends MovieClip
	{
		 
		
		public var textField:TextField;
		
		public var LeftArrow:MovieClip;
		
		public var RightArrow:MovieClip;
		
		public function ListHeader()
		{
			super();
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.textField,"shrink");
		}
		
		public function get headerText() : String
		{
			return this.textField.text;
		}
		
		public function get headerWidth() : *
		{
			return this.RightArrow.x + this.RightArrow.width;
		}
		
		public function set headerText(param1:String) : void
		{
			var _loc2_:TextLineMetrics = null;
			if(this.textField && param1)
			{
				GlobalFunc.SetText(this.textField,param1,false);
				_loc2_ = this.textField.getLineMetrics(0);
				this.RightArrow.x = this.textField.x + _loc2_.width + 10;
			}
		}
		
		public function SetArrowVisibility(param1:Boolean) : *
		{
			this.LeftArrow.visible = param1;
			this.RightArrow.visible = param1;
		}
	}
}
