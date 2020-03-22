package
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class HUDMessageItem extends HUDFadingListItem
	{
		 
		
		public var HUDMessageItemInternal_mc:MovieClip;
		
		private var BaseTextFieldWidth:uint = 0;
		
		private var _data:HUDMessageItemData = null;
		
		public function HUDMessageItem()
		{
			super();
			addFrameScript(4,this.frame5,12,this.frame13,84,this.frame85);
			this.BaseTextFieldWidth = this.MessageText_tf.width;
			this.MessageText_tf.autoSize = TextFieldAutoSize.LEFT;
			this.MessageText_tf.multiline = true;
		}
		
		public function get data() : HUDMessageItemData
		{
			return this._data;
		}
		
		public function set data(param1:HUDMessageItemData) : void
		{
			this._data = param1;
			SetIsDirty();
		}
		
		private function get MessageText_tf() : TextField
		{
			return this.HUDMessageItemInternal_mc.MessageText_tf as TextField;
		}
		
		private function get RadioStationIcon_mc() : MovieClip
		{
			return this.HUDMessageItemInternal_mc.RadioStationIcon_mc as MovieClip;
		}
		
		public function CalcIconWidth() : uint
		{
			var _loc1_:uint = 0;
			if(this.data.isRadioStation)
			{
				if(this.data.isRadioStation)
				{
					_loc1_ = _loc1_ + (this.RadioStationIcon_mc.width + 2);
				}
			}
			return _loc1_;
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:uint = 0;
			if(this.data)
			{
				visible = true;
				this.RadioStationIcon_mc.visible = this.data.isRadioStation;
				_loc1_ = this.CalcIconWidth();
				this.MessageText_tf.width = this.BaseTextFieldWidth - _loc1_;
				this.MessageText_tf.x = _loc1_;
				GlobalFunc.SetText(this.MessageText_tf,this.data.messageText,true);
				this.RadioStationIcon_mc.y = this.MessageText_tf.height * 0.5;
			}
			else
			{
				visible = false;
			}
		}
		
		function frame5() : *
		{
			stop();
		}
		
		function frame13() : *
		{
			OnFadeInComplete();
			stop();
		}
		
		function frame85() : *
		{
			OnFadeOutComplete();
			stop();
		}
	}
}
