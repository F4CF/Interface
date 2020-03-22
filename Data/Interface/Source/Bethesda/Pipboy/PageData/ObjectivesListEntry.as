package
{
	import flash.display.MovieClip;
	
	public class ObjectivesListEntry extends QuestsListEntry
	{
		 
		
		public var Background_mc:MovieClip;
		
		public function ObjectivesListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			this.Background_mc.visible = !this.selected;
			this.Background_mc.height = border.height;
		}
	}
}
