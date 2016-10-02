package
{
	import flash.display.MovieClip;
	
	public dynamic class SewerMarker extends MovieClip
	{
		 
		
		public function SewerMarker()
		{
			super();
			addFrameScript(0,this.frame1,1,this.frame2);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame2() : *
		{
			stop();
		}
	}
}
