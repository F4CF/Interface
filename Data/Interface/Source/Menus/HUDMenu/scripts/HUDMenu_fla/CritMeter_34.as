package HUDMenu_fla
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public dynamic class CritMeter_34 extends MovieClip
	{
		 
		
		public var Bracket_mc:MovieClip;
		
		public var CritMeterStars_mc:CritMeterStarHolder;
		
		public var DisplayText_tf:TextField;
		
		public var MeterBar_mc:CritMeterBar;
		
		public function CritMeter_34()
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
