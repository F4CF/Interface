package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import Shared.GlobalFunc;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	
	public class Option_Checkbox extends MovieClip
	{
		
		public static const VALUE_CHANGE:String = "Option_Checkbox::VALUE_CHANGE";
		 
		
		public var textField:TextField;
		
		private var bChecked:Boolean;
		
		public function Option_Checkbox()
		{
			super();
			this.bChecked = false;
			addEventListener(MouseEvent.CLICK,this.onClick);
		}
		
		public function get checked() : Boolean
		{
			return this.bChecked;
		}
		
		public function set checked(param1:Boolean) : *
		{
			this.bChecked = param1;
			GlobalFunc.SetText(this.textField,!!this.bChecked?"$ON":"$OFF",false);
		}
		
		private function Toggle() : *
		{
			this.checked = !this.checked;
			dispatchEvent(new Event(VALUE_CHANGE,true,true));
		}
		
		public function onItemPressed() : *
		{
			this.Toggle();
		}
		
		public function HandleKeyboardInput(param1:KeyboardEvent) : *
		{
			if(param1.keyCode == Keyboard.ENTER)
			{
				this.Toggle();
				param1.stopPropagation();
			}
		}
		
		private function onClick(param1:MouseEvent) : *
		{
			this.Toggle();
			param1.stopPropagation();
		}
	}
}
