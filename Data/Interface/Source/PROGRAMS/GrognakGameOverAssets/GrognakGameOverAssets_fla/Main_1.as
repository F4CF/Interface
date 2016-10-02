package GrognakGameOverAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class Main_1 extends MovieClip
	{
		 
		
		public var gameOverMc:MovieClip;
		
		public function Main_1()
		{
			super();
			addFrameScript(0,this.frame1,3,this.frame4);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame4() : *
		{
			stop();
		}
	}
}
