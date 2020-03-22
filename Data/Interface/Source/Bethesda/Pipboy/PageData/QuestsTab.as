package
{
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.AS3.COMPANIONAPP.PipboyLoader;
	import Shared.BGSExternalInterface;
	import Shared.GlobalFunc;
	import Shared.PlatformChangeEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	public class QuestsTab extends PipboyTab
	{
		 
		
		public var QuestsList_mc:BSScrollingList;
		
		public var ObjectivesList_mc:BSScrollingList;
		
		public var Description_tf:TextField;
		
		public var VaultBoyHolder_mc:MovieClip;
		
		private var Quest_VaultBoyLoader:PipboyLoader;
		
		private var Quest_DefaultBoy_mc:MovieClip;
		
		private var _ShowingSummary:Boolean;
		
		private var Quest_VaultBoy_LoadPending:Boolean;
		
		private var _ObjectivesListActive:Boolean;
		
		private var _DescText:String;
		
		private var ShowOnMapButton:BSButtonHintData;
		
		private var ShowSummaryButton:BSButtonHintData;
		
		private var NavigateObjectivesButton:BSButtonHintData;
		
		private var ToggleActiveButton:BSButtonHintData;
		
		private var _DefaultObjectivesListTop:Number;
		
		private const _ObjectivesListBuffer:Number = 7;
		
		public function QuestsTab()
		{
			this.ShowOnMapButton = new BSButtonHintData("$Show on Map","R","PSN_X","Xenon_X",1,this.onShowOnMap);
			this.ShowSummaryButton = new BSButtonHintData("$ShowQuestSummary","C","PSN_L1","Xenon_L1",1,this.onShowSummary);
			this.NavigateObjectivesButton = new BSButtonHintData("$NavigateObjectives","","PSN_RS","Xenon_RS",1,this.onNavigateObjectives);
			this.ToggleActiveButton = new BSButtonHintData("$ToggleActive","","PSN_A","Xenon_A",1,this.onToggleActivate);
			super();
			this.QuestsList_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onQuestSelectionChange);
			this.QuestsList_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onQuestPress);
			this.ObjectivesList_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onObjectiveSelectionChange);
			this.ObjectivesList_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onObjectivePress);
			this._ObjectivesListActive = false;
			this.Quest_VaultBoyLoader = new PipboyLoader();
			this._ShowingSummary = false;
			this.Quest_DefaultBoy_mc = new Quest_DefaultBoy();
			this.Quest_VaultBoy_LoadPending = true;
			this._DescText = "";
			this.__setProp_ObjectivesList_mc_QuestsTab_Objectives_0();
			this.__setProp_QuestsList_mc_QuestsTab_Quests_0();
		}
		
		override public function PopulateButtonHintData(param1:Vector.<BSButtonHintData>) : *
		{
			param1.push(this.ToggleActiveButton);
			param1.push(this.ShowOnMapButton);
			param1.push(this.ShowSummaryButton);
			param1.push(this.NavigateObjectivesButton);
			this.ShowOnMapButton.ButtonVisible = false;
			this.ShowSummaryButton.ButtonVisible = false;
			this.NavigateObjectivesButton.ButtonVisible = false;
			this.ToggleActiveButton.ButtonVisible = false;
			this._DefaultObjectivesListTop = this.ObjectivesList_mc.y;
		}
		
		override protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.Quest;
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			var _loc2_:* = this.visible == true;
			super.onPipboyChangeEvent(param1);
			var _loc3_:* = this.visible == true;
			var _loc4_:Boolean = false;
			if(CompanionAppMode.isOn)
			{
				if(!_loc2_ && _loc3_)
				{
					this.QuestsList_mc.scrollList.needFullRefresh = true;
				}
			}
			this.QuestsList_mc.entryList = param1.DataObj.QuestsList;
			this.QuestsList_mc.entryList.sortOn(["enabled","sortval"],[Array.DESCENDING | Array.NUMERIC,Array.NUMERIC]);
			var _loc5_:uint = uint.MAX_VALUE;
			var _loc6_:uint = 0;
			while(_loc6_ < this.QuestsList_mc.entryList.length)
			{
				if(!this.QuestsList_mc.entryList[_loc6_].enabled && _loc5_ == uint.MAX_VALUE)
				{
					if(_loc6_ > 0 && !_loc4_)
					{
						_loc5_ = _loc6_;
					}
					else
					{
						_loc4_ = true;
						this.QuestsList_mc.selectedIndex = -1;
					}
				}
				if(this.QuestsList_mc.entryList[_loc6_].isDivider)
				{
					this.QuestsList_mc.entryList.splice(_loc6_,1);
					_loc6_--;
				}
				_loc6_++;
			}
			if(_loc5_ != uint.MAX_VALUE)
			{
				this.QuestsList_mc.entryList.splice(_loc5_,0,{"isDivider":true});
			}
			this.QuestsList_mc.InvalidateData();
			if(_loc3_)
			{
				stage.focus = this.QuestsList_mc;
				if(this.QuestsList_mc.selectedIndex == -1)
				{
					this.QuestsList_mc.selectedClipIndex = 0;
				}
				else if(this.QuestsList_mc.selectedEntry.isDivider)
				{
					this.QuestsList_mc.selectedIndex = this.QuestsList_mc.selectedIndex - 1;
				}
			}
			else
			{
				this.QuestsList_mc.selectedIndex = -1;
			}
			this.refreshObjectiveList();
			SetIsDirty();
		}
		
		override protected function onReadOnlyChanged(param1:Boolean) : void
		{
			super.onReadOnlyChanged(param1);
			SetScrollingListReadOnly(this.QuestsList_mc,param1);
			SetScrollingListReadOnly(this.ObjectivesList_mc,param1);
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			while(this.VaultBoyHolder_mc.numChildren > 0)
			{
				this.VaultBoyHolder_mc.removeChildAt(0);
			}
			if(this.Quest_VaultBoyLoader.contentLoaderInfo.content != null)
			{
				this.Quest_VaultBoyLoader.contentLoaderInfo.content.scaleX = 0.7;
				this.Quest_VaultBoyLoader.contentLoaderInfo.content.scaleY = this.Quest_VaultBoyLoader.contentLoaderInfo.content.scaleX;
				this.VaultBoyHolder_mc.addChild(this.Quest_VaultBoyLoader.contentLoaderInfo.content);
			}
			else if(this.QuestsList_mc.entryList.length > 0 && !this.Quest_VaultBoy_LoadPending)
			{
				this.VaultBoyHolder_mc.addChild(this.Quest_DefaultBoy_mc);
			}
			GlobalFunc.SetText(this.Description_tf,this._DescText,false);
			var _loc1_:* = this._DescText == ""?0:this.Description_tf.textHeight;
			var _loc2_:* = this.Description_tf.y + _loc1_ + this._ObjectivesListBuffer;
			if(_loc2_ > this._DefaultObjectivesListTop)
			{
				this.ObjectivesList_mc.y = _loc2_;
			}
			this.QuestsList_mc.alpha = !!this._ObjectivesListActive?Number(GlobalFunc.DIMMED_ALPHA):Number(1);
			this.ObjectivesList_mc.visible = this.ObjectivesList_mc.entryList.length > 0;
			this.VaultBoyHolder_mc.visible = !this._ShowingSummary;
			this.Description_tf.visible = this._ShowingSummary;
			this.ShowOnMapButton.ButtonVisible = this.visible && this.QuestsList_mc.selectedEntry != null;
			var _loc3_:* = !CompanionAppMode.isOn;
			var _loc4_:Object = !!this._ObjectivesListActive?this.ObjectivesList_mc.selectedEntry:this.QuestsList_mc.selectedEntry;
			this.ShowOnMapButton.ButtonEnabled = _loc4_ != null && _loc4_.enabled && (_loc4_.active || _loc3_) && _loc4_.formID != 0;
			this.ShowSummaryButton.ButtonVisible = this.visible && this._DescText.length > 0;
			this.NavigateObjectivesButton.ButtonVisible = this.NavigateObjectivesButton.ButtonEnabled = this.visible && iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && iPlatform != PlatformChangeEvent.PLATFORM_MOBILE && this.QuestsList_mc.selectedEntry.formID == 0;
			this.ToggleActiveButton.ButtonVisible = this.visible && _loc4_ != null && iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && iPlatform != PlatformChangeEvent.PLATFORM_MOBILE;
			this.ToggleActiveButton.ButtonEnabled = this.ToggleActiveButton.ButtonVisible && _loc4_.enabled;
		}
		
		public function onQuestSelectionChange() : *
		{
			this.Quest_VaultBoyLoader.unloadAndStop();
			this.ObjectivesList_mc.selectedIndex = -1;
			this.Quest_VaultBoy_LoadPending = true;
			if(this.QuestsList_mc.selectedIndex != -1 && this.QuestsList_mc.selectedEntry.isDivider != true)
			{
				if(this.QuestsList_mc.selectedEntry.formID == 0)
				{
					this.ObjectivesList_mc.disableSelection = false;
				}
				else
				{
					this.ObjectivesList_mc.disableSelection = true;
				}
				this.updateQuestDescription();
				this.updateQuestAnimation();
				this.refreshObjectiveList();
			}
			else
			{
				this.ObjectivesList_mc.entryList.splice(0);
				this._DescText = "";
				this._ShowingSummary = false;
			}
			this.SetButtons();
			SetIsDirty();
		}
		
		private function updateQuestAnimation() : void
		{
			var _loc1_:URLRequest = null;
			var _loc2_:LoaderContext = null;
			if(this.QuestsList_mc.selectedEntry.swfFile != "")
			{
				_loc1_ = new URLRequest(this.QuestsList_mc.selectedEntry.swfFile);
				_loc2_ = new LoaderContext(false,ApplicationDomain.currentDomain);
				this.Quest_VaultBoyLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVaultBoyLoadComplete);
				this.Quest_VaultBoyLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onVaultBoyLookupFail);
				this.Quest_VaultBoyLoader.load(_loc1_,_loc2_);
			}
			else
			{
				this.onVaultBoyLookupFail(null);
			}
		}
		
		private function updateQuestDescription() : void
		{
			if(this.QuestsList_mc.selectedIndex != -1 && this.QuestsList_mc.selectedEntry != null && this.QuestsList_mc.selectedEntry.description != null && this.QuestsList_mc.selectedEntry.description != undefined)
			{
				this._DescText = this.QuestsList_mc.selectedEntry.description;
			}
			else
			{
				this._DescText = "";
			}
		}
		
		public function onObjectiveSelectionChange() : *
		{
			this.SetObjectivesListActive(this.ObjectivesList_mc.selectedIndex != -1);
		}
		
		private function refreshObjectiveList() : *
		{
			if(this.QuestsList_mc.selectedIndex != -1)
			{
				BGSExternalInterface.call(this.codeObj,"onQuestSelection",this.ObjectivesList_mc.entryList,this.QuestsList_mc.selectedEntry,this);
			}
			else
			{
				this.ObjectivesList_mc.entryList.splice(0);
			}
		}
		
		public function onObjectivesReady() : *
		{
			this.ObjectivesList_mc.InvalidateData();
			SetIsDirty();
		}
		
		private function onVaultBoyMovieExitFrame(param1:Event) : *
		{
			if(param1.target.getChildAt(0).totalFrames != undefined && param1.target.getChildAt(0).currentFrame == param1.target.getChildAt(0).totalFrames)
			{
				this.onShowSummary(false);
				param1.target.removeEventListener(Event.EXIT_FRAME,this.onVaultBoyMovieExitFrame);
			}
		}
		
		private function onVaultBoyLoadComplete(param1:Event) : *
		{
			this.Quest_VaultBoy_LoadPending = false;
			param1.target.removeEventListener(Event.COMPLETE,this.onVaultBoyLoadComplete);
			param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onVaultBoyLookupFail);
			if(param1.target.content != null)
			{
				param1.target.content.addEventListener(Event.EXIT_FRAME,this.onVaultBoyMovieExitFrame);
			}
			this._ShowingSummary = false;
			this.SetButtons();
			SetIsDirty();
		}
		
		private function onVaultBoyLookupFail(param1:IOErrorEvent) : *
		{
			this.Quest_VaultBoy_LoadPending = false;
			if(param1 != null)
			{
				param1.target.removeEventListener(Event.COMPLETE,this.onVaultBoyLoadComplete);
				param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onVaultBoyLookupFail);
				this.Quest_DefaultBoy_mc.addEventListener(Event.EXIT_FRAME,this.onVaultBoyMovieExitFrame);
			}
			this._ShowingSummary = false;
			this.SetButtons();
			SetIsDirty();
		}
		
		private function SetButtons() : *
		{
			this.ShowSummaryButton.ButtonText = !!this._ShowingSummary?"$HideQuestSummary":"$ShowQuestSummary";
		}
		
		private function onQuestPress() : *
		{
			if(this._ObjectivesListActive)
			{
				this.onObjectivePress();
			}
			else if(this.QuestsList_mc.selectedEntry.enabled)
			{
				if(this.QuestsList_mc.selectedEntry.formID == 0)
				{
					this.onRightThumbstickInput(2);
				}
				else
				{
					BGSExternalInterface.call(this.codeObj,"SetQuestActive",this.QuestsList_mc.selectedEntry);
					BGSExternalInterface.call(this.codeObj,"PlaySound",!!this.QuestsList_mc.selectedEntry.active?"UIPipBoyQuestInactive":"UIPipBoyQuestActive");
				}
			}
		}
		
		private function onObjectivePress() : *
		{
			BGSExternalInterface.call(this.codeObj,"SetQuestActive",this.ObjectivesList_mc.selectedEntry);
			BGSExternalInterface.call(this.codeObj,"PlaySound",!!this.ObjectivesList_mc.selectedEntry.active?"UIPipBoyQuestInactive":"UIPipBoyQuestActive");
		}
		
		override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(param1 == "XButton" && this.ShowOnMapButton.ButtonVisible && this.ShowOnMapButton.ButtonEnabled && !param2)
			{
				this.onShowOnMap();
				_loc3_ = true;
			}
			else if(param1 == "LShoulder" && this.ShowSummaryButton.ButtonVisible && !param2)
			{
				this.onShowSummary();
				_loc3_ = true;
			}
			else if(param1 == "Cancel" && this.QuestsList_mc != null && this.QuestsList_mc.selectedEntry != null && this.QuestsList_mc.selectedEntry.formID == 0 && this.ObjectivesList_mc != null && this.ObjectivesList_mc.selectedIndex != -1 && !param2)
			{
				this.onRightThumbstickInput(4);
				_loc3_ = true;
			}
			return _loc3_;
		}
		
		private function onShowOnMap() : *
		{
			if(this.QuestsList_mc.selectedIndex != -1)
			{
				if(this._ObjectivesListActive && !this.ObjectivesList_mc.selectedEntry.active || !this._ObjectivesListActive && !this.QuestsList_mc.selectedEntry.active)
				{
					this.onQuestPress();
				}
				if(this.QuestsList_mc.selectedEntry.formID == 0 && this.ObjectivesList_mc.selectedIndex != -1)
				{
					BGSExternalInterface.call(this.codeObj,"ShowQuestOnMap",this.ObjectivesList_mc.selectedEntry.formID);
				}
				else
				{
					BGSExternalInterface.call(this.codeObj,"ShowQuestOnMap",this.QuestsList_mc.selectedEntry.formID);
				}
			}
		}
		
		private function onShowSummary(param1:Boolean = true) : *
		{
			if(this.QuestsList_mc.selectedIndex != -1)
			{
				this._ShowingSummary = !this._ShowingSummary;
				if(this._ShowingSummary)
				{
					this.VaultBoyHolder_mc.stop();
				}
				else
				{
					this.VaultBoyHolder_mc.gotoAndPlay(1);
				}
				this.SetButtons();
				SetIsDirty();
				if(param1)
				{
					BGSExternalInterface.call(this.codeObj,"PlaySmallTransition");
				}
			}
		}
		
		private function onToggleActivate() : *
		{
		}
		
		private function onNavigateObjectives() : *
		{
		}
		
		public function SetObjectivesListActive(param1:Boolean) : *
		{
			if(this._ObjectivesListActive != param1)
			{
				this._ObjectivesListActive = param1;
				SetIsDirty();
			}
		}
		
		override public function GetIsUsingRightStick() : Boolean
		{
			return true;
		}
		
		override public function onRightThumbstickInput(param1:uint) : *
		{
			if(this.QuestsList_mc.selectedEntry.formID == 0)
			{
				if(param1 != 0)
				{
					if(this._ObjectivesListActive)
					{
						if(param1 == 1)
						{
							this.ObjectivesList_mc.moveSelectionUp();
						}
						else if(param1 == 3)
						{
							this.ObjectivesList_mc.moveSelectionDown();
						}
						else if(param1 == 4)
						{
							this.ObjectivesList_mc.selectedIndex = -1;
							stage.focus = this.QuestsList_mc;
						}
					}
					else
					{
						this.ObjectivesList_mc.selectedIndex = 0;
						stage.focus = this.ObjectivesList_mc;
					}
				}
			}
			else if(param1 == 1)
			{
				this.ObjectivesList_mc.scrollPosition = this.ObjectivesList_mc.scrollPosition - 1;
			}
			else if(param1 == 3)
			{
				this.ObjectivesList_mc.scrollPosition = this.ObjectivesList_mc.scrollPosition + 1;
			}
		}
		
		function __setProp_ObjectivesList_mc_QuestsTab_Objectives_0() : *
		{
			try
			{
				this.ObjectivesList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ObjectivesList_mc.listEntryClass = "ObjectivesListEntry";
			this.ObjectivesList_mc.numListItems = 6;
			this.ObjectivesList_mc.restoreListIndex = false;
			this.ObjectivesList_mc.textOption = "Multi-Line";
			this.ObjectivesList_mc.verticalSpacing = 1.75;
			try
			{
				this.ObjectivesList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_QuestsList_mc_QuestsTab_Quests_0() : *
		{
			try
			{
				this.QuestsList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.QuestsList_mc.listEntryClass = "QuestsListEntry";
			this.QuestsList_mc.numListItems = 10;
			this.QuestsList_mc.restoreListIndex = false;
			this.QuestsList_mc.textOption = "Shrink To Fit";
			this.QuestsList_mc.verticalSpacing = 1;
			try
			{
				this.QuestsList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
