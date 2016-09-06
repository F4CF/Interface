package PipFallAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class TimerMc_30 extends MovieClip
	{
		 
		
		public var timerAnimMc:MovieClip;
		
		public function TimerMc_30()
		{
			super();
			addFrameScript(8,this.frame9,29,this.frame30);
		}
		
		function frame9() : *
		{
			stop();
		}
		
		function frame30() : *
		{
			gotoAndPlay("warning");
		}
	}
}
