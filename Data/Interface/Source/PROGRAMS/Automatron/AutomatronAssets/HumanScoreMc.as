package
{
	import flash.display.MovieClip;
	
	public dynamic class HumanScoreMc extends MovieClip
	{
		 
		
		public var scoreAnimMc:MovieClip;
		
		public function HumanScoreMc()
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
