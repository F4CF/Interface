package
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public dynamic class HUDObjectiveItem extends HUDFadingListItem
	{
		 
		
		public var HUDObjectiveItemInternal_mc:MovieClip;
		
		private var _data:HUDObjectiveItemData = null;
		
		public function HUDObjectiveItem()
		{
			super();
			addFrameScript(4,this.frame5,18,this.frame19,236,this.frame237,262,this.frame263);
			this.ObjectiveMessage_tf.autoSize = TextFieldAutoSize.LEFT;
			this.ObjectiveMessage_tf.multiline = true;
			this.ObjectiveMessage_tf.wordWrap = true;
			bUseShadedBackground = true;
		}
		
		public function get data() : HUDObjectiveItemData
		{
			return this._data;
		}
		
		public function set data(param1:HUDObjectiveItemData) : void
		{
			this._data = param1;
			SetIsDirty();
		}
		
		private function get ObjectiveMessage_tf() : TextField
		{
			return this.HUDObjectiveItemInternal_mc.ObjectiveMessage_tf as TextField;
		}
		
		private function get ObjectiveIcons_mc() : MovieClip
		{
			return this.HUDObjectiveItemInternal_mc.ObjectiveIcons_mc as MovieClip;
		}
		
		override public function redrawUIComponent() : void
		{
			if(this.data)
			{
				visible = fadeInStarted;
				this.ObjectiveIcons_mc.visible = this.data.isCompleted;
				if(this.data.isCompleted)
				{
					this.ObjectiveIcons_mc.gotoAndPlay("Completed");
				}
				GlobalFunc.SetText(this.ObjectiveMessage_tf,this.data.ObjectiveMessage,true);
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
		
		function frame19() : *
		{
			OnFadeInComplete();
			stop();
		}
		
		function frame237() : *
		{
			OnFastFadeOutStarted();
		}
		
		function frame263() : *
		{
			OnFadeOutComplete();
			stop();
		}
	}
}
