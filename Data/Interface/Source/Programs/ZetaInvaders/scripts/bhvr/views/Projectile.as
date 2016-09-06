package bhvr.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	
	public class Projectile extends MovieClip
	{
		 
		
		protected var _projectile:MovieClip;
		
		protected var _colliderPoint:Point;
		
		public function Projectile(flashAssets:MovieClip, linkageId:String)
		{
			super();
			this._projectile = FlashUtil.getLibraryItem(flashAssets,linkageId) as MovieClip;
			addChild(this._projectile);
			this._colliderPoint = new Point(this._projectile.x,this._projectile.y);
		}
		
		public function get colliderPoint() : Point
		{
			return this._colliderPoint;
		}
		
		public function explode() : void
		{
			this._projectile.visible = false;
		}
		
		public function dispose() : void
		{
			if(this._projectile)
			{
				removeChild(this._projectile);
				this._projectile = null;
			}
		}
	}
}
