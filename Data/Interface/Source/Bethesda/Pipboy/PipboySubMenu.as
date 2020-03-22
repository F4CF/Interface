package
{
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.BSUIComponent;
	import flash.geom.ColorTransform;
	
	public class PipboySubMenu extends BSUIComponent
	{
		
		private static const READ_ONLY_LIST_COLOR_MULTIPLIER:Number = 0.5;
		
		public static const READ_ONLY_NONE:int = 0;
		
		public static const READ_ONLY_DEFAULT:int = 1;
		
		public static const READ_ONLY_OFFLINE:int = 2;
		
		public static const READ_ONLY_DEMO:int = 3;
		 
		
		protected var BGSCodeObj:Object;
		
		protected var _ReadOnlyMode:Boolean;
		
		public var _ReadOnlyModeType:int;
		
		public function PipboySubMenu()
		{
			super();
			this._ReadOnlyMode = false;
			this._ReadOnlyModeType = READ_ONLY_NONE;
		}
		
		protected static function SetScrollingListReadOnly(param1:BSScrollingList, param2:Boolean) : void
		{
			var _loc3_:ColorTransform = param1.transform.colorTransform;
			var _loc4_:Number = !!param2?Number(READ_ONLY_LIST_COLOR_MULTIPLIER):Number(1);
			_loc3_.redMultiplier = _loc4_;
			_loc3_.greenMultiplier = _loc4_;
			_loc3_.blueMultiplier = _loc4_;
			param1.transform.colorTransform = _loc3_;
		}
		
		public function InitCodeObj(param1:Object) : *
		{
			this.BGSCodeObj = param1;
		}
		
		public function ReleaseCodeObj() : *
		{
			this.BGSCodeObj = null;
		}
		
		public function get codeObj() : Object
		{
			return this.BGSCodeObj;
		}
		
		override public function onAddedToStage() : void
		{
			super.onAddedToStage();
			PipboyChangeEvent.Register(stage,this.onPipboyChangeEventInternal);
		}
		
		override public function onRemovedFromStage() : void
		{
			PipboyChangeEvent.Unregister(stage,this.onPipboyChangeEventInternal);
			this.ReleaseCodeObj();
			super.onRemovedFromStage();
		}
		
		private function onPipboyChangeEventInternal(param1:PipboyChangeEvent) : void
		{
			if(param1.UpdateMask.Intersects(PipboyUpdateMask.ReadOnly))
			{
				if(this._ReadOnlyModeType != param1.DataObj.ReadOnlyMode)
				{
					this._ReadOnlyMode = param1.DataObj.ReadOnlyMode != READ_ONLY_NONE;
					this._ReadOnlyModeType = param1.DataObj.ReadOnlyMode;
					this.onReadOnlyChanged(this._ReadOnlyMode);
				}
			}
			if(param1.UpdateMask.Intersects(this.GetUpdateMask()))
			{
				this.onPipboyChangeEvent(param1);
			}
		}
		
		protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
		}
		
		protected function onReadOnlyChanged(param1:Boolean) : void
		{
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			return false;
		}
		
		public function GetIsUsingRightStick() : Boolean
		{
			return false;
		}
		
		public function onRightThumbstickInput(param1:uint) : *
		{
		}
		
		protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.None;
		}
	}
}
