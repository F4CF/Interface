package RedMenaceAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class Roller1_62 extends MovieClip
	{
		 
		
		public function Roller1_62()
		{
			super();
			addFrameScript(13,this.frame14,32,this.frame33,53,this.frame54);
		}
		
		function frame14() : *
		{
			stop();
		}
		
		function frame33() : *
		{
			gotoAndPlay("rightDirection");
		}
		
		function frame54() : *
		{
			gotoAndPlay("leftDirection");
		}
	}
}
