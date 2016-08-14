package pipboybootsequence_fla
{
	import flash.display.MovieClip;
	import Shared.BGSExternalInterface;


	public dynamic class BootSequence_1 extends MovieClip
	{

		public function BootSequence_1()
		{
			super();
			addFrameScript(1, this.frame2, 370, this.frame371);
		}


		function frame2() : *
		{
			BGSExternalInterface.call(MovieClip(root).BGSCodeObj, "PlaySound", "UIPipBoyBootSequenceA");
		}


		function frame371() : *
		{
			stop();
		}



	}
}
