package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public dynamic class TutorialText extends BSUIComponent
	{
		 
		
		public var TutorialHeads_mc:MovieClip;
		
		public var TutorialText_tf:TextField;
		
		private var _numberOfHeads:uint = 3;
		
		public function TutorialText()
		{
			super();
		}
		
		public function get numberOfHeads() : uint
		{
			return this._numberOfHeads;
		}
		
		public function set numberOfHeads(param1:uint) : void
		{
			if(this._numberOfHeads != param1)
			{
				this._numberOfHeads = param1;
				SetIsDirty();
			}
		}
		
		public function SetText(param1:String) : *
		{
			var _loc2_:uint = Math.floor(Math.random() * this.numberOfHeads);
			this.TutorialHeads_mc.gotoAndPlay("Head_0" + _loc2_);
			this.TutorialText_tf.autoSize = TextFieldAutoSize.LEFT;
			GlobalFunc.SetText(this.TutorialText_tf,param1,true);
			SetIsDirty();
		}
	}
}
