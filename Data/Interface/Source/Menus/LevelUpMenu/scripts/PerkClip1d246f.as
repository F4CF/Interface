package
{
	public dynamic class PerkClip1d246f extends PerkAnimHolder
	{
		 
		
		public function PerkClip1d246f()
		{
			super();
			addFrameScript(0,this.frame1,99,this.frame100);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame100() : *
		{
			gotoAndPlay(2);
		}
	}
}
