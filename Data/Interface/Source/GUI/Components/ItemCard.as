package Components
{
	import Shared.AS3.BSUIComponent;
	
	public class ItemCard extends BSUIComponent
	{
		 
		
		private var _InfoObj:Array;
		
		private var currY:Number;
		
		private var _showItemDesc:Boolean;
		
		private const ENTRY_SPACING:Number = -3.5;
		
		private const ET_STANDARD:uint = 0;
		
		private const ET_AMMO:uint = 1;
		
		private const ET_DMG_WEAP:uint = 2;
		
		private const ET_DMG_ARMO:uint = 3;
		
		private const ET_TIMED_EFFECT:uint = 4;
		
		private const ET_COMPONENTS_LIST:uint = 5;
		
		private const ET_ITEM_DESCRIPTION:uint = 6;
		
		public function ItemCard()
		{
			super();
			this._InfoObj = new Array();
			this._showItemDesc = true;
			this.currY = 0;
		}
		
		public function get InfoObj() : Array
		{
			return this._InfoObj;
		}
		
		public function set InfoObj(aNewArray:Array) : *
		{
			this._InfoObj = aNewArray;
		}
		
		public function set showItemDesc(aVal:Boolean) : *
		{
			this._showItemDesc = aVal;
		}
		
		public function onDataChange() : *
		{
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var newEntry:ItemCard_Entry = null;
			var descriptionEntry:Object = null;
			var entryType:uint = 0;
			super.redrawUIComponent();
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			this.currY = 0;
			var hasDMGEntry:Boolean = false;
			var hasDREntry:Boolean = false;
			for(var dataIdx:int = this._InfoObj.length - 1; dataIdx >= 0; dataIdx--)
			{
				if(this._InfoObj[dataIdx].text == ItemCard_MultiEntry.DMG_WEAP_ID)
				{
					hasDMGEntry = hasDMGEntry || ItemCard_MultiEntry.IsEntryValid(this._InfoObj[dataIdx]);
				}
				else if(this._InfoObj[dataIdx].text == ItemCard_MultiEntry.DMG_ARMO_ID)
				{
					hasDREntry = hasDREntry || ItemCard_MultiEntry.IsEntryValid(this._InfoObj[dataIdx]);
				}
				else if(this._InfoObj[dataIdx].showAsDescription == true)
				{
					descriptionEntry = !!this._showItemDesc?this._InfoObj[dataIdx]:null;
				}
				else
				{
					entryType = this.GetEntryType(this._InfoObj[dataIdx]);
					newEntry = this.CreateEntry(entryType);
					if(newEntry != null)
					{
						newEntry.PopulateEntry(this._InfoObj[dataIdx]);
						addChild(newEntry);
						newEntry.y = this.currY - newEntry.height;
						this.currY = this.currY - (newEntry.height + this.ENTRY_SPACING);
					}
				}
			}
			if(hasDMGEntry || hasDREntry)
			{
				newEntry = this.CreateEntry(!!hasDMGEntry?uint(this.ET_DMG_WEAP):uint(this.ET_DMG_ARMO));
				if(newEntry != null)
				{
					(newEntry as ItemCard_MultiEntry).PopulateMultiEntry(this._InfoObj,!!hasDMGEntry?ItemCard_MultiEntry.DMG_WEAP_ID:ItemCard_MultiEntry.DMG_ARMO_ID);
					addChild(newEntry);
					newEntry.y = this.currY - newEntry.height;
					this.currY = this.currY - (newEntry.height + this.ENTRY_SPACING);
				}
			}
			if(descriptionEntry != null)
			{
				newEntry = this.CreateEntry(this.ET_ITEM_DESCRIPTION);
				if(newEntry != null)
				{
					newEntry.PopulateEntry(descriptionEntry);
					addChild(newEntry);
					newEntry.y = this.currY - newEntry.height;
					this.currY = this.currY - (newEntry.height + this.ENTRY_SPACING);
				}
				descriptionEntry = null;
			}
		}
		
		private function GetEntryType(aEntryObj:Object) : uint
		{
			var returnVal:uint = this.ET_STANDARD;
			if(aEntryObj.damageType == 10)
			{
				returnVal = this.ET_AMMO;
			}
			else if(aEntryObj.duration != null && aEntryObj.duration > 0)
			{
				returnVal = this.ET_TIMED_EFFECT;
			}
			else if(aEntryObj.components is Array)
			{
				returnVal = this.ET_COMPONENTS_LIST;
			}
			return returnVal;
		}
		
		private function CreateEntry(aEntryType:uint) : ItemCard_Entry
		{
			var returnVal:ItemCard_Entry = null;
			switch(aEntryType)
			{
				case this.ET_STANDARD:
					returnVal = new ItemCard_StandardEntry();
					break;
				case this.ET_AMMO:
					returnVal = new ItemCard_AmmoEntry();
					break;
				case this.ET_DMG_WEAP:
				case this.ET_DMG_ARMO:
					returnVal = new ItemCard_MultiEntry();
					break;
				case this.ET_TIMED_EFFECT:
					returnVal = new ItemCard_TimedEntry();
					break;
				case this.ET_COMPONENTS_LIST:
					returnVal = new ItemCard_ComponentsEntry();
					break;
				case this.ET_ITEM_DESCRIPTION:
					returnVal = new ItemCard_DescriptionEntry();
			}
			return returnVal;
		}
	}
}
