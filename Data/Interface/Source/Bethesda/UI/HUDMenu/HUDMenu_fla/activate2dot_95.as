package HUDMenu_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class activate2dot_95 extends MovieClip
	{
		 
		
		public function activate2dot_95()
		{
			super();
			addFrameScript(0,this.frame1,6,this.frame7);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame7() : *
		{
			dispatchEvent(new Event("animationComplete"));
		}
	}
}
