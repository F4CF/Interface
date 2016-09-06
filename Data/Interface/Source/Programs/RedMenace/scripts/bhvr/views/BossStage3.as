package bhvr.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import aze.motion.eaze;
	import bhvr.constants.GameConstants;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import bhvr.utils.MathUtil;
	import bhvr.utils.FlashUtil;
	import bhvr.data.LevelUpVariables;
	
	public class BossStage3 extends Boss
	{
		 
		
		private var _supportingBlocks:Vector.<bhvr.views.SupportingBlock>;
		
		private var _spawnTimerObject:MovieClip;
		
		private var _miniBossCollection:Vector.<bhvr.views.MiniBoss>;
		
		private var _spawnFreq:Number;
		
		private const TOP_LAYER_LEFT_SPAWN_POINT:Point = new Point(100,400);
		
		private const TOP_LAYER_RIGHT_SPAWN_POINT:Point = new Point(726,400);
		
		private const MID_LAYER_LEFT_SPAWN_POINT:Point = new Point(53,534);
		
		private const MID_LAYER_RIGHT_SPAWN_POINT:Point = new Point(773,534);
		
		private const BOTTOM_LAYER_LEFT_SPAWN_POINT:Point = new Point(36,668);
		
		private const BOTTOM_LAYER_RIGHT_SPAWN_POINT:Point = new Point(788,668);
		
		private var _leftSpawnPoints:Vector.<Point>;
		
		private var _rightSpawnPoints:Vector.<Point>;
		
		public function BossStage3(assets:MovieClip, bombsContainer:MovieClip, ladders:Vector.<Ladder>, girders:Vector.<Girder>, blocks:Vector.<bhvr.views.SupportingBlock>)
		{
			super(assets,bombsContainer,ladders,girders);
			this._supportingBlocks = blocks;
			_laughTimerObject = new MovieClip();
			this._spawnTimerObject = new MovieClip();
			this._spawnFreq = LevelUpVariables.getStage3SpawnFreq();
			this._leftSpawnPoints = new <Point>[this.TOP_LAYER_LEFT_SPAWN_POINT,this.MID_LAYER_LEFT_SPAWN_POINT,this.BOTTOM_LAYER_LEFT_SPAWN_POINT];
			this._rightSpawnPoints = new <Point>[this.TOP_LAYER_RIGHT_SPAWN_POINT,this.MID_LAYER_RIGHT_SPAWN_POINT,this.BOTTOM_LAYER_RIGHT_SPAWN_POINT];
		}
		
		public function get miniBossCollection() : Vector.<bhvr.views.MiniBoss>
		{
			return this._miniBossCollection;
		}
		
		override public function reset() : void
		{
			var miniBoss:bhvr.views.MiniBoss = null;
			super.reset();
			if(this._miniBossCollection != null)
			{
				while(this._miniBossCollection.length > 0)
				{
					miniBoss = this._miniBossCollection[length - 1];
					this.clearMiniBossReference(miniBoss);
				}
			}
			this._miniBossCollection = new Vector.<MiniBoss>();
		}
		
		override public function start() : void
		{
			super.start();
			this.startMiniBossSpawnTimer();
		}
		
		override public function stop() : void
		{
			var i:uint = 0;
			super.stop();
			eaze(this._spawnTimerObject).killTweens();
			if(this._miniBossCollection != null)
			{
				for(i = 0; i < this._miniBossCollection.length; i++)
				{
					this._miniBossCollection[i].stop();
				}
			}
		}
		
		override public function update() : void
		{
			var miniBoss:bhvr.views.MiniBoss = null;
			var i:uint = 0;
			super.update();
			if(this._miniBossCollection != null)
			{
				for(i = 0; i < this._miniBossCollection.length; i++)
				{
					miniBoss = this._miniBossCollection[i];
					miniBoss.update();
					if(miniBoss.collider)
					{
						miniBoss.checkCollisionWithLadders(_ladders);
						miniBoss.checkCollisionWithGirders(_girders);
						miniBoss.checkCollisionWithSupportingBlocks(this._supportingBlocks);
					}
				}
			}
		}
		
		private function startMiniBossSpawnTimer() : void
		{
			eaze(this._spawnTimerObject).delay(this._spawnFreq).onComplete(this.readyToSpawn);
		}
		
		private function readyToSpawn() : void
		{
			if(this._miniBossCollection.length < GameConstants.miniBossMax)
			{
				laughWithDuration(LAUGH_DURATION);
				dispatchEvent(new EventWithParams(GameEvents.SPAWN_MINI_BOSS));
			}
		}
		
		public function spawnMiniBoss(heroPosisiton:Point) : void
		{
			var spawnPoint:Point = null;
			var randomValue:int = MathUtil.random(0,100);
			var totalWeight:Number = GameConstants.miniBossTopLayerSpawnWeight + GameConstants.miniBossMidLayerSpawnWeight + GameConstants.miniBossBottomLayerSpawnWeight;
			var topLayerPercent:Number = GameConstants.miniBossTopLayerSpawnWeight / totalWeight * 100;
			var midLayerPercent:Number = topLayerPercent + GameConstants.miniBossMidLayerSpawnWeight / totalWeight * 100;
			var spawnPoints:Vector.<Point> = heroPosisiton.x < GameConstants.STAGE_WIDTH / 2?this._rightSpawnPoints:this._leftSpawnPoints;
			if(randomValue <= topLayerPercent)
			{
				spawnPoint = spawnPoints[0];
			}
			else if(randomValue <= midLayerPercent)
			{
				spawnPoint = spawnPoints[1];
			}
			else
			{
				spawnPoint = spawnPoints[2];
			}
			var miniBossMc:MovieClip = FlashUtil.getLibraryItem(_assets,"miniBossMc") as MovieClip;
			var miniBoss:bhvr.views.MiniBoss = new bhvr.views.MiniBoss(miniBossMc);
			miniBoss.addEventListener(GameEvents.MINI_BOSS_DEAD,this.onMiniBossDead,false,0,true);
			this._miniBossCollection.push(miniBoss);
			_bombsContainer.addChild(miniBossMc);
			miniBoss.setPosition(spawnPoint.x,spawnPoint.y);
			miniBoss.start();
			this.startMiniBossSpawnTimer();
		}
		
		override public function lose() : void
		{
			this.stop();
			this.reset();
			setState(DEATH_STATE);
		}
		
		protected function onMiniBossDead(e:EventWithParams) : void
		{
			var target:bhvr.views.MiniBoss = e.params.target as MiniBoss;
			target.removeEventListener(GameEvents.MINI_BOSS_DEAD,this.onMiniBossDead);
			this.clearMiniBossReference(target);
		}
		
		protected function clearMiniBossReference(miniBoss:bhvr.views.MiniBoss) : void
		{
			_bombsContainer.removeChild(miniBoss.assets);
			this.removeMiniBoss(miniBoss);
			miniBoss.dispose();
			miniBoss = null;
		}
		
		protected function removeMiniBoss(miniBoss:bhvr.views.MiniBoss) : void
		{
			for(var i:uint = 0; i < this._miniBossCollection.length; i++)
			{
				if(this._miniBossCollection[i] == miniBoss)
				{
					this._miniBossCollection.splice(i,1);
					return;
				}
			}
		}
		
		override public function pause() : void
		{
			var i:uint = 0;
			super.pause();
			for(i = 0; i < this._supportingBlocks.length; i++)
			{
				this._supportingBlocks[i].pause();
			}
			for(i = 0; i < this._miniBossCollection.length; i++)
			{
				this._miniBossCollection[i].pause();
			}
		}
		
		override public function resume() : void
		{
			var i:uint = 0;
			super.resume();
			for(i = 0; i < this._supportingBlocks.length; i++)
			{
				this._supportingBlocks[i].resume();
			}
			for(i = 0; i < this._miniBossCollection.length; i++)
			{
				this._miniBossCollection[i].resume();
			}
		}
	}
}
