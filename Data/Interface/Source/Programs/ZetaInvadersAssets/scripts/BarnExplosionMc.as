package
{
	import flash.display.MovieClip;
	
	public dynamic class BarnExplosionMc extends MovieClip
	{
		 
		
		public function BarnExplosionMc()
		{
			super();
			addFrameScript(0,this.frame1);
		}
		
		function frame1() : *
		{
			stop();
		}
	}
}
