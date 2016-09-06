package bhvr.views
{
	import flash.geom.Rectangle;
	import bhvr.utils.FlashUtil;
	import flash.display.MovieClip;
	
	public class Ladder extends InteractiveObject
	{
		 
		
		protected var _dimension:Rectangle;
		
		public function Ladder(assets:MovieClip)
		{
			super(assets);
			this._dimension = this.getDimensions();
			if(_assets.colliderMc)
			{
				_collider = _assets.colliderMc;
				return;
			}
			throw new Error("Missing mandatory \'colliderMc\' MovieClip in a Ladder object");
		}
		
		public function get thickness() : Number
		{
			return this._dimension.width;
		}
		
		public function get topPosition() : Number
		{
			return this._dimension.y - this._dimension.height / 2;
		}
		
		public function get bottomPosition() : Number
		{
			return this._dimension.y + this._dimension.height / 2;
		}
		
		public function get snapPosition() : Number
		{
			return this._dimension.x;
		}
		
		protected function getDimensions() : Rectangle
		{
			if(_assets.boundingBoxMc)
			{
				return new Rectangle(FlashUtil.localToGlobalPosition(_assets.boundingBoxMc).x,FlashUtil.localToGlobalPosition(_assets.boundingBoxMc).y,_assets.boundingBoxMc.width,_assets.boundingBoxMc.height);
			}
			throw new Error("Missing mandatory \'boundingBoxMc\' MovieClip in a Ladder object");
		}
	}
}
