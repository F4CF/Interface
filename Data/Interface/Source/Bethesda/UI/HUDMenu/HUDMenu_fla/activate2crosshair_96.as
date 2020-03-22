package HUDMenu_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class activate2crosshair_96 extends MovieClip
	{
		 
		
		public var Down:MovieClip;
		
		public var Left:MovieClip;
		
		public var Right:MovieClip;
		
		public var Up:MovieClip;
		
		public function activate2crosshair_96()
		{
			super();
			addFrameScript(0,this.frame1,11,this.frame12);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame12() : *
		{
			dispatchEvent(new Event("animationComplete"));
		}
	}
}
