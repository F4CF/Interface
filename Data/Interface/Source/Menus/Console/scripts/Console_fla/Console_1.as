package Console_fla
{
	import flash.display.MovieClip;
	
	public dynamic class Console_1 extends MovieClip
	{
		 
		
		public var Menu_mc:Console;
		
		public function Console_1()
		{
			super();
			addFrameScript(0,this.frame1,6,this.frame7,11,this.frame12);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame7() : *
		{
			this.Menu_mc.ShowComplete();
			stop();
		}
		
		function frame12() : *
		{
			this.Menu_mc.HideComplete();
			stop();
		}
	}
}
