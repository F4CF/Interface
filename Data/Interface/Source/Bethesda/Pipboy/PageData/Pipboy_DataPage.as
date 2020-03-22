package
{
	public class Pipboy_DataPage extends PipboyPage
	{
		 
		
		public var QuestsTab_mc:PipboyTab;
		
		public var WorkshopsTab_mc:PipboyTab;
		
		public var StatsTab_mc:PipboyTab;
		
		private var tabs:Vector.<PipboyTab>;
		
		public function Pipboy_DataPage()
		{
			super();
			_TabNames = new Array("$QUESTS","$SANCTUARY","$LOG");
			this.tabs = new <PipboyTab>[this.QuestsTab_mc,this.WorkshopsTab_mc,this.StatsTab_mc];
			var _loc1_:uint = 0;
			while(_loc1_ < this.tabs.length)
			{
				this.tabs[_loc1_].TabIndex = _loc1_;
				this.tabs[_loc1_].PopulateButtonHintData(_buttonHintDataV);
				_loc1_++;
			}
		}
		
		override public function InitCodeObj(param1:Object) : *
		{
			var _loc2_:PipboyTab = null;
			super.InitCodeObj(param1);
			for each(_loc2_ in this.tabs)
			{
				_loc2_.InitCodeObj(param1);
			}
		}
		
		override public function ReleaseCodeObj() : *
		{
			var _loc1_:PipboyTab = null;
			for each(_loc1_ in this.tabs)
			{
				_loc1_.ReleaseCodeObj();
			}
			super.ReleaseCodeObj();
		}
		
		override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc4_:* = undefined;
			var _loc3_:Boolean = false;
			for each(_loc4_ in this.tabs)
			{
				if(_loc4_.visible)
				{
					_loc3_ = _loc4_.ProcessUserEvent(param1,param2);
				}
			}
			return _loc3_;
		}
		
		override public function GetIsUsingRightStick() : Boolean
		{
			var _loc2_:PipboyTab = null;
			var _loc1_:Boolean = false;
			for each(_loc2_ in this.tabs)
			{
				_loc1_ = _loc1_ || _loc2_.GetIsUsingRightStick();
			}
			return _loc1_;
		}
		
		override public function onRightThumbstickInput(param1:uint) : *
		{
			var _loc2_:PipboyTab = null;
			for each(_loc2_ in this.tabs)
			{
				if(_loc2_.visible)
				{
					_loc2_.onRightThumbstickInput(param1);
				}
			}
		}
	}
}
