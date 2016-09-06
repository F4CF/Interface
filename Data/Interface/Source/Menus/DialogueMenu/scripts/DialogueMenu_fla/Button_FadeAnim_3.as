package DialogueMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class Button_FadeAnim_3 extends MovieClip
	{
		 
		
		public var Holder:MovieClip;
		
		public function Button_FadeAnim_3()
		{
			super();
			addFrameScript(0,this.frame1,1,this.frame2,9,this.frame10,10,this.frame11,19,this.frame20,20,this.frame21);
		}
		
		function frame1() : *
		{
			visible = false;
			stop();
		}
		
		function frame2() : *
		{
			visible = true;
		}
		
		function frame10() : *
		{
			stop();
		}
		
		function frame11() : *
		{
			visible = true;
		}
		
		function frame20() : *
		{
			gotoAndStop(1);
		}
		
		function frame21() : *
		{
			visible = true;
		}
	}
}
