package
{
	import Shared.AS3.BSScrollingList;
	import flash.display.MovieClip;
	
	public class ObjectivesList extends BSScrollingList
	{
		 
		
		public var Mask_mc:MovieClip;
		
		public function ObjectivesList()
		{
			super();
			this.Mask_mc = new MovieClip();
			this.Mask_mc.graphics.clear();
			this.Mask_mc.graphics.beginFill(16777215);
			this.Mask_mc.graphics.drawRect(0,0,border.width,border.height);
			this.Mask_mc.graphics.endFill();
			this.addChildAt(this.Mask_mc,2);
			this.Mask_mc.x = border.x;
			this.Mask_mc.y = border.y;
			this.Mask_mc.mouseEnabled = false;
			EntryHolder_mc.mask = this.Mask_mc;
			this.allowWheelScrollNoSelectionChange = true;
		}
	}
}
