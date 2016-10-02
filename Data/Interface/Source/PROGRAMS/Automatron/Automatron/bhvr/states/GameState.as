package bhvr.states
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.debug.Log;
	import flash.utils.getQualifiedClassName;
	import bhvr.events.EventWithParams;
	import aze.motion.EazeTween;
	
	public class GameState extends EventDispatcher
	{
		
		public static const STATE_CREATED:String = "StateCreated";
		
		public static const NAV_CONTINUE:String = "NavContinue";
		
		public static const NAV_BACK:String = "NavBack";
		
		public static const TUTORIAL_REQUESTED:String = "TutorialRequested";
		 
		
		public var BGSCodeObj:Object;
		
		protected var _assets:MovieClip;
		
		protected var _id:int;
		
		public function GameState(param1:int, param2:MovieClip)
		{
			super();
			this._id = param1;
			this._assets = param2;
			this.hide();
		}
		
		public function get id() : int
		{
			return this._id;
		}
		
		public function initialize() : void
		{
			this.onStateCreated();
		}
		
		public function enter(param1:Object = null) : void
		{
			this.show();
		}
		
		public function exit() : void
		{
			this.hide();
		}
		
		protected function show() : void
		{
			if(this._assets)
			{
				this._assets.visible = true;
			}
		}
		
		protected function hide() : void
		{
			if(this._assets)
			{
				this._assets.visible = false;
			}
		}
		
		protected function logInfo(param1:String) : void
		{
			Log.info("[" + getQualifiedClassName(this) + "] " + param1);
		}
		
		protected function logWarning(param1:String) : void
		{
			Log.warn("[" + getQualifiedClassName(this) + "] " + param1);
		}
		
		protected function onStateCreated() : void
		{
			dispatchEvent(new EventWithParams(GameState.STATE_CREATED,{"target":this}));
		}
		
		protected function onNavBack() : void
		{
			dispatchEvent(new EventWithParams(GameState.NAV_BACK,{"target":this}));
		}
		
		protected function onNavContinue() : void
		{
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{"target":this}));
		}
		
		protected function requestTutorialOverlay(param1:String) : void
		{
			dispatchEvent(new EventWithParams(GameState.TUTORIAL_REQUESTED,{"id":param1}));
		}
		
		public function dispose() : void
		{
			this.BGSCodeObj = null;
		}
		
		public function Pause(param1:Boolean) : void
		{
			if(param1)
			{
				EazeTween.pauseAllTweens();
			}
			else
			{
				EazeTween.resumeAllTweens();
			}
		}
	}
}
