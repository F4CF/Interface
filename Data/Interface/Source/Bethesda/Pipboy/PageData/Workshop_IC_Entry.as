package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class Workshop_IC_Entry extends BSUIComponent
	{
		 
		
		public var Label_tf:TextField;
		
		public var Value_tf:TextField;
		
		public var Alert_mc:MovieClip;
		
		private var _LabelText:String;
		
		private var _Value:uint;
		
		private var _Rating:int;
		
		public function Workshop_IC_Entry()
		{
			super();
			this._LabelText = "";
			this._Value = 0;
			this._Rating = 0;
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
		}
		
		public function set label(param1:String) : *
		{
			this._LabelText = param1;
			SetIsDirty();
		}
		
		public function SetData(param1:Object) : *
		{
			this._Value = param1.value;
			this._Rating = param1.rating;
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			GlobalFunc.SetText(this.Label_tf,this._LabelText,false);
			GlobalFunc.SetText(this.Value_tf,this._Value.toString(),false);
			switch(this._Rating)
			{
				case -1:
					this.Alert_mc.gotoAndStop("Alert");
					break;
				case 0:
					this.Alert_mc.gotoAndStop("None");
					break;
				case 1:
					this.Alert_mc.gotoAndStop("Increasing");
			}
		}
	}
}
