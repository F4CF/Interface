package
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.text.TextField;
	import Shared.GlobalFunc;
	
	public class TurretListEntry extends BSScrollingListEntry
	{
		 
		
		public var Toggle_tf:TextField;
		
		public function TurretListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			GlobalFunc.SetText(this.Toggle_tf,!!param1.enabled?"(*)":"(_)",false);
			this.Toggle_tf.textColor = !!this.selected?uint(0):uint(16777215);
		}
	}
}
