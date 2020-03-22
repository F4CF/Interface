package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.IMenu;
	
	public class TerminalButtons extends IMenu
	{
		 
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var BGSCodeObj:Object;
		
		private var ExitButton:BSButtonHintData;
		
		private var HolotapeButton:BSButtonHintData;
		
		public function TerminalButtons()
		{
			this.ExitButton = new BSButtonHintData("$Exit","Tab","PSN_B","Xenon_B",1,this.onExitPressed);
			this.HolotapeButton = new BSButtonHintData("","R","PSN_X","Xenon_X",1,this.onHolotapeButtonPressed);
			super();
			this.BGSCodeObj = new Object();
			this.PopulateButtonBar();
		}
		
		private function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.ExitButton);
			_loc1_.push(this.HolotapeButton);
			this.HolotapeButton.ButtonVisible = false;
			this.HolotapeButton.ButtonEnabled = false;
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		private function onExitPressed() : void
		{
			this.BGSCodeObj.BackLevel();
		}
		
		public function SetExitButtonText(param1:String) : void
		{
			this.ExitButton.ButtonText = param1;
		}
		
		public function SetHolotapeButtonText(param1:String) : void
		{
			this.HolotapeButton.ButtonText = param1;
		}
		
		public function ToggleHolotapeButtonState() : *
		{
			this.HolotapeButton.ButtonVisible = true;
			this.HolotapeButton.ButtonEnabled = !this.HolotapeButton.ButtonEnabled;
		}
		
		private function onHolotapeButtonPressed() : void
		{
			this.BGSCodeObj.HolotapeActivate();
		}
	}
}
