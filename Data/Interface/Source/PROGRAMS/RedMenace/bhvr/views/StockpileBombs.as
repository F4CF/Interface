package bhvr.views
{
	import flash.display.MovieClip;
	
	public class StockpileBombs extends InteractiveObject
	{
		 
		
		private var _bombCollider:MovieClip;
		
		public function StockpileBombs(assets:MovieClip)
		{
			super(assets);
			_collider = _assets.colliderMc;
			this._bombCollider = _assets.bombColliderMc;
		}
		
		public function get bombCollider() : MovieClip
		{
			return this._bombCollider;
		}
		
		override public function pause() : void
		{
			super.pause();
			_assets.lightMc.stop();
		}
		
		override public function resume() : void
		{
			super.resume();
			_assets.lightMc.play();
		}
	}
}
