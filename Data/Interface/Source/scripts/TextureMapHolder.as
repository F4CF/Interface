package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import Shared.AS3.COMPANIONAPP.PipboyLoader;
	import Shared.BGSExternalInterface;
	import Shared.GlobalFunc;


	public class TextureMapHolder extends MapHolder
	{
		protected var MapImageLoader:PipboyLoader;
		protected var START_ZOOM:Number;
		protected var MAX_SCALE:Number;
		protected var MAX_X_VAL:Number;
		protected var MAX_Y_VAL:Number;
		protected var MIN_SCALE:Number;
		protected var MIN_X_VAL:Number;
		protected var MIN_Y_VAL:Number;
		protected var TOP_PAN_GUTTER_PCT:Number;
		protected var BOTTOM_PAN_GUTTER_PCT:Number;
		protected var LEFT_PAN_GUTTER_PCT:Number;
		protected var RIGHT_PAN_GUTTER_PCT:Number;


// Class
//====================================================================================================

		public function TextureMapHolder()
		{
			super();
			this.MIN_SCALE = 1;
			this.MAX_SCALE = 1;
			this.START_ZOOM = 0;
			this.LEFT_PAN_GUTTER_PCT = 0;
			this.RIGHT_PAN_GUTTER_PCT = 0;
			this.TOP_PAN_GUTTER_PCT = 0;
			this.BOTTOM_PAN_GUTTER_PCT = 0;
			this.MapImageLoader = new PipboyLoader();
		}



// Methods
//====================================================================================================

		override public function onShowMap() : *
		{
			if(TextureHolder_mc.numChildren > 0)
			{
				this.mapScale = this.START_ZOOM;
			}
			super.onShowMap();
		}


		protected function onMapLoadComplete(e:Event) : *
		{
			e.target.removeEventListener(Event.COMPLETE,this.onMapLoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onMapLoadFailed);
			if(e.target.content != null)
			{
				TextureHolder_mc.addChild(e.target.content);
				this.onMapTextureSet();
				CreateMarkers();
				bMapLoaded = true;
				dispatchEvent(new Event(MAP_LOADED,true,true));
			}
			this.MapImageLoader.unloadAndStop();
		}


		protected function onMapLoadFailed(e:IOErrorEvent) : *
		{
			if(e != null)
			{
				e.target.removeEventListener(Event.COMPLETE,this.onMapLoadComplete);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onMapLoadFailed);
			}
		}


		override public function onMapTextureSet() : *
		{
			this.mapScale = this.START_ZOOM;
		}


		override protected function onSetMapScale() : *
		{
			this.scaleX = this.MIN_SCALE + this.mapScale * (this.MAX_SCALE - this.MIN_SCALE);
			this.scaleY = this.scaleX;
			this.MAX_X_VAL = BORDER_WIDTH * this.LEFT_PAN_GUTTER_PCT;
			this.MAX_Y_VAL = BORDER_HEIGHT * this.TOP_PAN_GUTTER_PCT;
			this.MIN_X_VAL = -this.width + BORDER_WIDTH * (1 - this.RIGHT_PAN_GUTTER_PCT);
			this.MIN_Y_VAL = -this.height + BORDER_HEIGHT * (1 - this.BOTTOM_PAN_GUTTER_PCT);
		}


		override public function MoveMap(param1:Number, param2:Number) : *
		{
			var _loc3_:Number = this.x;
			var _loc4_:Number = this.y;
			this.x = Math.min(Math.max(this.x + param1,this.MIN_X_VAL),this.MAX_X_VAL);
			this.y = Math.min(Math.max(this.y + param2,this.MIN_Y_VAL),this.MAX_Y_VAL);
			if(!GlobalFunc.CloseToNumber(_loc3_,this.x) || !GlobalFunc.CloseToNumber(_loc4_,this.y))
			{
				RefreshMarkers();
			}
			super.MoveMap(param1,param2);
		}


		override public function ZoomMap(param1:Number) : *
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			if(!bMapMoving && (param1 > 0 && !GlobalFunc.CloseToNumber(this.mapScale,1) && this.mapScale < 1 || param1 < 0 && !GlobalFunc.CloseToNumber(this.mapScale,0) && this.mapScale > 0))
			{
				_loc2_ = pageToMapSpace(-this.x + BORDER_WIDTH / 2);
				_loc3_ = pageToMapSpace(-this.y + BORDER_HEIGHT / 2);
				_loc4_ = this.mapScale;
				this.mapScale = Math.min(1,Math.max(0,this.mapScale + param1));
				if(!GlobalFunc.CloseToNumber(this.mapScale,_loc4_))
				{
					BGSExternalInterface.call(this.codeObj,"PlaySound","UIPipBoyMapZoom");
				}
				_loc5_ = mapToPageSpace(-_loc2_) + BORDER_WIDTH / 2;
				_loc6_ = mapToPageSpace(-_loc3_) + BORDER_HEIGHT / 2;
				this.MoveMap(_loc5_ - this.x,_loc6_ - this.y);
			}
			super.ZoomMap(param1);
		}



	}
}
