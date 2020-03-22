package
{
	import Shared.BGSExternalInterface;
	import Shared.GlobalFunc;
	import Shared.PlatformChangeEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MapHolder extends PipboyTab
	{
		
		protected static const COMPANION_MAP_DRAG_THRESHOLD:Number = 25;
		
		public static const MAP_LOADED:String = "MapHolder::map_loaded";
		
		public static const SELECTION_CHANGE:String = "MapHolder::selection_change";
		
		public static const SET_CUSTOM_MARKER:String = "MapHolder:set_custom_marker";
		
		public static const ACTIVATE_MARKER:String = "MapHolder:activate_marker";
		
		protected static const MarkerTypesA:Array = [CaveMarker,CityMarker,DiamondCityMarker,EncampmentMarker,FactoryMarker,MonumentMarker,MetroMarker,MilitaryBaseMarker,LandmarkMarker,OfficeMarker,TownRuinsMarker,UrbanRuinsMarker,SancHillsMarker,SettlementMarker,SewerMarker,VaultMarker,AirfieldMarker,BunkerHillMarker,CamperMarker,CarMarker,ChurchMarker,CountryClubMarker,CustomHouseMarker,DriveInMarker,ElevatedHighwayMarker,FaneuilHallMarker,FarmMarker,FillingStationMarker,ForestedMarker,GoodneighborMarker,GraveyardMarker,HospitalMarker,IndustrialDomeMarker,IndustrialStacksMarker,InstituteMarker,IrishPrideMarker,JunkyardMarker,ObservatoryMarker,PierMarker,PondLakeMarker,QuarryMarker,RadioactiveAreaMarker,RadioTowerMarker,SalemMarker,SchoolMarker,ShipwreckMarker,SubmarineMarker,SwanPondMarker,SynthHeadMarker,TownMarker,BoSMarker,BrownstoneMarker,BunkerMarker,CastleMarker,SkyscraperMarker,LibertaliaMarker,LowRiseMarker,MinutemenMarker,PoliceStationMarker,PrydwenMarker,RailroadFactionMarker,RailroadMarker,SatelliteMarker,SentinelMarker,USSConstitutionMarker,MechanistMarker,RaiderSettlementMarker,VassalSettlementMarker,PotentialVassalSettlementMarker,BottlingPlantMarker,GalacticMarker,HubMarker,KiddieKingdomMarker,MonorailMarker,RidesMarker,SafariMarker,WildWestMarker,POIMarker,DisciplesMarker,OperatorsMarker,PackMarker,DoorMarker,QuestMarker,QuestMarkerDoor,QuestMarker,PlayerSetMarker,PlayerLocMarker,PowerArmorLocMarker];
		 
		
		public var TextureHolder_mc:MovieClip;
		
		public var MarkerHolder_mc:MovieClip;
		
		protected var bMapLoaded:Boolean;
		
		private var bTexturesRegistered:Boolean;
		
		protected var MarkerInfoA:Array;
		
		protected var fZoomScale:Number;
		
		private const SELECT_RADIUS:Number = 50;
		
		private var _uiSelectedMarkerIndex:uint;
		
		private var _uiSelectedMarkerId:uint;
		
		private var _bCanFastTravel:Boolean = false;
		
		private var _bCanPlaceMarker:Boolean = false;
		
		protected var MARKER_SCALE_MIN:Number = 2.0;
		
		protected var MARKER_SCALE_MAX:Number = 0.5;
		
		protected var MARKER_SCALE_SELECTED_MIN:Number = 2.5;
		
		protected var MARKER_SCALE_SELECTED_MAX:Number = 0.625;
		
		protected var LEFT_GUTTER_PCT:Number;
		
		protected var RIGHT_GUTTER_PCT:Number;
		
		protected var TOP_GUTTER_PCT:Number;
		
		protected var BOTTOM_GUTTER_PCT:Number;
		
		protected var BORDER_X:Number;
		
		protected var BORDER_Y:Number;
		
		protected var BORDER_WIDTH:Number;
		
		protected var BORDER_HEIGHT:Number;
		
		protected var RIGHT_STICK_ZOOM_SPEED:Number;
		
		protected var MOUSE_WHEEL_ZOOM_SPEED:Number;
		
		protected var LEFT_STICK_MOVE_SPEED:Number;
		
		protected var MOUSE_DRAG_MOVE_SPEED:Number;
		
		protected var uiCenterMarkerIndex:uint;
		
		protected var NWCorner:Point;
		
		protected var NECorner:Point;
		
		protected var SWCorner:Point;
		
		protected var SECorner:Point;
		
		protected var RightAxis:Point;
		
		protected var DownAxis:Point;
		
		protected var fInverseMapWorldWidth:Number;
		
		protected var fInverseMapWorldHeight:Number;
		
		protected var bDisableInput:Boolean;
		
		protected var bMapMoving:Boolean;
		
		protected var _MapDragging:Boolean;
		
		protected var _ViewCaravansMode:Boolean;
		
		protected var _HasCaravans:Boolean;
		
		protected var fLastMouseX:Number;
		
		protected var fLastMouseY:Number;
		
		protected var fMouseDownX:Number;
		
		protected var fMouseDownY:Number;
		
		private var MOUSE_HOVER_SCROLL_X_MIN:Number = 50.0;
		
		private var MOUSE_HOVER_SCROLL_X_MAX:Number = 765.0;
		
		private var MOUSE_HOVER_SCROLL_Y_MIN:Number = 110.0;
		
		private var MOUSE_HOVER_SCROLL_Y_MAX:Number = 620.0;
		
		public var OnSelectedMarkerInfoMovedDelegate:Function;
		
		public var bCompanionGPSMode:Boolean = false;
		
		public function MapHolder()
		{
			super();
			this.bMapLoaded = false;
			this.bMapMoving = false;
			this._MapDragging = false;
			this.bDisableInput = false;
			this.bTexturesRegistered = false;
			this._ViewCaravansMode = false;
			this._HasCaravans = false;
			this.uiSelectedMarkerIndex = uint.MAX_VALUE;
			this.uiCenterMarkerIndex = uint.MAX_VALUE;
			this.fLastMouseX = Number.MAX_VALUE;
			this.fLastMouseY = Number.MAX_VALUE;
			this.NWCorner = new Point(0,0);
			this.SECorner = new Point(0,0);
			this.fZoomScale = 1;
			this.LEFT_GUTTER_PCT = 0;
			this.RIGHT_GUTTER_PCT = 0;
			this.TOP_GUTTER_PCT = 0;
			this.BOTTOM_GUTTER_PCT = 0;
			this.BORDER_X = 0;
			this.BORDER_Y = 0;
			this.BORDER_WIDTH = 0;
			this.BORDER_HEIGHT = 0;
			this.RIGHT_STICK_ZOOM_SPEED = 1;
			this.MOUSE_WHEEL_ZOOM_SPEED = 1;
			this.LEFT_STICK_MOVE_SPEED = 1;
			this.MOUSE_DRAG_MOVE_SPEED = 1;
			addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownDetect);
			if(true)
			{
				addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovement);
				addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			}
		}
		
		override protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.Map;
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			var _loc2_:* = this.visible;
			super.onPipboyChangeEvent(param1);
			var _loc3_:* = _loc2_ !== this.visible;
			this.SECorner = this.SWCorner.add(this.NECorner.subtract(this.NWCorner));
			this.RightAxis = this.NECorner.subtract(this.NWCorner);
			this.DownAxis = this.SWCorner.subtract(this.NWCorner);
			this.fInverseMapWorldWidth = 1 / this.RightAxis.length;
			this.fInverseMapWorldHeight = 1 / this.DownAxis.length;
			if(!_loc2_)
			{
				this.disableInput = param1.DataObj.CurrentTab != this.TabIndex;
			}
			if(_loc3_ === true)
			{
				this.ClearSelectedMarker();
			}
			this.UpdateSelectedMarkerIndex();
			if(false && this.OnSelectedMarkerInfoMovedDelegate !== null)
			{
				this.OnSelectedMarkerInfoMovedDelegate.call();
			}
			if(this.bMapLoaded)
			{
				this.ClearMarkers(param1);
				this.CreateMarkers();
			}
			if(_loc3_ && !_loc2_)
			{
				this.onShowMap();
			}
			SetIsDirty();
		}
		
		private function UpdateSelectedMarkerIndex() : void
		{
			var _loc2_:uint = 0;
			var _loc1_:* = this.uiSelectedMarkerId;
			if(_loc1_ != uint.MAX_VALUE)
			{
				this.uiSelectedMarkerIndex = uint.MAX_VALUE;
				_loc2_ = 0;
				while(_loc2_ < this.MarkerInfoA.length)
				{
					if(this.MarkerInfoA[_loc2_].arrayIndex == _loc1_)
					{
						this.uiSelectedMarkerIndex = _loc2_;
						break;
					}
					_loc2_++;
				}
				if(this.uiSelectedMarkerIndex == uint.MAX_VALUE && _loc1_ != uint.MAX_VALUE)
				{
					dispatchEvent(new Event(SELECTION_CHANGE,true,true));
				}
			}
		}
		
		private function ClearSelectedMarker() : *
		{
			this.uiSelectedMarkerIndex = uint.MAX_VALUE;
			dispatchEvent(new Event(SELECTION_CHANGE,true,true));
		}
		
		public function SetTexture(param1:DisplayObject) : *
		{
			this.TextureHolder_mc.addChild(param1);
			this.onMapTextureSet();
		}
		
		public function onShowMap() : *
		{
		}
		
		public function onMapTextureSet() : *
		{
		}
		
		protected function onSetMapScale() : *
		{
		}
		
		public function get mapLoaded() : Boolean
		{
			return this.bMapLoaded;
		}
		
		public function get mapMoving() : Boolean
		{
			return this.bMapMoving;
		}
		
		public function get markerArray() : Array
		{
			return this.MarkerInfoA;
		}
		
		public function get disableInput() : Boolean
		{
			return this.bDisableInput;
		}
		
		public function set disableInput(param1:Boolean) : *
		{
			this.bDisableInput = param1;
		}
		
		public function get viewCaravansMode() : Boolean
		{
			return this._ViewCaravansMode;
		}
		
		public function get hasCaravans() : Boolean
		{
			return this._HasCaravans;
		}
		
		public function SetBorderBounds(param1:Number, param2:Number, param3:Number, param4:Number) : *
		{
			this.BORDER_X = param1;
			this.BORDER_Y = param2;
			this.BORDER_WIDTH = param3;
			this.BORDER_HEIGHT = param4;
		}
		
		public function set texturesRegistered(param1:Boolean) : *
		{
			if(!this.bTexturesRegistered && param1)
			{
				this.bTexturesRegistered = true;
				this.LoadMapTexture();
			}
		}
		
		protected function LoadMapTexture() : *
		{
		}
		
		public function get selectedMarkerInfo() : Object
		{
			return this.uiSelectedMarkerIndex != uint.MAX_VALUE?this.MarkerInfoA[this.uiSelectedMarkerIndex]:null;
		}
		
		public function get mapScale() : Number
		{
			return this.fZoomScale;
		}
		
		public function set mapScale(param1:Number) : *
		{
			this.fZoomScale = param1;
			this.onSetMapScale();
		}
		
		public function set centerMarker(param1:uint) : *
		{
			this.uiCenterMarkerIndex = param1;
			if(this.bMapLoaded)
			{
				this.DetermineCenteredMarker();
			}
		}
		
		protected function get uiSelectedMarkerIndex() : uint
		{
			return this._uiSelectedMarkerIndex;
		}
		
		protected function set uiSelectedMarkerIndex(param1:uint) : void
		{
			var _loc5_:Boolean = false;
			var _loc2_:* = param1 != this._uiSelectedMarkerIndex;
			this._uiSelectedMarkerIndex = param1;
			var _loc3_:Object = this.selectedMarkerInfo;
			var _loc4_:uint = this._uiSelectedMarkerId;
			this._uiSelectedMarkerId = !!this.selectedMarkerInfo?uint(this.selectedMarkerInfo.arrayIndex):uint(uint.MAX_VALUE);
			if(true)
			{
				if(!this.selectedMarkerInfo)
				{
					this._bCanFastTravel = false;
					this._bCanPlaceMarker = true;
				}
				else if(_loc4_ != this._uiSelectedMarkerId)
				{
					_loc5_ = this.CanActivateMarker(_loc3_);
					this._bCanFastTravel = !_loc3_.undiscovered && _loc5_ && this.codeObj.CheckHardcoreModeFastTravel(this._uiSelectedMarkerId);
					this._bCanPlaceMarker = !this._bCanFastTravel && _loc5_ || MarkerTypesA[_loc3_.type] == PlayerSetMarker;
				}
				if(this.codeObj && _loc2_)
				{
					this.codeObj.RefreshMapMarkers(this._uiSelectedMarkerId);
				}
			}
		}
		
		protected function get uiSelectedMarkerId() : uint
		{
			return this._uiSelectedMarkerId;
		}
		
		public function get bCanFastTravel() : Boolean
		{
			return this._bCanFastTravel;
		}
		
		public function get bCanPlaceMarker() : Boolean
		{
			return this._bCanPlaceMarker;
		}
		
		protected function pageToMapSpace(param1:Number) : Number
		{
			return param1 * this.TextureHolder_mc.width / this.getMapHolderWidthWithoutMarkers();
		}
		
		protected function mapToPageSpace(param1:Number) : Number
		{
			return param1 * this.getMapHolderWidthWithoutMarkers() / this.TextureHolder_mc.width;
		}
		
		private function getMapHolderWidthWithoutMarkers() : Number
		{
			return this.scaleX * (-this.MarkerHolder_mc.x + this.TextureHolder_mc.width);
		}
		
		protected function normalizedToMapSpace(param1:Point) : Point
		{
			var _loc2_:Number = this.TextureHolder_mc.width * this.LEFT_GUTTER_PCT;
			var _loc3_:Number = this.TextureHolder_mc.height * this.TOP_GUTTER_PCT;
			var _loc4_:Number = this.TextureHolder_mc.width * (1 - this.RIGHT_GUTTER_PCT);
			var _loc5_:Number = this.TextureHolder_mc.height * (1 - this.BOTTOM_GUTTER_PCT);
			var _loc6_:Point = new Point();
			_loc6_.x = _loc2_ + param1.x * (_loc4_ - _loc2_);
			_loc6_.y = _loc3_ + param1.y * (_loc5_ - _loc3_);
			return _loc6_;
		}
		
		protected function mapToNormalizedSpace(param1:Point) : Point
		{
			var _loc2_:Number = this.TextureHolder_mc.width * this.LEFT_GUTTER_PCT;
			var _loc3_:Number = this.TextureHolder_mc.height * this.TOP_GUTTER_PCT;
			var _loc4_:Number = this.TextureHolder_mc.width * (1 - this.RIGHT_GUTTER_PCT);
			var _loc5_:Number = this.TextureHolder_mc.height * (1 - this.BOTTOM_GUTTER_PCT);
			var _loc6_:Point = new Point();
			_loc6_.x = (param1.x - _loc2_) / (_loc4_ - _loc2_);
			_loc6_.y = (param1.y - _loc3_) / (_loc5_ - _loc3_);
			return _loc6_;
		}
		
		public function GetMouseWorldCoords() : Point
		{
			var _loc1_:Point = this.mapToNormalizedSpace(new Point(this.mouseX - this.MarkerHolder_mc.x,this.mouseY - this.MarkerHolder_mc.y));
			return new Point(this.NWCorner.x + _loc1_.x * (this.SECorner.x - this.NWCorner.x),this.NWCorner.y + _loc1_.y * (this.SECorner.y - this.NWCorner.y));
		}
		
		public function MoveMap(param1:Number, param2:Number) : *
		{
			if(this.OnSelectedMarkerInfoMovedDelegate !== null)
			{
				this.OnSelectedMarkerInfoMovedDelegate.call();
			}
		}
		
		public function ZoomMap(param1:Number) : *
		{
			if(this.OnSelectedMarkerInfoMovedDelegate !== null)
			{
				this.OnSelectedMarkerInfoMovedDelegate.call();
			}
		}
		
		protected function onMouseWheel(param1:MouseEvent) : *
		{
			if(!this.bDisableInput)
			{
				this.ZoomMap(param1.delta * this.MOUSE_WHEEL_ZOOM_SPEED);
				this.ZoomMap(0);
			}
		}
		
		public function ClearMarkers(param1:PipboyChangeEvent) : *
		{
			var _loc2_:Array = null;
			var _loc3_:uint = 0;
			var _loc4_:uint = 0;
			var _loc5_:MovieClip = null;
			if(true || param1.DataObj.RemoveAllMapMarkers)
			{
				while(this.MarkerHolder_mc.numChildren > 0)
				{
					this.MarkerHolder_mc.removeChildAt(0);
				}
			}
			else
			{
				_loc2_ = param1.DataObj.RemovedMapMarkerIds;
				_loc3_ = 0;
				while(_loc3_ < _loc2_.length)
				{
					_loc4_ = 0;
					while(_loc4_ < this.MarkerHolder_mc.numChildren)
					{
						_loc5_ = this.MarkerHolder_mc.getChildAt(_loc4_) as MovieClip;
						if(_loc5_.markerId == _loc2_[_loc3_])
						{
							this.MarkerHolder_mc.removeChildAt(_loc4_);
							break;
						}
						_loc4_++;
					}
					_loc3_++;
				}
			}
		}
		
		protected function RefreshMarkers() : *
		{
			if(this.MarkerInfoA.length > 0 && this.MarkerInfoA[0].clip != undefined)
			{
				this.PositionMarkers();
				this.ClearSelectedMarkerScale();
				this.DrawLinkedLocations();
				if(true && !this.bDisableInput)
				{
					this.RefreshSelectedMarker();
				}
				this.RescaleMarkers();
				this.ScaleUpSelectedMarker();
			}
		}
		
		public function CreateMarkers() : *
		{
			var _loc3_:Object = null;
			var _loc4_:MovieClip = null;
			var _loc5_:uint = 0;
			var _loc6_:String = null;
			var _loc7_:MovieClip = null;
			var _loc1_:MovieClip = null;
			var _loc2_:uint = 0;
			while(_loc2_ < this.MarkerInfoA.length)
			{
				_loc3_ = this.MarkerInfoA[_loc2_];
				_loc4_ = null;
				if(true || _loc3_.clip == null)
				{
					_loc5_ = _loc3_.type < MarkerTypesA.length?uint(_loc3_.type):uint(0);
					_loc4_ = new MarkerTypesA[_loc5_]();
					this.MarkerHolder_mc.addChild(_loc4_);
					_loc3_.clip = _loc4_;
					_loc3_.shouldClamp = this.ShouldClampToEdges(_loc3_.type);
				}
				else
				{
					_loc4_ = _loc3_.clip;
				}
				if(_loc3_.undiscovered !== undefined)
				{
					_loc6_ = !!_loc3_.undiscovered?"Undiscovered":"Discovered";
					if(_loc4_.currentFrameLabel != _loc6_)
					{
						_loc4_.gotoAndStop(_loc6_);
					}
				}
				if(_loc3_.rotation !== undefined)
				{
					_loc1_ = _loc4_;
					_loc4_.rotation = _loc3_.rotation;
				}
				if(_loc3_.heightState !== undefined)
				{
					_loc7_ = _loc4_.getChildByName("MarkerBase_mc") as MovieClip;
					if(_loc7_ != null)
					{
						_loc7_.gotoAndStop(_loc3_.heightState);
					}
				}
				_loc2_++;
			}
			if(false && _loc1_ !== null && this.MarkerHolder_mc.numChildren > 1)
			{
				this.MarkerHolder_mc.setChildIndex(_loc1_,this.MarkerHolder_mc.numChildren - 1);
			}
			this.RefreshMarkers();
			this.DetermineCenteredMarker();
		}
		
		protected function CenterOnMarker(param1:uint) : *
		{
			var _loc2_:Number = this.MarkerInfoA[param1].clip.origX != undefined?Number(this.MarkerInfoA[param1].clip.origX):Number(this.MarkerInfoA[param1].clip.x);
			var _loc3_:Number = this.MarkerInfoA[param1].clip.origY != undefined?Number(this.MarkerInfoA[param1].clip.origY):Number(this.MarkerInfoA[param1].clip.y);
			var _loc4_:Number = this.mapToPageSpace(-_loc2_) + this.BORDER_X + this.BORDER_WIDTH / 2;
			var _loc5_:Number = this.mapToPageSpace(-_loc3_) + this.BORDER_Y + this.BORDER_HEIGHT / 2;
			this.MoveMap(_loc4_ - this.x,_loc5_ - this.y);
		}
		
		protected function DetermineCenteredMarker() : *
		{
			var _loc1_:uint = 0;
			while(this.uiCenterMarkerIndex != uint.MAX_VALUE && _loc1_ < this.MarkerInfoA.length)
			{
				if(this.MarkerInfoA[_loc1_].arrayIndex == this.uiCenterMarkerIndex)
				{
					this.CenterOnMarker(_loc1_);
					this.uiCenterMarkerIndex = uint.MAX_VALUE;
				}
				_loc1_++;
			}
		}
		
		protected function PositionMarkers() : *
		{
			var _loc8_:Object = null;
			var _loc9_:Point = null;
			var _loc10_:Point = null;
			var _loc11_:Boolean = false;
			var _loc12_:Point = null;
			var _loc1_:Rectangle = new Rectangle();
			var _loc2_:Point = new Point();
			var _loc3_:Number = 30;
			var _loc4_:Number = 0;
			var _loc5_:Number = 0;
			var _loc6_:Number = 10;
			_loc2_.x = this.pageToMapSpace(-this.x + this.BORDER_X + this.BORDER_WIDTH / 2);
			_loc2_.y = this.pageToMapSpace(-this.y + this.BORDER_Y + this.BORDER_HEIGHT / 2);
			_loc1_.x = this.pageToMapSpace(-this.x + this.BORDER_X + _loc5_);
			_loc1_.y = this.pageToMapSpace(-this.y + this.BORDER_Y + _loc3_);
			_loc1_.width = this.pageToMapSpace(this.BORDER_WIDTH - (_loc5_ + _loc6_));
			_loc1_.height = this.pageToMapSpace(this.BORDER_HEIGHT - (_loc3_ + _loc4_));
			var _loc7_:uint = 0;
			while(_loc7_ < this.MarkerInfoA.length)
			{
				_loc8_ = this.MarkerInfoA[_loc7_];
				_loc9_ = this.ConvertWorldToLocalMarkerPosition(_loc8_.x,_loc8_.y);
				_loc8_.clip.x = _loc9_.x;
				_loc8_.clip.y = _loc9_.y;
				if(_loc8_.shouldClamp)
				{
					_loc8_.clip.origX = _loc8_.clip.x;
					_loc8_.clip.origY = _loc8_.clip.y;
					_loc10_ = new Point(_loc8_.clip.origX + this.MarkerHolder_mc.x,_loc8_.clip.origY + this.MarkerHolder_mc.y);
					_loc11_ = false;
					if(!_loc1_.containsPoint(_loc10_))
					{
						_loc12_ = this.GetBorderIntersection(_loc1_,_loc10_,_loc2_);
						if(_loc12_ != null)
						{
							_loc8_.clip.x = _loc12_.x - this.MarkerHolder_mc.x;
							_loc8_.clip.y = _loc12_.y - this.MarkerHolder_mc.y;
							_loc11_ = true;
						}
					}
					if(!_loc11_)
					{
						_loc8_.clip.x = _loc8_.clip.origX;
						_loc8_.clip.y = _loc8_.clip.origY;
					}
				}
				_loc7_++;
			}
		}
		
		public function ToggleCaravansMode() : *
		{
			if(this.bMapLoaded && this.bTexturesRegistered && !this.bDisableInput && this._HasCaravans)
			{
				this._ViewCaravansMode = !this._ViewCaravansMode;
				this.RefreshMarkers();
			}
		}
		
		protected function DrawLinkedLocations() : *
		{
			var _loc2_:Shape = null;
			var _loc3_:uint = 0;
			var _loc4_:uint = 0;
			if(this.TextureHolder_mc.getChildByName("caravanLines"))
			{
				this.TextureHolder_mc.removeChild(this.TextureHolder_mc.getChildByName("caravanLines"));
			}
			this._HasCaravans = false;
			var _loc1_:uint = 0;
			while(_loc1_ < this.MarkerInfoA.length)
			{
				this.MarkerInfoA[_loc1_].clip.visible = !this._ViewCaravansMode;
				if(this.MarkerInfoA[_loc1_].workshopLinkedLocs != undefined)
				{
					this._HasCaravans = true;
				}
				_loc1_++;
			}
			if(this._ViewCaravansMode)
			{
				_loc2_ = new Shape();
				_loc2_.name = "caravanLines";
				_loc2_.graphics.lineStyle(5,16777215,1,false,"none");
				_loc3_ = 0;
				while(_loc3_ < this.MarkerInfoA.length)
				{
					if(this.MarkerInfoA[_loc3_].workshopOwned == true || MarkerTypesA[this.MarkerInfoA[_loc3_].type] == PlayerSetMarker)
					{
						this.MarkerInfoA[_loc3_].clip.visible = true;
					}
					if(this.MarkerInfoA[_loc3_].workshopLinkedLocs != undefined)
					{
						for each(_loc4_ in this.MarkerInfoA[_loc3_].workshopLinkedLocs)
						{
							this.MarkerInfoA[_loc4_].clip.visible = true;
							_loc2_.graphics.moveTo(this.MarkerInfoA[_loc3_].clip.x,this.MarkerInfoA[_loc3_].clip.y);
							_loc2_.graphics.lineTo(this.MarkerInfoA[_loc4_].clip.x,this.MarkerInfoA[_loc4_].clip.y);
						}
					}
					_loc3_++;
				}
				this.TextureHolder_mc.addChild(_loc2_);
			}
		}
		
		protected function ConvertWorldToLocalMarkerPosition(param1:Number, param2:Number) : Point
		{
			return new Point();
		}
		
		private function RescaleMarkers() : *
		{
			var _loc1_:uint = 0;
			while(_loc1_ < this.MarkerInfoA.length)
			{
				this.MarkerInfoA[_loc1_].clip.scaleX = this.MARKER_SCALE_MIN + this.fZoomScale * (this.MARKER_SCALE_MAX - this.MARKER_SCALE_MIN);
				this.MarkerInfoA[_loc1_].clip.scaleY = this.MarkerInfoA[_loc1_].clip.scaleX;
				_loc1_++;
			}
		}
		
		private function ScaleUpSelectedMarker() : *
		{
			if(this.uiSelectedMarkerIndex != uint.MAX_VALUE)
			{
				this.MarkerInfoA[this.uiSelectedMarkerIndex].clip.scaleX = this.MARKER_SCALE_SELECTED_MIN + this.fZoomScale * (this.MARKER_SCALE_SELECTED_MAX - this.MARKER_SCALE_SELECTED_MIN);
				this.MarkerInfoA[this.uiSelectedMarkerIndex].clip.scaleY = this.MarkerInfoA[this.uiSelectedMarkerIndex].clip.scaleX;
			}
		}
		
		private function ClearSelectedMarkerScale() : *
		{
			if(this.uiSelectedMarkerIndex != uint.MAX_VALUE)
			{
				this.MarkerInfoA[this.uiSelectedMarkerIndex].clip.scaleX = this.MARKER_SCALE_MIN + this.fZoomScale * (this.MARKER_SCALE_MAX - this.MARKER_SCALE_MIN);
				this.MarkerInfoA[this.uiSelectedMarkerIndex].clip.scaleY = this.MarkerInfoA[this.uiSelectedMarkerIndex].clip.scaleX;
			}
		}
		
		private function ShouldClampToEdges(param1:uint) : Boolean
		{
			return MarkerTypesA[param1] == QuestMarker || MarkerTypesA[param1] == QuestMarkerDoor || MarkerTypesA[param1] == PlayerSetMarker;
		}
		
		private function RefreshSelectedMarker() : *
		{
			var _loc1_:uint = this.uiSelectedMarkerIndex;
			this.uiSelectedMarkerIndex = this.FindClosestMarkerIndex();
			if(!this._MapDragging && _loc1_ != this.uiSelectedMarkerIndex && this.uiSelectedMarkerIndex != uint.MAX_VALUE)
			{
				BGSExternalInterface.call(this.codeObj,"PlaySound","UIPipBoyMapRollover");
			}
			dispatchEvent(new Event(SELECTION_CHANGE,true,true));
		}
		
		private function FindClosestMarkerIndex() : uint
		{
			var _loc7_:Number = NaN;
			var _loc1_:Point = new Point();
			var _loc2_:Rectangle = new Rectangle();
			_loc1_.x = this.mouseX;
			_loc1_.y = this.mouseY;
			_loc2_.x = _loc1_.x - this.SELECT_RADIUS;
			_loc2_.y = _loc1_.y - this.SELECT_RADIUS;
			_loc2_.width = this.SELECT_RADIUS * 2;
			_loc2_.height = this.SELECT_RADIUS * 2;
			var _loc3_:* = uint.MAX_VALUE;
			var _loc4_:Point = new Point();
			var _loc5_:Number = Number.MAX_VALUE;
			var _loc6_:uint = 0;
			while(_loc6_ < this.MarkerInfoA.length)
			{
				_loc4_.x = this.MarkerInfoA[_loc6_].clip.x + this.MarkerHolder_mc.x;
				_loc4_.y = this.MarkerInfoA[_loc6_].clip.y + this.MarkerHolder_mc.y;
				if(this.MarkerInfoA[_loc6_].clip.visible && _loc2_.containsPoint(_loc4_))
				{
					if(MarkerTypesA[this.MarkerInfoA[_loc6_].type] != PlayerLocMarker)
					{
						_loc7_ = Point.distance(_loc4_,_loc1_);
						if(_loc7_ < _loc5_)
						{
							_loc3_ = _loc6_;
							_loc5_ = _loc7_;
						}
					}
				}
				_loc6_++;
			}
			return _loc3_;
		}
		
		private function GetBorderIntersection(param1:Rectangle, param2:Point, param3:Point) : Point
		{
			var _loc8_:Point = null;
			var _loc10_:Number = NaN;
			var _loc4_:Point = param1.topLeft;
			var _loc5_:Point = param1.topLeft;
			_loc5_.x = _loc5_.x + param1.width;
			var _loc6_:Point = param1.bottomRight;
			_loc6_.x = _loc6_.x - param1.width;
			var _loc7_:Point = param1.bottomRight;
			var _loc9_:Number = Math.atan2(param2.y - param3.y,param2.x - param3.x);
			_loc10_ = Math.PI * 0.2;
			var _loc11_:Number = Math.PI - _loc10_;
			if(_loc9_ >= _loc10_ && _loc9_ <= _loc11_)
			{
				_loc8_ = this.GetLineIntersection(_loc6_,_loc7_,param3,param2);
				if(_loc8_ != null && _loc8_.x < _loc6_.x)
				{
					_loc8_ = _loc6_;
				}
				else if(_loc8_ != null && _loc8_.x > _loc7_.x)
				{
					_loc8_ = _loc7_;
				}
			}
			else if(_loc9_ >= -_loc10_ && _loc9_ <= _loc10_)
			{
				_loc8_ = this.GetLineIntersection(_loc5_,_loc7_,param3,param2);
				if(_loc8_ != null && _loc8_.y < _loc5_.y)
				{
					_loc8_ = _loc5_;
				}
				else if(_loc8_ != null && _loc8_.y > _loc7_.y)
				{
					_loc8_ = _loc7_;
				}
			}
			else if(_loc9_ >= -_loc11_ && _loc9_ <= -_loc10_)
			{
				_loc8_ = this.GetLineIntersection(_loc4_,_loc5_,param3,param2);
				if(_loc8_ != null && _loc8_.x < _loc4_.x)
				{
					_loc8_ = _loc4_;
				}
				else if(_loc8_ != null && _loc8_.x > _loc5_.x)
				{
					_loc8_ = _loc5_;
				}
			}
			else
			{
				_loc8_ = this.GetLineIntersection(_loc4_,_loc6_,param3,param2);
				if(_loc8_ != null && _loc8_.y < _loc4_.y)
				{
					_loc8_ = _loc4_;
				}
				else if(_loc8_ != null && _loc8_.y > _loc6_.y)
				{
					_loc8_ = _loc6_;
				}
			}
			return _loc8_;
		}
		
		private function GetLineIntersection(param1:Point, param2:Point, param3:Point, param4:Point) : Point
		{
			var _loc8_:Point = null;
			var _loc9_:Point = null;
			var _loc10_:Number = NaN;
			var _loc11_:Number = NaN;
			var _loc5_:Point = param2.subtract(param1);
			var _loc6_:Point = param4.subtract(param3);
			var _loc7_:Number = _loc5_.x * _loc6_.y - _loc5_.y * _loc6_.x;
			if(_loc7_ != 0)
			{
				_loc9_ = param3.subtract(param1);
				_loc10_ = _loc9_.x * _loc5_.y - _loc9_.y * _loc5_.x;
				_loc11_ = _loc10_ / _loc7_;
				if(_loc11_ >= 0 && _loc11_ <= 1)
				{
					_loc8_ = Point.interpolate(param4,param3,_loc11_);
				}
			}
			return _loc8_;
		}
		
		public function HasPlayerSetMarker() : *
		{
			var _loc3_:uint = 0;
			var _loc1_:Boolean = false;
			var _loc2_:uint = 0;
			while(_loc2_ < this.MarkerInfoA.length)
			{
				_loc3_ = this.MarkerInfoA[_loc2_].type;
				if(MarkerTypesA[_loc3_] == PlayerSetMarker)
				{
					_loc1_ = true;
					break;
				}
				_loc2_++;
			}
			return _loc1_;
		}
		
		protected function CanActivateMarker(param1:Object) : *
		{
			var _loc2_:Boolean = false;
			if(param1 != null && MarkerTypesA[param1.type] != DoorMarker && MarkerTypesA[param1.type] != QuestMarker && MarkerTypesA[param1.type] != QuestMarkerDoor && MarkerTypesA[param1.type] != PlayerSetMarker && MarkerTypesA[param1.type] != PlayerLocMarker && MarkerTypesA[param1.type] != PowerArmorLocMarker)
			{
				_loc2_ = true;
			}
			return _loc2_;
		}
		
		public function OnLeftStickInput(param1:Number, param2:Number) : *
		{
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			if(!this.bDisableInput)
			{
				_loc3_ = 0;
				_loc4_ = 0;
				if(stage.mouseX < this.MOUSE_HOVER_SCROLL_X_MIN && param1 < 0 || stage.mouseX > this.MOUSE_HOVER_SCROLL_X_MAX && param1 > 0)
				{
					_loc3_ = -param1;
				}
				if(stage.mouseY < this.MOUSE_HOVER_SCROLL_Y_MIN && param2 > 0 || stage.mouseY > this.MOUSE_HOVER_SCROLL_Y_MAX && param2 < 0)
				{
					_loc4_ = param2;
				}
				if(!GlobalFunc.CloseToNumber(_loc3_,0) || !GlobalFunc.CloseToNumber(_loc4_,0))
				{
					this.bMapMoving = true;
					this.MoveMap(_loc3_ * this.LEFT_STICK_MOVE_SPEED,_loc4_ * this.LEFT_STICK_MOVE_SPEED);
				}
				else
				{
					this.bMapMoving = false;
					this.RefreshMarkers();
				}
			}
		}
		
		public function OnRightStickInput(param1:Number, param2:Number) : *
		{
			if(!this.bDisableInput)
			{
				this.ZoomMap(param2 * this.RIGHT_STICK_ZOOM_SPEED);
			}
		}
		
		protected function onMouseDownDetect() : *
		{
			if(!this.bDisableInput)
			{
				if(iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE || iPlatform == PlatformChangeEvent.PLATFORM_MOBILE)
				{
					if(true || !this.bCompanionGPSMode)
					{
						this.bMapMoving = false;
						this._MapDragging = false;
						this.fLastMouseX = stage.mouseX;
						this.fLastMouseY = stage.mouseY;
						this.fMouseDownX = stage.mouseX;
						this.fMouseDownY = stage.mouseY;
						stage.addEventListener(Event.ENTER_FRAME,this.onUpdate);
					}
				}
				stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpDetect);
			}
		}
		
		protected function onMouseUpDetect(param1:MouseEvent) : *
		{
			var _loc2_:Object = null;
			stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpDetect);
			stage.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			if(!this._MapDragging)
			{
				_loc2_ = this.selectedMarkerInfo;
				if(this.CanActivateMarker(_loc2_))
				{
					dispatchEvent(new Event(ACTIVATE_MARKER,true,true));
				}
				else if(_loc2_ == null || MarkerTypesA[_loc2_.type] == PlayerSetMarker)
				{
					dispatchEvent(new Event(SET_CUSTOM_MARKER,true,true));
				}
			}
			this.bMapMoving = false;
			this._MapDragging = false;
		}
		
		protected function onUpdate() : *
		{
			var _loc1_:Number = stage.mouseX - this.fLastMouseX;
			var _loc2_:Number = stage.mouseY - this.fLastMouseY;
			if(!this._MapDragging)
			{
				this.bMapMoving = _loc1_ != 0 || _loc2_ != 0;
				this._MapDragging = this.bMapMoving;
			}
			this.MoveMap(_loc1_ * this.MOUSE_DRAG_MOVE_SPEED,_loc2_ * this.MOUSE_DRAG_MOVE_SPEED);
			this.fLastMouseX = stage.mouseX;
			this.fLastMouseY = stage.mouseY;
		}
		
		protected function onMouseMovement(param1:MouseEvent) : *
		{
			if(!this.bDisableInput)
			{
				this.RefreshMarkers();
			}
		}
	}
}
