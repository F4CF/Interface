package MultiActivateMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class Button_FadeAnim_3 extends MovieClip
	{
		 
		
		public var Holder:MovieClip;
		
		public function Button_FadeAnim_3()
		{
			super();
			addFrameScript(0,this.frame1,9,this.frame10,19,this.frame20);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame10() : *
		{
			stop();
		}
		
		function frame20() : *
		{
			gotoAndStop(1);
		}
	}
}
