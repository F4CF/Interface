package
{
	import Pipboy.COMPANIONAPP.MobileBackButtonEvent;
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.AS3.COMPANIONAPP.PipboyLoader;
	import Shared.BGSExternalInterface;
	import Shared.CustomEvent;
	import Shared.IMenu;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	
	public class PipboyMenu extends IMenu
	{
		 
		
		public var Header_mc:Pipboy_Header;
		
		public var BottomBar_mc:Pipboy_BottomBar;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var BGSCodeObj:Object;
		
		private var PageA:Vector.<PipboyLoader>;
		
		public var DataObj:Pipboy_DataObj;
		
		private var _IsLoadingPage:Boolean;
		
		private var GridViewButton:BSButtonHintData;
		
		private var ReadOnlyWarning:MovieClip;
		
		public var READ_ONLY_WARNING_NONE = 0;
		
		public var READ_ONLY_WARNING_DEFAULT = 1;
		
		public var READ_ONLY_WARNING_OFFLINE = 2;
		
		public var READ_ONLY_WARNING_DEMO = 3;
		
		public function PipboyMenu()
		{
			this.GridViewButton = new BSButtonHintData("$Grid View","T","PSN_Y","Xenon_Y",1,this.onGridViewPress);
			super();
			this.BGSCodeObj = new Object();
			this.DataObj = new Pipboy_DataObj();
			this._IsLoadingPage = false;
			this.PageA = new <PipboyLoader>[new PipboyLoader(),new PipboyLoader(),new PipboyLoader(),new PipboyLoader(),new PipboyLoader()];
			this.PageA.fixed = true;
			addEventListener(BSScrollingList.PLAY_FOCUS_SOUND,this.onListPlayFocus);
			addEventListener(Pipboy_Header.PAGE_CLICKED,this.onPageClicked);
			addEventListener(Pipboy_Header.TAB_CLICKED,this.onTabClicked);
			addEventListener(PipboyPage.LOWER_PIPBOY_ALLOW_CHANGE,this.onLowerPipboyAllowChange);
			addEventListener(PipboyPage.BOTTOM_BAR_UPDATE,this.onRequestBottomBarUpdate);
		}
		
		private function loadMobileSettings() : void
		{
			var _loc1_:PipboyLoader = new PipboyLoader();
			var _loc2_:URLRequest = new URLRequest();
			var _loc3_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			_loc2_.url = "PipboyMobileSettings.swf";
			_loc1_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onMobileSettingsLoaded);
			_loc1_.load(_loc2_,_loc3_);
		}
		
		private function onMobileSettingsLoaded(param1:Event) : *
		{
			param1.target.removeEventListener(Event.COMPLETE,this.onMobileSettingsLoaded);
			var _loc2_:MovieClip = param1.target.content as MovieClip;
			addChild(_loc2_);
			BGSExternalInterface.call(this.BGSCodeObj,"OnMobileSettingsLoaded",_loc2_);
			_loc2_.addEventListener("WindowOpened",this.onSettingsOpened);
			_loc2_.addEventListener("WindowClosed",this.onSettingsClosed);
			BGSExternalInterface.call(this.BGSCodeObj,"RegisterMovie",this);
		}
		
		private function onSettingsOpened(param1:Event) : void
		{
			this.Header_mc.tabSwipeZone.deactivate();
		}
		
		private function onSettingsClosed(param1:Event) : void
		{
			this.Header_mc.tabSwipeZone.activate();
		}
		
		private function SetReadOnlyWarningMessage(param1:int) : void
		{
			var _loc2_:* = "";
			var _loc3_:* = false;
			if(param1 == this.READ_ONLY_WARNING_DEFAULT)
			{
				_loc2_ = "$Companion_ReadOnly";
				_loc3_ = true;
			}
			else if(param1 == this.READ_ONLY_WARNING_OFFLINE)
			{
				_loc2_ = "$Companion_OfflineMode";
				_loc3_ = true;
			}
			else if(param1 == this.READ_ONLY_WARNING_DEMO)
			{
				_loc2_ = "$Companion_DemoMode";
				_loc3_ = true;
			}
			if(_loc3_)
			{
				if(this.ReadOnlyWarning != null)
				{
					removeChild(this.ReadOnlyWarning);
					this.ReadOnlyWarning = null;
				}
				this.ReadOnlyWarning = new (getDefinitionByName("ReadOnlyWarning") as Class)() as MovieClip;
				this.ReadOnlyWarning.readOnlyMc.readOnlyTxt.text = _loc2_;
				addChild(this.ReadOnlyWarning);
				this.ReadOnlyWarning.mouseEnabled = false;
				this.ReadOnlyWarning.mouseChildren = false;
				this.ReadOnlyWarning.x = stage.stageWidth / 2;
				this.ReadOnlyWarning.y = 128;
			}
			else if(this.ReadOnlyWarning != null)
			{
				removeChild(this.ReadOnlyWarning);
				this.ReadOnlyWarning = null;
			}
		}
		
		private function onPageClicked(param1:CustomEvent) : *
		{
			var _loc2_:uint = param1.params as uint;
			this.TryToSetPage(_loc2_);
		}
		
		private function onTabClicked(param1:CustomEvent) : *
		{
			var _loc2_:uint = param1.params as uint;
			this.TryToSetTab(_loc2_);
		}
		
		public function onCodeObjCreate() : *
		{
			BGSExternalInterface.call(this.BGSCodeObj,"PopulatePipboyInfoObj",this.DataObj);
		}
		
		public function onCodeObjDestruction() : *
		{
			this.ClearPages();
			this.BGSCodeObj = null;
			this.DataObj = null;
		}
		
		public function get CurrentPage() : PipboyPage
		{
			return this.GetPage(this.DataObj.CurrentPage);
		}
		
		private function GetPage(param1:uint) : PipboyPage
		{
			return param1 < this.PageA.length?this.PageA[param1].contentLoaderInfo.content as PipboyPage:null;
		}
		
		private function ClearPages() : *
		{
			var _loc2_:PipboyPage = null;
			var _loc1_:uint = 0;
			while(_loc1_ < this.PageA.length)
			{
				_loc2_ = this.GetPage(_loc1_);
				if(_loc2_)
				{
					removeChild(_loc2_);
				}
				this.PageA[_loc1_].unloadAndStop();
				_loc1_++;
			}
		}
		
		public function InvalidateData() : void
		{
			this.InvalidatePartialData(4294967295);
		}
		
		public function InvalidatePartialData(param1:uint) : *
		{
			if(!this._IsLoadingPage)
			{
				if(this.CurrentPage == null)
				{
					this.ClearPages();
					this.LoadCurrentPage();
				}
				else
				{
					this.SetReadOnlyWarningMessage(this.DataObj.ReadOnlyMode);
					PipboyChangeEvent.DispatchEvent(new PipboyUpdateMask(param1),stage,this.DataObj,this.CurrentPage.TabNames);
					this.GridViewButton.ButtonText = this.DataObj.PerkPoints > 0?"$$LEVELUP (" + this.DataObj.PerkPoints + ")":"$Grid View";
					this.GridViewButton.ButtonFlashing = this.DataObj.PerkPoints > 0;
					this.GridViewButton.ButtonVisible = this.CurrentPage == null || this.CurrentPage.CanLowerPipboy();
				}
			}
		}
		
		private function onLowerPipboyAllowChange() : *
		{
			this.GridViewButton.ButtonVisible = this.CurrentPage == null || this.CurrentPage.CanLowerPipboy();
		}
		
		private function onRequestBottomBarUpdate() : *
		{
			PipboyChangeEvent.DispatchEvent(PipboyUpdateMask.BottomBar,stage,this.DataObj,this.CurrentPage.TabNames);
		}
		
		private function LoadCurrentPage() : *
		{
			var _loc1_:URLRequest = null;
			var _loc2_:LoaderContext = null;
			if(this.DataObj.CurrentPage < this.PageA.length)
			{
				_loc1_ = new URLRequest();
				_loc2_ = new LoaderContext(false,ApplicationDomain.currentDomain);
				switch(this.DataObj.CurrentPage)
				{
					case 0:
						_loc1_.url = "Pipboy_StatsPage.swf";
						break;
					case 1:
						_loc1_.url = "Pipboy_InvPage.swf";
						break;
					case 2:
						_loc1_.url = "Pipboy_DataPage.swf";
						break;
					case 3:
						_loc1_.url = "Pipboy_MapPage.swf";
						break;
					case 4:
						_loc1_.url = "Pipboy_RadioPage.swf";
				}
				this.PageA[this.DataObj.CurrentPage].contentLoaderInfo.addEventListener(Event.COMPLETE,this.onPageLoadComplete);
				this.PageA[this.DataObj.CurrentPage].load(_loc1_,_loc2_);
				this._IsLoadingPage = true;
			}
		}
		
		private function onPageLoadComplete(param1:Event) : *
		{
			param1.target.removeEventListener(Event.COMPLETE,this.onPageLoadComplete);
			var _loc2_:PipboyPage = param1.target.content as PipboyPage;
			_loc2_.InitCodeObj(this.BGSCodeObj);
			addChild(_loc2_);
			if(!CompanionAppMode.isOn)
			{
				_loc2_.buttonHintDataV.push(this.GridViewButton);
			}
			this.ButtonHintBar_mc.SetButtonHintData(_loc2_.buttonHintDataV);
			if(CompanionAppMode.isOn)
			{
				if(this.DataObj.CurrentPage != 3)
				{
					swapChildren(this.ButtonHintBar_mc,_loc2_);
				}
				this.ButtonHintBar_mc.x = this.BottomBar_mc.x;
				this.ButtonHintBar_mc.y = this.DataObj.CurrentPage == 3?Number(631.55):Number(584);
				if(this.ReadOnlyWarning != null)
				{
					swapChildren(this.ReadOnlyWarning,this.ButtonHintBar_mc);
				}
			}
			this._IsLoadingPage = false;
			this.InvalidateData();
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = this.CurrentPage != null && this.CurrentPage.ProcessUserEvent(param1,param2);
			if(!_loc3_)
			{
				if(!param2)
				{
					_loc3_ = true;
					if(param1 == "Forward" || param1 == "LTrigger")
					{
						this.gotoPrevPage();
					}
					else if(param1 == "Back" || param1 == "RTrigger")
					{
						this.gotoNextPage();
					}
					else if(param1 == "StrafeLeft" || param1 == "Left")
					{
						this.gotoPrevTab();
					}
					else if(param1 == "StrafeRight" || param1 == "Right")
					{
						this.gotoNextTab();
					}
					if(param1 == "YButton" && this.GridViewButton.ButtonVisible)
					{
						this.onGridViewPress();
					}
					else
					{
						_loc3_ = false;
					}
				}
			}
			return _loc3_;
		}
		
		private function onListPlayFocus() : *
		{
			BGSExternalInterface.call(this.BGSCodeObj,"PlaySound","UIGeneralFocus");
		}
		
		public function gotoNextPage() : *
		{
			this.TryToSetPage(this.DataObj.CurrentPage + 1);
		}
		
		public function gotoPrevPage() : *
		{
			this.TryToSetPage(this.DataObj.CurrentPage - 1);
		}
		
		public function TryToSetPage(param1:uint) : *
		{
			if(param1 < this.PageA.length && this.CurrentPage != null && this.CurrentPage.CanSwitchFromCurrentPage())
			{
				if(param1 != this.DataObj.CurrentPage)
				{
					BGSExternalInterface.call(this.BGSCodeObj,"onNewPage",param1);
				}
			}
		}
		
		public function gotoNextTab() : *
		{
			this.TryToSetTab(this.DataObj.CurrentTab + 1);
		}
		
		public function gotoPrevTab() : *
		{
			this.TryToSetTab(this.DataObj.CurrentTab - 1);
		}
		
		public function TryToSetTab(param1:uint) : *
		{
			if(this.CurrentPage != null && this.CurrentPage.CanSwitchTabs(param1))
			{
				if(param1 != this.DataObj.CurrentTab)
				{
					BGSExternalInterface.call(this.BGSCodeObj,"onNewTab",param1);
				}
			}
		}
		
		public function onRightThumbstickInput(param1:uint) : *
		{
			if(this.CurrentPage != null)
			{
				this.CurrentPage.onRightThumbstickInput(param1);
			}
		}
		
		private function onGridViewPress() : *
		{
			BGSExternalInterface.call(this.BGSCodeObj,"ShowPerksMenu");
		}
		
		public function onMobileBackButtonPressed() : void
		{
			MobileBackButtonEvent.DispatchEvent(stage);
		}
		
		public function onMobileItemPress(param1:Event) : void
		{
		}
	}
}
