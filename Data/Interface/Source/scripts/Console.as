package
{
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
	import Shared.GlobalFunc;


	public class Console extends MovieClip
	{
		public var BGSCodeObj:Object;
		public var Background:MovieClip;
		public var CommandEntry:TextField;
		public var CommandHistory:TextField;
		public var CommandPrompt_tf:TextField;
		public var CurrentSelection:TextField;

		private var Commands:Array;
		private var TextXOffset:Number;
		private var CurrentSelectionYOffset:Number;
		private var PreviousCommandOffset:int;

		private var OriginalHeight:Number;
		private var OriginalWidth:Number;
		private var ScreenPercent:Number;

		private var Shown:Boolean;
		private var Animating:Boolean;
		private var Hiding:Boolean;

		private var HistoryCharBufferSize:uint = 8192;
		private const PREVIOUS_COMMANDS:uint = 32;


// Class
//====================================================================================================

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
			TextFieldEx.setNoTranslate(this.CommandEntry, true);
			this.CurrentSelection.defaultTextFormat = this.CurrentSelection.getTextFormat();
			this.CurrentSelection.text = "";
			TextFieldEx.setNoTranslate(this.CurrentSelection, true);
			this.CommandHistory.defaultTextFormat = this.CommandHistory.getTextFormat();
			this.CommandHistory.text = "";
			TextFieldEx.setNoTranslate(this.CommandHistory, true);
			stage.align = StageAlign.BOTTOM_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, this.onResize);
			addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
			this.onResize();
		}


		public function onResize() : *
		{
			this.Background.width = stage.stageWidth;
			this.CommandEntry.width = this.CommandHistory.width = this.CurrentSelection.width = stage.stageWidth - this.TextXOffset * 2;
			this.size = this.ScreenPercent;
		}


		public function onKeyUp(e:KeyboardEvent) : *
		{
			var iRangeA:int = 0;
			var iRangeB:int = 0;
			if(e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.NUMPAD_ENTER)
			{
				if(this.Commands.length >= this.PREVIOUS_COMMANDS)
				{
					this.Commands.shift();
				}
				this.Commands.push(this.CommandEntry.text);
				this.BGSCodeObj.executeCommand(this.CommandEntry.text);
				this.ResetCommandEntry();
			}
			else if(e.keyCode == Keyboard.PAGE_UP)
			{
				iRangeA = this.CommandHistory.bottomScrollV - this.CommandHistory.scrollV;
				iRangeB = this.CommandHistory.scrollV - iRangeA;
				this.CommandHistory.scrollV = iRangeB > 0?int(iRangeB):0;
			}
			else if(e.keyCode == Keyboard.PAGE_DOWN)
			{
				iRangeA = this.CommandHistory.bottomScrollV - this.CommandHistory.scrollV;
				iRangeB = this.CommandHistory.scrollV + iRangeA;
				this.CommandHistory.scrollV = iRangeB <= this.CommandHistory.maxScrollV?int(iRangeB):int(this.CommandHistory.maxScrollV);
			}
		}



// Display
//====================================================================================================

		public function Show() : *
		{
			if(!this.Animating)
			{
				parent.y = this.OriginalHeight;
				(parent as MovieClip).gotoAndPlay("show_anim");
				stage.focus = this.CommandEntry;
				this.Animating = true;
				this.CommandEntry.setSelection(this.CommandEntry.length, this.CommandEntry.length);
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


		public function PositionTextFields() : *
		{
			this.CurrentSelection.y = this.CurrentSelectionYOffset - this.Background.height;
			this.CommandHistory.y = this.CurrentSelection.y + this.CurrentSelection.height;
			this.CommandHistory.height = this.CommandEntry.y - this.CommandHistory.y;
		}



// Menu
//====================================================================================================

		public function PreviousCommand() : *
		{
			if(this.PreviousCommandOffset < this.Commands.length)
			{
				this.PreviousCommandOffset++;
			}
			if(0 != this.Commands.length && 0 != this.PreviousCommandOffset)
			{
				GlobalFunc.SetText(this.CommandEntry, this.Commands[this.Commands.length - this.PreviousCommandOffset], false);
				this.CommandEntry.setSelection(this.CommandEntry.length, this.CommandEntry.length);
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
				GlobalFunc.SetText(this.CommandEntry, this.Commands[this.Commands.length - this.PreviousCommandOffset], false);
				this.CommandEntry.setSelection(this.CommandEntry.length, this.CommandEntry.length);
			}
		}


		public function AddHistory(aText:String) : *
		{
			GlobalFunc.SetText(this.CommandHistory, this.CommandHistory.text + aText, false);
			if(this.CommandHistory.text.length > this.HistoryCharBufferSize)
			{
				GlobalFunc.SetText(this.CommandHistory, this.CommandHistory.text.substr(-this.HistoryCharBufferSize), false);
			}
			this.CommandHistory.scrollV = this.CommandHistory.maxScrollV;
		}


		public function SetCommandPrompt(aCommand:String) : *
		{
			GlobalFunc.SetText(this.CommandPrompt_tf, aCommand, false);
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



// Properties
//====================================================================================================


		public function get shown() : Boolean
		{
			return Boolean(this.Shown) && !this.Animating;
		}


		public function get hiding() : Boolean
		{
			return this.Hiding;
		}


		public function set currentSelection(aSelection:String) : *
		{
			GlobalFunc.SetText(this.CurrentSelection, aSelection, false);
		}


		public function set historyCharBufferSize(aSize:uint) : *
		{
			this.HistoryCharBufferSize = aSize;
		}


		public function set historyTextColor(aColor:uint) : *
		{
			this.CommandHistory.textColor = aColor;
		}


		public function set textColor(aColor:uint) : *
		{
			this.CommandEntry.textColor = aColor;
			this.CurrentSelection.textColor = aColor;
		}


		public function set textSize(aTextSize:uint) : *
		{
			var tf:TextFormat = null;
			tf = this.CurrentSelection.defaultTextFormat;
			tf.size = Math.max(1, aTextSize);
			this.CurrentSelection.setTextFormat(tf);
			this.CurrentSelection.defaultTextFormat = tf;
			tf = this.CommandHistory.defaultTextFormat;
			tf.size = Math.max(1, aTextSize - 2);
			this.CommandHistory.setTextFormat(tf);
			this.CommandHistory.defaultTextFormat = tf;
			tf = this.CommandEntry.defaultTextFormat;
			tf.size = Math.max(1, aTextSize);
			this.CommandEntry.setTextFormat(tf);
			this.CommandEntry.defaultTextFormat = tf;
			this.PositionTextFields();
		}


		public function set size(aSize:Number) : *
		{
			this.ScreenPercent = aSize;
			aSize = aSize / 100;
			this.Background.height = stage.stageHeight * aSize;
			this.PositionTextFields();
		}


	}
}
