package HUDMenu_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class command2activate_92 extends MovieClip
	{
		 
		
		public var Down:MovieClip;
		
		public var Left:MovieClip;
		
		public var Right:MovieClip;
		
		public var Up:MovieClip;
		
		public function command2activate_92()
		{
			super();
			addFrameScript(0,this.frame1,9,this.frame10);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame10() : *
		{
			dispatchEvent(new Event("animationComplete"));
			stop();
		}
	}
}
