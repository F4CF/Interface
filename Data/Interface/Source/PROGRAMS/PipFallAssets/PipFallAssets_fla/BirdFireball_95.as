package PipFallAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class BirdFireball_95 extends MovieClip
	{
		 
		
		public function BirdFireball_95()
		{
			super();
			addFrameScript(5,this.frame6,15,this.frame16);
		}
		
		function frame6() : *
		{
			gotoAndPlay("loop");
		}
		
		function frame16() : *
		{
			stop();
		}
	}
}
