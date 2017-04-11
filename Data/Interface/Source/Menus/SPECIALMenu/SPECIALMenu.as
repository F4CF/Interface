package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import Shared.PlatformChangeEvent;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	public class SPECIALMenu extends IMenu
	{
		 
		
		public var List_mc:BSScrollingList;
		
		public var PointCounter_tf:TextField;
		
		public var Description_tf:TextField;
		
		public var NameEntry_tf:TextField;
		
		public var Caption_tf:TextField;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var Background_mc:MovieClip;
		
		public var BackgroundBrackets_mc:MovieClip;
		
		public var VBHolder_mc:MovieClip;
		
		private var _VBLoader:Loader;
		
		protected var ExitButton:BSButtonHintData;
		
		protected var ResetButton:BSButtonHintData;
		
		private const SPECIALClipNameMap:Array = ["Name_Clip","Strength","Perception","Endurance","Charisma","Intelligence","Agility","Luck"];
		
		private const SPECIALClipSoundMap:Array = ["UIPerkMenuChargenName","UIPerkMenuChargenStrengthTraining","UIPerkMenuChargenPerceptionTraining","UIPerkMenuChargenEnduranceTraining","UIPerkMenuChargenCharismaTraining","UIPerkMenuChargenIntelligenceTraining","UIPerkMenuChargenAgilityTraining","UIPerkMenuChargenLuckTraining"];
		
		public var BGSCodeObj:Object;
		
		private var InputText:TextField;
		
		private var InputTextBaseX:Number;
		
		private var InputTextSpaceWidth:Number;
		
		private var initialValues:Array;
		
		private var uiCurrPoints:uint;
		
		private var uiMaxPoints:uint;
		
		private var uiCaptionBufferX:uint = 10;
		
		public function SPECIALMenu()
		{
			this.ExitButton = new BSButtonHintData("$ACCEPT","R","PSN_X","Xenon_X",1,this.onExitButtonClicked);
			this.ResetButton = new BSButtonHintData("$RESET","T","PSN_Y","Xenon_Y",1,this.onResetButtonClicked);
			super();
			this.BGSCodeObj = new Object();
			this.uiCurrPoints = 0;
			this.uiMaxPoints = 0;
			this._VBLoader = new Loader();
			this.Caption_tf.autoSize = TextFieldAutoSize.LEFT;
			this.PopulateButtonBar();
			var _loc1_:MovieClip = this.BackgroundBrackets_mc.TopBorderRight_mc;
			var _loc2_:Number = _loc1_.x + _loc1_.width;
			var _loc3_:Number = this.Caption_tf.x + this.Caption_tf.textWidth + this.uiCaptionBufferX;
			var _loc4_:Number = _loc3_ - this.BackgroundBrackets_mc.x;
			_loc1_.x = _loc4_ / this.BackgroundBrackets_mc.scaleX;
			_loc1_.width = _loc2_ - _loc1_.x;
			addEventListener(KeyboardEvent.KEY_DOWN,this.onMenuKeyDown);
			addEventListener(KeyboardEvent.KEY_UP,this.onMenuKeyUp);
			addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPress);
			addEventListener(BSScrollingList.SELECTION_CHANGE,this.onSelectionChange);
			addEventListener(ArrowButton.MOUSE_UP,this.onArrowClick);
			this.__setProp_List_mc_MenuObj_List_mc_0();
		}
		
		public function get editingName() : Boolean
		{
			return stage.focus == this.InputText;
		}
		
		private function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.ResetButton);
			_loc1_.push(this.ExitButton);
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		public function get pointsRemaining() : int
		{
			return this.uiMaxPoints - this.uiCurrPoints;
		}
		
		public function get isDirty() : Boolean
		{
			var _loc1_:Boolean = false;
			var _loc2_:* = 0;
			while(!_loc1_ && _loc2_ < 7)
			{
				if(this.List_mc.entryList[_loc2_ + 1].value != this.initialValues[_loc2_])
				{
					_loc1_ = true;
				}
				_loc2_++;
			}
			return _loc1_;
		}
		
		private function TrimString(param1:*) : String
		{
			var _loc2_:String = param1.replace(/^\s+|\s+$/g,"");
			_loc2_ = _loc2_.replace(/[<]+/g,"");
			return _loc2_;
		}
		
		public function onTextChangeListener(param1:Event) : *
		{
			var _loc3_:* = undefined;
			var _loc2_:Number = 0;
			if(this.InputText.text.length)
			{
				_loc3_ = this.InputText.text.length - 1;
				while(_loc3_ >= 0)
				{
					if(this.InputText.text.charAt(_loc3_) == " ")
					{
						_loc2_++;
						_loc3_--;
						continue;
					}
					break;
				}
			}
			this.InputText.x = this.InputTextBaseX - this.InputTextSpaceWidth * _loc2_;
		}
		
		public function onCodeObjCreate() : *
		{
			var _loc2_:String = null;
			this.uiMaxPoints = this.BGSCodeObj.initMenu(this.List_mc.entryList);
			this.initialValues = new Array();
			var _loc1_:* = 0;
			while(_loc1_ < 7)
			{
				this.initialValues[_loc1_] = this.List_mc.entryList[_loc1_ + 1].value;
				_loc1_++;
			}
			this.UpdateCounterAndButtons();
			this.List_mc.InvalidateData();
			stage.focus = this.List_mc;
			this.List_mc.selectedIndex = 0;
			this.InputText = this.List_mc.GetClipByIndex(0).textField;
			this.InputTextBaseX = this.InputText.x;
			_loc2_ = this.TrimString(this.InputText.text);
			this.InputText.text = " ";
			this.InputTextSpaceWidth = this.InputText.textWidth;
			this.InputText.text = _loc2_;
			this.InputText.addEventListener(Event.CHANGE,this.onTextChangeListener,false,0,true);
		}
		
		private function onItemPress(param1:Event) : *
		{
			if(this.List_mc.selectedIndex == 0)
			{
				if(this.InputText.type != TextFieldType.INPUT)
				{
					if(this.BGSCodeObj.startEditText())
					{
						this.StartEditText();
					}
				}
				else
				{
					this.EndEditText();
				}
			}
		}
		
		private function StartEditText() : *
		{
			var _loc1_:String = null;
			_loc1_ = this.TrimString(this.InputText.text);
			this.InputText.text = _loc1_;
			this.List_mc.disableInput = true;
			this.InputText.type = TextFieldType.INPUT;
			this.InputText.selectable = true;
			this.InputText.maxChars = 26;
			stage.focus = this.InputText;
			this.InputText.setSelection(0,this.InputText.text.length);
		}
		
		private function EndEditText(param1:Boolean = false) : *
		{
			this.InputText.type = TextFieldType.DYNAMIC;
			this.InputText.setSelection(0,0);
			this.InputText.selectable = false;
			this.InputText.maxChars = 0;
			this.List_mc.disableInput = false;
			stage.focus = this.List_mc;
			this.List_mc.entryList[0].text = this.TrimString(this.InputText.text);
			if(this.List_mc.entryList[0].text != this.InputText.text)
			{
				this.InputText.text = this.List_mc.entryList[0].text;
				this.onTextChangeListener(null);
			}
			if(!param1)
			{
				this.BGSCodeObj.endEditText(this.List_mc.entryList[0].text);
			}
			this.UpdateCounterAndButtons();
			this.BGSCodeObj.playSound("UIMenuOK");
		}
		
		public function onMenuKeyUp(param1:KeyboardEvent) : *
		{
			if(this.List_mc.selectedIndex == 0 && (uiPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE || uiPlatform == PlatformChangeEvent.PLATFORM_PC_GAMEPAD))
			{
				if((param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.TAB) && stage.focus == this.InputText)
				{
					this.EndEditText();
				}
			}
		}
		
		public function onMenuKeyDown(param1:KeyboardEvent) : *
		{
			if(this.List_mc.selectedIndex != 0)
			{
				if(param1.keyCode == Keyboard.LEFT)
				{
					this.ModSelectedValue(-1);
				}
				else if(param1.keyCode == Keyboard.RIGHT)
				{
					this.ModSelectedValue(1);
				}
			}
		}
		
		private function ModListEntryValue(param1:int, param2:int, param3:Boolean) : *
		{
			if(param2 < 0 && this.uiCurrPoints > 0 && this.List_mc.entryList[param1].value > 1 || param2 > 0 && this.uiCurrPoints < this.uiMaxPoints && this.List_mc.entryList[param1].value < 10)
			{
				this.BGSCodeObj.modValue(param1,param2);
				this.uiCurrPoints = this.uiCurrPoints + param2;
				this.List_mc.UpdateList();
				this.UpdateCounterAndButtons();
				if(param3)
				{
					this.BGSCodeObj.playSound("UIMenuPrevNext");
				}
			}
		}
		
		private function ModSelectedValue(param1:int) : *
		{
			this.ModListEntryValue(this.List_mc.selectedClipIndex,param1,true);
		}
		
		private function onArrowClick(param1:Event) : *
		{
			if(param1.target.name == "DecrementArrow")
			{
				this.ModSelectedValue(-1);
			}
			else
			{
				this.ModSelectedValue(1);
			}
		}
		
		private function onResetButtonClicked() : void
		{
			if(this.BGSCodeObj)
			{
				this.BGSCodeObj.confirmResetPoints();
				this.BGSCodeObj.playSound("UIMenuPopupGeneric");
			}
		}
		
		private function onExitButtonClicked() : void
		{
			if(this.BGSCodeObj)
			{
				this.BGSCodeObj.tryCloseMenu();
				this.BGSCodeObj.playSound("UIMenuOK");
			}
		}
		
		public function onVirtualKeyboardResult(param1:String, param2:Boolean) : *
		{
			if(param2)
			{
				param1 = param1.replace(/[<]+/g,"");
				this.InputText.text = param1;
			}
			this.EndEditText(param2);
		}
		
		public function CancelVirtualKeyboardNameEdit(param1:String) : *
		{
			var executeDelayed:* = undefined;
			var aOldText:String = param1;
			executeDelayed = function delayedFunc(param1:Event):void
			{
				stage.focus = Description_tf;
				InputText.text = aOldText;
				EndEditText(true);
				removeEventListener(Event.ENTER_FRAME,executeDelayed);
			};
			addEventListener(Event.ENTER_FRAME,executeDelayed);
		}
		
		protected function UpdateCounterAndButtons() : *
		{
			var _loc1_:* = undefined;
			var _loc2_:* = undefined;
			this.uiCurrPoints = 0;
			for(_loc1_ in this.List_mc.entryList)
			{
				if(this.List_mc.entryList[_loc1_].value != undefined)
				{
					this.uiCurrPoints = this.uiCurrPoints + this.List_mc.entryList[_loc1_].value;
				}
			}
			this.ResetButton.ButtonEnabled = this.isDirty;
			GlobalFunc.SetText(this.PointCounter_tf,(this.uiMaxPoints - this.uiCurrPoints).toString(),false);
			_loc2_ = this.TrimString(this.List_mc.entryList[0].text);
			this.ExitButton.ButtonEnabled = this.uiCurrPoints == this.uiMaxPoints && _loc2_.length > 0;
		}
		
		private function onSelectionChange(param1:Event) : *
		{
			var _loc2_:URLRequest = null;
			var _loc3_:LoaderContext = null;
			if(this.List_mc.selectedEntry && this.List_mc.selectedEntry.description)
			{
				GlobalFunc.SetText(this.Description_tf,this.List_mc.selectedEntry.description,false);
				_loc2_ = new URLRequest("Components/VaultBoys/SPECIAL/" + this.SPECIALClipNameMap[this.List_mc.selectedIndex] + ".swf");
				_loc3_ = new LoaderContext(false,ApplicationDomain.currentDomain);
				this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVBLoadComplete);
				this._VBLoader.load(_loc2_,_loc3_);
			}
			else
			{
				GlobalFunc.SetText(this.Description_tf,"",false);
				if(this.VBHolder_mc.numChildren > 0)
				{
					this.VBHolder_mc.removeChildAt(0);
				}
			}
			this.BGSCodeObj.playSound("UIMenuFocus");
		}
		
		private function onPerkAnimUpdate(param1:Event) : *
		{
			if(this.List_mc.selectedIndex >= 0 && param1.target.currentFrame == 1)
			{
				this.BGSCodeObj.PlayPerkSound(this.SPECIALClipSoundMap[this.List_mc.selectedIndex]);
			}
		}
		
		private function onVBLoadComplete(param1:Event) : *
		{
			var _loc2_:DisplayObject = null;
			param1.target.removeEventListener(Event.COMPLETE,this.onVBLoadComplete);
			if(this.VBHolder_mc.numChildren > 0)
			{
				_loc2_ = this.VBHolder_mc.getChildAt(0);
				this.VBHolder_mc.removeChild(_loc2_);
				_loc2_.removeEventListener(Event.ENTER_FRAME,this.onPerkAnimUpdate);
				this.BGSCodeObj.StopPerkSound();
			}
			this.VBHolder_mc.addChild(param1.target.content);
			param1.target.content.addEventListener(Event.ENTER_FRAME,this.onPerkAnimUpdate);
			this.BGSCodeObj.PlayPerkSound(this.SPECIALClipSoundMap[this.List_mc.selectedIndex]);
		}
		
		public function ResetPoints() : *
		{
			var _loc1_:* = undefined;
			var _loc2_:int = 0;
			this.BGSCodeObj.playSound("UIMenuOK");
			for(_loc1_ in this.List_mc.entryList)
			{
				if(_loc1_ > 0 && this.List_mc.entryList[_loc1_].value != undefined)
				{
					_loc2_ = this.initialValues[_loc1_ - 1] - this.List_mc.entryList[_loc1_].value;
					this.ModListEntryValue(_loc1_,_loc2_,_loc1_ == 1);
				}
			}
			this.List_mc.InvalidateData();
			this.UpdateCounterAndButtons();
		}
		
		public function CancelReset() : *
		{
			this.BGSCodeObj.playSound("UIMenuCancel");
		}
		
		public function IncrementPoints() : *
		{
			if(this.List_mc.selectedClipIndex > 0)
			{
				this.ModSelectedValue(1);
			}
		}
		
		public function DecrementPoints() : *
		{
			if(this.List_mc.selectedClipIndex > 0)
			{
				this.ModSelectedValue(-1);
			}
		}
		
		function __setProp_List_mc_MenuObj_List_mc_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.listEntryClass = "SPECIAL_ListEntry";
			this.List_mc.numListItems = 8;
			this.List_mc.restoreListIndex = false;
			this.List_mc.textOption = "None";
			this.List_mc.verticalSpacing = 0;
			try
			{
				this.List_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
