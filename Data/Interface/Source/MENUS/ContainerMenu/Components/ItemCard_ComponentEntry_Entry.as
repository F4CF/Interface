package Components
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	
	public class ItemCard_ComponentEntry_Entry extends BSScrollingListEntry
	{
		 
		
		public var FavIcon_mc:MovieClip;
		
		public function ItemCard_ComponentEntry_Entry()
		{
			super();
		}
		
		override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
		{
			super.SetEntryText(aEntryObject,astrTextOption);
			if(aEntryObject.count != 1 && aEntryObject.count != undefined)
			{
				textField.appendText(" (" + aEntryObject.count + ")");
			}
			var rightTextX:Number = textField.x + textField.width / 2 + textField.textWidth / 2 + 15;
			if(this.FavIcon_mc != null)
			{
				this.FavIcon_mc.x = rightTextX;
				this.FavIcon_mc.visible = aEntryObject.favorite > 0 || aEntryObject.taggedForSearch;
			}
		}
	}
}
