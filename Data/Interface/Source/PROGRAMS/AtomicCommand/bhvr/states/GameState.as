package bhvr.states
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.manager.InputManager;
	import bhvr.constatnts.GameInputs;
	import bhvr.events.EventWithParams;
	
	public class GameState extends EventDispatcher
	{
		
		public static const STATE_CREATED:String = "StateCreated";
		
		public static const NAV_CONTINUE:String = "NavContinue";
		
		public static const NAV_BACK:String = "NavBack";
		
		public static const TUTORIAL_REQUESTED:String = "TutorialRequested";
		 
		
		public var BGSCodeObj:Object;
		
		protected var _assets:MovieClip;
		
		protected var _id:int;
		
		public function GameState(id:int, assets:MovieClip)
		{
			super();
			this._id = id;
			this._assets = assets;
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
		
		public function enter() : void
		{
			if(this.BGSCodeObj && this.BGSCodeObj.playActionAnim)
			{
				InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onPushAction);
			}
			this.show();
		}
		
		public function exit() : void
		{
			this.hide();
			if(this.BGSCodeObj && this.BGSCodeObj.playActionAnim)
			{
				InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onPushAction);
			}
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
		
		protected function requestTutorialOverlay(id:String) : void
		{
			dispatchEvent(new EventWithParams(GameState.TUTORIAL_REQUESTED,{"id":id}));
		}
		
		public function dispose() : void
		{
			this.BGSCodeObj = null;
		}
		
		private function onPushAction() : void
		{
			this.BGSCodeObj.playActionAnim();
		}
		
		public function Pause(paused:Boolean) : void
		{
		}
	}
}
