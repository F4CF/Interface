package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public dynamic class QuickContainerItem extends BSUIComponent
	{
		 
		
		public var ItemName_tf:TextField;
		
		public var LegendaryIcon_mc:MovieClip;
		
		public var TaggedForSearchIcon_mc:MovieClip;
		
		public var FavoriteIcon_mc:MovieClip;
		
		public var BetterIcon_mc:MovieClip;
		
		public var SelectionIndicator_mc:MovieClip;
		
		private var BaseTextFieldWidth:uint;
		
		private var _data:QuickContainerItemData;
		
		private var _selected:Boolean;
		
		public function QuickContainerItem()
		{
			super();
			this.BaseTextFieldWidth = this.ItemName_tf.width;
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.ItemName_tf,"shrink");
			visible = false;
			this._data = null;
		}
		
		public function get data() : QuickContainerItemData
		{
			return this._data;
		}
		
		public function set data(param1:QuickContainerItemData) : void
		{
			this._data = param1;
			SetIsDirty();
		}
		
		public function get selected() : Boolean
		{
			return this._selected;
		}
		
		public function set selected(param1:Boolean) : void
		{
			this._selected = param1;
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:uint = 0;
			if(this.data)
			{
				visible = true;
				_loc1_ = this.CalcIconWidth();
				this.ItemName_tf.width = this.BaseTextFieldWidth - _loc1_;
				if(this.data.count > 1)
				{
					GlobalFunc.SetText(this.ItemName_tf,this.data.text + " (" + this.data.count + ")",false,false,true);
				}
				else
				{
					GlobalFunc.SetText(this.ItemName_tf,this.data.text,false,false,true);
				}
				this.ItemName_tf.textColor = !!this.selected?uint(0):uint(16777215);
				this.SelectionIndicator_mc.alpha = !!this.selected?Number(1):Number(0);
				this.AddIconsToEntry();
			}
			else
			{
				visible = false;
			}
		}
		
		public function CalcIconWidth() : uint
		{
			var _loc1_:uint = 0;
			if(this.data.taggedForSearch || this.data.isLegendary || this.data.favorite || this.data.isBetterThanEquippedItem)
			{
				_loc1_ = 4;
				if(this.data.taggedForSearch)
				{
					_loc1_ = _loc1_ + (this.TaggedForSearchIcon_mc.width + 2);
				}
				if(this.data.isLegendary)
				{
					_loc1_ = _loc1_ + (this.LegendaryIcon_mc.width + 2);
				}
				if(this.data.favorite)
				{
					_loc1_ = _loc1_ + (this.FavoriteIcon_mc.width + 2);
				}
				if(this.data.isBetterThanEquippedItem)
				{
					_loc1_ = _loc1_ + this.BetterIcon_mc.width;
				}
			}
			return _loc1_;
		}
		
		public function AddIconsToEntry() : *
		{
			var _loc1_:ColorTransform = this.FavoriteIcon_mc.transform.colorTransform;
			_loc1_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc1_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc1_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.FavoriteIcon_mc.transform.colorTransform = _loc1_;
			_loc1_ = this.TaggedForSearchIcon_mc.transform.colorTransform;
			_loc1_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc1_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc1_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.TaggedForSearchIcon_mc.transform.colorTransform = _loc1_;
			_loc1_ = this.LegendaryIcon_mc.transform.colorTransform;
			_loc1_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc1_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc1_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.LegendaryIcon_mc.transform.colorTransform = _loc1_;
			_loc1_ = this.BetterIcon_mc.transform.colorTransform;
			_loc1_.redOffset = !!this.selected?Number(-255):Number(0);
			_loc1_.greenOffset = !!this.selected?Number(-255):Number(0);
			_loc1_.blueOffset = !!this.selected?Number(-255):Number(0);
			this.BetterIcon_mc.transform.colorTransform = _loc1_;
			var _loc2_:Number = 4 + this.ItemName_tf.getLineMetrics(0).width + this.ItemName_tf.getLineMetrics(0).x + this.ItemName_tf.x;
			this.TaggedForSearchIcon_mc.visible = this.data.taggedForSearch;
			this.TaggedForSearchIcon_mc.x = _loc2_;
			if(this.data.taggedForSearch)
			{
				_loc2_ = _loc2_ + (this.TaggedForSearchIcon_mc.width + 2);
			}
			this.LegendaryIcon_mc.visible = this.data.isLegendary;
			this.LegendaryIcon_mc.x = _loc2_;
			if(this.data.isLegendary)
			{
				_loc2_ = _loc2_ + (this.LegendaryIcon_mc.width + 2);
			}
			this.FavoriteIcon_mc.visible = this.data.favorite;
			this.FavoriteIcon_mc.x = _loc2_;
			if(this.data.favorite)
			{
				_loc2_ = _loc2_ + (this.FavoriteIcon_mc.width + 2);
			}
			this.BetterIcon_mc.visible = this.data.isBetterThanEquippedItem;
			this.BetterIcon_mc.x = _loc2_;
			if(this.data.isBetterThanEquippedItem)
			{
				_loc2_ = _loc2_ + this.BetterIcon_mc.width;
			}
		}
	}
}
