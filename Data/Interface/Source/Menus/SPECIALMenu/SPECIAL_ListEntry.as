package
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	
	public class SPECIAL_ListEntry extends BSScrollingListEntry
	{
		 
		
		public var Value_tf:TextField;
		
		public var NameLabel_tf:TextField;
		
		public var IncrementArrow:MovieClip;
		
		public var DecrementArrow:MovieClip;
		
		public var IsNameEntry:Boolean = true;
		
		public function SPECIAL_ListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			GlobalFunc.SetText(this.Value_tf,param1.value,false);
			this.Value_tf.textColor = !!this.selected?uint(0):uint(16777215);
			var _loc3_:ColorTransform = this.IncrementArrow.transform.colorTransform;
			_loc3_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.IncrementArrow.transform.colorTransform = _loc3_;
			_loc3_ = this.DecrementArrow.transform.colorTransform;
			_loc3_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc3_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.DecrementArrow.transform.colorTransform = _loc3_;
		}
	}
}
