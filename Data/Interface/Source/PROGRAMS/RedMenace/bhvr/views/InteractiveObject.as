package bhvr.views
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	
	public class InteractiveObject extends EventDispatcher
	{
		 
		
		protected var _assets:MovieClip;
		
		protected var _collider:MovieClip;
		
		public function InteractiveObject(assets:MovieClip)
		{
			super();
			this._assets = assets;
			this._collider = this._assets;
		}
		
		public function get collider() : MovieClip
		{
			return this._collider;
		}
		
		public function get name() : String
		{
			return this._assets.name;
		}
		
		public function pause() : void
		{
		}
		
		public function resume() : void
		{
		}
		
		public function destroy() : void
		{
			this._collider = null;
		}
		
		public function dispose() : void
		{
			this._assets = null;
			this._collider = null;
		}
	}
}
