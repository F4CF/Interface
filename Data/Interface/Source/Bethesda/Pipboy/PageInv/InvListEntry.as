package
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class InvListEntry extends BSScrollingListEntry
	{
		 
		
		public var EquipIcon_mc:MovieClip;
		
		public var FavIcon_mc:MovieClip;
		
		public var LegendaryIcon_mc:MovieClip;
		
		public var SearchIcon_mc:MovieClip;
		
		private var BaseTextFieldWidth;
		
		private const SelectedColorTransform:ColorTransform = new ColorTransform(1,1,1,1,-255,-255,-255,0);
		
		private const UnselectedColorTransform:ColorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
		
		public function InvListEntry()
		{
			super();
			this.BaseTextFieldWidth = textField.width;
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			if(this.LegendaryIcon_mc != null)
			{
				this.LegendaryIcon_mc.visible = param1.isLegendary;
				_loc4_++;
			}
			if(this.FavIcon_mc != null)
			{
				this.FavIcon_mc.visible = param1.favorite > 0;
				if(_loc4_ > 0)
				{
					_loc3_ = _loc3_ + (this.FavIcon_mc.width / 2 + 10);
				}
				_loc4_++;
			}
			if(this.SearchIcon_mc != null)
			{
				this.SearchIcon_mc.visible = param1.taggedForSearch;
				if(_loc4_ > 0)
				{
					_loc3_ = _loc3_ + (this.SearchIcon_mc.width / 2 + 10);
				}
			}
			textField.width = this.BaseTextFieldWidth - _loc3_;
			super.SetEntryText(param1,param2);
			GlobalFunc.SetText(textField,textField.text,false,false,true);
			if(param1.count != 1)
			{
				textField.appendText(" (" + param1.count + ")");
			}
			GlobalFunc.SetText(textField,textField.text,false);
			var _loc5_:Number = this.textField.getLineMetrics(0).width + this.textField.x + 15;
			var _loc6_:ColorTransform = !!this.selected?this.SelectedColorTransform:this.UnselectedColorTransform;
			if(this.EquipIcon_mc != null)
			{
				this.EquipIcon_mc.visible = param1.equipState > 0;
				if(this.EquipIcon_mc.visible)
				{
					this.EquipIcon_mc.transform.colorTransform = _loc6_;
				}
			}
			if(this.LegendaryIcon_mc != null && this.LegendaryIcon_mc.visible)
			{
				this.LegendaryIcon_mc.x = _loc5_;
				_loc5_ = _loc5_ + (this.LegendaryIcon_mc.width / 2 + 10);
				this.LegendaryIcon_mc.transform.colorTransform = _loc6_;
			}
			if(this.FavIcon_mc != null && this.FavIcon_mc.visible)
			{
				this.FavIcon_mc.x = _loc5_;
				_loc5_ = _loc5_ + (this.FavIcon_mc.width / 2 + 10);
				this.FavIcon_mc.transform.colorTransform = _loc6_;
			}
			if(this.SearchIcon_mc != null && this.SearchIcon_mc.visible)
			{
				this.SearchIcon_mc.x = _loc5_;
				this.SearchIcon_mc.transform.colorTransform = _loc6_;
			}
		}
	}
}
