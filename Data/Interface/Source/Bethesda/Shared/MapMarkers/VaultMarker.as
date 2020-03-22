package
{
	import flash.display.MovieClip;
	
	public dynamic class VaultMarker extends MovieClip
	{
		 
		
		public function VaultMarker()
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
