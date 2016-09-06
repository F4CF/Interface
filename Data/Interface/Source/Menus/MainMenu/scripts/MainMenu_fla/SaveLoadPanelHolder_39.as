package MainMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class SaveLoadPanelHolder_39 extends MovieClip
	{
		 
		
		public var icsaveLoadList_mc:MovieClip;
		
		public var Panel_mc:SaveLoadPanel;
		
		public function SaveLoadPanelHolder_39()
		{
			super();
			addFrameScript(0,this.frame1,2,this.frame3,4,this.frame5);
		}
		
		function frame1() : *
		{
			visible = false;
			stop();
		}
		
		function frame3() : *
		{
			visible = true;
			stop();
		}
		
		function frame5() : *
		{
			visible = false;
			stop();
		}
	}
}
