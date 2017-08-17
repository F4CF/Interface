package
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class InvListEntry extends BSScrollingListEntry
	{
		 
		
		public var EquipIconInstance:MovieClip;
		
		public var FavoriteIconInstance:MovieClip;
		
		public var BestIconInstance:MovieClip;
		
		public var LockIcon_mc:MovieClip;
		
		public var LegendaryIcon_mc:MovieClip;
		
		public function InvListEntry()
		{
			super();
		}
		
		private function SetColorTransform(param1:Object, param2:Boolean) : *
		{
			var _loc3_:ColorTransform = param1.transform.colorTransform;
			_loc3_.redOffset = !!param2?Number(-255):Number(0);
			_loc3_.greenOffset = !!param2?Number(-255):Number(0);
			_loc3_.blueOffset = !!param2?Number(-255):Number(0);
			param1.transform.colorTransform = _loc3_;
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			var _loc3_:String = null;
			super.SetEntryText(param1,param2);
			if(param1.accountedFor != null && param1.requiredCount != null)
			{
				_loc3_ = param1.text + " " + param1.accountedFor + "/" + param1.requiredCount;
			}
			else
			{
				_loc3_ = param1.text;
			}
			if(param1.text != undefined)
			{
				GlobalFunc.SetText(textField,param1.count > 1?_loc3_ + " (" + param1.count + ")":_loc3_,true);
			}
			textField.alpha = param1.enabled || param1.hasRequired || param1.equipState > 0?Number(1):Number(0.5);
			this.EquipIconInstance.visible = param1.equipState > 0;
			this.FavoriteIconInstance.visible = param1.favorite == true;
			this.BestIconInstance.visible = param1.bestInClass == true;
			this.LegendaryIcon_mc.visible = param1.isLegendary == true;
			var _loc4_:uint = this.textField.getLineMetrics(0).width + this.textField.x + 5;
			if(this.LegendaryIcon_mc.visible)
			{
				this.LegendaryIcon_mc.x = _loc4_;
				_loc4_ = _loc4_ + (this.LegendaryIcon_mc.width + 5);
			}
			if(this.FavoriteIconInstance.visible)
			{
				this.FavoriteIconInstance.x = _loc4_;
			}
			this.LockIcon_mc.visible = false;
			this.SetColorTransform(this.EquipIconInstance,this.selected);
			this.SetColorTransform(this.FavoriteIconInstance,this.selected);
			this.SetColorTransform(this.BestIconInstance,this.selected);
			this.SetColorTransform(this.LegendaryIcon_mc,this.selected);
			this.SetColorTransform(textField,this.selected);
		}
	}
}
