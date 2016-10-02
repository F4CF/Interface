package
{
	import flash.display.MovieClip;
	
	public dynamic class EnemyScoreMc extends MovieClip
	{
		 
		
		public var scoreAnimMc:MovieClip;
		
		public function EnemyScoreMc()
		{
			super();
			addFrameScript(0,this.frame1);
		}
		
		function frame1() : *
		{
			stop();
		}
	}
}
