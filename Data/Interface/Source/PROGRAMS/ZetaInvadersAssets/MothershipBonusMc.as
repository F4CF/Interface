package
{
	import flash.display.MovieClip;
	
	public dynamic class MothershipBonusMc extends MovieClip
	{
		 
		
		public var bonusAnimMc:MovieClip;
		
		public function MothershipBonusMc()
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
