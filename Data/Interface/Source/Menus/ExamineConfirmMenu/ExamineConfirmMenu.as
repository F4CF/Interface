package
{
	import Shared.IMenu;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	public class ExamineConfirmMenu extends IMenu
	{
		 
		
		public var BGRect_mc:TextField;
		
		public var Confirm_mc:ConfirmPanel;
		
		public var BGSCodeObj:Object;
		
		public function ExamineConfirmMenu()
		{
			super();
			this.BGSCodeObj = new Object();
			addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
		}
		
		public function onKeyDown(param1:KeyboardEvent) : void
		{
			if(param1.keyCode == Keyboard.ENTER)
			{
				this.BGSCodeObj.OnAcceptPress();
			}
		}
		
		public function onCodeObjCreate() : *
		{
			this.Confirm_mc.InitCodeObj(this.BGSCodeObj);
		}
		
		public function onCodeObjDestruction() : *
		{
			this.Confirm_mc.ReleaseCodeObj();
		}
	}
}
