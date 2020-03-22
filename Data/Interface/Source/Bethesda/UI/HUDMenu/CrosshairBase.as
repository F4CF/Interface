package
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class CrosshairBase extends BSUIComponent
	{
		
		public static const DEFAULT_TICK_RADIUS:Number = 19;
		
		public static const EXPANSION_ACCELERATION:Number = 10;
		
		public static const COLLAPSE_BASE_VELOCITY:Number = 10;
		
		public static const COLLAPSE_FRAME_DELAY:uint = 5;
		
		public static const STATE_NONE:String = "None";
		
		public static const STATE_DOT:String = "Dot";
		
		public static const STATE_STANDARD:String = "Standard";
		
		public static const STATE_ACTIVATE:String = "Activate";
		
		public static const STATE_COMMAND:String = "Command";
		
		public static const CLIPNAME_STANDARD_STANDARD:String = "Standard_Standard";
		
		public static const ANIMATION_COMPLETE:String = "animationComplete";
		 
		
		public var CrosshairTicks_mc:MovieClip;
		
		public var CrosshairClips_mc:MovieClip;
		
		private var _currentState:String = "None";
		
		private var _requestedState:String = "None";
		
		private var _currentAnimStart:String;
		
		private var _currentAnimFinish:String;
		
		private var _currentRadius:Number = 0;
		
		private var _requestedRadius:Number = 0;
		
		private var _activeClip:MovieClip;
		
		private var _activeClipName:String;
		
		private var _collapsingCrosshair:Boolean = false;
		
		private var _expandingCrosshair:Boolean = false;
		
		private var _collapseCountdown:uint = 0;
		
		private var _expandVelocity:Number = 0;
		
		public function CrosshairBase()
		{
			super();
			this._currentAnimStart = new String();
			this._currentAnimFinish = new String();
			this._activeClip = null;
			this._activeClipName = new String();
			this.startNextClip();
		}
		
		public function set requestedState(param1:String) : void
		{
			this._requestedState = param1;
			SetIsDirty();
		}
		
		public function set requestedRadius(param1:Number) : void
		{
			this._requestedRadius = param1;
			SetIsDirty();
		}
		
		private function onAnimationComplete(param1:Event) : *
		{
			this._currentState = this._currentAnimFinish;
			this.startNextClip();
		}
		
		private function startNextClip() : *
		{
			var _loc3_:* = false;
			this._currentAnimStart = this._currentState;
			this._currentAnimFinish = this._requestedState;
			this._activeClipName = this._currentState + "_" + this._requestedState;
			var _loc1_:MovieClip = this.CrosshairClips_mc[this._activeClipName] as MovieClip;
			var _loc2_:Boolean = this._activeClip && this._activeClip != _loc1_;
			if(_loc2_)
			{
				this._activeClip.removeEventListener(ANIMATION_COMPLETE,this.onAnimationComplete);
				this._activeClip.visible = false;
			}
			if(this._activeClipName == CLIPNAME_STANDARD_STANDARD)
			{
				this.BeginExpandingTicks(DEFAULT_TICK_RADIUS);
			}
			else
			{
				_loc3_ = this._activeClip != _loc1_;
				if(_loc3_)
				{
					this._activeClip = _loc1_;
					this._activeClip.addEventListener(ANIMATION_COMPLETE,this.onAnimationComplete);
					this._activeClip.visible = true;
				}
				this._activeClip.gotoAndPlay(2);
			}
		}
		
		private function repositionCrosshairTicks(param1:Number) : void
		{
			this.CrosshairTicks_mc.Up.y = -param1;
			this.CrosshairTicks_mc.Down.y = param1;
			this.CrosshairTicks_mc.Left.x = -param1;
			this.CrosshairTicks_mc.Right.x = param1;
		}
		
		private function BeginExpandingTicks(param1:Number) : void
		{
			this.CrosshairTicks_mc.visible = true;
			this.CrosshairClips_mc.visible = false;
			this._currentRadius = param1;
			this._expandingCrosshair = true;
			this._collapsingCrosshair = false;
			this._expandVelocity = 0;
			this._collapseCountdown = 0;
			SetIsDirty();
		}
		
		private function EndExpandingTicks() : void
		{
			this.CrosshairTicks_mc.visible = true;
			this.CrosshairClips_mc.visible = false;
			this._currentRadius = this._requestedRadius;
			this._collapsingCrosshair = false;
			this._expandingCrosshair = false;
			this._expandVelocity = 0;
			this._collapseCountdown = 0;
		}
		
		private function BeginCollapsingTicks() : void
		{
			this.CrosshairTicks_mc.visible = true;
			this.CrosshairClips_mc.visible = false;
			this._expandingCrosshair = false;
			this._collapsingCrosshair = true;
			this._expandVelocity = 0;
			this._collapseCountdown = 0;
			SetIsDirty();
		}
		
		private function EndCollapsingTicks() : void
		{
			this.CrosshairTicks_mc.visible = false;
			this.CrosshairClips_mc.visible = true;
			this._currentRadius = DEFAULT_TICK_RADIUS;
			this._expandingCrosshair = false;
			this._collapsingCrosshair = false;
			this._expandVelocity = 0;
			this._collapseCountdown = 0;
			this.startNextClip();
		}
		
		private function PerformCountdownToCollapse() : void
		{
			if(this._collapseCountdown == 0)
			{
				this._collapseCountdown = COLLAPSE_FRAME_DELAY;
				SetIsDirty();
			}
			else
			{
				this._collapseCountdown--;
				if(this._collapseCountdown == 0)
				{
					this.BeginCollapsingTicks();
				}
				else
				{
					SetIsDirty();
				}
			}
		}
		
		private function PerformTickExpansion() : void
		{
			this._expandVelocity = this._expandVelocity + EXPANSION_ACCELERATION;
			this._currentRadius = this._currentRadius + this._expandVelocity;
			if(this._currentRadius >= this._requestedRadius)
			{
				this.EndExpandingTicks();
			}
			else
			{
				SetIsDirty();
			}
		}
		
		private function PerformTickCollapse() : void
		{
			this._currentRadius = this._currentRadius - (EXPANSION_ACCELERATION + (this._currentRadius - DEFAULT_TICK_RADIUS) / 2);
			if(this._currentRadius <= DEFAULT_TICK_RADIUS)
			{
				this.EndCollapsingTicks();
			}
			else
			{
				SetIsDirty();
			}
		}
		
		override public function redrawUIComponent() : void
		{
			if(this._activeClipName == CLIPNAME_STANDARD_STANDARD)
			{
				if(this._requestedState != STATE_STANDARD)
				{
					if(!this._collapsingCrosshair)
					{
						if(this._requestedState == STATE_ACTIVATE)
						{
							this.PerformCountdownToCollapse();
						}
						else
						{
							this.BeginCollapsingTicks();
						}
					}
				}
				else if(this._collapsingCrosshair)
				{
					this.BeginExpandingTicks(this._currentRadius);
				}
				if(this._collapsingCrosshair)
				{
					this.PerformTickCollapse();
				}
				else if(this._expandingCrosshair)
				{
					this.PerformTickExpansion();
				}
				else if(this._currentRadius != this._requestedRadius)
				{
					this._currentRadius = this._requestedRadius;
					if(this._currentRadius < DEFAULT_TICK_RADIUS)
					{
						this._currentRadius = DEFAULT_TICK_RADIUS;
					}
				}
				this.repositionCrosshairTicks(this._currentRadius);
			}
		}
	}
}
