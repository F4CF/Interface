package bhvr.tutorial
{
	import Holotapes.Common.tutorial.BaseTutorialOverlay;
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	
	public class MapTutorialOverlay extends BaseTutorialOverlay
	{
		 
		
		public var mainMc:MovieClip;
		
		public function MapTutorialOverlay()
		{
			super();
		}
		
		override public function SetScreenInfo(param1:int, param2:int, param3:Number) : void
		{
			super.SetScreenInfo(param1,param2,param3);
			var _loc4_:Number = Math.atan(param1 / Number(param2)) * 180 / Math.PI;
			this.mainMc.tutorialMc.titleTxtMc.titleTxt.text = LocalizationStrings.TUTORIAL_TITLE;
			this.mainMc.tutorialMc.upTxtMc.txtMc.txt.text = LocalizationStrings.TUTORIAL_ZONE_UP;
			this.mainMc.tutorialMc.downTxtMc.txtMc.txt.text = LocalizationStrings.TUTORIAL_ZONE_DOWN;
			this.mainMc.tutorialMc.leftTxtMc.txtMc.txt.text = LocalizationStrings.TUTORIAL_ZONE_LEFT;
			this.mainMc.tutorialMc.rightTxtMc.txtMc.txt.text = LocalizationStrings.TUTORIAL_ZONE_RIGHT;
			this.mainMc.tutorialMc.linesAnimMc.linesMc.line1Mc.rotation = _loc4_;
			this.mainMc.tutorialMc.linesAnimMc.linesMc.line2Mc.rotation = -_loc4_;
		}
	}
}
