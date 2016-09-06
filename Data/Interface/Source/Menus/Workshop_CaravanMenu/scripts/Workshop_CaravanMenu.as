package
{
	import Shared.IMenu;
	import flash.text.TextField;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.BSButtonHintBar;
	import flash.display.MovieClip;
	import Shared.AS3.BSButtonHintData;
	import Shared.GlobalFunc;
	import flash.events.Event;
	import scaleform.gfx.TextFieldEx;
	
	public class Workshop_CaravanMenu extends IMenu
	{
		 
		
		public var BGSCodeObj:Object;
		
		private var strConfirmMessage:String;
		
		public var Header_tf:TextField;
		
		public var CaravanList_mc:BSScrollingList;
		
		public var ConfirmMessage_tf:TextField;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var BracketContainer_mc:MovieClip;
		
		private var ConfirmButton:BSButtonHintData;
		
		private var CancelButton:BSButtonHintData;
		
		public function Workshop_CaravanMenu()
		{
			this.ConfirmButton = new BSButtonHintData("$CONFIRM","Enter","PSN_A","Xenon_A",1,this.OnConfirmPress);
			this.CancelButton = new BSButtonHintData("$CANCEL","Tab","PSN_B","Xenon_B",1,this.OnCancelPress);
			super();
			this.BGSCodeObj = new Object();
			this.PopulateButtonBar();
			this.CaravanList_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onCaravanListItemPress);
			this.ConfirmMessage_tf.visible = false;
			TextFieldEx.setTextAutoSize(this.Header_tf,"shrink");
			this.__setProp_CaravanList_mc_Scene1_CaravanList_0();
		}
		
		public function set headerText(param1:String) : *
		{
			GlobalFunc.SetText(this.Header_tf,param1,false,true);
		}
		
		private function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.ConfirmButton);
			_loc1_.push(this.CancelButton);
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		override protected function onStageInit(param1:Event) : *
		{
			super.onStageInit(param1);
			this.SetListFocus(true);
		}
		
		public function onShowMenu() : *
		{
			var _loc1_:int = this.BGSCodeObj.populateCaravanList(this.CaravanList_mc.entryList);
			this.CaravanList_mc.InvalidateData();
			this.CaravanList_mc.selectedIndex = _loc1_;
		}
		
		public function set confirmMessage(param1:String) : *
		{
			this.strConfirmMessage = param1;
		}
		
		private function onCaravanListItemPress(param1:Event) : *
		{
			if(this.CaravanList_mc.selectedEntry.disabled != true)
			{
				this.SetListFocus(false);
			}
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!param2)
			{
				if(param1 == "Accept" || param1 == "Activate")
				{
					this.OnConfirmPress();
					_loc3_ = true;
				}
				else if(param1 == "Cancel")
				{
					this.OnCancelPress();
					_loc3_ = true;
				}
			}
			return _loc3_;
		}
		
		public function OnConfirmPress() : *
		{
			if(this.CaravanList_mc.selectedEntry.disabled != true)
			{
				if(this.CaravanList_mc.disableInput)
				{
					this.BGSCodeObj.onLocationConfirm(this.CaravanList_mc.selectedEntry.formID);
				}
				else
				{
					this.SetListFocus(false);
				}
			}
		}
		
		public function OnCancelPress() : *
		{
			if(this.CaravanList_mc.disableInput)
			{
				this.SetListFocus(true);
			}
			else
			{
				this.BGSCodeObj.closeMenu();
			}
		}
		
		private function SetListFocus(param1:Boolean) : *
		{
			var _loc2_:Array = null;
			if(param1)
			{
				this.ConfirmMessage_tf.visible = false;
				this.CaravanList_mc.disableInput = false;
				stage.focus = this.CaravanList_mc;
			}
			else
			{
				_loc2_ = this.strConfirmMessage.split("%");
				if(_loc2_.length > 1)
				{
					GlobalFunc.SetText(this.ConfirmMessage_tf,_loc2_[0] + this.CaravanList_mc.selectedEntry.text + _loc2_[1].substr(1),false);
				}
				else
				{
					GlobalFunc.SetText(this.ConfirmMessage_tf,this.strConfirmMessage,false);
				}
				this.ConfirmMessage_tf.visible = true;
				this.CaravanList_mc.disableInput = true;
				stage.focus = null;
			}
		}
		
		function __setProp_CaravanList_mc_Scene1_CaravanList_0() : *
		{
			try
			{
				this.CaravanList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.CaravanList_mc.disableSelection = false;
			this.CaravanList_mc.listEntryClass = "CaravanListEntry";
			this.CaravanList_mc.numListItems = 8;
			this.CaravanList_mc.restoreListIndex = true;
			this.CaravanList_mc.textOption = "Shrink To Fit";
			this.CaravanList_mc.verticalSpacing = 0;
			try
			{
				this.CaravanList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
