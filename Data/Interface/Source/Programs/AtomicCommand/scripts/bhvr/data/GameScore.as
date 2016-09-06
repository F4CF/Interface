package bhvr.data
{
	import bhvr.constatnts.GameConstants;
	
	public class GameScore
	{
		 
		
		private var _score:int;
		
		private var _missilesBonus:int;
		
		private var _landmarksBonus:int;
		
		public function GameScore()
		{
			super();
			this._score = 0;
			this._missilesBonus = 0;
			this._landmarksBonus = 0;
		}
		
		public function get score() : int
		{
			return this._score;
		}
		
		public function get missilesBonus() : int
		{
			return this._missilesBonus;
		}
		
		public function get landmarksBonus() : int
		{
			return this._landmarksBonus;
		}
		
		public function get multiplier() : int
		{
			return Math.floor((GamePersistantData.level + 1) / GameConstants.levelsPerMultiplier);
		}
		
		private function addPoints(pts:int) : void
		{
			this._score = this._score + pts * this.multiplier;
		}
		
		public function addNukePoints(multiHitNum:int) : void
		{
			var pts:int = 0;
			switch(multiHitNum)
			{
				case 1:
					pts = GameConstants.scoreOneNuke;
					break;
				case 2:
					pts = GameConstants.scoreTwoNuke;
					break;
				case 3:
					pts = GameConstants.scoreThreeNuke;
					break;
				case 4:
					pts = GameConstants.scoreFourNuke;
					break;
				case 5:
				default:
					pts = GameConstants.scoreFiveNuke;
			}
			this.addPoints(pts);
		}
		
		public function addBomberPoints() : void
		{
			this.addPoints(GameConstants.scoreBomber);
		}
		
		public function addMissilesBonusPoints(missilesNum:int) : void
		{
			this._missilesBonus = missilesNum * GameConstants.scoreMissile;
		}
		
		public function addLandmarksBonusPoints(landmarksNum:int) : void
		{
			this._landmarksBonus = landmarksNum * GameConstants.scoreLandmark;
		}
		
		public function transferMissilesBonusToScore() : void
		{
			this.addPoints(this._missilesBonus);
		}
		
		public function transferLandmarksBonusToScore() : void
		{
			this.addPoints(this._landmarksBonus);
		}
	}
}
