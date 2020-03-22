package
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class WorkshopsListEntry extends BSScrollingListEntry
	{
		 
		
		public var AlertIcon_mc:MovieClip;
		
		public var RaiderIcon_mc:MovieClip;
		
		public function WorkshopsListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			this.AlertIcon_mc.visible = param1.rating < 0;
			this.RaiderIcon_mc.visible = param1.raider == true;
			var _loc3_:ColorTransform = this.AlertIcon_mc.transform.colorTransform;
			_loc3_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.AlertIcon_mc.transform.colorTransform = _loc3_;
			this.RaiderIcon_mc.transform.colorTransform = _loc3_;
			var _loc4_:int = textField.getLineMetrics(0).width + textField.x + 20;
			this.AlertIcon_mc.x = !!this.AlertIcon_mc.visible?Number(_loc4_):Number(0);
			this.RaiderIcon_mc.x = !!this.AlertIcon_mc.visible?Number(_loc4_ + this.AlertIcon_mc.width + 5):Number(_loc4_);
		}
	}
}
