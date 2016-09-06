package
{
	import flash.display.Sprite;
	import bhvr.interfaces.IExternalCommunication;
	import bhvr.controller.GameController;
	import flash.events.Event;
	import bhvr.debug.Log;
	import Shared.BGSExternalInterface;
	import bhvr.constants.GameConfig;
	import bhvr.data.GamePersistantData;
	
	public class Main extends Sprite implements IExternalCommunication
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var IsMiniGame:Boolean = true;
		
		public var UseOwnCursor:Boolean;
		
		protected var gameController:GameController;
		
		public function Main()
		{
			this.UseOwnCursor = GameConfig.USING_CURSOR;
			super();
			this.BGSCodeObj = new Object();
			if(stage)
			{
				this.init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,this.init);
			}
			addEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
		}
		
		protected function init(param1:Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,this.init);
			this.createGameController();
		}
		
		protected function createGameController() : void
		{
			this.gameController = new GameController(stage);
			this.gameController.BGSCodeObj = this.BGSCodeObj;
		}
		
		protected function dispose(param1:Event) : void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
			this.gameController.dispose();
		}
		
		public function onCodeObjCreate() : void
		{
		}
		
		public function onCodeObjDestruction() : void
		{
			this.gameController.dispose();
			this.BGSCodeObj = null;
		}
		
		public function SetPlatform(param1:uint, param2:Boolean) : void
		{
			this.gameController.SetPlatform(param1,param2);
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			if(this.gameController.inputMgr)
			{
				return this.gameController.inputMgr.ProcessUserEvent(param1,param2);
			}
			return false;
		}
		
		public function OnLeftStickInput(param1:Number, param2:Number, param3:Number = 0.016) : void
		{
			Log.info("OnLeftStickInput: " + param1 + ", " + param2 + ", " + param3);
			if(this.gameController.inputMgr)
			{
				this.gameController.inputMgr.OnLeftStickInput(param1,param2,param3);
			}
		}
		
		public function OnRightStickInput(param1:Number, param2:Number, param3:Number = 0.016) : void
		{
			Log.info("OnRightStickInput: " + param1 + ", " + param2 + ", " + param3);
			if(this.gameController.inputMgr)
			{
				this.gameController.inputMgr.OnRightStickInput(param1,param2,param3);
			}
		}
		
		public function InitProgram() : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"getHighscore",GameConfig.GAME_HIGH_SCORE_KEY);
		}
		
		public function SetHighscore(param1:int) : void
		{
			if(GamePersistantData["highScore"] != null)
			{
				GamePersistantData["highScore"] = param1;
			}
		}
		
		public function Pause(param1:Boolean) : void
		{
			var _loc2_:String = !!param1?"Paused":"Resumed";
			Log.info(GameConfig.GAME_NAME + " has been " + _loc2_ + "!");
			this.gameController.Pause(param1);
		}
		
		public function ConfirmQuit() : void
		{
			this.gameController.ConfirmQuit();
		}
	}
}
