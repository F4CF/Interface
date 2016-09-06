package
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.geom.ColorTransform;
	
	public class ModDetails_OptionsEntry extends BSScrollingListEntry
	{
		 
		
		public var RatingHolder_mc:ModDetails_RatingHolder;
		
		public function ModDetails_OptionsEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			this.RatingHolder_mc.rating = param1.rating;
			var _loc3_:ColorTransform = this.transform.colorTransform;
			_loc3_.redOffset = !!param1.disabled?Number(-128):Number(0);
			_loc3_.greenOffset = !!param1.disabled?Number(-128):Number(0);
			_loc3_.blueOffset = !!param1.disabled?Number(-128):Number(0);
			this.transform.colorTransform = _loc3_;
			_loc3_ = this.RatingHolder_mc.transform.colorTransform;
			_loc3_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.RatingHolder_mc.transform.colorTransform = _loc3_;
		}
	}
}
