package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class RadioWave extends MovieClip
	{
		
		public static const LINE_1:int = 0;
		
		public static const LINE_2:int = 1;
		
		public static const LINE_3:int = 2;
		
		public static const LINE_COUNT:int = 3;
		
		public static const MAX_AMP:int = 100;
		
		public static const LARGE_AMP:int = 95;
		
		public static const MEDIUM_AMP:int = 65;
		
		public static const SMALL_AMP:int = 40;
		
		public static const NO_AMP:int = 5;
		
		public static const BAD_FREQ:int = 14;
		
		public static const NEUTRAL_FREQ:int = 3;
		
		public static const GOOD_FREQ:int = 2;
		
		public static const NO_FREQ:int = 1;
		
		public static var COLOR_BRIGHT:Number = 100;
		
		public static var COLOR_MEDIUM:Number = 60;
		
		public static var COLOR_LIGHT:Number = 25;
		
		public static const WAVE_WIDTH:int = 226;
		 
		
		public var Wave:Array;
		
		public var amp:int = 5;
		
		public var freq:int = 14;
		
		public var ampMult:Number;
		
		public var freqMult:Number;
		
		public var darkness:int;
		
		public var bwrongWord:Boolean = false;
		
		public var bshowWinningGroup:Boolean = false;
		
		public var bwinningWord:Boolean = false;
		
		public var bwinningGroupFound:Boolean = false;
		
		protected var offset:Number;
		
		protected var randFreqOffset:Number;
		
		protected var pulsingAlpha:Number = 0.5;
		
		protected var WaveIndex:uint = 0;
		
		protected var OldAng:Number = 0.0;
		
		public function RadioWave()
		{
			this.Wave = new Array();
			this.darkness = COLOR_BRIGHT;
			super();
			this.offset = Math.random() * 2 * Math.PI;
			this.randFreqOffset = 2 - Math.random() * 4;
			addEventListener(Event.ADDED_TO_STAGE,this.onStageInit);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onStageDestruct);
			this.ampMult = Math.random() * 3.5;
			this.freqMult = Math.random() * 0.035 + 1;
		}
		
		private function onStageInit(param1:Event) : *
		{
			stage.addEventListener("ResetWaves",this.resetWaves);
			stage.addEventListener("SetGroupFound",this.setGroupFound);
		}
		
		private function onStageDestruct(param1:Event) : *
		{
			stage.removeEventListener("ResetWaves",this.resetWaves);
			stage.removeEventListener("SetGroupFound",this.setGroupFound);
		}
		
		private function setGroupFound(param1:Event) : *
		{
			this.bwinningGroupFound = true;
		}
		
		private function resetWaves(param1:Event) : *
		{
			this.amp = NO_AMP;
			this.bwrongWord = false;
			this.bshowWinningGroup = false;
			this.bwinningWord = false;
		}
		
		private function GetWavePoint() : Number
		{
			var _loc5_:* = undefined;
			var _loc1_:Number = this.freq;
			if(this.bshowWinningGroup && this.bwinningGroupFound)
			{
				if(this.bwinningWord)
				{
					_loc1_ = _loc1_ * 1.14;
				}
				else
				{
					_loc1_ = _loc1_ * this.freqMult;
				}
			}
			var _loc2_:Number = 2 * Math.PI * (this.bshowWinningGroup && this.bwinningGroupFound?_loc1_ + this.randFreqOffset:(!!this.bwrongWord?BAD_FREQ:this.freq) + this.randFreqOffset) * this.WaveIndex / WAVE_WIDTH + this.offset;
			this.offset = this.offset + 0.025;
			var _loc3_:Number = this.amp;
			if(this.bshowWinningGroup && this.bwinningGroupFound)
			{
				if(this.bwinningWord)
				{
					_loc3_ = this.amp + 14;
				}
				else
				{
					_loc3_ = this.amp + this.ampMult;
				}
			}
			var _loc4_:Number = MAX_AMP - (!this.bshowWinningGroup && this.bwrongWord?MAX_AMP:_loc3_) * Math.sin(_loc2_);
			if(this.OldAng < 0 && Math.sin(_loc2_) > 0)
			{
				_loc5_ = Math.random() * 100;
				if(_loc5_ < 75)
				{
					this.amp = Math.random() * 60 + 40;
				}
			}
			this.OldAng = Math.sin(_loc2_);
			this.WaveIndex++;
			return _loc4_;
		}
		
		public function InitWave() : *
		{
			var _loc1_:int = 0;
			while(_loc1_ < WAVE_WIDTH)
			{
				this.Wave.push(this.GetWavePoint());
				_loc1_++;
			}
		}
		
		public function Animate() : *
		{
			this.pulsingAlpha = this.pulsingAlpha + 0.1;
			if(this.pulsingAlpha > 1)
			{
				this.pulsingAlpha = 0;
			}
			this.graphics.clear();
			this.graphics.lineStyle(2,16777215,this.bshowWinningGroup && this.bwrongWord?Number(this.pulsingAlpha):Number(this.darkness / 100));
			this.graphics.moveTo(0,MAX_AMP);
			var _loc1_:int = 0;
			while(_loc1_ < WAVE_WIDTH)
			{
				this.graphics.lineTo(_loc1_,this.Wave[_loc1_]);
				_loc1_++;
			}
			var _loc2_:uint = 10;
			this.Wave.splice(0,_loc2_);
			var _loc3_:int = 0;
			while(_loc3_ < _loc2_)
			{
				this.Wave.push(this.GetWavePoint());
				_loc3_++;
			}
		}
	}
}
