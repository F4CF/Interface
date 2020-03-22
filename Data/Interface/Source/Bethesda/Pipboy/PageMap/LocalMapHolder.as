package
{
	import Shared.BGSExternalInterface;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class LocalMapHolder extends TextureMapHolder
	{
		 
		
		public function LocalMapHolder()
		{
			super();
			MIN_SCALE = 0.75;
			MAX_SCALE = 2;
			START_ZOOM = 0.2;
			MARKER_SCALE_MIN = 2;
			MARKER_SCALE_MAX = 1.5;
			MARKER_SCALE_SELECTED_MIN = 2.5;
			MARKER_SCALE_SELECTED_MAX = 1.875;
			RIGHT_STICK_ZOOM_SPEED = 0.05;
			MOUSE_WHEEL_ZOOM_SPEED = 0.15;
			LEFT_STICK_MOVE_SPEED = 12.5;
			MOUSE_DRAG_MOVE_SPEED = Number(2.75);
		}
		
		public function MapInitialized(param1:int, param2:int) : *
		{
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			MarkerInfoA = param1.DataObj.LocalMapMarkers;
			NWCorner = param1.DataObj.LocalMapNWCorner;
			NECorner = param1.DataObj.LocalMapNECorner;
			SWCorner = param1.DataObj.LocalMapSWCorner;
			super.onPipboyChangeEvent(param1);
			if(false && bCompanionGPSMode)
			{
				this.CenterMapOnPlayer();
			}
		}
		
		override public function onShowMap() : *
		{
			BGSExternalInterface.call(this.codeObj,"CenterMarkerRequest",false);
			super.onShowMap();
		}
		
		override protected function LoadMapTexture() : *
		{
			var _loc1_:URLRequest = null;
			var _loc2_:LoaderContext = null;
			if(TextureHolder_mc.numChildren == 0)
			{
				_loc1_ = new URLRequest("img://LocalMap");
				_loc2_ = new LoaderContext(false,ApplicationDomain.currentDomain);
				MapImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onMapLoadComplete);
				MapImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onMapLoadFailed);
				MapImageLoader.load(_loc1_,_loc2_);
			}
		}
		
		override public function onMapTextureSet() : *
		{
			super.onMapTextureSet();
		}
		
		public function CenterMapOnPlayer() : *
		{
		}
		
		override protected function ConvertWorldToLocalMarkerPosition(param1:Number, param2:Number) : Point
		{
			var _loc3_:* = new Point(param1,param2).subtract(NWCorner);
			var _loc4_:Point = this.Project(_loc3_,RightAxis);
			var _loc5_:Point = this.Project(_loc3_,DownAxis);
			var _loc6_:Point = new Point(_loc4_.length * fInverseMapWorldWidth,_loc5_.length * fInverseMapWorldHeight);
			if(this.DotProduct(_loc4_,RightAxis) < 0)
			{
				_loc6_.x = -_loc6_.x;
			}
			if(this.DotProduct(_loc5_,DownAxis) < 0)
			{
				_loc6_.y = -_loc6_.y;
			}
			return normalizedToMapSpace(_loc6_);
		}
		
		private function Project(param1:Point, param2:Point) : Point
		{
			var _loc3_:Number = this.DotProduct(param1,param2) / this.DotProduct(param2,param2);
			return new Point(param2.x * _loc3_,param2.y * _loc3_);
		}
		
		private function DotProduct(param1:Point, param2:Point) : Number
		{
			return param1.x * param2.x + param1.y * param2.y;
		}
	}
}
