package
{
	import Shared.AS3.BSScrollingListFadeEntry;
	import flash.text.TextField;
	
	public class ItemSelectListEntry extends BSScrollingListFadeEntry
	{
		 
		
		public var count:TextField;
		
		public function ItemSelectListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			if(param1.invCount > 1)
			{
				param1.text = param1.name + " (" + param1.invCount + ")";
			}
			else
			{
				param1.text = param1.name;
			}
			super.SetEntryText(param1,param2);
			this.count.text = (param1.usedCount * param1.componentCountA[param1.filterIndex]).toString() + "/" + param1.componentCountA[param1.filterIndex];
			this.border.height = this.textField.textHeight + 2;
			this.count.textColor = !!this.selected?uint(0):uint(16777215);
		}
	}
}
