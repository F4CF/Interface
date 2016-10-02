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
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			if(param1.count != 1 && param1.count != undefined)
			{
				textField.appendText(" (" + param1.count + ")");
			}
			var _loc3_:Number = textField.x + textField.width / 2 + textField.textWidth / 2 + 15;
			if(this.FavIcon_mc != null)
			{
				this.FavIcon_mc.x = _loc3_;
				this.FavIcon_mc.visible = param1.favorite > 0 || param1.taggedForSearch;
			}
		}
	}
}
