package Main_ModManager_fla
{
	import flash.display.MovieClip;
	
	public dynamic class ModListsHolder_1 extends MovieClip
	{
		 
		
		public var ScrollDown:MovieClip;
		
		public var List2_mc:ModCategoryList;
		
		public var ScrollUp:MovieClip;
		
		public var List1_mc:ModCategoryList;
		
		public function ModListsHolder_1()
		{
			super();
			addFrameScript(0,this.frame1,3,this.frame4);
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame4() : *
		{
			gotoAndStop(1);
		}
	}
}
