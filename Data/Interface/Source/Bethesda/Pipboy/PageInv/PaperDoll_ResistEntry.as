package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class PaperDoll_ResistEntry extends BSUIComponent
	{
		 
		
		public var Icon_mc:MovieClip;
		
		public var Value_tf:TextField;
		
		private var _IconType:uint;
		
		private var _Value:Number;
		
		public function PaperDoll_ResistEntry()
		{
			super();
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
		}
		
		public function SetData(param1:uint, param2:Number) : *
		{
			this._IconType = param1;
			this._Value = param2;
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			this.Icon_mc.gotoAndStop(this._IconType);
			GlobalFunc.SetText(this.Value_tf,Math.round(this._Value).toString(),false);
		}
	}
}
