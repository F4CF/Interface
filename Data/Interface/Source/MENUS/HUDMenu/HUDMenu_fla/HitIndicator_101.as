package HUDMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class HitIndicator_101 extends MovieClip
	{
		 
		
		public var HitHolder:MovieClip;
		
		public function HitIndicator_101()
		{
			super();
			addFrameScript(2,this.frame3,19,this.frame20);
		}
		
		function frame3() : *
		{
			stop();
		}
		
		function frame20() : *
		{
			this["onAnimationComplete"]();
		}
	}
}
