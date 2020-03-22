package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.IMenu;
	
	public class PlayBinkMenu extends IMenu
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		protected var buttonHint_Skip:BSButtonHintData;
		
		public function PlayBinkMenu()
		{
			this.buttonHint_Skip = new BSButtonHintData("$SKIP","T","PSN_Y","Xenon_Y",1,null);
			super();
			this.BGSCodeObj = new Object();
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.buttonHint_Skip);
			this.buttonHint_Skip.ButtonVisible = false;
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
			this.__setProp_ButtonHintBar_mc_MenuObj_Layer1_0();
		}
		
		public function set allowConfirm(param1:Boolean) : *
		{
			this.buttonHint_Skip.ButtonVisible = param1;
		}
		
		function __setProp_ButtonHintBar_mc_MenuObj_Layer1_0() : *
		{
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ButtonHintBar_mc.BackgroundAlpha = 1;
			this.ButtonHintBar_mc.BackgroundColor = 0;
			this.ButtonHintBar_mc.bracketCornerLength = 6;
			this.ButtonHintBar_mc.bracketLineWidth = 1.5;
			this.ButtonHintBar_mc.BracketStyle = "horizontal";
			this.ButtonHintBar_mc.bRedirectToButtonBarMenu = true;
			this.ButtonHintBar_mc.bShowBrackets = false;
			this.ButtonHintBar_mc.bUseShadedBackground = false;
			this.ButtonHintBar_mc.ShadedBackgroundMethod = "Shader";
			this.ButtonHintBar_mc.ShadedBackgroundType = "normal";
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
