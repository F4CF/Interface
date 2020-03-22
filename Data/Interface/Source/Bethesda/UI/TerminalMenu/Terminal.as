package
{
	import Shared.AS3.BSScrollingList;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import scaleform.gfx.Extensions;
	
	public class Terminal extends IMenu
	{
		 
		
		public var HeaderText_tf:TextField;
		
		public var WelcomeText_tf:TextField;
		
		public var DisplayText_tf:TextField;
		
		public var ResponsePrompt_tf:TextField;
		
		public var ResponseText_tf:TextField;
		
		public var ResponseLog_tf:TextField;
		
		public var HackingAttempts_tf:TextField;
		
		public var MenuItemList_mc:MenuItemList;
		
		public var BlinkingCursor_mc:MovieClip;
		
		public var HackingHighlight1_mc:MovieClip;
		
		public var HackingHighlight2_mc:MovieClip;
		
		public var HackingGuess1_mc:MovieClip;
		
		public var HackingGuess2_mc:MovieClip;
		
		public var HackingGuess3_mc:MovieClip;
		
		public var HackingGuess4_mc:MovieClip;
		
		public var HackingGuess5_mc:MovieClip;
		
		public var BGSCodeObj:Object;
		
		public var strHeaderText:String;
		
		public var strWelcomeText:String;
		
		public var strDisplayText:String;
		
		public var strResponseText:String;
		
		public var timer:Timer;
		
		public var iTickCount:int = 0;
		
		public var bAnimateResponseText:Boolean;
		
		public var bAnimateDisplayText:Boolean;
		
		public var bShowHackingAttempts:Boolean;
		
		protected var bAcceptDebounce:Boolean;
		
		public var displayText_x:Number;
		
		public var displayText_y:Number;
		
		public var displayText_width:Number;
		
		public var displayText_height:Number;
		
		public var responsePrompt_x:Number;
		
		public var responsePrompt_y:Number;
		
		public var responseText_x:Number;
		
		public var responseText_y:Number;
		
		public var responseText_width:Number;
		
		public var displayTextMenuBuffer_y:Number = 10;
		
		public var menuItemList_y:Number;
		
		public var menuItemList_height:Number;
		
		public var menuItemList_scrollDownY:Number;
		
		public var displayText_startChar:Number = 0;
		
		public var displayText_isDone:Boolean = false;
		
		public var DisplayImage_mc:MovieClip;
		
		private var DisplayImageLoader:Loader;
		
		private var ncharRemainder = 0;
		
		private var ucharsPerSec:uint = 60;
		
		public function Terminal()
		{
			super();
			this.BGSCodeObj = new Object();
			this.strHeaderText = new String();
			this.strWelcomeText = new String();
			this.strDisplayText = new String();
			this.strResponseText = new String();
			this.timer = new Timer(33);
			GlobalFunc.MaintainTextFormat();
			stage.stageFocusRect = false;
			this.bAnimateResponseText = false;
			this.bAnimateDisplayText = false;
			this.bAcceptDebounce = false;
			this.MenuItemList_mc.disableInput = true;
			addEventListener(BSScrollingList.SELECTION_CHANGE,this.playSelectSound);
			addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPress);
			stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseClick);
			this.HackingHighlight1_mc.visible = false;
			this.HackingHighlight2_mc.visible = false;
			this.ResponsePrompt_tf.visible = false;
			this.ResponseLog_tf.visible = false;
			this.HackingAttempts_tf.visible = false;
			this.bShowHackingAttempts = false;
			this.ShowHackingGuesses(false);
			this.menuItemList_y = this.MenuItemList_mc.y;
			this.menuItemList_height = this.MenuItemList_mc.border.height;
			this.menuItemList_scrollDownY = this.MenuItemList_mc.ScrollDown.y;
			this.ncharRemainder = 0;
			Extensions.enabled = true;
			ShrinkFontToFit(this.HackingAttempts_tf,1);
			this.__setProp_MenuItemList_mc_TerminalBase_Layer1_0();
		}
		
		public function onCodeObjCreate() : *
		{
			this.ucharsPerSec = this.BGSCodeObj.GetDisplayRate();
		}
		
		public function playSelectSound() : *
		{
			this.BGSCodeObj.PlaySound("UITerminalCharArrow");
		}
		
		public function RegisterTerminalElements(param1:Boolean = true) : *
		{
			this.displayText_x = this.DisplayText_tf.x;
			this.displayText_y = this.DisplayText_tf.y;
			this.displayText_width = this.DisplayText_tf.width;
			this.displayText_height = this.DisplayText_tf.height;
			this.responsePrompt_x = this.ResponsePrompt_tf.x;
			this.responsePrompt_y = this.ResponsePrompt_tf.y;
			this.responseText_x = this.ResponseText_tf.x;
			this.responseText_y = this.ResponseText_tf.y;
			this.responseText_width = this.ResponseText_tf.width;
			this.BGSCodeObj.RegisterTerminalElements(this.HeaderText_tf,this.WelcomeText_tf,this.DisplayText_tf,this.ResponseText_tf,this.MenuItemList_mc,this.DisplayImage_mc);
			this.timer.addEventListener(TimerEvent.TIMER,this.AnimateText);
			this.HackingHighlight1_mc.HackingHighlightText_tf.addEventListener(MouseEvent.CLICK,this.onTextClick);
			this.HackingHighlight2_mc.HackingHighlightText_tf.addEventListener(MouseEvent.CLICK,this.onTextClick);
			this.DisplayText_tf.addEventListener(MouseEvent.MOUSE_MOVE,this.onTextOver);
			this.HackingHighlight1_mc.HackingHighlightText_tf.addEventListener(MouseEvent.MOUSE_MOVE,this.onTextOver);
			this.HackingHighlight2_mc.HackingHighlightText_tf.addEventListener(MouseEvent.MOUSE_MOVE,this.onTextOver);
			this.StartTimer();
		}
		
		public function DisplayHack(param1:TextField) : *
		{
			param1.x = param1.x;
		}
		
		public function AnimateText() : *
		{
			this.UpdateText(false);
		}
		
		public function onTextOver(param1:Event) : void
		{
			var _loc3_:int = 0;
			var _loc2_:int = this.DisplayText_tf.getCharIndexAtPoint(this.DisplayText_tf.mouseX,this.DisplayText_tf.mouseY);
			if(_loc2_ >= 0)
			{
				_loc3_ = this.DisplayText_tf.getLineIndexOfChar(_loc2_);
				this.BGSCodeObj.SelectHackingWord(_loc2_,_loc3_);
			}
		}
		
		public function onTextClick(param1:Event) : void
		{
			this.BGSCodeObj.ValidateHackingWord();
		}
		
		public function ConvertToGlobal(param1:TextField) : Point
		{
			var _loc2_:Rectangle = new Rectangle();
			var _loc3_:Point = new Point();
			var _loc4_:Boolean = false;
			var _loc5_:int = param1.length - 1;
			while(_loc5_ >= 0)
			{
				_loc4_ = param1.text.charCodeAt(_loc5_) != 13 && param1.text.charCodeAt(_loc5_) != 10 && (param1.text.charCodeAt(_loc5_) != 32 || param1.length > 1);
				if(_loc4_)
				{
					break;
				}
				_loc5_--;
			}
			if(_loc4_)
			{
				_loc2_ = param1.getCharBoundaries(_loc5_);
				_loc3_.x = _loc2_.bottomRight.x;
				_loc3_.y = _loc2_.y;
			}
			return param1.localToGlobal(_loc3_);
		}
		
		public function UpdateTextField(param1:TextField, param2:String, param3:uint, param4:Boolean) : *
		{
			if(param4 || param1.length + param3 >= param2.length)
			{
				GlobalFunc.SetText(param1,param2,false);
			}
			else
			{
				GlobalFunc.SetText(param1,param2.slice(0,param1.length + param3),false);
			}
		}
		
		public function UpdateText(param1:Boolean) : *
		{
			var _loc7_:Boolean = false;
			var _loc8_:uint = 0;
			var _loc9_:Boolean = false;
			var _loc10_:Boolean = false;
			var _loc11_:TextLineMetrics = null;
			var _loc12_:Number = NaN;
			var _loc13_:Number = NaN;
			var _loc2_:int = this.iTickCount;
			this.iTickCount = getTimer();
			var _loc3_:Number = (this.iTickCount - _loc2_) / 1000;
			var _loc4_:Number = _loc3_ * this.ucharsPerSec;
			var _loc5_:uint = _loc4_;
			this.ncharRemainder = this.ncharRemainder + (_loc4_ - _loc5_);
			if(this.ncharRemainder > 1)
			{
				_loc5_ = _loc5_ + 1;
				this.ncharRemainder = this.ncharRemainder - 1;
			}
			this.visible = true;
			var _loc6_:Point = new Point(-1,-1);
			if(this.bAnimateResponseText)
			{
				this.ResponsePrompt_tf.visible = true;
				if(this.ResponseText_tf.length < this.strResponseText.length || this.ResponseText_tf.text == " " && this.strResponseText.length == 1)
				{
					this.UpdateTextField(this.ResponseText_tf,this.strResponseText,_loc5_,param1);
					this.DisplayHack(this.ResponseText_tf);
				}
				else
				{
					param1 = true;
				}
				if(param1)
				{
					this.bAnimateResponseText = false;
				}
				_loc6_ = this.ConvertToGlobal(this.ResponseText_tf);
			}
			else
			{
				if(this.MenuItemList_mc.y != this.menuItemList_y || this.MenuItemList_mc.border.height != this.menuItemList_height || this.MenuItemList_mc.ScrollDown.y != this.menuItemList_scrollDownY)
				{
					this.MenuItemList_mc.y = this.menuItemList_y;
					this.MenuItemList_mc.border.height = this.menuItemList_height;
					this.MenuItemList_mc.ScrollDown.y = this.menuItemList_scrollDownY;
					this.MenuItemList_mc.InvalidateData();
				}
				_loc7_ = true;
				if(this.HeaderText_tf.length < this.strHeaderText.length)
				{
					this.UpdateTextField(this.HeaderText_tf,this.strHeaderText,_loc5_,param1);
					this.DisplayHack(this.HeaderText_tf);
					_loc7_ = param1;
					_loc6_ = this.ConvertToGlobal(this.HeaderText_tf);
				}
				if(_loc7_ && this.WelcomeText_tf.length < this.strWelcomeText.length)
				{
					this.UpdateTextField(this.WelcomeText_tf,this.strWelcomeText,_loc5_,param1);
					this.DisplayHack(this.WelcomeText_tf);
					_loc7_ = param1;
					_loc6_ = this.ConvertToGlobal(this.WelcomeText_tf);
				}
				if(_loc7_ && this.bAnimateDisplayText)
				{
					_loc8_ = 0;
					_loc9_ = !param1 && _loc8_ >= _loc5_;
					_loc10_ = param1;
					while(!_loc9_)
					{
						GlobalFunc.SetText(this.DisplayText_tf,this.strDisplayText.slice(this.displayText_startChar,this.displayText_startChar + this.DisplayText_tf.length + 1),false);
						if(this.displayText_startChar + this.DisplayText_tf.length >= this.strDisplayText.length)
						{
							_loc9_ = true;
							this.displayText_isDone = true;
						}
						else
						{
							_loc11_ = this.DisplayText_tf.getLineMetrics(this.DisplayText_tf.numLines - 1);
							if(this.DisplayText_tf.text.charCodeAt(this.DisplayText_tf.length - 1) == 13 && this.DisplayText_tf.textHeight + _loc11_.height + _loc11_.leading + 1 > this.DisplayText_tf.height)
							{
								_loc9_ = true;
								this.displayText_startChar = this.displayText_startChar + this.DisplayText_tf.length;
							}
						}
						if(!param1)
						{
							_loc10_ = _loc9_;
							_loc9_ = _loc9_ || ++_loc8_ >= _loc5_;
						}
					}
					if(_loc10_)
					{
						if(this.bShowHackingAttempts)
						{
							this.HackingAttempts_tf.visible = true;
							this.ShowHackingGuesses(true);
							this.HackingGuess1_mc.gotoAndStop(0);
							this.HackingGuess2_mc.gotoAndStop(0);
							this.HackingGuess3_mc.gotoAndStop(0);
							this.HackingGuess4_mc.gotoAndStop(0);
							this.HackingGuess5_mc.gotoAndStop(0);
							this.bShowHackingAttempts = false;
						}
						this.bAnimateDisplayText = false;
					}
					_loc6_ = this.ConvertToGlobal(this.DisplayText_tf);
					_loc7_ = param1;
				}
				if(_loc7_)
				{
					if(this.DisplayText_tf.visible)
					{
						_loc12_ = this.displayText_y + this.DisplayText_tf.textHeight + this.displayTextMenuBuffer_y;
						_loc13_ = _loc12_ - this.MenuItemList_mc.y;
						this.MenuItemList_mc.border.height = this.MenuItemList_mc.border.height - _loc13_;
						this.MenuItemList_mc.ScrollDown.y = this.MenuItemList_mc.ScrollDown.y - _loc13_;
						this.MenuItemList_mc.y = _loc12_;
						this.MenuItemList_mc.InvalidateData();
					}
					if(this.MenuItemList_mc.AnimateText(param1,this.BlinkingCursor_mc,_loc5_))
					{
						this.ResponsePrompt_tf.visible = true;
						this.StopTimer();
						stage.focus = this.MenuItemList_mc;
						if(this.MenuItemList_mc.selectedIndex == -1)
						{
							this.MenuItemList_mc.selectedIndex = this.BGSCodeObj.GetStartingListPosition();
						}
						_loc6_ = this.ConvertToGlobal(this.ResponseText_tf);
					}
				}
			}
			if(_loc6_.x != -1)
			{
				this.SetCursorPosition(_loc6_.x,_loc6_.y);
			}
		}
		
		public function SetCursorPosition(param1:Number, param2:Number) : *
		{
			this.BlinkingCursor_mc.x = param1;
			this.BlinkingCursor_mc.y = param2;
		}
		
		public function ShowHackingHighlight(param1:int, param2:String, param3:int, param4:String) : *
		{
			var _loc5_:Rectangle = new Rectangle();
			var _loc6_:Number = -2;
			var _loc7_:Number = -2;
			var _loc8_:uint = 4;
			if(param1 >= 0)
			{
				_loc5_ = this.DisplayText_tf.getCharBoundaries(param1);
				_loc5_.x = _loc5_.x + _loc6_;
				_loc5_.y = _loc5_.y + _loc7_;
				this.HackingHighlight1_mc.visible = true;
				GlobalFunc.SetText(this.HackingHighlight1_mc.HackingHighlightText_tf,param2,false);
				this.HackingHighlight1_mc.HackingHighlightBorder_mc.width = this.HackingHighlight1_mc.HackingHighlightText_tf.getLineMetrics(0).width + _loc8_;
				this.HackingHighlight1_mc.HackingHighlightText_tf.x = _loc5_.x;
				this.HackingHighlight1_mc.HackingHighlightText_tf.y = _loc5_.y;
				this.HackingHighlight1_mc.HackingHighlightBorder_mc.x = _loc5_.x;
				this.HackingHighlight1_mc.HackingHighlightBorder_mc.y = _loc5_.y;
			}
			else
			{
				this.HackingHighlight1_mc.visible = false;
			}
			if(param3 >= 0)
			{
				_loc5_ = this.DisplayText_tf.getCharBoundaries(param3);
				_loc5_.x = _loc5_.x + _loc6_;
				_loc5_.y = _loc5_.y + _loc7_;
				this.HackingHighlight2_mc.visible = true;
				GlobalFunc.SetText(this.HackingHighlight2_mc.HackingHighlightText_tf,param4,false);
				this.HackingHighlight2_mc.HackingHighlightBorder_mc.width = this.HackingHighlight2_mc.HackingHighlightText_tf.getLineMetrics(0).width + _loc8_;
				this.HackingHighlight2_mc.HackingHighlightText_tf.x = _loc5_.x;
				this.HackingHighlight2_mc.HackingHighlightText_tf.y = _loc5_.y;
				this.HackingHighlight2_mc.HackingHighlightBorder_mc.x = _loc5_.x;
				this.HackingHighlight2_mc.HackingHighlightBorder_mc.y = _loc5_.y;
			}
			else
			{
				this.HackingHighlight2_mc.visible = false;
			}
		}
		
		public function StartTimer() : *
		{
			this.timer.reset();
			this.timer.start();
			this.iTickCount = getTimer();
			this.BGSCodeObj.ActivateScrollSound(true);
		}
		
		public function StopTimer() : *
		{
			this.timer.stop();
			this.BGSCodeObj.ActivateScrollSound(false);
		}
		
		public function IsTextAnimating() : Boolean
		{
			return this.timer.running;
		}
		
		public function FinishAnimatingText() : *
		{
			this.UpdateText(true);
			this.BGSCodeObj.PlaySound("UITerminalCharEnter");
			this.bAcceptDebounce = this.MenuItemList_mc.visible;
		}
		
		public function set headerText(param1:String) : *
		{
			this.strHeaderText = param1;
			GlobalFunc.SetText(this.HeaderText_tf,"",false);
			this.DisplayHack(this.HeaderText_tf);
		}
		
		public function set welcomeText(param1:String) : *
		{
			this.strWelcomeText = param1;
			GlobalFunc.SetText(this.WelcomeText_tf,"",false);
			this.DisplayHack(this.WelcomeText_tf);
		}
		
		public function set displayText(param1:String) : *
		{
			var _loc4_:String = null;
			var _loc5_:int = 0;
			var _loc6_:int = 0;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			GlobalFunc.SetText(this.DisplayText_tf,param1,false);
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			while(_loc3_ < this.DisplayText_tf.numLines)
			{
				_loc4_ = this.DisplayText_tf.getLineText(_loc3_);
				if(_loc4_.length == 0)
				{
					break;
				}
				if(_loc3_ < this.DisplayText_tf.numLines - 1)
				{
					_loc5_ = -1;
					_loc6_ = _loc2_ + _loc4_.length;
					_loc7_ = param1.charCodeAt(_loc6_);
					_loc8_ = param1.charCodeAt(_loc6_ - 1);
					if(_loc7_ == 32)
					{
						_loc5_ = _loc6_;
					}
					else if(_loc7_ != 10 && _loc7_ != 13 && _loc8_ == 32)
					{
						_loc5_ = _loc6_ - 1;
					}
					if(_loc5_ >= 0)
					{
						param1 = param1.substring(0,_loc5_) + "\n" + param1.substring(_loc5_ + 1);
						_loc2_ = _loc5_;
					}
					else
					{
						_loc2_ = _loc2_ + _loc4_.length;
					}
				}
				_loc3_++;
			}
			this.strDisplayText = param1;
			this.displayText_startChar = 0;
			this.displayText_isDone = false;
			this.DisplayTextNextPage();
		}
		
		public function DisplayTextNextPage() : void
		{
			GlobalFunc.SetText(this.DisplayText_tf,"",false);
			this.DisplayHack(this.DisplayText_tf);
			this.bAnimateDisplayText = true;
			this.StartTimer();
		}
		
		public function IsDisplayTextDone() : Boolean
		{
			return this.displayText_isDone;
		}
		
		public function set responseText(param1:String) : *
		{
			this.strResponseText = param1;
			GlobalFunc.SetText(this.ResponseText_tf,"",false);
			this.DisplayHack(this.ResponseText_tf);
			this.bAnimateResponseText = true;
			this.StartTimer();
		}
		
		public function SetDisplayMode(param1:Boolean) : void
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			if(param1)
			{
				_loc2_ = this.DisplayText_tf.textHeight + this.DisplayText_tf.getTextFormat().leading;
				_loc3_ = this.DisplayText_tf.getCharBoundaries(0).width;
				this.DisplayText_tf.x = this.HackingHighlight1_mc.x;
				this.DisplayText_tf.y = this.HackingHighlight1_mc.y;
				this.DisplayText_tf.width = this.BGSCodeObj.GetHackingBoardCharWidth() * _loc3_ + 6;
				this.DisplayText_tf.height = this.BGSCodeObj.GetHackingBoardCharHeight() * _loc2_ + 1;
				this.DisplayText_tf.mouseWheelEnabled = false;
				this.ResponsePrompt_tf.x = this.DisplayText_tf.x + this.DisplayText_tf.width + _loc3_;
				this.ResponsePrompt_tf.y = this.DisplayText_tf.y + this.DisplayText_tf.height - _loc2_ - 1;
				this.ResponseText_tf.x = this.ResponsePrompt_tf.x + _loc3_;
				this.ResponseText_tf.y = this.ResponsePrompt_tf.y;
				this.ResponseText_tf.width = 13 * _loc3_ + 5;
				this.ResponseLog_tf.x = this.ResponsePrompt_tf.x;
				this.ResponseLog_tf.width = this.ResponseText_tf.x + this.ResponseText_tf.width - this.ResponsePrompt_tf.x;
				this.bShowHackingAttempts = true;
			}
			else
			{
				this.DisplayText_tf.x = this.displayText_x;
				this.DisplayText_tf.y = this.displayText_y;
				this.DisplayText_tf.width = this.displayText_width;
				this.DisplayText_tf.height = this.displayText_height;
				this.DisplayText_tf.mouseWheelEnabled = true;
				this.ResponsePrompt_tf.x = this.responsePrompt_x;
				this.ResponsePrompt_tf.y = this.responsePrompt_y;
				this.ResponseText_tf.x = this.responseText_x;
				this.ResponseText_tf.y = this.responseText_y;
				this.ResponseText_tf.width = this.responseText_width;
				this.ResponseLog_tf.visible = false;
				this.HackingAttempts_tf.visible = false;
				this.ShowHackingGuesses(false);
			}
		}
		
		public function PushResponseLog(param1:String, param2:Boolean) : void
		{
			var _loc6_:String = null;
			var _loc7_:uint = 0;
			if(param2)
			{
				this.PushResponseLog(this.strResponseText,false);
			}
			param1 = ">" + param1;
			if(!this.ResponseLog_tf.visible)
			{
				GlobalFunc.SetText(this.ResponseLog_tf,"",false);
				this.ResponseLog_tf.visible = true;
			}
			var _loc3_:uint = this.BGSCodeObj.GetHackingBoardCharHeight() - 1;
			var _loc4_:uint = this.ResponseLog_tf.text.length == 1?uint(0):uint(this.ResponseLog_tf.numLines);
			if(_loc4_ >= _loc3_)
			{
				_loc6_ = new String();
				_loc7_ = _loc4_ - _loc3_ + 1;
				while(_loc7_ < _loc4_)
				{
					_loc6_ = _loc6_ + this.ResponseLog_tf.getLineText(_loc7_);
					_loc7_++;
				}
				this.ResponseLog_tf.text = _loc6_;
			}
			if(_loc4_ == 0)
			{
				this.ResponseLog_tf.text = param1;
			}
			else
			{
				this.ResponseLog_tf.text = this.ResponseLog_tf.text + "\n" + param1;
			}
			var _loc5_:Number = this.DisplayText_tf.getLineMetrics(0).height + this.DisplayText_tf.getTextFormat().leading + 0.5;
			this.ResponseLog_tf.height = _loc5_ * this.ResponseLog_tf.numLines + 1;
			this.ResponseLog_tf.y = this.ResponseText_tf.y - this.ResponseLog_tf.height;
		}
		
		public function ShowHackingGuesses(param1:Boolean) : void
		{
			var _loc2_:uint = 0;
			if(param1)
			{
				_loc2_ = this.BGSCodeObj.GetNumGuesses();
				this.HackingGuess1_mc.visible = _loc2_ >= 1;
				this.HackingGuess2_mc.visible = _loc2_ >= 2;
				this.HackingGuess3_mc.visible = _loc2_ >= 3;
				this.HackingGuess4_mc.visible = _loc2_ >= 4;
				this.HackingGuess5_mc.visible = _loc2_ >= 5;
			}
			else
			{
				this.HackingGuess1_mc.visible = false;
				this.HackingGuess2_mc.visible = false;
				this.HackingGuess3_mc.visible = false;
				this.HackingGuess4_mc.visible = false;
				this.HackingGuess5_mc.visible = false;
			}
		}
		
		public function RemoveGuessBlock() : void
		{
			if(this.HackingGuess5_mc.visible)
			{
				this.HackingGuess5_mc.visible = false;
			}
			else if(this.HackingGuess4_mc.visible)
			{
				this.HackingGuess4_mc.visible = false;
			}
			else if(this.HackingGuess3_mc.visible)
			{
				this.HackingGuess3_mc.visible = false;
			}
			else if(this.HackingGuess2_mc.visible)
			{
				this.HackingGuess2_mc.visible = false;
			}
			else if(this.HackingGuess1_mc.visible)
			{
				this.HackingGuess1_mc.visible = false;
			}
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!param2 && this.IsTextAnimating() && (param1 == "Accept" || param1 == "Activate"))
			{
				this.FinishAnimatingText();
				_loc3_ = true;
			}
			return _loc3_;
		}
		
		public function LoadDisplayImage(param1:String) : void
		{
			if(this.DisplayImage_mc.numChildren > 0)
			{
				this.DisplayImage_mc.removeChildren();
			}
			this.DisplayImageLoader = new Loader();
			this.DisplayImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onDisplayImageLoadComplete);
			this.DisplayImageLoader.load(new URLRequest("img://" + param1));
		}
		
		private function onDisplayImageLoadComplete(param1:Event) : *
		{
			this.DisplayImage_mc.addChild(param1.currentTarget.content);
			this.DisplayImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onDisplayImageLoadComplete);
			this.DisplayImageLoader = null;
		}
		
		protected function onItemPress() : *
		{
			if(!this.bAcceptDebounce)
			{
				this.BGSCodeObj.OnMenuItemSelect();
			}
			else
			{
				this.bAcceptDebounce = false;
			}
		}
		
		public function onMouseClick(param1:MouseEvent) : void
		{
			if(this.IsTextAnimating())
			{
				this.FinishAnimatingText();
			}
		}
		
		function __setProp_MenuItemList_mc_TerminalBase_Layer1_0() : *
		{
			try
			{
				this.MenuItemList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.MenuItemList_mc.listEntryClass = "MenuItemListEntry";
			this.MenuItemList_mc.numListItems = 12;
			this.MenuItemList_mc.restoreListIndex = false;
			this.MenuItemList_mc.textOption = "Shrink To Fit";
			this.MenuItemList_mc.verticalSpacing = 0;
			try
			{
				this.MenuItemList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
