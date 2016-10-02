package Shared.AS3
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import scaleform.gfx.TextFieldEx;
	import flash.text.TextFieldAutoSize;
	import Shared.GlobalFunc;
	import scaleform.gfx.Extensions;
	
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
		
		public function set clipIndex(newIndex:uint) : *
		{
			this._clipIndex = newIndex;
		}
		
		public function get itemIndex() : uint
		{
			return this._itemIndex;
		}
		
		public function set itemIndex(newIndex:uint) : *
		{
			this._itemIndex = newIndex;
		}
		
		public function get selected() : Boolean
		{
			return this._selected;
		}
		
		public function set selected(flag:Boolean) : *
		{
			this._selected = flag;
		}
		
		public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
		{
			var vertSpacing:Number = NaN;
			if(this.textField != null && aEntryObject != null && aEntryObject.hasOwnProperty("text"))
			{
				if(astrTextOption == BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT)
				{
					TextFieldEx.setTextAutoSize(this.textField,"shrink");
				}
				else if(astrTextOption == BSScrollingList.TEXT_OPTION_MULTILINE)
				{
					this.textField.autoSize = TextFieldAutoSize.LEFT;
					this.textField.multiline = true;
					this.textField.wordWrap = true;
				}
				if(aEntryObject.text != undefined)
				{
					GlobalFunc.SetText(this.textField,aEntryObject.text,true);
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
				if(this.textField != null && astrTextOption == BSScrollingList.TEXT_OPTION_MULTILINE && this.textField.numLines > 1)
				{
					vertSpacing = this.textField.y - this.border.y;
					this.border.height = this.textField.textHeight + vertSpacing * 2 + 5;
				}
				else
				{
					this.border.height = this.ORIG_BORDER_HEIGHT;
				}
			}
		}
	}
}
