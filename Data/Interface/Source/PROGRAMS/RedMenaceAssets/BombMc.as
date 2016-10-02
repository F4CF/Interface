package
{
	import flash.display.MovieClip;
	
	public dynamic class BombMc extends MovieClip
	{
		 
		
		public var bombViewMc:MovieClip;
		
		public var colliderPointMc:MovieClip;
		
		public function BombMc()
		{
			super();
			addFrameScript(1,this.frame2,10,this.frame11);
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame11() : *
		{
			stop();
		}
	}
}
