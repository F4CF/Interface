package AutomatronAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class HeroAnimMc_52 extends MovieClip
	{
		 
		
		public var colliderMc:MovieClip;
		
		public var gunMc:MovieClip;
		
		public var bodyMc:MovieClip;
		
		public function HeroAnimMc_52()
		{
			super();
			addFrameScript(4,this.frame5,15,this.frame16,16,this.frame17,30,this.frame31,31,this.frame32,50,this.frame51,51,this.frame52,68,this.frame69,69,this.frame70,90,this.frame91,91,this.frame92);
		}
		
		function frame5() : *
		{
			stop();
		}
		
		function frame16() : *
		{
			gotoAndPlay("moveUp");
		}
		
		function frame17() : *
		{
			stop();
		}
		
		function frame31() : *
		{
			gotoAndPlay("moveUpLeft");
		}
		
		function frame32() : *
		{
			stop();
		}
		
		function frame51() : *
		{
			gotoAndPlay("moveLeft");
		}
		
		function frame52() : *
		{
			stop();
		}
		
		function frame69() : *
		{
			gotoAndPlay("moveDownLeft");
		}
		
		function frame70() : *
		{
			stop();
		}
		
		function frame91() : *
		{
			gotoAndPlay("moveDown");
		}
		
		function frame92() : *
		{
			stop();
		}
	}
}
