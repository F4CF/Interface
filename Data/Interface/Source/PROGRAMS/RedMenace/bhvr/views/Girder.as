package bhvr.views
{
	import flash.geom.Rectangle;
	import bhvr.utils.FlashUtil;
	import flash.display.MovieClip;
	
	public class Girder extends InteractiveObject
	{
		 
		
		protected var _dimension:Rectangle;
		
		protected var _coeffA:Number;
		
		protected var _constB:Number;
		
		protected var _speed:Number;
		
		public function Girder(assets:MovieClip)
		{
			super(assets);
			_collider = _assets;
			this.init();
		}
		
		public function get speed() : Number
		{
			return this._speed;
		}
		
		public function get leftExtremity() : Number
		{
			return this._dimension.x - this._dimension.width / 2;
		}
		
		public function get rightExtremity() : Number
		{
			return this._dimension.x + this._dimension.width / 2;
		}
		
		private function init() : void
		{
			var yPosEnd:Number = NaN;
			var xPosEnd:Number = NaN;
			var yPosStart:Number = NaN;
			var xPosStart:Number = NaN;
			this._dimension = this.getDimensions();
			if(_assets.startMarkerMc != null && _assets.endMarkerMc != null)
			{
				yPosEnd = FlashUtil.localToGlobalPosition(_assets.endMarkerMc).y;
				xPosEnd = FlashUtil.localToGlobalPosition(_assets.endMarkerMc).x;
				yPosStart = FlashUtil.localToGlobalPosition(_assets.startMarkerMc).y;
				xPosStart = FlashUtil.localToGlobalPosition(_assets.startMarkerMc).x;
				this._coeffA = (yPosEnd - yPosStart) / (xPosEnd - xPosStart);
				this._constB = yPosEnd - this._coeffA * xPosEnd;
			}
			else
			{
				this._coeffA = 0;
				this._constB = this._dimension.y - this._dimension.height / 2;
			}
			this._speed = 0;
		}
		
		private function getDimensions() : Rectangle
		{
			if(_assets.boundingBoxMc != null)
			{
				return new Rectangle(FlashUtil.localToGlobalPosition(_assets.boundingBoxMc).x,FlashUtil.localToGlobalPosition(_assets.boundingBoxMc).y,_assets.boundingBoxMc.width,_assets.boundingBoxMc.height);
			}
			return new Rectangle(_assets.x,_assets.y,_assets.width,_assets.height);
		}
		
		public function getYFromX(posX:Number) : Number
		{
			return this._coeffA * posX + this._constB;
		}
	}
}
