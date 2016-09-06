package RedMenaceAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class Arrow_65 extends MovieClip
	{
		 
		
		public function Arrow_65()
		{
			super();
			addFrameScript(5,this.frame6,27,this.frame28,51,this.frame52);
		}
		
		function frame6() : *
		{
			stop();
		}
		
		function frame28() : *
		{
			gotoAndPlay("blinkRightDirection");
		}
		
		function frame52() : *
		{
			gotoAndPlay("blinkLeftDirection");
		}
	}
}
