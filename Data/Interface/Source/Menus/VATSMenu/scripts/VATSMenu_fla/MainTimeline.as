package VATSMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class MainTimeline extends MovieClip
	{
		 
		
		public var MenuInstance:VATSMenu;
		
		public function MainTimeline()
		{
			super();
			addFrameScript(0,this.frame1);
		}
		
		public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean) : *
		{
			this.MenuInstance.SetPlatform(auiPlatform,abPS3Switch);
		}
		
		function frame1() : *
		{
		}
	}
}
