package Components
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	
	public class ItemCard_MultiEntry extends ItemCard_Entry
	{
		
		public static const DMG_WEAP_ID:String = "$dmg";
		
		public static const DMG_ARMO_ID:String = "$dr";
		 
		
		public var EntryHolder_mc:MovieClip;
		
		public var Background_mc:MovieClip;
		
		private var currY:Number;
		
		private const ENTRY_SPACING:Number = -4.5;
		
		public function ItemCard_MultiEntry()
		{
			super();
			this.currY = 0;
		}
		
		public static function IsEntryValid(param1:Object) : Boolean
		{
			return param1.value > 0 || ShouldShowDifference(param1) && param1.text == DMG_ARMO_ID;
		}
		
		public function PopulateMultiEntry(param1:Array, param2:String) : *
		{
			var _loc4_:ItemCard_MultiEntry_Value = null;
			if(Label_tf != null)
			{
				GlobalFunc.SetText(Label_tf,param2,false);
			}
			while(this.EntryHolder_mc.numChildren > 0)
			{
				this.EntryHolder_mc.removeChildAt(0);
			}
			this.currY = 0;
			var _loc3_:uint = 0;
			while(_loc3_ < param1.length)
			{
				if(param1[_loc3_].text == param2 && IsEntryValid(param1[_loc3_]))
				{
					_loc4_ = new ItemCard_MultiEntry_Value();
					_loc4_.Icon_mc.gotoAndStop(param2 == DMG_WEAP_ID?param1[_loc3_].damageType + GlobalFunc.NUM_DAMAGE_TYPES:param1[_loc3_].damageType);
					_loc4_.PopulateEntry(param1[_loc3_]);
					this.EntryHolder_mc.addChild(_loc4_);
					_loc4_.y = this.currY;
					this.currY = this.currY + (_loc4_.height + this.ENTRY_SPACING);
				}
				_loc3_++;
			}
			this.Background_mc.height = this.EntryHolder_mc.height + this.ENTRY_SPACING;
		}
	}
}
