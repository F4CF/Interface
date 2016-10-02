package
{
	public dynamic class PerkClip4c92d extends PerkAnimHolder
	{
		 
		
		public function PerkClip4c92d()
		{
			super();
			addFrameScript(0,this.frame1,15,this.frame16);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame16() : *
		{
			gotoAndPlay(2);
		}
	}
}
