package
{
	import Shared.CustomEvent;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.events.Event;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class FavoritesMenu extends IMenu
	{
		 
		
		public var Cross_mc:FavoritesCross;
		
		public var ItemName_tf:TextField;
		
		public var ItemAmmo_tf:TextField;
		
		public var BGSCodeObj:Object;
		
		public function FavoritesMenu()
		{
			super();
			Extensions.enabled = true;
			this.BGSCodeObj = new Object();
			this.Cross_mc.addEventListener(FavoritesCross.SELECTION_UPDATE,this.onSelectionChange);
			this.Cross_mc.addEventListener(FavoritesEntry.CLICK,this.onFavEntryClick);
			this.Cross_mc.addEventListener(FavoritesCross.ITEM_PRESS,this.onFavEntryClick);
			TextFieldEx.setTextAutoSize(this.ItemName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.ItemAmmo_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
		}
		
		override protected function onStageInit(param1:Event) : *
		{
			super.onStageInit(param1);
			stage.focus = this.Cross_mc;
			this.Cross_mc.hideEmptySlots = true;
		}
		
		override protected function onSetSafeRect() : void
		{
			GlobalFunc.LockToSafeRect(this,"BR",SafeX,SafeY);
		}
		
		public function set selectedIndex(param1:uint) : *
		{
			this.Cross_mc.selectedIndex = param1;
		}
		
		public function set favInfoArray(param1:Array) : *
		{
			this.Cross_mc.infoArray = param1;
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = this.Cross_mc.ProcessUserEvent(param1,param2);
			if(!_loc3_)
			{
				if((param1 == "Cancel" || param1 == "Quickkeys") && !param2)
				{
					this.BGSCodeObj.closeMenu();
					_loc3_ = true;
				}
			}
			return _loc3_;
		}
		
		protected function onSelectionChange(param1:Event) : *
		{
			var _loc4_:String = null;
			var _loc2_:Object = this.Cross_mc.selectedEntry;
			if(_loc2_ != null)
			{
				GlobalFunc.SetText(this.ItemName_tf,_loc2_.text,false);
				if(_loc2_.count != 1)
				{
					this.ItemName_tf.appendText(" (" + _loc2_.count + ")");
				}
				if(_loc2_.ammoText != undefined)
				{
					GlobalFunc.SetText(this.ItemAmmo_tf,_loc2_.ammoText + " (" + _loc2_.ammoCount + ")",false);
				}
				else
				{
					GlobalFunc.SetText(this.ItemAmmo_tf," ",false);
				}
			}
			else
			{
				GlobalFunc.SetText(this.ItemName_tf," ",false);
				GlobalFunc.SetText(this.ItemAmmo_tf," ",false);
			}
			var _loc3_:int = (param1 as CustomEvent).params as int;
			if(_loc3_ != this.Cross_mc.selectedIndex)
			{
				_loc4_ = this.Cross_mc.selectionSound;
				if(_loc4_ != "")
				{
					this.BGSCodeObj.PlaySound(_loc4_);
				}
			}
		}
		
		private function onFavEntryClick() : *
		{
			this.BGSCodeObj.useQuickkey(this.Cross_mc.selectedIndex);
		}
	}
}
