package
{
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import Shared.GlobalFunc;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ConfirmPanel extends MovieClip
	{
		 
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var BGRect_mc:MovieClip;
		
		public var ConfirmQuestion_tf:TextField;
		
		public var ScrollUp_mc:MovieClip;
		
		public var ScrollDown_mc:MovieClip;
		
		private var ButtonHints:Vector.<BSButtonHintData>;
		
		private var AcceptButton:BSButtonHintData;
		
		private var CancelButton:BSButtonHintData;
		
		private var TopComponentSource = 0;
		
		private var TopComponent = 0;
		
		private const XBufferBeforeEntriesC = 65;
		
		private const YBufferBeforeComponentsC = 20;
		
		private const YBufferBetweenEntriesC = 5;
		
		private const YBufferBeforeButtonsC = 20;
		
		private const YBufferAfterButtonsC = 19;
		
		private const MaxHeightC = 400;
		
		private const MinWidthC = 354;
		
		private var EntriesA:Array;
		
		protected var BGSCodeObj:Object;
		
		public function ConfirmPanel()
		{
			this.AcceptButton = new BSButtonHintData("$CONFIRM","Enter","PSN_A","Xenon_A",1,this.onAcceptButton);
			this.CancelButton = new BSButtonHintData("$CANCEL","Tab","PSN_B","Xenon_B",1,this.onCancelButton);
			super();
			this.ButtonHints = new Vector.<BSButtonHintData>();
			this.ButtonHints.push(this.AcceptButton);
			this.ButtonHints.push(this.CancelButton);
			this.ButtonHintBar_mc.SetButtonHintData(this.ButtonHints);
			this.EntriesA = new Array();
			this.__setProp_ButtonHintBar_mc_ConfirmPanel_Body_0();
		}
		
		public function Clear() : *
		{
			var _loc2_:DisplayObject = null;
			this.EntriesA.length = 0;
			var _loc1_:* = 0;
			while(_loc1_ < numChildren)
			{
				_loc2_ = getChildAt(_loc1_);
				if(_loc2_ is ConfirmPanelComponentSourceEntry)
				{
					removeChildAt(_loc1_--);
				}
				_loc1_++;
			}
		}
		
		public function InitCodeObj(param1:Object) : *
		{
			this.BGSCodeObj = param1;
		}
		
		public function ReleaseCodeObj() : *
		{
			this.BGSCodeObj = null;
		}
		
		public function set confirmQuestion(param1:String) : *
		{
			GlobalFunc.SetText(this.ConfirmQuestion_tf,param1,false);
		}
		
		public function set acceptButtonText(param1:String) : *
		{
			this.AcceptButton.ButtonText = param1;
		}
		
		public function set hasCancelButton(param1:Boolean) : *
		{
			this.CancelButton.ButtonVisible = param1;
		}
		
		public function AddComponentSource(param1:String, param2:uint, param3:String, param4:uint, param5:uint = 4.294967295E9) : *
		{
			var _loc6_:* = null;
			var _loc7_:* = this.EntriesA.length;
			var _loc8_:* = 0;
			while(_loc8_ < _loc7_)
			{
				if(this.EntriesA[_loc8_].itemName == param1)
				{
					_loc6_ = this.EntriesA[_loc8_];
					break;
				}
				_loc8_++;
			}
			if(_loc6_ == null)
			{
				_loc6_ = new ConfirmPanelComponentSourceEntry(param1);
				addChild(_loc6_);
				this.EntriesA.push(_loc6_);
			}
			_loc6_.itemCount = Math.max(param2,_loc6_.itemCount);
			_loc6_.AddComponent(param3,param4,param5);
		}
		
		public function Build() : *
		{
			var _loc6_:* = undefined;
			var _loc7_:* = undefined;
			var _loc1_:* = this.EntriesA.length;
			var _loc2_:* = this.ConfirmQuestion_tf.y + (!!_loc1_?this.ConfirmQuestion_tf.height:this.ConfirmQuestion_tf.textHeight);
			this.ScrollUp_mc.y = _loc2_ + this.ScrollUp_mc.height;
			var _loc3_:* = 0;
			while(_loc3_ < _loc1_)
			{
				_loc6_ = this.EntriesA[_loc3_] as ConfirmPanelComponentSourceEntry;
				_loc6_.originalY = _loc2_;
				_loc6_.y = _loc2_;
				_loc6_.x = this.XBufferBeforeEntriesC;
				_loc6_.UpdateList();
				_loc2_ = _loc2_ + (_loc6_.height + this.YBufferBetweenEntriesC);
				_loc7_ = _loc6_.textWidth - _loc6_.textFieldWidth;
				if(_loc7_ > 0)
				{
					_loc6_.textFieldWidth = _loc6_.textWidth;
					this.BGRect_mc.width = this.BGRect_mc.width + _loc7_ * 2;
					this.BGRect_mc.x = this.BGRect_mc.x - _loc7_;
				}
				_loc3_++;
			}
			this.TopComponentSource = !!_loc1_?0:-1;
			this.TopComponent = 0;
			var _loc4_:* = this.BGRect_mc.height;
			var _loc5_:* = this.BGRect_mc.width;
			if(_loc1_ == 0)
			{
				this.BGRect_mc.width = this.MinWidthC;
				y = y - 20;
			}
			this.BGRect_mc.height = Math.min(_loc2_,this.MaxHeightC) + this.YBufferBeforeButtonsC + this.ButtonHintBar_mc.height + this.YBufferAfterButtonsC;
			this.ButtonHintBar_mc.y = this.BGRect_mc.height - this.ButtonHintBar_mc.height - this.YBufferAfterButtonsC;
			y = y - (this.BGRect_mc.height - _loc4_) * 0.5;
			x = x - (this.BGRect_mc.width - _loc5_) * 0.5;
			this.ButtonHintBar_mc.x = this.ButtonHintBar_mc.x + (this.BGRect_mc.width - _loc5_) * 0.5;
			this.ConfirmQuestion_tf.x = this.ConfirmQuestion_tf.x + (this.BGRect_mc.width - _loc5_) * 0.5;
			this.ScrollDown_mc.y = this.ButtonHintBar_mc.y - this.YBufferBeforeButtonsC - this.ScrollDown_mc.height;
			this.UpdateScroll();
		}
		
		private function onAcceptButton() : *
		{
			this.BGSCodeObj.onAcceptPress();
		}
		
		private function onCancelButton() : *
		{
			this.BGSCodeObj.onCancelPress();
		}
		
		private function ScrollUp() : *
		{
			var _loc1_:ConfirmPanelComponentSourceEntry = null;
			if(this.ScrollUp_mc.visible)
			{
				if(this.TopComponent > 0)
				{
					this.TopComponent--;
				}
				else
				{
					this.TopComponentSource--;
					_loc1_ = this.EntriesA[this.TopComponentSource];
					this.TopComponent = _loc1_.numComponents - 1;
				}
				this.UpdateScroll();
			}
		}
		
		private function ScrollDown() : *
		{
			var _loc1_:ConfirmPanelComponentSourceEntry = null;
			if(this.ScrollDown_mc.visible)
			{
				_loc1_ = this.EntriesA[this.TopComponentSource];
				if(this.TopComponent == _loc1_.numComponents - 1)
				{
					if(this.TopComponentSource < this.EntriesA.length - 1)
					{
						this.TopComponentSource++;
						this.TopComponent = 0;
						this.UpdateScroll();
					}
				}
				else
				{
					this.TopComponent++;
					this.UpdateScroll();
				}
			}
		}
		
		public function onLeftThumbstickInput(param1:uint) : *
		{
			if(param1 == 1)
			{
				this.ScrollUp();
			}
			else if(param1 == 3)
			{
				this.ScrollDown();
			}
		}
		
		private function UpdateScroll() : *
		{
			var _loc1_:* = undefined;
			var _loc2_:* = undefined;
			var _loc3_:ConfirmPanelComponentSourceEntry = null;
			var _loc4_:* = undefined;
			var _loc5_:Boolean = false;
			var _loc6_:* = undefined;
			var _loc7_:* = undefined;
			if(this.TopComponentSource == -1)
			{
				this.ScrollUp_mc.visible = this.ScrollDown_mc.visible = false;
			}
			else
			{
				_loc1_ = this.ConfirmQuestion_tf.y + this.ConfirmQuestion_tf.height;
				_loc2_ = this.ButtonHintBar_mc.y - this.YBufferBeforeButtonsC;
				_loc3_ = this.EntriesA[this.TopComponentSource];
				_loc4_ = _loc3_.GetComponentOriginalY(this.TopComponent) - _loc1_;
				_loc5_ = false;
				_loc6_ = this.EntriesA.length;
				_loc7_ = 0;
				while(_loc7_ < _loc6_)
				{
					_loc3_ = this.EntriesA[_loc7_] as ConfirmPanelComponentSourceEntry;
					_loc3_.y = _loc3_.originalY - _loc4_;
					_loc5_ = _loc3_.Clip(_loc1_,_loc2_);
					_loc7_++;
				}
				this.ScrollUp_mc.visible = this.TopComponentSource > 0 || this.TopComponent > 0;
				if(_loc5_)
				{
					if(this.TopComponent < _loc3_.numComponents - 1)
					{
						this.ScrollDown_mc.visible = true;
					}
					else
					{
						this.ScrollDown_mc.visible = this.TopComponentSource < _loc6_ - 1;
					}
				}
				else
				{
					this.ScrollDown_mc.visible = false;
				}
			}
		}
		
		function __setProp_ButtonHintBar_mc_ConfirmPanel_Body_0() : *
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
			this.ButtonHintBar_mc.bRedirectToButtonBarMenu = true;
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
