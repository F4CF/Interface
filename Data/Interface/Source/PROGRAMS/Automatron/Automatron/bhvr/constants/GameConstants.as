package bhvr.constants
{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class GameConstants
	{
		
		public static const STAGE_WIDTH:Number = 826;
		
		public static const STAGE_HEIGHT:Number = 700;
		
		public static var mobileMoveControlScreenRatio:Number = 0.5;
		
		public static var mobileLeftJoystickNeutralRadiusInInches:Number = 0.05;
		
		public static var mobileLeftJoystickMaxRadiusInInches:Number = 0.15;
		
		public static var mobileRightJoystickNeutralRadiusInInches:Number = 0.01;
		
		public static var mobileRightJoystickMaxRadiusInInches:Number = 0.15;
		
		public static var gameZoneArea:Rectangle;
		
		public static var heroSpawnPosition:Point;
		
		public static var leftStickSpeedPC:Number = 1;
		
		public static var leftStickSpeedXbox:Number = 1;
		
		public static var leftStickSpeedPS4:Number = 1;
		
		public static var rightStickSpeedPC:Number = 1;
		
		public static var rightStickSpeedXbox:Number = 1;
		
		public static var rightStickSpeedPS4:Number = 1;
		
		public static var heroSpeed:Number = 8;
		
		public static var heroStartLifeNum:Number = 3;
		
		public static var heroDamageAnimDuration:Number = 1.5;
		
		public static var delayBetweenHeroBullets:Number = 0.3;
		
		public static var heroBulletSpeed:Number = 15;
		
		public static var heroBonusPointsMilestone:Number = 30000;
		
		public static var heroSpawnSafeDistance:Number = 100;
		
		public static var enemyToHeroMaxOffset:Number = 80;
		
		public static var enemyBulletToHeroMaxOffset:Number = 150;
		
		public static var electrodeExplosionRadius:Number = 40;
		
		public static var humanSpeed:Number = 1;
		
		public static var humanDeathSymbolDuration:Number = 2;
		
		public static var enemyFightOffFactor:Number = 3;
		
		public static var humanPoints:Number = 1000;
		
		public static var humanReprogrammedPoints:Number = 100;
		
		public static var enemySpawnAnimationDuration:Number = 1;
		
		public static var heroSpawnAnimationDuration:Number = 1;
		
		public static var humanChangeDirectionMinDelay:Number = 3;
		
		public static var humanChangeDirectionMaxDelay:Number = 5;
		
		public static var humanChangeDirectionAfterStopDelay:Number = 0.5;
		
		public static var unstickWallChances:Number = 70;
		 
		
		public function GameConstants()
		{
			super();
		}
	}
}
