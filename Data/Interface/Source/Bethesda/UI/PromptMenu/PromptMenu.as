package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class PromptMenu extends IMenu
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var PromptMenuPanel_mc:MovieClip;
		
		public function PromptMenu()
		{
			super();
			this.BGSCodeObj = new Object();
		}
		
		override protected function onSetSafeRect() : void
		{
			GlobalFunc.LockToSafeRect(this.PromptMenuPanel_mc,"TL",SafeX,SafeY);
		}
		
		public function set message(param1:String) : *
		{
			var _loc5_:Array = null;
			var _loc2_:BSUIComponent = this.PromptMenuPanel_mc.MessageHolder_mc as BSUIComponent;
			var _loc3_:TextField = _loc2_.textField;
			_loc3_.autoSize = TextFieldAutoSize.LEFT;
			var _loc4_:Array = param1.split("[");
			if(_loc4_.length > 1)
			{
				_loc5_ = _loc4_[1].split("]");
				GlobalFunc.SetText(_loc3_,_loc4_[0] + this.BGSCodeObj.getButtonFromUserEvent(_loc5_[0]) + _loc5_[1],true);
			}
			else
			{
				GlobalFunc.SetText(_loc3_,param1,true);
			}
			_loc2_.SetIsDirty();
		}
		
		public function onCodeObjDestruction() : *
		{
			this.BGSCodeObj = null;
		}
	}
}
