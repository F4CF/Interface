package GrognakWindowAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class Main_1 extends MovieClip
	{
		 
		
		public var windowEventMc:MovieClip;
		
		public var pauseBtnMc:PauseIcon;
		
		public function Main_1()
		{
			super();
			addFrameScript(1,this.frame2,5,this.frame6);
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame6() : *
		{
			stop();
		}
	}
}
