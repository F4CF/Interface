package
{
	import flash.display.MovieClip;
	
	public dynamic class GameOverMc extends MovieClip
	{
		 
		
		public var titleMc:MovieClip;
		
		public var highScoreMc:MovieClip;
		
		public var instructionsMc:MovieClip;
		
		public var alienFrameMc:MovieClip;
		
		public function GameOverMc()
		{
			super();
			addFrameScript(19,this.frame20);
		}
		
		function frame20() : *
		{
			stop();
		}
	}
}
