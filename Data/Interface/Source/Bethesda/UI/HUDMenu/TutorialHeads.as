package
{
	import flash.display.MovieClip;
	
	public dynamic class TutorialHeads extends MovieClip
	{
		 
		
		public var Head_mc:MovieClip;
		
		public function TutorialHeads()
		{
			super();
			addFrameScript(0,this.frame1,6,this.frame7,13,this.frame14,20,this.frame21);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame7() : *
		{
			stop();
		}
		
		function frame14() : *
		{
			stop();
		}
		
		function frame21() : *
		{
			stop();
		}
	}
}
