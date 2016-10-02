package PipFallAssets_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class RadiationCloudViewMc_132 extends MovieClip
	{
		 
		
		public function RadiationCloudViewMc_132()
		{
			super();
			addFrameScript(0,this.frame1,1,this.frame2,64,this.frame65,85,this.frame86,140,this.frame141);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame2() : *
		{
			dispatchEvent(new Event("SmokeEject",true,true));
		}
		
		function frame65() : *
		{
			dispatchEvent(new Event("SmokeEject",true,true));
		}
		
		function frame86() : *
		{
			dispatchEvent(new Event("SmokeEject",true,true));
		}
		
		function frame141() : *
		{
			stop();
		}
	}
}
