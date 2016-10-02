package TextEntry_fla
{
	import flash.display.MovieClip;
	
	public dynamic class PCKeyHolder_5 extends MovieClip
	{
		 
		
		public var PCKeyAnimInstance:MovieClip;
		
		public function PCKeyHolder_5()
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
