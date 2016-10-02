package bhvr.utils
{
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import aze.motion.eaze;
	import aze.motion.easing.Linear;
	
	public class AnimationUtil extends EventDispatcher
	{
		 
		
		public function AnimationUtil()
		{
			super();
		}
		
		public static function transferTextfieldValue(duration:Number, from:TextField, to:TextField, callbackUpdate:Function = null, callbackComplete:Function = null) : void
		{
			var totalSender:int = int(from.text);
			var totalReceiver:int = int(to.text);
			eaze(from).to(duration,{"text":0}).easing(Linear.easeNone).onUpdate(onTransferUpdate,from,to,totalSender,totalReceiver,callbackUpdate).onComplete(onTransferFinished,from,to,totalSender,totalReceiver,callbackComplete);
		}
		
		private static function onTransferUpdate(from:TextField, to:TextField, totalSender:int, totalReceiver:int, callbackUpdate:Function) : void
		{
			var fromValue:int = int(from.text);
			var deltaToTransfer:int = totalSender - fromValue;
			from.text = fromValue.toString();
			var toValue:int = totalReceiver + deltaToTransfer;
			to.text = toValue.toString();
			if(callbackUpdate != null)
			{
				callbackUpdate(deltaToTransfer);
			}
		}
		
		private static function onTransferFinished(from:TextField, to:TextField, totalSender:int, totalReceiver:int, callbackComplete:Function) : void
		{
			from.text = "0";
			to.text = (totalSender + totalReceiver).toString();
			if(callbackComplete != null)
			{
				callbackComplete();
			}
		}
	}
}
