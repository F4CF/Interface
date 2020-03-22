package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.IMenu;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
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
			this.BackButton = new BSButtonHintData("$BACK","Esc","PSN_B","Xenon_B",1,this.onQuitPress);
			super();
			this.BGSCodeObj = new Object();
			Extensions.enabled = true;
			this.CreditsLines = new Array();
			this.CreditsStrings = new Array();
			this.CreditsFonts = new Array();
			this.startIndex = -1;
			this.endIndex = -1;
			this.maxEndIndex = -1;
			addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
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
			removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
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
		
		public function onEnterFrame(param1:Event) : void
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
		
		public function appendCredits(param1:String) : void
		{
			var _loc4_:Object = null;
			var _loc5_:RegExp = null;
			var _loc6_:Array = null;
			var _loc7_:Object = null;
			var _loc8_:RegExp = null;
			var _loc9_:* = undefined;
			var _loc2_:Boolean = false;
			var _loc3_:Boolean = false;
			if(param1.toLocaleLowerCase().search("<font") != -1)
			{
				_loc2_ = true;
			}
			if(param1.toLocaleLowerCase().search("</font>") != -1)
			{
				_loc3_ = true;
			}
			if(_loc2_ == _loc3_)
			{
				if(_loc2_)
				{
					_loc4_ = new Object();
					_loc4_.startIndex = this.CreditsStrings.length;
					_loc4_.endIndex = this.CreditsStrings.length;
					_loc4_.fontString = "";
					this.CreditsFonts.push(_loc4_);
				}
				this.CreditsStrings.push(param1);
			}
			else if(_loc2_)
			{
				_loc5_ = /\<font(.*)\>/i;
				_loc6_ = param1.match(_loc5_);
				_loc7_ = new Object();
				_loc7_.startIndex = this.CreditsStrings.length;
				_loc7_.endIndex = -1;
				_loc7_.fontString = _loc6_[0];
				this.CreditsFonts.push(_loc7_);
				this.CreditsStrings.push(param1.replace(_loc5_,""));
			}
			else
			{
				_loc8_ = /\<\/font\>/i;
				_loc9_ = this.CreditsFonts.length - 1;
				while(_loc9_ >= 0)
				{
					if(this.CreditsFonts[_loc9_].endIndex == -1)
					{
						this.CreditsFonts[_loc9_].endIndex = this.CreditsStrings.length;
						_loc9_ = 0;
					}
					_loc9_--;
				}
				this.CreditsStrings.push(param1.replace(_loc8_,""));
			}
		}
		
		public function onMouseWheel(param1:MouseEvent) : void
		{
			this.moveCredits(20 * param1.delta);
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
