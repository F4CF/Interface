package Shared.AS3
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public dynamic class BSButtonHintData extends EventDispatcher
	{
		
		public static const BUTTON_HINT_DATA_CHANGE:String = "ButtonHintDataChange";
		 
		
		private var _strButtonText:String;
		
		private var _strPCKey:String;
		
		private var _strPSNButton:String;
		
		private var _strXenonButton:String;
		
		private var _uiJustification:uint;
		
		private var _callbackFunction:Function;
		
		private var _bButtonDisabled:Boolean;
		
		private var _bSecondaryButtonDisabled:Boolean;
		
		private var _bButtonVisible:Boolean;
		
		private var _bButtonFlashing:Boolean;
		
		private var _hasSecondaryButton:Boolean;
		
		private var _strSecondaryPCKey:String;
		
		private var _strSecondaryXenonButton:String;
		
		private var _strSecondaryPSNButton:String;
		
		private var _secondaryButtonCallback:Function;
		
		private var _strDynamicMovieClipName:String;
		
		public var onAnnounceDataChange:Function;
		
		public var onTextClick:Function;
		
		public var onSecondaryButtonClick:Function;
		
		public function BSButtonHintData(param1:String, param2:String, param3:String, param4:String, param5:uint, param6:Function)
		{
			this.onAnnounceDataChange = this.onAnnounceDataChange_Impl;
			this.onTextClick = this.onTextClick_Impl;
			this.onSecondaryButtonClick = this.onSecondaryButtonClick_Impl;
			super();
			this._strPCKey = param2;
			this._strButtonText = param1;
			this._strXenonButton = param4;
			this._strPSNButton = param3;
			this._uiJustification = param5;
			this._callbackFunction = param6;
			this._bButtonDisabled = false;
			this._bButtonVisible = true;
			this._bButtonFlashing = false;
			this._hasSecondaryButton = false;
			this._strSecondaryPCKey = "";
			this._strSecondaryPSNButton = "";
			this._strSecondaryXenonButton = "";
			this._secondaryButtonCallback = null;
			this._strDynamicMovieClipName = "";
		}
		
		public function get PCKey() : String
		{
			return this._strPCKey;
		}
		
		public function get PSNButton() : String
		{
			return this._strPSNButton;
		}
		
		public function get XenonButton() : String
		{
			return this._strXenonButton;
		}
		
		public function get Justification() : uint
		{
			return this._uiJustification;
		}
		
		public function get SecondaryPCKey() : String
		{
			return this._strSecondaryPCKey;
		}
		
		public function get SecondaryPSNButton() : String
		{
			return this._strSecondaryPSNButton;
		}
		
		public function get SecondaryXenonButton() : String
		{
			return this._strSecondaryXenonButton;
		}
		
		public function get DynamicMovieClipName() : String
		{
			return this._strDynamicMovieClipName;
		}
		
		public function set DynamicMovieClipName(param1:String) : void
		{
			if(this._strDynamicMovieClipName != param1)
			{
				this._strDynamicMovieClipName = param1;
				this.AnnounceDataChange();
			}
		}
		
		public function get ButtonDisabled() : Boolean
		{
			return this._bButtonDisabled;
		}
		
		public function set ButtonDisabled(param1:Boolean) : *
		{
			if(this._bButtonDisabled != param1)
			{
				this._bButtonDisabled = param1;
				this.AnnounceDataChange();
			}
		}
		
		public function get ButtonEnabled() : Boolean
		{
			return !this.ButtonDisabled;
		}
		
		public function set ButtonEnabled(param1:Boolean) : void
		{
			this.ButtonDisabled = !param1;
		}
		
		public function get SecondaryButtonDisabled() : Boolean
		{
			return this._bSecondaryButtonDisabled;
		}
		
		public function set SecondaryButtonDisabled(param1:Boolean) : *
		{
			if(this._bSecondaryButtonDisabled != param1)
			{
				this._bSecondaryButtonDisabled = param1;
				this.AnnounceDataChange();
			}
		}
		
		public function get SecondaryButtonEnabled() : Boolean
		{
			return !this.SecondaryButtonDisabled;
		}
		
		public function set SecondaryButtonEnabled(param1:Boolean) : void
		{
			this.SecondaryButtonDisabled = !param1;
		}
		
		public function get ButtonText() : String
		{
			return this._strButtonText;
		}
		
		public function set ButtonText(param1:String) : void
		{
			if(this._strButtonText != param1)
			{
				this._strButtonText = param1;
				this.AnnounceDataChange();
			}
		}
		
		public function get ButtonVisible() : Boolean
		{
			return this._bButtonVisible;
		}
		
		public function set ButtonVisible(param1:Boolean) : void
		{
			if(this._bButtonVisible != param1)
			{
				this._bButtonVisible = param1;
				this.AnnounceDataChange();
			}
		}
		
		public function get ButtonFlashing() : Boolean
		{
			return this._bButtonFlashing;
		}
		
		public function set ButtonFlashing(param1:Boolean) : void
		{
			if(this._bButtonFlashing != param1)
			{
				this._bButtonFlashing = param1;
				this.AnnounceDataChange();
			}
		}
		
		public function get hasSecondaryButton() : Boolean
		{
			return this._hasSecondaryButton;
		}
		
		private function AnnounceDataChange() : void
		{
			dispatchEvent(new Event(BUTTON_HINT_DATA_CHANGE));
			if(this.onAnnounceDataChange is Function)
			{
				this.onAnnounceDataChange();
			}
		}
		
		private function onAnnounceDataChange_Impl() : void
		{
		}
		
		public function SetButtons(param1:String, param2:String, param3:String) : *
		{
			var _loc4_:Boolean = false;
			if(this._strPCKey != param1)
			{
				this._strPCKey = param1;
				_loc4_ = true;
			}
			if(this._strPSNButton != param2)
			{
				this._strPSNButton = param2;
				_loc4_ = true;
			}
			if(this._strXenonButton != param3)
			{
				this._strXenonButton = param3;
				_loc4_ = true;
			}
			if(_loc4_)
			{
				this.AnnounceDataChange();
			}
		}
		
		public function SetSecondaryButtons(param1:String, param2:String, param3:String) : *
		{
			this._hasSecondaryButton = true;
			var _loc4_:Boolean = false;
			if(this._strSecondaryPCKey != param1)
			{
				this._strSecondaryPCKey = param1;
				_loc4_ = true;
			}
			if(this._strSecondaryPSNButton != param2)
			{
				this._strSecondaryPSNButton = param2;
				_loc4_ = true;
			}
			if(this._strSecondaryXenonButton != param3)
			{
				this._strSecondaryXenonButton = param3;
				_loc4_ = true;
			}
			if(_loc4_)
			{
				this.AnnounceDataChange();
			}
		}
		
		public function set secondaryButtonCallback(param1:Function) : *
		{
			this._secondaryButtonCallback = param1;
		}
		
		private function onTextClick_Impl() : void
		{
			if(this._callbackFunction is Function)
			{
				this._callbackFunction.call();
			}
		}
		
		private function onSecondaryButtonClick_Impl() : void
		{
			if(this._secondaryButtonCallback is Function)
			{
				this._secondaryButtonCallback.call();
			}
		}
	}
}
