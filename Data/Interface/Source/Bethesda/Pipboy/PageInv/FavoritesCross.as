package
{
	import Shared.AS3.BSUIComponent;
	import Shared.CustomEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class FavoritesCross extends BSUIComponent
	{
		
		public static const SELECTION_UPDATE:String = "FavoritesCross::selectionUpdate";
		
		public static const ITEM_PRESS:String = "FavoritesCross::itemPress";
		
		public static const FS_LEFT_3:uint = 0;
		
		public static const FS_LEFT_2:uint = 1;
		
		public static const FS_LEFT_1:uint = 2;
		
		public static const FS_RIGHT_1:uint = 3;
		
		public static const FS_RIGHT_2:uint = 4;
		
		public static const FS_RIGHT_3:uint = 5;
		
		public static const FS_UP_3:uint = 6;
		
		public static const FS_UP_2:uint = 7;
		
		public static const FS_UP_1:uint = 8;
		
		public static const FS_DOWN_1:uint = 9;
		
		public static const FS_DOWN_2:uint = 10;
		
		public static const FS_DOWN_3:uint = 11;
		
		public static const FS_NONE:uint = 12;
		 
		
		public var EntryHolder_mc:MovieClip;
		
		public var Selection_mc:MovieClip;
		
		private var _FavoritesInfoA:Array;
		
		private var _SelectedIndex:uint;
		
		private var _HideEmptySlots:Boolean;
		
		private var OverEntry:Boolean = false;
		
		private const _UpDirectory:Array = [FS_UP_1,FS_UP_1,FS_UP_1,FS_UP_1,FS_UP_1,FS_UP_1,FS_UP_3,FS_UP_3,FS_UP_2,FS_UP_1,FS_DOWN_1,FS_DOWN_2,FS_UP_1];
		
		private const _DownDirectory:Array = [FS_DOWN_1,FS_DOWN_1,FS_DOWN_1,FS_DOWN_1,FS_DOWN_1,FS_DOWN_1,FS_UP_2,FS_UP_1,FS_DOWN_1,FS_DOWN_2,FS_DOWN_3,FS_DOWN_3,FS_DOWN_1];
		
		private const _LeftDirectory:Array = [FS_LEFT_3,FS_LEFT_3,FS_LEFT_2,FS_LEFT_1,FS_RIGHT_1,FS_RIGHT_2,FS_LEFT_1,FS_LEFT_1,FS_LEFT_1,FS_LEFT_1,FS_LEFT_1,FS_LEFT_1,FS_LEFT_1];
		
		private const _RightDirectory:Array = [FS_LEFT_2,FS_LEFT_1,FS_RIGHT_1,FS_RIGHT_2,FS_RIGHT_3,FS_RIGHT_3,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_1];
		
		private const _InDirectory:Array = [FS_LEFT_2,FS_LEFT_1,FS_LEFT_1,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_2,FS_UP_2,FS_UP_1,FS_UP_1,FS_DOWN_1,FS_DOWN_1,FS_DOWN_2,FS_NONE];
		
		private const _OutDirectory:Array = [FS_LEFT_3,FS_LEFT_3,FS_LEFT_2,FS_RIGHT_2,FS_RIGHT_3,FS_RIGHT_3,FS_UP_3,FS_UP_3,FS_UP_2,FS_DOWN_2,FS_DOWN_3,FS_DOWN_3,FS_NONE];
		
		public function FavoritesCross()
		{
			super();
			this._SelectedIndex = FS_NONE;
			this._HideEmptySlots = false;
			addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			addEventListener(FavoritesEntry.MOUSE_OVER,this.onFavEntryMouseover);
			addEventListener(FavoritesEntry.MOUSE_LEAVE,this.onFavEntryMouseleave);
		}
		
		public function CanAcceptAimlessClicking() : Boolean
		{
			return this._SelectedIndex != FS_NONE && !this.OverEntry;
		}
		
		public function set infoArray(param1:Array) : *
		{
			this._FavoritesInfoA = param1;
			var _loc2_:int = this._SelectedIndex;
			this.selectedIndex = this.ClampSelection(this.selectedIndex);
			dispatchEvent(new CustomEvent(SELECTION_UPDATE,_loc2_,true,true));
			SetIsDirty();
		}
		
		public function get selectedIndex() : uint
		{
			return this._SelectedIndex;
		}
		
		public function set selectedIndex(param1:uint) : *
		{
			var _loc3_:int = 0;
			var _loc2_:int = this.ClampSelection(param1);
			if(this._SelectedIndex != _loc2_)
			{
				_loc3_ = this._SelectedIndex;
				this._SelectedIndex = _loc2_;
				dispatchEvent(new CustomEvent(SELECTION_UPDATE,_loc3_,true,true));
				SetIsDirty();
			}
		}
		
		public function get selectedEntry() : Object
		{
			return this._FavoritesInfoA != null && this._SelectedIndex >= 0 && this._SelectedIndex < this._FavoritesInfoA.length?this._FavoritesInfoA[this._SelectedIndex]:null;
		}
		
		public function set hideEmptySlots(param1:Boolean) : *
		{
			this._HideEmptySlots = param1;
			this.selectedIndex = this.ClampSelection(this.selectedIndex);
			SetIsDirty();
		}
		
		public function get selectionSound() : String
		{
			var _loc1_:String = "";
			switch(this.selectedIndex)
			{
				case FS_UP_1:
				case FS_DOWN_1:
				case FS_LEFT_1:
				case FS_RIGHT_1:
					_loc1_ = "UIPipBoyFavoriteMenuDPadA";
					break;
				case FS_UP_2:
				case FS_DOWN_2:
				case FS_LEFT_2:
				case FS_RIGHT_2:
					_loc1_ = "UIPipBoyFavoriteMenuDPadB";
					break;
				case FS_UP_3:
				case FS_DOWN_3:
				case FS_LEFT_3:
				case FS_RIGHT_3:
					_loc1_ = "UIPipBoyFavoriteMenuDPadC";
			}
			return _loc1_;
		}
		
		public function GetEntryClip(param1:uint) : FavoritesEntry
		{
			return this.EntryHolder_mc.getChildByName("Entry_" + param1) as FavoritesEntry;
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc3_:Object = null;
			var _loc4_:FavoritesEntry = null;
			var _loc5_:Boolean = false;
			super.redrawUIComponent();
			var _loc1_:uint = 0;
			while(this._FavoritesInfoA != null && _loc1_ < this._FavoritesInfoA.length)
			{
				_loc3_ = this._FavoritesInfoA[_loc1_];
				_loc4_ = this.GetEntryClip(_loc1_);
				_loc5_ = false;
				if(_loc4_ != null)
				{
					if(_loc3_ != null)
					{
						_loc4_.Icon_mc.gotoAndStop(_loc3_.FavIconType);
					}
					else
					{
						_loc4_.Icon_mc.gotoAndStop(1);
					}
					_loc4_.visible = !this._HideEmptySlots || !this.ShouldHideSlot(_loc1_);
				}
				_loc1_++;
			}
			var _loc2_:FavoritesEntry = this.GetEntryClip(this.selectedIndex);
			if(_loc2_ != null)
			{
				this.Selection_mc.x = this.EntryHolder_mc.x + _loc2_.x;
				this.Selection_mc.y = this.EntryHolder_mc.y + _loc2_.y;
				this.Selection_mc.visible = true;
			}
			else
			{
				this.Selection_mc.visible = false;
			}
		}
		
		private function ShouldHideSlot(param1:uint) : Boolean
		{
			return this._FavoritesInfoA == null || this._FavoritesInfoA[param1] == null && this._FavoritesInfoA[this._OutDirectory[param1]] == null && this._FavoritesInfoA[this._OutDirectory[this._OutDirectory[param1]]] == null && param1 != FS_UP_1 && param1 != FS_DOWN_1 && param1 != FS_LEFT_1 && param1 != FS_RIGHT_1;
		}
		
		private function ClampSelection(param1:uint) : uint
		{
			var _loc2_:int = param1;
			if(this._HideEmptySlots)
			{
				if(this.ShouldHideSlot(_loc2_))
				{
					_loc2_ = this._InDirectory[_loc2_];
				}
				if(this.ShouldHideSlot(_loc2_))
				{
					_loc2_ = this._InDirectory[_loc2_];
				}
				if(this.ShouldHideSlot(_loc2_))
				{
					_loc2_ = FS_NONE;
				}
			}
			return _loc2_;
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc4_:Number = NaN;
			var _loc3_:Boolean = false;
			if(!param2)
			{
				_loc3_ = true;
				switch(param1)
				{
					case "PrimaryAttack":
						if(this.CanAcceptAimlessClicking())
						{
							dispatchEvent(new Event(ITEM_PRESS,true,true));
						}
						break;
					default:
						_loc4_ = Number(param1.substr(8));
						if(_loc4_ >= 1 && _loc4_ <= FS_NONE)
						{
							this.selectedIndex = _loc4_ - 1;
							this.SelectItem();
						}
						else
						{
							_loc3_ = false;
						}
				}
			}
			return _loc3_;
		}
		
		public function onKeyUp(param1:KeyboardEvent) : *
		{
			switch(param1.keyCode)
			{
				case Keyboard.UP:
					this.selectedIndex = this.ClampSelection(this._UpDirectory[this.selectedIndex]);
					break;
				case Keyboard.DOWN:
					this.selectedIndex = this.ClampSelection(this._DownDirectory[this.selectedIndex]);
					break;
				case Keyboard.LEFT:
					this.selectedIndex = this.ClampSelection(this._LeftDirectory[this.selectedIndex]);
					break;
				case Keyboard.RIGHT:
					this.selectedIndex = this.ClampSelection(this._RightDirectory[this.selectedIndex]);
					break;
				case Keyboard.ENTER:
					if(this.selectedIndex != FS_NONE)
					{
						this.SelectItem();
						param1.stopPropagation();
					}
			}
		}
		
		public function SelectItem() : *
		{
			dispatchEvent(new Event(ITEM_PRESS,true,true));
		}
		
		protected function onFavEntryMouseover(param1:Event) : *
		{
			this.selectedIndex = param1.target.entryIndex;
			this.OverEntry = true;
		}
		
		protected function onFavEntryMouseleave(param1:Event) : *
		{
			this.OverEntry = false;
		}
	}
}
