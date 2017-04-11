package Shared.AS3
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class BSScrollingListEntry extends MovieClip
	{
		 
		
		public var border:MovieClip;
		
		public var textField:TextField;
		
		protected var _clipIndex:uint;
		
		protected var _itemIndex:uint;
		
		protected var _selected:Boolean;
		
		public var ORIG_BORDER_HEIGHT:Number;
		
		public function BSScrollingListEntry()
		{
			super();
			Extensions.enabled = true;
			this.ORIG_BORDER_HEIGHT = this.border != null?Number(this.border.height):Number(0);
		}
		
		public function get clipIndex() : uint
		{
			return this._clipIndex;
		}
		
		public function set clipIndex(param1:uint) : *
		{
			this._clipIndex = param1;
		}
		
		public function get itemIndex() : uint
		{
			return this._itemIndex;
		}
		
		public function set itemIndex(param1:uint) : *
		{
			this._itemIndex = param1;
		}
		
		public function get selected() : Boolean
		{
			return this._selected;
		}
		
		public function set selected(param1:Boolean) : *
		{
			this._selected = param1;
		}
		
		public function SetEntryText(param1:Object, param2:String) : *
		{
			var _loc3_:Number = NaN;
			if(this.textField != null && param1 != null && param1.hasOwnProperty("text"))
			{
				if(param2 == BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT)
				{
					TextFieldEx.setTextAutoSize(this.textField,"shrink");
				}
				else if(param2 == BSScrollingList.TEXT_OPTION_MULTILINE)
				{
					this.textField.autoSize = TextFieldAutoSize.LEFT;
					this.textField.multiline = true;
					this.textField.wordWrap = true;
				}
				if(param1.text != undefined)
				{
					GlobalFunc.SetText(this.textField,param1.text,true);
				}
				else
				{
					GlobalFunc.SetText(this.textField," ",true);
				}
				this.textField.textColor = !!this.selected?uint(0):uint(16777215);
			}
			if(this.border != null)
			{
				this.border.alpha = !!this.selected?Number(GlobalFunc.SELECTED_RECT_ALPHA):Number(0);
				if(this.textField != null && param2 == BSScrollingList.TEXT_OPTION_MULTILINE && this.textField.numLines > 1)
				{
					_loc3_ = this.textField.y - this.border.y;
					this.border.height = this.textField.textHeight + _loc3_ * 2 + 5;
				}
				else
				{
					this.border.height = this.ORIG_BORDER_HEIGHT;
				}
			}
		}
	}
}
