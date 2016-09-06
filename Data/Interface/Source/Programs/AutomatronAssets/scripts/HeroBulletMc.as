package
{
	import flash.display.MovieClip;
	
	public dynamic class HeroBulletMc extends MovieClip
	{
		 
		
		public var colliderMc:MovieClip;
		
		public function HeroBulletMc()
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
