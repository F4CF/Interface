package
{
	import Shared.UpdateEventList;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ExamineMenuList extends UpdateEventList
	{
		
		public static const MOUSE_OVER:String = "ItemList::mouse_over";
		 
		
		public function ExamineMenuList()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
		}
		
		override protected function doSetSelectedIndex(param1:int) : *
		{
			var _loc2_:* = false;
			if(param1 != this.selectedIndex)
			{
				if(this.selectedIndex != -1)
				{
					MovieClip(root).BaseInstance.BGSCodeObj.PlaySound("UIGeneralFocus");
				}
				_loc2_ = true;
			}
			super.doSetSelectedIndex(param1);
			if(_loc2_)
			{
				MovieClip(root).BaseInstance.BGSCodeObj.ShowItem();
			}
			var _loc3_:Array = new Array();
			if(this.selectedIndex >= 0 && entryList.length > this.selectedIndex)
			{
				if(entryList[this.selectedIndex].ItemCardInfoList != null)
				{
					MovieClip(root).BaseInstance.ItemCardList_mc.InfoObj = entryList[this.selectedIndex].ItemCardInfoList;
				}
				_loc3_ = null;
			}
			else
			{
				MovieClip(root).BaseInstance.ItemCardList_mc.InfoObj = _loc3_;
				MovieClip(root).BaseInstance.ItemCardList_mc.InfoObj.reverse();
				_loc3_ = null;
			}
		}
		
		private function onMouseOver(param1:MouseEvent) : void
		{
			dispatchEvent(new Event(MOUSE_OVER,true,true));
		}
		
		public function RefreshItem() : void
		{
			MovieClip(root).BaseInstance.ItemCardList_mc.InfoObj = entryList[this.selectedIndex].ItemCardInfoList;
			MovieClip(root).BaseInstance.ItemCardList_mc.InfoObj.reverse();
		}
	}
}
