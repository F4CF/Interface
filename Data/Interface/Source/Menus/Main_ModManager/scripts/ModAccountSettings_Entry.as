package
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.geom.ColorTransform;
	
	public class ModAccountSettings_Entry extends BSScrollingListEntry
	{
		 
		
		public function ModAccountSettings_Entry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			var _loc3_:ColorTransform = this.transform.colorTransform;
			_loc3_.redOffset = !!param1.disabled?Number(-128):Number(0);
			_loc3_.greenOffset = !!param1.disabled?Number(-128):Number(0);
			_loc3_.blueOffset = !!param1.disabled?Number(-128):Number(0);
			this.transform.colorTransform = _loc3_;
		}
	}
}
