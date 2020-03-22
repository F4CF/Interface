package
{
	import Shared.AS3.BSScrollingList;
	import Shared.BGSExternalInterface;
	import Shared.GlobalFunc;
	import Shared.IMenu;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class MessageBoxMenu extends IMenu
	{
		 
		
		public var Body_tf:TextField;
		
		public var List_mc:BSScrollingList;
		
		public var BGRect_mc:MovieClip;
		
		public var BGRectBlack_mc:MovieClip;
		
		public var BGSCodeObj:Object;
		
		private var fCenterY:Number;
		
		private var DisableInputCounter:uint;
		
		private var ListYBuffer:Number;
		
		private var MenuMode:Boolean = false;
		
		public function MessageBoxMenu()
		{
			super();
			this.BGSCodeObj = new Object();
			this.Body_tf.autoSize = TextFieldAutoSize.LEFT;
			this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPress);
			this.List_mc.addEventListener(BSScrollingList.PLAY_FOCUS_SOUND,this.playFocusSound);
			addEventListener(Event.ENTER_FRAME,this.initDisableInputCounter);
			this.visible = false;
			this.List_mc.disableInput = true;
			this.fCenterY = this.y + this.BGRect_mc.height / 2;
			this.DisableInputCounter = 0;
			this.ListYBuffer = this.BGRect_mc.height - (this.List_mc.y + this.List_mc.height);
			this.__setProp_List_mc_MenuObj_ButtonList_0();
		}
		
		public function get bodyText() : String
		{
			return this.Body_tf.text;
		}
		
		public function set bodyText(param1:String) : *
		{
			GlobalFunc.SetText(this.Body_tf,param1,true);
		}
		
		public function get buttonArray() : Array
		{
			return this.List_mc.entryList;
		}
		
		public function set buttonArray(param1:Array) : *
		{
			this.List_mc.entryList = param1;
		}
		
		public function get selectedIndex() : uint
		{
			return this.List_mc.selectedIndex;
		}
		
		public function set menuMode(param1:Boolean) : *
		{
			this.MenuMode = param1;
		}
		
		public function ForceInit() : *
		{
			if(this.List_mc.numListItems == 0)
			{
				this.List_mc.listEntryClass = "MessageBoxButtonEntry";
				this.List_mc.numListItems = 4;
				this.List_mc.onComponentInit(null);
			}
		}
		
		public function InvalidateMenu() : *
		{
			if(this.Body_tf.text.length > 0 && this.Body_tf.getCharBoundaries(this.Body_tf.text.length - 1) != null)
			{
				this.List_mc.y = this.Body_tf.y + this.Body_tf.getCharBoundaries(this.Body_tf.text.length - 1).bottom + 30;
			}
			this.List_mc.InvalidateData();
			this.BGRect_mc.height = this.List_mc.y + this.List_mc.shownItemsHeight + this.ListYBuffer;
			if(this.BGRectBlack_mc != null)
			{
				this.BGRectBlack_mc.height = this.List_mc.y + this.List_mc.shownItemsHeight + this.ListYBuffer;
				this.BGRectBlack_mc.visible = this.MenuMode;
			}
			this.y = this.fCenterY - this.BGRect_mc.height / 2;
			this.List_mc.selectedIndex = 0;
			stage.stageFocusRect = false;
			stage.focus = this.List_mc;
			this.visible = true;
		}
		
		private function initDisableInputCounter() : *
		{
			this.DisableInputCounter++;
			if(this.DisableInputCounter > 3)
			{
				removeEventListener(Event.ENTER_FRAME,this.initDisableInputCounter);
				this.List_mc.disableInput = false;
			}
		}
		
		private function onItemPress(param1:Event) : *
		{
			if(this.List_mc.selectedEntry.buttonIndex != undefined)
			{
				BGSExternalInterface.call(this.BGSCodeObj,"onButtonPress",this.List_mc.selectedEntry.buttonIndex);
			}
		}
		
		private function playFocusSound() : *
		{
			if(this.BGSCodeObj.PlayFocusSound != undefined)
			{
				BGSExternalInterface.call(this.BGSCodeObj,"PlayFocusSound");
			}
		}
		
		function __setProp_List_mc_MenuObj_ButtonList_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.disableSelection = false;
			this.List_mc.listEntryClass = "MessageBoxButtonEntry";
			this.List_mc.numListItems = 4;
			this.List_mc.restoreListIndex = true;
			this.List_mc.textOption = "None";
			this.List_mc.verticalSpacing = 7.5;
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
