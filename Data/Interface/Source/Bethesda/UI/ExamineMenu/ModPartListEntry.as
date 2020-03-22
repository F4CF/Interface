package
{
	import Shared.AS3.BSScrollingListFadeEntry;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class ModPartListEntry extends BSScrollingListFadeEntry
	{
		 
		
		public var ModSelectedIcon_mc:MovieClip;
		
		public var FavoriteIcon_mc:MovieClip;
		
		public function ModPartListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			this.ModSelectedIcon_mc.alpha = param1.currentMod != undefined && param1.currentMod == true?Number(GlobalFunc.SELECTED_RECT_ALPHA):Number(0);
			this.textField.alpha = param1.hasRequired == true || param1.hasLooseMod == true?Number(1):Number(0.5);
			this.ModSelectedIcon_mc.gotoAndStop(!!this.selected?"Selected":"Unselected");
			this.FavoriteIcon_mc.visible = param1.modTaggedForSearch == true;
			this.FavoriteIcon_mc.x = this.textField.getLineMetrics(0).width + this.textField.x + 5;
			var _loc3_:ColorTransform = this.FavoriteIcon_mc.transform.colorTransform;
			_loc3_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.FavoriteIcon_mc.transform.colorTransform = _loc3_;
		}
	}
}
