package
{
	import flash.display.MovieClip;
	
	public dynamic class EnforcerBulletMc extends MovieClip
	{
		 
		
		public var viewMc:MovieClip;
		
		public function EnforcerBulletMc()
		{
			super();
			addFrameScript(7,this.frame8,21,this.frame22);
		}
		
		function frame8() : *
		{
			gotoAndPlay("normal");
		}
		
		function frame22() : *
		{
			stop();
		}
	}
}
