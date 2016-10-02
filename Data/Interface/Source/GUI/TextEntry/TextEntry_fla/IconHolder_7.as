package TextEntry_fla
{
	import flash.display.MovieClip;
	
	public dynamic class IconHolder_7 extends MovieClip
	{
		 
		
		public var IconAnimInstance:MovieClip;
		
		public function IconHolder_7()
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
