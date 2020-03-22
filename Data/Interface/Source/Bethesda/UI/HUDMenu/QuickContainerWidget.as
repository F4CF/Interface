package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import scaleform.gfx.Extensions;
	
	public dynamic class QuickContainerWidget extends BSUIComponent
	{
		
		private static var cuiNumClips:Number = 5;
		 
		
		public var ListHeaderAndBracket_mc:MovieClip;
		
		public var ListItems_mc:MovieClip;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var ItemDataA:Vector.<QuickContainerItemData>;
		
		private var _selectedIndex:int;
		
		private var _bracketsVisible:Boolean;
		
		public var AButton:BSButtonHintData;
		
		public var XButton:BSButtonHintData;
		
		public var YButton:BSButtonHintData;
		
		private var ItemClipsA:Vector.<QuickContainerItem>;
		
		private var PositionForListSize:Vector.<int>;
		
		public function QuickContainerWidget()
		{
			var _loc3_:QuickContainerItem = null;
			this.AButton = new BSButtonHintData("$TAKE","E","PSN_A","Xenon_A",1,null);
			this.XButton = new BSButtonHintData("$QuickContainerTransfer","R","PSN_X","Xenon_X",1,null);
			this.YButton = new BSButtonHintData("Special Action","$SPACEBAR","PSN_Y","Xenon_Y",1,null);
			super();
			Extensions.enabled = true;
			this._selectedIndex = -1;
			this.PopulateButtonBar();
			this.ItemDataA = new Vector.<QuickContainerItemData>();
			this.ItemClipsA = new Vector.<QuickContainerItem>(cuiNumClips,true);
			this.PositionForListSize = new Vector.<int>(cuiNumClips + 1,true);
			var _loc1_:TextField = this.ListHeaderAndBracket_mc.ContainerName_mc.textField_tf as TextField;
			_loc1_.autoSize = TextFieldAutoSize.CENTER;
			_loc1_.multiline = false;
			_loc1_.wordWrap = false;
			var _loc2_:Number = 0;
			while(_loc2_ < cuiNumClips)
			{
				_loc3_ = this.ListItems_mc.getChildByName("ItemText" + _loc2_) as QuickContainerItem;
				this.ItemClipsA[_loc2_] = _loc3_;
				this.PositionForListSize[cuiNumClips - _loc2_] = _loc3_.y;
				_loc2_++;
			}
			this.PositionForListSize[0] = this.PositionForListSize[1];
			visible = false;
			alpha = 0;
			this.__setProp_ButtonHintBar_mc_QuickContainerWidget_ButtonHintBar_mc_0();
		}
		
		public function get numClips() : uint
		{
			return cuiNumClips;
		}
		
		protected function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.AButton);
			_loc1_.push(this.XButton);
			_loc1_.push(this.YButton);
			this.XButton.ButtonVisible = false;
			this.AButton.ButtonVisible = false;
			this.YButton.ButtonVisible = false;
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		public function UpdateList(param1:int) : void
		{
			var _loc3_:QuickContainerItem = null;
			this._selectedIndex = param1;
			var _loc2_:uint = 0;
			while(_loc2_ < cuiNumClips)
			{
				_loc3_ = this.ItemClipsA[_loc2_];
				if(_loc2_ < this.ItemDataA.length)
				{
					_loc3_.data = this.ItemDataA[_loc2_];
					_loc3_.selected = this._selectedIndex == _loc2_;
				}
				else
				{
					_loc3_.data = null;
				}
				_loc2_++;
			}
		}
		
		public function UpdateComponentPositions() : void
		{
			var _loc1_:int = this.PositionForListSize[this.ItemDataA.length];
			this.ListItems_mc.y = _loc1_;
			this.ListHeaderAndBracket_mc.BracketPairHolder_mc.UpperBracket_mc.y = _loc1_;
			this.ListHeaderAndBracket_mc.BracketPairHolder_mc.visible = this._bracketsVisible;
			if(this._bracketsVisible)
			{
				this.ListHeaderAndBracket_mc.ContainerName_mc.y = _loc1_;
			}
			else
			{
				this.ListHeaderAndBracket_mc.ContainerName_mc.y = _loc1_ - this.ListHeaderAndBracket_mc.y;
			}
		}
		
		public function set containerName(param1:String) : *
		{
			GlobalFunc.SetText(this.ListHeaderAndBracket_mc.ContainerName_mc.textField_tf,param1,false,true);
		}
		
		public function set bracketsVisible(param1:Boolean) : void
		{
			this._bracketsVisible = param1;
		}
		
		function __setProp_ButtonHintBar_mc_QuickContainerWidget_ButtonHintBar_mc_0() : *
		{
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ButtonHintBar_mc.BackgroundAlpha = 1;
			this.ButtonHintBar_mc.BackgroundColor = 0;
			this.ButtonHintBar_mc.bracketCornerLength = 6;
			this.ButtonHintBar_mc.bracketLineWidth = 1.5;
			this.ButtonHintBar_mc.BracketStyle = "horizontal";
			this.ButtonHintBar_mc.bRedirectToButtonBarMenu = false;
			this.ButtonHintBar_mc.bShowBrackets = false;
			this.ButtonHintBar_mc.bUseShadedBackground = false;
			this.ButtonHintBar_mc.ShadedBackgroundMethod = "Shader";
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
