package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import Shared.PlatformChangeEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class LevelUpMenu extends IMenu
	{
		 
		
		public var GridView_mc:PerkGrid;
		
		public var PerkInfo_mc:MovieClip;
		
		public var XPMeterHolder_mc:MovieClip;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		private var uiPerkCount:uint;
		
		private var errorDisapearTimer:Timer;
		
		private var bConfirming:Boolean;
		
		private var _WasCancelPressRegistered:Boolean;
		
		private var AcceptButton:BSButtonHintData;
		
		private var CancelButton:BSButtonHintData;
		
		private var PrevPerkButton:BSButtonHintData;
		
		private var NextPerkButton:BSButtonHintData;
		
		private const INFO_Y_BOUND:Number = 460;
		
		private const INFO_UPPER_Y:Number = 35;
		
		private const INFO_LOWER_Y:Number = 617.75;
		
		private var _SelectionDesc:String;
		
		private var _ViewingRankOffset:int;
		
		private var _ViewingRanks:Boolean;
		
		public var BGSCodeObj:Object;
		
		public function LevelUpMenu()
		{
			this.AcceptButton = new BSButtonHintData("$ACCEPT","Enter","PSN_A","Xenon_A",1,this.onAcceptPressed);
			this.CancelButton = new BSButtonHintData("$CLOSE","Tab","PSN_B","Xenon_B",1,this.onCancelPressed);
			this.PrevPerkButton = new BSButtonHintData("$PREV PERK","Ctrl","PSN_L1","Xenon_L1",1,this.onPrevPerk);
			this.NextPerkButton = new BSButtonHintData("$NEXT PERK","Alt","PSN_R1","Xenon_R1",1,this.onNextPerk);
			super();
			this.BGSCodeObj = new Object();
			this.PopulateButtonBar();
			this.GridView_mc.visible = false;
			this.SetButtons();
			this.PerkInfo_mc.visible = false;
			this.PerkInfo_mc.Confirm_tf.visible = false;
			this.bConfirming = false;
			this._WasCancelPressRegistered = false;
			this._ViewingRankOffset = 0;
			this._ViewingRanks = false;
			this.GridView_mc.addEventListener(PerkGrid.SELECTION_CHANGE,this.onGridSelectionChange);
			this.GridView_mc.addEventListener(PerkGrid.ZOOMING,this.onGridZoom);
			this.GridView_mc.addEventListener(PerkAnimHolder.CLICK,this.onGridItemPress);
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.XPMeterHolder_mc.textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
			this.__setProp_XPMeterHolder_mc_MenuObj_XPMeter_0();
			this.__setProp_ButtonHintBar_mc_MenuObj_ButtonHintBar_mc_0();
		}
		
		private function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.AcceptButton);
			_loc1_.push(this.CancelButton);
			_loc1_.push(this.PrevPerkButton);
			_loc1_.push(this.NextPerkButton);
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		public function onCodeObjCreate() : *
		{
			this.GridView_mc.codeObj = this.BGSCodeObj;
			this.BGSCodeObj.RegisterPerkGridComponents(this.GridView_mc);
			var _loc1_:Object = new Object();
			this.BGSCodeObj.GetXPInfo(_loc1_);
			GlobalFunc.SetText(this.XPMeterHolder_mc.textField,"$$LEVEL " + _loc1_.level,false);
			this.XPMeterHolder_mc.Meter_mc.SetMeter(_loc1_.currXP,0,_loc1_.maxXP);
			this.GridView_mc.InvalidateGrid();
			this.GridView_mc.addEventListener(PerkGrid.TEXTURES_LOADED,this.onGridTexturesLoaded);
		}
		
		public function onCodeObjDestruction() : *
		{
			this.GridView_mc.codeObj = null;
			this.BGSCodeObj = null;
		}
		
		private function onGridTexturesLoaded() : *
		{
			this.GridView_mc.removeEventListener(PerkGrid.TEXTURES_LOADED,this.onGridTexturesLoaded);
			this.GridView_mc.platform = uiPlatform;
			this.GridView_mc.visible = true;
			stage.focus = this.GridView_mc;
			this.BGSCodeObj.onGridAddedToStage();
			this.SetButtons();
		}
		
		public function get perkCount() : uint
		{
			return this.uiPerkCount;
		}
		
		public function set perkCount(param1:uint) : *
		{
			this.uiPerkCount = param1;
			this.GridView_mc.perkCount = param1;
		}
		
		public function set ratio16x10(param1:Boolean) : *
		{
			this.GridView_mc.ratio16x10 = param1;
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc4_:Object = null;
			var _loc3_:Boolean = this.GridView_mc.ProcessUserEvent(param1,param2);
			if(!_loc3_)
			{
				if(!param2)
				{
					if(param1 == "Cancel")
					{
						if(this._WasCancelPressRegistered)
						{
							_loc3_ = this.onCancelPressed();
						}
						this._WasCancelPressRegistered = false;
					}
					else if(param1 == "Accept" || param1 == "Activate")
					{
						_loc4_ = this.GridView_mc.selectedPerkEntry;
						if(_loc4_ != null)
						{
							if(!this.bConfirming)
							{
								this.TryToAcquirePerk(_loc4_);
								_loc3_ = this.bConfirming;
							}
							else
							{
								_loc3_ = this.onAcceptPressed();
							}
						}
					}
					else if(param1 == "PrevPerk" && this.PrevPerkButton.ButtonVisible && !this.PrevPerkButton.ButtonDisabled)
					{
						this.onPrevPerk();
					}
					else if(param1 == "NextPerk" && this.NextPerkButton.ButtonVisible && !this.NextPerkButton.ButtonDisabled)
					{
						this.onNextPerk();
					}
				}
				else if(param1 == "Cancel")
				{
					this._WasCancelPressRegistered = true;
				}
			}
			return _loc3_;
		}
		
		protected function onGridItemPress(param1:Event) : *
		{
			var _loc2_:Object = this.GridView_mc.selectedPerkEntry;
			if(_loc2_ != null && param1.target == this.GridView_mc.selectedPerkClip && !this.GridView_mc.isDragging)
			{
				this.TryToAcquirePerk(_loc2_);
			}
		}
		
		private function TryToAcquirePerk(param1:Object) : *
		{
			if(param1 != null)
			{
				if(!param1.available && this.uiPerkCount > 0)
				{
					if(param1.displayRank != param1.displayMaxRank)
					{
						this.ShowErrorText("$PerksLowReqs");
					}
					this.BGSCodeObj.PlaySound("UIMenuCancel");
				}
				else if(!this.bConfirming)
				{
					if(this.uiPerkCount > 0)
					{
						this.StartConfirmation();
						this.BGSCodeObj.PlaySound("UIMenuOK");
					}
				}
				else if(uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
				{
					this.OnSelectPerk();
				}
			}
		}
		
		private function onAcceptPressed() : Boolean
		{
			if(this.bConfirming)
			{
				this.OnSelectPerk();
			}
			return this.bConfirming;
		}
		
		private function onCancelPressed() : Boolean
		{
			if(this.bConfirming)
			{
				this.EndConfirmation();
				this.BGSCodeObj.PlaySound("UIMenuCancel");
			}
			else
			{
				this.BGSCodeObj.CloseMenu();
			}
			return true;
		}
		
		protected function OnSelectPerk() : *
		{
			var _loc1_:Object = this.GridView_mc.selectedPerkEntry;
			if(_loc1_.available && this.uiPerkCount > 0)
			{
				this.BGSCodeObj.SelectPerk(_loc1_.clipName,_loc1_.rank);
				this.BGSCodeObj.PlaySound("UIMenuOK");
				this.EndConfirmation();
			}
		}
		
		public function InvalidateGrid() : *
		{
			this.BGSCodeObj.RegisterPerkGridComponents(this.GridView_mc);
			this.GridView_mc.InvalidateGrid();
		}
		
		private function onGridSelectionChange() : *
		{
			if(this.GridView_mc.visible)
			{
				if(this.GridView_mc.selectedPerkEntry != null)
				{
					if(this.GridView_mc.selectedPerkEntry.owned == true)
					{
						this.BGSCodeObj.PlayPerkSound(this.GridView_mc.selectedPerkEntry.clipName);
					}
					else
					{
						this.BGSCodeObj.StopPerkSound();
					}
					this.BGSCodeObj.PlaySound("UIMenuFocus");
					this._SelectionDesc = this.GridView_mc.selectedPerkEntry.description;
					if(this.GridView_mc.selectedPerkEntry.rank == this.GridView_mc.selectedPerkEntry.maxRank)
					{
						this._ViewingRankOffset = 0;
					}
					else if(this.GridView_mc.selectedPerkEntry.rank == 0 || this.uiPerkCount != 0)
					{
						this._ViewingRankOffset = 1;
					}
					else
					{
						this._ViewingRankOffset = 0;
					}
					this._ViewingRanks = false;
				}
				else
				{
					this._SelectionDesc = "";
					this._ViewingRankOffset = 0;
					this._ViewingRanks = false;
					this.BGSCodeObj.StopPerkSound();
				}
			}
			this.UpdateSelectionText();
			this.SetButtons();
		}
		
		private function UpdateSelectionText() : *
		{
			var _loc2_:Array = null;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:TextLineMetrics = null;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			var _loc9_:uint = 0;
			var _loc10_:MovieClip = null;
			var _loc1_:Object = this.GridView_mc.selectedPerkEntry;
			if(_loc1_ != null)
			{
				GlobalFunc.SetText(this.PerkInfo_mc.PerkName_tf,this.GridView_mc.selectedPerkEntry.text.toUpperCase(),false);
				_loc2_ = this._SelectionDesc.split("\n");
				if(_loc2_.length >= 2)
				{
					if(this.GridView_mc.selectedPerkEntry.displayRank != this.GridView_mc.selectedPerkEntry.displayMaxRank || this._ViewingRanks)
					{
						GlobalFunc.SetText(this.PerkInfo_mc.Reqs_tf,_loc2_[0],true);
					}
					else
					{
						GlobalFunc.SetText(this.PerkInfo_mc.Reqs_tf," ",true);
					}
					GlobalFunc.SetText(this.PerkInfo_mc.DescriptionText_tf,_loc2_[1],true);
				}
				else if(_loc2_.length == 1)
				{
					GlobalFunc.SetText(this.PerkInfo_mc.DescriptionText_tf,_loc2_[0],true);
					GlobalFunc.SetText(this.PerkInfo_mc.Reqs_tf," ",true);
				}
				while(this.PerkInfo_mc.StarHolder_mc.numChildren > 0)
				{
					this.PerkInfo_mc.StarHolder_mc.removeChildAt(0);
				}
				if(_loc1_.displayMaxRank != null && _loc1_.displayMaxRank > 1)
				{
					_loc9_ = 0;
					while(_loc9_ < _loc1_.displayMaxRank)
					{
						_loc10_ = new PerkRankStar();
						this.PerkInfo_mc.StarHolder_mc.addChild(_loc10_);
						_loc10_.x = 22.5 * _loc9_;
						_loc10_.scaleX = 0.5;
						_loc10_.scaleY = _loc10_.scaleX;
						_loc9_++;
					}
					this.PerkInfo_mc.StarHolder_mc.x = this.PerkInfo_mc.Background_mc.x + (this.PerkInfo_mc.Background_mc.width - this.PerkInfo_mc.StarHolder_mc.width) / 2;
					this.RefreshStarStates(_loc1_.displayRank,_loc1_.displayMaxRank,_loc1_.available == true);
				}
				_loc3_ = 4;
				_loc4_ = 43;
				_loc5_ = 35;
				this.PerkInfo_mc.StarHolder_mc.y = this.PerkInfo_mc.DescriptionText_tf.y + this.PerkInfo_mc.DescriptionText_tf.textHeight + _loc3_;
				this.PerkInfo_mc.Reqs_tf.y = this.PerkInfo_mc.StarHolder_mc.y + _loc4_;
				this.PerkInfo_mc.Confirm_tf.y = this.PerkInfo_mc.StarHolder_mc.y + _loc5_;
				_loc6_ = this.PerkInfo_mc.DescriptionText_tf.getLineMetrics(0);
				_loc7_ = 100;
				_loc8_ = 30;
				this.PerkInfo_mc.Background_mc.x = this.PerkInfo_mc.DescriptionText_tf.x + _loc6_.x - _loc7_ / 2;
				this.PerkInfo_mc.Background_mc.width = _loc6_.width + _loc7_;
				this.PerkInfo_mc.Background_mc.height = this.PerkInfo_mc.Reqs_tf.y - this.PerkInfo_mc.PerkName_tf.y + _loc8_;
				this.SetInfoClipLocation();
				this.PerkInfo_mc.visible = true;
			}
			else
			{
				this.PerkInfo_mc.visible = false;
				this.ClearErrorText();
			}
		}
		
		private function RefreshStarStates(param1:uint, param2:uint, param3:Boolean) : *
		{
			var _loc5_:MovieClip = null;
			var _loc6_:Boolean = false;
			var _loc7_:* = false;
			var _loc4_:uint = 0;
			while(_loc4_ < param2)
			{
				_loc5_ = this.PerkInfo_mc.StarHolder_mc.getChildAt(_loc4_) as MovieClip;
				_loc6_ = param3 && param1 == _loc4_ && this.uiPerkCount > 0;
				_loc7_ = _loc4_ < param1;
				if(_loc6_)
				{
					_loc5_.gotoAndStop("Available");
				}
				else if(_loc7_)
				{
					_loc5_.gotoAndStop("Full");
				}
				else
				{
					_loc5_.gotoAndStop("Empty");
				}
				_loc4_++;
			}
		}
		
		private function onGridZoom() : *
		{
			this.SetInfoClipLocation();
		}
		
		private function SetInfoClipLocation() : *
		{
			if(uiPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.GridView_mc.selectedPerkEntry != null && this.GridView_mc.selectedPerkEntry.y != undefined && this.GridView_mc.y + this.GridView_mc.selectedPerkEntry.y * this.GridView_mc.gridScale > this.INFO_Y_BOUND)
			{
				this.PerkInfo_mc.y = this.INFO_UPPER_Y;
			}
			else
			{
				this.PerkInfo_mc.y = this.INFO_LOWER_Y - this.PerkInfo_mc.height;
			}
		}
		
		private function SetButtons() : *
		{
			var _loc1_:Object = this.GridView_mc.selectedPerkEntry;
			if(this.bConfirming)
			{
				this.AcceptButton.ButtonText = "$ACCEPT";
				this.AcceptButton.ButtonDisabled = false;
				this.AcceptButton.ButtonVisible = true;
			}
			else if(this.uiPerkCount > 0)
			{
				this.AcceptButton.ButtonDisabled = _loc1_ == null || _loc1_.available == false || this._ViewingRanks && this._ViewingRankOffset != 1;
				this.AcceptButton.ButtonText = "$$Choose (" + this.uiPerkCount.toString() + ")";
				this.AcceptButton.ButtonVisible = true;
			}
			else
			{
				this.AcceptButton.ButtonVisible = false;
			}
			this.PrevPerkButton.ButtonDisabled = _loc1_ == null || _loc1_.displayMaxRank <= 1 || _loc1_.rank + this._ViewingRankOffset - 1 == 0;
			this.NextPerkButton.ButtonDisabled = _loc1_ == null || _loc1_.displayMaxRank <= 1 || _loc1_.rank + this._ViewingRankOffset + 1 > _loc1_.maxRank || _loc1_.displayRank + this._ViewingRankOffset + 1 > _loc1_.displayMaxRank;
		}
		
		private function onPrevPerk() : *
		{
			this._ViewingRankOffset--;
			this._ViewingRanks = true;
			this.nextPrevPerk_Helper();
		}
		
		private function onNextPerk() : *
		{
			this._ViewingRankOffset++;
			this._ViewingRanks = true;
			this.nextPrevPerk_Helper();
		}
		
		private function nextPrevPerk_Helper() : *
		{
			this._SelectionDesc = this.BGSCodeObj.GetPerkInfoByRank(this.GridView_mc.selectedPerkEntry.clipName,this.GridView_mc.selectedPerkEntry.rank + this._ViewingRankOffset - 1);
			this.UpdateSelectionText();
			this.RefreshStarStates(this.GridView_mc.selectedPerkEntry.displayRank + this._ViewingRankOffset,this.GridView_mc.selectedPerkEntry.displayMaxRank,false);
			this.SetButtons();
			this.BGSCodeObj.PlaySound("UIMenuPrevNext");
		}
		
		protected function StartConfirmation() : *
		{
			this.GridView_mc.disableInput = true;
			GlobalFunc.SetText(this.PerkInfo_mc.Confirm_tf,"$ConfirmPerkSelect",false);
			this.PerkInfo_mc.Confirm_tf.visible = true;
			this.PerkInfo_mc.Reqs_tf.visible = false;
			this.bConfirming = true;
			this.SetButtons();
		}
		
		protected function EndConfirmation() : *
		{
			this.GridView_mc.disableInput = false;
			this.PerkInfo_mc.Confirm_tf.visible = false;
			this.PerkInfo_mc.Reqs_tf.visible = true;
			this.bConfirming = false;
			this.SetButtons();
		}
		
		protected function ShowErrorText(param1:String) : *
		{
			GlobalFunc.SetText(this.PerkInfo_mc.Confirm_tf,param1,false);
			this.PerkInfo_mc.Confirm_tf.visible = true;
			this.PerkInfo_mc.Reqs_tf.visible = false;
			if(this.errorDisapearTimer == null)
			{
				this.errorDisapearTimer = new Timer(2000,1);
				this.errorDisapearTimer.addEventListener(TimerEvent.TIMER,this.onTimerClearErrorText);
				this.errorDisapearTimer.start();
			}
		}
		
		protected function ClearErrorText() : *
		{
			this.PerkInfo_mc.Confirm_tf.visible = false;
			this.PerkInfo_mc.Reqs_tf.visible = true;
		}
		
		protected function onTimerClearErrorText(param1:TimerEvent) : *
		{
			if(this.PerkInfo_mc.Confirm_tf.visible && !this.PerkInfo_mc.Reqs_tf.visible)
			{
				this.ClearErrorText();
			}
			this.errorDisapearTimer.removeEventListener(TimerEvent.TIMER,this.onTimerClearErrorText);
			this.errorDisapearTimer = null;
		}
		
		function __setProp_XPMeterHolder_mc_MenuObj_XPMeter_0() : *
		{
			try
			{
				this.XPMeterHolder_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.XPMeterHolder_mc.bracketCornerLength = 6;
			this.XPMeterHolder_mc.bracketLineWidth = 1.5;
			this.XPMeterHolder_mc.bracketPaddingX = 0;
			this.XPMeterHolder_mc.bracketPaddingY = 0;
			this.XPMeterHolder_mc.BracketStyle = "horizontal";
			this.XPMeterHolder_mc.bShowBrackets = true;
			this.XPMeterHolder_mc.bUseShadedBackground = true;
			this.XPMeterHolder_mc.ShadedBackgroundMethod = "Flash";
			this.XPMeterHolder_mc.ShadedBackgroundType = "normal";
			try
			{
				this.XPMeterHolder_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_ButtonHintBar_mc_MenuObj_ButtonHintBar_mc_0() : *
		{
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ButtonHintBar_mc.BackgroundAlpha = 0.7;
			this.ButtonHintBar_mc.BackgroundColor = 3355443;
			this.ButtonHintBar_mc.bracketCornerLength = 6;
			this.ButtonHintBar_mc.bracketLineWidth = 1.5;
			this.ButtonHintBar_mc.BracketStyle = "horizontal";
			this.ButtonHintBar_mc.bRedirectToButtonBarMenu = false;
			this.ButtonHintBar_mc.bShowBrackets = true;
			this.ButtonHintBar_mc.bUseShadedBackground = true;
			this.ButtonHintBar_mc.ShadedBackgroundMethod = "Flash";
			this.ButtonHintBar_mc.ShadedBackgroundType = "normal";
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
