package bhvr.states
{
	import bhvr.controller.StateController;
	import bhvr.events.GameEvents;
	import bhvr.data.GamePersistantData;
	
	public class GameFlow
	{
		 
		
		public function GameFlow()
		{
			super();
		}
		
		public static function getNextState(param1:int, param2:Object) : int
		{
			var _loc3_:int = StateController.INVALID_STATE;
			switch(param1)
			{
				case GameStateFactory.TITLE:
					_loc3_ = GameStateFactory.INSTRUCTIONS;
					break;
				case GameStateFactory.INSTRUCTIONS:
					_loc3_ = GameStateFactory.LEVEL;
					break;
				case GameStateFactory.LEVEL:
					if(param2.status == GameEvents.GAME_LEVEL_UP)
					{
						_loc3_ = GameStateFactory.LEVEL;
						GamePersistantData.proceedNextLevel();
					}
					else
					{
						_loc3_ = GameStateFactory.GAME_OVER;
					}
					break;
				case GameStateFactory.GAME_OVER:
					GamePersistantData.reset();
					_loc3_ = GameStateFactory.TITLE;
			}
			return _loc3_;
		}
	}
}
