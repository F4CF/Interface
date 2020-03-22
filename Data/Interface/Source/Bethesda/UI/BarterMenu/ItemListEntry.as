package
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class ItemListEntry extends BSScrollingListEntry
	{
		 
		
		public var LeftIcon_mc:MovieClip;
		
		public var FavoriteIcon_mc:MovieClip;
		
		public var LegendaryIcon_mc:MovieClip;
		
		public var TaggedForSearchIcon_mc:MovieClip;
		
		private var BaseTextFieldWidth;
		
		public function ItemListEntry()
		{
			super();
			this.BaseTextFieldWidth = textField.width;
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			this.TaggedForSearchIcon_mc.visible = param1.taggedForSearch == true;
			this.FavoriteIcon_mc.visible = param1.favorite > 0;
			this.LegendaryIcon_mc.visible = param1.isLegendary == true;
			var _loc3_:* = 0;
			if(this.FavoriteIcon_mc.visible && this.TaggedForSearchIcon_mc.visible)
			{
				_loc3_ = _loc3_ + (this.FavoriteIcon_mc.width / 2 + 10);
			}
			if(this.LegendaryIcon_mc.visible && this.FavoriteIcon_mc.visible)
			{
				_loc3_ = _loc3_ + (this.LegendaryIcon_mc.width / 2 + 10);
			}
			textField.width = this.BaseTextFieldWidth - _loc3_;
			super.SetEntryText(param1,param2);
			var _loc4_:int = 0;
			if(param1.barterCount != undefined)
			{
				_loc4_ = param1.barterCount;
			}
			var _loc5_:int = param1.count - _loc4_;
			GlobalFunc.SetText(textField,textField.text,false,false,true);
			if(_loc5_ != 1)
			{
				textField.appendText(" (" + _loc5_ + ")");
			}
			GlobalFunc.SetText(textField,textField.text,false);
			var _loc6_:ColorTransform = this.LeftIcon_mc.transform.colorTransform;
			_loc6_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc6_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc6_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.LeftIcon_mc.transform.colorTransform = _loc6_;
			this.LeftIcon_mc.EquipIcon_mc.visible = param1.equipState != 0;
			this.LeftIcon_mc.BestIcon_mc.visible = param1.inContainer && param1.bestInClass == true;
			if(this.LeftIcon_mc.BarterIcon_mc != undefined)
			{
				this.LeftIcon_mc.BarterIcon_mc.visible = _loc4_ < 0;
			}
			this.TaggedForSearchIcon_mc.x = this.textField.getLineMetrics(0).width + this.textField.x + 10;
			this.LegendaryIcon_mc.x = !!this.TaggedForSearchIcon_mc.visible?Number(this.TaggedForSearchIcon_mc.x + this.TaggedForSearchIcon_mc.width / 2 + 10):Number(this.TaggedForSearchIcon_mc.x);
			this.FavoriteIcon_mc.x = !!this.LegendaryIcon_mc.visible?Number(this.LegendaryIcon_mc.x + this.LegendaryIcon_mc.width / 2 + 10):!!this.TaggedForSearchIcon_mc.visible?Number(this.TaggedForSearchIcon_mc.x + this.TaggedForSearchIcon_mc.width / 2 + 10):Number(this.TaggedForSearchIcon_mc.x);
			_loc6_ = this.FavoriteIcon_mc.transform.colorTransform;
			_loc6_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc6_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc6_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.FavoriteIcon_mc.transform.colorTransform = _loc6_;
			_loc6_ = this.TaggedForSearchIcon_mc.transform.colorTransform;
			_loc6_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc6_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc6_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.TaggedForSearchIcon_mc.transform.colorTransform = _loc6_;
			_loc6_ = this.LegendaryIcon_mc.transform.colorTransform;
			_loc6_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc6_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc6_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.LegendaryIcon_mc.transform.colorTransform = _loc6_;
		}
	}
}
