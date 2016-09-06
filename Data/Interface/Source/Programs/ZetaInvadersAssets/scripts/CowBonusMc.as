package
{
	import flash.display.MovieClip;
	
	public dynamic class CowBonusMc extends MovieClip
	{
		 
		
		public var bonusAnimMc:MovieClip;
		
		public function CowBonusMc()
		{
			super();
			addFrameScript(0,this.frame1);
		}
		
		function frame1() : *
		{
			stop();
		}
	}
}
