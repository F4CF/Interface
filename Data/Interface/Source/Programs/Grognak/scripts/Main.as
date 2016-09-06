package
{
	import flash.display.Sprite;
	import bhvr.interfaces.IExternalCommunication;
	import bhvr.controller.GameController;
	import flash.events.Event;
	import Shared.BGSExternalInterface;
	import bhvr.constants.GameConfig;
	import bhvr.manager.SaveManager;
	import bhvr.debug.Log;
	
	public class Main extends Sprite implements IExternalCommunication
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var IsMiniGame:Boolean = true;
		
		public var UseOwnCursor:Boolean = false;
		
		private var gameController:GameController;
		
		public function Main()
		{
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
			if(this.gameController)
			{
				this.gameController.dispose();
				this.gameController = null;
			}
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
			if(this.gameController)
			{
				this.gameController.dispose();
				this.gameController = null;
			}
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
		
		public function InitProgram() : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"getHighscore",GameConfig.GAME_HIGH_SCORE_KEY);
			BGSExternalInterface.call(this.BGSCodeObj,"getSaveData",GameConfig.GAME_SAVE_DATA_KEY);
		}
		
		public function SetSaveData(data:String) : void
		{
			if(data != null && data.length > 0)
			{
				SaveManager.instance.SetSaveData(data);
			}
		}
		
		public function SetHighscore(highscore:int) : void
		{
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
