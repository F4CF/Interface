package
{
	import Shared.AS3.BSButtonHint;
	import Shared.AS3.BSButtonHintData;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.display.MovieClip;
	
	public class DialogueMenu extends IMenu
	{
		 
		
		public var FadeHolder_mc:MovieClip;
		
		public var BGSCodeObj:Object;
		
		private var Buttons:Vector.<BSButtonHint>;
		
		private var ButtonAnimators:Vector.<MovieClip>;
		
		private var ButtonData:Vector.<BSButtonHintData>;
		
		private var PositiveBtnData:BSButtonHintData;
		
		private var NegativeBtnData:BSButtonHintData;
		
		private var NeutralBtnData:BSButtonHintData;
		
		private var QuestionBtnData:BSButtonHintData;
		
		private var LastPressedButtonIndex:uint;
		
		private var _ButtonsShown:Boolean;
		
		public function DialogueMenu()
		{
			this.PositiveBtnData = new BSButtonHintData("","Down","PSN_A","Xenon_A",1,this.onPositiveRelease);
			this.NegativeBtnData = new BSButtonHintData("","Right","PSN_B","Xenon_B",1,this.onNegativeRelease);
			this.NeutralBtnData = new BSButtonHintData("","Left","PSN_X","Xenon_X",0,this.onNeutralRelease);
			this.QuestionBtnData = new BSButtonHintData("","Up","PSN_Y","Xenon_Y",0,this.onQuestionRelease);
			super();
			addFrameScript(0,this.frame1,4,this.frame5);
			this.visible = false;
			this.BGSCodeObj = new Object();
			this.Buttons = new Vector.<BSButtonHint>();
			this.Buttons.push(this.FadeHolder_mc.Positive.Holder.Button_mc);
			this.Buttons.push(this.FadeHolder_mc.Negative.Holder.Button_mc);
			this.Buttons.push(this.FadeHolder_mc.Neutral.Holder.Button_mc);
			this.Buttons.push(this.FadeHolder_mc.Question.Holder.Button_mc);
			this.ButtonAnimators = new Vector.<MovieClip>();
			this.ButtonAnimators.push(this.FadeHolder_mc.Positive);
			this.ButtonAnimators.push(this.FadeHolder_mc.Negative);
			this.ButtonAnimators.push(this.FadeHolder_mc.Neutral);
			this.ButtonAnimators.push(this.FadeHolder_mc.Question);
			this.ButtonData = new Vector.<BSButtonHintData>();
			this.ButtonData.push(this.PositiveBtnData);
			this.ButtonData.push(this.NegativeBtnData);
			this.ButtonData.push(this.NeutralBtnData);
			this.ButtonData.push(this.QuestionBtnData);
			this.LastPressedButtonIndex = uint.MAX_VALUE;
			this._ButtonsShown = false;
			this.FadeHolder_mc.SpeechChallengeAnim_mc.mouseEnabled = false;
			this.FadeHolder_mc.SpeechChallengeAnim_mc.mouseChildren = false;
			this.FadeHolder_mc.SpeechChallengeAnim_mc.addEventListener("OnSpeechChallengeAnimComplete",this.OnSpeechChallengeAnimComplete);
		}
		
		override protected function onSetSafeRect() : void
		{
			GlobalFunc.LockToSafeRect(this,"BC",SafeX,SafeY);
		}
		
		public function onCodeObjCreate() : *
		{
			this.BGSCodeObj.registerObjects(this.FadeHolder_mc.Positive,this.FadeHolder_mc.Negative,this.FadeHolder_mc.Neutral,this.FadeHolder_mc.Question,this.FadeHolder_mc.SpeechChallengeAnim_mc);
			var _loc1_:uint = 0;
			while(_loc1_ < this.Buttons.length)
			{
				this.Buttons[_loc1_].ButtonHintData = this.ButtonData[_loc1_];
				_loc1_++;
			}
		}
		
		public function SetButtonText(param1:uint, param2:String) : *
		{
			this.ButtonData[param1].ButtonText = param2.toUpperCase();
			if(!this.visible && param1 == 3)
			{
				this.visible = true;
			}
		}
		
		public function ShowButtonHelp() : *
		{
			var _loc1_:Number = 0;
			while(!this._ButtonsShown && _loc1_ < this.Buttons.length)
			{
				this.Buttons[_loc1_].bButtonPressed = false;
				this.ButtonAnimators[_loc1_].gotoAndPlay("showButton");
				_loc1_++;
			}
			this._ButtonsShown = true;
		}
		
		public function HideButtonHelp() : *
		{
			var _loc1_:Number = 0;
			while(this._ButtonsShown && _loc1_ < this.ButtonAnimators.length)
			{
				if(_loc1_ == this.LastPressedButtonIndex)
				{
					this.Buttons[_loc1_].bButtonPressed = true;
					this.ButtonAnimators[_loc1_].gotoAndPlay("slowHideButton");
				}
				else
				{
					this.ButtonAnimators[_loc1_].gotoAndPlay("hideButton");
				}
				_loc1_++;
			}
			this._ButtonsShown = false;
		}
		
		public function EnableMenu() : *
		{
			gotoAndPlay("showMenu");
		}
		
		public function DisableMenu() : *
		{
			gotoAndPlay("hideMenu");
		}
		
		private function onPositivePress() : *
		{
			this.onButtonPress(0);
		}
		
		private function onNegativePress() : *
		{
			this.onButtonPress(1);
		}
		
		private function onNeutralPress() : *
		{
			this.onButtonPress(2);
		}
		
		private function onQuestionPress() : *
		{
			this.onButtonPress(3);
		}
		
		private function onPositiveRelease() : *
		{
			this.onButtonRelease(0);
		}
		
		private function onNegativeRelease() : *
		{
			this.onButtonRelease(1);
		}
		
		private function onNeutralRelease() : *
		{
			this.onButtonRelease(2);
		}
		
		private function onQuestionRelease() : *
		{
			this.onButtonRelease(3);
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(this._ButtonsShown)
			{
				_loc3_ = true;
				if(param1 == "MultiActivateA")
				{
					if(param2)
					{
						this.onPositivePress();
					}
					else
					{
						this.onPositiveRelease();
					}
				}
				else if(param1 == "MultiActivateB")
				{
					if(param2)
					{
						this.onNegativePress();
					}
					else
					{
						this.onNegativeRelease();
					}
				}
				else if(param1 == "MultiActivateX")
				{
					if(param2)
					{
						this.onNeutralPress();
					}
					else
					{
						this.onNeutralRelease();
					}
				}
				else if(param1 == "MultiActivateY")
				{
					if(param2)
					{
						this.onQuestionPress();
					}
					else
					{
						this.onQuestionRelease();
					}
				}
				else
				{
					_loc3_ = false;
				}
			}
			return _loc3_;
		}
		
		private function onButtonPress(param1:uint) : *
		{
			if(param1 < this.Buttons.length)
			{
				this.Buttons[param1].bButtonPressed = true;
			}
		}
		
		private function onButtonRelease(param1:uint) : *
		{
			if(param1 < this.Buttons.length)
			{
				this.LastPressedButtonIndex = param1;
				this.Buttons[param1].bButtonPressed = false;
				this.BGSCodeObj.onButtonRelease(param1);
			}
		}
		
		public function PlaySpeechChallengeAnim() : *
		{
			this.FadeHolder_mc.SpeechChallengeAnim_mc.gotoAndPlay("startAnim");
		}
		
		public function OnSpeechChallengeAnimComplete() : *
		{
			this.BGSCodeObj.OnSpeechChallengeAnimComplete();
		}
		
		function frame1() : *
		{
			stop();
		}
		
		function frame5() : *
		{
			stop();
		}
	}
}
