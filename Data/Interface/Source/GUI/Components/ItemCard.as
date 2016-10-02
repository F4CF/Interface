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
		
		public function set InfoObj(param1:Array) : *
		{
			this._InfoObj = param1;
		}
		
		public function set showItemDesc(param1:Boolean) : *
		{
			this._showItemDesc = param1;
		}
		
		public function onDataChange() : *
		{
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:ItemCard_Entry = null;
			var _loc4_:Object = null;
			var _loc6_:uint = 0;
			super.redrawUIComponent();
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			this.currY = 0;
			var _loc2_:Boolean = false;
			var _loc3_:Boolean = false;
			var _loc5_:int = this._InfoObj.length - 1;
			while(_loc5_ >= 0)
			{
				if(this._InfoObj[_loc5_].text == ItemCard_MultiEntry.DMG_WEAP_ID)
				{
					_loc2_ = _loc2_ || ItemCard_MultiEntry.IsEntryValid(this._InfoObj[_loc5_]);
				}
				else if(this._InfoObj[_loc5_].text == ItemCard_MultiEntry.DMG_ARMO_ID)
				{
					_loc3_ = _loc3_ || ItemCard_MultiEntry.IsEntryValid(this._InfoObj[_loc5_]);
				}
				else if(this._InfoObj[_loc5_].showAsDescription == true)
				{
					_loc4_ = !!this._showItemDesc?this._InfoObj[_loc5_]:null;
				}
				else
				{
					_loc6_ = this.GetEntryType(this._InfoObj[_loc5_]);
					_loc1_ = this.CreateEntry(_loc6_);
					if(_loc1_ != null)
					{
						_loc1_.PopulateEntry(this._InfoObj[_loc5_]);
						addChild(_loc1_);
						_loc1_.y = this.currY - _loc1_.height;
						this.currY = this.currY - (_loc1_.height + this.ENTRY_SPACING);
					}
				}
				_loc5_--;
			}
			if(_loc2_)
			{
				_loc1_ = this.CreateEntry(this.ET_DMG_WEAP);
				if(_loc1_ != null)
				{
					(_loc1_ as ItemCard_MultiEntry).PopulateMultiEntry(this._InfoObj,ItemCard_MultiEntry.DMG_WEAP_ID);
					addChild(_loc1_);
					_loc1_.y = this.currY - _loc1_.height;
					this.currY = this.currY - (_loc1_.height + this.ENTRY_SPACING);
				}
			}
			if(_loc3_)
			{
				_loc1_ = this.CreateEntry(this.ET_DMG_ARMO);
				if(_loc1_ != null)
				{
					(_loc1_ as ItemCard_MultiEntry).PopulateMultiEntry(this._InfoObj,ItemCard_MultiEntry.DMG_ARMO_ID);
					addChild(_loc1_);
					_loc1_.y = this.currY - _loc1_.height;
					this.currY = this.currY - (_loc1_.height + this.ENTRY_SPACING);
				}
			}
			if(_loc4_ != null)
			{
				_loc1_ = this.CreateEntry(this.ET_ITEM_DESCRIPTION);
				if(_loc1_ != null)
				{
					_loc1_.PopulateEntry(_loc4_);
					addChild(_loc1_);
					_loc1_.y = this.currY - _loc1_.height;
					this.currY = this.currY - (_loc1_.height + this.ENTRY_SPACING);
				}
				_loc4_ = null;
			}
		}
		
		private function GetEntryType(param1:Object) : uint
		{
			var _loc2_:uint = this.ET_STANDARD;
			if(param1.damageType == 10)
			{
				_loc2_ = this.ET_AMMO;
			}
			else if(param1.duration != null && param1.duration > 0)
			{
				_loc2_ = this.ET_TIMED_EFFECT;
			}
			else if(param1.components is Array)
			{
				_loc2_ = this.ET_COMPONENTS_LIST;
			}
			return _loc2_;
		}
		
		private function CreateEntry(param1:uint) : ItemCard_Entry
		{
			var _loc2_:ItemCard_Entry = null;
			switch(param1)
			{
				case this.ET_STANDARD:
					_loc2_ = new ItemCard_StandardEntry();
					break;
				case this.ET_AMMO:
					_loc2_ = new ItemCard_AmmoEntry();
					break;
				case this.ET_DMG_WEAP:
				case this.ET_DMG_ARMO:
					_loc2_ = new ItemCard_MultiEntry();
					break;
				case this.ET_TIMED_EFFECT:
					_loc2_ = new ItemCard_TimedEntry();
					break;
				case this.ET_COMPONENTS_LIST:
					_loc2_ = new ItemCard_ComponentsEntry();
					break;
				case this.ET_ITEM_DESCRIPTION:
					_loc2_ = new ItemCard_DescriptionEntry();
			}
			return _loc2_;
		}
	}
}
