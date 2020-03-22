package
{
	public dynamic class PerkClip1e67f extends PerkAnimHolder
	{
		 
		
		public function PerkClip1e67f()
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
