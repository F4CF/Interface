package
{
	import flash.display.MovieClip;
	
	public dynamic class BeamMc extends MovieClip
	{
		 
		
		public function BeamMc()
		{
			super();
			addFrameScript(0,this.frame1,17,this.frame18,40,this.frame41,47,this.frame48);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame18() : *
		{
			stop();
		}
		
		function frame41() : *
		{
			gotoAndPlay("loop");
		}
		
		function frame48() : *
		{
			stop();
		}
	}
}
