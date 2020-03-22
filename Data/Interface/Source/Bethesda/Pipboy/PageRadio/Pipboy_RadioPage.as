package
{
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.BGSExternalInterface;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Pipboy_RadioPage extends PipboyPage
	{
		 
		
		public var List_mc:BSScrollingList;
		
		public var RadioWave_mc:RadioWave;
		
		public var DeadWave_mc:MovieClip;
		
		protected var timer:Timer;
		
		private var RadioButton:BSButtonHintData;
		
		public function Pipboy_RadioPage()
		{
			this.RadioButton = new BSButtonHintData("","Enter","PSN_A","Xenon_A",1,this.onTuneButtonPress);
			super();
			this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
			this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onRadioItemPress);
			this.timer = new Timer(41);
			this.timer.addEventListener(TimerEvent.TIMER,this.AnimateWave);
			this.timer.start();
			this.__setProp_List_mc_Scene1_List_0();
		}
		
		override protected function PopulateButtonHintData() : *
		{
			if(!CompanionAppMode.isOn)
			{
				_buttonHintDataV.push(this.RadioButton);
			}
			this.RadioButton.ButtonVisible = false;
		}
		
		override protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.Radio;
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			super.onPipboyChangeEvent(param1);
			this.List_mc.entryList = param1.DataObj.RadioList;
			this.List_mc.entryList.sortOn(["enabled","text"],[Array.DESCENDING | Array.NUMERIC,Array.CASEINSENSITIVE]);
			this.List_mc.InvalidateData();
			stage.focus = this.List_mc;
			if(this.List_mc.selectedIndex == -1)
			{
				this.List_mc.selectedClipIndex = 0;
			}
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			this.updateRadioFrequency();
			this.SetButtons();
		}
		
		override protected function onReadOnlyChanged(param1:Boolean) : void
		{
			super.onReadOnlyChanged(param1);
			SetScrollingListReadOnly(this.List_mc,param1);
		}
		
		override public function onRemovedFromStage() : void
		{
			super.onRemovedFromStage();
			this.timer.stop();
			this.timer.removeEventListener(TimerEvent.TIMER,this.AnimateWave);
			this.timer = null;
		}
		
		private function onTuneButtonPress() : *
		{
			this.onRadioItemPress(null);
		}
		
		private function onRadioItemPress(param1:Event) : *
		{
			BGSExternalInterface.call(this.codeObj,"ToggleRadioStationActiveStatus",this.List_mc.selectedEntry.frequency);
			SetIsDirty();
		}
		
		override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(param1 == "Activate" && !param2)
			{
				this.onRadioItemPress(null);
			}
			return _loc3_;
		}
		
		private function onListSelectionChange() : *
		{
			if(this.List_mc.selectedEntry != null)
			{
				this.DeadWave_mc.visible = false;
				this.RadioWave_mc.visible = true;
				this.RadioWave_mc.InitWave();
			}
			else
			{
				this.DeadWave_mc.visible = true;
				this.RadioWave_mc.visible = false;
			}
			SetIsDirty();
		}
		
		private function updateRadioFrequency() : void
		{
			if(this.List_mc.selectedEntry != null)
			{
				this.RadioWave_mc.freq = !!this.List_mc.selectedEntry.active?int(GlobalFunc.Lerp(5,10,70,110,this.List_mc.selectedEntry.frequency,true)):int(RadioWave.NO_AMP);
				this.RadioWave_mc.InitWave();
			}
		}
		
		private function SetButtons() : *
		{
			if(this.List_mc.selectedEntry != null)
			{
				this.RadioButton.ButtonVisible = true;
				this.RadioButton.ButtonText = !!this.List_mc.selectedEntry.active?"$RadioOff":"$TuneToStation";
			}
			else
			{
				this.RadioButton.ButtonVisible = false;
			}
		}
		
		private function AnimateWave(param1:TimerEvent) : *
		{
			this.RadioWave_mc.Animate();
		}
		
		function __setProp_List_mc_Scene1_List_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.listEntryClass = "RadioListEntry";
			this.List_mc.numListItems = 10;
			this.List_mc.restoreListIndex = false;
			this.List_mc.textOption = "Shrink To Fit";
			this.List_mc.verticalSpacing = 1.4;
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
