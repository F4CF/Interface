package
{
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.COMPANIONAPP.PipboyLoader;
	import Shared.BGSExternalInterface;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class Pipboy_MapPage extends PipboyPage
	{
		 
		
		private const LOCAL_MAP_MODE_MANUAL:uint = 0;
		
		private const LOCAL_MAP_MODE_GPS:uint = 1;
		
		public var WorldMapHolder_mc:MapHolder;
		
		public var LocalMapHolder_mc:MapHolder;
		
		public var WorldMapMask_mc:MovieClip;
		
		public var LocalMapMask_mc:MovieClip;
		
		public var SelectionInfo_mc:SelectionInfo;
		
		public var MessageHolder_mc:MovieClip;
		
		public var CompanionMessages:Messages;
		
		private var FastTravelButton:BSButtonHintData;
		
		private var PlaceMarkerButton:BSButtonHintData;
		
		private var LWToggleButton:BSButtonHintData;
		
		private var ScanButton:BSButtonHintData;
		
		private var ManualModeButton:BSButtonHintData;
		
		private var GPSModeButton:BSButtonHintData;
		
		private var ViewCaravansButton:BSButtonHintData;
		
		private var MessageClip:MessageBoxMenu;
		
		private var MessageParams:Object;
		
		private var MessageCallback:Function;
		
		private var bShowingLocalMap:Boolean;
		
		private var LocalMapMode:uint = 1;
		
		public function Pipboy_MapPage()
		{
			this.FastTravelButton = new BSButtonHintData("$FastTravel","Mouse1","PSN_A","Xenon_A",1,null);
			this.PlaceMarkerButton = new BSButtonHintData("$PLACEMARKER","Mouse1","PSN_A","Xenon_A",1,null);
			this.ScanButton = new BSButtonHintData("$Companion_Scan","S","PSN_Y","Xenon_Y",1,this.onScanButtonClicked);
			this.ManualModeButton = new BSButtonHintData("$Companion_ManualMode","S","PSN_Y","Xenon_Y",1,this.onManualModeButtonClicked);
			this.GPSModeButton = new BSButtonHintData("$Companion_GPSMode","S","PSN_Y","Xenon_Y",1,this.onGPSModeButtonClicked);
			this.ViewCaravansButton = new BSButtonHintData("$ShowCaravans","C","PSN_L1","Xenon_L1",1,this.onViewCaravans);
			super();
			this.WorldMapHolder_mc.TabIndex = 0;
			this.LocalMapHolder_mc.TabIndex = 1;
			this.WorldMapHolder_mc.SetBorderBounds(this.WorldMapMask_mc.x,this.WorldMapMask_mc.y,this.WorldMapMask_mc.width,this.WorldMapMask_mc.height);
			this.LocalMapHolder_mc.SetBorderBounds(this.LocalMapMask_mc.x,this.LocalMapMask_mc.y,this.LocalMapMask_mc.width,this.LocalMapMask_mc.height);
			this.bShowingLocalMap = false;
			this.CompanionMessages.mouseEnabled = false;
			this.CompanionMessages.mouseChildren = false;
			this.SelectionInfo_mc.mouseEnabled = false;
			this.SelectionInfo_mc.mouseChildren = false;
			this.WorldMapHolder_mc.addEventListener(MapHolder.MAP_LOADED,this.onWorldMapLoaded);
		}
		
		override protected function PopulateButtonHintData() : *
		{
			this.LWToggleButton = new BSButtonHintData("$World Map","R","PSN_X","Xenon_X",1,this.onXButtonClicked);
			if(true)
			{
				_buttonHintDataV.push(this.FastTravelButton);
				_buttonHintDataV.push(this.PlaceMarkerButton);
				this.FastTravelButton.ButtonVisible = false;
				this.PlaceMarkerButton.ButtonVisible = false;
			}
			_buttonHintDataV.push(this.LWToggleButton);
			this.LWToggleButton.ButtonVisible = false;
			_buttonHintDataV.push(this.ViewCaravansButton);
			this.ViewCaravansButton.ButtonVisible = false;
		}
		
		override public function InitCodeObj(param1:Object) : *
		{
			super.InitCodeObj(param1);
			BGSExternalInterface.call(this.codeObj,"RegisterMap",this);
			this.WorldMapHolder_mc.InitCodeObj(this.codeObj);
			this.LocalMapHolder_mc.InitCodeObj(this.codeObj);
		}
		
		override public function ReleaseCodeObj() : *
		{
			BGSExternalInterface.call(this.codeObj,"UnregisterMap");
			this.WorldMapHolder_mc.ReleaseCodeObj();
			this.LocalMapHolder_mc.ReleaseCodeObj();
			super.ReleaseCodeObj();
		}
		
		override protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.Map;
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			super.onPipboyChangeEvent(param1);
			if(!this.showingMessage)
			{
				stage.focus = null;
			}
			this.currMapObj.removeEventListener(MapHolder.SELECTION_CHANGE,this.onMapSelectionChange);
			this.currMapObj.removeEventListener(MapHolder.SET_CUSTOM_MARKER,this.onSetCustomMarker);
			this.currMapObj.removeEventListener(MapHolder.ACTIVATE_MARKER,this.onMarkerActivated);
			this.bShowingLocalMap = param1.DataObj.CurrentTab == 1;
			this.currMapObj.addEventListener(MapHolder.SELECTION_CHANGE,this.onMapSelectionChange);
			this.currMapObj.addEventListener(MapHolder.SET_CUSTOM_MARKER,this.onSetCustomMarker);
			this.currMapObj.addEventListener(MapHolder.ACTIVATE_MARKER,this.onMarkerActivated);
			this.LWToggleButton.ButtonText = !!this.bShowingLocalMap?"$World Map":"$Local Map";
			this.LWToggleButton.ButtonVisible = true;
			this.UpdateCaravansButton();
			this.UpdateCompanionButtonsVisibility();
			this.onMapSelectionChange();
		}
		
		override protected function onReadOnlyChanged(param1:Boolean) : void
		{
			super.onReadOnlyChanged(param1);
			if(param1 && this.showingMessage)
			{
				this.CloseMessage();
			}
		}
		
		override protected function HandleMobileBackButton() : Boolean
		{
			var _loc1_:Boolean = false;
			if(this.showingMessage)
			{
				this.CloseMessage();
				_loc1_ = true;
			}
			return _loc1_;
		}
		
		private function get currMapObj() : MapHolder
		{
			return !!this.bShowingLocalMap?this.LocalMapHolder_mc:this.WorldMapHolder_mc;
		}
		
		private function get showingMessage() : Boolean
		{
			return this.MessageClip != null;
		}
		
		public function onMapTexturesLoaded() : *
		{
			this.WorldMapHolder_mc.texturesRegistered = true;
			this.LocalMapHolder_mc.texturesRegistered = true;
		}
		
		private function onWorldMapLoaded() : *
		{
			this.UpdateCaravansButton();
		}
		
		public function OnLeftStickInput(param1:Number, param2:Number) : *
		{
			this.currMapObj.OnLeftStickInput(param1,param2);
		}
		
		public function OnRightStickInput(param1:Number, param2:Number) : *
		{
			this.currMapObj.OnRightStickInput(param1,param2);
		}
		
		protected function onMapSelectionChange() : *
		{
			var _loc1_:Object = this.currMapObj.selectedMarkerInfo;
			if(_loc1_ != null)
			{
				this.SelectionInfo_mc.SetSelectionInfo(_loc1_);
				this.updateSelectionInfoPosition();
			}
			else
			{
				this.SelectionInfo_mc.ClearSelectionInfo();
			}
			if(true)
			{
				this.FastTravelButton.ButtonVisible = this.currMapObj.bCanFastTravel;
				this.PlaceMarkerButton.ButtonVisible = this.currMapObj.bCanPlaceMarker;
			}
		}
		
		private function updateSelectionInfoPosition() : *
		{
			var _loc2_:* = undefined;
			var _loc3_:Point = null;
			var _loc1_:Object = this.currMapObj.selectedMarkerInfo;
			if(_loc1_ !== null)
			{
				_loc2_ = _loc1_.clip;
				if(_loc2_ !== null && _loc2_ !== undefined)
				{
					_loc3_ = new Point(_loc2_.x,_loc2_.y);
					this.SelectionInfo_mc.x = this.currMapObj.MarkerHolder_mc.localToGlobal(_loc3_).x;
					this.SelectionInfo_mc.y = this.currMapObj.MarkerHolder_mc.localToGlobal(_loc3_).y + this.currMapObj.selectedMarkerInfo.clip.height * this.currMapObj.scaleX;
				}
			}
		}
		
		private function onMarkerActivated() : void
		{
			if(!this.bShowingLocalMap)
			{
				if(this.currMapObj.selectedMarkerInfo.undiscovered == true)
				{
					this.DisplayMessage("","$FastTravelUndiscovered",[{
						"text":"$Yes",
						"param":new Point(this.currMapObj.selectedMarkerInfo.x,this.currMapObj.selectedMarkerInfo.y)
					},{"text":"$No"}],this.onUndiscoveredMarkerConfirm);
				}
				else if(!this.codeObj.CheckHardcoreModeFastTravel(this.currMapObj.selectedMarkerInfo.arrayIndex))
				{
					this.DisplayMessage("","$HardcorePreventedFastTravel",[{
						"text":"$Yes",
						"param":new Point(this.currMapObj.selectedMarkerInfo.x,this.currMapObj.selectedMarkerInfo.y)
					},{"text":"$No"}],this.onHardcorePreventedFastTravelConfirm);
				}
				else
				{
					this.DisplayMessage("","$ConfirmFastTravel",[{"text":"$Yes"},{"text":"$No"},{
						"text":"$PlaceMarker",
						"param":new Point(this.currMapObj.selectedMarkerInfo.x,this.currMapObj.selectedMarkerInfo.y)
					}],this.onFTConfirmPress);
				}
			}
		}
		
		private function onSetCustomMarker() : void
		{
			var _loc1_:Point = this.currMapObj.GetMouseWorldCoords();
			if(this.currMapObj.HasPlayerSetMarker())
			{
				this.DisplayMessage("","$MoveMarkerQuestion",[{
					"text":"$MoveMarker",
					"param":_loc1_
				},{"text":"$RemoveMarker"},{"text":"$Cancel"}],this.onChangeMarkerConfirm);
			}
			else
			{
				BGSExternalInterface.call(this.codeObj,"SetPlayerMarker",_loc1_.x,_loc1_.y);
			}
		}
		
		public function SetCenterMarker(param1:uint) : *
		{
			this.currMapObj.centerMarker = param1;
		}
		
		public function onFTConfirmPress(param1:uint, param2:Point) : *
		{
			switch(param1)
			{
				case 0:
					BGSExternalInterface.call(this.codeObj,"FastTravel",this.currMapObj.selectedMarkerInfo.arrayIndex);
					BGSExternalInterface.call(this.codeObj,"PlaySound","UIMenuOK");
					break;
				case 1:
					BGSExternalInterface.call(this.codeObj,"PlaySound","UIMenuCancel");
					break;
				case 2:
					BGSExternalInterface.call(this.codeObj,"SetPlayerMarker",param2.x,param2.y);
					BGSExternalInterface.call(this.codeObj,"PlaySound","UIGeneralFocus");
			}
		}
		
		public function onUndiscoveredMarkerConfirm(param1:uint, param2:Point) : *
		{
			if(param1 == 0)
			{
				BGSExternalInterface.call(this.codeObj,"SetPlayerMarker",param2.x,param2.y);
			}
		}
		
		public function onHardcorePreventedFastTravelConfirm(param1:uint, param2:Point) : *
		{
			if(param1 == 0)
			{
				BGSExternalInterface.call(this.codeObj,"SetPlayerMarker",param2.x,param2.y);
			}
		}
		
		public function onChangeMarkerConfirm(param1:uint, param2:Point) : *
		{
			switch(param1)
			{
				case 0:
					BGSExternalInterface.call(this.codeObj,"SetPlayerMarker",param2.x,param2.y);
					BGSExternalInterface.call(this.codeObj,"PlaySound","UIGeneralFocus");
					break;
				case 1:
					BGSExternalInterface.call(this.codeObj,"ClearPlayerMarker");
					BGSExternalInterface.call(this.codeObj,"PlaySound","UIMenuCancel");
					break;
				case 2:
					BGSExternalInterface.call(this.codeObj,"PlaySound","UIMenuCancel");
			}
		}
		
		private function onXButtonClicked() : void
		{
			BGSExternalInterface.call(this.codeObj,"onSwitchBetweenWorldLocalMap");
		}
		
		override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(this.showingMessage)
			{
				_loc3_ = true;
				if(!param2 && param1 == "Cancel")
				{
					BGSExternalInterface.call(this.codeObj,"PlaySound","UIMenuCancel");
					this.CloseMessage();
				}
			}
			else if(param1 == "XButton" && this.LWToggleButton.ButtonVisible && !param2)
			{
				this.onXButtonClicked();
			}
			else if(param1 == "LShoulder" && this.ViewCaravansButton.ButtonVisible && !param2)
			{
				this.onViewCaravans();
				_loc3_ = true;
			}
			return _loc3_;
		}
		
		override public function CanSwitchFromCurrentPage() : Boolean
		{
			return !this.showingMessage;
		}
		
		private function DisplayMessage(param1:String, param2:String, param3:Array, param4:Function) : *
		{
			var _loc5_:PipboyLoader = null;
			var _loc6_:URLRequest = null;
			var _loc7_:LoaderContext = null;
			if(this.MessageClip == null)
			{
				_loc5_ = new PipboyLoader();
				_loc6_ = new URLRequest("PipboyMessageBox.swf");
				_loc7_ = new LoaderContext(false,ApplicationDomain.currentDomain);
				_loc5_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onMessageLoadComplete);
				this.MessageParams = {
					"header":param1,
					"body":param2,
					"buttons":param3
				};
				this.MessageCallback = param4;
				_loc5_.load(_loc6_,_loc7_);
			}
		}
		
		private function onMessageLoadComplete(param1:Event) : *
		{
			param1.target.removeEventListener(Event.COMPLETE,this.onMessageLoadComplete);
			if(!_ReadOnlyMode)
			{
				this.MessageClip = param1.target.content.getChildByName("Menu_mc");
				this.MessageClip.bodyText = this.MessageParams.body;
				this.MessageClip.buttonArray = this.MessageParams.buttons;
				this.MessageHolder_mc.addChild(param1.target.content);
				this.MessageClip.addEventListener(BSScrollingList.ITEM_PRESS,this.onMessageButtonPress);
				this.MessageClip.addEventListener(BSScrollingList.LIST_ITEMS_CREATED,this.onMessageListInit);
				this.MessageClip.ForceInit();
				this.MessageHolder_mc.visible = true;
				BGSExternalInterface.call(this.codeObj,"onModalOpen",true);
				this.WorldMapHolder_mc.disableInput = true;
				this.LocalMapHolder_mc.disableInput = true;
			}
			else
			{
				param1.target.loader.unload();
				this.MessageCallback = null;
			}
			this.MessageParams = null;
		}
		
		private function onMessageListInit() : *
		{
			this.MessageClip.InvalidateMenu();
		}
		
		private function onMessageButtonPress() : *
		{
			if(this.MessageCallback != null)
			{
				this.MessageCallback(this.MessageClip.selectedIndex,this.MessageClip.buttonArray[this.MessageClip.selectedIndex].param);
			}
			this.CloseMessage();
		}
		
		private function CloseMessage() : void
		{
			this.MessageClip.removeEventListener(BSScrollingList.ITEM_PRESS,this.onMessageButtonPress);
			this.MessageCallback = null;
			this.MessageHolder_mc.removeChild(this.MessageClip);
			this.MessageClip.parent.loaderInfo.loader.unload();
			this.MessageClip = null;
			this.MessageHolder_mc.visible = false;
			BGSExternalInterface.call(this.codeObj,"onModalOpen",false);
			this.WorldMapHolder_mc.disableInput = false;
			this.LocalMapHolder_mc.disableInput = false;
		}
		
		private function OnSelectedMarkerInfoMovedDelegate() : *
		{
			this.updateSelectionInfoPosition();
		}
		
		private function onScanButtonClicked() : *
		{
			if(false && this.LocalMapMode === this.LOCAL_MAP_MODE_MANUAL)
			{
				BGSExternalInterface.call(this.codeObj,"onScanButtonClicked");
			}
		}
		
		public function SetLocalMapMode(param1:uint) : *
		{
		}
		
		private function UpdateCompanionButtonsVisibility() : *
		{
		}
		
		private function UpdateCaravansButton() : *
		{
			this.ViewCaravansButton.ButtonText = !!this.WorldMapHolder_mc.viewCaravansMode?"$HideCaravans":"$ShowCaravans";
			this.ViewCaravansButton.ButtonVisible = this.WorldMapHolder_mc.hasCaravans && true;
		}
		
		private function onManualModeButtonClicked() : *
		{
			if(false && this.LocalMapMode !== this.LOCAL_MAP_MODE_MANUAL)
			{
				BGSExternalInterface.call(this.codeObj,"onManualModeButtonClicked");
			}
		}
		
		private function onGPSModeButtonClicked() : *
		{
			if(false && this.LocalMapMode !== this.LOCAL_MAP_MODE_GPS)
			{
				BGSExternalInterface.call(this.codeObj,"functiononGPSModeButtonClicked");
			}
		}
		
		private function onViewCaravans() : *
		{
			this.WorldMapHolder_mc.ToggleCaravansMode();
			this.UpdateCaravansButton();
			BGSExternalInterface.call(this.codeObj,"PlaySmallTransition");
		}
	}
}
