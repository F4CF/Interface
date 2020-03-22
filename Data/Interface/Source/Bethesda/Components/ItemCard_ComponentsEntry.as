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
		
		override public function PopulateEntry(aInfoObj:Object) : *
		{
			var component:Object = null;
			var newEntry:ItemCard_ComponentEntry_Entry = null;
			while(this.EntryHolder_mc.numChildren > 0)
			{
				this.EntryHolder_mc.removeChildAt(0);
			}
			this.currY = 0;
			for each(component in aInfoObj.components)
			{
				newEntry = new ItemCard_ComponentEntry_Entry();
				newEntry.SetEntryText(component,BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT);
				this.EntryHolder_mc.addChild(newEntry);
				newEntry.y = this.currY;
				this.currY = this.currY + (newEntry.height + this.ENTRY_SPACING);
			}
		}
	}
}
