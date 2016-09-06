package RedMenaceAssets_fla
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class RedMenaceMc_43 extends MovieClip
	{
		 
		
		public var bossClimbMc:MovieClip;
		
		public var leftBombMc:BombMc;
		
		public var rightBombMc:BombMc;
		
		public function RedMenaceMc_43()
		{
			super();
			addFrameScript(1,this.frame2,18,this.frame19,20,this.frame21,28,this.frame29,35,this.frame36,89,this.frame90,150,this.frame151,178,this.frame179);
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame19() : *
		{
			gotoAndPlay("laugh");
		}
		
		function frame21() : *
		{
			stop();
		}
		
		function frame29() : *
		{
			stop();
		}
		
		function frame36() : *
		{
			stop();
		}
		
		function frame90() : *
		{
			stop();
		}
		
		function frame151() : *
		{
			dispatchEvent(new Event("KidnapGirl",true,true));
		}
		
		function frame179() : *
		{
			stop();
		}
	}
}
