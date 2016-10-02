package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.utils.FlashUtil;
	
	public class Target extends MovieClip
	{
		 
		
		protected var _container:MovieClip;
		
		protected var _type:String;
		
		protected var _collider:MovieClip;
		
		public function Target(flashAssets:MovieClip, linkageId:String)
		{
			super();
			this._type = linkageId;
			this._container = FlashUtil.getLibraryItem(flashAssets,this._type) as MovieClip;
			addChild(this._container);
		}
		
		public function get type() : String
		{
			return this._type;
		}
		
		public function get collider() : MovieClip
		{
			return this._collider;
		}
		
		public function destroy() : void
		{
			this._collider = null;
		}
		
		public function dispose() : void
		{
			removeChild(this._container);
			this._collider = null;
		}
	}
}
