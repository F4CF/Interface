package bhvr.data.database.creators.bases
{
	import bhvr.data.database.Item;
	import bhvr.data.database.ShopItem;
	import bhvr.data.database.GameDatabase;
	import bhvr.data.database.StoryItem;
	import flash.utils.Dictionary;
	
	public class BaseItemDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseItemDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createItem(id:String) : Item
		{
			var obj:Item = new Item();
			addObjectToSharedData(id,obj);
			return obj;
		}
		
		public function createShopItem(id:String) : ShopItem
		{
			var obj:ShopItem = new ShopItem(GameDatabase.shopItems.length);
			GameDatabase.shopItems.push(obj);
			addObjectToSharedData(id,obj);
			return obj;
		}
		
		public function createStoryItem(id:String) : StoryItem
		{
			var obj:StoryItem = new StoryItem();
			addObjectToSharedData(id,obj);
			return obj;
		}
	}
}
