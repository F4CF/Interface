package
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class PAWarningText extends MovieClip
	{
		 
		
		public var PowerArmorLowBatteryWarning_tf:TextField;
		
		protected var BGSCodeObj:Object;
		
		public function PAWarningText()
		{
			super();
		}
		
		public function set warningText(param1:String) : *
		{
			var _loc3_:Array = null;
			var _loc2_:Array = param1.split("[");
			if(_loc2_.length > 1 && this.BGSCodeObj != null)
			{
				_loc3_ = _loc2_[1].split("]");
				GlobalFunc.SetText(this.PowerArmorLowBatteryWarning_tf,_loc2_[0] + this.BGSCodeObj.GetButtonFromUserEvent(_loc3_[0]) + _loc3_[1],true);
			}
			else
			{
				GlobalFunc.SetText(this.PowerArmorLowBatteryWarning_tf,param1,true);
			}
		}
		
		public function set codeObj(param1:Object) : *
		{
			this.BGSCodeObj = param1;
		}
	}
}
