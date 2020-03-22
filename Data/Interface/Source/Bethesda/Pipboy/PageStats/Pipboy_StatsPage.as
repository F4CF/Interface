package
{
	public class Pipboy_StatsPage extends PipboyPage
	{
		 
		
		public var StatusTab_mc:PipboyTab;
		
		public var SPECIALTab_mc:PipboyTab;
		
		public var PerksTab_mc:PipboyTab;
		
		private var tabs:Vector.<PipboyTab>;
		
		public function Pipboy_StatsPage()
		{
			super();
			_TabNames = new Array("$PipboyConditionCategory","$PipboySPECIALCategory","$PipboyPerksCategory");
			this.tabs = new <PipboyTab>[this.StatusTab_mc,this.SPECIALTab_mc,this.PerksTab_mc];
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
			var _loc2_:* = undefined;
			super.InitCodeObj(param1);
			for each(_loc2_ in this.tabs)
			{
				_loc2_.InitCodeObj(param1);
			}
		}
		
		override public function ReleaseCodeObj() : *
		{
			var _loc1_:* = undefined;
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
	}
}
