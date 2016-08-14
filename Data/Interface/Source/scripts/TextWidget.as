package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import Shared.GlobalFunc;
	import flash.text.TextFieldAutoSize;


	public class TextWidget extends MovieClip
	{

		public var textField_tf:TextField;


		public function TextWidget()
		{
			super();
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.textField_tf.autoSize = TextFieldAutoSize.LEFT;
		}


		public function SetTextFormatProp(param1:String, param2:Object) : *
		{
			var _loc3_:TextFormat = this.textField_tf.getTextFormat();
			_loc3_[param1] = param2;
			this.textField_tf.setTextFormat(_loc3_);
			this.textField_tf.defaultTextFormat = _loc3_;
			if("align" == param1)
			{
				this.textField_tf.autoSize = param2.toString();
			}
		}


		public function SetText(param1:String, param2:* = false) : *
		{
			GlobalFunc.SetText(this.textField_tf, param1, param2);
		}


		public function SetDimensions(param1:uint, param2:uint) : *
		{
			this.textField_tf.width = param1;
			this.textField_tf.height = param2;
		}



	}
}
