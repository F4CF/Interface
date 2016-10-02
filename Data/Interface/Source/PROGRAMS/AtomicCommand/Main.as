package
{
	import flash.display.Sprite;
	import bhvr.interfaces.IExternalCommunication;
	import bhvr.controller.GameController;
	import flash.events.Event;
	import bhvr.debug.Log;
	import Shared.BGSExternalInterface;
	import bhvr.constatnts.GameConfig;
	import bhvr.data.GamePersistantData;
	
	public class Main extends Sprite implements IExternalCommunication
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var IsMiniGame:Boolean = true;
		
		public var UseOwnCursor:Boolean;
		
		private var gameController:GameController;
		
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
		
		public function onCodeObjDestruction() : void
		{
			this.gameController.dispose();
			this.BGSCodeObj = null;
		}
		
		private function init(e:Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,this.init);
			this.gameController = new GameController(stage);
			this.gameController.BGSCodeObj = this.BGSCodeObj;
		}
		
		private function dispose(e:Event) : void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,this.dispose);
			this.gameController.dispose();
		}
		
		public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean) : void
		{
			this.gameController.SetPlatform(auiPlatform,abPS3Switch);
		}
		
		public function ProcessUserEvent(strEventName:String, abPressed:Boolean) : Boolean
		{
			if(this.gameController.inputMgr)
			{
				return this.gameController.inputMgr.ProcessUserEvent(strEventName,abPressed);
			}
			return false;
		}
		
		public function OnLeftStickInput(afXDelta:Number, afYDelta:Number, afDeltaTime:Number = 0.016) : void
		{
			Log.info("OnLeftStickInput: " + afXDelta + ", " + afYDelta + ", " + afDeltaTime);
			if(this.gameController.inputMgr)
			{
				this.gameController.inputMgr.OnLeftStickInput(afXDelta,afYDelta,afDeltaTime);
			}
		}
		
		public function InitProgram() : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"getHighscore",GameConfig.GAME_HIGH_SCORE_KEY);
		}
		
		public function SetHighscore(highscore:int) : void
		{
			GamePersistantData.highScore = highscore;
		}
		
		public function Pause(paused:Boolean) : void
		{
			var pauseStatus:String = !!paused?"Paused":"Resumed";
			Log.info(GameConfig.GAME_NAME + " has been " + pauseStatus + "!");
			this.gameController.Pause(paused);
		}
		
		public function ConfirmQuit() : void
		{
			this.gameController.ConfirmQuit();
		}
	}
}
