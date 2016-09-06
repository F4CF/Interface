package
{
	public dynamic class PerkClip1dafe extends PerkAnimHolder
	{
		 
		
		public function PerkClip1dafe()
		{
			super();
			addFrameScript(0,this.frame1,24,this.frame25);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame25() : *
		{
			gotoAndPlay(2);
		}
	}
}
