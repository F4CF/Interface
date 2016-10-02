package bhvr.data
{
	import bhvr.constatnts.GameConstants;
	import bhvr.views.Alien;
	
	public class GameScore
	{
		 
		
		private var _score:int;
		
		public function GameScore()
		{
			super();
			this._score = 0;
		}
		
		public function get score() : int
		{
			return this._score;
		}
		
		private function addPoints(pts:int) : void
		{
			this._score = this._score + pts;
		}
		
		public function addAlienPoints(alienType:String) : void
		{
			var pts:int = 0;
			switch(alienType)
			{
				case Alien.ALIEN_1_TYPE:
					pts = GameConstants.scoreAlien1;
					break;
				case Alien.ALIEN_2_TYPE:
					pts = GameConstants.scoreAlien2;
					break;
				case Alien.ALIEN_UFO_TYPE:
					pts = GameConstants.scoreAlienUFO;
			}
			this.addPoints(pts);
		}
		
		public function addMotherShipPoints() : void
		{
			this.addPoints(GameConstants.scoreMothership);
		}
		
		public function addTractorBeamPoints() : void
		{
			this.addPoints(GameConstants.scoreAlienUFOTractor);
		}
		
		public function removeCowPoints() : void
		{
			this.addPoints(-GameConstants.scoreCow);
		}
	}
}
