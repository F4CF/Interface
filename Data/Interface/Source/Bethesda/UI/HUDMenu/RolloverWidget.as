package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public dynamic class RolloverWidget extends BSUIComponent
	{
		 
		
		public var RolloverName_tf:TextField;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var LegendaryIcon_mc:MovieClip;
		
		public var TaggedForSearchIcon_mc:MovieClip;
		
		public var ActivateButton:BSButtonHintData;
		
		public var PlayHolotapeButton:BSButtonHintData;
		
		public function RolloverWidget()
		{
			this.ActivateButton = new BSButtonHintData("","E","PSN_A","Xenon_A",1,null);
			this.PlayHolotapeButton = new BSButtonHintData("$PLAY","R","PSN_X","Xenon_X",1,null);
			super();
			this.PopulateButtonBar();
			Extensions.enabled = true;
			this.RolloverName_tf.autoSize = TextFieldAutoSize.CENTER;
			this.RolloverName_tf.text = " ";
			TextFieldEx.setVerticalAlign(this.RolloverName_tf,TextFieldEx.VALIGN_BOTTOM);
			this.AdjustRolloverPositions();
			this.__setProp_ButtonHintBar_mc_RolloverWidget_ButtonHintBar_mc_0();
		}
		
		private function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.ActivateButton);
			_loc1_.push(this.PlayHolotapeButton);
			this.ActivateButton.ButtonVisible = false;
			this.PlayHolotapeButton.ButtonVisible = false;
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		public function AdjustRolloverPositions() : *
		{
			var _loc1_:Number = this.RolloverName_tf.height;
			this.LegendaryIcon_mc.y = this.RolloverName_tf.y + 10;
			this.LegendaryIcon_mc.x = this.RolloverName_tf.getLineMetrics(0).x + this.RolloverName_tf.x - this.LegendaryIcon_mc.width - 5;
			this.TaggedForSearchIcon_mc.y = this.RolloverName_tf.y + 15;
			this.TaggedForSearchIcon_mc.x = this.RolloverName_tf.getLineMetrics(0).x + this.RolloverName_tf.x - this.TaggedForSearchIcon_mc.width - 5;
		}
		
		function __setProp_ButtonHintBar_mc_RolloverWidget_ButtonHintBar_mc_0() : *
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
			this.ButtonHintBar_mc.bRedirectToButtonBarMenu = false;
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
