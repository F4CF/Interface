package
{
	import flash.display.MovieClip;

	public dynamic class DamageIcons extends MovieClip
	{


		public function DamageIcons()
		{
			super();
			addFrameScript(0, this.frame1);
		}


		function frame1() : *
		{
			stop();
		}


	}
}
