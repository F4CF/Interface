package bhvr.views
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import aze.motion.eaze;
	import bhvr.data.GamePersistantData;
	import bhvr.constants.GameConstants;
	import bhvr.data.LocalizationStrings;
	import flash.events.Event;
	
	public class Hud extends EventDispatcher
	{
		
		public static const INSTRUCTIONS_ON:String = "InstructionsOn";
		
		public static const INSTRUCTIONS_OFF:String = "InstructionsOff";
		 
		
		private var _assets:MovieClip;
		
		private var _livesCounter:MovieClip;
		
		private var _timer:MovieClip;
		
		private var _bobbleHeadCounter:MovieClip;
		
		private var _instructions:MovieClip;
		
		private var _lifeInQueue:Vector.<int>;
		
		private var _playingAnimation:Boolean;
		
		private const WARNING_TIMER_THRESHOLD:uint = 30;
		
		private const NUMBER_OF_INSTRUCTIONS:uint = 2;
		
		private var _instructionsCounter:uint = 0;
		
		public function Hud(assets:MovieClip)
		{
			super();
			this._assets = assets;
			this._livesCounter = this._assets.heartsMc;
			this._timer = this._assets.timerMc;
			this._bobbleHeadCounter = this._assets.bobbleHeadsMc.counterMc;
			this._instructions = this._assets.instructionsMc;
			this._playingAnimation = false;
			this._lifeInQueue = new Vector.<int>();
		}
		
		public function show() : void
		{
			this._assets.visible = true;
		}
		
		public function hide() : void
		{
			this._assets.visible = false;
		}
		
		public function setLife(id:uint, isFull:Boolean) : void
		{
			var frame:String = !!isFull?"full":"empty";
			this._livesCounter["heart" + id].gotoAndPlay(frame);
		}
		
		public function addLife(id:uint) : void
		{
			if(this._playingAnimation)
			{
				this._lifeInQueue.push(id);
			}
			else
			{
				eaze(this._livesCounter["heart" + id]).play("addStart>addEnd").onComplete(this.onLifeUpdated);
				this._playingAnimation = true;
			}
			this.setBobbleHead();
		}
		
		public function removeLife(id:uint) : void
		{
			if(this._playingAnimation)
			{
				this._lifeInQueue.push(-id);
			}
			else
			{
				eaze(this._livesCounter["heart" + id]).play("removeStart>removeEnd").onComplete(this.onLifeUpdated);
				this._playingAnimation = true;
			}
		}
		
		private function onLifeUpdated() : void
		{
			this._playingAnimation = false;
			if(this._lifeInQueue.length > 0)
			{
				if(this._lifeInQueue[0] > 0)
				{
					this.addLife(this._lifeInQueue.shift());
				}
				else
				{
					this.removeLife(Math.abs(this._lifeInQueue.shift()));
				}
			}
		}
		
		public function setBobbleHead() : void
		{
			this._bobbleHeadCounter.counterTxt.text = GamePersistantData.bobbleHeadNum + "/" + GameConstants.numBobbleHead;
		}
		
		public function setTimer(value:uint) : void
		{
			var currentTime:uint = int(this._timer.timerAnimMc.timerTxt.text);
			this._timer.timerAnimMc.timerTxt.text = value;
			if(value > this.WARNING_TIMER_THRESHOLD)
			{
				this._timer.gotoAndPlay("normal");
			}
			else if(currentTime > this.WARNING_TIMER_THRESHOLD && value <= this.WARNING_TIMER_THRESHOLD)
			{
				this._timer.gotoAndPlay("warning");
			}
			else if(value <= 0)
			{
				this._timer.gotoAndPlay("normal");
			}
		}
		
		public function setInstructionsVisibility(isVisible:Boolean, withAnimation:Boolean) : void
		{
			if(isVisible)
			{
				if(withAnimation)
				{
					this.setInstructionsContent();
					eaze(this._instructions).play("fadeInStart>fadeInEnd").onComplete(this.startInstructionsTimer);
				}
				else
				{
					this._instructions.gotoAndStop("fadeInEnd");
					eaze(this._instructions).killTweens();
				}
			}
			else if(withAnimation)
			{
				eaze(this._instructions).play("fadeOutStart>fadeOutEnd").onComplete(this.onInstructionsFinished);
			}
			else
			{
				this._instructions.gotoAndStop("fadeOutEnd");
				eaze(this._instructions).killTweens();
			}
		}
		
		private function setInstructionsContent() : void
		{
			this._instructions.bobblehead1.visible = this._instructionsCounter == 0;
			this._instructions.bobblehead2.visible = this._instructionsCounter == 0;
			this._instructions.instructionsText1.instructionsTxt.text = LocalizationStrings["GAME_INSTRUCTIONS_" + (this._instructionsCounter + 1)];
			this._instructions.instructionsText2.instructionsTxt.text = LocalizationStrings["GAME_INSTRUCTIONS_" + (this._instructionsCounter + 1)];
		}
		
		private function startInstructionsTimer() : void
		{
			if(this._instructionsCounter == 0)
			{
				dispatchEvent(new Event(INSTRUCTIONS_ON));
			}
			eaze(this._instructions).delay(GameConstants.instructionsDuration).onComplete(this.setInstructionsVisibility,false,true);
		}
		
		private function onInstructionsFinished() : void
		{
			if(this._instructionsCounter < this.NUMBER_OF_INSTRUCTIONS - 1)
			{
				this._instructionsCounter++;
				this.setInstructionsVisibility(true,true);
			}
			else if(this._instructionsCounter == this.NUMBER_OF_INSTRUCTIONS - 1)
			{
				dispatchEvent(new Event(INSTRUCTIONS_OFF));
				this._instructionsCounter = 0;
			}
		}
	}
}
