package bhvr.modules
{
	import bhvr.controller.StageController;
	import bhvr.views.StockpileBombs;
	import bhvr.views.BossStage2;
	import bhvr.events.GameEvents;
	import flash.display.MovieClip;
	import bhvr.views.ConveyorBelt;
	import bhvr.debug.Log;
	import bhvr.views.ExtendableLadder;
	import bhvr.views.RollingBomb;
	import bhvr.data.SoundList;
	
	public class Stage2 extends StageController
	{
		 
		
		private var _conveyorBeltsNum:uint;
		
		private var _extendableLaddersNum:uint;
		
		private var _stockpileBombs:StockpileBombs;
		
		public function Stage2(assets:MovieClip)
		{
			_laddersNum = 6;
			_girdersNum = 1;
			this._conveyorBeltsNum = 4;
			this._extendableLaddersNum = 2;
			_currentStageMusic = SoundList.STAGE_2_MUSIC_LOOP_SOUND_ID;
			super(assets);
		}
		
		override protected function onUpdate() : void
		{
			super.onUpdate();
			if(_hero != null && _hero.collider != null)
			{
				this.checkCollisionWithStockpileBombs();
			}
			if(this._stockpileBombs != null && this._stockpileBombs.bombCollider)
			{
				this.checkCollisionBetweenBombsAndStockpile();
			}
		}
		
		override protected function createInteractiveObjects() : void
		{
			createWinStageZone();
			createHero();
			createHelmets();
			createGirders();
			createLadders();
			this.createConveyorBelts();
			this.createExtendableLadders();
			this.createStockpileBombs();
			this.createBoss();
		}
		
		override protected function createBoss() : void
		{
			_boss = new BossStage2(_assets.bossMc,_assets.bombsContainerMc,_ladders,_girders);
			_boss.addEventListener(GameEvents.BOSS_LOST_STAGE,dispatchEvent,false,0,true);
			_boss.addEventListener(GameEvents.GIRL_TELEPORTED,onGirlTeleported,false,0,true);
		}
		
		private function createConveyorBelts() : void
		{
			var conveyorBeltMc:MovieClip = null;
			var conveyorBelt:ConveyorBelt = null;
			for(var i:uint = 0; i < this._conveyorBeltsNum; i++)
			{
				conveyorBeltMc = _assets["conveyorBelt" + i];
				if(conveyorBeltMc)
				{
					conveyorBelt = new ConveyorBelt(conveyorBeltMc);
					_girders.push(conveyorBelt);
				}
				else
				{
					Log.warn("Conveyor Belt MovieClip named \'conveyorBelt" + i + "\' doesn\'t exist on Flash stage");
				}
			}
		}
		
		private function createExtendableLadders() : void
		{
			var extendableLadderMc:MovieClip = null;
			var extendableLadder:ExtendableLadder = null;
			for(var i:uint = 0; i < this._extendableLaddersNum; i++)
			{
				extendableLadderMc = _assets["extendableLadder" + i];
				if(extendableLadderMc)
				{
					extendableLadder = new ExtendableLadder(extendableLadderMc);
					_ladders.push(extendableLadder);
				}
				else
				{
					Log.warn("Extendable Ladder MovieClip named \'extendableLadder" + i + "\' doesn\'t exist on Flash stage");
				}
			}
		}
		
		private function createStockpileBombs() : void
		{
			this._stockpileBombs = new StockpileBombs(_assets.stockpileBombsMc);
		}
		
		private function checkCollisionWithStockpileBombs() : void
		{
			if(this._stockpileBombs != null && this._stockpileBombs.collider != null)
			{
				if(this._stockpileBombs.collider.hitTestObject(_hero.collider))
				{
					if(!_hero.invincible)
					{
						damageHero();
					}
				}
			}
		}
		
		private function checkCollisionBetweenBombsAndStockpile() : void
		{
			var bomb:RollingBomb = null;
			var i:uint = 0;
			var rollingBombs:Vector.<RollingBomb> = _boss.activeRollingBombs;
			if(rollingBombs != null && rollingBombs.length > 0)
			{
				for(i = 0; i < rollingBombs.length; i++)
				{
					bomb = rollingBombs[i];
					if(bomb.y <= BossStage2(_boss).midLayerPosY)
					{
						if(bomb.collider && bomb.collider.hitTestObject(this._stockpileBombs.bombCollider))
						{
							_boss.explodeBomb(bomb);
						}
					}
				}
			}
		}
		
		override public function pause() : void
		{
			super.pause();
			this._stockpileBombs.pause();
		}
		
		override public function resume() : void
		{
			super.resume();
			this._stockpileBombs.resume();
		}
	}
}
