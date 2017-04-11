package
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class Console extends MovieClip
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var CommandEntry:TextField;
		
		public var Background:MovieClip;
		
		public var CommandHistory:TextField;
		
		public var CurrentSelection:TextField;
		
		public var CommandPrompt_tf:TextField;
		
		private const PREVIOUS_COMMANDS:uint = 32;
		
		private var HistoryCharBufferSize:uint = 8192;
		
		private var CurrentSelectionYOffset:Number;
		
		private var TextXOffset:Number;
		
		private var Commands:Array;
		
		private var PreviousCommandOffset:int;
		
		private var OriginalWidth:Number;
		
		private var OriginalHeight:Number;
		
		private var ScreenPercent:Number;
		
		private var Shown:Boolean;
		
		private var Animating:Boolean;
		
		private var Hiding:Boolean;
		
		public function Console()
		{
			this.Commands = new Array();
			super();
			this.BGSCodeObj = new Object();
			Extensions.enabled = true;
			this.CurrentSelectionYOffset = this.height + this.CurrentSelection.y;
			this.TextXOffset = this.CommandEntry.x;
			this.OriginalHeight = stage.stageHeight;
			this.OriginalWidth = stage.stageWidth;
			this.ScreenPercent = 100 * (this.height / stage.stageHeight);
			this.PreviousCommandOffset = 0;
			this.Shown = false;
			this.Animating = false;
			this.Hiding = false;
			this.CommandEntry.defaultTextFormat = this.CommandEntry.getTextFormat();
			this.CommandEntry.text = "";
			TextFieldEx.setNoTranslate(this.CommandEntry,true);
			this.CurrentSelection.defaultTextFormat = this.CurrentSelection.getTextFormat();
			this.CurrentSelection.text = "";
			TextFieldEx.setNoTranslate(this.CurrentSelection,true);
			this.CommandHistory.defaultTextFormat = this.CommandHistory.getTextFormat();
			this.CommandHistory.text = "";
			TextFieldEx.setNoTranslate(this.CommandHistory,true);
			stage.align = StageAlign.BOTTOM_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE,this.onResize);
			addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			this.onResize();
		}
		
		public function get shown() : Boolean
		{
			return this.Shown && !this.Animating;
		}
		
		public function get hiding() : Boolean
		{
			return this.Hiding;
		}
		
		public function set currentSelection(param1:String) : *
		{
			GlobalFunc.SetText(this.CurrentSelection,param1,false);
		}
		
		public function set historyCharBufferSize(param1:uint) : *
		{
			this.HistoryCharBufferSize = param1;
		}
		
		public function set historyTextColor(param1:uint) : *
		{
			this.CommandHistory.textColor = param1;
		}
		
		public function set textColor(param1:uint) : *
		{
			this.CommandEntry.textColor = param1;
			this.CurrentSelection.textColor = param1;
		}
		
		public function set textSize(param1:uint) : *
		{
			var _loc2_:TextFormat = null;
			_loc2_ = this.CurrentSelection.defaultTextFormat;
			_loc2_.size = Math.max(1,param1);
			this.CurrentSelection.setTextFormat(_loc2_);
			this.CurrentSelection.defaultTextFormat = _loc2_;
			_loc2_ = this.CommandHistory.defaultTextFormat;
			_loc2_.size = Math.max(1,param1 - 2);
			this.CommandHistory.setTextFormat(_loc2_);
			this.CommandHistory.defaultTextFormat = _loc2_;
			_loc2_ = this.CommandEntry.defaultTextFormat;
			_loc2_.size = Math.max(1,param1);
			this.CommandEntry.setTextFormat(_loc2_);
			this.CommandEntry.defaultTextFormat = _loc2_;
			this.PositionTextFields();
		}
		
		public function set size(param1:Number) : *
		{
			this.ScreenPercent = param1;
			param1 = param1 / 100;
			this.Background.height = stage.stageHeight * param1;
			this.PositionTextFields();
		}
		
		public function PositionTextFields() : *
		{
			this.CurrentSelection.y = this.CurrentSelectionYOffset - this.Background.height;
			this.CommandHistory.y = this.CurrentSelection.y + this.CurrentSelection.height;
			this.CommandHistory.height = this.CommandEntry.y - this.CommandHistory.y;
		}
		
		public function Show() : *
		{
			if(!this.Animating)
			{
				parent.y = this.OriginalHeight;
				(parent as MovieClip).gotoAndPlay("show_anim");
				stage.focus = this.CommandEntry;
				this.Animating = true;
				this.CommandEntry.setSelection(this.CommandEntry.length,this.CommandEntry.length);
			}
		}
		
		public function ShowComplete() : *
		{
			this.Shown = true;
			this.Animating = false;
		}
		
		public function Hide() : *
		{
			if(!this.Animating)
			{
				(parent as MovieClip).gotoAndPlay("hide_anim");
				stage.focus = null;
				this.ResetCommandEntry();
				this.Animating = true;
				this.Hiding = true;
			}
		}
		
		public function HideComplete() : *
		{
			this.Shown = false;
			this.Animating = false;
			this.Hiding = false;
			this.BGSCodeObj.onHideComplete();
		}
		
		public function Minimize() : *
		{
			parent.y = this.OriginalHeight - this.CommandHistory.y;
		}
		
		public function PreviousCommand() : *
		{
			if(this.PreviousCommandOffset < this.Commands.length)
			{
				this.PreviousCommandOffset++;
			}
			if(0 != this.Commands.length && 0 != this.PreviousCommandOffset)
			{
				GlobalFunc.SetText(this.CommandEntry,this.Commands[this.Commands.length - this.PreviousCommandOffset],false);
				this.CommandEntry.setSelection(this.CommandEntry.length,this.CommandEntry.length);
			}
		}
		
		public function NextCommand() : *
		{
			if(this.PreviousCommandOffset > 1)
			{
				this.PreviousCommandOffset--;
			}
			if(0 != this.Commands.length && 0 != this.PreviousCommandOffset)
			{
				GlobalFunc.SetText(this.CommandEntry,this.Commands[this.Commands.length - this.PreviousCommandOffset],false);
				this.CommandEntry.setSelection(this.CommandEntry.length,this.CommandEntry.length);
			}
		}
		
		public function AddHistory(param1:String) : *
		{
			GlobalFunc.SetText(this.CommandHistory,this.CommandHistory.text + param1,false);
			if(this.CommandHistory.text.length > this.HistoryCharBufferSize)
			{
				GlobalFunc.SetText(this.CommandHistory,this.CommandHistory.text.substr(-this.HistoryCharBufferSize),false);
			}
			this.CommandHistory.scrollV = this.CommandHistory.maxScrollV;
		}
		
		public function SetCommandPrompt(param1:String) : *
		{
			GlobalFunc.SetText(this.CommandPrompt_tf,param1,false);
			this.CommandEntry.x = this.CommandPrompt_tf.x + this.CommandPrompt_tf.getLineMetrics(0).width + 10;
		}
		
		public function ClearHistory() : *
		{
			this.CommandHistory.text = "";
		}
		
		public function ResetCommandEntry() : *
		{
			this.CommandEntry.text = "";
			this.PreviousCommandOffset = 0;
		}
		
		public function onKeyUp(param1:KeyboardEvent) : *
		{
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			if(param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NUMPAD_ENTER)
			{
				if(this.Commands.length >= this.PREVIOUS_COMMANDS)
				{
					this.Commands.shift();
				}
				this.Commands.push(this.CommandEntry.text);
				this.BGSCodeObj.executeCommand(this.CommandEntry.text);
				this.ResetCommandEntry();
			}
			else if(param1.keyCode == Keyboard.PAGE_UP)
			{
				_loc2_ = this.CommandHistory.bottomScrollV - this.CommandHistory.scrollV;
				_loc3_ = this.CommandHistory.scrollV - _loc2_;
				this.CommandHistory.scrollV = _loc3_ > 0?int(_loc3_):0;
			}
			else if(param1.keyCode == Keyboard.PAGE_DOWN)
			{
				_loc2_ = this.CommandHistory.bottomScrollV - this.CommandHistory.scrollV;
				_loc3_ = this.CommandHistory.scrollV + _loc2_;
				this.CommandHistory.scrollV = _loc3_ <= this.CommandHistory.maxScrollV?int(_loc3_):int(this.CommandHistory.maxScrollV);
			}
		}
		
		public function onResize() : *
		{
			this.Background.width = stage.stageWidth;
			this.CommandEntry.width = this.CommandHistory.width = this.CurrentSelection.width = stage.stageWidth - this.TextXOffset * 2;
			this.size = this.ScreenPercent;
		}
	}
}
