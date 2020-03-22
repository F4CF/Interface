package
{
	import flash.display.MovieClip;

	public dynamic class Helmet_Anim extends MovieClip
	{


		public function Helmet_Anim()
		{
			super();
			addFrameScript(0, this.frame1, 24, this.frame25);
		}


		function frame1():*
		{
			stop();
		}


		function frame25():*
		{
			gotoAndPlay("Animate");
		}


	}
}
