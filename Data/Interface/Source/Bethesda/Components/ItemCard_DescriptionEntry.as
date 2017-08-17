package Components
{
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	import scaleform.gfx.TextFieldEx;
	
	public class ItemCard_DescriptionEntry extends ItemCard_Entry
	{
		 
		
		public var Background_mc:MovieClip;
		
		public function ItemCard_DescriptionEntry()
		{
			super();
			TextFieldEx.setTextAutoSize(Label_tf,TextFieldEx.TEXTAUTOSZ_NONE);
			Label_tf.autoSize = TextFieldAutoSize.LEFT;
			Label_tf.multiline = true;
			Label_tf.wordWrap = true;
		}
		
		override public function PopulateEntry(param1:Object) : *
		{
			super.PopulateEntry(param1);
			this.Background_mc.height = Label_tf.textHeight + 5;
		}
	}
}
