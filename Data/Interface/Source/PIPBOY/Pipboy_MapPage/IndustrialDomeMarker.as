package
{
	import flash.display.MovieClip;
	
	public dynamic class IndustrialDomeMarker extends MovieClip
	{
		 
		
		public function IndustrialDomeMarker()
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
