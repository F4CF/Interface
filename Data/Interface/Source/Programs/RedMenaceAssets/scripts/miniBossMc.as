package
{
	import flash.display.MovieClip;
	
	public dynamic class miniBossMc extends MovieClip
	{
		 
		
		public var colliderPointMc:MovieClip;
		
		public function miniBossMc()
		{
			super();
			addFrameScript(11,this.frame12,31,this.frame32,38,this.frame39);
		}
		
		function frame12() : *
		{
			gotoAndPlay("idle");
		}
		
		function frame32() : *
		{
			stop();
		}
		
		function frame39() : *
		{
			gotoAndPlay("climb");
		}
	}
}
