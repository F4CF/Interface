package bhvr.views
{
	import aze.motion.eaze;
	import bhvr.constants.GameConstants;
	import aze.motion.easing.Linear;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import flash.display.MovieClip;
	
	public class ExtendableLadder extends Ladder
	{
		
		public static const RETRACTED_STATE:uint = 0;
		
		public static const EXTENDED_STATE:uint = 1;
		
		public static const RETRACTING_STATE:uint = 2;
		
		public static const EXTENDING_STATE:uint = 3;
		 
		
		private const TOP_VIEW_EXTENDED_POS_Y:Number = -31.55;
		
		private const TOP_VIEW_RETRACTED_POS_Y:Number = 62.65;
		
		private const BOUNDING_BOX_EXTENDED_HEIGHT:Number = 139.4;
		
		private const BOUNDING_BOX_RETRACTED_HEIGHT:Number = 54.6;
		
		private const COLLIDER_EXTENDED_HEIGHT:Number = 180.3;
		
		private const COLLIDER_RETRACTED_HEIGHT:Number = 84.95;
		
		private var _state:uint;
		
		public function ExtendableLadder(assets:MovieClip)
		{
			super(assets);
			this._state = EXTENDED_STATE;
		}
		
		public function get state() : uint
		{
			return this._state;
		}
		
		private function get isAnimating() : Boolean
		{
			return this._state == EXTENDING_STATE || this._state == RETRACTING_STATE;
		}
		
		override public function get topPosition() : Number
		{
			_dimension = getDimensions();
			return _dimension.y - _dimension.height;
		}
		
		override public function get bottomPosition() : Number
		{
			_dimension = getDimensions();
			return _dimension.y;
		}
		
		public function reset() : void
		{
			this.extend(false);
		}
		
		public function changeState() : void
		{
			if(this._state == EXTENDED_STATE || this._state == EXTENDING_STATE)
			{
				this.retract();
			}
			else if(this._state == RETRACTED_STATE || this._state == RETRACTING_STATE)
			{
				this.extend();
			}
		}
		
		public function retract(withAnimation:Boolean = true) : void
		{
			if(this._state != RETRACTED_STATE)
			{
				if(withAnimation)
				{
					eaze(_assets.topLadderMc).to(GameConstants.stage2ExtendableLadderDuration,{"y":this.TOP_VIEW_RETRACTED_POS_Y}).easing(Linear.easeNone);
					eaze(_assets.boundingBoxMc).to(GameConstants.stage2ExtendableLadderDuration,{"height":this.BOUNDING_BOX_RETRACTED_HEIGHT}).easing(Linear.easeNone);
					eaze(_assets.colliderMc).to(GameConstants.stage2ExtendableLadderDuration,{"height":this.COLLIDER_RETRACTED_HEIGHT}).easing(Linear.easeNone).onComplete(this.onLadderRetracted);
					this._state = RETRACTING_STATE;
				}
				else
				{
					this.stopMovement();
					_assets.topLadderMc.y = this.TOP_VIEW_RETRACTED_POS_Y;
					_assets.boundingBoxMc.height = this.BOUNDING_BOX_RETRACTED_HEIGHT;
					_assets.colliderMc.height = this.COLLIDER_RETRACTED_HEIGHT;
					this._state = RETRACTED_STATE;
				}
			}
		}
		
		private function onLadderRetracted() : void
		{
			this._state = RETRACTED_STATE;
			dispatchEvent(new EventWithParams(GameEvents.LADDER_RETRACTED,{"target":this}));
		}
		
		public function extend(withAnimation:Boolean = true) : void
		{
			if(this._state != EXTENDED_STATE)
			{
				if(withAnimation)
				{
					eaze(_assets.topLadderMc).to(GameConstants.stage2ExtendableLadderDuration,{"y":this.TOP_VIEW_EXTENDED_POS_Y}).easing(Linear.easeNone);
					eaze(_assets.boundingBoxMc).to(GameConstants.stage2ExtendableLadderDuration,{"height":this.BOUNDING_BOX_EXTENDED_HEIGHT}).easing(Linear.easeNone);
					eaze(_assets.colliderMc).to(GameConstants.stage2ExtendableLadderDuration,{"height":this.COLLIDER_EXTENDED_HEIGHT}).easing(Linear.easeNone).onComplete(this.onLadderExtended);
					this._state = EXTENDING_STATE;
				}
				else
				{
					this.stopMovement();
					_assets.topLadderMc.y = this.TOP_VIEW_EXTENDED_POS_Y;
					_assets.boundingBoxMc.height = this.BOUNDING_BOX_EXTENDED_HEIGHT;
					_assets.colliderMc.height = this.COLLIDER_EXTENDED_HEIGHT;
					this._state = EXTENDED_STATE;
				}
			}
		}
		
		private function onLadderExtended() : void
		{
			this._state = EXTENDED_STATE;
			dispatchEvent(new EventWithParams(GameEvents.LADDER_EXTENDED,{"target":this}));
		}
		
		public function stopMovement() : void
		{
			if(this.isAnimating)
			{
				this.killAnimations();
			}
		}
		
		private function killAnimations() : void
		{
			eaze(_assets.topLadderMc).killTweens();
			eaze(_assets.boundingBoxMc).killTweens();
			eaze(_assets.colliderMc).killTweens();
		}
	}
}
