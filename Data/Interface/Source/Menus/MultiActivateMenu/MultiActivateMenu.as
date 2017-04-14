package
{
	import Shared.AS3.BSButtonHint;
	import Shared.AS3.BSButtonHintData;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.display.MovieClip;
	
	public class MultiActivateMenu extends IMenu
	{
		 
		
		public var FadeHolder_mc:MovieClip;
		
		public var BGSCodeObj:Object;
		
		private var Buttons:Vector.<BSButtonHint>;
		
		private var ButtonAnimators:Vector.<MovieClip>;
		
		private var ButtonData:Vector.<BSButtonHintData>;
		
		private var ABtnData:BSButtonHintData;
		
		private var BBtnData:BSButtonHintData;
		
		private var XBtnData:BSButtonHintData;
		
		private var YBtnData:BSButtonHintData;
		
		public function MultiActivateMenu()
		{
			this.ABtnData = new BSButtonHintData("","Down","PSN_A","Xenon_A",1,this.onARelease);
			this.BBtnData = new BSButtonHintData("","Right","PSN_B","Xenon_B",1,this.onBRelease);
			this.XBtnData = new BSButtonHintData("","Left","PSN_X","Xenon_X",0,this.onXRelease);
			this.YBtnData = new BSButtonHintData("","Up","PSN_Y","Xenon_Y",0,this.onYRelease);
			super();
			this.visible = false;
			this.BGSCodeObj = new Object();
			this.Buttons = new Vector.<BSButtonHint>();
			this.Buttons.push(this.FadeHolder_mc.A.Holder.Button_mc);
			this.Buttons.push(this.FadeHolder_mc.B.Holder.Button_mc);
			this.Buttons.push(this.FadeHolder_mc.X.Holder.Button_mc);
			this.Buttons.push(this.FadeHolder_mc.Y.Holder.Button_mc);
			this.ButtonAnimators = new Vector.<MovieClip>();
			this.ButtonAnimators.push(this.FadeHolder_mc.A);
			this.ButtonAnimators.push(this.FadeHolder_mc.B);
			this.ButtonAnimators.push(this.FadeHolder_mc.X);
			this.ButtonAnimators.push(this.FadeHolder_mc.Y);
			this.ButtonData = new Vector.<BSButtonHintData>();
			this.ButtonData.push(this.ABtnData);
			this.ButtonData.push(this.BBtnData);
			this.ButtonData.push(this.XBtnData);
			this.ButtonData.push(this.YBtnData);
		}
		
		override protected function onSetSafeRect() : void
		{
			GlobalFunc.LockToSafeRect(this,"BC",SafeX,SafeY);
		}
		
		public function onCodeObjCreate() : *
		{
			this.BGSCodeObj.registerObjects(this.FadeHolder_mc.A,this.FadeHolder_mc.B,this.FadeHolder_mc.X,this.FadeHolder_mc.Y);
			var _loc1_:uint = 0;
			while(_loc1_ < this.Buttons.length)
			{
				this.Buttons[_loc1_].ButtonHintData = this.ButtonData[_loc1_];
				_loc1_++;
			}
		}
		
		public function SetButtonData(param1:uint, param2:String, param3:Boolean) : *
		{
			var _loc4_:Number = NaN;
			this.ButtonData[param1].ButtonText = param2.toUpperCase();
			this.ButtonData[param1].ButtonDisabled = !param3;
			if(!this.visible && param1 == 3)
			{
				_loc4_ = 0;
				while(_loc4_ < this.Buttons.length)
				{
					this.Buttons[_loc4_].bButtonPressed = false;
					this.ButtonAnimators[_loc4_].gotoAndPlay("showButton");
					_loc4_++;
				}
				this.visible = true;
			}
		}
		
		private function onAPress() : *
		{
			this.onButtonPress(0);
		}
		
		private function onBPress() : *
		{
			this.onButtonPress(1);
		}
		
		private function onXPress() : *
		{
			this.onButtonPress(2);
		}
		
		private function onYPress() : *
		{
			this.onButtonPress(3);
		}
		
		private function onARelease() : *
		{
			this.onButtonRelease(0);
		}
		
		private function onBRelease() : *
		{
			this.onButtonRelease(1);
		}
		
		private function onXRelease() : *
		{
			this.onButtonRelease(2);
		}
		
		private function onYRelease() : *
		{
			this.onButtonRelease(3);
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = true;
			if(param2)
			{
				if(param1 == "MultiActivateA")
				{
					this.onAPress();
				}
				else if(param1 == "MultiActivateB")
				{
					this.onBPress();
				}
				else if(param1 == "MultiActivateX")
				{
					this.onXPress();
				}
				else if(param1 == "MultiActivateY")
				{
					this.onYPress();
				}
				else
				{
					_loc3_ = false;
				}
			}
			else if(param1 == "MultiActivateA")
			{
				this.onARelease();
			}
			else if(param1 == "MultiActivateB")
			{
				this.onBRelease();
			}
			else if(param1 == "MultiActivateX")
			{
				this.onXRelease();
			}
			else if(param1 == "MultiActivateY")
			{
				this.onYRelease();
			}
			else
			{
				_loc3_ = false;
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
				this.Buttons[param1].bButtonPressed = false;
				this.BGSCodeObj.onButtonRelease(param1);
			}
		}
	}
}
