package Pipboy.COMPANIONAPP
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	
	public class InventoryListItemRenderer extends PipboyListItemRenderer
	{
		 
		
		public var EquipIcon_mc:MovieClip;
		
		public var FavIcon_mc:MovieClip;
		
		public var LegendaryIcon_mc:MovieClip;
		
		public var SearchIcon_mc:MovieClip;
		
		public function InventoryListItemRenderer()
		{
			super();
		}
		
		override protected function createScrollingListEntry() : BSScrollingListEntry
		{
			return new InvListEntry();
		}
		
		override protected function setupScrollinglistEntry() : *
		{
			super.setupScrollinglistEntry();
			var _loc1_:InvListEntry = _scrollingListEntry as InvListEntry;
			_loc1_.EquipIcon_mc = this.EquipIcon_mc;
			_loc1_.FavIcon_mc = this.FavIcon_mc;
			_loc1_.LegendaryIcon_mc = this.LegendaryIcon_mc;
			_loc1_.SearchIcon_mc = this.SearchIcon_mc;
		}
	}
}
