package VignetteMenu_fla
{
	import flash.display.MovieClip;


	public dynamic class MainTimeline extends MovieClip
	{

		public var VignetteClipInstance:VignetteMenu;


		public function MainTimeline()
		{
			super();
			addFrameScript(14, this.frame15, 19, this.frame20);
		}


		function frame15() : *
		{
			stop();
		}


		function frame20() : *
		{
			this.VignetteClipInstance.OnAnimateOutComplete();
			stop();
		}



	}
}
