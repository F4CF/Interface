package
{
	import Shared.AS3.BSScrollingList;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class MenuItemList extends BSScrollingList
	{
		 
		
		public function MenuItemList()
		{
			super();
		}
		
		public function ConvertToGlobal(param1:TextField) : Point
		{
			var _loc2_:Rectangle = new Rectangle();
			var _loc3_:Point = new Point();
			_loc2_ = param1.getCharBoundaries(param1.length - 1);
			_loc3_.x = _loc2_.bottomRight.x;
			_loc3_.y = _loc2_.y;
			return param1.localToGlobal(_loc3_);
		}
		
		public function AnimateText(param1:Boolean, param2:MovieClip, param3:uint) : Boolean
		{
			var _loc7_:uint = 0;
			var _loc8_:TextField = null;
			var _loc9_:Point = null;
			var _loc4_:* = EntriesA.length == 0;
			var _loc5_:Boolean = true;
			var _loc6_:uint = 0;
			while(_loc5_ && _loc6_ < EntriesA.length)
			{
				if(EntriesA[_loc6_].isFinished == undefined)
				{
					if(param1)
					{
						EntriesA[_loc6_].text = EntriesA[_loc6_].fullText.toString();
					}
					else
					{
						EntriesA[_loc6_].text = EntriesA[_loc6_].fullText.toString().slice(0,EntriesA[_loc6_].text.length + param3);
					}
					if(EntriesA[_loc6_].text.length == EntriesA[_loc6_].fullText.length)
					{
						EntriesA[_loc6_].isFinished = true;
					}
					_loc7_ = Math.min(_loc6_,iListItemsShown - 1);
					_loc8_ = GetClipByIndex(_loc7_).getChildByName("textField") as TextField;
					_loc9_ = this.ConvertToGlobal(_loc8_);
					param2.x = _loc9_.x;
					param2.y = _loc9_.y;
					_loc5_ = param1;
				}
				if(EntriesA[_loc6_].isFinished == true && _loc6_ == EntriesA.length - 1)
				{
					_loc4_ = true;
				}
				_loc6_++;
			}
			InvalidateData();
			disableInput = !_loc4_ || entryList.length == 0 || !visible;
			return _loc4_;
		}
	}
}
