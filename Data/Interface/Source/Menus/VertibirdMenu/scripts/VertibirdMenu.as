package
{
	import Shared.IMenu;
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	
	public class VertibirdMenu extends IMenu
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		protected var buttonHint_Land:BSButtonHintData;
		
		public function VertibirdMenu()
		{
			this.buttonHint_Land = new BSButtonHintData("$LAND","E","PSN_A","Xenon_A",1,this.onLand);
			super();
			this.BGSCodeObj = new Object();
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.buttonHint_Land);
			this.buttonHint_Land.ButtonVisible = true;
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		public function set canLand(param1:Boolean) : *
		{
			this.buttonHint_Land.ButtonEnabled = param1;
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!param2)
			{
				if(param1 == "Land")
				{
					this.onLand();
				}
			}
			return _loc3_;
		}
		
		private function onLand() : *
		{
			if(this.buttonHint_Land.ButtonEnabled)
			{
				this.BGSCodeObj.Land();
			}
		}
	}
}
