package
{
	import Shared.AS3.BSButtonHintData;
	
	public class PipboyTab extends PipboySubMenu
	{
		 
		
		private var _TabIndex:uint;
		
		public function PipboyTab()
		{
			super();
		}
		
		public function get TabIndex() : uint
		{
			return this._TabIndex;
		}
		
		public function set TabIndex(param1:uint) : *
		{
			this._TabIndex = param1;
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			super.onPipboyChangeEvent(param1);
			this.visible = param1.DataObj.CurrentTab == this._TabIndex;
		}
		
		public function PopulateButtonHintData(param1:Vector.<BSButtonHintData>) : *
		{
		}
	}
}
