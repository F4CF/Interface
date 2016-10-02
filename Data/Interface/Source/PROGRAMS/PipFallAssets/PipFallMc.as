package
{
	import flash.display.MovieClip;
	
	public dynamic class PipFallMc extends MovieClip
	{
		 
		
		public var colliderMc:MovieClip;
		
		public var pipFallViewMc:MovieClip;
		
		public function PipFallMc()
		{
			super();
			addFrameScript(4,this.frame5,60,this.frame61);
		}
		
		function frame5() : *
		{
			stop();
		}
		
		function frame61() : *
		{
			stop();
		}
	}
}
