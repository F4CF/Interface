package bhvr.tutorial
{
	import Holotapes.Common.tutorial.BaseTutorialOverlay;
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	
	public class WindowTutorialOverlay extends BaseTutorialOverlay
	{
		 
		
		public var mainMc:MovieClip;
		
		public function WindowTutorialOverlay()
		{
			super();
		}
		
		override public function SetScreenInfo(param1:int, param2:int, param3:Number) : void
		{
			super.SetScreenInfo(param1,param2,param3);
			this.mainMc.tutorialMc.titleTxtMc.titleTxt.text = LocalizationStrings.TUTORIAL_TITLE;
			this.mainMc.tutorialMc.selectMc.selectTxtMc.txt.text = LocalizationStrings.TUTORIAL_ZONE_SELECT;
		}
	}
}
