package
{
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.QuantityMenu;
	import Shared.GlobalFunc;
	import Shared.PlatformChangeEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public dynamic class BarterMenu extends ContainerMenu
	{
		
		private static const CapsTransferBackgroundLeftX = 566;
		
		private static const CapsTransferBackgroundRightX = 572;
		 
		
		public var bIsValidTrade:Boolean;
		
		private var CanInvest:Boolean;
		
		public var CapsTransferInfo_mc:MovieClip;
		
		protected var TransferCapsIconInitialX:uint;
		
		protected var TransferCapsTextInitialX:uint;
		
		private var AcceptTradeButton:BSButtonHintData;
		
		private var ResetTradeButton:BSButtonHintData;
		
		private var InvestButton:BSButtonHintData;
		
		public function BarterMenu()
		{
			this.AcceptTradeButton = new BSButtonHintData("$ACCEPT","R","PSN_X","Xenon_X",1,this.onAcceptTrade);
			this.ResetTradeButton = new BSButtonHintData("$RESET","T","PSN_Y","Xenon_Y",1,this.onResetTrade);
			this.InvestButton = new BSButtonHintData("$INVEST","Q","PSN_R1","Xenon_R1",1,this.onInvest);
			super();
			PlayerInventory_mc.PlayerList_mc.filterer = new BarterListFilterer();
			ContainerList_mc.filterer = new BarterListFilterer();
			this.bIsValidTrade = false;
			this.TransferCapsIconInitialX = this.CapsTransferInfo_mc.TransferCapsIcon_mc.x;
			this.TransferCapsTextInitialX = this.CapsTransferInfo_mc.TransferCaps_tf.x;
			this.__setProp_ContainerList_mc_MenuObj_ContainerList_0();
		}
		
		override protected function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(SwitchToPlayerButton);
			_loc1_.push(SwitchToContainerButton);
			_loc1_.push(AcceptButton);
			_loc1_.push(this.AcceptTradeButton);
			_loc1_.push(this.ResetTradeButton);
			_loc1_.push(SortButton);
			_loc1_.push(ExitButton);
			_loc1_.push(QuantityAcceptButton);
			_loc1_.push(QuantityCancelButton);
			_loc1_.push(InspectButton);
			_loc1_.push(this.InvestButton);
			this.InvestButton.ButtonEnabled = false;
			ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		public function get isValidTrade() : Boolean
		{
			return this.bIsValidTrade;
		}
		
		public function set canInvest(param1:Boolean) : *
		{
			this.InvestButton.ButtonEnabled = this.CanInvest = param1;
		}
		
		public function get canInvest() : Boolean
		{
			return this.InvestButton.ButtonEnabled;
		}
		
		override protected function get AcceptButtonText() : String
		{
			var _loc1_:* = stage.focus == ContainerList_mc;
			return !!_loc1_?"$BUY":"$SELL";
		}
		
		override protected function UpdateButtonHints() : void
		{
			var _loc3_:ItemList = null;
			var _loc4_:* = undefined;
			var _loc1_:* = stage.focus == QuantityMenu_mc;
			var _loc2_:Boolean = _loc1_ || MessageBoxIsActive;
			SwitchToPlayerButton.ButtonVisible = uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && !_loc2_;
			SwitchToContainerButton.ButtonVisible = uiPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && !_loc2_;
			SwitchToPlayerButton.ButtonEnabled = stage.focus == ContainerList_mc && PlayerInventory_mc.PlayerList_mc.itemsShown;
			SwitchToContainerButton.ButtonEnabled = stage.focus == PlayerInventory_mc.PlayerList_mc && ContainerList_mc.itemsShown;
			QuantityAcceptButton.ButtonVisible = _loc1_;
			QuantityCancelButton.ButtonVisible = _loc1_;
			AcceptButton.ButtonVisible = !_loc2_;
			this.AcceptTradeButton.ButtonVisible = !_loc2_;
			this.ResetTradeButton.ButtonVisible = !_loc2_;
			ExitButton.ButtonVisible = !_loc2_;
			InspectButton.ButtonVisible = !_loc2_;
			SortButton.ButtonVisible = !_loc2_;
			this.InvestButton.ButtonVisible = !_loc2_;
			if(!_loc2_)
			{
				_loc3_ = stage.focus as ItemList;
				_loc4_ = !_loc3_ || _loc3_.entryList.length == 0;
				AcceptButton.ButtonText = this.AcceptButtonText;
				AcceptButton.ButtonDisabled = _loc4_;
				this.AcceptTradeButton.ButtonDisabled = !this.isValidTrade;
				this.ResetTradeButton.ButtonDisabled = !this.isValidTrade;
				InspectButton.ButtonDisabled = _loc4_;
			}
			this.InvestButton.ButtonDisabled = !this.CanInvest || !this.AcceptTradeButton.ButtonDisabled;
		}
		
		private function onItemPress(param1:Event) : *
		{
			var _loc4_:* = undefined;
			var _loc2_:* = (param1.target as ItemList).selectedEntry;
			var _loc3_:int = _loc2_.count;
			if(_loc2_.barterCount != undefined)
			{
				_loc3_ = _loc3_ - _loc2_.barterCount;
			}
			if(_loc3_ > 0)
			{
				if(_loc3_ <= QuantityMenu.INV_MAX_NUM_BEFORE_QUANTITY_MENU)
				{
					BGSCodeObj.transferItem((param1.target as ItemList).selectedIndex,1,param1.target == ContainerList_mc);
				}
				else
				{
					_loc4_ = BGSCodeObj.getItemValue((param1.target as ItemList).selectedIndex,param1.target == ContainerList_mc);
					OpenQuantityMenu(_loc3_,_loc4_);
				}
				this.UpdateButtonHints();
			}
		}
		
		public function onAcceptTrade() : void
		{
			this.BGSCodeObj.sendXButton();
		}
		
		public function onResetTrade() : void
		{
			this.BGSCodeObj.sendYButton();
		}
		
		public function onInvest() : void
		{
			BGSCodeObj.confirmInvest();
		}
		
		public function UpdateTransferCaps(param1:int, param2:uint, param3:uint, param4:Boolean) : *
		{
			var _loc8_:Number = NaN;
			var _loc9_:Number = NaN;
			this.bIsValidTrade = false;
			var _loc5_:int = Math.abs(param1);
			var _loc6_:Number = this.CapsTransferInfo_mc.CapsArrowRight_mc.BottomBracket_mc.width;
			var _loc7_:* = 16;
			this.CapsTransferInfo_mc.TransferCaps_tf.visible = this.CapsTransferInfo_mc.TransferCapsIcon_mc.visible = this.CapsTransferInfo_mc.TotalCost_tf.visible = this.CapsTransferInfo_mc.Background_mc.visible = param4;
			if(param4)
			{
				if(param1 >= 0)
				{
					if(param2 < _loc5_)
					{
						this.CapsTransferInfo_mc.TotalCost_tf.alpha = this.CapsTransferInfo_mc.TransferCaps_tf.alpha = this.CapsTransferInfo_mc.TransferCapsIcon_mc.alpha = this.CapsTransferInfo_mc.CapsArrowRight_mc.alpha = GlobalFunc.PIPBOY_GREY_OUT_ALPHA;
					}
					else
					{
						this.bIsValidTrade = true;
						this.CapsTransferInfo_mc.TotalCost_tf.alpha = this.CapsTransferInfo_mc.TransferCaps_tf.alpha = this.CapsTransferInfo_mc.TransferCapsIcon_mc.alpha = this.CapsTransferInfo_mc.CapsArrowRight_mc.alpha = 1;
					}
					this.CapsTransferInfo_mc.CapsArrowLeft_mc.visible = false;
					this.CapsTransferInfo_mc.CapsArrowRight_mc.visible = true;
					this.CapsTransferInfo_mc.CapsArrowRight_mc.TopBracketLeft_mc.width = (_loc6_ - this.CapsTransferInfo_mc.TotalCost_tf.textWidth / this.CapsTransferInfo_mc.CapsArrowRight_mc.scaleX) / 2;
					this.CapsTransferInfo_mc.CapsArrowRight_mc.TopBracketRight_mc.width = this.CapsTransferInfo_mc.CapsArrowRight_mc.TopBracketLeft_mc.width - _loc7_;
					this.CapsTransferInfo_mc.CapsArrowRight_mc.TopBracketRight_mc.x = this.CapsTransferInfo_mc.CapsArrowRight_mc.DirectionalArrow_mc.x - this.CapsTransferInfo_mc.CapsArrowRight_mc.TopBracketRight_mc.width;
					this.CapsTransferInfo_mc.Background_mc.x = CapsTransferBackgroundRightX - this.CapsTransferInfo_mc.x;
				}
				else
				{
					if(param3 < _loc5_)
					{
						this.CapsTransferInfo_mc.TotalCost_tf.alpha = this.CapsTransferInfo_mc.TransferCaps_tf.alpha = this.CapsTransferInfo_mc.TransferCapsIcon_mc.alpha = this.CapsTransferInfo_mc.CapsArrowLeft_mc.alpha = GlobalFunc.PIPBOY_GREY_OUT_ALPHA;
					}
					else
					{
						this.CapsTransferInfo_mc.TotalCost_tf.alpha = this.CapsTransferInfo_mc.TransferCaps_tf.alpha = this.CapsTransferInfo_mc.TransferCapsIcon_mc.alpha = this.CapsTransferInfo_mc.CapsArrowLeft_mc.alpha = 1;
					}
					this.bIsValidTrade = true;
					this.CapsTransferInfo_mc.CapsArrowLeft_mc.visible = true;
					this.CapsTransferInfo_mc.CapsArrowRight_mc.visible = false;
					this.CapsTransferInfo_mc.CapsArrowLeft_mc.TopBracketRight_mc.width = (_loc6_ - this.CapsTransferInfo_mc.TotalCost_tf.textWidth / this.CapsTransferInfo_mc.CapsArrowLeft_mc.scaleX) / 2;
					this.CapsTransferInfo_mc.CapsArrowLeft_mc.TopBracketLeft_mc.width = this.CapsTransferInfo_mc.CapsArrowLeft_mc.TopBracketRight_mc.width;
					this.CapsTransferInfo_mc.CapsArrowLeft_mc.TopBracketRight_mc.x = this.CapsTransferInfo_mc.CapsArrowLeft_mc.DirectionalArrow_mc.x - this.CapsTransferInfo_mc.CapsArrowLeft_mc.TopBracketRight_mc.width;
					this.CapsTransferInfo_mc.Background_mc.x = CapsTransferBackgroundLeftX - this.CapsTransferInfo_mc.x;
				}
				_loc8_ = this.CapsTransferInfo_mc.TransferCaps_tf.x - this.CapsTransferInfo_mc.TransferCapsIcon_mc.x;
				GlobalFunc.SetText(this.CapsTransferInfo_mc.TransferCaps_tf,_loc5_.toString(),false);
				_loc8_ = this.CapsTransferInfo_mc.TransferCaps_tf.x - this.CapsTransferInfo_mc.TransferCapsIcon_mc.x;
				_loc9_ = _loc8_ + this.CapsTransferInfo_mc.TransferCaps_tf.textWidth;
				this.CapsTransferInfo_mc.TransferCapsIcon_mc.x = (1280 - _loc9_) / 2 - this.CapsTransferInfo_mc.x;
				this.CapsTransferInfo_mc.TransferCaps_tf.x = this.CapsTransferInfo_mc.TransferCapsIcon_mc.x + _loc8_;
				_loc8_ = this.CapsTransferInfo_mc.TransferCaps_tf.x - this.CapsTransferInfo_mc.TransferCapsIcon_mc.x;
			}
			else
			{
				this.CapsTransferInfo_mc.CapsArrowLeft_mc.visible = this.CapsTransferInfo_mc.CapsArrowRight_mc.visible = false;
			}
			this.UpdateButtonHints();
		}
		
		public function UpdateListEntry(param1:Boolean, param2:Object) : *
		{
			if(param1)
			{
				PlayerInventory_mc.PlayerList_mc.UpdateEntry(param2);
			}
			else
			{
				ContainerList_mc.UpdateEntry(param2);
			}
			this.UpdateButtonHints();
		}
		
		public function RemoveListEntry(param1:Boolean, param2:Object) : *
		{
			var _loc3_:* = undefined;
			var _loc4_:* = undefined;
			if(param1)
			{
				_loc3_ = playerListArray;
			}
			else
			{
				_loc3_ = containerListArray;
			}
			for(_loc4_ in _loc3_)
			{
				if(_loc3_[_loc4_] == param2)
				{
					_loc3_.splice(_loc4_,1);
					break;
				}
			}
			if(param1)
			{
				PlayerInventory_mc.PlayerList_mc.InvalidateData();
			}
			else
			{
				ContainerList_mc.InvalidateData();
			}
			this.UpdateButtonHints();
		}
		
		public function GetItemObject(param1:Boolean, param2:uint, param3:uint) : Object
		{
			var _loc4_:* = undefined;
			var _loc5_:* = undefined;
			var _loc6_:* = undefined;
			var _loc8_:* = undefined;
			var _loc7_:* = null;
			if(param1)
			{
				_loc4_ = playerListArray;
			}
			else
			{
				_loc4_ = containerListArray;
			}
			for(_loc5_ in _loc4_)
			{
				if(_loc4_[_loc5_].handle == param2 && _loc4_[_loc5_].stackArray != undefined)
				{
					_loc8_ = 0;
					while(_loc8_ < _loc4_[_loc5_].stackArray.length)
					{
						if(_loc4_[_loc5_].stackArray[_loc8_] == param3)
						{
							_loc7_ = _loc4_[_loc5_];
							break;
						}
						_loc8_++;
					}
				}
				if(_loc7_ != null)
				{
					break;
				}
			}
			return _loc7_;
		}
		
		function __setProp_ContainerList_mc_MenuObj_ContainerList_0() : *
		{
			try
			{
				ContainerList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			ContainerList_mc.listEntryClass = "ContainerListEntry";
			ContainerList_mc.numListItems = 9;
			ContainerList_mc.restoreListIndex = true;
			ContainerList_mc.textOption = "Shrink To Fit";
			ContainerList_mc.verticalSpacing = -3;
			try
			{
				ContainerList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
