package
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.InteractiveObject;
	import Shared.AS3.BSButtonHintData;
	import flash.events.Event;
	import Shared.AS3.BSScrollingList;
	import Shared.PlatformChangeEvent;
	import flash.display.BlendMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import Shared.GlobalFunc;
	import flash.ui.Keyboard;
	import Shared.CustomEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	
	public class Main_ModManager extends ISubmenu
	{
		 
		
		public var ListsHolder_mc:MovieClip;
		
		public var LoginHolder_mc:MovieClip;
		
		public var DetailsPage_mc:ModDetailsPage;
		
		public var LibraryPage_mc:ModLibraryPage;
		
		public var SearchPage_mc:MovieClip;
		
		public var AccountSettingsPage_mc:MovieClip;
		
		private var LoginLoader_mc:Loader;
		
		private var _DataArray:Array;
		
		private var _StoredSelectedEntry:Object;
		
		private var _PrevFocusedList:InteractiveObject;
		
		private var _CurrScrollPage:uint;
		
		private var _LibraryOpenedFromLogin:Boolean;
		
		private var _AcceptInput:Boolean;
		
		private var _CurrTimeFilterCategory:uint;
		
		private var _MinimalMode:Boolean;
		
		private var Mod_DetailsButton:BSButtonHintData;
		
		private var Mod_MyLibraryButton:BSButtonHintData;
		
		private var Mod_ReorderButton:BSButtonHintData;
		
		private var Mod_LibraryEnableButton:BSButtonHintData;
		
		private var Mod_LibraryDeleteButton:BSButtonHintData;
		
		private var Mod_SearchButton:BSButtonHintData;
		
		private var Mod_AccountSettingsButton:BSButtonHintData;
		
		private var Mod_ConfirmButton:BSButtonHintData;
		
		private var Mod_CancelButton:BSButtonHintData;
		
		private var Mod_TimeFilterButton:BSButtonHintData;
		
		public function Main_ModManager()
		{
			this.Mod_DetailsButton = new BSButtonHintData("$Mod_Details","Enter","PSN_A","Xenon_A",1,this.onModItemPress);
			this.Mod_MyLibraryButton = new BSButtonHintData("$Mod_MyLibrary","T","PSN_Y","Xenon_Y",1,this.onModLibraryPressed);
			this.Mod_ReorderButton = new BSButtonHintData("$Mod_Reorder","X","PSN_X","Xenon_X",1,this.onModReorderPressed);
			this.Mod_LibraryEnableButton = new BSButtonHintData("$Mod_LibraryEnable","Enter","PSN_A","Xenon_A",1,this.onModLibraryEnablePressed);
			this.Mod_LibraryDeleteButton = new BSButtonHintData("$Mod_LibraryDelete","T","PSN_Y","Xenon_Y",1,this.onModLibraryDeletePressed);
			this.Mod_SearchButton = new BSButtonHintData("$Mod_Search","X","PSN_X","Xenon_X",1,this.onModSearchPressed);
			this.Mod_AccountSettingsButton = new BSButtonHintData("$Mod_AccountSettings","V","PSN_Select","Xenon_Select",1,this.onModAccountSettingsPressed);
			this.Mod_ConfirmButton = new BSButtonHintData("$SELECT","Enter","PSN_A","Xenon_A",1,null);
			this.Mod_CancelButton = new BSButtonHintData("$BACK","Esc","PSN_B","Xenon_B",1,this.onModCancelPressed);
			this.Mod_TimeFilterButton = new BSButtonHintData("$TimeFilterToday","Home","PSN_L2","Xenon_L2",1,this.onTimeFilterLeftPress);
			super();
			this._CurrScrollPage = 0;
			this._LibraryOpenedFromLogin = false;
			this._AcceptInput = false;
			this._MinimalMode = false;
			this._CurrTimeFilterCategory = 5;
			this._DataArray = new Array();
			addEventListener(ModListEntry.LOAD_THUMBNAIL,this.onLoadThumbnail);
			addEventListener(ModListEntry.UNREGISTER_IMAGE,this.onUnregisterImage);
			addEventListener(ModListEntry.DISPLAY_IMAGE,this.onDisplayImage);
			this.LoginLoader_mc = new Loader();
			this.LoginLoader_mc.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoginLoaderComplete,false,0,true);
			this.LoginLoader_mc.load(new URLRequest("Main_LoginHelper.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
			addEventListener("CANCEL_LOGIN",this.onLoginCancel);
			addEventListener("openLoadOrder",this.onLoginOpenLoadOrder);
			addEventListener("onEULAAccepted",this.onInitEULAAccepted);
			addEventListener("onEULACancelled",this.onInitEULACancelled);
			this.Mod_ConfirmButton.ButtonVisible = false;
			this.Mod_ReorderButton.ButtonVisible = false;
			this.Mod_LibraryEnableButton.ButtonVisible = false;
			this.Mod_LibraryDeleteButton.ButtonVisible = false;
			this.SearchPage_mc.SearchGrayText_tf.mouseEnabled = false;
			this.AccountSettingsPage_mc.List_mc.addEventListener(BSScrollingList.LIST_ITEMS_CREATED,this.onAccountListCreated);
			var _loc1_:Vector.<BSButtonHintData> = this.buttonData;
			this.Mod_TimeFilterButton.SetSecondaryButtons("End","PSN_R2","Xenon_R2");
			this.Mod_TimeFilterButton.secondaryButtonCallback = this.onTimeFilterRightPress;
			_loc1_.push(this.Mod_DetailsButton);
			_loc1_.push(this.Mod_MyLibraryButton);
			_loc1_.push(this.Mod_LibraryEnableButton);
			_loc1_.push(this.Mod_ReorderButton);
			_loc1_.push(this.Mod_LibraryDeleteButton);
			_loc1_.push(this.Mod_SearchButton);
			_loc1_.push(this.Mod_AccountSettingsButton);
			_loc1_.push(this.Mod_TimeFilterButton);
			_loc1_.push(this.Mod_ConfirmButton);
			_loc1_.push(this.Mod_CancelButton);
		}
		
		public static function GetFileSizeString(param1:Number) : String
		{
			var _loc3_:* = null;
			var _loc2_:uint = 0;
			while(param1 >= 1024)
			{
				param1 = param1 / 1024;
				_loc2_ = _loc2_ + 3;
			}
			_loc3_ = param1.toFixed(2);
			var _loc4_:int = _loc3_.search(".00");
			if(_loc4_ != -1 && _loc4_ >= _loc3_.length - 3)
			{
				_loc3_ = _loc3_.slice(0,_loc4_);
			}
			switch(_loc2_)
			{
				case 0:
					_loc3_ = _loc3_ + " B";
					break;
				case 3:
					_loc3_ = _loc3_ + " KB";
					break;
				case 6:
					_loc3_ = _loc3_ + " MB";
					break;
				case 9:
					_loc3_ = _loc3_ + " GB";
					break;
				default:
					_loc3_ = _loc3_ + " ?B";
			}
			return _loc3_;
		}
		
		private function onLoginLoaderComplete(param1:Event) : *
		{
			if(this.LoginLoader_mc.content != null && this.LoginLoader_mc.content is ISubmenu)
			{
				(this.LoginLoader_mc.content as ISubmenu).codeObj = this.codeObj;
				(this.LoginLoader_mc.content as ISubmenu).buttonHintBar = this.buttonHintBar;
				this.LoginHolder_mc.addChild(this.LoginLoader_mc);
				this.UpdateButtons();
				this._MinimalMode = this.codeObj.UseMinimalModMenu();
				this.codeObj.InitModManager(this,this.LoginLoader_mc.content,this.LibraryPage_mc.dataArray);
				this._AcceptInput = true;
			}
		}
		
		private function onAccountListCreated() : *
		{
			this.AccountSettingsPage_mc.List_mc.removeEventListener(BSScrollingList.LIST_ITEMS_CREATED,this.onAccountListCreated);
			this.AccountSettingsPage_mc.List_mc.entryList = [{"text":"$DeleteAllMods"},{"text":"$DisableAllMods"}];
			this.AccountSettingsPage_mc.List_mc.InvalidateData();
			this.UpdateAccountSettingsList();
		}
		
		public function get minimalMode() : Boolean
		{
			return this._MinimalMode;
		}
		
		private function onInitEULAAccepted() : *
		{
			this.codeObj.onInitEULAAccepted();
		}
		
		private function onInitEULACancelled() : *
		{
			this.onConfirmCloseManager();
		}
		
		public function onInitDataComplete() : *
		{
			var maxFramesToWait:uint = 0;
			var executeDelayedFinishInit_Min:* = undefined;
			var firstValidIndex:uint = 0;
			var secondValidIndex:uint = 0;
			var executeDelayedFinishInit:* = undefined;
			maxFramesToWait = 100;
			if(this._MinimalMode)
			{
				executeDelayedFinishInit_Min = function delayedFunc(param1:Event):void
				{
					if(maxFramesToWait == 0 || LibraryPage_mc.CheckThumbnailsLoaded())
					{
						FinishInit();
						removeEventListener(Event.ENTER_FRAME,executeDelayedFinishInit_Min);
					}
					else
					{
						maxFramesToWait--;
					}
				};
				addEventListener(Event.ENTER_FRAME,executeDelayedFinishInit_Min);
			}
			else
			{
				firstValidIndex = 0;
				secondValidIndex = 0;
				if(!this.IsValidCategoryObj(this._DataArray[0]))
				{
					firstValidIndex = this.GetNextValidDataArray_Index(0);
				}
				secondValidIndex = this.GetNextValidDataArray_Index(firstValidIndex);
				if(firstValidIndex != uint.MAX_VALUE)
				{
					this._CurrScrollPage = firstValidIndex;
					this.ListsHolder_mc.List1_mc.dataObj = this._DataArray[firstValidIndex];
				}
				if(secondValidIndex != uint.MAX_VALUE)
				{
					this.ListsHolder_mc.List2_mc.dataObj = this._DataArray[secondValidIndex];
				}
				removeEventListener("onEULAAccepted",this.onInitEULAAccepted);
				removeEventListener("onEULACancelled",this.onInitEULACancelled);
				executeDelayedFinishInit = function delayedFunc(param1:Event):void
				{
					if(maxFramesToWait == 0 || ListsHolder_mc.List1_mc.CheckScreenshotsLoaded() && ListsHolder_mc.List2_mc.CheckScreenshotsLoaded())
					{
						FinishInit();
						removeEventListener(Event.ENTER_FRAME,executeDelayedFinishInit);
					}
					else
					{
						maxFramesToWait--;
					}
				};
				addEventListener(Event.ENTER_FRAME,executeDelayedFinishInit);
			}
		}
		
		private function FinishInit() : *
		{
			if(this.iPlatform == PlatformChangeEvent.PLATFORM_PS4)
			{
				this.AccountSettingsPage_mc.Background_mc.blendMode = BlendMode.NORMAL;
				this.SearchPage_mc.Background_mc.blendMode = BlendMode.NORMAL;
			}
			addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			this.ListsHolder_mc.List1_mc.addEventListener(ModCategoryList.ITEM_PRESS,this.onModItemPress);
			this.ListsHolder_mc.List2_mc.addEventListener(ModCategoryList.ITEM_PRESS,this.onModItemPress);
			this.ListsHolder_mc.List1_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onListRollover);
			this.ListsHolder_mc.List2_mc.addEventListener(MouseEvent.MOUSE_OVER,this.onListRollover);
			this.ListsHolder_mc.ScrollUp.addEventListener(MouseEvent.CLICK,this.onScrollUpClick);
			this.ListsHolder_mc.ScrollDown.addEventListener(MouseEvent.CLICK,this.onScrollDownClick);
			this.ListsHolder_mc.addEventListener(GlobalFunc.PLAY_FOCUS_SOUND,this.onSelectionChange);
			if(this._MinimalMode)
			{
				this.LoginHolder_mc.visible = false;
				this.StartLibraryPage();
			}
			else
			{
				this.ListsHolder_mc.List1_mc.selectedIndex = 0;
				stage.focus = this.ListsHolder_mc.List1_mc;
				this.LoginHolder_mc.visible = false;
				this.ListsHolder_mc.visible = true;
			}
			this.buttonHintBar.SetButtonHintData(this.buttonData);
			this.UpdateButtons();
			SetIsDirty();
			this.codeObj.onFinishInit();
		}
		
		public function BackToLogin() : *
		{
			if(!this.LoginHolder_mc.visible)
			{
				if(this.AccountSettingsPage_mc.visible)
				{
					this.StopAccountSettingsPage();
				}
				if(this.DetailsPage_mc.visible)
				{
					this.StopDetailsPage(true);
				}
				if(this.LibraryPage_mc.visible)
				{
					this.StopLibraryPage();
				}
				if(this.SearchPage_mc.visible)
				{
					this.StopSearchPage();
				}
				this.LoginHolder_mc.visible = true;
				this.ListsHolder_mc.visible = false;
				this.UpdateButtons();
				(this.LoginLoader_mc.content as ISubmenu).onAddedToStage();
			}
		}
		
		public function onVKBTextEntered(param1:String) : *
		{
			if(param1.length > 0)
			{
				if(stage.focus == this.SearchPage_mc.Input_tf && this.iPlatform != PlatformChangeEvent.PLATFORM_PS4)
				{
					GlobalFunc.SetText(this.SearchPage_mc.Input_tf,param1,false);
				}
			}
			if(this.SearchPage_mc.Input_tf.text.length > 0)
			{
				this.SearchPage_mc.SearchGrayText_tf.visible = false;
			}
		}
		
		public function get dataArray() : Array
		{
			return this._DataArray;
		}
		
		private function get storedSelectedEntry() : Object
		{
			return this._StoredSelectedEntry;
		}
		
		private function sortModsFunc(param1:Object, param2:Object) : int
		{
			var _loc3_:* = 0;
			if(param1 != null && param2 == null)
			{
				_loc3_ = -1;
			}
			else if(param1 == null && param2 != null)
			{
				_loc3_ = 1;
			}
			if(param1 != null && param2 != null)
			{
				if(_loc3_ == 0)
				{
					if(param1.sortIndex != undefined && param2.sortIndex == undefined)
					{
						_loc3_ = -1;
					}
					else if(param1.sortIndex == undefined && param2.sortIndex != undefined)
					{
						_loc3_ = 1;
					}
					else if(param1.sortIndex != undefined && param2.sortIndex != undefined)
					{
						if(param1.sortIndex < param2.sortIndex)
						{
							_loc3_ = -1;
						}
						if(param1.sortIndex > param2.sortIndex)
						{
							_loc3_ = 1;
						}
					}
				}
				if(_loc3_ == 0)
				{
					if(param1.text < param2.text)
					{
						_loc3_ = -1;
					}
					if(param1.text > param2.text)
					{
						_loc3_ = 1;
					}
				}
			}
			return _loc3_;
		}
		
		public function onDataCategoryUpdate(param1:uint) : *
		{
			var _loc2_:uint = 0;
			var _loc3_:uint = 0;
			if(this.IsValidCategoryObj(this._DataArray[this._CurrScrollPage]))
			{
				_loc2_ = this._CurrScrollPage;
			}
			else
			{
				_loc2_ = this.GetNextValidDataArray_Index(this._CurrScrollPage);
			}
			_loc3_ = this.GetNextValidDataArray_Index(_loc2_);
			this.ListsHolder_mc.List1_mc.dataObj = this._DataArray[_loc2_];
			this.ListsHolder_mc.List2_mc.dataObj = this._DataArray[_loc3_];
		}
		
		public function onDataObjectChange(param1:Object) : *
		{
			this.ListsHolder_mc.List1_mc.onDataObjectChange(param1);
			this.ListsHolder_mc.List2_mc.onDataObjectChange(param1);
			if(param1 == this.DetailsPage_mc.dataObj)
			{
				this.DetailsPage_mc.dataObj = param1;
			}
			this.LibraryPage_mc.onDataObjectChange(param1);
		}
		
		public function onLibraryArrayChange() : *
		{
			this.UpdateAccountSettingsList();
			this.LibraryPage_mc.dataArray.sort(this.sortModsFunc);
			this.LibraryPage_mc.InvalidateData();
		}
		
		public function SetLibraryFreeSpace(param1:Number) : *
		{
			this.LibraryPage_mc.freeSpace = param1;
			this.LibraryPage_mc.InvalidateData();
		}
		
		public function ShowDetailsPageError(param1:String) : *
		{
			if(this.DetailsPage_mc.visible)
			{
				this.DetailsPage_mc.ShowError(param1);
			}
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:uint = this.GetNextValidDataArray_Index(this._CurrScrollPage);
			if(this.ListsHolder_mc.ScrollUp != null)
			{
				this.ListsHolder_mc.ScrollUp.visible = this.GetPrevValidDataArray_Index(this._CurrScrollPage) < this._CurrScrollPage;
			}
			if(this.ListsHolder_mc.ScrollDown != null)
			{
				this.ListsHolder_mc.ScrollDown.visible = this.GetNextValidDataArray_Index(_loc1_) > _loc1_;
			}
			this.UpdateTimeFilterButton();
		}
		
		private function onKeyDown(param1:KeyboardEvent) : *
		{
			if(this.ListsHolder_mc.visible)
			{
				if(param1.keyCode == Keyboard.UP)
				{
					this.scrollMenuUp();
					this.ListsHolder_mc.List1_mc.usingMouseNav = false;
					this.ListsHolder_mc.List2_mc.usingMouseNav = false;
					param1.stopPropagation();
				}
				else if(param1.keyCode == Keyboard.DOWN)
				{
					this.scrollMenuDown();
					this.ListsHolder_mc.List1_mc.usingMouseNav = false;
					this.ListsHolder_mc.List2_mc.usingMouseNav = false;
					param1.stopPropagation();
				}
				if(stage.focus is ModCategoryList)
				{
					if(param1.keyCode == Keyboard.PAGE_UP)
					{
						(stage.focus as ModCategoryList).JumpLeft();
					}
					else if(param1.keyCode == Keyboard.PAGE_DOWN)
					{
						(stage.focus as ModCategoryList).JumpRight();
					}
					else if(param1.keyCode == Keyboard.HOME && this.Mod_TimeFilterButton.ButtonVisible)
					{
						this.onTimeFilterLeftPress();
					}
					else if(param1.keyCode == Keyboard.END && this.Mod_TimeFilterButton.ButtonVisible)
					{
						this.onTimeFilterRightPress();
					}
				}
			}
		}
		
		private function onSearchKeyUp(param1:KeyboardEvent) : *
		{
			if(param1.keyCode == Keyboard.ENTER)
			{
				if(this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.iPlatform != PlatformChangeEvent.PLATFORM_PC_GAMEPAD && (this.SearchPage_mc.Input_tf.text.length == 0 || this.SearchPage_mc.Input_tf.selectionBeginIndex != this.SearchPage_mc.Input_tf.selectionEndIndex))
				{
					this.SearchPage_mc.Input_tf.text = "";
					this.SearchPage_mc.Input_tf.setSelection(0,0);
					this.SearchPage_mc.SearchGrayText_tf.visible = false;
					this.codeObj.startEditText();
				}
				else if(this.SearchPage_mc.Input_tf.text.length > 0)
				{
					this.SearchForMods();
				}
			}
			else if(param1.keyCode == Keyboard.ESCAPE || param1.keyCode == Keyboard.TAB)
			{
				this.onModCancelPressed();
			}
			if(this.SearchPage_mc.Input_tf.text.length > 0)
			{
				this.SearchPage_mc.SearchGrayText_tf.visible = false;
			}
		}
		
		private function scrollMenuUp(param1:Boolean = false) : *
		{
			var _loc2_:uint = 0;
			if(!param1 && stage.focus == this.ListsHolder_mc.List2_mc)
			{
				stage.focus = this.ListsHolder_mc.List1_mc;
				this.ListsHolder_mc.List1_mc.selectedIndex = this.ListsHolder_mc.List2_mc.selectedIndex;
				this.ListsHolder_mc.List2_mc.selectedIndex = uint.MAX_VALUE;
				dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
			}
			else
			{
				_loc2_ = this.GetPrevValidDataArray_Index(this._CurrScrollPage);
				if(_loc2_ < this._CurrScrollPage)
				{
					this._CurrScrollPage = _loc2_;
					this.ListsHolder_mc.List2_mc.CopyDataAndClips(this.ListsHolder_mc.List1_mc);
					this.ListsHolder_mc.List1_mc.dataObj = this._DataArray[this._CurrScrollPage];
					this.ListsHolder_mc.List1_mc.selectedIndex = this.ListsHolder_mc.List2_mc.selectedIndex;
					this.ListsHolder_mc.List2_mc.selectedIndex = uint.MAX_VALUE;
					dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
					SetIsDirty();
					this.ListsHolder_mc.gotoAndPlay("scrollUp");
				}
			}
			this.UpdateButtons();
		}
		
		private function scrollMenuDown(param1:Boolean = false) : *
		{
			var _loc2_:uint = 0;
			var _loc3_:uint = 0;
			if(!param1 && stage.focus == this.ListsHolder_mc.List1_mc)
			{
				stage.focus = this.ListsHolder_mc.List2_mc;
				this.ListsHolder_mc.List2_mc.selectedIndex = this.ListsHolder_mc.List1_mc.selectedIndex;
				this.ListsHolder_mc.List1_mc.selectedIndex = uint.MAX_VALUE;
				dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
			}
			else
			{
				_loc2_ = this.GetNextValidDataArray_Index(this._CurrScrollPage);
				_loc3_ = this.GetNextValidDataArray_Index(_loc2_);
				if(_loc3_ > _loc2_)
				{
					this._CurrScrollPage = _loc2_;
					this.ListsHolder_mc.List1_mc.CopyDataAndClips(this.ListsHolder_mc.List2_mc);
					this.ListsHolder_mc.List2_mc.dataObj = this._DataArray[_loc3_];
					this.ListsHolder_mc.List2_mc.selectedIndex = this.ListsHolder_mc.List1_mc.selectedIndex;
					this.ListsHolder_mc.List1_mc.selectedIndex = uint.MAX_VALUE;
					dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
					SetIsDirty();
					if(this._DataArray[_loc3_].loaded == false)
					{
						this.codeObj.StartCategoryRefresh(_loc3_);
					}
					this.ListsHolder_mc.gotoAndPlay("scrollDown");
				}
			}
			this.UpdateButtons();
		}
		
		private function onMouseWheel(param1:MouseEvent) : *
		{
			if(this.ListsHolder_mc.visible)
			{
				if(param1.delta < 0)
				{
					this.scrollMenuDown(true);
				}
				else if(param1.delta > 0)
				{
					this.scrollMenuUp(true);
				}
			}
		}
		
		private function onScrollUpClick() : *
		{
			this.scrollMenuUp();
		}
		
		private function onScrollDownClick() : *
		{
			this.scrollMenuDown();
		}
		
		private function onTimeFilterLeftPress() : *
		{
			var _loc1_:Object = null;
			var _loc2_:uint = this._CurrTimeFilterCategory;
			if(stage.focus == this.ListsHolder_mc.List1_mc)
			{
				_loc1_ = this.ListsHolder_mc.List1_mc.dataObj;
			}
			else if(stage.focus == this.ListsHolder_mc.List2_mc)
			{
				_loc1_ = this.ListsHolder_mc.List2_mc.dataObj;
			}
			if(_loc1_.prevSubFilter != undefined)
			{
				this._CurrTimeFilterCategory = _loc1_.prevSubFilter;
			}
			else
			{
				this._CurrTimeFilterCategory--;
			}
			if(_loc2_ == this._CurrScrollPage)
			{
				this._CurrScrollPage = this._CurrTimeFilterCategory;
			}
			this.onDataCategoryUpdate(_loc2_);
			this.UpdateTimeFilterButton();
		}
		
		private function onTimeFilterRightPress() : *
		{
			var _loc1_:Object = null;
			var _loc2_:uint = this._CurrTimeFilterCategory;
			if(stage.focus == this.ListsHolder_mc.List1_mc)
			{
				_loc1_ = this.ListsHolder_mc.List1_mc.dataObj;
			}
			else if(stage.focus == this.ListsHolder_mc.List2_mc)
			{
				_loc1_ = this.ListsHolder_mc.List2_mc.dataObj;
			}
			if(_loc1_.nextSubFilter != undefined)
			{
				this._CurrTimeFilterCategory = _loc1_.nextSubFilter;
			}
			else
			{
				this._CurrTimeFilterCategory++;
			}
			if(_loc2_ == this._CurrScrollPage)
			{
				this._CurrScrollPage = this._CurrTimeFilterCategory;
			}
			this.onDataCategoryUpdate(_loc2_);
			this.UpdateTimeFilterButton();
		}
		
		private function IsValidCategoryObj(param1:Object) : *
		{
			return param1.entries is Array && (param1.entries.length > 0 || param1.loaded == false) && (param1.subFilterIndex == undefined || param1.subFilterIndex == this._CurrTimeFilterCategory);
		}
		
		private function GetPrevValidDataArray_Index(param1:uint) : uint
		{
			var _loc2_:uint = param1;
			var _loc3_:int = param1 - 1;
			while(_loc2_ == param1 && _loc3_ >= 0)
			{
				if(this.IsValidCategoryObj(this._DataArray[_loc3_]))
				{
					_loc2_ = _loc3_;
				}
				_loc3_--;
			}
			return _loc2_;
		}
		
		private function GetNextValidDataArray_Index(param1:uint) : uint
		{
			var _loc2_:uint = param1;
			var _loc3_:int = param1 + 1;
			while(_loc2_ == param1 && _loc3_ < this._DataArray.length)
			{
				if(this.IsValidCategoryObj(this._DataArray[_loc3_]))
				{
					_loc2_ = _loc3_;
				}
				_loc3_++;
			}
			return _loc2_;
		}
		
		private function onModItemPress() : *
		{
			if(stage.focus == this.ListsHolder_mc.List1_mc)
			{
				this._StoredSelectedEntry = this.ListsHolder_mc.List1_mc.selectedEntry;
			}
			else if(stage.focus == this.ListsHolder_mc.List2_mc)
			{
				this._StoredSelectedEntry = this.ListsHolder_mc.List2_mc.selectedEntry;
			}
			else
			{
				this._StoredSelectedEntry = null;
			}
			if(this.ListsHolder_mc.visible && this._StoredSelectedEntry != null)
			{
				this.StartDetailsPage();
				this.codeObj.PlayOKSound();
			}
		}
		
		private function onListRollover(param1:MouseEvent) : *
		{
			if(param1.currentTarget == this.ListsHolder_mc.List1_mc)
			{
				stage.focus = this.ListsHolder_mc.List1_mc;
				this.ListsHolder_mc.List1_mc.selectedIndex = this.ListsHolder_mc.List1_mc.selectedIndex;
				this.ListsHolder_mc.List2_mc.selectedIndex = uint.MAX_VALUE;
			}
			else if(param1.currentTarget == this.ListsHolder_mc.List2_mc)
			{
				stage.focus = this.ListsHolder_mc.List2_mc;
				this.ListsHolder_mc.List2_mc.selectedIndex = this.ListsHolder_mc.List2_mc.selectedIndex;
				this.ListsHolder_mc.List1_mc.selectedIndex = uint.MAX_VALUE;
			}
			this.UpdateButtons();
		}
		
		override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!this._AcceptInput)
			{
				_loc3_ = true;
			}
			if(!_loc3_ && this.LoginLoader_mc.content is ISubmenu && this.LoginHolder_mc.visible)
			{
				_loc3_ = (this.LoginLoader_mc.content as ISubmenu).ProcessUserEvent(param1,param2);
			}
			if(!_loc3_ && !param2)
			{
				switch(param1)
				{
					case "Cancel":
					case "Start":
						if(this.LibraryPage_mc.reorderMode)
						{
							_loc3_ = true;
						}
						else if(this.Mod_CancelButton.ButtonVisible)
						{
							_loc3_ = this.onModCancelPressed();
						}
						break;
					case "YButton":
						if(this.Mod_MyLibraryButton.ButtonVisible)
						{
							this.onModLibraryPressed();
						}
						else if(this.Mod_LibraryDeleteButton.ButtonVisible)
						{
							this.onModLibraryDeletePressed();
						}
						_loc3_ = true;
						break;
					case "Select":
						if(this.Mod_AccountSettingsButton.ButtonVisible)
						{
							this.onModAccountSettingsPressed();
						}
						_loc3_ = true;
						break;
					case "DeleteSave":
					case "XButton":
						if(this.Mod_ReorderButton.ButtonVisible)
						{
							this.onModReorderPressed();
						}
						else if(this.Mod_SearchButton.ButtonVisible)
						{
							this.onModSearchPressed();
						}
						_loc3_ = true;
						break;
					case "LShoulder":
						if(this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.ListsHolder_mc.visible && stage.focus is ModCategoryList)
						{
							(stage.focus as ModCategoryList).JumpLeft();
						}
						_loc3_ = true;
						break;
					case "RShoulder":
						if(this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.ListsHolder_mc.visible && stage.focus is ModCategoryList)
						{
							(stage.focus as ModCategoryList).JumpRight();
						}
						_loc3_ = true;
						break;
					case "LTrigger":
						if(this.Mod_TimeFilterButton.ButtonVisible && this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.ListsHolder_mc.visible && stage.focus is ModCategoryList)
						{
							this.onTimeFilterLeftPress();
						}
						_loc3_ = true;
						break;
					case "RTrigger":
						if(this.Mod_TimeFilterButton.ButtonVisible && this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.ListsHolder_mc.visible && stage.focus is ModCategoryList)
						{
							this.onTimeFilterRightPress();
						}
						_loc3_ = true;
				}
			}
			return _loc3_;
		}
		
		override public function OnRightStickInput(param1:Number, param2:Number) : *
		{
			if(this.DetailsPage_mc.visible)
			{
				this.DetailsPage_mc.OnRightStickInput(param1,param2);
			}
			if(this.LibraryPage_mc.visible)
			{
				this.LibraryPage_mc.OnRightStickInput(param1,param2);
			}
		}
		
		private function StartDetailsPage() : *
		{
			if(this.storedSelectedEntry != null)
			{
				this.codeObj.populateDetails(this.storedSelectedEntry);
				this.DetailsPage_mc.dataObj = this.storedSelectedEntry;
				this.ListsHolder_mc.visible = false;
				this.DetailsPage_mc.visible = true;
				this._PrevFocusedList = stage.focus;
				stage.focus = this.DetailsPage_mc.OptionsList_mc;
				this.DetailsPage_mc.OptionsList_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onDetailsOptionPress);
				this.UpdateButtons();
			}
		}
		
		private function StopDetailsPage(param1:Boolean = false) : *
		{
			if(!param1)
			{
				if(this.DetailsPage_mc.hasRatingChanged)
				{
					this.codeObj.RateMod(this.storedSelectedEntry,this.DetailsPage_mc.tempRating);
				}
				this.UpdateAccountSettingsList();
			}
			this._StoredSelectedEntry = null;
			this.DetailsPage_mc.dataObj = null;
			this.ListsHolder_mc.visible = true;
			this.DetailsPage_mc.visible = false;
			stage.focus = this._PrevFocusedList;
			this.DetailsPage_mc.OptionsList_mc.removeEventListener(BSScrollingList.ITEM_PRESS,this.onDetailsOptionPress);
			this.UpdateButtons();
			this.codeObj.PlayCancelSound();
		}
		
		private function onDetailsOptionPress(param1:Event) : *
		{
			if(this.DetailsPage_mc.selectedEntry.disabled != true)
			{
				switch(this.DetailsPage_mc.selectedEntry.id)
				{
					case ModDetailsPage.FOLLOW_ID:
						this.codeObj.FollowMod(this.storedSelectedEntry);
						break;
					case ModDetailsPage.UNFOLLOW_ID:
						this.codeObj.UnfollowMod(this.storedSelectedEntry);
						break;
					case ModDetailsPage.DOWNLOAD_ID:
						if(this.LibraryPage_mc.GetModSpaceRemaining() > 0 && this.storedSelectedEntry.fileSizeDisplay > this.LibraryPage_mc.GetModSpaceRemaining())
						{
							this.ShowDetailsPageError("$DetailsPageError_ModTooLarge");
						}
						else
						{
							this.codeObj.DownloadMod(this.storedSelectedEntry);
						}
						break;
					case ModDetailsPage.UPDATE_ID:
						this.codeObj.UpdateMod(this.storedSelectedEntry);
						break;
					case ModDetailsPage.DELETE_ID:
						this.codeObj.DeleteMod(this.storedSelectedEntry);
						break;
					case ModDetailsPage.INSTALL_ID:
						this.codeObj.InstallMod(this.storedSelectedEntry);
						break;
					case ModDetailsPage.UNINSTALL_ID:
						this.codeObj.UninstallMod(this.storedSelectedEntry);
						break;
					case ModDetailsPage.REPORT_ID:
						this.codeObj.ReportMod(this.storedSelectedEntry);
				}
			}
		}
		
		private function onModSearchPressed() : *
		{
			this.StartSearchPage();
		}
		
		private function StartSearchPage() : *
		{
			this.SearchPage_mc.SpinnerHolder_mc.visible = false;
			this.ListsHolder_mc.visible = false;
			this.SearchPage_mc.visible = true;
			this._PrevFocusedList = stage.focus;
			this.SearchPage_mc.Input_tf.text = "";
			this.SearchPage_mc.Input_tf.restrict = "^%";
			this.SearchPage_mc.SearchGrayText_tf.visible = this.SearchPage_mc.Input_tf.text.length <= 0;
			stage.focus = this.SearchPage_mc.Input_tf;
			addEventListener(KeyboardEvent.KEY_UP,this.onSearchKeyUp);
			if(this.iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE || this.iPlatform == PlatformChangeEvent.PLATFORM_PC_GAMEPAD)
			{
				this.codeObj.startEditText();
			}
			this.UpdateButtons();
		}
		
		private function SearchForMods() : *
		{
			if(this.SearchPage_mc.Input_tf.text.length > 0)
			{
				this.SearchPage_mc.SpinnerHolder_mc.EmptyWarning_tf.visible = false;
				this.SearchPage_mc.SpinnerHolder_mc.Spinner_mc.visible = true;
				this.SearchPage_mc.SpinnerHolder_mc.visible = true;
				this.codeObj.searchForMods(this.SearchPage_mc.Input_tf.text);
			}
		}
		
		public function onModSearchReturned(param1:int) : *
		{
			var _loc2_:uint = 0;
			if(param1 == -1)
			{
				this.SearchPage_mc.Input_tf.setSelection(0,this.SearchPage_mc.Input_tf.length);
				this.SearchPage_mc.SpinnerHolder_mc.EmptyWarning_tf.visible = true;
				this.SearchPage_mc.SpinnerHolder_mc.Spinner_mc.visible = false;
			}
			else
			{
				_loc2_ = this.GetNextValidDataArray_Index(param1);
				this._CurrScrollPage = param1;
				this.ListsHolder_mc.List1_mc.dataObj = this._DataArray[param1];
				if(_loc2_ != uint.MAX_VALUE)
				{
					this.ListsHolder_mc.List2_mc.dataObj = this._DataArray[_loc2_];
				}
				this.ListsHolder_mc.List1_mc.currScrollPage = 0;
				this.ListsHolder_mc.List1_mc.selectedIndex = 0;
				stage.focus = this.ListsHolder_mc.List1_mc;
				this.UpdateButtons();
				this.StopSearchPage();
				SetIsDirty();
			}
		}
		
		private function StopSearchPage() : *
		{
			removeEventListener(KeyboardEvent.KEY_UP,this.onSearchKeyUp);
			this.codeObj.endEditText();
			this.ListsHolder_mc.visible = true;
			this.SearchPage_mc.visible = false;
			stage.focus = this._PrevFocusedList;
			this.UpdateButtons();
			this.codeObj.PlayCancelSound();
		}
		
		private function onModAccountSettingsPressed() : *
		{
			this.StartAccountSettingsPage();
		}
		
		private function StartAccountSettingsPage() : *
		{
			this.LibraryPage_mc.visible = false;
			this.AccountSettingsPage_mc.visible = true;
			this.AccountSettingsPage_mc.List_mc.selectedIndex = 0;
			stage.focus = this.AccountSettingsPage_mc.List_mc;
			this.AccountSettingsPage_mc.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onAccountSettingsPress);
			this.UpdateButtons();
		}
		
		private function onAccountSettingsPress() : *
		{
			if(this.AccountSettingsPage_mc.List_mc.selectedEntry != null && this.AccountSettingsPage_mc.List_mc.selectedEntry.disabled != true)
			{
				switch(this.AccountSettingsPage_mc.List_mc.selectedIndex)
				{
					case 0:
						this.codeObj.DeleteAllMods();
						break;
					case 1:
						this.codeObj.DisableAllMods();
						break;
					case 2:
						addEventListener("onEULAAccepted",this.onAccountSettingsEULADone);
						addEventListener("onEULACancelled",this.onAccountSettingsEULADone);
						stage.focus = null;
						this.LoginHolder_mc.visible = true;
						this.AccountSettingsPage_mc.visible = false;
						this.UpdateButtons();
						(this.LoginLoader_mc.content as ISubmenu).onAddedToStage();
						this.codeObj.PopulateEULA();
				}
				this.UpdateAccountSettingsList();
			}
		}
		
		private function UpdateAccountSettingsList() : *
		{
			var _loc1_:Boolean = false;
			var _loc2_:* = undefined;
			if(this.AccountSettingsPage_mc.List_mc.entryList.length > 0)
			{
				this.AccountSettingsPage_mc.List_mc.entryList[0].disabled = this.LibraryPage_mc.dataArray.length == 0;
				_loc1_ = false;
				for each(_loc2_ in this.LibraryPage_mc.dataArray)
				{
					if(_loc2_.checked == true)
					{
						_loc1_ = true;
					}
				}
				this.AccountSettingsPage_mc.List_mc.entryList[1].disabled = !_loc1_;
				this.AccountSettingsPage_mc.List_mc.UpdateList();
			}
		}
		
		private function onAccountSettingsEULADone() : *
		{
			removeEventListener("onEULAAccepted",this.onAccountSettingsEULADone);
			removeEventListener("onEULACancelled",this.onAccountSettingsEULADone);
			stage.focus = this.AccountSettingsPage_mc.List_mc;
			this.LoginHolder_mc.visible = false;
			this.AccountSettingsPage_mc.visible = true;
			this.buttonHintBar.SetButtonHintData(this.buttonData);
			this.UpdateButtons();
		}
		
		private function StopAccountSettingsPage() : *
		{
			this.LibraryPage_mc.visible = true;
			this.AccountSettingsPage_mc.visible = false;
			stage.focus = this.LibraryPage_mc.List_mc;
			this.AccountSettingsPage_mc.List_mc.removeEventListener(BSScrollingList.ITEM_PRESS,this.onAccountSettingsPress);
			this.UpdateButtons();
			this.codeObj.PlayCancelSound();
		}
		
		private function onModLibraryPressed() : *
		{
			this.StartLibraryPage();
		}
		
		private function StartLibraryPage() : *
		{
			this.ListsHolder_mc.visible = false;
			this.LibraryPage_mc.visible = true;
			this._PrevFocusedList = stage.focus;
			this.LibraryPage_mc.List_mc.selectedIndex = 0;
			stage.focus = this.LibraryPage_mc.List_mc;
			this.LibraryPage_mc.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onLibraryItemPress);
			this.LibraryPage_mc.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.UpdateButtons);
			this.LibraryPage_mc.addEventListener(ModLibraryPage.REORDER_COMPLETE,this.onLibraryReorderComplete);
			this.UpdateButtons();
		}
		
		private function StopLibraryPage() : *
		{
			this.UpdateAccountSettingsList();
			this.LibraryPage_mc.List_mc.removeEventListener(BSScrollingList.ITEM_PRESS,this.onLibraryItemPress);
			this.LibraryPage_mc.List_mc.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.UpdateButtons);
			this.LibraryPage_mc.removeEventListener(ModLibraryPage.REORDER_COMPLETE,this.onLibraryReorderComplete);
			this._LibraryOpenedFromLogin = false;
			this.LibraryPage_mc.visible = false;
			if(!this._MinimalMode)
			{
				stage.focus = this._PrevFocusedList;
				this.ListsHolder_mc.visible = true;
				this.codeObj.PlayCancelSound();
			}
			this.UpdateButtons();
		}
		
		private function onLibraryItemPress() : *
		{
			if(!this._MinimalMode && this.LibraryPage_mc.List_mc.selectedEntry != null)
			{
				if(this.LibraryPage_mc.List_mc.selectedEntry.disabled == true)
				{
					this.codeObj.onDisabledLibraryPress();
				}
				else if(this.LibraryPage_mc.List_mc.selectedEntry.dataObj != null && this.LibraryPage_mc.List_mc.selectedEntry.dataObj.blacklisted == true)
				{
					this.codeObj.onBlacklistLibraryPress();
				}
				else if(this.LibraryPage_mc.List_mc.selectedEntry.dataObj is Object)
				{
					if(this.LibraryPage_mc.List_mc.selectedEntry.checked == true)
					{
						this.codeObj.UninstallMod(this.LibraryPage_mc.List_mc.selectedEntry.dataObj);
					}
					else
					{
						this.codeObj.InstallMod(this.LibraryPage_mc.List_mc.selectedEntry.dataObj);
					}
				}
				else if(this.LibraryPage_mc.List_mc.selectedEntry.checked == true)
				{
					this.codeObj.UninstallMod_NonBnet(this.LibraryPage_mc.List_mc.selectedEntry);
				}
				else
				{
					this.codeObj.InstallMod_NonBnet(this.LibraryPage_mc.List_mc.selectedEntry);
				}
			}
			this.UpdateButtons();
		}
		
		private function onLibraryReorderComplete() : *
		{
			this.codeObj.onLibraryReorderComplete();
		}
		
		private function UpdateButtons() : *
		{
			this.Mod_DetailsButton.ButtonVisible = this.ListsHolder_mc.visible;
			this.Mod_MyLibraryButton.ButtonVisible = this.ListsHolder_mc.visible;
			this.Mod_ConfirmButton.ButtonVisible = this.DetailsPage_mc.visible || this.SearchPage_mc.visible;
			this.Mod_ConfirmButton.ButtonText = !!this.SearchPage_mc.visible?"$Mod_Search":"$SELECT";
			this.Mod_CancelButton.ButtonVisible = true;
			this.Mod_SearchButton.ButtonVisible = this.ListsHolder_mc.visible;
			this.Mod_AccountSettingsButton.ButtonVisible = this.LibraryPage_mc.visible && !this.LibraryPage_mc.reorderMode && !this._MinimalMode;
			this.Mod_LibraryEnableButton.ButtonVisible = this.LibraryPage_mc.visible && !this.LibraryPage_mc.reorderMode && this.LibraryPage_mc.List_mc.itemsShown > 0 && !this._MinimalMode;
			this.Mod_LibraryDeleteButton.ButtonVisible = this.LibraryPage_mc.visible && !this.LibraryPage_mc.reorderMode && this.LibraryPage_mc.List_mc.itemsShown > 0 && !this._MinimalMode;
			this.Mod_ReorderButton.ButtonVisible = this.LibraryPage_mc.visible && this.LibraryPage_mc.List_mc.itemsShown > 0 && !this._MinimalMode;
			if(this.Mod_LibraryEnableButton.ButtonVisible)
			{
				this.Mod_LibraryEnableButton.ButtonText = this.LibraryPage_mc.List_mc.selectedEntry != null && this.LibraryPage_mc.List_mc.selectedEntry.checked == true?"$Mod_LibraryDisable":"$Mod_LibraryEnable";
			}
			this.UpdateTimeFilterButton();
		}
		
		private function UpdateTimeFilterButton() : *
		{
			this.Mod_TimeFilterButton.ButtonVisible = this.ListsHolder_mc.visible && (this.ListsHolder_mc.List1_mc.selectedIndex != uint.MAX_VALUE && this.ListsHolder_mc.List1_mc.dataObj.subFilterIndex != undefined || this.ListsHolder_mc.List2_mc.selectedIndex != uint.MAX_VALUE && this.ListsHolder_mc.List2_mc.dataObj.subFilterIndex != undefined);
			switch(this._CurrTimeFilterCategory)
			{
				case 5:
					this.Mod_TimeFilterButton.ButtonText = "$TimeFilterToday";
					break;
				case 6:
					this.Mod_TimeFilterButton.ButtonText = "$TimeFilterWeek";
					break;
				case 7:
					this.Mod_TimeFilterButton.ButtonText = "$TimeFilterMonth";
					break;
				case 8:
					this.Mod_TimeFilterButton.ButtonText = "$TimeFilterAll";
					break;
				default:
					this.Mod_TimeFilterButton.ButtonText = "$TimeFilterAll";
			}
		}
		
		private function onSelectionChange() : *
		{
			this.UpdateTimeFilterButton();
		}
		
		private function onModCancelPressed() : Boolean
		{
			var executeDelayedBackToLogin:* = undefined;
			var bhandled:Boolean = false;
			if(this.DetailsPage_mc.visible)
			{
				this.StopDetailsPage();
				bhandled = true;
			}
			else if(this.AccountSettingsPage_mc.visible)
			{
				this.StopAccountSettingsPage();
				bhandled = true;
			}
			else if(this.SearchPage_mc.visible)
			{
				this.StopSearchPage();
				bhandled = true;
			}
			else if(this.LibraryPage_mc.visible)
			{
				if(this._LibraryOpenedFromLogin)
				{
					executeDelayedBackToLogin = function delayedFunc(param1:Event):void
					{
						BackToLogin();
						removeEventListener(Event.ENTER_FRAME,executeDelayedBackToLogin);
						dispatchEvent(new Event("showLoginScreen",true,true));
					};
					addEventListener(Event.ENTER_FRAME,executeDelayedBackToLogin);
				}
				else
				{
					this.StopLibraryPage();
					if(this._MinimalMode)
					{
						this.codeObj.confirmCloseManager();
					}
				}
				bhandled = true;
			}
			else
			{
				this.codeObj.confirmCloseManager();
				bhandled = true;
			}
			return bhandled;
		}
		
		public function onConfirmCloseManager() : *
		{
			this.LibraryPage_mc.ClearArray();
			this.codeObj.endModMusic();
			if(!this.codeObj.attemptCloseManager())
			{
				this.LoginHolder_mc.visible = true;
				this.ListsHolder_mc.visible = false;
				this.Mod_DetailsButton.ButtonVisible = false;
				this.Mod_MyLibraryButton.ButtonVisible = false;
				this.Mod_ReorderButton.ButtonVisible = false;
				this.Mod_ConfirmButton.ButtonVisible = false;
				this.Mod_CancelButton.ButtonVisible = false;
				this.Mod_SearchButton.ButtonVisible = false;
				this.Mod_AccountSettingsButton.ButtonVisible = false;
				this.Mod_TimeFilterButton.ButtonVisible = false;
			}
		}
		
		private function onModReorderPressed() : *
		{
			this.LibraryPage_mc.reorderMode = !this.LibraryPage_mc.reorderMode;
			this.Mod_ReorderButton.ButtonText = !!this.LibraryPage_mc.reorderMode?"$DONE":"$Mod_Reorder";
			this.Mod_CancelButton.ButtonVisible = !this.LibraryPage_mc.reorderMode;
			this.UpdateButtons();
		}
		
		private function onLoginCancel() : *
		{
			this.onModCancelPressed();
		}
		
		private function onLoginOpenLoadOrder() : *
		{
			this.buttonHintBar.SetButtonHintData(this.buttonData);
			this.LoginHolder_mc.visible = false;
			this._LibraryOpenedFromLogin = true;
			this.StartLibraryPage();
		}
		
		private function onModLibraryEnablePressed() : *
		{
			this.onLibraryItemPress();
		}
		
		private function onModLibraryDeletePressed() : *
		{
			this.codeObj.DeleteModFromLibrary(this.LibraryPage_mc.List_mc.selectedEntry);
		}
		
		private function onLoadThumbnail(param1:Event) : *
		{
			this.codeObj.LoadThumbnail((param1 as CustomEvent).params);
		}
		
		private function onUnregisterImage(param1:Event) : *
		{
			this.codeObj.UnregisterImage((param1 as CustomEvent).params);
		}
		
		private function onDisplayImage(param1:Event) : *
		{
			this.codeObj.onDisplayImage((param1 as CustomEvent).params);
		}
	}
}
