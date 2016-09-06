package bhvr.views
{
	import flash.display.MovieClip;
	
	public class LaserProjectile extends Projectile
	{
		 
		
		private const ASSET_LINKAGE_ID:String = "LaserProjectileMc";
		
		public function LaserProjectile(flashAssets:MovieClip)
		{
			super(flashAssets,this.ASSET_LINKAGE_ID);
		}
	}
}
