package RedMenaceAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class BonusTimerMc_94 extends MovieClip
	{
		 
		
		public var bonusTimerAnimMc:MovieClip;
		
		public function BonusTimerMc_94()
		{
			super();
			addFrameScript(8,this.frame9,29,this.frame30);
		}
		
		function frame9() : *
		{
			stop();
		}
		
		function frame30() : *
		{
			gotoAndPlay("warning");
		}
	}
}
