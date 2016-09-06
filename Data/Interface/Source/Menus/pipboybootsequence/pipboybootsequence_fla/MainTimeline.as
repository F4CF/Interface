package pipboybootsequence_fla
{
	import flash.display.MovieClip;
	
	public dynamic class MainTimeline extends MovieClip
	{
		 
		
		public var BGSCodeObj:Object;
		
		public function MainTimeline()
		{
			super();
			addFrameScript(0,this.frame1);
		}
		
		function frame1() : *
		{
			this.BGSCodeObj = new Object();
		}
	}
}
