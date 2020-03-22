package
{
	public dynamic class PerkClip24aff extends PerkAnimHolder
	{
		 
		
		public function PerkClip24aff()
		{
			super();
			addFrameScript(0,this.frame1,91,this.frame92);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame92() : *
		{
			gotoAndPlay(2);
		}
	}
}
