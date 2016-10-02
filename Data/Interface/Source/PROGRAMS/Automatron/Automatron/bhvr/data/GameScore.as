package bhvr.data
{
	import flash.events.EventDispatcher;
	import bhvr.constants.GameConstants;
	import bhvr.events.EventWithParams;
	
	public class GameScore extends EventDispatcher
	{
		
		public static const LIFE_BONUS_APPLIED:String = "LifeBonusApplied";
		 
		
		private var _lifeBonusReceived:uint;
		
		private var _comboNum:uint;
		
		private const MAX_COMBO_NUM:uint = 5;
		
		private var _score:int;
		
		public function GameScore()
		{
			super();
			this._score = 0;
			this._lifeBonusReceived = 0;
			this.resetCombo();
		}
		
		public function get score() : int
		{
			return this._score;
		}
		
		public function resetCombo() : void
		{
			this._comboNum = 0;
		}
		
		public function addPoints(param1:int) : void
		{
			this._score = this._score + param1;
			this.checkLifeBonus();
		}
		
		public function addComboPoints() : int
		{
			this._comboNum = Math.min(this._comboNum + 1,this.MAX_COMBO_NUM);
			var _loc1_:int = this._comboNum * GameConstants.humanPoints;
			this.addPoints(_loc1_);
			return _loc1_;
		}
		
		public function checkLifeBonus() : void
		{
			var _loc1_:int = Math.floor(this._score / GameConstants.heroBonusPointsMilestone) - this._lifeBonusReceived;
			if(_loc1_ > 0)
			{
				GamePersistantData.addLife();
				this._lifeBonusReceived++;
				dispatchEvent(new EventWithParams(LIFE_BONUS_APPLIED));
			}
		}
	}
}
