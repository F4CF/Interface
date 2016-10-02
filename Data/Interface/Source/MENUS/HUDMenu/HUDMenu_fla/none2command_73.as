package HUDMenu_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class none2command_73 extends MovieClip
	{
		 
		
		public var Down:MovieClip;
		
		public var Left:MovieClip;
		
		public var Right:MovieClip;
		
		public var Up:MovieClip;
		
		public function none2command_73()
		{
			super();
			addFrameScript(0,this.frame1,5,this.frame6);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame6() : *
		{
			dispatchEvent(new Event("animationComplete"));
		}
	}
}
