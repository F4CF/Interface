package
{
	public dynamic class CritMeterBar extends MeterBarWidget
	{
		 
		
		public function CritMeterBar()
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
