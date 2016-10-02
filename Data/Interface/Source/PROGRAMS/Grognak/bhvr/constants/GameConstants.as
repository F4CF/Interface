package bhvr.constants
{
	public class GameConstants
	{
		
		public static const STAGE_WIDTH:Number = 826;
		
		public static const STAGE_HEIGHT:Number = 700;
		
		public static const MAX_PARTY_MEMBERS:uint = 3;
		
		public static const VISIBLE_TILES_PER_ROW:uint = 15;
		
		public static const VISIBLE_TILES_PER_COL:uint = 12;
		
		public static const TILE_WIDTH:Number = 40;
		
		public static const TILE_HEIGHT:Number = 40;
		
		public static const BASE_INITIATIVE_CHEAT_INCREMENT:int = 4;
		
		public static const ATTACK_POWER_CHEAT_INCREMENT:int = 2;
		
		public static const MAX_HP_CHEAT_INCREMENT:int = 3;
		
		public static const FOCUS_CHEAT_INCREMENT:int = 10;
		
		public static const GOLD_CHEAT_INCREMENT:int = 25;
		
		public static var mapRepeatInputDelay:Number = 1;
		
		public static var mapPopupManualCancelDelay:Number = 0.5;
		
		public static var mapPopupAutoCancelDelay:Number = 4;
		
		public static var mapGrognakToShipDuration:Number = 1;
		
		public static var mapGrognakFadeShipDuration:Number = 0.5;
		
		public static var mapShipStepDuration:Number = 0.1;
		
		public static var mapTriggerEventDelay:Number = 0.04;
		
		public static var pauseShort:Number = 1;
		
		public static var pauseMedium:Number = 1.5;
		
		public static var pauseLong:Number = 2;
		
		public static var initLowerBound:int = 10;
		
		public static var initUpperBound:int = 10;
		
		public static var aggroInitial:int = 10;
		
		public static var factorAggroDmg:Number = 0.3;
		
		public static var factorAggroRecover:Number = 0.5;
		
		public static var factorAggroMeditate:Number = 0.5;
		
		public static var factorAggroRage:Number = 0.3;
		
		public static var factorAggroSalve:Number = 0.5;
		
		public static var factorAggroSleep:Number = 1.2;
		
		public static var factorAggroDaze:Number = 1.2;
		
		public static var factorAggroFlee:Number = 1.5;
		
		public static var percRecoverHP:int = 10;
		
		public static var focusMeditateRegen:int = 10;
		
		public static var percMeditateResist:int = 25;
		
		public static var lifetimeCombatFX:Number = 1.3;
		
		public static var focusNaturalRegen:int = 5;
		
		public static var rageStrikes:int = 3;
		
		public static var aggroDareSelf:int = 100;
		
		public static var percDareResist:int = 50;
		
		public static var percDareLimit:int = 60;
		
		public static var atksSalveNum:int = 3;
		
		public static var percSalveResist:int = 75;
		
		public static var turnsSleepMin:int = 3;
		
		public static var turnsSleepMax:int = 3;
		
		public static var factorSleepDmg:Number = 1.5;
		
		public static var turnsDazeMin:int = 3;
		
		public static var turnsDazeMax:int = 3;
		
		public static var dmgDazeMin:int = 5;
		
		public static var dmgDazeMax:int = 10;
		
		public static var atkPwrDazeRatio:int = 3;
		 
		
		public function GameConstants()
		{
			super();
		}
	}
}
