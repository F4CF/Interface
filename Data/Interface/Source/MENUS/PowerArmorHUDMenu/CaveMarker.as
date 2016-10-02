package
{
	import flash.display.MovieClip;
	
	public dynamic class CaveMarker extends MovieClip
	{
		 
		
		public function CaveMarker()
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
