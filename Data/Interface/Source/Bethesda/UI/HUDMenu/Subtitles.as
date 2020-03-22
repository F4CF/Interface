package
{
	import Shared.AS3.BSUIComponent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import scaleform.gfx.TextFieldEx;
	
	public dynamic class Subtitles extends BSUIComponent
	{
		 
		
		public var SpeakerName_tf:TextField;
		
		public var SubtitleText_tf:TextField;
		
		public function Subtitles()
		{
			super();
			this.SpeakerName_tf.autoSize = TextFieldAutoSize.CENTER;
			this.SubtitleText_tf.autoSize = TextFieldAutoSize.NONE;
		}
		
		public function set VerticalAutoSize(param1:String) : *
		{
			TextFieldEx.setVerticalAutoSize(this.SubtitleText_tf,param1);
		}
	}
}
