package
{
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.COMPANIONAPP.PipboyLoader;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class SPECIALTab extends PipboyTab
	{
		 
		
		public var List_mc:BSScrollingList;
		
		public var Description_tf:TextField;
		
		public var VBHolder_mc:MovieClip;
		
		private var _VBLoader:PipboyLoader;
		
		private var _VBClipName:String;
		
		private var _DescText:String;
		
		public function SPECIALTab()
		{
			super();
			this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.Description_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			this._VBLoader = new PipboyLoader();
			this._VBClipName = "";
			this._DescText = "";
			this.__setProp_List_mc_SPECIALTab_List_0();
		}
		
		override protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.Special;
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			var _loc2_:* = this.visible == true;
			super.onPipboyChangeEvent(param1);
			var _loc3_:* = this.visible == true;
			this.List_mc.entryList = param1.DataObj.SPECIALList;
			this.List_mc.InvalidateData();
			if(_loc3_)
			{
				stage.focus = this.List_mc;
				if(this.List_mc.selectedIndex == -1)
				{
					this.List_mc.selectedClipIndex = 0;
				}
			}
			else
			{
				this.List_mc.selectedIndex = -1;
			}
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:URLRequest = null;
			var _loc2_:LoaderContext = null;
			super.redrawUIComponent();
			if(this._VBClipName.length > 0)
			{
				_loc1_ = new URLRequest("Components/VaultBoys/SPECIAL/" + this._VBClipName + ".swf");
				_loc2_ = new LoaderContext(false,ApplicationDomain.currentDomain);
				this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVBLoadComplete);
				this._VBLoader.load(_loc1_,_loc2_);
			}
			else if(this.VBHolder_mc.numChildren > 0)
			{
				this.VBHolder_mc.removeChildAt(0);
			}
			GlobalFunc.SetText(this.Description_tf,this._DescText,false);
		}
		
		public function onListSelectionChange() : *
		{
			if(this.List_mc.selectedIndex != -1)
			{
				this._DescText = this.List_mc.selectedEntry.description;
				switch(this.List_mc.selectedIndex)
				{
					case 0:
						this._VBClipName = "Strength";
						break;
					case 1:
						this._VBClipName = "Perception";
						break;
					case 2:
						this._VBClipName = "Endurance";
						break;
					case 3:
						this._VBClipName = "Charisma";
						break;
					case 4:
						this._VBClipName = "Intelligence";
						break;
					case 5:
						this._VBClipName = "Agility";
						break;
					case 6:
						this._VBClipName = "Luck";
				}
			}
			else
			{
				this._DescText = " ";
				this._VBClipName = "";
			}
			SetIsDirty();
		}
		
		private function onVBLoadComplete(param1:Event) : *
		{
			param1.target.removeEventListener(Event.COMPLETE,this.onVBLoadComplete);
			if(this.VBHolder_mc.numChildren > 0)
			{
				this.VBHolder_mc.removeChildAt(0);
			}
			this.VBHolder_mc.addChild(param1.target.content);
		}
		
		function __setProp_List_mc_SPECIALTab_List_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.listEntryClass = "SPECIALListEntry";
			this.List_mc.numListItems = 7;
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
