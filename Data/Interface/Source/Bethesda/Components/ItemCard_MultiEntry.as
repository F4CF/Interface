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
		
		public static function IsEntryValid(aEntryObj:Object) : Boolean
		{
			return aEntryObj.value > 0 || ShouldShowDifference(aEntryObj) && aEntryObj.text == DMG_ARMO_ID;
		}
		
		public function PopulateMultiEntry(aInfoObj:Array, aPropName:String) : *
		{
			var newEntry:ItemCard_MultiEntry_Value = null;
			if(Label_tf != null)
			{
				GlobalFunc.SetText(Label_tf,aPropName,false);
			}
			while(this.EntryHolder_mc.numChildren > 0)
			{
				this.EntryHolder_mc.removeChildAt(0);
			}
			this.currY = 0;
			for(var dataIdx:uint = 0; dataIdx < aInfoObj.length; dataIdx++)
			{
				if(aInfoObj[dataIdx].text == aPropName && IsEntryValid(aInfoObj[dataIdx]))
				{
					newEntry = new ItemCard_MultiEntry_Value();
					newEntry.Icon_mc.gotoAndStop(aPropName == DMG_WEAP_ID?aInfoObj[dataIdx].damageType + GlobalFunc.NUM_DAMAGE_TYPES:aInfoObj[dataIdx].damageType);
					newEntry.PopulateEntry(aInfoObj[dataIdx]);
					this.EntryHolder_mc.addChild(newEntry);
					newEntry.y = this.currY;
					this.currY = this.currY + (newEntry.height + this.ENTRY_SPACING);
				}
			}
			this.Background_mc.height = this.EntryHolder_mc.height + this.ENTRY_SPACING;
		}
	}
}
