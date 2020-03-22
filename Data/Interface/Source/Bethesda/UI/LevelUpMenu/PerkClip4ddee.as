package
{
	public dynamic class PerkClip4ddee extends PerkAnimHolder
	{
		 
		
		public function PerkClip4ddee()
		{
			super();
			addFrameScript(0,this.frame1,103,this.frame104);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame104() : *
		{
			gotoAndPlay(2);
		}
	}
}
