package
{
	import flash.display.MovieClip;

	public dynamic class HotkeyIcons extends MovieClip
	{


		public function HotkeyIcons()
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
