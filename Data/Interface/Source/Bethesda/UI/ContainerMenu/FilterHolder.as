package
{
	import flash.display.MovieClip;

	public dynamic class FilterHolder extends MovieClip
	{
		public var Menu_mc:ContainerMenu;


		public function FilterHolder()
		{
			super();
			addFrameScript(9, this.frame10);
		}


		function frame10() : *
		{
			this.Menu_mc.onIntroAnimComplete();
			stop();
		}


	}
}
