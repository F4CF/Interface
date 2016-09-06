package
{
	import flash.display.MovieClip;
	
	public dynamic class Hero extends MovieClip
	{
		 
		
		public var heroViewMc:MovieClip;
		
		public function Hero()
		{
			super();
			addFrameScript(1,this.frame2,29,this.frame30,54,this.frame55);
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame30() : *
		{
			gotoAndPlay("damage");
		}
		
		function frame55() : *
		{
			stop();
		}
	}
}
