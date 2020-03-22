package ExamineMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class BSButtonHint_IconHolder_32 extends MovieClip
	{
		 
		
		public var IconAnimInstance:MovieClip;
		
		public function BSButtonHint_IconHolder_32()
		{
			super();
			addFrameScript(0,this.frame1,59,this.frame60);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame60() : *
		{
			gotoAndPlay("Flashing");
		}
	}
}
