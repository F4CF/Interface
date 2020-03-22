package
{
	import Components.ItemCard;
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.AS3.COMPANIONAPP.MobileQuantityMenu;
	import Shared.BGSExternalInterface;
	import Shared.CustomEvent;
	import Shared.QuantityMenuNEW;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	public class Pipboy_InvPage extends PipboyPage
	{
		 
		
		public var List_mc:BSScrollingList;
		
		public var ComponentList_mc:BSScrollingList;
		
		public var ComponentOwnersList_mc:BSScrollingList;
		
		public var ItemCard_mc:ItemCard;
		
		public var ModalFadeRect_mc:MovieClip;
		
		public var PaperDoll_mc:PaperDoll;
		
		private var _QuantityMenu:QuantityMenuNEW;
		
		private const DROP_ITEM_COUNT_THRESHOLD:uint = 5;
		
		private var _ShowingQuantity:Boolean;
		
		public var _FavoritesMenu:PipboyFavoritesMenu;
		
		private var _ShowingFavorites:Boolean;
		
		private var favoriteHideTimer:Timer;
		
		private var _CurrentTab:uint;
		
		private var _HolotapePlaying:Boolean;
		
		private var _ComponentViewMode:Boolean;
		
		private var _SortMode:uint;
		
		private var _SortSelectionRestoreIndex:int;
		
		private var _quantityMenuOnItemID:uint;
		
		private var HolotapeButton:BSButtonHintData;
		
		private var NoteReadButton:BSButtonHintData;
		
		private var InspectButton:BSButtonHintData;
		
		private var DropButton:BSButtonHintData;
		
		private var FavButton:BSButtonHintData;
		
		private var CycleApparelDamageButton:BSButtonHintData;
		
		private var AcceptButton:BSButtonHintData;
		
		private var CancelButton:BSButtonHintData;
		
		private var ComponentToggleButton:BSButtonHintData;
		
		private var SortButton:BSButtonHintData;
		
		private var SortText:Array;
		
		private var previousSelectedNodeId;
		
		public function Pipboy_InvPage()
		{
			this.HolotapeButton = new BSButtonHintData("$HolotapePlay","Enter","PSN_A","Xenon_A",1,this.SelectItem);
			this.NoteReadButton = new BSButtonHintData("$READ","Enter","PSN_A","Xenon_A",1,this.SelectItem);
			this.InspectButton = new BSButtonHintData("$INSPECT","X","PSN_R3","Xenon_R3",1,this.ExamineItem);
			this.DropButton = new BSButtonHintData("$DROP","R","PSN_X","Xenon_X",1,this.DropItem);
			this.FavButton = new BSButtonHintData("$FAV","Q","PSN_R1","Xenon_R1",1,this.onFavButtonPress);
			this.CycleApparelDamageButton = new BSButtonHintData("$CYCLE DAMAGE","C","PSN_L1","Xenon_L1",1,this.CycleApparelDamage);
			this.AcceptButton = new BSButtonHintData("$ACCEPT","Enter","PSN_A","Xenon_A",1,this.onAcceptPress);
			this.CancelButton = new BSButtonHintData("$CANCEL","Tab","PSN_B","Xenon_B",1,this.onCancelPress);
			this.ComponentToggleButton = new BSButtonHintData("$COMPONENT VIEW","C","PSN_L1","Xenon_L1",1,this.ToggleComponentViewMode);
			this.SortButton = new BSButtonHintData("$SORT","Z","PSN_L3","Xenon_L3",1,this.onSortPress);
			this.SortText = ["$SORT","$SORT_DMG","$SORT_ROF","$SORT_RNG","$SORT_ACC","$SORT_VAL","$SORT_WT"];
			super();
			_TabNames = new Array("$InventoryCategoryWeapons","$InventoryCategoryApparel","$InventoryCategoryAid","$InventoryCategoryMisc","$InventoryCategoryJunk","$InventoryCategoryMods","$InventoryCategoryAmmo");
			this._CurrentTab = uint.MAX_VALUE;
			this._ShowingFavorites = false;
			this._ShowingQuantity = false;
			this._HolotapePlaying = false;
			this._ComponentViewMode = false;
			this._SortMode = 0;
			this._SortSelectionRestoreIndex = -1;
			this._FavoritesMenu = new PipboyFavoritesMenu();
			this.ComponentOwnersList_mc.disableInput = true;
			this.ComponentOwnersList_mc.disableSelection = true;
			this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
			this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
			this.ComponentList_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onComponentSelectionChange);
			this._FavoritesMenu.addEventListener(FavoritesEntry.CLICK,this.onFavEntryClick);
			this._FavoritesMenu.addEventListener(FavoritesCross.ITEM_PRESS,this.onFavEntryClick);
			this._FavoritesMenu.addEventListener(FavoritesCross.SELECTION_UPDATE,this.onFavSelection);
			if(CompanionAppMode.isOn)
			{
				this.ModalFadeRect_mc.ModalFadeInputCatcher.addEventListener(MouseEvent.CLICK,this.onFavCancel);
				this.previousSelectedNodeId = uint.MAX_VALUE;
			}
			this.__setProp_List_mc_Scene1_List_0();
			this.__setProp_ComponentList_mc_Scene1_ComponentView_0();
			this.__setProp_ComponentOwnersList_mc_Scene1_ComponentView_0();
		}
		
		override protected function PopulateButtonHintData() : *
		{
			_buttonHintDataV.push(this.HolotapeButton);
			_buttonHintDataV.push(this.NoteReadButton);
			if(!CompanionAppMode.isOn)
			{
				_buttonHintDataV.push(this.InspectButton);
			}
			_buttonHintDataV.push(this.DropButton);
			_buttonHintDataV.push(this.CycleApparelDamageButton);
			_buttonHintDataV.push(this.ComponentToggleButton);
			_buttonHintDataV.push(this.FavButton);
			_buttonHintDataV.push(this.AcceptButton);
			_buttonHintDataV.push(this.CancelButton);
			_buttonHintDataV.push(this.SortButton);
		}
		
		override protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.Inventory;
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			super.onPipboyChangeEvent(param1);
			if(param1.DataObj.CurrentTab != 4)
			{
				this._ComponentViewMode = false;
			}
			if(CompanionAppMode.isOn)
			{
				if(this._CurrentTab != param1.DataObj.CurrentTab)
				{
					this.List_mc.scrollList.needFullRefresh = true;
				}
			}
			this.List_mc.entryList = param1.DataObj.InvItems;
			this.List_mc.filterer.itemFilter = param1.DataObj.InvFilter;
			if(!this._ComponentViewMode)
			{
				this.List_mc.InvalidateData();
			}
			if(this.List_mc.selectedEntry != null)
			{
				if(this._ShowingQuantity && this._quantityMenuOnItemID != this.List_mc.selectedEntry.nodeID)
				{
					this.HideQuantity();
				}
			}
			this.ComponentList_mc.entryList = param1.DataObj.InvComponents;
			this.ComponentList_mc.entryList.sortOn("text");
			if(this._ComponentViewMode)
			{
				this.ComponentList_mc.InvalidateData();
			}
			this._FavoritesMenu.Cross_mc.infoArray = param1.DataObj.FavoritesList;
			if(!this._ShowingFavorites && !this._ShowingQuantity)
			{
				stage.focus = !!this._ComponentViewMode?this.ComponentList_mc:this.List_mc;
			}
			if(this._CurrentTab != param1.DataObj.CurrentTab)
			{
				this.List_mc.selectedIndex = this.List_mc.filterer.ClampIndex(param1.DataObj.InvSelectedItems[param1.DataObj.CurrentTab]);
			}
			if(this._SortSelectionRestoreIndex != -1)
			{
				this.List_mc.selectedIndex = this._SortSelectionRestoreIndex;
				this._SortSelectionRestoreIndex = -1;
			}
			this._CurrentTab = param1.DataObj.CurrentTab;
			this.PaperDoll_mc.slotResists = param1.DataObj.SlotResists;
			this.PaperDoll_mc.underwearType = param1.DataObj.UnderwearType;
			this.PaperDoll_mc.onDataChange();
			this._HolotapePlaying = param1.DataObj.HolotapePlaying;
			this._SortMode = param1.DataObj.SortMode;
			this.SetButtons();
			SetIsDirty();
			BGSExternalInterface.call(this.codeObj,"onInvItemSelection",this.List_mc.selectedIndex,this.ItemCard_mc.InfoObj,this.PaperDoll_mc.selectedInfoObj,this);
		}
		
		override protected function onReadOnlyChanged(param1:Boolean) : void
		{
			super.onReadOnlyChanged(param1);
			SetScrollingListReadOnly(this.List_mc,param1);
			if(param1)
			{
				this.HideHotkeys();
				this.HideQuantity();
			}
			this.SetButtons();
		}
		
		override protected function HandleMobileBackButton() : Boolean
		{
			var _loc1_:Boolean = false;
			if(this._ShowingFavorites)
			{
				this.HideHotkeys();
				_loc1_ = true;
			}
			else if(this._ShowingQuantity)
			{
				this.HideQuantity();
				_loc1_ = true;
			}
			return _loc1_;
		}
		
		private function onItemPressed(param1:Event) : *
		{
			this.SelectItem();
			param1.stopPropagation();
		}
		
		private function SelectItem() : void
		{
			BGSExternalInterface.call(this.codeObj,"SelectItem",this.List_mc.selectedIndex);
			this.SetButtons();
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			while(this.ModalFadeRect_mc.numChildren > 1)
			{
				this.ModalFadeRect_mc.removeChildAt(this.ModalFadeRect_mc.numChildren - 1);
			}
			if(this._ShowingQuantity)
			{
				this.ModalFadeRect_mc.addChild(this._QuantityMenu);
			}
			else if(this._ShowingFavorites)
			{
				this.ModalFadeRect_mc.addChild(this._FavoritesMenu);
			}
			this.ModalFadeRect_mc.visible = this._ShowingQuantity || this._ShowingFavorites;
			this.ItemCard_mc.visible = !this._ComponentViewMode;
			this.ComponentList_mc.visible = this._ComponentViewMode;
			this.ComponentList_mc.disableInput = !this._ComponentViewMode;
			this.ComponentOwnersList_mc.visible = this._ComponentViewMode;
			this.List_mc.visible = !this._ComponentViewMode;
			this.List_mc.disableInput = this._ComponentViewMode;
		}
		
		public function onListSelectionChange() : *
		{
			BGSExternalInterface.call(this.codeObj,"onInvItemSelection",this.List_mc.selectedIndex,this.ItemCard_mc.InfoObj,this.PaperDoll_mc.selectedInfoObj,this);
			BGSExternalInterface.call(this.codeObj,"updateItem3D",this.List_mc.selectedIndex);
			if(CompanionAppMode.isOn && this.List_mc.selectedEntry != null)
			{
				this.previousSelectedNodeId = this.List_mc.selectedEntry.nodeID;
			}
		}
		
		public function onListSelectionChangeCallback() : *
		{
			this.ItemCard_mc.onDataChange();
			this.PaperDoll_mc.onDataChange();
			dispatchEvent(new Event(PipboyPage.BOTTOM_BAR_UPDATE,true,true));
			this.SetButtons();
			SetIsDirty();
		}
		
		private function onComponentSelectionChange() : *
		{
			if(this.ComponentList_mc.selectedEntry != null)
			{
				this.ComponentOwnersList_mc.entryList = this.ComponentList_mc.selectedEntry.componentOwners;
				this.ComponentOwnersList_mc.entryList.sortOn("text");
			}
			else
			{
				this.ComponentOwnersList_mc.entryList = null;
			}
			this.ComponentOwnersList_mc.InvalidateData();
		}
		
		private function SetButtons() : *
		{
			var _loc1_:* = 1 << 13;
			var _loc2_:* = 1 << 7;
			this.HolotapeButton.ButtonText = !!this._HolotapePlaying?"$HolotapeStop":"$HolotapePlay";
			this.HolotapeButton.ButtonVisible = this._CurrentTab == 3 && this.List_mc.selectedEntry != null && (this.List_mc.selectedEntry.filterFlag & _loc1_) != 0;
			this.HolotapeButton.ButtonEnabled = !_ReadOnlyMode || (_ReadOnlyModeType == READ_ONLY_OFFLINE || _ReadOnlyModeType == READ_ONLY_DEMO) && this.List_mc.selectedEntry != null && this.List_mc.selectedEntry.isMinigame;
			this.NoteReadButton.ButtonVisible = this._CurrentTab == 3 && this.List_mc.selectedEntry != null && (this.List_mc.selectedEntry.filterFlag & _loc2_) != 0;
			this.NoteReadButton.ButtonEnabled = !_ReadOnlyMode;
			this.SortButton.ButtonText = this.SortText[this._SortMode];
			this.SortButton.ButtonVisible = !this._ShowingQuantity && !this._ShowingFavorites && !this._ComponentViewMode;
			this.SortButton.ButtonEnabled = !_ReadOnlyMode;
			this.InspectButton.ButtonVisible = !this._ShowingQuantity && !this._ShowingFavorites && !this._ComponentViewMode;
			this.InspectButton.ButtonEnabled = this.List_mc.selectedEntry != null;
			this.DropButton.ButtonVisible = !this._ShowingQuantity && !this._ShowingFavorites && !this._ComponentViewMode;
			this.DropButton.ButtonEnabled = this.List_mc.selectedEntry != null && !_ReadOnlyMode;
			this.FavButton.ButtonText = !!this._ComponentViewMode?"$TAG FOR SEARCH":"$FAV";
			this.FavButton.ButtonVisible = !this._ShowingQuantity && !this._ShowingFavorites && (this._CurrentTab < 3 || this._CurrentTab == 4 && this._ComponentViewMode);
			this.FavButton.ButtonEnabled = (!this._ComponentViewMode && this.List_mc.selectedEntry != null && this.List_mc.selectedEntry.canFavorite == true || this._ComponentViewMode && this.ComponentList_mc.selectedEntry != null) && !_ReadOnlyMode;
			this.CycleApparelDamageButton.ButtonVisible = this._CurrentTab == 1 && !this._ShowingQuantity && !this._ShowingFavorites;
			this.AcceptButton.ButtonVisible = this._ShowingQuantity || this._ShowingFavorites && !CompanionAppMode.isOn;
			this.CancelButton.ButtonVisible = this._ShowingQuantity || this._ShowingFavorites && !CompanionAppMode.isOn;
			this.ComponentToggleButton.ButtonText = !!this._ComponentViewMode?"$ITEM VIEW":"$COMPONENT VIEW";
			this.ComponentToggleButton.ButtonVisible = this._CurrentTab == 4 && !this._ShowingQuantity && !this._ShowingFavorites && this.List_mc.selectedEntry != null;
		}
		
		override public function CanLowerPipboy() : Boolean
		{
			return !this._ShowingQuantity && !this._ShowingFavorites;
		}
		
		private function onKeyUp(param1:KeyboardEvent) : *
		{
			if(param1.keyCode == Keyboard.ENTER)
			{
				this.onAcceptPress();
			}
			else if(param1.keyCode == Keyboard.ESCAPE)
			{
				this.onCancelPress();
			}
		}
		
		private function onAcceptPress() : *
		{
			if(this._ShowingQuantity)
			{
				BGSExternalInterface.call(this.codeObj,"ItemDrop",this.List_mc.selectedIndex,this._QuantityMenu.count);
				this.HideQuantity();
			}
			else if(this._ShowingFavorites)
			{
				this._FavoritesMenu.Cross_mc.SelectItem();
			}
		}
		
		private function onCancelPress() : *
		{
			if(this._ShowingQuantity)
			{
				this.HideQuantity();
			}
			else if(this._ShowingFavorites)
			{
				this.HideHotkeys();
			}
		}
		
		override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(this.ModalFadeRect_mc.visible == true)
			{
				_loc3_ = true;
			}
			if(this._ShowingQuantity)
			{
				this._QuantityMenu.ProcessUserEvent(param1,param2);
			}
			if(this._ShowingFavorites)
			{
				if((param1 == "RShoulder" || param1 == "Cancel") && !param2)
				{
					this.HideHotkeys();
				}
				else
				{
					this._FavoritesMenu.Cross_mc.ProcessUserEvent(param1,param2);
				}
			}
			if(!_loc3_)
			{
				if(!param2)
				{
					if(this.List_mc.selectedEntry != null)
					{
						if(param1 == "XButton" && this.DropButton.ButtonVisible)
						{
							this.DropItem();
							_loc3_ = true;
						}
						else if(param1 == "R3" && this.InspectButton.ButtonVisible)
						{
							this.ExamineItem();
							_loc3_ = true;
						}
						else if(param1 == "RShoulder" && this.FavButton.ButtonVisible && this.FavButton.ButtonEnabled)
						{
							this.onFavButtonPress();
							_loc3_ = true;
						}
					}
					if(param1 == "LShoulder")
					{
						if(this.CycleApparelDamageButton.ButtonVisible)
						{
							this.CycleApparelDamage();
						}
						else if(this.ComponentToggleButton.ButtonVisible)
						{
							this.ToggleComponentViewMode();
						}
					}
					if(param1 == "L3")
					{
						this.onSortPress();
					}
				}
			}
			return _loc3_;
		}
		
		private function onSortPress() : *
		{
			BGSExternalInterface.call(this.codeObj,"SortItemList",this);
		}
		
		public function onSortComplete(param1:int) : *
		{
			this._SortSelectionRestoreIndex = param1;
		}
		
		private function ExamineItem() : void
		{
			BGSExternalInterface.call(this.codeObj,"ExamineItem",this.List_mc.selectedIndex);
		}
		
		private function DropItem() : void
		{
			var _loc1_:uint = 0;
			if(this.List_mc.selectedEntry.count > this.DROP_ITEM_COUNT_THRESHOLD)
			{
				this.ShowQuantity(this.List_mc.selectedEntry.count);
			}
			else
			{
				_loc1_ = 1;
				BGSExternalInterface.call(this.codeObj,"ItemDrop",this.List_mc.selectedIndex,_loc1_);
			}
		}
		
		private function CycleApparelDamage() : void
		{
			this.PaperDoll_mc.IncrementDisplayedDamageType();
		}
		
		private function onFavButtonPress() : *
		{
			if(this._ComponentViewMode)
			{
				BGSExternalInterface.call(this.codeObj,"ToggleComponentFavorite",this.ComponentList_mc.selectedEntry.formID);
			}
			else
			{
				this.ShowHotkeys();
			}
		}
		
		private function ShowHotkeys() : *
		{
			if(!this._ShowingFavorites)
			{
				this.List_mc.disableInput = true;
				stage.focus = this._FavoritesMenu.Cross_mc;
				this._ShowingFavorites = true;
				BGSExternalInterface.call(this.codeObj,"onShowHotKeys",true);
				dispatchEvent(new Event(PipboyPage.LOWER_PIPBOY_ALLOW_CHANGE,true,true));
				this.SetButtons();
				SetIsDirty();
			}
		}
		
		private function HideHotkeys() : *
		{
			if(this._ShowingFavorites)
			{
				this._FavoritesMenu.Cross_mc.selectedIndex = FavoritesCross.FS_NONE;
				this.List_mc.disableInput = false;
				stage.focus = this.List_mc;
				this._ShowingFavorites = false;
				BGSExternalInterface.call(this.codeObj,"onShowHotKeys",false);
				dispatchEvent(new Event(PipboyPage.LOWER_PIPBOY_ALLOW_CHANGE,true,true));
				this.SetButtons();
				SetIsDirty();
			}
		}
		
		private function onFavEntryClick(param1:Event) : *
		{
			BGSExternalInterface.call(this.codeObj,"SetQuickkey",this.List_mc.selectedIndex,this._FavoritesMenu.Cross_mc.selectedIndex);
			if(this.favoriteHideTimer == null)
			{
				this.favoriteHideTimer = new Timer(450,1);
				this.favoriteHideTimer.addEventListener(TimerEvent.TIMER,this.onFavHideTimerDone);
				this.favoriteHideTimer.start();
			}
		}
		
		private function onFavHideTimerDone() : *
		{
			this.favoriteHideTimer.removeEventListener(TimerEvent.TIMER,this.onFavHideTimerDone);
			this.favoriteHideTimer = null;
			this.HideHotkeys();
		}
		
		private function onFavSelection(param1:Event) : *
		{
			var _loc3_:String = null;
			var _loc2_:int = (param1 as CustomEvent).params as int;
			if(_loc2_ != this._FavoritesMenu.Cross_mc.selectedIndex)
			{
				_loc3_ = this._FavoritesMenu.Cross_mc.selectionSound;
				if(_loc3_ != "")
				{
					BGSExternalInterface.call(this.codeObj,"PlaySound",_loc3_);
				}
			}
		}
		
		private function onFavCancel(param1:MouseEvent) : void
		{
			this.HideHotkeys();
		}
		
		private function ShowQuantity(param1:uint) : *
		{
			if(!this._ShowingQuantity)
			{
				this._QuantityMenu = !!CompanionAppMode.isOn?new MobileQuantityMenu(param1):new QuantityMenuNEW(param1);
				addEventListener(!!CompanionAppMode.isOn?MobileQuantityMenu.QUANTITY_CHANGED:QuantityMenuNEW.QUANTITY_CHANGED,this.onQuantityModified);
				this.List_mc.disableInput = true;
				stage.focus = this._QuantityMenu;
				this._ShowingQuantity = true;
				this._quantityMenuOnItemID = this.List_mc.selectedEntry.nodeID;
				BGSExternalInterface.call(this.codeObj,"toggleMovementToDirectional",true);
				BGSExternalInterface.call(this.codeObj,"onModalOpen",true);
				addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
				dispatchEvent(new Event(PipboyPage.LOWER_PIPBOY_ALLOW_CHANGE,true,true));
				this.SetButtons();
				SetIsDirty();
			}
		}
		
		private function HideQuantity() : *
		{
			if(this._ShowingQuantity)
			{
				this._QuantityMenu = null;
				removeEventListener(!!CompanionAppMode.isOn?MobileQuantityMenu.QUANTITY_CHANGED:QuantityMenuNEW.QUANTITY_CHANGED,this.onQuantityModified);
				this.List_mc.disableInput = false;
				stage.focus = this.List_mc;
				this._ShowingQuantity = false;
				BGSExternalInterface.call(this.codeObj,"onModalOpen",false);
				BGSExternalInterface.call(this.codeObj,"toggleMovementToDirectional",false);
				removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
				dispatchEvent(new Event(PipboyPage.LOWER_PIPBOY_ALLOW_CHANGE,true,true));
				this.SetButtons();
				SetIsDirty();
			}
		}
		
		private function ToggleComponentViewMode() : *
		{
			this._ComponentViewMode = !this._ComponentViewMode;
			this.ComponentList_mc.selectedClipIndex = 0;
			stage.focus = !!this._ComponentViewMode?this.ComponentList_mc:this.List_mc;
			if(this._ComponentViewMode)
			{
				this.ComponentList_mc.InvalidateData();
				this.ComponentList_mc.selectedIndex = 0;
			}
			else
			{
				this.List_mc.InvalidateData();
			}
			this.SetButtons();
			SetIsDirty();
			BGSExternalInterface.call(this.codeObj,"onComponentViewToggle",this._ComponentViewMode);
		}
		
		public function onQuantityModified(param1:Event) : *
		{
			BGSExternalInterface.call(this.codeObj,"PlaySound","UIMenuQuantity");
		}
		
		override public function CanSwitchTabs(param1:uint) : Boolean
		{
			return super.CanSwitchTabs(param1) && !this.ModalFadeRect_mc.visible;
		}
		
		override public function GetIsUsingRightStick() : Boolean
		{
			return this._ComponentViewMode;
		}
		
		override public function onRightThumbstickInput(param1:uint) : *
		{
			if(param1 == 1)
			{
				this.ComponentOwnersList_mc.scrollPosition = this.ComponentOwnersList_mc.scrollPosition - 1;
			}
			else if(param1 == 3)
			{
				this.ComponentOwnersList_mc.scrollPosition = this.ComponentOwnersList_mc.scrollPosition + 1;
			}
		}
		
		function __setProp_List_mc_Scene1_List_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.listEntryClass = "InvListEntry";
			this.List_mc.numListItems = 10;
			this.List_mc.restoreListIndex = true;
			this.List_mc.textOption = "Shrink To Fit";
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
		
		function __setProp_ComponentList_mc_Scene1_ComponentView_0() : *
		{
			try
			{
				this.ComponentList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ComponentList_mc.listEntryClass = "ComponentListEntry";
			this.ComponentList_mc.numListItems = 10;
			this.ComponentList_mc.restoreListIndex = false;
			this.ComponentList_mc.textOption = "Shrink To Fit";
			this.ComponentList_mc.verticalSpacing = 0;
			try
			{
				this.ComponentList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_ComponentOwnersList_mc_Scene1_ComponentView_0() : *
		{
			try
			{
				this.ComponentOwnersList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ComponentOwnersList_mc.disableSelection = false;
			this.ComponentOwnersList_mc.listEntryClass = "ComponentOwnersListEntry";
			this.ComponentOwnersList_mc.numListItems = 10;
			this.ComponentOwnersList_mc.restoreListIndex = false;
			this.ComponentOwnersList_mc.textOption = "Shrink To Fit";
			this.ComponentOwnersList_mc.verticalSpacing = 0;
			try
			{
				this.ComponentOwnersList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
