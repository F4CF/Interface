package
{
	import Pipboy.COMPANIONAPP.MobileBackButtonEvent;
	import Shared.AS3.BSButtonHintData;
	import Shared.BGSExternalInterface;
	
	public class PipboyPage extends PipboySubMenu
	{
		
		public static const LOWER_PIPBOY_ALLOW_CHANGE:String = "PipboyPage::LowerPipboyAllowedChange";
		
		public static const BOTTOM_BAR_UPDATE:String = "PipboyPage::BottomBarUpdate";
		 
		
		protected var _TabNames:Array;
		
		protected var _buttonHintDataV:Vector.<BSButtonHintData>;
		
		public function PipboyPage()
		{
			super();
			this._buttonHintDataV = new Vector.<BSButtonHintData>();
			this.PopulateButtonHintData();
		}
		
		public function get TabNames() : Array
		{
			return this._TabNames;
		}
		
		override public function onAddedToStage() : void
		{
			super.onAddedToStage();
			MobileBackButtonEvent.Register(stage,this.onMobileBackButtonPressed);
		}
		
		override public function onRemovedFromStage() : void
		{
			MobileBackButtonEvent.Unregister(stage,this.onMobileBackButtonPressed);
			super.onRemovedFromStage();
		}
		
		public function get buttonHintDataV() : Vector.<BSButtonHintData>
		{
			return this._buttonHintDataV;
		}
		
		protected function PopulateButtonHintData() : *
		{
		}
		
		public function CanSwitchFromCurrentPage() : Boolean
		{
			return true;
		}
		
		public function CanSwitchTabs(param1:uint) : Boolean
		{
			return this._TabNames != null && param1 < this._TabNames.length;
		}
		
		public function CanLowerPipboy() : Boolean
		{
			return true;
		}
		
		private function onMobileBackButtonPressed(param1:MobileBackButtonEvent) : void
		{
			var _loc2_:Boolean = this.HandleMobileBackButton();
			BGSExternalInterface.call(BGSCodeObj,"onBackButtonHandled",_loc2_);
		}
		
		protected function HandleMobileBackButton() : Boolean
		{
			return false;
		}
	}
}
