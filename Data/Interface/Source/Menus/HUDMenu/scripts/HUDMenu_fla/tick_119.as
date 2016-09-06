package HUDMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class tick_119 extends MovieClip
	{
		 
		
		public function tick_119()
		{
			super();
			addFrameScript(0,this.frame1,27,this.frame28);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame28() : *
		{
			gotoAndPlay("Pulse");
		}
	}
}
