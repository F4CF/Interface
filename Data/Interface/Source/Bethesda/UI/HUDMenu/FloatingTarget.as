package
{
	import flash.display.MovieClip;
	
	public dynamic class FloatingTarget extends MovieClip
	{
		 
		
		public var FloatingTargetSubClip:MovieClip;
		
		public function FloatingTarget()
		{
			super();
			addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4,4,this.frame5,5,this.frame6,6,this.frame7);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame3() : *
		{
			stop();
		}
		
		function frame4() : *
		{
			stop();
		}
		
		function frame5() : *
		{
			stop();
		}
		
		function frame6() : *
		{
			stop();
		}
		
		function frame7() : *
		{
			stop();
		}
	}
}
