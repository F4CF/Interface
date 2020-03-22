package
{
	import flash.display.MovieClip;

	public dynamic class MeterBarInternal extends MovieClip
	{


		public function MeterBarInternal()
		{
			super();
			addFrameScript(0,this.frame1,5,this.frame6,10,this.frame11,15,this.frame16,20,this.frame21,25,this.frame26,30,this.frame31,35,this.frame36,39,this.frame40);
		}

		function frame1() : *
		{
			stop();
		}

		function frame6() : *
		{
			stop();
		}

		function frame11() : *
		{
			this["onBarFlashedDark"]();
		}

		function frame16() : *
		{
			this["onBarFlashedBright"]();
		}

		function frame21() : *
		{
			this["onBarFlashedDark"]();
		}

		function frame26() : *
		{
			this["onBarFlashedBright"]();
		}

		function frame31() : *
		{
			this["onBarFlashedDark"]();
		}

		function frame36() : *
		{
			this["onBarFlashedBright"]();
		}

		function frame40() : *
		{
			this["onBarFlashingDone"]();
		}
	}
}
