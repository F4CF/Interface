package
{
	import flash.display.MovieClip;
	import Shared.AS3.BSScrollingList;
	import flash.events.Event;
	
	public class TurretHack extends MovieClip
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var List_mc:BSScrollingList;
		
		public function TurretHack()
		{
			super();
			this.BGSCodeObj = new Object();
			stage.stageFocusRect = false;
			this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onListItemPress);
			this.List_mc.visible = false;
			this.__setProp_List_mc_Scene1_Layer7_0();
		}
		
		public function InitProgram() : *
		{
			this.List_mc.entryList = [{
				"text":"shutdown",
				"enabled":this.BGSCodeObj.getTextReplaceID("OnStatus") != 1135569
			},{
				"text":"watchdog",
				"enabled":this.BGSCodeObj.getTextReplaceID("Faction") == 7
			},{
				"text":"killkillkill",
				"enabled":this.BGSCodeObj.getTextReplaceValue("Frenzied") == 1
			},{
				"text":"asplode",
				"enabled":this.BGSCodeObj.getTextReplaceValue("Sabotaged") == 1
			}];
			this.List_mc.InvalidateData();
			stage.focus = this.List_mc;
			this.List_mc.selectedIndex = 0;
			this.List_mc.visible = true;
		}
		
		private function onListItemPress(param1:Event) : *
		{
			switch(this.List_mc.selectedIndex)
			{
				case 0:
					this.BGSCodeObj.notifyScripts("SetTurretStatusOff");
					break;
				case 1:
					this.BGSCodeObj.notifyScripts("SetTurretStatusFriend");
					break;
				case 2:
					this.BGSCodeObj.notifyScripts("SetTurretStatusFrenzy");
					break;
				case 3:
					this.BGSCodeObj.notifyScripts("SetTurretStatusDestroy");
			}
			if(!this.List_mc.selectedEntry.enabled)
			{
				this.List_mc.selectedEntry.enabled = true;
			}
			this.List_mc.UpdateList();
		}
		
		function __setProp_List_mc_Scene1_Layer7_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.disableSelection = false;
			this.List_mc.listEntryClass = "TurretListEntry";
			this.List_mc.numListItems = 4;
			this.List_mc.restoreListIndex = false;
			this.List_mc.textOption = "None";
			this.List_mc.verticalSpacing = 0;
			try
			{
				this.List_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
