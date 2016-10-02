package bhvr.views
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	
	public class Projectile extends MovieClip
	{
		
		public static const UNKNOWN:int = -1;
		
		public static const MISSILE_TYPE:int = 0;
		
		public static const NUKE_TYPE:int = 1;
		
		public static const NUKE_SPLIT_TYPE:int = 2;
		
		public static const BOMBER_TYPE:int = 3;
		 
		
		protected var _type:int;
		
		protected var _projectile:MovieClip;
		
		protected var _smokeView:MovieClip;
		
		protected var _collider:DisplayObject;
		
		public function Projectile(flashAssets:MovieClip, type:int)
		{
			super();
			this._type = type;
			this._projectile = FlashUtil.getLibraryItem(flashAssets,this.getProjectileLinkageId()) as MovieClip;
			addChild(this._projectile);
			if(type != Projectile.BOMBER_TYPE)
			{
				this._smokeView = new MovieClip();
				this._smokeView.graphics.lineStyle(1,16777215);
				this._smokeView.graphics.moveTo(this._projectile.x,this._projectile.y - this._projectile.height);
				addChildAt(this._smokeView,0);
			}
		}
		
		public function get type() : int
		{
			return this._type;
		}
		
		public function get collider() : DisplayObject
		{
			return this._collider;
		}
		
		private function getProjectileLinkageId() : String
		{
			switch(this._type)
			{
				case Projectile.NUKE_TYPE:
				case Projectile.NUKE_SPLIT_TYPE:
					return "NukeMc";
				case Projectile.MISSILE_TYPE:
					return "MissileMc";
				case Projectile.BOMBER_TYPE:
					return "BomberMc";
				case Projectile.UNKNOWN:
				default:
					return "";
			}
		}
		
		public function explode() : void
		{
			this._projectile.visible = false;
		}
		
		public function drawSmoke(pos:Point) : void
		{
			if(this._smokeView)
			{
				this._smokeView.graphics.lineTo(pos.x,pos.y);
			}
		}
		
		public function dispose() : void
		{
			if(this._smokeView)
			{
				this._smokeView.graphics.clear();
				removeChild(this._smokeView);
			}
			if(this._projectile)
			{
				removeChild(this._projectile);
				this._projectile = null;
			}
		}
	}
}
