package bhvr.modules
{
	import bhvr.controller.StageController;
	import bhvr.views.BossStage1;
	import bhvr.events.GameEvents;
	import flash.display.MovieClip;
	import bhvr.data.SoundList;
	
	public class Stage1 extends StageController
	{
		 
		
		public function Stage1(assets:MovieClip)
		{
			_laddersNum = 10;
			_girdersNum = 6;
			_currentStageMusic = SoundList.STAGE_GENERIC_MUSIC_LOOP_SOUND_ID;
			super(assets);
		}
		
		override protected function createBoss() : void
		{
			_boss = new BossStage1(_assets.bossMc,_assets.bombsContainerMc,_ladders,_girders);
			_boss.addEventListener(GameEvents.BOSS_LOST_STAGE,dispatchEvent,false,0,true);
			_boss.addEventListener(GameEvents.GIRL_TELEPORTED,onGirlTeleported,false,0,true);
		}
	}
}
