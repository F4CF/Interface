package
{
	import Components.ItemCard;
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.QuantityMenu;
	import Shared.CustomEvent;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import Shared.PlatformChangeEvent;
	import flash.display.InteractiveObject;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	public class ContainerMenu extends IMenu
	{
		
		private static const NUM_FILTERS:uint = 8;
		
		private static const CM_LOOT = 0;
		
		private static const CM_STEALING_FROM_CONTAINER = 1;
		
		private static const CM_PICKPOCKET = 2;
		
		private static const CM_TEAMMATE = 3;
		
		private static const CM_POWER_ARMOR = 4;
		
		private static const CM_JUNK_JET_RELOAD = 5;
		
		private static const CM_WORKBENCH = 6;
		 
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var CapsLabel_tf:TextField;
		
		public var ContainerInventory_mc:MovieClip;
		
		public var ContainerList_mc:ItemList;
		
		public var ItemCard_mc:ItemCard;
		
		public var PickpocketInfo_mc:MovieClip;
		
		public var PlayerInventory_mc:MovieClip;
		
		public var QuantityMenu_mc:MovieClip;
		
		public var PlayerHasJunk:Boolean = false;
		
		public var BGSCodeObj:Object;
		
		private var PlayFocusSounds:Boolean = true;
		
		private var FilterInfoA:Array;
		
		private var uiPlayerFilterIndex:uint;
		
		private var uiContainerFilterIndex:uint;
		
		private var uiUpperBracketPlayerLineMaxX:uint;
		
		private var uiUpperBracketContainerLineMaxX:uint;
		
		protected var MessageBoxIsActive = false;
		
		private var uiMode:uint = 0;
		
		private var InspectingFeaturedItem:Boolean = false;
		
		private var BlockNextListFocusSound:Boolean = false;
		
		protected var SwitchToPlayerButton:BSButtonHintData;
		
		protected var SwitchToContainerButton:BSButtonHintData;
		
		protected var AcceptButton:BSButtonHintData;
		
		protected var TakeAllButton:BSButtonHintData;
		
		protected var EquipOrStoreButton:BSButtonHintData;
		
		protected var SortButton:BSButtonHintData;
		
		protected var InspectButton:BSButtonHintData;
		
		protected var ExitButton:BSButtonHintData;
		
		protected var QuantityAcceptButton:BSButtonHintData;
		
		protected var QuantityCancelButton:BSButtonHintData;
		
		private var InitialValidation = true;
		
		public function ContainerMenu()
		{
			this.SwitchToPlayerButton = new BSButtonHintData("$TransferPlayerLabel","LT","PSN_L2_Alt","Xenon_L2_Alt",1,this.SwitchToPlayerList);
			this.SwitchToContainerButton = new BSButtonHintData("$TransferContainerLabel","RT","PSN_R2_Alt","Xenon_R2_Alt",1,this.SwitchToContainerList);
			this.AcceptButton = new BSButtonHintData("$STORE","Enter","PSN_A","Xenon_A",1,this.onAccept);
			this.TakeAllButton = new BSButtonHintData("$TAKE ALL","R","PSN_X","Xenon_X",1,this.onTakeAll);
			this.EquipOrStoreButton = new BSButtonHintData("$EQUIP","T","PSN_Y","Xenon_Y",1,this.onEquipOrStore);
			this.SortButton = new BSButtonHintData("$SORT","Z","PSN_L3","Xenon_L3",1,this.requestSort);
			this.InspectButton = new BSButtonHintData("$INSPECT","X","PSN_R3","Xenon_R3",1,this.onInspect);
			this.ExitButton = new BSButtonHintData("$EXIT","TAB","PSN_B","Xenon_B",1,this.onExitMenu);
			this.QuantityAcceptButton = new BSButtonHintData("$ACCEPT","E","PSN_A","Xenon_A",1,this.onQuantityAccepted);
			this.QuantityCancelButton = new BSButtonHintData("$CANCEL","TAB","PSN_B","Xenon_B",1,this.onQuantityCanceled);
			super();
			this.BGSCodeObj = new Object();
			this.PopulateButtonBar();
			stage.stageFocusRect = false;
			this.PlayerInventory_mc.PlayerSwitchButton_tf.visible = false;
			this.ContainerInventory_mc.ContainerSwitchButton_tf.visible = false;
			this.ItemCard_mc.scaleX = 0.7;
			this.ItemCard_mc.scaleY = this.ItemCard_mc.scaleX;
			this.FilterInfoA = new Array();
			this.FilterInfoA.push({
				"text":"$INVENTORY",
				"flag":4294967295
			});
			this.FilterInfoA.push({
				"text":"$InventoryCategoryWeapons",
				"flag":1 << 1
			});
			this.FilterInfoA.push({
				"text":"$InventoryCategoryApparel",
				"flag":1 << 2
			});
			this.FilterInfoA.push({
				"text":"$InventoryCategoryAid",
				"flag":1 << 3
			});
			this.FilterInfoA.push({
				"text":"$InventoryCategoryMisc",
				"flag":1 << 9
			});
			this.FilterInfoA.push({
				"text":"$InventoryCategoryJunk",
				"flag":1 << 10
			});
			this.FilterInfoA.push({
				"text":"$InventoryCategoryMods",
				"flag":1 << 11
			});
			this.FilterInfoA.push({
				"text":"$InventoryCategoryAmmo",
				"flag":1 << 12
			});
			this.uiPlayerFilterIndex = 0;
			this.uiContainerFilterIndex = 0;
			this.PlayerInventory_mc.LeftHitBox_tf.addEventListener(MouseEvent.MOUSE_UP,this.onListHeaderClick);
			this.PlayerInventory_mc.RightHitBox_tf.addEventListener(MouseEvent.MOUSE_UP,this.onListHeaderClick);
			this.ContainerInventory_mc.LeftHitBox_tf.addEventListener(MouseEvent.MOUSE_UP,this.onListHeaderClick);
			this.ContainerInventory_mc.RightHitBox_tf.addEventListener(MouseEvent.MOUSE_UP,this.onListHeaderClick);
			addEventListener(FocusEvent.FOCUS_OUT,this.onFocusChange);
			addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPress);
			addEventListener(BSScrollingList.SELECTION_CHANGE,this.onSelectionChange);
			addEventListener(ItemList.MOUSE_OVER,this.onListMouseOver);
			addEventListener(HeaderArrow.MOUSE_UP,this.onListHeaderClick);
			addEventListener(QuantityMenu.CONFIRM,this.onQuantityConfirm);
			this.PlayerInventory_mc.PlayerListHeader.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverPlayerHeader);
			this.ContainerInventory_mc.ContainerListHeader.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverContainerHeader);
			this.SwitchToContainerList(false);
			this.UpdateButtonHints();
			this.UpdateHeaderText(this.PlayerInventory_mc.PlayerList_mc);
			this.UpdateHeaderText(this.ContainerList_mc);
			if(this.PickpocketInfo_mc != null)
			{
				this.PickpocketInfo_mc.Caption_tf.visible = false;
				this.PickpocketInfo_mc.Percent_tf.visible = false;
			}
		}
		
		public function get containerIsSelected() : Boolean
		{
			return stage.focus == this.ContainerList_mc;
		}
		
		public function get selectedIndex() : int
		{
			return !!stage.focus?int((stage.focus as ItemList).selectedIndex):-1;
		}
		
		public function set inspectingFeaturedItem(param1:Boolean) : *
		{
			this.InspectingFeaturedItem = param1;
			if(param1 == false)
			{
				(stage.focus as ItemList).disableInput = false;
			}
		}
		
		public function set playFocusSounds(param1:Boolean) : *
		{
			this.PlayFocusSounds = param1;
		}
		
		public function set playerHasJunk(param1:Boolean) : *
		{
			this.PlayerHasJunk = param1;
			this.UpdateButtonHints();
		}
		
		protected function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.SwitchToPlayerButton);
			_loc1_.push(this.SwitchToContainerButton);
			_loc1_.push(this.AcceptButton);
			_loc1_.push(this.TakeAllButton);
			if(this.uiMode != CM_POWER_ARMOR && this.uiMode != CM_JUNK_JET_RELOAD)
			{
				_loc1_.push(this.EquipOrStoreButton);
			}
			_loc1_.push(this.InspectButton);
			_loc1_.push(this.ExitButton);
			_loc1_.push(this.QuantityAcceptButton);
			_loc1_.push(this.QuantityCancelButton);
			_loc1_.push(this.SortButton);
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		public function onIntroAnimComplete() : *
		{
			this.BGSCodeObj.onIntroAnimComplete();
		}
		
		protected function get AcceptButtonText() : String
		{
			var _loc1_:* = this.uiMode == CM_JUNK_JET_RELOAD;
			var _loc2_:* = stage.focus == this.ContainerList_mc;
			if(_loc1_)
			{
				return !!_loc2_?"$UNLOAD":"$LOAD";
			}
			return !!_loc2_?this.uiMode == CM_PICKPOCKET || this.uiMode == CM_STEALING_FROM_CONTAINER?"$STEAL":"$TAKE":this.uiMode == CM_PICKPOCKET?"$PLACE":"$STORE";
		}
		
		protected function get TakeAllText() : String
		{
			var _loc1_:* = this.uiMode == CM_JUNK_JET_RELOAD;
			return !!_loc1_?"$UNLOAD ALL":"$TAKE ALL";
		}
		
		protected function UpdateButtonHints() : void
		{
			var _loc3_:int = 0;
			var _loc4_:* = false;
			var _loc5_:ItemList = null;
			var _loc6_:* = undefined;
			var _loc1_:* = stage.focus == this.QuantityMenu_mc;
			var _loc2_:Boolean = _loc1_ || this.MessageBoxIsActive;
			this.SwitchToPlayerButton.ButtonVisible = stage.focus == this.ContainerList_mc && this.PlayerInventory_mc.PlayerList_mc.itemsShown && uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE;
			this.SwitchToContainerButton.ButtonVisible = stage.focus == this.PlayerInventory_mc.PlayerList_mc && this.ContainerList_mc.itemsShown && uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE;
			this.EquipOrStoreButton.ButtonVisible = this.uiMode == CM_TEAMMATE && stage.focus != this.PlayerInventory_mc.PlayerList_mc;
			if(this.EquipOrStoreButton.ButtonVisible && !_loc2_)
			{
				_loc3_ = (stage.focus as ItemList).selectedIndex;
				_loc4_ = stage.focus == this.ContainerList_mc;
				this.EquipOrStoreButton.ButtonVisible = this.BGSCodeObj.getSelectedItemEquippable(_loc3_,_loc4_);
				this.EquipOrStoreButton.ButtonText = !!this.BGSCodeObj.getSelectedItemEquipped(_loc3_,_loc4_)?"$UNEQUIP":"$EQUIP";
			}
			else if(this.uiMode == CM_WORKBENCH)
			{
				this.EquipOrStoreButton.ButtonVisible = true;
				this.EquipOrStoreButton.ButtonText = "$StoreAllJunk";
				this.EquipOrStoreButton.ButtonDisabled = !this.PlayerHasJunk;
			}
			this.QuantityAcceptButton.ButtonVisible = _loc1_;
			this.QuantityCancelButton.ButtonVisible = _loc1_;
			this.AcceptButton.ButtonVisible = !_loc2_;
			this.TakeAllButton.ButtonVisible = !_loc2_;
			this.EquipOrStoreButton.ButtonVisible = this.EquipOrStoreButton.ButtonVisible && !_loc2_;
			this.ExitButton.ButtonVisible = !_loc2_;
			this.InspectButton.ButtonVisible = !_loc2_;
			this.SortButton.ButtonVisible = !_loc2_;
			if(!_loc2_)
			{
				_loc5_ = stage.focus as ItemList;
				_loc6_ = !_loc5_ || _loc5_.entryList.length == 0;
				this.AcceptButton.ButtonText = this.AcceptButtonText;
				this.AcceptButton.ButtonDisabled = _loc6_;
				this.TakeAllButton.ButtonText = this.TakeAllText;
				this.TakeAllButton.ButtonDisabled = _loc6_;
				this.InspectButton.ButtonDisabled = _loc6_;
			}
		}
		
		public function SetContainerInfo(param1:String, param2:uint) : *
		{
			this.uiMode = param2;
			this.FilterInfoA[0].containerText = param1.toUpperCase();
			this.ContainerInventory_mc.ContainerListHeader.SetArrowVisibility(this.uiMode != CM_JUNK_JET_RELOAD);
			this.UpdateHeaderText(this.ContainerList_mc);
			this.SwitchToContainerButton.ButtonText = this.FilterInfoA[this.uiContainerFilterIndex].containerText.toUpperCase();
		}
		
		public function get playerListArray() : Array
		{
			return this.PlayerInventory_mc.PlayerList_mc.entryList;
		}
		
		public function get containerListArray() : Array
		{
			return this.ContainerList_mc.entryList;
		}
		
		public function InvalidateLists() : *
		{
			this.PlayerInventory_mc.PlayerList_mc.InvalidateData();
			this.ContainerList_mc.InvalidateData();
			this.UpdateItemDisplay(stage.focus as ItemList,false);
			this.ValidateListHighlight();
			if(this.PlayerInventory_mc.PlayerListHeader.headerText.length == 0)
			{
				this.UpdateHeaderText(this.PlayerInventory_mc.PlayerList_mc);
				this.UpdateHeaderText(this.ContainerList_mc);
			}
			this.UpdateButtonHints();
		}
		
		private function ValidateListHighlight() : *
		{
			var _loc1_:ItemList = null;
			if(this.PlayerInventory_mc.PlayerList_mc.itemsShown == 0 && this.ContainerList_mc.itemsShown == 0)
			{
				this.PlayerInventory_mc.PlayerList_mc.selectedIndex = -1;
				this.ContainerList_mc.selectedIndex = -1;
				this.PlayerInventory_mc.PlayerSwitchButton_tf.visible = false;
				this.ContainerInventory_mc.ContainerSwitchButton_tf.visible = false;
			}
			else if(this.ContainerList_mc.itemsShown == 0 && stage.focus == this.ContainerList_mc || this.PlayerInventory_mc.PlayerList_mc.itemsShown == 0 && stage.focus == this.PlayerInventory_mc.PlayerList_mc)
			{
				_loc1_ = stage.focus as ItemList;
				if(_loc1_.entryList.length > 0)
				{
					this.changeItemFilter(_loc1_,1);
				}
				else
				{
					if(_loc1_ == this.ContainerList_mc)
					{
						this.uiContainerFilterIndex = 0;
						this.SwitchToPlayerList(!this.InitialValidation);
						this.ContainerInventory_mc.ContainerSwitchButton_tf.visible = false;
					}
					else
					{
						this.uiPlayerFilterIndex = 0;
						this.SwitchToContainerList(!this.InitialValidation);
						this.PlayerInventory_mc.PlayerSwitchButton_tf.visible = false;
					}
					_loc1_.filterer.itemFilter = this.FilterInfoA[0].flag;
					this.UpdateHeaderText(_loc1_);
				}
			}
			else if(stage.focus == null)
			{
				if(this.ContainerList_mc.itemsShown == 0)
				{
					this.SwitchToPlayerList(!this.InitialValidation);
				}
				else
				{
					this.SwitchToContainerList(!this.InitialValidation);
				}
			}
			this.InitialValidation = false;
		}
		
		private function UpdateItemCard() : *
		{
			var _loc1_:Object = null;
			if(stage.focus is ItemList)
			{
				_loc1_ = (stage.focus as ItemList).selectedEntry;
				if(_loc1_ != null)
				{
					this.ItemCard_mc.InfoObj = _loc1_.ItemCardInfoList;
					this.ItemCard_mc.onDataChange();
				}
			}
		}
		
		public function SwitchToContainerList(param1:Boolean = true) : Boolean
		{
			var _loc2_:Boolean = this.SwitchLists(this.PlayerInventory_mc.PlayerList_mc,this.ContainerList_mc);
			if(_loc2_)
			{
				if(uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
				{
					this.PlayerInventory_mc.PlayerSwitchButton_tf.visible = true;
				}
				this.PlayerInventory_mc.PlayerListHeader.SetArrowVisibility(false);
				this.ContainerInventory_mc.ContainerSwitchButton_tf.visible = false;
				this.ContainerInventory_mc.ContainerListHeader.SetArrowVisibility(this.uiMode != CM_JUNK_JET_RELOAD);
				this.UpdateButtonHints();
				this.RepositionUpperBracketBars();
				if(param1)
				{
					this.BGSCodeObj.PlaySound("UIBarterHorizontalRight");
				}
				this.BGSCodeObj.updateSortButtonLabel(true,this.uiContainerFilterIndex);
			}
			return _loc2_;
		}
		
		protected function RepositionUpperBracketBars() : *
		{
			var _loc1_:Shape = null;
			var _loc2_:* = null;
			var _loc3_:* = 0;
			_loc3_ = 0;
			while(_loc3_ < this.PlayerInventory_mc.numChildren)
			{
				_loc2_ = this.PlayerInventory_mc.getChildAt(_loc3_);
				if(_loc2_.name == "lines")
				{
					this.PlayerInventory_mc.removeChild(_loc2_);
					break;
				}
				_loc3_++;
			}
			_loc1_ = new Shape();
			_loc1_.name = "lines";
			_loc1_.graphics.lineStyle(2,16777215,1,true,LineScaleMode.NONE);
			_loc1_.graphics.moveTo(0,31.5);
			_loc1_.graphics.lineTo(0,27.5);
			_loc1_.graphics.lineTo(this.PlayerInventory_mc.PlayerListHeader.x,27.5);
			if(this.PlayerInventory_mc.PlayerSwitchButton_tf.visible == true)
			{
				_loc1_.graphics.lineTo(this.PlayerInventory_mc.PlayerListHeader.x + 15,27.5);
			}
			_loc1_.graphics.moveTo(this.PlayerInventory_mc.PlayerListHeader.x + this.PlayerInventory_mc.PlayerListHeader.headerWidth - (!!this.PlayerInventory_mc.PlayerSwitchButton_tf.visible?17:0),27.5);
			_loc1_.graphics.lineTo(this.PlayerInventory_mc.PlayerSwitchButton_tf.x,27.5);
			if(this.PlayerInventory_mc.PlayerSwitchButton_tf.visible == true)
			{
				_loc1_.graphics.moveTo(this.PlayerInventory_mc.PlayerSwitchButton_tf.x + this.PlayerInventory_mc.PlayerSwitchButton_tf.width + 2,27.5);
			}
			_loc1_.graphics.lineTo(this.PlayerInventory_mc.PlayerBracketBackground_mc.x + this.PlayerInventory_mc.PlayerBracketBackground_mc.width,27.5);
			_loc1_.graphics.lineTo(this.PlayerInventory_mc.PlayerBracketBackground_mc.x + this.PlayerInventory_mc.PlayerBracketBackground_mc.width,31.5);
			_loc1_.graphics.moveTo(0,this.PlayerInventory_mc.PlayerBracketBackground_mc.y + this.PlayerInventory_mc.PlayerBracketBackground_mc.height - 4);
			_loc1_.graphics.lineTo(0,this.PlayerInventory_mc.PlayerBracketBackground_mc.y + this.PlayerInventory_mc.PlayerBracketBackground_mc.height);
			_loc1_.graphics.lineTo(this.PlayerInventory_mc.PlayerBracketBackground_mc.x + this.PlayerInventory_mc.PlayerBracketBackground_mc.width,this.PlayerInventory_mc.PlayerBracketBackground_mc.y + this.PlayerInventory_mc.PlayerBracketBackground_mc.height);
			_loc1_.graphics.lineTo(this.PlayerInventory_mc.PlayerBracketBackground_mc.x + this.PlayerInventory_mc.PlayerBracketBackground_mc.width,this.PlayerInventory_mc.PlayerBracketBackground_mc.y + this.PlayerInventory_mc.PlayerBracketBackground_mc.height - 4);
			this.PlayerInventory_mc.addChild(_loc1_);
			_loc3_ = 0;
			while(_loc3_ < this.ContainerInventory_mc.numChildren)
			{
				_loc2_ = this.ContainerInventory_mc.getChildAt(_loc3_);
				if(_loc2_.name == "lines")
				{
					this.ContainerInventory_mc.removeChild(_loc2_);
					break;
				}
				_loc3_++;
			}
			_loc1_ = new Shape();
			_loc1_.name = "lines";
			_loc1_.graphics.lineStyle(2,16777215,1,true,LineScaleMode.NONE);
			_loc1_.graphics.moveTo(0,31.5);
			_loc1_.graphics.lineTo(0,27.5);
			_loc1_.graphics.lineTo(this.ContainerInventory_mc.ContainerListHeader.x,27.5);
			if(this.ContainerInventory_mc.ContainerSwitchButton_tf.visible == true)
			{
				_loc1_.graphics.lineTo(this.ContainerInventory_mc.ContainerListHeader.x + 15,27.5);
			}
			_loc1_.graphics.moveTo(this.ContainerInventory_mc.ContainerListHeader.x + this.ContainerInventory_mc.ContainerListHeader.headerWidth - (!!this.ContainerInventory_mc.ContainerSwitchButton_tf.visible?17:0),27.5);
			_loc1_.graphics.lineTo(this.ContainerInventory_mc.ContainerSwitchButton_tf.x - 2,27.5);
			if(this.ContainerInventory_mc.ContainerSwitchButton_tf.visible == true)
			{
				_loc1_.graphics.moveTo(this.ContainerInventory_mc.ContainerSwitchButton_tf.x + this.ContainerInventory_mc.ContainerSwitchButton_tf.width,27.5);
			}
			_loc1_.graphics.lineTo(this.ContainerInventory_mc.ContainerBracketBackground_mc.x + this.ContainerInventory_mc.ContainerBracketBackground_mc.width,27.5);
			_loc1_.graphics.lineTo(this.ContainerInventory_mc.ContainerBracketBackground_mc.x + this.ContainerInventory_mc.ContainerBracketBackground_mc.width,31.5);
			_loc1_.graphics.moveTo(0,this.ContainerInventory_mc.ContainerBracketBackground_mc.y + this.ContainerInventory_mc.ContainerBracketBackground_mc.height - 4);
			_loc1_.graphics.lineTo(0,this.ContainerInventory_mc.ContainerBracketBackground_mc.y + this.ContainerInventory_mc.ContainerBracketBackground_mc.height);
			_loc1_.graphics.lineTo(this.ContainerInventory_mc.ContainerBracketBackground_mc.x + this.ContainerInventory_mc.ContainerBracketBackground_mc.width,this.ContainerInventory_mc.ContainerBracketBackground_mc.y + this.ContainerInventory_mc.ContainerBracketBackground_mc.height);
			_loc1_.graphics.lineTo(this.ContainerInventory_mc.ContainerBracketBackground_mc.x + this.ContainerInventory_mc.ContainerBracketBackground_mc.width,this.ContainerInventory_mc.ContainerBracketBackground_mc.y + this.ContainerInventory_mc.ContainerBracketBackground_mc.height - 4);
			this.ContainerInventory_mc.addChild(_loc1_);
		}
		
		protected function SwitchToPlayerList(param1:Boolean = true) : Boolean
		{
			var _loc2_:Boolean = this.SwitchLists(this.ContainerList_mc,this.PlayerInventory_mc.PlayerList_mc);
			if(_loc2_)
			{
				if(uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
				{
					this.ContainerInventory_mc.ContainerSwitchButton_tf.visible = true;
				}
				this.ContainerInventory_mc.ContainerListHeader.SetArrowVisibility(false);
				this.PlayerInventory_mc.PlayerSwitchButton_tf.visible = false;
				this.PlayerInventory_mc.PlayerListHeader.SetArrowVisibility(true);
				this.UpdateButtonHints();
				this.RepositionUpperBracketBars();
				if(param1)
				{
					this.BGSCodeObj.PlaySound("UIBarterHorizontalLeft");
				}
				this.BGSCodeObj.updateSortButtonLabel(false,this.uiPlayerFilterIndex);
			}
			return _loc2_;
		}
		
		protected function OpenQuantityMenu(param1:int, param2:int = 0) : *
		{
			this.BGSCodeObj.show3D(-1,false);
			this.QuantityMenu_mc.OpenMenu(param1,stage.focus,"",param2);
			addEventListener(QuantityMenu.QUANTITY_CHANGED,this.onQuantityModified);
			stage.focus = this.QuantityMenu_mc;
			this.PlayerInventory_mc.PlayerList_mc.disableInput = true;
			this.PlayerInventory_mc.PlayerList_mc.disableSelection = true;
			this.ContainerList_mc.disableInput = true;
			this.ContainerList_mc.disableSelection = true;
			this.ItemCard_mc.visible = false;
			this.UpdateButtonHints();
		}
		
		protected function CloseQuantityMenu() : *
		{
			this.PlayerInventory_mc.PlayerList_mc.disableInput = false;
			this.PlayerInventory_mc.PlayerList_mc.disableSelection = false;
			this.ContainerList_mc.disableInput = false;
			this.ContainerList_mc.disableSelection = false;
			stage.focus = this.QuantityMenu_mc.prevFocus;
			this.QuantityMenu_mc.CloseMenu();
			removeEventListener(QuantityMenu.QUANTITY_CHANGED,this.onQuantityModified);
			this.UpdateItemDisplay(stage.focus as ItemList,false);
			this.ItemCard_mc.visible = true;
			this.UpdateButtonHints();
		}
		
		private function SwitchLists(param1:ItemList, param2:ItemList) : Boolean
		{
			var _loc3_:Boolean = false;
			if(stage.focus != param2 && param2.itemsShown > 0 && !this.QuantityMenu_mc.opened)
			{
				stage.focus = param2;
				if(param1.selectedEntry == null)
				{
					param2.selectedIndex = param2.GetEntryFromClipIndex(0);
				}
				else
				{
					param2.selectedIndex = param2.GetEntryFromClipIndex(param1.selectedEntry.clipIndex);
				}
				param1.selectedIndex = -1;
				_loc3_ = true;
			}
			return _loc3_;
		}
		
		private function onMouseOverPlayerHeader(param1:MouseEvent) : *
		{
			if(!this.QuantityMenu_mc.opened)
			{
				if(stage.focus != this.PlayerInventory_mc.PlayerList_mc)
				{
					stage.focus = this.PlayerInventory_mc.PlayerList_mc;
					this.PlayerInventory_mc.PlayerList_mc.selectedIndex = 0;
					this.ContainerList_mc.selectedIndex = -1;
					this.ContainerInventory_mc.ContainerListHeader.SetArrowVisibility(false);
					this.PlayerInventory_mc.PlayerListHeader.SetArrowVisibility(true);
					this.UpdateButtonHints();
					this.RepositionUpperBracketBars();
					this.BGSCodeObj.updateSortButtonLabel(false,this.uiPlayerFilterIndex);
				}
			}
		}
		
		private function onMouseOverContainerHeader(param1:MouseEvent) : *
		{
			if(!this.QuantityMenu_mc.opened)
			{
				if(stage.focus != this.ContainerList_mc)
				{
					stage.focus = this.ContainerList_mc;
					this.ContainerList_mc.selectedIndex = 0;
					this.PlayerInventory_mc.PlayerList_mc.selectedIndex = -1;
					this.PlayerInventory_mc.PlayerListHeader.SetArrowVisibility(false);
					this.ContainerInventory_mc.ContainerListHeader.SetArrowVisibility(true);
					this.UpdateButtonHints();
					this.RepositionUpperBracketBars();
					this.BGSCodeObj.updateSortButtonLabel(true,this.uiContainerFilterIndex);
				}
			}
		}
		
		private function onListMouseOver(param1:Event) : *
		{
			if(!this.QuantityMenu_mc.opened)
			{
				if(param1.target == this.PlayerInventory_mc.PlayerList_mc && stage.focus != this.PlayerInventory_mc.PlayerList_mc)
				{
					stage.focus = this.PlayerInventory_mc.PlayerList_mc;
					this.ContainerList_mc.selectedIndex = -1;
					this.ContainerInventory_mc.ContainerListHeader.SetArrowVisibility(false);
					this.PlayerInventory_mc.PlayerListHeader.SetArrowVisibility(true);
					this.UpdateButtonHints();
					this.RepositionUpperBracketBars();
					this.BGSCodeObj.updateSortButtonLabel(false,this.uiPlayerFilterIndex);
				}
				else if(param1.target == this.ContainerList_mc && stage.focus != this.ContainerList_mc)
				{
					stage.focus = this.ContainerList_mc;
					this.PlayerInventory_mc.PlayerList_mc.selectedIndex = -1;
					this.PlayerInventory_mc.PlayerListHeader.SetArrowVisibility(false);
					this.ContainerInventory_mc.ContainerListHeader.SetArrowVisibility(true);
					this.UpdateButtonHints();
					this.RepositionUpperBracketBars();
					this.BGSCodeObj.updateSortButtonLabel(true,this.uiContainerFilterIndex);
				}
			}
		}
		
		private function onFocusChange(param1:FocusEvent) : *
		{
			if(param1.relatedObject != this.PlayerInventory_mc.PlayerList_mc && param1.relatedObject != this.ContainerList_mc && param1.relatedObject != this.QuantityMenu_mc)
			{
				stage.focus = param1.target as InteractiveObject;
			}
		}
		
		private function onItemPress(param1:Event) : *
		{
			var _loc2_:int = 0;
			var _loc3_:* = undefined;
			if(visible)
			{
				if(this.InspectingFeaturedItem)
				{
					this.InspectingFeaturedItem = false;
				}
				else
				{
					_loc2_ = (param1.target as ItemList).selectedEntry.count;
					if((param1.target as ItemList).selectedEntry.suppressQuantityMenu == true)
					{
						this.BGSCodeObj.transferItem((param1.target as ItemList).selectedIndex,_loc2_,param1.target == this.ContainerList_mc);
						this.BlockNextListFocusSound = true;
						this.onTransferItem(stage.focus == this.PlayerInventory_mc.PlayerList_mc?this.ContainerList_mc:this.PlayerInventory_mc.PlayerList_mc);
					}
					else if(_loc2_ <= QuantityMenu.INV_MAX_NUM_BEFORE_QUANTITY_MENU)
					{
						this.BGSCodeObj.transferItem((param1.target as ItemList).selectedIndex,1,param1.target == this.ContainerList_mc);
						this.BlockNextListFocusSound = true;
						this.onTransferItem(stage.focus == this.PlayerInventory_mc.PlayerList_mc?this.ContainerList_mc:this.PlayerInventory_mc.PlayerList_mc);
					}
					else
					{
						_loc3_ = this.BGSCodeObj.getItemValue((param1.target as ItemList).selectedIndex,param1.target == this.ContainerList_mc);
						this.OpenQuantityMenu(_loc2_,_loc3_);
					}
				}
			}
		}
		
		public function onQuantityConfirm(param1:Event) : *
		{
			this.CloseQuantityMenu();
			this.BGSCodeObj.transferItem((stage.focus as ItemList).selectedIndex,this.QuantityMenu_mc.quantity,stage.focus == this.ContainerList_mc);
			this.onTransferItem(stage.focus == this.PlayerInventory_mc.PlayerList_mc?this.ContainerList_mc:this.PlayerInventory_mc.PlayerList_mc);
		}
		
		public function onAccept() : *
		{
			(stage.focus as ItemList).dispatchEvent(new Event(BSScrollingList.ITEM_PRESS,true,true));
		}
		
		public function onQuantityAccepted() : *
		{
			dispatchEvent(new Event(QuantityMenu.CONFIRM,true,true));
		}
		
		public function onTakeAll() : *
		{
			this.BGSCodeObj.takeAllItems();
		}
		
		public function onEquipOrStore() : *
		{
			trace("here");
			this.BGSCodeObj.sendYButton();
		}
		
		public function onExitMenu() : *
		{
			this.BGSCodeObj.exitMenu();
		}
		
		public function onQuantityCanceled() : *
		{
			this.CloseQuantityMenu();
		}
		
		public function onInspect() : *
		{
			if(this.InspectButton.ButtonVisible)
			{
				(stage.focus as ItemList).disableInput = true;
				this.BGSCodeObj.inspectItem();
			}
		}
		
		public function onEndInspect() : *
		{
			(stage.focus as ItemList).disableInput = false;
		}
		
		private function onSelectionChange(param1:Event) : *
		{
			this.UpdateItemDisplay(stage.focus as ItemList,!this.BlockNextListFocusSound);
			this.BlockNextListFocusSound = false;
			this.UpdateButtonHints();
		}
		
		private function onTransferItem(param1:Object) : *
		{
			if(param1 == this.ContainerList_mc && stage.focus == this.PlayerInventory_mc.PlayerList_mc)
			{
				if(this.ContainerInventory_mc.ContainerSwitchButton_tf.visible == false && uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
				{
					this.ContainerInventory_mc.ContainerSwitchButton_tf.visible = true;
					this.UpdateButtonHints();
					this.RepositionUpperBracketBars();
				}
			}
			else if(param1 == this.PlayerInventory_mc.PlayerList_mc && stage.focus == this.ContainerList_mc)
			{
				if(this.PlayerInventory_mc.PlayerSwitchButton_tf.visible == false && uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
				{
					this.PlayerInventory_mc.PlayerSwitchButton_tf.visible = true;
					this.UpdateButtonHints();
					this.RepositionUpperBracketBars();
				}
			}
		}
		
		private function UpdateItemDisplay(param1:ItemList, param2:Boolean = true) : *
		{
			this.UpdateItemCard();
			if(param1 != null)
			{
				this.BGSCodeObj.show3D(param1.selectedIndex,param1 == this.ContainerList_mc);
				this.BGSCodeObj.updateItemPickpocketInfo(param1.selectedIndex,param1 == this.ContainerList_mc,-1);
				if(this.PlayFocusSounds && param2)
				{
					this.BGSCodeObj.PlaySound("UIMenuFocus");
				}
			}
		}
		
		public function onKeyUp(param1:KeyboardEvent) : void
		{
			if(visible && this.uiMode != CM_JUNK_JET_RELOAD && !param1.isDefaultPrevented() && !this.QuantityMenu_mc.opened)
			{
				if(param1.keyCode == Keyboard.LEFT)
				{
					this.changeItemFilter(stage.focus as ItemList,-1);
				}
				else if(param1.keyCode == Keyboard.RIGHT)
				{
					this.changeItemFilter(stage.focus as ItemList,1);
				}
			}
		}
		
		private function changeItemFilter(param1:ItemList, param2:int) : *
		{
			var _loc3_:uint = param1 == this.PlayerInventory_mc.PlayerList_mc?uint(this.uiPlayerFilterIndex):uint(this.uiContainerFilterIndex);
			var _loc4_:uint = _loc3_;
			do
			{
				if(_loc4_ == 0 && param2 < 0)
				{
					_loc4_ = NUM_FILTERS - 1;
				}
				else if(_loc4_ == NUM_FILTERS - 1 && param2 > 0)
				{
					_loc4_ = 0;
				}
				else
				{
					_loc4_ = _loc4_ + param2;
				}
			}
			while(_loc4_ != _loc3_ && param1.filterer.IsFilterEmpty(this.FilterInfoA[_loc4_].flag));
			
			param1.filterer.itemFilter = this.FilterInfoA[_loc4_].flag;
			var _loc5_:* = param1 == this.PlayerInventory_mc.PlayerList_mc;
			if(_loc5_)
			{
				this.uiPlayerFilterIndex = _loc4_;
			}
			else
			{
				this.uiContainerFilterIndex = _loc4_;
			}
			if(_loc4_ != _loc3_)
			{
				this.BGSCodeObj.PlaySound(param2 > 0?"UIBarterHorizontalRight":"UIBarterHorizontalLeft");
				this.BGSCodeObj.sortItems(!_loc5_,_loc4_,false);
				this.BGSCodeObj.updateSortButtonLabel(!_loc5_,_loc4_);
				this.UpdateHeaderText(param1);
				param1.InvalidateData();
				if(uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && param1.selectedClipIndex == -1 && !param1.filterer.IsFilterEmpty(this.FilterInfoA[_loc4_].flag))
				{
					param1.selectedClipIndex = 0;
				}
			}
		}
		
		private function UpdateHeaderText(param1:ItemList) : *
		{
			if(param1 == this.PlayerInventory_mc.PlayerList_mc)
			{
				this.PlayerInventory_mc.PlayerListHeader.headerText = this.FilterInfoA[this.uiPlayerFilterIndex].text + "Mine";
			}
			else if(param1 == this.ContainerList_mc)
			{
				if(this.uiContainerFilterIndex == 0)
				{
					this.ContainerInventory_mc.ContainerListHeader.headerText = this.FilterInfoA[this.uiContainerFilterIndex].containerText;
				}
				else
				{
					this.ContainerInventory_mc.ContainerListHeader.headerText = this.FilterInfoA[this.uiContainerFilterIndex].text;
				}
			}
			this.RepositionUpperBracketBars();
		}
		
		private function onListHeaderClick(param1:Event) : *
		{
			var _loc2_:Boolean = false;
			if(visible && !this.QuantityMenu_mc.opened)
			{
				_loc2_ = param1.target.name == "LeftArrow" || param1.target.name == "LeftHitBox_tf";
				if(param1.target.parent == this.ContainerInventory_mc.ContainerListHeader || param1.target.parent == this.ContainerInventory_mc)
				{
					this.changeItemFilter(this.ContainerList_mc,!!_loc2_?-1:1);
				}
				else if(param1.target.parent == this.PlayerInventory_mc.PlayerListHeader || param1.target.parent == this.PlayerInventory_mc)
				{
					this.changeItemFilter(this.PlayerInventory_mc.PlayerList_mc,!!_loc2_?-1:1);
				}
			}
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(visible && !param2)
			{
				if(param1 == "Cancel" && this.QuantityMenu_mc.opened)
				{
					this.CloseQuantityMenu();
					_loc3_ = true;
				}
				if(!_loc3_)
				{
					if(this.QuantityMenu_mc.opened)
					{
						_loc3_ = this.QuantityMenu_mc.ProcessUserEvent(param1,param2);
					}
					if(!_loc3_)
					{
						if(param1 == "RTrigger")
						{
							this.SwitchToContainerList();
							_loc3_ = true;
						}
						else if(param1 == "LTrigger")
						{
							this.SwitchToPlayerList();
							_loc3_ = true;
						}
					}
				}
			}
			return _loc3_;
		}
		
		public function UpdateEncumbranceAndCaps(param1:Boolean, param2:uint, param3:uint, param4:uint, param5:int) : *
		{
			var _loc6_:* = "";
			if(param5)
			{
				_loc6_ = " (";
				if(param5 > 0)
				{
					_loc6_ = _loc6_ + "+";
				}
				_loc6_ = _loc6_ + param5.toString();
				_loc6_ = _loc6_ + ")";
			}
			if(param1)
			{
				if(this.ContainerInventory_mc.VendorCaps_tf != null)
				{
					GlobalFunc.SetText(this.ContainerInventory_mc.VendorCaps_tf,param4.toString() + _loc6_,false);
				}
			}
			else
			{
				if(this.PlayerInventory_mc.PlayerWeight_tf != null)
				{
					GlobalFunc.SetText(this.PlayerInventory_mc.PlayerWeight_tf,param2.toString() + "/" + param3.toString(),false);
				}
				if(this.PlayerInventory_mc.PlayerCaps_tf != null)
				{
					GlobalFunc.SetText(this.PlayerInventory_mc.PlayerCaps_tf,param4.toString() + _loc6_,false);
				}
			}
		}
		
		public function UpdatePickpocketInfo(param1:Boolean, param2:Boolean, param3:uint) : *
		{
			var _loc4_:* = undefined;
			this.PickpocketInfo_mc.Caption_tf.visible = param1;
			this.PickpocketInfo_mc.Percent_tf.visible = param1;
			if(param1)
			{
				GlobalFunc.SetText(this.PickpocketInfo_mc.Percent_tf,param3.toString() + "% ",false);
				GlobalFunc.SetText(this.PickpocketInfo_mc.Caption_tf,!!param2?"$TO STEAL":"$TO PLACE",false);
				this.PickpocketInfo_mc.Caption_tf.x = this.PickpocketInfo_mc.Percent_tf.textWidth;
				_loc4_ = this.PickpocketInfo_mc.Caption_tf.textWidth + this.PickpocketInfo_mc.Percent_tf.textWidth;
				this.PickpocketInfo_mc.x = (stage.stageWidth - _loc4_) / 2;
			}
		}
		
		override public function SetPlatform(param1:uint, param2:Boolean) : *
		{
			super.SetPlatform(param1,param2);
			GlobalFunc.SetText(this.PlayerInventory_mc.PlayerSwitchButton_tf,uiPlatform == PlatformChangeEvent.PLATFORM_PS4?"y":"Y",false);
			GlobalFunc.SetText(this.ContainerInventory_mc.ContainerSwitchButton_tf,uiPlatform == PlatformChangeEvent.PLATFORM_PS4?"x":"X",false);
		}
		
		public function onQuantityModified(param1:Event) : *
		{
			var _loc2_:BSScrollingList = this.QuantityMenu_mc.prevFocus as BSScrollingList;
			var _loc3_:int = (param1 as CustomEvent).params as int;
			this.BGSCodeObj.updateItemPickpocketInfo(_loc2_.selectedIndex,_loc2_ == this.ContainerList_mc,_loc3_);
			this.BGSCodeObj.PlaySound("UIMenuQuantity");
		}
		
		public function onToggleEquip() : *
		{
			var _loc1_:int = 0;
			var _loc2_:* = false;
			if(this.EquipOrStoreButton.ButtonVisible)
			{
				_loc1_ = (stage.focus as ItemList).selectedIndex;
				_loc2_ = stage.focus == this.ContainerList_mc;
				this.BGSCodeObj.toggleSelectedItemEquipped(_loc1_,_loc2_);
			}
		}
		
		public function requestSort() : *
		{
			if(this.SortButton.ButtonVisible)
			{
				if(stage.focus == this.ContainerList_mc)
				{
					this.BGSCodeObj.sortItems(true,this.uiContainerFilterIndex,true);
					this.BGSCodeObj.updateSortButtonLabel(true,this.uiContainerFilterIndex);
				}
				else
				{
					this.BGSCodeObj.sortItems(false,this.uiPlayerFilterIndex,true);
					this.BGSCodeObj.updateSortButtonLabel(false,this.uiPlayerFilterIndex);
				}
			}
		}
		
		public function set sortButtonLabel(param1:String) : *
		{
			this.SortButton.ButtonText = param1;
		}
		
		public function set messageBoxIsActive(param1:Boolean) : *
		{
			this.MessageBoxIsActive = param1;
			this.UpdateButtonHints();
		}
	}
}
