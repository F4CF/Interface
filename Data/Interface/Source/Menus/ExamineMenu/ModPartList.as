package
{
	import Shared.AS3.BSScrollingList;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ModPartList extends BSScrollingList
	{
		 
		
		public function ModPartList()
		{
			super();
			addEventListener(BSScrollingList.LIST_ITEMS_CREATED,this.onListCreate);
		}
		
		public function onListCreate(param1:Event) : *
		{
			stage.stageFocusRect = false;
		}
		
		override protected function doSetSelectedIndex(param1:int) : *
		{
			var _loc2_:Array = null;
			if(param1 != selectedIndex)
			{
				MovieClip(root).BaseInstance.BGSCodeObj.PlaySound("UIMenuFocus");
			}
			super.doSetSelectedIndex(param1);
			if(stage.focus == this)
			{
				_loc2_ = new Array();
				MovieClip(root).BaseInstance.BGSCodeObj.SwitchMod(selectedIndex,_loc2_);
			}
			if(stage.focus == this)
			{
				dispatchEvent(new Event("ModPossibilityListChange",true,true));
			}
		}
		
		public function GetDescription() : String
		{
			if(selectedIndex > -1 && selectedIndex < entryList.length)
			{
				return entryList[selectedIndex].description;
			}
			return "";
		}
	}
}
