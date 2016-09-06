package bhvr.states
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import bhvr.data.LocalizationStrings;
	import bhvr.events.EventWithParams;
	import flash.display.MovieClip;
	
	public class PauseState extends GameState
	{
		
		public static const READY_TO_RESUME:String = "ReadyToResume";
		 
		
		private const START_TIME_COUNTER:Number = 3;
		
		private var _timer:Timer;
		
		public function PauseState(id:int, assets:MovieClip)
		{
			super(id,assets);
		}
		
		public function get isActive() : Boolean
		{
			return _assets.visible;
		}
		
		override public function enter() : void
		{
			super.enter();
			this.reset();
			_assets.pauseMc.visible = true;
			_assets.pauseMc.gotoAndPlay("enter");
		}
		
		public function startExit() : void
		{
			this.reset();
			_assets.resumeMc.visible = true;
			this.updateCounter(this.START_TIME_COUNTER);
			this.startTimer();
		}
		
		private function startTimer() : void
		{
			this._timer = new Timer(1000,this.START_TIME_COUNTER + 1);
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimerUpdate,false,0,true);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete,false,0,true);
			this._timer.start();
		}
		
		private function stopTimer() : void
		{
			if(this._timer)
			{
				this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerUpdate);
				this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
				this._timer = null;
			}
		}
		
		private function onTimerUpdate(e:TimerEvent) : void
		{
			var currentTime:int = int(_assets.resumeMc.counterMc.counterTxt.text) - 1;
			this.updateCounter(currentTime);
		}
		
		private function updateCounter(count:int) : void
		{
			_assets.resumeMc.counterMc.counterTxt.text = count > 0?count:LocalizationStrings.COUNTER_GO;
			_assets.resumeMc.gotoAndPlay("enter");
		}
		
		private function onTimerComplete(e:TimerEvent) : void
		{
			this.exit();
		}
		
		public function cancel() : void
		{
			super.exit();
			this.stopTimer();
		}
		
		override public function exit() : void
		{
			super.exit();
			this.stopTimer();
			dispatchEvent(new EventWithParams(READY_TO_RESUME));
		}
		
		private function reset() : void
		{
			_assets.pauseMc.visible = false;
			_assets.resumeMc.visible = false;
			this.stopTimer();
		}
	}
}
