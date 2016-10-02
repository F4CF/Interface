package bhvr.views
{
	import flash.geom.Point;
	import flash.display.MovieClip;
	import bhvr.events.GameEvents;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	
	public class Boss extends Character
	{
		
		public static const LAUGHING_STATE:uint = DEATH_STATE + 1;
		
		public static const END_STAGE_STATE:uint = DEATH_STATE + 2;
		 
		
		protected const LAUGH_DURATION:Number = 1.0;
		
		protected var _initialPosition:Point;
		
		protected var attackTimerObject:MovieClip;
		
		protected var _laughTimerObject:MovieClip;
		
		protected var _bombsContainer:MovieClip;
		
		protected var _ladders:Vector.<bhvr.views.Ladder>;
		
		protected var _girders:Vector.<bhvr.views.Girder>;
		
		protected var _activeBombs:Vector.<bhvr.views.Bomb>;
		
		public function Boss(assets:MovieClip, bombsContainer:MovieClip, ladders:Vector.<bhvr.views.Ladder>, girders:Vector.<bhvr.views.Girder>)
		{
			this._initialPosition = new Point(assets.x,assets.y);
			super(assets);
			this._bombsContainer = bombsContainer;
			this._ladders = ladders;
			this._girders = girders;
			this.attackTimerObject = new MovieClip();
			this._laughTimerObject = new MovieClip();
		}
		
		public function get activeBombs() : Vector.<bhvr.views.Bomb>
		{
			return this._activeBombs;
		}
		
		public function get activeRollingBombs() : Vector.<RollingBomb>
		{
			if(this._activeBombs == null || this._activeBombs.length == 0)
			{
				return null;
			}
			var rollingBombs:Vector.<RollingBomb> = new Vector.<RollingBomb>();
			for(var i:uint = 0; i < this._activeBombs.length; i++)
			{
				if(this._activeBombs[i].type == Bomb.ROLLING_TYPE)
				{
					rollingBombs.push(this._activeBombs[i] as RollingBomb);
				}
			}
			return rollingBombs;
		}
		
		override public function reset() : void
		{
			var bomb:bhvr.views.Bomb = null;
			super.reset();
			_collider = _assets;
			_canRun = false;
			_canJump = false;
			canClimb = false;
			if(this._activeBombs != null)
			{
				while(this._activeBombs.length > 0)
				{
					bomb = this._activeBombs[length - 1];
					if(bomb.type == Bomb.ROLLING_TYPE)
					{
						bomb.removeEventListener(GameEvents.ROLLING_BOMB_OUT_OF_SCREEN,this.onRollingBombOutOfScreen);
					}
					bomb.removeEventListener(GameEvents.BOMB_EXPLODED,this.onBombExploded);
					this.clearBombReference(bomb);
				}
			}
			this._activeBombs = new Vector.<Bomb>();
			_assets.x = this._initialPosition.x;
			_assets.y = this._initialPosition.y;
		}
		
		override public function start() : void
		{
			this.reset();
		}
		
		override public function stop() : void
		{
			eaze(this.attackTimerObject).killTweens();
			eaze(_assets).killTweens();
			this.laugh();
		}
		
		public function update() : void
		{
		}
		
		protected function laugh() : void
		{
			this.setState(LAUGHING_STATE);
		}
		
		protected function laughWithDuration(duration:Number) : void
		{
			this.laugh();
			eaze(this._laughTimerObject).delay(duration).onComplete(this.setState,STANDING_STATE);
		}
		
		public function lose() : void
		{
			this.stop();
			this.reset();
			this.setState(END_STAGE_STATE);
			_assets.addEventListener("KidnapGirl",this.onGirlTeleport,false,0,true);
		}
		
		override protected function setState(state:uint) : void
		{
			if(_state != state)
			{
				switch(state)
				{
					case STANDING_STATE:
						_assets.gotoAndPlay("idle");
						break;
					case DEATH_STATE:
						setVisibility(false);
						break;
					case LAUGHING_STATE:
						_assets.gotoAndPlay("laugh");
						break;
					case END_STAGE_STATE:
						eaze(_assets).play("endStageStart>endStageEnd").onComplete(this.onStageEnd);
				}
				_state = state;
			}
		}
		
		protected function onRollingBombOutOfScreen(e:EventWithParams) : void
		{
			var target:bhvr.views.Bomb = e.params.target;
			target.removeEventListener(GameEvents.ROLLING_BOMB_OUT_OF_SCREEN,this.onRollingBombOutOfScreen);
			this.clearBombReference(target);
		}
		
		protected function onBombExploded(e:EventWithParams) : void
		{
			var target:bhvr.views.Bomb = e.params.target;
			target.removeEventListener(GameEvents.BOMB_EXPLODED,this.onBombExploded);
			this.clearBombReference(target);
		}
		
		protected function clearBombReference(bomb:bhvr.views.Bomb) : void
		{
			this._bombsContainer.removeChild(bomb.assets);
			this.removeActiveBomb(bomb);
			bomb.dispose();
			bomb = null;
		}
		
		protected function removeActiveBomb(bomb:bhvr.views.Bomb) : void
		{
			for(var i:uint = 0; i < this._activeBombs.length; i++)
			{
				if(this._activeBombs[i] == bomb)
				{
					this._activeBombs.splice(i,1);
					return;
				}
			}
		}
		
		public function explodeBomb(bomb:bhvr.views.Bomb) : void
		{
			bomb.explode();
			if(bomb.type == Bomb.FLYING_TYPE)
			{
				eaze(bomb).killTweens();
			}
		}
		
		protected function onGirlTeleport() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.GIRL_TELEPORTED));
		}
		
		protected function onStageEnd() : void
		{
			_assets.removeEventListener("KidnapGirl",this.onGirlTeleport);
			dispatchEvent(new EventWithParams(GameEvents.BOSS_LOST_STAGE));
		}
		
		override public function dispose() : void
		{
			this.stop();
			this.reset();
		}
		
		override public function pause() : void
		{
			var i:uint = 0;
			super.pause();
			if(this._activeBombs != null)
			{
				for(i = 0; i < this._activeBombs.length; i++)
				{
					this._activeBombs[i].pause();
				}
			}
			if(_state == LAUGHING_STATE)
			{
				_assets.stop();
			}
			else if(_state == END_STAGE_STATE)
			{
				if(_assets.bossClimbMc)
				{
					_assets.bossClimbMc.stop();
				}
			}
		}
		
		override public function resume() : void
		{
			var i:uint = 0;
			super.resume();
			if(this._activeBombs != null)
			{
				for(i = 0; i < this._activeBombs.length; i++)
				{
					this._activeBombs[i].resume();
				}
			}
			if(_state == LAUGHING_STATE)
			{
				_assets.play();
			}
			else if(_state == END_STAGE_STATE)
			{
				if(_assets.bossClimbMc)
				{
					_assets.bossClimbMc.play();
				}
			}
		}
	}
}
