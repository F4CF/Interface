package bhvr.constatnts
{
	import flash.geom.Rectangle;
	
	public class GameConstants
	{
		
		public static const STAGE_WIDTH:Number = 826;
		
		public static const STAGE_HEIGHT:Number = 700;
		
		public static const GAME_ZONE_AREA:Rectangle = new Rectangle(30,48,765,600);
		
		public static const MAX_NUMBER_OF_LIVES:int = 3;
		
		public static const NUMBER_OF_BARNS:int = 4;
		
		public static const NUMBER_OF_BARN_PIECES_ROW:int = 6;
		
		public static const NUMBER_OF_BARN_PIECES_COL:int = 6;
		
		public static const BARN_PIECE_SIZE:int = 12;
		
		public static const NUMBER_OF_ALIEN_COLUMNS:int = 11;
		
		public static const NUMBER_OF_ALIEN_ROWS:int = 5;
		
		public static const MAX_NUMBER_OF_ENEMY_PROJECTILES:uint = 3;
		
		public static var mobileFireControlScreenRatio:Number = 0.5;
		
		public static var mobileLeftControlWidthInInches:Number = 0.625;
		
		public static var scoreAlien1:int = 10;
		
		public static var scoreAlien2:int = 20;
		
		public static var scoreAlienUFO:int = 40;
		
		public static var scoreAlienUFOTractor:int = 60;
		
		public static var scoreCow:int = 40;
		
		public static var scoreMothership:int = 100;
		
		public static var barnsInitialXPosition:Number = 140;
		
		public static var barnsInitialYPosition:Number = 540;
		
		public static var alienShootMinInterval:Number = 3;
		
		public static var alienShootMaxInterval:Number = 6;
		
		public static var alienSlowProjectileSpeed:Number = 300;
		
		public static var alienFastProjectileSpeed:Number = 600;
		
		public static var alienSlowProjectileChance:Number = 0.6;
		
		public static var alienWaveMaxInterval:Number = 0.8;
		
		public static var alienWaveMinInterval:Number = 0.1;
		
		public static var alienWaveIntervalMod:Number = 0.2;
		
		public static var alienWaveIntervalRatio:Number = 0.5;
		
		public static var alienWaveIntervalLastAlien:Number = 0.05;
		
		public static var alienWaveMovesPerRowNumLastAlien:Number = 5;
		
		public static var alienWaveMovesPerRowNum:int = 40;
		
		public static var alienWaveInitialYPosition:Number = 40;
		
		public static var alienWaveDistMoveVertical:Number = 40;
		
		public static var horizontalSpaceBetweenAliens:Number = 45;
		
		public static var verticalSpaceBetweenAliens:Number = 40;
		
		public static var playerSpeed:Number = 5;
		
		public static var playerProjectileSpeed:Number = 10;
		
		public static var mothershipYPosition:Number = 70;
		
		public static var mothershipSpeed:Number = 100;
		
		public static var mothershipMinSpawnTimeInterval:Number = 10;
		
		public static var mothershipMaxSpawnTimeInterval:Number = 20;
		
		public static var mothershipInitSpawnTimeInterval:Number = 30;
		
		public static var alienUFOTractorMinSpawnTimeInterval:Number = 10;
		
		public static var alienUFOTractorMaxSpawnTimeInterval:Number = 20;
		
		public static var alienUFOTractorInitSpawnTimeInterval:Number = 30;
		
		public static var tractorBeamMinHeight:Number = 500;
		
		public static var tractorBeamSpeed:Number = 10;
		
		public static var cowReleaseSpeed:Number = 100;
		
		public static var cowRunSpeed:Number = 100;
		
		public static var cowMooInterval:Number = 2.5;
		 
		
		public function GameConstants()
		{
			super();
		}
	}
}
