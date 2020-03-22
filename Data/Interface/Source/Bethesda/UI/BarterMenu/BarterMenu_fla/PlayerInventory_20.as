package BarterMenu_fla
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public dynamic class PlayerInventory_20 extends MovieClip
	{
		 
		
		public var RightHitBox_tf:TextField;
		
		public var PlayerCaps_tf:TextField;
		
		public var LeftHitBox_tf:TextField;
		
		public var PlayerListHeader:ListHeader;
		
		public var PlayerList_mc:PlayerList;
		
		public var PlayerBracketBackground_mc:MovieClip;
		
		public var PlayerSwitchButton_tf:TextField;
		
		public function PlayerInventory_20()
		{
			super();
			this.__setProp_PlayerList_mc_PlayerInventory_Layer1_0();
		}
		
		function __setProp_PlayerList_mc_PlayerInventory_Layer1_0() : *
		{
			try
			{
				this.PlayerList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.PlayerList_mc.listEntryClass = "PlayerListEntry";
			this.PlayerList_mc.numListItems = 9;
			this.PlayerList_mc.restoreListIndex = true;
			this.PlayerList_mc.textOption = "Shrink To Fit";
			this.PlayerList_mc.verticalSpacing = -3;
			try
			{
				this.PlayerList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
