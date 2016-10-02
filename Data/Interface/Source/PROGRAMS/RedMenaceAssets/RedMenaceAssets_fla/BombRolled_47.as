package RedMenaceAssets_fla
{
	import flash.display.MovieClip;
	
	public dynamic class BombRolled_47 extends MovieClip
	{
		 
		
		public var colliderMc:MovieClip;
		
		public var jumpOverColliderMc:MovieClip;
		
		public function BombRolled_47()
		{
			super();
			addFrameScript(1,this.frame2,20,this.frame21,40,this.frame41);
		}
		
		function frame2() : *
		{
			stop();
		}
		
		function frame21() : *
		{
			gotoAndPlay("rolling");
		}
		
		function frame41() : *
		{
			stop();
		}
	}
}
