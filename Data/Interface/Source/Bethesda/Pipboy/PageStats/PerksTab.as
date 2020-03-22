package
{
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.AS3.COMPANIONAPP.PipboyLoader;
	import Shared.BGSExternalInterface;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class PerksTab extends PipboyTab
	{
		 
		
		public var List_mc:BSScrollingList;
		
		public var Description_tf:TextField;
		
		public var StarHolder_mc:MovieClip;
		
		public var VBHolder_mc:MovieClip;
		
		private var _VBLoader:PipboyLoader;
		
		private var _VBClipID:uint;
		
		private var _VBFileName:String;
		
		private var _DescText:String;
		
		private var _CurrSelectedRank:uint;
		
		private var _MaxSelectedRank:uint;
		
		private var ORIG_STAR_X:Number;
		
		private var _ViewingRankOffset:int;
		
		private var _ViewingRanks:Boolean;
		
		private var PrevPerkButton:BSButtonHintData;
		
		private var NextPerkButton:BSButtonHintData;
		
		public function PerksTab()
		{
			this.PrevPerkButton = new BSButtonHintData("$PREV PERK","Ctrl","PSN_L1","Xenon_L1",1,this.onPrevPerk);
			this.NextPerkButton = new BSButtonHintData("$NEXT PERK","Alt","PSN_R1","Xenon_R1",1,this.onNextPerk);
			super();
			this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.Description_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			this._VBLoader = new PipboyLoader();
			this._VBClipID = 0;
			this._VBFileName = "";
			this._DescText = "";
			this._CurrSelectedRank = 0;
			this._MaxSelectedRank = 0;
			this._ViewingRankOffset = 0;
			this._ViewingRanks = false;
			this.ORIG_STAR_X = this.StarHolder_mc.x;
			this.__setProp_List_mc_PerksTab_List_0();
		}
		
		override public function PopulateButtonHintData(param1:Vector.<BSButtonHintData>) : *
		{
			param1.push(this.PrevPerkButton);
			param1.push(this.NextPerkButton);
		}
		
		override protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.Perks;
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			var _loc2_:* = this.visible == true;
			super.onPipboyChangeEvent(param1);
			var _loc3_:* = this.visible == true;
			if(CompanionAppMode.isOn)
			{
				if(!_loc2_ && _loc3_)
				{
					this.List_mc.scrollList.needFullRefresh = true;
				}
			}
			this.List_mc.entryList = param1.DataObj.PerksList;
			this.List_mc.entryList.sortOn("text");
			this.List_mc.InvalidateData();
			if(_loc3_)
			{
				stage.focus = this.List_mc;
				if(this.List_mc.selectedIndex == -1)
				{
					this.List_mc.selectedClipIndex = 0;
				}
				else
				{
					this.onListSelectionChange();
				}
			}
			else
			{
				this.List_mc.selectedIndex = -1;
			}
			if(_loc3_ && !_loc2_)
			{
				BGSExternalInterface.call(this.codeObj,"onPerksTabOpen");
			}
			else if(_loc2_ && !_loc3_)
			{
				BGSExternalInterface.call(this.codeObj,"onPerksTabClose");
			}
			this.PrevPerkButton.ButtonVisible = this.visible;
			this.NextPerkButton.ButtonVisible = this.visible;
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:URLRequest = null;
			var _loc2_:LoaderContext = null;
			var _loc3_:uint = 0;
			var _loc4_:MovieClip = null;
			super.redrawUIComponent();
			if(!this._ViewingRanks)
			{
				if(this._VBClipID != 0)
				{
					_loc1_ = new URLRequest(this._VBFileName);
					_loc2_ = new LoaderContext(false,ApplicationDomain.currentDomain);
					this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVBLoadComplete);
					this._VBLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onVBLoadFail);
					this._VBLoader.load(_loc1_,_loc2_);
					BGSExternalInterface.call(this.codeObj,"PlayPerkSound",this._VBClipID);
				}
				else
				{
					if(this.VBHolder_mc.numChildren > 0)
					{
						this.VBHolder_mc.removeChildAt(0);
					}
					BGSExternalInterface.call(this.codeObj,"StopPerkSound");
				}
			}
			GlobalFunc.SetText(this.Description_tf,this._DescText,false);
			while(this.StarHolder_mc.numChildren > 0)
			{
				this.StarHolder_mc.removeChildAt(0);
			}
			if(this._MaxSelectedRank > 1)
			{
				_loc3_ = 0;
				while(_loc3_ < this._MaxSelectedRank)
				{
					_loc4_ = new PerkRankStar();
					this.StarHolder_mc.addChild(_loc4_);
					_loc4_.x = 37.5 * _loc3_;
					if(_loc3_ < this._CurrSelectedRank)
					{
						_loc4_.gotoAndStop("Full");
					}
					_loc3_++;
				}
				this.StarHolder_mc.x = this.ORIG_STAR_X - this.StarHolder_mc.width / 2;
			}
			this.PrevPerkButton.ButtonEnabled = this._CurrSelectedRank > 1;
			this.NextPerkButton.ButtonEnabled = this._CurrSelectedRank < this._MaxSelectedRank;
		}
		
		public function onListSelectionChange() : *
		{
			if(this.List_mc.selectedIndex != -1)
			{
				this._DescText = this.List_mc.selectedEntry.descriptions[this.List_mc.selectedEntry.rank - 1];
				this._VBClipID = this.List_mc.selectedEntry.clipName;
				if(this.List_mc.selectedEntry.SWFFile != undefined && this.List_mc.selectedEntry.SWFFile.length > 0)
				{
					this._VBFileName = this.List_mc.selectedEntry.SWFFile;
				}
				else
				{
					this._VBFileName = "Components/VaultBoys/Perks/PerkClip_" + this._VBClipID.toString(16) + ".swf";
				}
				this._CurrSelectedRank = this.List_mc.selectedEntry.rank;
				this._MaxSelectedRank = this.List_mc.selectedEntry.maxRank;
			}
			else
			{
				this._DescText = " ";
				this._VBFileName = "";
				this._VBClipID = 0;
				this._CurrSelectedRank = 0;
				this._MaxSelectedRank = 0;
			}
			this._ViewingRankOffset = 0;
			this._ViewingRanks = false;
			SetIsDirty();
		}
		
		private function onPrevPerk() : *
		{
			this._ViewingRankOffset--;
			this._ViewingRanks = true;
			this.nextPrevPerk_Helper();
			SetIsDirty();
		}
		
		private function onNextPerk() : *
		{
			this._ViewingRankOffset++;
			this._ViewingRanks = true;
			this.nextPrevPerk_Helper();
			SetIsDirty();
		}
		
		private function nextPrevPerk_Helper() : *
		{
			this._DescText = this.List_mc.selectedEntry.descriptions[this.List_mc.selectedEntry.rank + this._ViewingRankOffset - 1];
			this._CurrSelectedRank = this.List_mc.selectedEntry.rank + this._ViewingRankOffset;
			BGSExternalInterface.call(this.codeObj,"PlaySound","UIMenuPrevNext");
		}
		
		override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!param2)
			{
				if(param1 == "PrevPerk" && this.PrevPerkButton.ButtonVisible && this.PrevPerkButton.ButtonEnabled)
				{
					this.onPrevPerk();
					_loc3_ = true;
				}
				else if(param1 == "NextPerk" && this.NextPerkButton.ButtonVisible && this.NextPerkButton.ButtonEnabled)
				{
					this.onNextPerk();
					_loc3_ = true;
				}
			}
			return _loc3_;
		}
		
		private function onVBLoadComplete(param1:Event) : *
		{
			param1.target.removeEventListener(Event.COMPLETE,this.onVBLoadComplete);
			param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onVBLoadFail);
			if(this.VBHolder_mc.numChildren > 0)
			{
				param1.target.content.removeEventListener(Event.ENTER_FRAME,this.onPerkSelectionAnimUpdate);
				this.VBHolder_mc.removeChildAt(0);
			}
			this.VBHolder_mc.addChild(param1.target.content);
			param1.target.content.addEventListener(Event.ENTER_FRAME,this.onPerkSelectionAnimUpdate);
		}
		
		private function onVBLoadFail(param1:Event) : *
		{
			param1.target.removeEventListener(Event.COMPLETE,this.onVBLoadComplete);
			param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onVBLoadFail);
			if(this.VBHolder_mc.numChildren > 0)
			{
				this.VBHolder_mc.removeChildAt(0);
			}
		}
		
		protected function onPerkSelectionAnimUpdate(param1:Event) : *
		{
			if(param1.target.currentFrame == 1 && this._VBClipID != 0)
			{
				BGSExternalInterface.call(this.codeObj,"PlayPerkSound",this._VBClipID);
			}
		}
		
		function __setProp_List_mc_PerksTab_List_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.listEntryClass = "PerksListEntry";
			this.List_mc.numListItems = 10;
			this.List_mc.restoreListIndex = false;
			this.List_mc.textOption = "Shrink To Fit";
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
