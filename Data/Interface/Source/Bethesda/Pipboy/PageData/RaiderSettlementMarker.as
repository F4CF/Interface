package
{
	import flash.display.MovieClip;
	
	public dynamic class RaiderSettlementMarker extends MovieClip
	{
		 
		
		public function RaiderSettlementMarker()
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
