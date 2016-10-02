package bhvr.external
{
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	
	public class BGSExternalAnimation
	{
		 
		
		public var BGSCodeObj:Object;
		
		public function BGSExternalAnimation(param1:Object)
		{
			super();
			this.BGSCodeObj = param1;
			this.initialize();
		}
		
		private function get canPlayAnimation() : Boolean
		{
			return this.BGSCodeObj && this.BGSCodeObj.playActionAnim && !CompanionAppMode.isOn;
		}
		
		private function initialize() : void
		{
			if(this.canPlayAnimation)
			{
				InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onPushAction);
			}
		}
		
		private function onPushAction() : void
		{
			this.BGSCodeObj.playActionAnim();
		}
		
		public function dispose() : void
		{
			if(this.canPlayAnimation)
			{
				InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onPushAction);
			}
			this.BGSCodeObj = null;
		}
	}
}
