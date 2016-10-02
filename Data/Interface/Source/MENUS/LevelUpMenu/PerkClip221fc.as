package
{
	public dynamic class PerkClip221fc extends PerkAnimHolder
	{
		 
		
		public function PerkClip221fc()
		{
			super();
			addFrameScript(0,this.frame1,80,this.frame81);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame81() : *
		{
			gotoAndPlay(2);
		}
	}
}
