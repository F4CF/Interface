package
{
	import Shared.BGSExternalInterface;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class WorldMapHolder extends TextureMapHolder
	{
		 
		
		protected var _TextureName:String;
		
		public function WorldMapHolder()
		{
			super();
			MIN_SCALE = 0.75;
			MAX_SCALE = 5;
			START_ZOOM = 0.117647;
			LEFT_GUTTER_PCT = 0.02685546875;
			RIGHT_GUTTER_PCT = 0.0283203125;
			TOP_GUTTER_PCT = 0.02685546875;
			BOTTOM_GUTTER_PCT = 0.0283203125;
			LEFT_PAN_GUTTER_PCT = Number(0.0568253567369617);
			RIGHT_PAN_GUTTER_PCT = Number(-0.0481121353706276);
			TOP_PAN_GUTTER_PCT = Number(0.0633541496968051);
			BOTTOM_PAN_GUTTER_PCT = Number(-0.0589193592180288);
			RIGHT_STICK_ZOOM_SPEED = 0.05;
			MOUSE_WHEEL_ZOOM_SPEED = 0.15;
			LEFT_STICK_MOVE_SPEED = 10;
			MOUSE_DRAG_MOVE_SPEED = 1;
			this._TextureName = "Textures/Interface/Pip-Boy/WorldMap_d.dds";
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			MarkerInfoA = param1.DataObj.WorldMapMarkers;
			NWCorner = param1.DataObj.WorldMapNWCorner;
			NECorner = param1.DataObj.WorldMapNECorner;
			SWCorner = param1.DataObj.WorldMapSWCorner;
			this._TextureName = param1.DataObj.WorldMapTextureName;
			trace(param1.DataObj.WorldMapTextureName);
			switch(this._TextureName)
			{
				case "DLC03\\Interface\\Map\\MapFarHarbor.dds":
					LEFT_GUTTER_PCT = 0.00920067;
					RIGHT_GUTTER_PCT = 0.03374173;
					TOP_GUTTER_PCT = 0.02515624;
					BOTTOM_GUTTER_PCT = 0.00958931;
					break;
				case "DLC04\\Interface\\Map\\NukaWorldMap.DDS":
					LEFT_GUTTER_PCT = -0.045;
					RIGHT_GUTTER_PCT = -0.095;
					TOP_GUTTER_PCT = 0.0005;
					BOTTOM_GUTTER_PCT = -0.155;
					break;
				default:
					LEFT_GUTTER_PCT = 0.02685546875;
					RIGHT_GUTTER_PCT = 0.0283203125;
					TOP_GUTTER_PCT = 0.02685546875;
					BOTTOM_GUTTER_PCT = 0.0283203125;
			}
			super.onPipboyChangeEvent(param1);
		}
		
		override public function onShowMap() : *
		{
			BGSExternalInterface.call(this.codeObj,"CenterMarkerRequest",true);
			super.onShowMap();
		}
		
		override protected function LoadMapTexture() : *
		{
			var _loc1_:URLRequest = null;
			var _loc2_:LoaderContext = null;
			if(TextureHolder_mc.numChildren == 0)
			{
				_loc2_ = new LoaderContext(false,ApplicationDomain.currentDomain);
				MapImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onMapLoadComplete);
				MapImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onMapLoadFailed);
				_loc1_ = new URLRequest("img://WorldMap");
				MapImageLoader.load(_loc1_,_loc2_);
			}
		}
		
		override protected function ConvertWorldToLocalMarkerPosition(param1:Number, param2:Number) : Point
		{
			var _loc3_:Point = new Point((param1 - NWCorner.x) * fInverseMapWorldWidth,(NWCorner.y - param2) * fInverseMapWorldHeight);
			return normalizedToMapSpace(_loc3_);
		}
	}
}
