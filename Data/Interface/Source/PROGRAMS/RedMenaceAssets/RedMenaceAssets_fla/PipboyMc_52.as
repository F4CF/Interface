package RedMenaceAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class PipboyMc_52 extends MovieClip
	{
		 
		
		public var pipboyViewMc:MovieClip;
		
		public function PipboyMc_52()
		{
			super();
			addFrameScript(1,this.frame2,29,this.frame30,38,this.frame39);
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame30() : *
		{
			gotoAndPlay("slowBlink");
		}
		
		function frame39() : *
		{
			gotoAndPlay("fastBlink");
		}
	}
}
