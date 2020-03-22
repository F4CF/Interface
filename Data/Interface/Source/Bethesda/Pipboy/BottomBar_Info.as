package
{
	import flash.display.MovieClip;
	import flash.text.TextField;

	public dynamic class BottomBar_Info extends MovieClip
	{

		public var LVL_tf:TextField;

		public var Time_tf:TextField;

		public var Location_tf:TextField;

		public var Date_tf:TextField;

		public var AP_tf:TextField;

		public var Caps_tf:TextField;

		public var XPMeter_mc:Pipboy_Meter;

		public var DMGDRWidget_mc:BB_DMGDRWidget;

		public var HPMeter:Pipboy_Meter;

		public var Weight_tf:TextField;

		public var HP_tf:TextField;


		public function BottomBar_Info()
		{
			super();
			addFrameScript(0, this.frame1);
		}


		function frame1() : *
		{
			stop();
		}


	}
}
