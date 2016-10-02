package GenericPauseAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class ResumeMc_4 extends MovieClip
	{
		 
		
		public var counterMc:MovieClip;
		
		public function ResumeMc_4()
		{
			super();
			addFrameScript(9,this.frame10);
		}
		
		function frame10() : *
		{
			stop();
		}
	}
}
