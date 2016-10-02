package bhvr.views
{
	import flash.display.MovieClip;
	
	public class Helmet extends InteractiveObject
	{
		 
		
		public function Helmet(assets:MovieClip)
		{
			super(assets);
			this.reset();
		}
		
		public function collect() : void
		{
			_collider = null;
			_assets.gotoAndPlay("collect");
		}
		
		public function reset() : void
		{
			_collider = _assets;
			_assets.gotoAndPlay("idle");
		}
		
		override public function pause() : void
		{
			super.pause();
			_assets.stop();
		}
		
		override public function resume() : void
		{
			super.resume();
			_assets.play();
		}
	}
}
