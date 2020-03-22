package
{
	import Shared.AS3.BSScrollingList;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class RequirementList extends BSScrollingList
	{
		 
		
		public function RequirementList()
		{
			super();
			if(this.parent["RightArrow"] != null)
			{
				this.parent["RightArrow"].alpha = 0;
			}
			addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPress);
			addEventListener(BSScrollingList.LIST_ITEMS_CREATED,this.onListCreate);
		}
		
		public function onListCreate(param1:Event) : *
		{
		}
		
		override protected function doSetSelectedIndex(param1:int) : *
		{
			var _loc2_:* = param1 != selectedIndex;
			super.doSetSelectedIndex(param1);
			if(_loc2_)
			{
				MovieClip(root).BaseInstance.BGSCodeObj.PlaySound("UIMenuFocus");
				dispatchEvent(new Event("requirementSelectionChange",true,true));
			}
		}
		
		public function GrabFocus() : *
		{
			stage.focus = this;
			stage.stageFocusRect = false;
		}
		
		override protected function onItemPress() : *
		{
			dispatchEvent(new Event("startItemSelection",true,true));
		}
	}
}
