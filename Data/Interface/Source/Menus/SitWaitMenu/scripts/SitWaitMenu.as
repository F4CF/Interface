package
{
	import Shared.IMenu;
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	
	public class SitWaitMenu extends IMenu
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		protected var buttonHint_Wait:BSButtonHintData;
		
		public function SitWaitMenu()
		{
			this.buttonHint_Wait = new BSButtonHintData("$Wait","T","PSN_Y","Xenon_Y",1,this.onWaitButtonClicked);
			super();
			this.BGSCodeObj = new Object();
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.buttonHint_Wait);
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!param2)
			{
				if(param1 == "StartWait" && this.buttonHint_Wait.ButtonVisible && this.buttonHint_Wait.ButtonEnabled)
				{
					this.onWaitButtonClicked();
					_loc3_ = true;
				}
			}
			return _loc3_;
		}
		
		private function onWaitButtonClicked() : *
		{
			this.BGSCodeObj.StartWaiting();
		}
	}
}
