package
{
	public dynamic class PerkClip4d89b extends PerkAnimHolder
	{
		 
		
		public function PerkClip4d89b()
		{
			super();
			addFrameScript(0,this.frame1,200,this.frame201);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame201() : *
		{
			gotoAndPlay(2);
		}
	}
}
