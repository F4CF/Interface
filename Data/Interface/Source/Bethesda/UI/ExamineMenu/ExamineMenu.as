package
{
	import Components.ItemCard;
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class ExamineMenu extends IMenu
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var InventoryList_mc:MovieClip;
		
		public var ItemName_tf:TextField;
		
		public var LegendaryItemDescription_tf:TextField;
		
		public var ModDescriptionBase_mc:MovieClip;
		
		public var ItemCardList_mc:ItemCard;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var InventoryBase_mc:MovieClip;
		
		public var ModSlotBase_mc:MovieClip;
		
		public var CurrentModsBase_mc:MovieClip;
		
		public var PerkPanel0_mc:MovieClip;
		
		public var PerkPanel1_mc:MovieClip;
		
		public var ItemCatcher:MovieClip;
		
		public var MouseReleaseCatcher:MovieClip;
		
		public var VaultBoySafeRectGroup_mc:MovieClip;
		
		public var ItemSelectBracketBase_mc:MovieClip;
		
		public var ComponentsBracketBase_mc:MovieClip;
		
		public var ModBracketBase_mc:MovieClip;
		
		public var ModSlotBracketBase_mc:MovieClip;
		
		public var InventoryBracketBase_mc:MovieClip;
		
		public var InventoryListObject:ListInfoObject;
		
		public var ModSlotListObject:ListInfoObject;
		
		public var ComponentsListObject:ListInfoObject;
		
		public var ModListObject:ListInfoObject;
		
		public var MiscItemListObject:ListInfoObject;
		
		public var RequirementsListObject:ListInfoObject;
		
		public var CurrentModsListObject:ListInfoObject;
		
		private var InspectModeButtons:Vector.<BSButtonHintData>;
		
		private var TakeButton:BSButtonHintData;
		
		private var NextButton:BSButtonHintData;
		
		private var PrevButton:BSButtonHintData;
		
		private var ZoomInButton:BSButtonHintData;
		
		private var ZoomOutButton:BSButtonHintData;
		
		private var ExitButton:BSButtonHintData;
		
		private var InventoryButtonHints:Vector.<BSButtonHintData>;
		
		private var ModSlotButtonHints:Vector.<BSButtonHintData>;
		
		private var ModButton:BSButtonHintData;
		
		private var BackButton:BSButtonHintData;
		
		private var ScrapButton:BSButtonHintData;
		
		private var RenameButton:BSButtonHintData;
		
		private var RepairButton:BSButtonHintData;
		
		private var ModsListHints:Vector.<BSButtonHintData>;
		
		private var AutoBuild:BSButtonHintData;
		
		private var ChooseComponents:BSButtonHintData;
		
		private var TagButton:BSButtonHintData;
		
		private var AlternateButton:BSButtonHintData;
		
		private var ComponentsListHints:Vector.<BSButtonHintData>;
		
		private var Build:BSButtonHintData;
		
		private var MiscItemListHints:Vector.<BSButtonHintData>;
		
		private var Add:BSButtonHintData;
		
		private var RotateButton:BSButtonHintData;
		
		private var CameraButton:BSButtonHintData;
		
		private const INVENTORY_MODE:uint = 0;
		
		private const SLOTS_MODE:uint = 1;
		
		private const MOD_MODE:uint = 2;
		
		private const REQUIREMENTS_MODE:uint = 3;
		
		private const ITEM_SELECT_MODE:uint = 4;
		
		private const INSPECT_MODE:uint = 5;
		
		private var _eMode:uint = 0;
		
		private var bConfirm = false;
		
		private var strStartName = "";
		
		private var strBuildOverrideText = "$COOK";
		
		private var strAlternateButtonText:String = "";
		
		private var AternateTextEnabled = true;
		
		private var LastFocusedClip:InteractiveObject;
		
		private var bEnteringText:Boolean = false;
		
		private var bQueuedBackToMods:Boolean = false;
		
		public var _inspectMode:Boolean = false;
		
		private var _featuredItemMode:Boolean = false;
		
		private var _singleItemInspectMode:Boolean = false;
		
		private var _itemNameManagedByCode:Boolean = false;
		
		private var Language:String = "en";
		
		public var _allowEquip:Boolean = false;
		
		public var _allowRename:Boolean = true;
		
		public var _allowRepair:Boolean = false;
		
		public var _showScrapButton:Boolean = true;
		
		public var _isCookingMenu:Boolean = false;
		
		public function ExamineMenu()
		{
			this.InventoryListObject = new ListInfoObject();
			this.ModSlotListObject = new ListInfoObject();
			this.ComponentsListObject = new ListInfoObject();
			this.ModListObject = new ListInfoObject();
			this.MiscItemListObject = new ListInfoObject();
			this.RequirementsListObject = new ListInfoObject();
			this.CurrentModsListObject = new ListInfoObject();
			this.TakeButton = new BSButtonHintData("$TAKE","Enter","PSN_A","Xenon_A",1,this.onTakeButton);
			this.NextButton = new BSButtonHintData("$NEXT","S","PSN_R1","Xenon_R1",1,this.onNextButton);
			this.PrevButton = new BSButtonHintData("$PREV","W","PSN_L1","Xenon_L1",1,this.onPreviousButton);
			this.ZoomInButton = new BSButtonHintData("$ZOOM IN","Wheel up","PSN_R2","Xenon_R2",1,this.onZoomInButton);
			this.ZoomOutButton = new BSButtonHintData("$ZOOM OUT","Wheel down","PSN_L2","Xenon_L2",1,this.onZoomOutButton);
			this.ExitButton = new BSButtonHintData("$EXIT","TAB","PSN_B","Xenon_B",1,this.onBackButton);
			this.ModButton = new BSButtonHintData("$MODIFY","E","PSN_A","Xenon_A",1,this.onModButton);
			this.BackButton = new BSButtonHintData("$BACK","TAB","PSN_B","Xenon_B",1,this.onBackButton);
			this.ScrapButton = new BSButtonHintData("$SCRAP","R","PSN_X","Xenon_X",1,this.onScrapBuildAdd);
			this.RenameButton = new BSButtonHintData("$RENAME","T","PSN_Y","Xenon_Y",1,this.onRenameRepairSearch);
			this.RepairButton = new BSButtonHintData("$REPAIR","T","PSN_Y","Xenon_Y",1,this.onRenameRepairSearch);
			this.AutoBuild = new BSButtonHintData("$BUILD","E","PSN_A","Xenon_A",1,this.onScrapBuildAdd);
			this.ChooseComponents = new BSButtonHintData("$CHOOSE COMPONENTS","E","PSN_A","Xenon_A",1,this.onModButton);
			this.TagButton = new BSButtonHintData("$TAG FOR SEARCH","T","PSN_Y","Xenon_Y",1,this.onRenameRepairSearch);
			this.AlternateButton = new BSButtonHintData("","R","PSN_X","Xenon_X",1,this.onAlternateButton);
			this.Build = new BSButtonHintData("$BUILD","R","PSN_X","Xenon_X",1,this.onScrapBuildAdd);
			this.Add = new BSButtonHintData("$ADD","R","PSN_X","Xenon_X",1,this.onScrapBuildAdd);
			this.RotateButton = new BSButtonHintData("$ROTATE","A/D","PSN_L2R2","Xenon_L2R2",1,null);
			this.CameraButton = new BSButtonHintData("$CAMERA","C","PSN_L1","Xenon_L1",1,null);
			super();
			addFrameScript(0,this.frame1,4,this.frame5,13,this.frame14,21,this.frame22,29,this.frame30,37,this.frame38,38,this.frame39,46,this.frame47,54,this.frame55,62,this.frame63,70,this.frame71,71,this.frame72);
			this.BGSCodeObj = new Object();
			this.PopulateButtonBar();
			this.InventoryListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.InventorySelectionChange);
			this.ModSlotListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.FillPossibleModPartArray);
			this.ModListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
			this.RequirementsListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.UpdateMiscItemList);
			this.MiscItemListObject.CategoryNameList = new Array();
			addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
			addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			this.ItemCatcher.addEventListener(MouseEvent.MOUSE_DOWN,this.OnStartRotateItem);
			stage.addEventListener(MouseEvent.MOUSE_UP,this.OnStopRotateItem);
			this.SetInventoryLabel("$INVENTORY");
			this.MouseReleaseCatcher.visible = false;
			stage.stageFocusRect = false;
			this.alpha = 0;
			this.ItemName_tf.selectable = false;
			this.itemName = "";
			this.CurrentModsBase_mc.visible = false;
			this.CurrentModsBase_mc.ModSlotList_mc.disableSelection = true;
			this.UpdatePerks();
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.ItemName_tf,"shrink");
			TextFieldEx.setTextAutoSize(this.PerkPanel0_mc.PerkName_tf,"shrink");
			TextFieldEx.setTextAutoSize(this.PerkPanel1_mc.PerkName_tf,"shrink");
		}
		
		public function AddRotateButtons() : *
		{
			this.InventoryButtonHints.push(this.RotateButton);
			this.ModsListHints.push(this.RotateButton);
			this.ModSlotButtonHints.push(this.RotateButton);
			this.InventoryButtonHints.push(this.CameraButton);
			this.ModsListHints.push(this.CameraButton);
			this.ModSlotButtonHints.push(this.CameraButton);
		}
		
		public function get inspectMode() : *
		{
			return this._inspectMode;
		}
		
		public function set inspectMode(param1:Boolean) : *
		{
			this._inspectMode = param1;
		}
		
		public function set singleItemInspectMode(param1:Boolean) : *
		{
			this._singleItemInspectMode = param1;
			this.PrevButton.ButtonVisible = this.NextButton.ButtonVisible = !this._singleItemInspectMode;
		}
		
		public function set featuredItemMode(param1:Boolean) : *
		{
			this._featuredItemMode = param1;
			this.TakeButton.ButtonVisible = this._featuredItemMode;
			this.ExitButton.ButtonVisible = !this._featuredItemMode;
			if(this._featuredItemMode)
			{
				this.singleItemInspectMode = true;
			}
		}
		
		public function set alternateTextEnabled(param1:Boolean) : *
		{
			this.AternateTextEnabled = param1;
		}
		
		public function set alternateButtonText(param1:String) : *
		{
			this.strAlternateButtonText = param1;
		}
		
		public function set itemNameManagedByCode(param1:Boolean) : *
		{
			this._itemNameManagedByCode = param1;
		}
		
		public function get shouldHighlight() : Boolean
		{
			return this.eMode != this.INVENTORY_MODE;
		}
		
		public function get inventoryLevel() : Boolean
		{
			return this.eMode == this.INVENTORY_MODE;
		}
		
		public function get resetItemRotation() : Boolean
		{
			return this.eMode == this.INVENTORY_MODE || this.eMode == this.INSPECT_MODE;
		}
		
		public function get shouldReshow() : Boolean
		{
			return this.eMode == this.INVENTORY_MODE || this.eMode == this.MOD_MODE || this.eMode == this.INSPECT_MODE;
		}
		
		public function set allowEquip(param1:Boolean) : *
		{
			this._allowEquip = param1;
		}
		
		public function set BuildOverrideText(param1:String) : *
		{
			this.strBuildOverrideText = param1;
		}
		
		public function get allowRename() : *
		{
			return this.eMode == this.INVENTORY_MODE && this._allowRename;
		}
		
		public function set allowRename(param1:Boolean) : *
		{
			this._allowRename = param1;
		}
		
		public function set allowRepair(param1:Boolean) : *
		{
			this._allowRepair = param1;
		}
		
		public function set showScrapButton(param1:Boolean) : *
		{
			this._showScrapButton = param1;
		}
		
		public function get isCookingMenu() : Boolean
		{
			return this._isCookingMenu;
		}
		
		public function set language(param1:String) : *
		{
			this.Language = param1.toLowerCase();
		}
		
		override protected function onSetSafeRect() : void
		{
			GlobalFunc.LockToSafeRect(this.VaultBoySafeRectGroup_mc,"TL",SafeX,SafeY);
		}
		
		private function OnStartRotateItem(param1:MouseEvent) : void
		{
			this.BGSCodeObj.StartRotate3DItem();
			this.MouseReleaseCatcher.visible = true;
		}
		
		private function OnStopRotateItem(param1:MouseEvent) : void
		{
			this.BGSCodeObj.EndRotate3DItem();
			this.MouseReleaseCatcher.visible = false;
		}
		
		public function AllowRotate() : Boolean
		{
			return this.eMode != this.MOD_MODE || this.ModSlotBase_mc.ModSlotList_mc.entryList.length <= 5;
		}
		
		public function onKeyUp(param1:KeyboardEvent) : void
		{
			if(param1.keyCode == 13 && this.bEnteringText)
			{
				this.enteringText = !this.enteringText;
			}
		}
		
		private function onItemPressed(param1:Event) : *
		{
			if(!this.bEnteringText)
			{
				this.onModButton();
				param1.stopPropagation();
			}
		}
		
		public function set itemName(param1:String) : *
		{
			GlobalFunc.SetText(this.ItemName_tf,param1,false,true);
		}
		
		private function PopulateButtonBar() : void
		{
			this.InspectModeButtons = new Vector.<BSButtonHintData>();
			this.InspectModeButtons.push(this.TakeButton);
			this.TakeButton.ButtonVisible = false;
			this.InspectModeButtons.push(this.PrevButton);
			this.InspectModeButtons.push(this.NextButton);
			this.InspectModeButtons.push(this.ZoomInButton);
			this.InspectModeButtons.push(this.ZoomOutButton);
			this.InspectModeButtons.push(this.ExitButton);
			this.InventoryButtonHints = new Vector.<BSButtonHintData>();
			this.ModSlotButtonHints = new Vector.<BSButtonHintData>();
			this.InventoryButtonHints.push(this.ScrapButton);
			this.InventoryButtonHints.push(this.RepairButton);
			this.InventoryButtonHints.push(this.ModButton);
			this.InventoryButtonHints.push(this.RenameButton);
			this.InventoryButtonHints.push(this.BackButton);
			this.InventoryButtonHints.push(this.AlternateButton);
			this.ModSlotButtonHints.push(this.ModButton);
			this.ModSlotButtonHints.push(this.BackButton);
			this.ModSlotButtonHints.push(this.AlternateButton);
			this.ModsListHints = new Vector.<BSButtonHintData>();
			this.ModsListHints.push(this.AutoBuild);
			this.ModsListHints.push(this.TagButton);
			this.ModsListHints.push(this.BackButton);
			this.ModsListHints.push(this.AlternateButton);
			this.ComponentsListHints = new Vector.<BSButtonHintData>();
			this.ComponentsListHints.push(this.Build);
			this.ComponentsListHints.push(this.ChooseComponents);
			this.ComponentsListHints.push(this.BackButton);
			this.MiscItemListHints = new Vector.<BSButtonHintData>();
			this.MiscItemListHints.push(this.Add);
			this.MiscItemListHints.push(this.BackButton);
			this.ButtonHintBar_mc.SetButtonHintData(this.InventoryButtonHints);
		}
		
		public function StartInspectMode() : *
		{
			this.ButtonHintBar_mc.SetButtonHintData(this.InspectModeButtons);
			gotoAndStop("InspectMode");
			this.InventoryBase_mc.visible = false;
			this.CurrentModsBase_mc.ModSlotList_mc.visible = true;
			this.CurrentModsListObject.SetActive(this.CurrentModsBase_mc.ModSlotList_mc,"CurrentModsListObject");
			this.eMode = this.INSPECT_MODE;
			this.InventoryBase_mc.InventoryList_mc.disableInput = true;
		}
		
		public function RegisterComponents() : *
		{
			this.alpha = 1;
			this.BGSCodeObj.RegisterComponents(this,this.InventoryListObject,this.ItemName_tf,this.ModDescriptionBase_mc.ModDescription_tf,this.ItemCardList_mc,this.ComponentsListObject,this.ModSlotListObject,this.ModListObject,this.MiscItemListObject,this.RequirementsListObject,this.ButtonHintBar_mc,this.CurrentModsListObject);
			this.ItemCardList_mc.scaleX = 0.7;
			this.ItemCardList_mc.scaleY = 0.7;
			this.AdjustBracket(this.InventoryBracketBase_mc);
			this.AdjustBracket(this.ModSlotBracketBase_mc);
			this.AdjustBracket(this.ModBracketBase_mc);
			this.AdjustBracket(this.ComponentsBracketBase_mc);
			this.AdjustBracket(this.ItemSelectBracketBase_mc);
			stage.focus = this.InventoryBase_mc.InventoryList_mc;
			if(!this._isCookingMenu)
			{
				this.InventoryListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"InventoryListObject");
				this.ModSlotListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"ModSlotListObject");
				this.ModSlotBase_mc.ModSlotList_mc.disableSelection = true;
				this.ModSlotBase_mc.ModSlotList_mc.allowWheelScrollNoSelectionChange = true;
			}
			this.ModSlotBase_mc.ModSlotList_mc.selectedIndex = -1;
			this.ModSlotBase_mc.ModSlotList_mc.InvalidateData();
			this.UpdateDescription();
		}
		
		public function FillPossibleModPartArray(param1:Event) : *
		{
			if(this.ModSlotListObject.selectedIndex > -1 && this.ModListObject.entryList)
			{
				this.BGSCodeObj.FillModPartArray(this.ModListObject.entryList,this.ModListObject);
			}
			this.UpdateDescription();
		}
		
		public function ModChange(param1:Event) : *
		{
			if(!this.bEnteringText)
			{
				this.onModChange();
			}
			else
			{
				this.AbortTextEditing();
			}
		}
		
		public function onModChange() : *
		{
			var _loc1_:Array = null;
			if(!this._isCookingMenu || this.eMode == this.MOD_MODE)
			{
				_loc1_ = new Array();
				this.BGSCodeObj.SwitchMod(this.ModListObject.selectedIndex,_loc1_);
				this.BGSCodeObj.UpdateRequirements();
				this.AutoBuild.ButtonEnabled = this.GetBuildable(true);
				this.AutoBuild.ButtonVisible = true;
				this.AutoBuild.ButtonText = !!this.GetLooseModAvailable()?"$ATTACH MOD":"$BUILD";
				if(this.eMode == this.MOD_MODE && this.ModListObject.entryList[this.ModListObject.selectedIndex].hasLooseMod)
				{
					this.ChooseComponents.ButtonText = "$ATTACH MOD";
				}
				else
				{
					this.ChooseComponents.ButtonText = "$CHOOSE COMPONENTS";
				}
				this.UpdatePerks();
				this.UpdateDescription();
				this.UpdateButtons();
			}
		}
		
		public function UpdatePerks() : *
		{
			var _loc1_:uint = 0;
			var _loc2_:MovieClip = null;
			var _loc3_:TextFormat = null;
			if(this.eMode != this.MOD_MODE)
			{
				this.PerkPanel0_mc.visible = false;
				this.PerkPanel1_mc.visible = false;
			}
			else if(this.ModListObject.selectedIndex >= 0 && this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData != null)
			{
				_loc1_ = 0;
				while(_loc1_ < 2)
				{
					_loc2_ = getChildByName("PerkPanel" + _loc1_ + "_mc") as MovieClip;
					if(_loc1_ < this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData.length)
					{
						_loc2_.visible = true;
						if(this.Language == "ru" || this.Language == "pl")
						{
							_loc3_ = _loc2_.PerkName_tf.getTextFormat();
							_loc3_.font = "$MAIN_Font_Bold";
							_loc3_.size = 20;
							_loc3_.align = "left";
							_loc2_.Requires_tf.setTextFormat(_loc3_);
							TextFieldEx.setTextAutoSize(_loc2_.Requires_tf,"shrink");
							GlobalFunc.SetText(_loc2_.Requires_tf,"$Req:",false);
							GlobalFunc.SetText(_loc2_.Requires_tf,!!this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData[_loc1_].perkRank?_loc2_.Requires_tf.text + " " + this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData[_loc1_].perkRank.toString():"",false);
							_loc2_.Requires_tf.setTextFormat(_loc3_);
							ShrinkFontToFit(_loc2_.Requires_tf,1);
						}
						else
						{
							GlobalFunc.SetText(_loc2_.Requires_tf,"$Req:",false);
							GlobalFunc.SetText(_loc2_.Requires_tf,!!this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData[_loc1_].perkRank?_loc2_.Requires_tf.text + " " + this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData[_loc1_].perkRank.toString():"",false);
							ShrinkFontToFit(_loc2_.Requires_tf,1);
						}
						_loc2_.PerkLock_mc.visible = this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData[_loc1_].perkLocked;
						if(this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData[_loc1_].perkName != _loc2_.PerkName_tf.text)
						{
							if(this.Language == "ru" || this.Language == "pl")
							{
								_loc3_ = _loc2_.PerkName_tf.getTextFormat();
								_loc3_.font = "$MAIN_Font_Bold";
								_loc2_.PerkName_tf.setTextFormat(_loc3_);
								GlobalFunc.SetText(_loc2_.PerkName_tf,this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData[_loc1_].perkName,false);
								_loc2_.PerkName_tf.setTextFormat(_loc3_);
							}
							else
							{
								GlobalFunc.SetText(_loc2_.PerkName_tf,this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData[_loc1_].perkName,false);
							}
							_loc2_.PerkLoaderClip_mc.clipScale = 0.39;
							_loc2_.PerkLoaderClip_mc.SWFLoad("Components/Vaultboys/Perks/PerkClip_" + this.ModListObject.entryList[this.ModListObject.selectedIndex].perkData[_loc1_].perkID.toString(16));
						}
					}
					else
					{
						_loc2_.visible = false;
					}
					_loc1_++;
				}
			}
		}
		
		public function InventorySelectionChange(param1:Event) : *
		{
			this.AbortTextEditing();
			if(!this._isCookingMenu)
			{
				this.BGSCodeObj.SwitchBaseItem();
				this.FillPossibleModPartArray(new Event(""));
				this.UpdateButtons();
			}
			this.ItemCardList_mc.showItemDesc = this.LegendaryItemDescription_tf.text == " ";
		}
		
		public function SetInventoryLabel(param1:String) : *
		{
			GlobalFunc.SetText(this.InventoryBracketBase_mc.Label_tf,param1,false);
			this.AdjustBracket(this.InventoryBracketBase_mc);
		}
		
		public function SetModSlotsLabel(param1:String) : *
		{
			GlobalFunc.SetText(this.ModSlotBracketBase_mc.Label_tf,param1,false);
			this.AdjustBracket(this.InventoryBracketBase_mc);
		}
		
		public function SetModsLabel(param1:String) : *
		{
			GlobalFunc.SetText(this.ModBracketBase_mc.Label_tf,param1,false);
			this.AdjustBracket(this.InventoryBracketBase_mc);
		}
		
		private function AdjustBracket(param1:MovieClip) : *
		{
			var _loc2_:* = param1.RightBarReference_mc.x;
			param1.ModListBracketTopRight_mc.x = param1.Label_tf.x + param1.Label_tf.textWidth + 1;
			var _loc3_:uint = 2;
			param1.ModListBracketTopRight_mc.width = _loc2_ - param1.ModListBracketTopRight_mc.x - _loc3_;
		}
		
		private function UpdateMiscItemList() : *
		{
			this.MiscItemListObject.filterer.itemFilter = 1 << this.RequirementsListObject.selectedIndex;
			this.MiscItemListObject.RefreshList();
			this.UpdateButtons();
		}
		
		private function SetRightListLabel(param1:String) : *
		{
			GlobalFunc.SetText(this.ModSlotBase_mc.SlotsLabel_tf,param1,false);
		}
		
		public function ModModeToSlotsMode() : *
		{
			this.BGSCodeObj.RevertChanges();
			this.bQueuedBackToMods = true;
		}
		
		public function ExecuteQueuedActions() : *
		{
			if(this.bQueuedBackToMods)
			{
				this.ModListObject.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
				this.bQueuedBackToMods = false;
				this.eMode = this.SLOTS_MODE;
				gotoAndPlay("ModsBack");
				this.RequirementsListObject.SetInactive();
				this.ModSlotListObject.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.FillPossibleModPartArray);
				this.ModSlotListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ModSlotListObject");
				this.ModListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"ModListObject");
				this.SetRightListLabel(!!this._isCookingMenu?"$AVAILABLE RECIPES:":"$AVAILABLE MODS:");
				this.ModSlotListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.FillPossibleModPartArray);
				this.UpdatePerks();
				this.UpdateDescription();
			}
		}
		
		public function InventoryModeToSlotsMode() : *
		{
			if(this._isCookingMenu || this.ModSlotBase_mc.ModSlotList_mc.entryList.length > 0)
			{
				gotoAndPlay("ModSlots");
				if(!this._isCookingMenu)
				{
					this.InventoryListObject.SetInactive();
				}
				this.ModListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"ModListObject");
				this.ModSlotListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ModSlotListObject");
				this.InventoryBase_mc.InventoryList_mc.selectedIndex = -1;
				this.InventoryBase_mc.InventoryList_mc.moveSelectionDown();
				this.SetRightListLabel(!!this._isCookingMenu?"$AVAILABLE RECIPES:":"$AVAILABLE MODS:");
				this.eMode = this.SLOTS_MODE;
				this.BGSCodeObj.PlaySound("UIMenuOK");
			}
			else
			{
				this.BGSCodeObj.PlaySound("UICancel");
			}
		}
		
		public function CookingMode() : *
		{
			this._isCookingMenu = true;
			this.InventoryBracketBase_mc.visible = false;
			this.ModButton.ButtonText = "$Select";
			this.Build.ButtonText = this.strBuildOverrideText;
			this.AutoBuild.ButtonText = this.strBuildOverrideText;
		}
		
		private function GetModEquipped() : *
		{
			return this.ModListObject.entryList.length > this.ModListObject.selectedIndex && this.ModListObject.selectedIndex >= 0 && this.ModListObject.entryList[this.ModListObject.selectedIndex].equipState != undefined && this.ModListObject.entryList[this.ModListObject.selectedIndex].equipState > 0;
		}
		
		private function GetLooseModAvailable() : *
		{
			return this.ModListObject.entryList.length > this.ModListObject.selectedIndex && this.ModListObject.selectedIndex >= 0 && this.ModListObject.entryList[this.ModListObject.selectedIndex].hasLooseMod == true;
		}
		
		private function GetBuildable(param1:Boolean) : Boolean
		{
			return !this.GetModEquipped() && (this.GetLooseModAvailable() || this.BGSCodeObj.CheckRequirements(param1));
		}
		
		public function UpdateButtons() : *
		{
			this.BackButton.ButtonText = this.eMode == this.SLOTS_MODE && !!this._isCookingMenu?"$EXIT":"$BACK";
			switch(this.eMode)
			{
				case this.INVENTORY_MODE:
					this.ButtonHintBar_mc.SetButtonHintData(this.InventoryButtonHints);
					if(this._allowEquip)
					{
						this.ScrapButton.ButtonText = !!this.BGSCodeObj.IsSelectedItemEquipped()?"$UNEQUIP":"$EQUIP";
					}
					this.AlternateButton.ButtonVisible = this.strAlternateButtonText.length > 0;
					this.AlternateButton.ButtonText = this.strAlternateButtonText;
					this.AlternateButton.ButtonEnabled = this.AternateTextEnabled;
					if(this._allowRepair)
					{
						this.RepairButton.ButtonEnabled = this.BGSCodeObj.CanRepairSelectedItem();
					}
					this.RepairButton.ButtonVisible = this._allowRepair;
					this.RenameButton.ButtonVisible = !this._allowRepair && this._allowRename;
					this.ScrapButton.ButtonVisible = this._showScrapButton;
					break;
				case this.SLOTS_MODE:
					this.ButtonHintBar_mc.SetButtonHintData(this.ModSlotButtonHints);
					this.AlternateButton.ButtonVisible = this.strAlternateButtonText.length > 0;
					this.AlternateButton.ButtonText = this.strAlternateButtonText;
					this.AlternateButton.ButtonEnabled = this.AternateTextEnabled;
					break;
				case this.MOD_MODE:
					this.ButtonHintBar_mc.SetButtonHintData(this.ModsListHints);
					this.AutoBuild.ButtonEnabled = this.GetBuildable(true);
					this.AutoBuild.ButtonVisible = true;
					this.AutoBuild.ButtonText = !!this.GetLooseModAvailable()?"$ATTACH MOD":!!this._isCookingMenu?this.strBuildOverrideText:"$BUILD";
					this.TagButton.ButtonEnabled = this.BGSCodeObj.ShouldShowTagForSearchButton();
					this.AlternateButton.ButtonVisible = this.strAlternateButtonText.length > 0;
					this.AlternateButton.ButtonText = this.strAlternateButtonText;
					this.AlternateButton.ButtonEnabled = this.AternateTextEnabled;
					break;
				case this.REQUIREMENTS_MODE:
					this.ButtonHintBar_mc.SetButtonHintData(this.ComponentsListHints);
					this.BGSCodeObj.SetItemSelectValuesForComponents(this.MiscItemListObject.entryList,this.MiscItemListObject.CategoryNameList);
					this.AutoBuild.ButtonEnabled = this.GetBuildable(true);
					this.AutoBuild.ButtonVisible = true;
					this.ChooseComponents.ButtonEnabled = !this.ModSlotBase_mc.ModSlotList_mc.filterer.IsFilterEmpty(this.ModSlotBase_mc.ModSlotList_mc.filterer.itemFilter);
					break;
				case this.ITEM_SELECT_MODE:
					this.ButtonHintBar_mc.SetButtonHintData(this.MiscItemListHints);
			}
			this.ModSlotBase_mc.ModSlotList_mc.ScrollUp.alpha = this.eMode == this.MOD_MODE?1:0;
			this.ModSlotBase_mc.ModSlotList_mc.ScrollDown.alpha = this.eMode == this.MOD_MODE?1:0;
		}
		
		private function set eMode(param1:uint) : *
		{
			this._eMode = param1;
			this.UpdateButtons();
		}
		
		private function get eMode() : *
		{
			return this._eMode;
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!this.bEnteringText)
			{
				if(this.eMode == this.ITEM_SELECT_MODE)
				{
					stage.focus = this.ModSlotBase_mc.ModSlotList_mc;
				}
				else if(stage.focus != this.ModSlotBase_mc.ModSlotList_mc)
				{
					stage.focus = this.InventoryBase_mc.InventoryList_mc;
				}
				if(param2 == false)
				{
					switch(param1)
					{
						case "Activate":
						case "Accept":
							if(this._featuredItemMode)
							{
								this.onTakeButton();
							}
							break;
						case "Left":
						case "StrafeLeft":
							if(this.eMode == this.INSPECT_MODE || this.eMode == this.INVENTORY_MODE || this.eMode == this.SLOTS_MODE && this._isCookingMenu)
							{
								break;
							}
						case "Cancel":
							this.onBackButton();
							_loc3_ = true;
							break;
						case "StrafeRight":
						case "Right":
							this.onModButton();
							_loc3_ = true;
							break;
						case "XButton":
							if(this.ScrapButton.ButtonVisible && this.ScrapButton.ButtonEnabled)
							{
								this.onScrapBuildAdd();
							}
							_loc3_ = true;
							break;
						case "YButton":
							if(!this.inspectMode)
							{
								this.onRenameRepairSearch();
							}
							_loc3_ = true;
							break;
						case "RShoulder":
						case "Back":
							if(this.eMode == this.INSPECT_MODE && !this._singleItemInspectMode)
							{
								this.InventoryBase_mc.InventoryList_mc.moveSelectionDown();
								if(!this._itemNameManagedByCode)
								{
									this.itemName = this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex].text;
								}
								_loc3_ = true;
							}
							break;
						case "LShoulder":
						case "Forward":
							if(this.eMode == this.INSPECT_MODE && !this._singleItemInspectMode)
							{
								this.InventoryBase_mc.InventoryList_mc.moveSelectionUp();
								if(!this._itemNameManagedByCode)
								{
									this.itemName = this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex].text;
								}
								_loc3_ = true;
							}
					}
					this.UpdateDescription();
					this.UpdatePerks();
				}
				return _loc3_;
			}
			if(param2 == false && param1 == "Cancel")
			{
				this.AbortTextEditing();
				_loc3_ = true;
			}
			return true;
		}
		
		private function onMouseWheel(param1:MouseEvent) : *
		{
			if(this.eMode == this.INSPECT_MODE)
			{
				if(param1.delta < 0)
				{
					this.BGSCodeObj.ZoomOut();
				}
				else if(param1.delta > 0)
				{
					this.BGSCodeObj.ZoomIn();
				}
			}
		}
		
		private function onNextButton() : void
		{
			this.InventoryBase_mc.InventoryList_mc.moveSelectionDown();
			if(!this._itemNameManagedByCode)
			{
				this.itemName = this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex].text;
			}
		}
		
		private function onPreviousButton() : void
		{
			this.InventoryBase_mc.InventoryList_mc.moveSelectionUp();
			if(!this._itemNameManagedByCode)
			{
				this.itemName = this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex].text;
			}
		}
		
		private function onZoomInButton() : void
		{
			this.BGSCodeObj.ZoomIn();
		}
		
		private function onZoomOutButton() : void
		{
			this.BGSCodeObj.ZoomOut();
		}
		
		private function onRenameRepairSearch() : void
		{
			var _loc1_:Boolean = false;
			if(this.eMode == this.MOD_MODE)
			{
				if(this.BGSCodeObj.ToggleFavoriteMod())
				{
					this.BGSCodeObj.PlaySound("UIMenuPrevNext");
					_loc1_ = this.ModListObject.entryList[this.ModListObject.selectedIndex].modTaggedForSearch;
					this.ModListObject.entryList[this.ModListObject.selectedIndex].modTaggedForSearch = !!_loc1_?false:true;
					this.ModListObject.RefreshList();
					this.UpdateButtons();
				}
			}
			else if(this._allowRepair)
			{
				if(this.eMode == this.INVENTORY_MODE)
				{
					this.BGSCodeObj.RepairSelectedItem();
				}
			}
			else if(this.allowRename && !this.enteringText)
			{
				this.enteringText = !this.enteringText;
			}
		}
		
		private function onScrapBuildAdd() : void
		{
			if(this.strAlternateButtonText)
			{
				this.onAlternateButton();
			}
			else
			{
				switch(this.eMode)
				{
					case this.INVENTORY_MODE:
						if(this._allowEquip)
						{
							this.BGSCodeObj.ToggleItemEquipped();
						}
						else
						{
							this.BGSCodeObj.ScrapItem();
						}
						break;
					case this.MOD_MODE:
					case this.REQUIREMENTS_MODE:
						if(this.eMode != this.MOD_MODE && !this.GetModEquipped())
						{
							this.BGSCodeObj.OnBuildFailed();
						}
						else
						{
							this.BGSCodeObj.PlaySound("UIMenuCancel");
						}
						break;
					case this.ITEM_SELECT_MODE:
						if(this.MiscItemListObject.selectedIndex >= 0)
						{
							this.BGSCodeObj.ItemSelect(this.MiscItemListObject.entryList,uint(this.MiscItemListObject.selectedIndex),this.MiscItemListObject.CategoryNameList,uint(Math.log(this.MiscItemListObject.filterer.itemFilter) / Math.log(2)),this.MiscItemListObject.filterer.itemFilter);
							this.RequirementsListObject.RefreshList();
						}
				}
			}
		}
		
		private function onAlternateButton() : void
		{
			this.BGSCodeObj.OnAlternateButton();
		}
		
		private function onModButton() : void
		{
			switch(this.eMode)
			{
				case this.INVENTORY_MODE:
					if(!this.enteringText)
					{
						this.InventoryModeToSlotsMode();
					}
					else
					{
						this.enteringText = false;
					}
					break;
				case this.SLOTS_MODE:
					gotoAndPlay("Mods");
					this.ModSlotListObject.SetInactive();
					this.RequirementsListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"RequirementsListObject");
					this.ModListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ModListObject");
					this.SetRightListLabel("$REQUIRES:");
					this.ModListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
					this.InventoryBase_mc.InventoryList_mc.selectedIndex = -1;
					this.InventoryBase_mc.InventoryList_mc.moveSelectionDown();
					this.eMode = this.MOD_MODE;
					this.BGSCodeObj.PlaySound("UIMenuOK");
					if(this._isCookingMenu)
					{
						this.onModChange();
					}
					break;
				case this.MOD_MODE:
					if(!this.GetModEquipped())
					{
						if(this.ModListObject.entryList[this.ModListObject.selectedIndex].hasLooseMod)
						{
							this.BGSCodeObj.ConfirmBuild();
							this.BGSCodeObj.PlaySound("UIMenuOK");
						}
						else
						{
							this.BGSCodeObj.StartBuildConfirm();
						}
					}
					break;
				case this.REQUIREMENTS_MODE:
					if(this.ChooseComponents.ButtonEnabled)
					{
						stage.focus = this.ModSlotBase_mc.ModSlotList_mc;
						this.ModSlotBase_mc.ModSlotList_mc.selectedIndex = this.ModSlotBase_mc.ModSlotList_mc.filterer.ClampIndex(-1);
						this.ModSlotBase_mc.ModSlotList_mc.InvalidateData();
						this.eMode = this.ITEM_SELECT_MODE;
						this.BGSCodeObj.SetItemSelectValuesForComponents(this.MiscItemListObject.entryList,this.MiscItemListObject.CategoryNameList);
						this.BGSCodeObj.PlaySound("UIMenuOK");
					}
					else
					{
						this.BGSCodeObj.PlaySound("UIMenuCancel");
					}
					break;
				case this.ITEM_SELECT_MODE:
			}
			this.UpdateDescription();
			this.UpdatePerks();
			this.BGSCodeObj.SendTutorialEvent(this.eMode);
		}
		
		private function onTakeButton() : void
		{
			this.BGSCodeObj.HideMenu();
		}
		
		private function onBackButton() : void
		{
			switch(this.eMode)
			{
				case this.INVENTORY_MODE:
				case this.INSPECT_MODE:
					if(!this._featuredItemMode)
					{
						this.BGSCodeObj.HideMenu();
					}
					break;
				case this.SLOTS_MODE:
					if(!this._isCookingMenu)
					{
						gotoAndPlay("ModSlotsBack");
						this.ModListObject.SetInactive();
						this.ModSlotListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"ModSlotListObject");
						this.InventoryListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"InventoryListObject");
						this.InventoryListObject.RefreshList();
						this.ModSlotListObject.RefreshList();
						this.ModListObject.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
						this.SetRightListLabel("$CURRENT MODS:");
						this.eMode = this.INVENTORY_MODE;
						this.BGSCodeObj.PlaySound("UIMenuCancel");
						this.BGSCodeObj.RemoveHighlight();
					}
					else
					{
						this.BGSCodeObj.HideMenu();
					}
					break;
				case this.MOD_MODE:
					this.ModModeToSlotsMode();
					this.BGSCodeObj.PlaySound("UIMenuCancel");
					break;
				case this.REQUIREMENTS_MODE:
					gotoAndPlay("ComponentsBack");
					this.MiscItemListObject.SetInactive();
					this.ModListObject.SetActive(this.InventoryBase_mc.InventoryList_mc,"ModListObject");
					this.ModListObject.RefreshList();
					this.RequirementsListObject.SetActive(this.ModSlotBase_mc.ModSlotList_mc,"RequirementsListObject");
					this.RequirementsListObject.RefreshList();
					this.SetRightListLabel("$REQUIRES:");
					this.ModListObject.addEventListener(BSScrollingList.SELECTION_CHANGE,this.ModChange);
					this.eMode = this.MOD_MODE;
					this.BGSCodeObj.PlaySound("UIMenuCancel");
					break;
				case this.ITEM_SELECT_MODE:
					stage.focus = this.InventoryBase_mc.InventoryList_mc;
					this.RequirementsListObject.selectedIndex = -1;
					this.InventoryBase_mc.InventoryList_mc.moveSelectionDown();
					this.MiscItemListObject.selectedIndex = -1;
					this.SetRightListLabel("$ITEMS:");
					this.eMode = this.REQUIREMENTS_MODE;
					this.BGSCodeObj.PlaySound("UIMenuCancel");
			}
		}
		
		public function onRightThumbstickInput(param1:uint) : *
		{
			if(param1 == 1)
			{
				this.ModSlotBase_mc.ModSlotList_mc.scrollPosition = this.ModSlotBase_mc.ModSlotList_mc.scrollPosition - 1;
			}
			else if(param1 == 3)
			{
				this.ModSlotBase_mc.ModSlotList_mc.scrollPosition = this.ModSlotBase_mc.ModSlotList_mc.scrollPosition + 1;
			}
		}
		
		public function get autoBuild() : *
		{
			return this.eMode == this.MOD_MODE || this.eMode == this.INVENTORY_MODE;
		}
		
		public function AbortTextEditing() : *
		{
			if(this.bEnteringText)
			{
				this.enteringText = false;
			}
		}
		
		public function onVirtualKeyboardResult(param1:String) : *
		{
			if(param1 != this.ItemName_tf.text)
			{
				this.ItemName_tf.text = param1;
			}
			this.ItemName_tf.type = TextFieldType.DYNAMIC;
			this.ItemName_tf.setSelection(0,0);
			this.ItemName_tf.maxChars = 0;
			this.ItemName_tf.selectable = false;
			stage.focus = null;
		}
		
		public function CancelVirtualKeyboardNameEdit(param1:String) : *
		{
			var executeDelayed:* = undefined;
			var aOldText:String = param1;
			this.bEnteringText = false;
			executeDelayed = function delayedFunc(param1:Event):void
			{
				stage.focus = LegendaryItemDescription_tf;
				ItemName_tf.text = aOldText;
				ItemName_tf.type = TextFieldType.DYNAMIC;
				ItemName_tf.setSelection(0,0);
				ItemName_tf.selectable = false;
				removeEventListener(Event.ENTER_FRAME,executeDelayed);
				if(eMode == ITEM_SELECT_MODE)
				{
					stage.focus = ModSlotBase_mc.ModSlotList_mc;
				}
				else if(stage.focus != ModSlotBase_mc.ModSlotList_mc)
				{
					stage.focus = InventoryBase_mc.InventoryList_mc;
				}
			};
			addEventListener(Event.ENTER_FRAME,executeDelayed);
		}
		
		public function set enteringText(param1:Boolean) : *
		{
			this.bEnteringText = param1;
			if(this.bEnteringText)
			{
				this.ItemName_tf.type = TextFieldType.INPUT;
				this.strStartName = this.ItemName_tf.text;
				this.BGSCodeObj.SetName();
				this.ItemName_tf.selectable = true;
				this.ItemName_tf.maxChars = 26;
				stage.focus = this.ItemName_tf;
				this.ItemName_tf.setSelection(0,this.ItemName_tf.text.length);
			}
			else
			{
				if(this.strStartName != this.ItemName_tf.text)
				{
					this.BGSCodeObj.SetName(this.ItemName_tf.text);
				}
				else
				{
					this.BGSCodeObj.SetName();
				}
				this.ItemName_tf.type = TextFieldType.DYNAMIC;
				this.ItemName_tf.setSelection(0,0);
				this.ItemName_tf.selectable = false;
				stage.focus = null;
				if(this.eMode == this.ITEM_SELECT_MODE)
				{
					stage.focus = this.ModSlotBase_mc.ModSlotList_mc;
				}
				else if(stage.focus != this.ModSlotBase_mc.ModSlotList_mc)
				{
					stage.focus = this.InventoryBase_mc.InventoryList_mc;
				}
			}
		}
		
		public function get enteringText() : *
		{
			return this.bEnteringText;
		}
		
		public function GetCurrentModSelected() : Boolean
		{
			return this.ModListObject.entryList.length > 0?this.ModListObject.entryList[this.ModListObject.selectedIndex].currentMod == true:false;
		}
		
		public function GetCurrentModAttachable() : Boolean
		{
			return this.ModListObject.entryList.length > this.ModListObject.selectedIndex && this.ModListObject.selectedIndex >= 0?this.ModListObject.entryList[this.ModListObject.selectedIndex].hasLooseMod == true:false;
		}
		
		public function UpdateDescription() : *
		{
			var _loc1_:String = "";
			if(this.eMode == this.MOD_MODE || this.eMode == this.REQUIREMENTS_MODE)
			{
				if(this._isCookingMenu)
				{
					if(this.ModListObject.selectedIndex < this.ModListObject.entryList.length && this.ModListObject.entryList[this.ModListObject.selectedIndex] && this.ModListObject.entryList[this.ModListObject.selectedIndex].description != undefined)
					{
						_loc1_ = this.ModListObject.entryList[this.ModListObject.selectedIndex].description;
					}
				}
				else if(this.InventoryBase_mc.InventoryList_mc.selectedIndex < this.InventoryBase_mc.InventoryList_mc.entryList.length && this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex] && this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex].description != undefined)
				{
					_loc1_ = this.InventoryBase_mc.InventoryList_mc.entryList[this.InventoryBase_mc.InventoryList_mc.selectedIndex].description;
				}
			}
			GlobalFunc.SetText(this.ModDescriptionBase_mc.ModDescription_tf,_loc1_,false);
			ShrinkFontToFit(this.ModDescriptionBase_mc.ModDescription_tf,1);
			var _loc2_:* = _loc1_ == ""?0:this.ModDescriptionBase_mc.ModDescription_tf.numLines;
			switch(_loc2_)
			{
				case 0:
					this.ModSlotBase_mc.SlotsLabel_tf.y = -5;
					this.ModSlotBase_mc.ModSlotList_mc.y = 17;
					break;
				case 1:
					this.ModSlotBase_mc.SlotsLabel_tf.y = 16;
					this.ModSlotBase_mc.ModSlotList_mc.y = 38;
					break;
				default:
					this.ModSlotBase_mc.SlotsLabel_tf.y = 37;
					this.ModSlotBase_mc.ModSlotList_mc.y = 59;
			}
		}
		
		public function startItemSelection() : *
		{
			this.BGSCodeObj.StartItemSelection();
		}
		
		public function RefreshItemCard(param1:Object = null) : *
		{
			this.ItemCardList_mc.onDataChange();
		}
		
		public function set legendaryItemDescription(param1:String) : *
		{
			var _loc2_:String = param1;
			while(_loc2_.indexOf("%%") != -1)
			{
				_loc2_ = _loc2_.replace("%%","%");
			}
			while(_loc2_.indexOf("\r\n") != -1)
			{
				_loc2_ = _loc2_.replace("\r\n","\n");
			}
			GlobalFunc.SetText(this.LegendaryItemDescription_tf,_loc2_,false);
		}
		
		public function RepositionCurrentModsList() : *
		{
			var _loc1_:* = undefined;
			var _loc2_:* = undefined;
			var _loc3_:* = undefined;
			var _loc4_:* = undefined;
			var _loc5_:BSScrollingListEntry = null;
			if(this.CurrentModsListObject.entryList.length)
			{
				this.CurrentModsBase_mc.visible = true;
				this.CurrentModsBase_mc.x = stage.width - this.CurrentModsBase_mc.width - (this.ItemCardList_mc.x - this.ItemCardList_mc.width);
				_loc1_ = 0;
				_loc2_ = 0;
				while(_loc2_ < this.CurrentModsListObject.entryList.length)
				{
					_loc5_ = this.CurrentModsBase_mc.ModSlotList_mc.GetClipByIndex(_loc2_);
					if(_loc5_.y + _loc5_.height > _loc1_)
					{
						_loc1_ = _loc5_.y + _loc5_.height;
					}
					_loc2_++;
				}
				_loc3_ = _loc1_ + this.CurrentModsBase_mc.ModSlotList_mc.y + this.CurrentModsBase_mc.y;
				_loc4_ = this.ItemCardList_mc.y - _loc3_;
				this.CurrentModsBase_mc.y = this.CurrentModsBase_mc.y + _loc4_;
			}
			else
			{
				this.CurrentModsBase_mc.visible = false;
			}
		}
		
		function frame1() : *
		{
		}
		
		function frame5() : *
		{
			stop();
		}
		
		function frame14() : *
		{
			stop();
		}
		
		function frame22() : *
		{
			stop();
		}
		
		function frame30() : *
		{
			stop();
		}
		
		function frame38() : *
		{
			stop();
		}
		
		function frame39() : *
		{
			stop();
		}
		
		function frame47() : *
		{
			stop();
		}
		
		function frame55() : *
		{
			stop();
		}
		
		function frame63() : *
		{
			stop();
		}
		
		function frame71() : *
		{
			stop();
		}
		
		function frame72() : *
		{
			stop();
		}
	}
}
