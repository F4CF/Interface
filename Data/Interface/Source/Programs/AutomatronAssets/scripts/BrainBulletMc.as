package
{
	import flash.display.MovieClip;
	
	public dynamic class BrainBulletMc extends MovieClip
	{
		 
		
		public var viewMc:MovieClip;
		
		public function BrainBulletMc()
		{
			super();
			addFrameScript(0,this.frame1,22,this.frame23);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame23() : *
		{
			stop();
		}
	}
}
