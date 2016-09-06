package bhvr.views
{
	import bhvr.utils.MathUtil;
	import bhvr.constatnts.GameConstants;
	import flash.display.MovieClip;
	
	public class AlienProjectile extends Projectile
	{
		
		public static const PROJECTILE_SLOW_TYPE:String = "AlienProjectileSlow";
		
		public static const PROJECTILE_FAST_TYPE:String = "AlienProjectileFast";
		 
		
		private var _type:String;
		
		public function AlienProjectile(flashAssets:MovieClip)
		{
			super(flashAssets,this.setType());
		}
		
		public function get type() : String
		{
			return this._type;
		}
		
		private function setType() : String
		{
			var randomNum:int = MathUtil.random(0,100);
			this._type = PROJECTILE_FAST_TYPE;
			if(randomNum < GameConstants.alienSlowProjectileChance * 100)
			{
				this._type = PROJECTILE_SLOW_TYPE;
			}
			return this._type;
		}
		
		public function pauseAnimation() : void
		{
			_projectile.projectileViewMc.stop();
		}
		
		public function resumeAnimation() : void
		{
			_projectile.projectileViewMc.play();
		}
	}
}
