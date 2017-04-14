package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class BookMenu extends IMenu
	{
		
		private static var PAGE_BREAK_TAG:String = "[pagebreak]";
		
		private static var CACHED_PAGES:Number = 4;
		 
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var ReferenceTextInstance:MovieClip;
		
		private var PrevButton:BSButtonHintData;
		
		private var TakeButton:BSButtonHintData;
		
		private var NextButton:BSButtonHintData;
		
		private var ExitButton:BSButtonHintData;
		
		private var ReferenceText_mc:MovieClip;
		
		private var ReferenceTextField:TextField;
		
		private var RefTextFieldTextFormat:TextFormat;
		
		private var BookPages:Array;
		
		private var PageInfoA:Array;
		
		private var iLeftPageNumber:Number;
		
		private var iPageSetIndex:Number;
		
		private var iMaxPageHeight:Number;
		
		private var iNextPageBreak:Number;
		
		private var iCurrentLine:Number;
		
		public var BGSCodeObj:Object;
		
		private var bNote:Boolean;
		
		private var iInitialRefTextWidth:int = 0;
		
		private var iInitialRefTextHeight:int = 0;
		
		private var pointTextOffset:Point;
		
		private var timer:Timer;
		
		private var Language:String = "en";
		
		public function BookMenu()
		{
			this.PrevButton = new BSButtonHintData("$PREV","Up","PSN_L2","Xenon_L2",1,this.onPrevButton);
			this.TakeButton = new BSButtonHintData("$TAKE","E","PSN_A","Xenon_A",1,this.onTakeButton);
			this.NextButton = new BSButtonHintData("$NEXT","Down","PSN_R2","Xenon_R2",1,this.onNextButton);
			this.ExitButton = new BSButtonHintData("$EXIT","TAB","PSN_B","Xenon_B",1,this.onBackButton);
			super();
			this.BookPages = new Array();
			this.PageInfoA = new Array();
			this.iLeftPageNumber = 0;
			this.iPageSetIndex = 0;
			this.bNote = false;
			this.ReferenceText_mc = this["ReferenceTextInstance"];
			this.RefTextFieldTextFormat = this.ReferenceText_mc["PageTextField"].getTextFormat();
			this.ReferenceTextField = this.ReferenceText_mc["PageTextField"];
			this.iInitialRefTextWidth = this.ReferenceTextField.width;
			this.iInitialRefTextHeight = this.ReferenceTextField.height;
			TextFieldEx.setNoTranslate(this.ReferenceTextField,true);
			this.ReferenceTextField.setTextFormat(this.RefTextFieldTextFormat);
			this.ReferenceTextField.visible = false;
			this.iMaxPageHeight = this.iInitialRefTextHeight;
			this.BGSCodeObj = new Object();
			this.pointTextOffset = new Point(0,0);
			this.PopulateButtonBar();
			this.SetButtonVisibility(0,0,0);
			this.__setProp_ButtonHintBar_mc_Scene1_ButtonHintBar_mc_0();
		}
		
		public function set language(param1:String) : *
		{
			this.Language = param1.toLowerCase();
		}
		
		private function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.TakeButton);
			_loc1_.push(this.PrevButton);
			_loc1_.push(this.NextButton);
			_loc1_.push(this.ExitButton);
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		private function onPrevButton() : void
		{
		}
		
		private function onTakeButton() : void
		{
		}
		
		private function onNextButton() : void
		{
		}
		
		private function onBackButton() : void
		{
		}
		
		public function SetTextOffset(param1:Number, param2:Number) : *
		{
			this.pointTextOffset = new Point(param1,param2);
			var _loc3_:* = this.iInitialRefTextHeight - this.pointTextOffset.y;
			this.iMaxPageHeight = Math.min(this.iMaxPageHeight,_loc3_);
		}
		
		public function SetBookText(param1:String, param2:Boolean) : void
		{
			this.bNote = param2;
			this.ReferenceTextField.autoSize = TextFieldAutoSize.LEFT;
			if(param1.search("<p align=") == 0)
			{
				param1 = " " + param1;
			}
			GlobalFunc.SetText(this.ReferenceTextField,param1,true);
			if(param2)
			{
				this.ReferenceTextField.width = this.width;
			}
			this.PageInfoA.push({
				"startLine":0,
				"endLine":-1
			});
			this.iCurrentLine = 0;
			this.timer = new Timer(30);
			this.timer.addEventListener(TimerEvent.TIMER,this.CalculatePagination);
			this.timer.start();
			this.iNextPageBreak = this.iMaxPageHeight;
			this.SetLeftPageNumber(0);
		}
		
		private function CreateDisplayPage(param1:Number) : *
		{
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:* = undefined;
			var _loc7_:* = undefined;
			var _loc8_:Number = NaN;
			var _loc9_:Number = NaN;
			var _loc2_:RefText = new RefText();
			this.addChild(_loc2_);
			var _loc3_:TextField = _loc2_["PageTextField"];
			TextFieldEx.setNoTranslate(_loc3_,true);
			if(this.bNote)
			{
				_loc4_ = this.iInitialRefTextHeight - this.pointTextOffset.y;
				_loc3_.height = Math.min(_loc3_.height,_loc4_);
				this.ReferenceTextField.height = _loc3_.height;
				_loc5_ = this.iInitialRefTextWidth - this.pointTextOffset.x;
				_loc3_.width = Math.min(_loc3_.width,_loc5_);
				this.ReferenceTextField.width = _loc3_.width;
				_loc2_.x = Extensions.visibleRect.x + this.pointTextOffset.x;
				_loc2_.y = Extensions.visibleRect.y + this.pointTextOffset.y;
			}
			else
			{
				_loc2_.x = this.ReferenceText_mc.x;
				_loc2_.y = this.ReferenceText_mc.y;
			}
			if(this.Language == "ru" || this.Language == "pl")
			{
				_loc6_ = this.ReferenceTextField.htmlText;
				_loc7_ = _loc6_.replace("HandwrittenFont","$MAIN_Font");
				while(_loc7_ != _loc6_)
				{
					_loc6_ = _loc7_;
					_loc7_ = _loc6_.replace("HandwrittenFont","$MAIN_Font");
				}
				_loc6_ = _loc7_;
				_loc7_ = _loc6_.replace("Handwritten_Institute","$MAIN_Font");
				while(_loc7_ != _loc6_)
				{
					_loc6_ = _loc7_;
					_loc7_ = _loc6_.replace("Handwritten_Institute","$MAIN_Font");
				}
				_loc6_ = _loc7_;
				_loc7_ = _loc6_.replace("$$MAIN_Font","$MAIN_Font");
				while(_loc7_ != _loc6_)
				{
					_loc6_ = _loc7_;
					_loc7_ = _loc6_.replace("$$MAIN_Font","$MAIN_Font");
				}
				GlobalFunc.SetText(_loc3_,_loc7_,true);
			}
			else
			{
				GlobalFunc.SetText(_loc3_,this.ReferenceTextField.htmlText,true);
			}
			if(param1 < this.PageInfoA.length)
			{
				_loc8_ = this.ReferenceTextField.getLineOffset(this.PageInfoA[param1].startLine);
				_loc3_.replaceText(0,_loc8_,"");
				if(this.PageInfoA[param1].endLine >= 0)
				{
					_loc9_ = this.ReferenceTextField.getLineOffset(this.PageInfoA[param1].endLine);
					_loc9_ = _loc9_ + this.ReferenceTextField.getLineText(this.PageInfoA[param1].endLine).length;
					_loc3_.replaceText(_loc9_ - _loc8_,_loc3_.length,"");
				}
			}
			_loc3_.autoSize = "left";
			_loc2_.visible = false;
			_loc2_.pageNum = param1;
			this.BookPages.push(_loc2_);
			if(this.BookPages.length == 1)
			{
				_loc2_.visible = true;
			}
			else if(this.BookPages.length == 2)
			{
				this.SetButtonVisibility(-1,-1,1);
			}
		}
		
		public function SetButtonVisibility(param1:int, param2:int, param3:int) : void
		{
			if(param1 > 0)
			{
				this.PrevButton.ButtonVisible = true;
			}
			else if(param1 == 0)
			{
				this.PrevButton.ButtonVisible = false;
			}
			if(param2 > 0)
			{
				this.TakeButton.ButtonVisible = true;
			}
			else if(param2 == 0)
			{
				this.TakeButton.ButtonVisible = false;
			}
			if(param3 > 0)
			{
				this.NextButton.ButtonVisible = true;
			}
			else if(param3 == 0)
			{
				this.NextButton.ButtonVisible = false;
			}
		}
		
		private function CalculatePagination() : void
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc4_:Rectangle = null;
			var _loc5_:Rectangle = null;
			var _loc6_:String = null;
			var _loc7_:* = false;
			var _loc8_:Object = null;
			if(this.bNote)
			{
				this.ReferenceTextField.height = this.iInitialRefTextHeight - this.pointTextOffset.y;
				this.ReferenceTextField.width = this.iInitialRefTextWidth - this.pointTextOffset.x;
			}
			var _loc1_:Boolean = false;
			while(!_loc1_ && this.iCurrentLine < this.ReferenceTextField.numLines)
			{
				_loc2_ = this.ReferenceTextField.getLineOffset(this.iCurrentLine);
				_loc3_ = this.ReferenceTextField.getLineOffset(this.iCurrentLine + 1);
				_loc4_ = this.ReferenceTextField.getCharBoundaries(_loc2_);
				_loc5_ = _loc3_ >= 0?this.ReferenceTextField.getCharBoundaries(_loc3_):null;
				_loc6_ = _loc3_ != -1?this.ReferenceTextField.text.substring(_loc2_,_loc3_):this.ReferenceTextField.text.substring(_loc2_);
				_loc6_ = GlobalFunc.StringTrim(_loc6_);
				_loc7_ = _loc6_ == PAGE_BREAK_TAG;
				if(_loc4_ != null && _loc4_.bottom >= this.iNextPageBreak || _loc7_)
				{
					_loc8_ = {
						"startLine":this.iCurrentLine,
						"endLine":-1
					};
					if(_loc7_)
					{
						if(_loc5_ == null)
						{
							this.iNextPageBreak = _loc4_.bottom + this.iMaxPageHeight;
						}
						else
						{
							this.iNextPageBreak = _loc5_.top + this.iMaxPageHeight;
						}
						_loc8_.startLine++;
					}
					else
					{
						this.iNextPageBreak = _loc4_.top + this.iMaxPageHeight;
					}
					this.PageInfoA[this.PageInfoA.length - 1].endLine = this.iCurrentLine - 1;
					this.PageInfoA.push(_loc8_);
					_loc1_ = true;
				}
				this.iCurrentLine++;
			}
			if(this.iCurrentLine >= this.ReferenceTextField.numLines)
			{
				this.timer.stop();
			}
			this.UpdatePages();
			if(this.bNote)
			{
				this.ReferenceTextField.height = this.iInitialRefTextHeight + this.pointTextOffset.y;
				this.ReferenceTextField.width = this.iInitialRefTextWidth + this.pointTextOffset.x;
			}
		}
		
		private function SetLeftPageNumber(param1:Number) : void
		{
			if(param1 < this.PageInfoA.length)
			{
				this.iLeftPageNumber = param1;
			}
		}
		
		public function ShowPageAtOffset(param1:Number) : void
		{
			var _loc2_:Number = 0;
			while(_loc2_ < this.BookPages.length)
			{
				if(this.BookPages[_loc2_].pageNum == this.iPageSetIndex + param1)
				{
					this.BookPages[_loc2_].visible = true;
				}
				else
				{
					this.BookPages[_loc2_].visible = false;
				}
				_loc2_++;
			}
		}
		
		public function PrepForClose() : *
		{
			this.iPageSetIndex = this.iLeftPageNumber;
		}
		
		public function TurnPage(param1:Number) : Boolean
		{
			var _loc5_:* = undefined;
			var _loc6_:int = 0;
			var _loc7_:int = 0;
			var _loc2_:Number = this.iLeftPageNumber + param1;
			var _loc3_:Boolean = _loc2_ >= 0 && _loc2_ < this.PageInfoA.length;
			var _loc4_:Number = Math.abs(param1);
			if(_loc3_)
			{
				_loc5_ = _loc4_ == 1?1:4;
				this.SetLeftPageNumber(_loc2_);
				if(this.iLeftPageNumber < this.iPageSetIndex)
				{
					this.iPageSetIndex = this.iPageSetIndex - _loc4_;
				}
				else if(this.iLeftPageNumber >= this.iPageSetIndex + _loc5_)
				{
					this.iPageSetIndex = this.iPageSetIndex + _loc4_;
				}
				_loc6_ = -1;
				_loc7_ = -1;
				if(_loc2_ == 0)
				{
					_loc6_ = 0;
				}
				else
				{
					_loc6_ = 1;
				}
				if(_loc2_ == this.PageInfoA.length - 1)
				{
					_loc7_ = 0;
				}
				else
				{
					_loc7_ = 1;
				}
				this.SetButtonVisibility(_loc6_,-1,_loc7_);
				this.UpdatePages();
				this.ShowPageAtOffset(0);
			}
			return _loc3_;
		}
		
		public function UpdatePages() : *
		{
			var _loc2_:Boolean = false;
			var _loc3_:Number = NaN;
			var _loc1_:Number = 0;
			while(_loc1_ < CACHED_PAGES)
			{
				_loc2_ = false;
				_loc3_ = 0;
				while(!_loc2_ && _loc3_ < this.BookPages.length)
				{
					if(this.BookPages[_loc3_].pageNum == this.iPageSetIndex + _loc1_)
					{
						_loc2_ = true;
					}
					_loc3_++;
				}
				if(!_loc2_ && (this.PageInfoA.length > this.iPageSetIndex + _loc1_ + 1 || !this.timer.running && this.PageInfoA.length > this.iPageSetIndex + _loc1_))
				{
					this.CreateDisplayPage(this.iPageSetIndex + _loc1_);
				}
				_loc1_++;
			}
		}
		
		function __setProp_ButtonHintBar_mc_Scene1_ButtonHintBar_mc_0() : *
		{
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ButtonHintBar_mc.BackgroundAlpha = 1;
			this.ButtonHintBar_mc.BackgroundColor = 0;
			this.ButtonHintBar_mc.bracketCornerLength = 6;
			this.ButtonHintBar_mc.bracketLineWidth = 1.5;
			this.ButtonHintBar_mc.BracketStyle = "horizontal";
			this.ButtonHintBar_mc.bRedirectToButtonBarMenu = true;
			this.ButtonHintBar_mc.bShowBrackets = true;
			this.ButtonHintBar_mc.bUseShadedBackground = true;
			this.ButtonHintBar_mc.ShadedBackgroundMethod = "Shader";
			this.ButtonHintBar_mc.ShadedBackgroundType = "default";
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
