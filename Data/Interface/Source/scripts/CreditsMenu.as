package
{
	import Shared.IMenu;
	import flash.display.MovieClip;
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import scaleform.gfx.TextFieldEx;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import scaleform.gfx.Extensions;


	public class CreditsMenu extends IMenu
	{
		private var StartY:Number = 670;
		private var FadeStart:Number = 660;
		private var FadeEnd:Number = 600;
		private var EndY:Number = -25;
		private var TextYRate:Number = 1;
		private var MinHeight:Number = 10;
		private var FontSize:int = 16;
		private var TextColor:int = 16777215;
		public var BGSCodeObj:Object;
		public var CreditsStrings:Array;
		public var CreditsLines:Array;
		public var CreditsContainer:MovieClip;
		public var CreditsFonts:Array;
		public var Background_mc:MovieClip;
		private var startIndex:int;
		private var endIndex:int;
		private var maxEndIndex:int;
		public var ButtonHintBar_mc:BSButtonHintBar;
		private var BackButton:BSButtonHintData;


		public function CreditsMenu()
		{
			this.BackButton = new BSButtonHintData("$BACK", "Esc", "PSN_B", "Xenon_B", 1, this.onQuitPress);
			super();
			this.BGSCodeObj = new Object();
			Extensions.enabled = true;
			this.CreditsLines = new Array();
			this.CreditsStrings = new Array();
			this.CreditsFonts = new Array();
			this.startIndex = -1;
			this.endIndex = -1;
			this.maxEndIndex = -1;
			addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
			addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			this.PopulateButtonBar();
			this.BackButton.ButtonVisible = true;
		}


		override protected function onSetSafeRect() : void
		{
			this.StartY = stage.stageHeight - SafeY - this.ButtonHintBar_mc.height;
			this.FadeStart = this.StartY - 10;
			this.FadeEnd = this.FadeStart - 60;
		}


		public function onCodeObjDestruction() : *
		{
			removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
			removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			this.BGSCodeObj = null;
			this.CreditsContainer = null;
			this.CreditsStrings = null;
			this.CreditsLines = null;
			this.CreditsFonts = null;
		}


		public function onCodeObjCreate() : void
		{
			var _loc2_:* = undefined;
			this.BGSCodeObj.requestCredits();
			var _loc1_:DisplayObject = this.CreditsContainer.addChild(new Fallout4logo());
			this.CreditsLines.push(_loc1_);
			_loc1_.y = this.StartY;
			_loc1_.x = 0.5 * stage.stageWidth;
			if(this.CreditsStrings.length > 0)
			{
				_loc2_ = this.CreditsContainer.addChild(new TextField());
				this.CreditsLines.push(_loc2_);
				_loc2_.y = _loc1_.y + _loc1_.height;
				this.formatLine(_loc2_,1);
				this.startIndex = 0;
				this.endIndex = 1;
				this.maxEndIndex = 1;
			}
			this.TextYRate = this.BGSCodeObj.getScrollSpeed();
		}


		private function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.BackButton);
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}


		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(param1 == "Cancel" || param1 == "Start")
			{
				_loc3_ = this.onQuitPress();
			}
			return _loc3_;
		}


		public function onEnterFrame(e:Event) : void
		{
			if(this.endIndex == -1 || this.CreditsContainer.y + this.CreditsLines[this.endIndex].y + this.CreditsLines[this.endIndex].height <= this.EndY)
			{
				this.BGSCodeObj.closeMenu();
			}
			this.moveCredits(-this.TextYRate);
		}


		public function formatLine(param1:TextField, param2:int) : void
		{
			var _loc3_:int = this.CreditsFonts.length - 1;
			var _loc4_:* = this.CreditsStrings[param2];
			var _loc5_:Boolean = false;
			while(_loc3_ >= 0)
			{
				if(this.CreditsFonts[_loc3_].startIndex <= param2 && this.CreditsFonts[_loc3_].endIndex >= param2)
				{
					_loc5_ = true;
					if(this.CreditsFonts[_loc3_].startIndex != this.CreditsFonts[_loc3_].endIndex)
					{
						_loc4_ = this.CreditsFonts[_loc3_].fontString + _loc4_ + "</font>";
					}
				}
				_loc3_--;
			}
			param1.width = stage.stageWidth;
			TextFieldEx.setVerticalAutoSize(param1,TextFieldEx.VAUTOSIZE_TOP);
			TextFieldEx.appendHtml(param1,_loc4_);
			param1.height = Math.max(param1.textHeight,this.MinHeight);
			param1.autoSize = TextFieldAutoSize.CENTER;
			param1.textColor = this.TextColor;
			var _loc6_:TextFormat = param1.getTextFormat();
			if(!_loc5_)
			{
				_loc6_.font = "$MAIN_Font";
			}
			_loc6_.size = this.FontSize;
			param1.setTextFormat(_loc6_);
		}


		public function appendCredits(aCreditText:String) : void
		{
			var objBeginBlock:Object = null;
			var reBeginBlock:RegExp = null;
			var formattedList:Array = null;

			var objEndBlock:Object = null;
			var reEndBlock:RegExp = null;
			var iFontIndex:* = undefined;

			var bConditionA:Boolean = false;
			var bConditionB:Boolean = false;

			if(aCreditText.toLocaleLowerCase().search("<font") != -1)
			{
				bConditionA = true;
			}

			if(aCreditText.toLocaleLowerCase().search("</font>") != -1)
			{
				bConditionB = true;
			}

			if(bConditionA == bConditionB)
			{
				if(bConditionA)
				{
					objBeginBlock = new Object();
					objBeginBlock.startIndex = this.CreditsStrings.length;
					objBeginBlock.endIndex = this.CreditsStrings.length;
					objBeginBlock.fontString = "";
					this.CreditsFonts.push(objBeginBlock);
				}
				this.CreditsStrings.push(aCreditText);
			}
			else if(bConditionA)
			{
				reBeginBlock = /\<font(.*)\>/i;
				formattedList = aCreditText.match(reBeginBlock);

				objEndBlock = new Object();
				objEndBlock.startIndex = this.CreditsStrings.length;
				objEndBlock.endIndex = -1;
				objEndBlock.fontString = formattedList[0];

				this.CreditsFonts.push(objEndBlock);
				this.CreditsStrings.push(aCreditText.replace(reBeginBlock, ""));
			}
			else
			{ // "_loc8_" or "reEndBlock" had Syntax Error: 1093
				// I think this block parses for ending </tags> in credits.txt
				// I broke this :(
				reEndBlock = /\<font\>/i;
				iFontIndex = this.CreditsFonts.length - 1;
				while(iFontIndex >= 0)
				{
					if(this.CreditsFonts[iFontIndex].endIndex == -1)
					{
						this.CreditsFonts[iFontIndex].endIndex = this.CreditsStrings.length;
						iFontIndex = 0;
					}
					iFontIndex--;
				}
				this.CreditsStrings.push(aCreditText.replace(reEndBlock, ""));
			}
		}


		public function onMouseWheel(e:MouseEvent) : void
		{
			this.moveCredits(20 * e.delta);
		}


		public function onQuitPress() : Boolean
		{
			this.BGSCodeObj.closeMenu();
			return true;
		}


		private function moveCredits(param1:Number) : void
		{
			var _loc2_:int = 0;
			var _loc3_:* = undefined;
			var _loc4_:* = undefined;
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			this.CreditsContainer.y = this.CreditsContainer.y + param1;
			if(param1 < 0)
			{
				while(this.endIndex < this.CreditsStrings.length - 1 && this.CreditsContainer.y + this.CreditsLines[this.endIndex].y + this.CreditsLines[this.endIndex].height <= this.StartY)
				{
					if(this.endIndex >= this.maxEndIndex)
					{
						this.CreditsLines.push(new TextField());
					}
					else
					{
						this.CreditsLines[this.endIndex + 1] = new TextField();
					}
					_loc3_ = this.CreditsLines[this.endIndex + 1];
					this.CreditsContainer.addChild(_loc3_);
					_loc3_.y = this.CreditsLines[this.endIndex].y + this.CreditsLines[this.endIndex].height;
					this.formatLine(_loc3_,this.endIndex + 1);
					this.endIndex++;
					this.maxEndIndex = Math.max(this.endIndex,this.maxEndIndex);
				}
				while(this.startIndex < this.endIndex && this.CreditsContainer.y + this.CreditsLines[this.startIndex].y + this.CreditsLines[this.startIndex].height <= this.EndY)
				{
					this.CreditsContainer.removeChild(this.CreditsLines[this.startIndex]);
					this.CreditsLines[this.startIndex] = null;
					this.startIndex++;
				}
			}
			else if(param1 > 0)
			{
				while(this.startIndex > 0 && this.CreditsContainer.y + this.CreditsLines[this.startIndex].y + this.CreditsLines[this.startIndex].height >= this.EndY)
				{
					this.CreditsLines[this.startIndex - 1] = new TextField();
					_loc4_ = this.CreditsLines[this.startIndex - 1];
					this.CreditsContainer.addChild(_loc4_);
					this.formatLine(_loc4_,this.startIndex - 1);
					_loc4_.y = this.CreditsLines[this.startIndex].y - _loc4_.height;
					this.startIndex--;
				}
				while(this.endIndex > this.startIndex && this.CreditsContainer.y + this.CreditsLines[this.endIndex].y + this.CreditsLines[this.endIndex].height >= this.StartY)
				{
					this.CreditsContainer.removeChild(this.CreditsLines[this.endIndex]);
					this.CreditsLines[this.endIndex] = null;
					this.endIndex--;
				}
			}
			_loc2_ = this.startIndex;
			while(_loc2_ <= this.endIndex)
			{
				_loc5_ = this.CreditsContainer.y + this.CreditsLines[_loc2_].y + this.CreditsLines[_loc2_].height;
				_loc6_ = 0;
				if(_loc5_ <= this.FadeEnd)
				{
					_loc6_ = 1;
				}
				else if(_loc5_ >= this.FadeStart)
				{
					_loc6_ = 0;
				}
				else
				{
					_loc6_ = 1 - (_loc5_ - this.FadeEnd) / (this.FadeStart - this.FadeEnd);
				}
				this.CreditsLines[_loc2_].alpha = _loc6_;
				_loc2_++;
			}
		}



	}
}
