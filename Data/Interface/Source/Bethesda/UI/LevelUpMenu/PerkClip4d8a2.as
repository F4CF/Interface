package
{
	public dynamic class PerkClip4d8a2 extends PerkAnimHolder
	{
		 
		
		public function PerkClip4d8a2()
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
