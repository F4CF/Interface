package
{
	import flash.display.MovieClip;


	public class VignetteMenu extends MovieClip
	{

		public var BGSCodeObj:Object;


		public function VignetteMenu()
		{
			super();
			this.BGSCodeObj = new Object();
		}


		public function AnimateOut() : *
		{
			MovieClip(root).gotoAndPlay("AnimateOut");
		}


		public function OnAnimateOutComplete() : *
		{
			this.BGSCodeObj.OnAnimateOutComplete();
		}



	}
}
