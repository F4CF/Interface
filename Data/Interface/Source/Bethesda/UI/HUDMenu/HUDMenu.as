package
{
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.display.MovieClip;
	import scaleform.gfx.Extensions;
	
	public dynamic class HUDMenu extends IMenu
	{
		 
		
		public var FloatingQuestMarkerBase:MovieClip;
		
		public var HUDNotificationsGroup_mc:MovieClip;
		
		public var TopCenterGroup_mc:MovieClip;
		
		public var TopRightGroup_mc:MovieClip;
		
		public var CenterGroup_mc:MovieClip;
		
		public var LeftMeters_mc:MovieClip;
		
		public var BottomCenterGroup_mc:MovieClip;
		
		public var RightMeters_mc:MovieClip;
		
		public var SafeRect_mc:MovieClip;
		
		public var BGSCodeObj:Object;
		
		public function HUDMenu()
		{
			super();
			this.BGSCodeObj = new Object();
			Extensions.enabled = true;
		}
		
		override protected function onSetSafeRect() : void
		{
			GlobalFunc.LockToSafeRect(this.HUDNotificationsGroup_mc,"TL",SafeX,SafeY);
			GlobalFunc.LockToSafeRect(this.TopCenterGroup_mc,"TC",SafeX,SafeY);
			GlobalFunc.LockToSafeRect(this.TopRightGroup_mc,"TR",SafeX,SafeY);
			GlobalFunc.LockToSafeRect(this.CenterGroup_mc,"CC",SafeX,SafeY);
			GlobalFunc.LockToSafeRect(this.LeftMeters_mc,"BL",SafeX,SafeY);
			GlobalFunc.LockToSafeRect(this.BottomCenterGroup_mc,"BC",SafeX,SafeY);
			GlobalFunc.LockToSafeRect(this.RightMeters_mc,"BR",SafeX,SafeY);
		}
		
		public function onCodeObjCreate() : *
		{
			(this.RightMeters_mc.PowerArmorLowBatteryWarning_mc.WarningTextHolder_mc as PAWarningText).codeObj = this.BGSCodeObj;
		}
		
		public function onCodeObjDestruction() : *
		{
			this.BGSCodeObj = null;
			(this.RightMeters_mc.PowerArmorLowBatteryWarning_mc.WarningTextHolder_mc as PAWarningText).codeObj = null;
		}
	}
}
