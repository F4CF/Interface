package
{
	import flash.display.MovieClip;

	public dynamic class Tick extends MovieClip
	{


		public function Tick()
		{
			super();
			addFrameScript(0, this.frame1, 27, this.frame28);
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
