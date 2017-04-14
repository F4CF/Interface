package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.IMenu;
	
	public class ScopeMenu extends IMenu
	{
		 
		
		public var ButtonHintInstance:BSButtonHintBar;
		
		private var HoldBreathButton:BSButtonHintData;
		
		private var HoldBreathButtonForVita:BSButtonHintData;
		
		public function ScopeMenu()
		{
			this.HoldBreathButton = new BSButtonHintData("$Hold Breath","Alt","PSN_L3","Xenon_L3",1,null);
			this.HoldBreathButtonForVita = new BSButtonHintData("$Hold Breath","Alt","_DPad_Down","Xenon_L3",1,null);
			super();
			addFrameScript(0,this.frame1);
			this.HoldBreathButtonForVita.ButtonVisible = false;
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.HoldBreathButton);
			_loc1_.push(this.HoldBreathButtonForVita);
			this.ButtonHintInstance.SetButtonHintData(_loc1_);
		}
		
		public function SetIsVita(param1:Boolean) : *
		{
			if(param1)
			{
				this.HoldBreathButton.ButtonVisible = false;
				this.HoldBreathButtonForVita.ButtonVisible = true;
			}
			else
			{
				this.HoldBreathButton.ButtonVisible = true;
				this.HoldBreathButtonForVita.ButtonVisible = false;
			}
		}
		
		public function SetOverlay(param1:uint) : *
		{
			this.gotoAndStop(param1 + 1);
		}
		
		function frame1() : *
		{
			stop();
		}
	}
}
