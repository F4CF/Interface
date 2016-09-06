package
{
	import Shared.AS3.BSUIComponent;
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSButtonHintBar;
	
	public class ISubmenu extends BSUIComponent
	{
		 
		
		protected var _CodeObj:Object;
		
		protected var _ButtonData:Vector.<BSButtonHintData>;
		
		protected var _ButtonHintBar:BSButtonHintBar;
		
		public function ISubmenu()
		{
			super();
			this._ButtonData = new Vector.<BSButtonHintData>();
		}
		
		public function get codeObj() : Object
		{
			return this._CodeObj;
		}
		
		public function set codeObj(param1:Object) : *
		{
			this._CodeObj = param1;
		}
		
		public function get buttonHintBar() : BSButtonHintBar
		{
			return this._ButtonHintBar;
		}
		
		public function set buttonHintBar(param1:BSButtonHintBar) : *
		{
			this._ButtonHintBar = param1;
		}
		
		public function get buttonData() : Vector.<BSButtonHintData>
		{
			return this._ButtonData;
		}
		
		override public function onRemovedFromStage() : void
		{
			super.onRemovedFromStage();
			this.buttonHintBar = null;
			this.codeObj = null;
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			return false;
		}
		
		public function OnRightStickInput(param1:Number, param2:Number) : *
		{
		}
	}
}
