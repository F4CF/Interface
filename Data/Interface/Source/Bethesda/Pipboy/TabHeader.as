package
{
	import flash.display.MovieClip;

	public dynamic class TabHeader extends MovieClip
	{

		public var AlphaHolder:MovieClip;


		public function TabHeader()
		{
			super();
			addFrameScript(0, this.frame1, 4, this.frame5);
		}


		function frame1():*
		{
			stop();
		}


		function frame5():*
		{
			gotoAndStop(1);
		}


	}
}
