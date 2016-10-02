package bhvr.modules
{
	import bhvr.controller.StageController;
	import bhvr.views.SupportingBlock;
	import bhvr.views.BossStage3;
	import bhvr.events.GameEvents;
	import flash.display.MovieClip;
	import bhvr.debug.Log;
	import bhvr.events.EventWithParams;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.views.MiniBoss;
	import aze.motion.eaze;
	import bhvr.views.Character;
	
	public class Stage3 extends StageController
	{
		 
		
		private var _supportingBlocks:Vector.<SupportingBlock>;
		
		private const SUPPORTING_BLOCKS_NUM:uint = 6;
		
		private var _supportingBlocksRemainingNum:uint;
		
		public function Stage3(assets:MovieClip)
		{
			_laddersNum = 11;
			_girdersNum = 4;
			_helmetsNum = 2;
			_currentStageMusic = SoundList.STAGE_GENERIC_MUSIC_LOOP_SOUND_ID;
			super(assets);
		}
		
		override protected function onUpdate() : void
		{
			super.onUpdate();
			if(_hero != null && _hero.collider != null)
			{
				this.checkCollisionWithSupportingBlocks();
				this.checkCollisionWithMiniBoss();
			}
		}
		
		override protected function createInteractiveObjects() : void
		{
			createHero();
			createHelmets();
			createGirders();
			createLadders();
			this.createSupportingBlocks();
			this.createBoss();
		}
		
		override protected function createBoss() : void
		{
			_boss = new BossStage3(_assets.bossMc,_assets.miniBossContainer,_ladders,_girders,this._supportingBlocks);
			_boss.addEventListener(GameEvents.SPAWN_MINI_BOSS,this.onSpawnRequest,false,0,true);
		}
		
		private function createSupportingBlocks() : void
		{
			var blockMc:MovieClip = null;
			var block:SupportingBlock = null;
			this._supportingBlocks = new Vector.<SupportingBlock>();
			this._supportingBlocksRemainingNum = this.SUPPORTING_BLOCKS_NUM;
			for(var i:uint = 0; i < this.SUPPORTING_BLOCKS_NUM; i++)
			{
				blockMc = _assets["block" + i];
				if(blockMc)
				{
					block = new SupportingBlock(blockMc);
					block.addEventListener(GameEvents.SUPPORTING_BLOCK_REMOVED,this.onSupportingBlockRemoved);
					this._supportingBlocks.push(block);
				}
				else
				{
					Log.warn("SupportingBlock MovieClip named \'block" + i + "\' doesn\'t exist on Flash stage");
				}
			}
		}
		
		private function resetSupportingBlocks() : void
		{
			var block:SupportingBlock = null;
			this._supportingBlocksRemainingNum = this.SUPPORTING_BLOCKS_NUM;
			for(var i:uint = 0; i < this.SUPPORTING_BLOCKS_NUM; i++)
			{
				block = this._supportingBlocks[i];
				if(block.collider == null)
				{
					block.addEventListener(GameEvents.SUPPORTING_BLOCK_REMOVED,this.onSupportingBlockRemoved);
				}
				block.reset();
			}
		}
		
		private function onSupportingBlockRemoved(e:EventWithParams) : void
		{
			var block:SupportingBlock = e.params.target as SupportingBlock;
			block.removeEventListener(GameEvents.SUPPORTING_BLOCK_REMOVED,this.onSupportingBlockRemoved);
			if(this._supportingBlocksRemainingNum == 0)
			{
				_boss.lose();
				this.playFinalAnimation();
				dispatchEvent(new EventWithParams(GameEvents.HERO_WIN));
			}
		}
		
		private function checkCollisionWithSupportingBlocks() : void
		{
			var block:SupportingBlock = null;
			var i:uint = 0;
			if(this._supportingBlocks != null && this._supportingBlocks.length > 0 && this._supportingBlocksRemainingNum > 0)
			{
				for(i = 0; i < this._supportingBlocks.length; i++)
				{
					block = this._supportingBlocks[i];
					if(block.collider && block.collider.hitTestObject(_hero.collider))
					{
						block.unlock();
						this._supportingBlocksRemainingNum--;
						SoundManager.instance.playSound(SoundList.BOLT_ACTIVATE_SOUND);
						if(this._supportingBlocksRemainingNum == 0)
						{
							_hero.win(_girl);
							_boss.stop();
							stopMusic(_currentMusic);
							SoundManager.instance.startSound(SoundList.FINALE_MUSIC_LOOP_SOUND_ID);
						}
						return;
					}
				}
			}
		}
		
		private function checkCollisionWithMiniBoss() : void
		{
			var miniBoss:MiniBoss = null;
			var i:uint = 0;
			var enemies:Vector.<MiniBoss> = BossStage3(_boss).miniBossCollection;
			if(enemies != null && enemies.length > 0)
			{
				for(i = 0; i < enemies.length; i++)
				{
					miniBoss = enemies[i];
					if(miniBoss.collider && miniBoss.collider.hitTestObject(_hero.collider))
					{
						if(!_hero.invincible)
						{
							damageHero();
						}
						else
						{
							miniBoss.explode();
							dispatchEvent(new EventWithParams(GameEvents.MINI_BOSS_BONUS,{"target":miniBoss}));
						}
					}
				}
			}
		}
		
		private function onSpawnRequest(e:EventWithParams) : void
		{
			BossStage3(_boss).spawnMiniBoss(_hero.position);
		}
		
		override protected function onHeroDamaged(e:EventWithParams) : void
		{
			super.onHeroDamaged(e);
			this.resetSupportingBlocks();
		}
		
		private function playFinalAnimation() : void
		{
			_hero.setVisibility(false);
			_girl.visible = false;
			_assets.girlGirderMc.visible = false;
			_assets.girder1.middlePartMc.visible = false;
			_assets.girder2.middlePartMc.visible = false;
			_assets.girder3.middlePartMc.visible = false;
			_assets.ladder1.visible = false;
			_assets.ladder2.visible = false;
			_assets.ladder5.visible = false;
			_assets.ladder8.visible = false;
			_assets.ladder9.visible = false;
			eaze(_assets.finalAnimationMc).play("finalSceneStart>finalSceneEnd").onComplete(this.onFinalAnimationFinished);
		}
		
		private function resetFinalAnimation() : void
		{
			_hero.setVisibility(true);
			_girl.visible = true;
			_assets.girlGirderMc.visible = true;
			_assets.girder1.middlePartMc.visible = true;
			_assets.girder2.middlePartMc.visible = true;
			_assets.girder3.middlePartMc.visible = true;
			_assets.ladder1.visible = true;
			_assets.ladder2.visible = true;
			_assets.ladder5.visible = true;
			_assets.ladder8.visible = true;
			_assets.ladder9.visible = true;
			_assets.finalAnimationMc.gotoAndPlay("init");
		}
		
		private function onFinalAnimationFinished() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.BOSS_LOST_STAGE));
		}
		
		override public function pause() : void
		{
			super.pause();
			if(_boss.state == Character.DEATH_STATE)
			{
				if(_assets.finalAnimationMc.bossHeartMc)
				{
					_assets.finalAnimationMc.bossHeartMc.stop();
				}
				if(_assets.finalAnimationMc.heroHeartMc)
				{
					_assets.finalAnimationMc.heroHeartMc.stop();
				}
			}
		}
		
		override public function resume() : void
		{
			super.resume();
			if(_boss.state == Character.DEATH_STATE)
			{
				if(_assets.finalAnimationMc.bossHeartMc)
				{
					_assets.finalAnimationMc.bossHeartMc.play();
				}
				if(_assets.finalAnimationMc.heroHeartMc)
				{
					_assets.finalAnimationMc.heroHeartMc.play();
				}
			}
		}
		
		override public function dispose() : void
		{
			SoundManager.instance.stopSound(SoundList.FINALE_MUSIC_LOOP_SOUND_ID);
			for(var i:uint = 0; i < this._supportingBlocks.length; i++)
			{
				this._supportingBlocks[i].dispose();
				this._supportingBlocks[i] = null;
			}
			this._supportingBlocks = null;
			this.resetFinalAnimation();
			super.dispose();
		}
	}
}
