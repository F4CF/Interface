package HUDMenu_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class dot2crosshair_80 extends MovieClip
	{
		 
		
		public var Down:MovieClip;
		
		public var Left:MovieClip;
		
		public var Right:MovieClip;
		
		public var Up:MovieClip;
		
		public function dot2crosshair_80()
		{
			super();
			addFrameScript(0,this.frame1,7,this.frame8);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame8() : *
		{
			dispatchEvent(new Event("animationComplete"));
		}
	}
}
