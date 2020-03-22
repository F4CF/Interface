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

		public function set headerText(strText:String) : void
		{
			var metrics:TextLineMetrics = null;
			if(this.textField && strText)
			{
				GlobalFunc.SetText(this.textField,strText,false);
				metrics = this.textField.getLineMetrics(0);
				this.RightArrow.x = this.textField.x + metrics.width + 10;
			}
		}

		public function SetArrowVisibility(abVisible:Boolean) : *
		{
			this.LeftArrow.visible = abVisible;
			this.RightArrow.visible = abVisible;
		}


	}
}
