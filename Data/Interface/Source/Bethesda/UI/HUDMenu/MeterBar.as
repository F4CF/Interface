package
{
	public dynamic class MeterBar extends MeterBarWidget
	{
		 
		
		public function MeterBar()
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
			gotoAndPlay("Flashing");
		}
	}
}
