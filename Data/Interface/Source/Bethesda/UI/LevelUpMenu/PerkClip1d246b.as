package
{
	public dynamic class PerkClip1d246b extends PerkAnimHolder
	{
		 
		
		public function PerkClip1d246b()
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
