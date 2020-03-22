package HUDMenu_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class dotLoop_79 extends MovieClip
	{
		 
		
		public function dotLoop_79()
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
