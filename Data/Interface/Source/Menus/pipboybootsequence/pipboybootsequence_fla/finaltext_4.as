package pipboybootsequence_fla
{
	import Shared.BGSExternalInterface;
	import flash.display.MovieClip;
	
	public dynamic class finaltext_4 extends MovieClip
	{
		 
		
		public function finaltext_4()
		{
			super();
			addFrameScript(0,this.frame1,160,this.frame161,309,this.frame310);
		}
		
		function frame1() : *
		{
			BGSExternalInterface.call(MovieClip(root).BGSCodeObj,"PlaySound","UIPipBoyBootSequenceB");
		}
		
		function frame161() : *
		{
			BGSExternalInterface.call(MovieClip(root).BGSCodeObj,"PlaySound","UIPipBoyBootSequenceC");
		}
		
		function frame310() : *
		{
			BGSExternalInterface.call(MovieClip(root).BGSCodeObj,"HideMenu");
		}
	}
}
