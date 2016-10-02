package
{
	import flash.display.MovieClip;
	
	public dynamic class Human extends MovieClip
	{
		 
		
		public var viewMc:MovieClip;
		
		public function Human()
		{
			super();
			addFrameScript(1,this.frame2,7,this.frame8,9,this.frame10);
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame8() : *
		{
			gotoAndPlay("damage");
		}
		
		function frame10() : *
		{
			stop();
		}
	}
}
