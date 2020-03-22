package HUDMenu_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class crosshairLoop_83 extends MovieClip
	{
		 
		
		public var Down:MovieClip;
		
		public var Left:MovieClip;
		
		public var Right:MovieClip;
		
		public var Up:MovieClip;
		
		public function crosshairLoop_83()
		{
			super();
			addFrameScript(0,this.frame1,3,this.frame4);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame4() : *
		{
			dispatchEvent(new Event("animationComplete"));
		}
	}
}
