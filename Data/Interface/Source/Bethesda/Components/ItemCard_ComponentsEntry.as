package Components
{
	import Shared.AS3.BSScrollingList;
	import flash.display.MovieClip;
	
	public class ItemCard_ComponentsEntry extends ItemCard_Entry
	{
		 
		
		public var EntryHolder_mc:MovieClip;
		
		private var currY:Number;
		
		private const ENTRY_SPACING:Number = 0;
		
		public function ItemCard_ComponentsEntry()
		{
			super();
			this.currY = 0;
		}
		
		override public function PopulateEntry(param1:Object) : *
		{
			var _loc2_:Object = null;
			var _loc3_:ItemCard_ComponentEntry_Entry = null;
			while(this.EntryHolder_mc.numChildren > 0)
			{
				this.EntryHolder_mc.removeChildAt(0);
			}
			this.currY = 0;
			for each(_loc2_ in param1.components)
			{
				_loc3_ = new ItemCard_ComponentEntry_Entry();
				_loc3_.SetEntryText(_loc2_,BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT);
				this.EntryHolder_mc.addChild(_loc3_);
				_loc3_.y = this.currY;
				this.currY = this.currY + (_loc3_.height + this.ENTRY_SPACING);
			}
		}
	}
}
