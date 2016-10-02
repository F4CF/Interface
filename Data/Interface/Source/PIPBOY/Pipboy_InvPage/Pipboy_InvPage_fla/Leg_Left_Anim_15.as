package Pipboy_InvPage_fla
{
	import flash.display.MovieClip;
	
	public dynamic class Leg_Left_Anim_15 extends MovieClip
	{
		 
		
		public function Leg_Left_Anim_15()
		{
			super();
			addFrameScript(0,this.frame1,24,this.frame25);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame25() : *
		{
			gotoAndPlay("Animate");
		}
	}
}
