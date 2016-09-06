package
{
	import flash.display.MovieClip;
	
	public dynamic class MonorailMarker extends MovieClip
	{
		 
		
		public function MonorailMarker()
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
