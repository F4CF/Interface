package
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;

	public class ItemListEntry extends BSScrollingListEntry
	{


		public var LeftIcon_mc:MovieClip;

		public var FavoriteIcon_mc:MovieClip;

		public var LegendaryIcon_mc:MovieClip;

		public var TaggedForSearchIcon_mc:MovieClip;

		private var BaseTextFieldWidth;

		public function ItemListEntry()
		{
			super();
			this.BaseTextFieldWidth = textField.width;
		}

		override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
		{
			this.TaggedForSearchIcon_mc.visible = aEntryObject.taggedForSearch == true;
			this.FavoriteIcon_mc.visible = aEntryObject.favorite > 0;
			this.LegendaryIcon_mc.visible = aEntryObject.isLegendary == true;
			var textFieldWidthDelta:* = 0;
			if(this.FavoriteIcon_mc.visible && this.TaggedForSearchIcon_mc.visible)
			{
				textFieldWidthDelta = textFieldWidthDelta + (this.FavoriteIcon_mc.width / 2 + 10);
			}
			if(this.LegendaryIcon_mc.visible && this.FavoriteIcon_mc.visible)
			{
				textFieldWidthDelta = textFieldWidthDelta + (this.LegendaryIcon_mc.width / 2 + 10);
			}
			textField.width = this.BaseTextFieldWidth - textFieldWidthDelta;
			super.SetEntryText(aEntryObject,astrTextOption);
			var barterCount:int = 0;
			if(aEntryObject.barterCount != undefined)
			{
				barterCount = aEntryObject.barterCount;
			}
			var displayCount:int = aEntryObject.count - barterCount;
			GlobalFunc.SetText(textField,textField.text,false,false,true);
			if(displayCount != 1)
			{
				textField.appendText(" (" + displayCount + ")");
			}
			GlobalFunc.SetText(textField,textField.text,false);
			var colorTrans:ColorTransform = this.LeftIcon_mc.transform.colorTransform;
			colorTrans.redOffset = !!this.selected?Number(-255):Number(0);
			colorTrans.greenOffset = !!this.selected?Number(-255):Number(0);
			colorTrans.blueOffset = !!this.selected?Number(-255):Number(0);
			this.LeftIcon_mc.transform.colorTransform = colorTrans;
			this.LeftIcon_mc.EquipIcon_mc.visible = aEntryObject.equipState != 0;
			this.LeftIcon_mc.BestIcon_mc.visible = aEntryObject.inContainer && aEntryObject.bestInClass == true;
			if(this.LeftIcon_mc.BarterIcon_mc != undefined)
			{
				this.LeftIcon_mc.BarterIcon_mc.visible = barterCount < 0;
			}
			this.TaggedForSearchIcon_mc.x = this.textField.getLineMetrics(0).width + this.textField.x + 10;
			this.LegendaryIcon_mc.x = !!this.TaggedForSearchIcon_mc.visible?Number(this.TaggedForSearchIcon_mc.x + this.TaggedForSearchIcon_mc.width / 2 + 10):Number(this.TaggedForSearchIcon_mc.x);
			this.FavoriteIcon_mc.x = !!this.LegendaryIcon_mc.visible?Number(this.LegendaryIcon_mc.x + this.LegendaryIcon_mc.width / 2 + 10):!!this.TaggedForSearchIcon_mc.visible?Number(this.TaggedForSearchIcon_mc.x + this.TaggedForSearchIcon_mc.width / 2 + 10):Number(this.TaggedForSearchIcon_mc.x);
			colorTrans = this.FavoriteIcon_mc.transform.colorTransform;
			colorTrans.redOffset = !!this.selected?Number(-255):Number(0);
			colorTrans.greenOffset = !!this.selected?Number(-255):Number(0);
			colorTrans.blueOffset = !!this.selected?Number(-255):Number(0);
			this.FavoriteIcon_mc.transform.colorTransform = colorTrans;
			colorTrans = this.TaggedForSearchIcon_mc.transform.colorTransform;
			colorTrans.redOffset = !!this.selected?Number(-255):Number(0);
			colorTrans.greenOffset = !!this.selected?Number(-255):Number(0);
			colorTrans.blueOffset = !!this.selected?Number(-255):Number(0);
			this.TaggedForSearchIcon_mc.transform.colorTransform = colorTrans;
			colorTrans = this.LegendaryIcon_mc.transform.colorTransform;
			colorTrans.redOffset = !!this.selected?Number(-255):Number(0);
			colorTrans.greenOffset = !!this.selected?Number(-255):Number(0);
			colorTrans.blueOffset = !!this.selected?Number(-255):Number(0);
			this.LegendaryIcon_mc.transform.colorTransform = colorTrans;
		}


	}
}
