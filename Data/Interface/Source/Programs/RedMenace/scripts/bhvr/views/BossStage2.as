package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.constants.GameConstants;
	import bhvr.events.GameEvents;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import bhvr.utils.FlashUtil;
	import bhvr.data.LevelUpVariables;
	
	public class BossStage2 extends Boss
	{
		 
		
		private const BOSS_KIDNAPPING_POSITION_X:Number = 182;
		
		private var _topLayer:bhvr.views.ConveyorBelt;
		
		private var _bottomLayer:bhvr.views.ConveyorBelt;
		
		private var _leftMidLayer:bhvr.views.ConveyorBelt;
		
		private var _rightMidLayer:bhvr.views.ConveyorBelt;
		
		private var _leftLadder:bhvr.views.ExtendableLadder;
		
		private var _rightLadder:bhvr.views.ExtendableLadder;
		
		private var laughTimerObject:MovieClip;
		
		private var ladderTimerObject:MovieClip;
		
		private var bottomLayerTimerObject:MovieClip;
		
		private var midLayerTimerObject:MovieClip;
		
		private var _bombFreq:Number;
		
		public function BossStage2(assets:MovieClip, bombsContainer:MovieClip, ladders:Vector.<Ladder>, girders:Vector.<Girder>)
		{
			super(assets,bombsContainer,ladders,girders);
			this.extractConveyorBelts();
			this.extractExtendableLadders();
			this.laughTimerObject = new MovieClip();
			this.ladderTimerObject = new MovieClip();
			this.bottomLayerTimerObject = new MovieClip();
			this.midLayerTimerObject = new MovieClip();
			this._bombFreq = LevelUpVariables.getStage2BombFreq();
		}
		
		override public function get activeRollingBombs() : Vector.<RollingBomb>
		{
			return Vector.<RollingBomb>(activeBombs);
		}
		
		public function get midLayerPosY() : Number
		{
			return this._leftMidLayer.getYFromX(0);
		}
		
		override public function reset() : void
		{
			super.reset();
		}
		
		override public function start() : void
		{
			super.start();
			laughWithDuration(LAUGH_DURATION);
			this.startConveyorBelts();
			this.startExtendableLaddersSequence();
			this.startAttackBottomLayerTimer();
			this.startAttackLeftMidLayerTimer();
		}
		
		override public function stop() : void
		{
			super.stop();
			this.stopConveyorBelts();
			this.stopExtendableLadders();
			this.stopSpawningBombs();
		}
		
		override public function update() : void
		{
			var newPosX:Number = NaN;
			var rollingBombs:Vector.<Bomb> = null;
			var bomb:RollingBomb = null;
			var i:uint = 0;
			super.update();
			if(this._topLayer.direction != ConveyorBelt.NO_DIRECTION)
			{
				newPosX = _assets.x + this._topLayer.speed;
				if(newPosX >= GameConstants.STAGE_WIDTH - thickness / 2 || _assets.x + this._topLayer.speed <= thickness / 2)
				{
					this.changeTopLayerDirection();
					laughWithDuration(LAUGH_DURATION);
				}
				setPositionX(newPosX);
				rollingBombs = activeBombs;
				if(rollingBombs != null && rollingBombs.length > 0)
				{
					for(i = 0; i < rollingBombs.length; i++)
					{
						bomb = rollingBombs[i] as RollingBomb;
						if(bomb != null && bomb.collider != null)
						{
							bomb.checkCollisionWithGirder(_girders);
						}
					}
				}
			}
		}
		
		private function extractConveyorBelts() : void
		{
			var conveyorBelt:bhvr.views.ConveyorBelt = null;
			for(var i:uint = 0; i < _girders.length; i++)
			{
				if(_girders[i] is ConveyorBelt)
				{
					conveyorBelt = _girders[i] as ConveyorBelt;
					switch(conveyorBelt.name)
					{
						case "conveyorBelt0":
							this._bottomLayer = conveyorBelt;
							break;
						case "conveyorBelt1":
							this._leftMidLayer = conveyorBelt;
							break;
						case "conveyorBelt2":
							this._rightMidLayer = conveyorBelt;
							break;
						case "conveyorBelt3":
							this._topLayer = conveyorBelt;
					}
				}
			}
		}
		
		private function startConveyorBelts() : void
		{
			this._topLayer.setDirection(ConveyorBelt.DIRECTION_RIGHT);
			this._bottomLayer.setDirection(ConveyorBelt.DIRECTION_LEFT);
			this._leftMidLayer.setDirection(ConveyorBelt.DIRECTION_RIGHT);
			this._rightMidLayer.setDirection(ConveyorBelt.DIRECTION_LEFT);
		}
		
		private function stopConveyorBelts() : void
		{
			this._topLayer.setDirection(ConveyorBelt.NO_DIRECTION);
			this._bottomLayer.setDirection(ConveyorBelt.NO_DIRECTION);
			this._leftMidLayer.setDirection(ConveyorBelt.NO_DIRECTION);
			this._rightMidLayer.setDirection(ConveyorBelt.NO_DIRECTION);
		}
		
		private function changeTopLayerDirection() : void
		{
			this._topLayer.changeDirection();
			this._bottomLayer.changeDirection();
		}
		
		private function extractExtendableLadders() : void
		{
			var ladder:bhvr.views.ExtendableLadder = null;
			for(var i:uint = 0; i < _ladders.length; i++)
			{
				if(_ladders[i] is ExtendableLadder)
				{
					ladder = _ladders[i] as ExtendableLadder;
					switch(ladder.name)
					{
						case "extendableLadder0":
							this._leftLadder = ladder;
							this._leftLadder.addEventListener(GameEvents.LADDER_RETRACTED,this.changeRightLadderState,false,0,true);
							this._leftLadder.addEventListener(GameEvents.LADDER_EXTENDED,this.changeRightLadderState,false,0,true);
							break;
						case "extendableLadder1":
							this._rightLadder = ladder;
							this._rightLadder.addEventListener(GameEvents.LADDER_RETRACTED,this.pauseLadderSequence,false,0,true);
							this._rightLadder.addEventListener(GameEvents.LADDER_EXTENDED,this.pauseLadderSequence,false,0,true);
					}
				}
			}
		}
		
		private function startExtendableLaddersSequence() : void
		{
			eaze(this.ladderTimerObject).delay(GameConstants.stage2InitExtendableLadderDelay).onComplete(this.changeLeftLadderState);
		}
		
		private function changeLeftLadderState() : void
		{
			this._leftLadder.changeState();
		}
		
		private function changeRightLadderState(e:EventWithParams) : void
		{
			this._rightLadder.changeState();
		}
		
		private function pauseLadderSequence(e:EventWithParams) : void
		{
			eaze(this.ladderTimerObject).delay(GameConstants.stage2ExtendableLadderPause).onComplete(this.changeLeftLadderState);
		}
		
		private function stopExtendableLadders() : void
		{
			eaze(this.ladderTimerObject).killTweens();
			this._leftLadder.stopMovement();
			this._rightLadder.stopMovement();
		}
		
		private function startAttackBottomLayerTimer() : void
		{
			eaze(this.bottomLayerTimerObject).delay(this._bombFreq).onComplete(this.spawnBomb,this._bottomLayer,this.startAttackBottomLayerTimer);
		}
		
		private function startAttackLeftMidLayerTimer() : void
		{
			eaze(this.midLayerTimerObject).delay(this._bombFreq / 2).onComplete(this.spawnBomb,this._leftMidLayer,this.startAttackRightMidLayerTimer);
		}
		
		private function startAttackRightMidLayerTimer() : void
		{
			eaze(this.midLayerTimerObject).delay(this._bombFreq / 2).onComplete(this.spawnBomb,this._rightMidLayer,this.startAttackLeftMidLayerTimer);
		}
		
		private function spawnBomb(layer:bhvr.views.ConveyorBelt, callback:Function) : void
		{
			var bombMc:MovieClip = FlashUtil.getLibraryItem(_assets,"BombMc") as MovieClip;
			var bomb:RollingBomb = new RollingBomb(bombMc,LevelUpVariables.getStage2ConveyorSpeed());
			bomb.addEventListener(GameEvents.ROLLING_BOMB_OUT_OF_SCREEN,onRollingBombOutOfScreen,false,0,true);
			bomb.addEventListener(GameEvents.BOMB_EXPLODED,onBombExploded,false,0,true);
			_bombsContainer.addChild(bombMc);
			_activeBombs.push(bomb);
			bombMc.x = layer.direction == ConveyorBelt.DIRECTION_LEFT?Number(GameConstants.STAGE_WIDTH):Number(0);
			bombMc.y = layer.getYFromX(bombMc.x);
			bomb.setDirection(layer.direction == ConveyorBelt.DIRECTION_LEFT?uint(RollingBomb.LEFT_DIRECTION):uint(RollingBomb.RIGHT_DIRECTION));
			callback();
		}
		
		private function stopSpawningBombs() : void
		{
			eaze(this.bottomLayerTimerObject).killTweens();
			eaze(this.midLayerTimerObject).killTweens();
		}
		
		override public function lose() : void
		{
			super.lose();
			setPositionX(this.BOSS_KIDNAPPING_POSITION_X);
		}
	}
}
