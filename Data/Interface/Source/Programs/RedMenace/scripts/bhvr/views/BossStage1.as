package bhvr.views
{
	import aze.motion.eaze;
	import bhvr.constants.GameConstants;
	import flash.display.MovieClip;
	import bhvr.utils.MathUtil;
	import bhvr.utils.FlashUtil;
	import bhvr.data.LevelUpVariables;
	import bhvr.events.GameEvents;
	import flash.geom.Point;
	import aze.motion.easing.Linear;
	
	public class BossStage1 extends Boss
	{
		
		public static const SHOW_BOMBS_STATE:uint = END_STAGE_STATE + 1;
		
		public static const THROWING_BOMB_RIGHT_ARM_STATE:uint = END_STAGE_STATE + 2;
		
		public static const THROWING_BOMB_LEFT_ARM_STATE:uint = END_STAGE_STATE + 3;
		 
		
		private const LEFT_HAND:uint = 0;
		
		private const RIGHT_HAND:uint = 1;
		
		private var _currentLeftBomb:bhvr.views.Bomb;
		
		private var _currentRightBomb:bhvr.views.Bomb;
		
		public function BossStage1(assets:MovieClip, bombsContainer:MovieClip, ladders:Vector.<Ladder>, girders:Vector.<Girder>)
		{
			super(assets,bombsContainer,ladders,girders);
		}
		
		public function get activeFlyingBombs() : Vector.<FlyingBomb>
		{
			if(_activeBombs == null || _activeBombs.length == 0)
			{
				return null;
			}
			var flyingBombs:Vector.<FlyingBomb> = new Vector.<FlyingBomb>();
			for(var i:uint = 0; i < _activeBombs.length; i++)
			{
				if(_activeBombs[i].type == Bomb.FLYING_TYPE)
				{
					flyingBombs.push(_activeBombs[i] as FlyingBomb);
				}
			}
			return flyingBombs;
		}
		
		override public function reset() : void
		{
			super.reset();
			this._currentLeftBomb = null;
			this._currentRightBomb = null;
		}
		
		override public function start() : void
		{
			super.start();
			laugh();
			eaze(attackTimerObject).delay(GameConstants.stage1AttackInitDelay).onComplete(this.onStartAttackSequence);
		}
		
		override public function stop() : void
		{
			var i:uint = 0;
			super.stop();
			if(this.activeFlyingBombs != null)
			{
				for(i = 0; i < this.activeFlyingBombs.length; i++)
				{
					eaze(this.activeFlyingBombs[i]).killTweens();
				}
			}
			if(activeRollingBombs != null)
			{
				for(i = 0; i < activeRollingBombs.length; i++)
				{
					activeRollingBombs[i].stop();
				}
			}
		}
		
		override public function update() : void
		{
			var bomb:RollingBomb = null;
			var i:uint = 0;
			super.update();
			var rollingBombs:Vector.<RollingBomb> = activeRollingBombs;
			if(rollingBombs != null && rollingBombs.length > 0)
			{
				for(i = 0; i < rollingBombs.length; i++)
				{
					bomb = rollingBombs[i];
					if(bomb != null && bomb.collider != null)
					{
						bomb.checkCollisionWithLadder(_ladders);
						bomb.checkCollisionWithGirder(_girders);
					}
				}
			}
		}
		
		private function onStartAttackSequence() : void
		{
			this.setState(SHOW_BOMBS_STATE);
			this.getBombs();
			eaze(attackTimerObject).delay(GameConstants.stage1ShowingBombsDuration).onComplete(this.setState,THROWING_BOMB_LEFT_ARM_STATE);
		}
		
		private function getBombs() : void
		{
			var randomNum:int = 0;
			var bombMc:MovieClip = null;
			var bombType:uint = 0;
			var bomb:bhvr.views.Bomb = null;
			var frameToPlay:String = null;
			for(var i:uint = 0; i < 2; i++)
			{
				randomNum = MathUtil.random(0,100);
				bombMc = FlashUtil.getLibraryItem(_assets,"BombMc") as MovieClip;
				bombType = randomNum < GameConstants.stage1FlyingBombChance * 100?uint(Bomb.FLYING_TYPE):uint(Bomb.ROLLING_TYPE);
				if(bombType == Bomb.FLYING_TYPE)
				{
					bomb = new FlyingBomb(bombMc);
					frameToPlay = "flyingBomb";
				}
				else
				{
					bomb = new RollingBomb(bombMc,LevelUpVariables.getStage1RollingBombSpeed());
					bomb.addEventListener(GameEvents.ROLLING_BOMB_OUT_OF_SCREEN,onRollingBombOutOfScreen,false,0,true);
					frameToPlay = "rollingBomb";
				}
				bomb.addEventListener(GameEvents.BOMB_EXPLODED,onBombExploded,false,0,true);
				if(i == this.LEFT_HAND)
				{
					_assets.leftBombMc.gotoAndPlay(frameToPlay);
					this._currentLeftBomb = bomb;
				}
				else
				{
					_assets.rightBombMc.gotoAndPlay(frameToPlay);
					this._currentRightBomb = bomb;
				}
			}
		}
		
		private function getFlyingBombFinalPosition(hand:uint) : Point
		{
			var min:int = 0;
			var max:int = 0;
			if(hand == this.LEFT_HAND)
			{
				min = 1;
				max = FlyingBomb.FLYING_TRAJECTORY_NUM - 1;
			}
			else
			{
				min = 2;
				max = FlyingBomb.FLYING_TRAJECTORY_NUM;
			}
			var trajectoryNum:int = MathUtil.random(min,max);
			return new Point(GameConstants["stage1FlyingBombEndPosXTraj" + trajectoryNum],GameConstants["stage1FlyingBombEndPosYTraj" + trajectoryNum]);
		}
		
		override protected function setState(state:uint) : void
		{
			if(_state != state)
			{
				switch(state)
				{
					case SHOW_BOMBS_STATE:
						_assets.gotoAndPlay("showBombs");
						break;
					case THROWING_BOMB_RIGHT_ARM_STATE:
						eaze(_assets).play("throwBombRightHandStart>throwBombRightHandEnd").onComplete(this.onRightBombThrown);
						break;
					case THROWING_BOMB_LEFT_ARM_STATE:
						eaze(_assets).play("throwBombLeftHandStart>throwBombLeftHandEnd").onComplete(this.onLeftBombThrown);
				}
			}
			super.setState(state);
		}
		
		private function onRightBombThrown() : void
		{
			var endPoint:Point = null;
			var angle:Number = NaN;
			var duration:Number = NaN;
			var rightBomb:bhvr.views.Bomb = this._currentRightBomb;
			var startPoint:Point = FlashUtil.localToGlobalPosition(_assets.rightBombMc);
			rightBomb.x = startPoint.x;
			rightBomb.y = startPoint.y;
			_bombsContainer.addChild(rightBomb.assets);
			_activeBombs.push(rightBomb);
			if(rightBomb.type == Bomb.FLYING_TYPE)
			{
				endPoint = this.getFlyingBombFinalPosition(this.RIGHT_HAND);
				angle = MathUtil.getVerticalDegAngle(startPoint,endPoint);
				FlyingBomb(rightBomb).rotation = angle;
				duration = MathUtil.getDistance(startPoint,endPoint) / LevelUpVariables.getStage1FlyingBombSpeed();
				eaze(rightBomb).to(duration,{
					"x":endPoint.x,
					"y":endPoint.y
				}).easing(Linear.easeNone).onComplete(this.onBombOutOfScreen,rightBomb);
			}
			laugh();
			eaze(attackTimerObject).delay(LevelUpVariables.getStage1BombFreq()).onComplete(this.onStartAttackSequence);
		}
		
		private function onLeftBombThrown() : void
		{
			var endPoint:Point = null;
			var angle:Number = NaN;
			var duration:Number = NaN;
			var leftBomb:bhvr.views.Bomb = this._currentLeftBomb;
			var startPoint:Point = FlashUtil.localToGlobalPosition(_assets.leftBombMc);
			leftBomb.x = startPoint.x;
			leftBomb.y = startPoint.y;
			_bombsContainer.addChild(leftBomb.assets);
			_activeBombs.push(leftBomb);
			if(leftBomb.type == Bomb.FLYING_TYPE)
			{
				endPoint = this.getFlyingBombFinalPosition(this.LEFT_HAND);
				angle = MathUtil.getVerticalDegAngle(startPoint,endPoint);
				FlyingBomb(leftBomb).rotation = angle;
				duration = MathUtil.getDistance(startPoint,endPoint) / LevelUpVariables.getStage1FlyingBombSpeed();
				eaze(leftBomb).to(duration,{
					"x":endPoint.x,
					"y":endPoint.y
				}).easing(Linear.easeNone).onComplete(this.onBombOutOfScreen,leftBomb);
			}
			eaze(attackTimerObject).delay(GameConstants.stage1DelayBetweenLeftAndRightBombs).onComplete(this.setState,THROWING_BOMB_RIGHT_ARM_STATE);
		}
		
		private function onBombOutOfScreen(bomb:bhvr.views.Bomb) : void
		{
			clearBombReference(bomb);
		}
	}
}
