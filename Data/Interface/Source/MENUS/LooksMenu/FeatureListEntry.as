package
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class FeatureListEntry extends BSScrollingListEntry
	{
		 
		
		public var EquipIcon_mc:MovieClip;
		
		public function FeatureListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			this.EquipIcon_mc.visible = param1.applied;
			var _loc3_:ColorTransform = this.EquipIcon_mc.transform.colorTransform;
			_loc3_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.EquipIcon_mc.transform.colorTransform = _loc3_;
		}
	}
}
