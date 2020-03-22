package Shared.AS3.COMPANIONAPP
{
	import Shared.CustomEvent;
	import Shared.GlobalFunc;
	import Shared.QuantityMenuNEW;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import scaleform.clik.controls.Button;
	import scaleform.clik.controls.Slider;
	import scaleform.clik.events.ButtonEvent;
	import scaleform.clik.events.SliderEvent;
	
	public class MobileQuantityMenu extends QuantityMenuNEW
	{
		
		public static const QUANTITY_CHANGED = "QuantityChanged";
		 
		
		public var sliderCLIK:Slider;
		
		public var minusCLIK:Button;
		
		public var plusCLIK:Button;
		
		protected var _currentCount:uint;
		
		protected var _maxCount:uint;
		
		public function MobileQuantityMenu(param1:uint)
		{
			this._maxCount = param1;
			super(param1);
			this.__setProp_sliderCLIK_MobileQuantityMenu_CLIKSlider_0();
			this.__setProp_minusCLIK_MobileQuantityMenu_arrows_0();
			this.__setProp_plusCLIK_MobileQuantityMenu_arrows_0();
		}
		
		override public function onAddedToStage() : void
		{
			super.onAddedToStage();
			this.sliderCLIK.minimum = 1;
			this.sliderCLIK.maximum = this._maxCount;
			this.sliderCLIK.value = this._currentCount;
			this.sliderCLIK.offsetLeft = this.sliderCLIK.thumb.width / 2 + this.sliderCLIK.track.width / this.sliderCLIK.maximum;
			this.sliderCLIK.addEventListener(SliderEvent.VALUE_CHANGE,this.onSliderValueChange,false,0,true);
			this.minusCLIK.addEventListener(ButtonEvent.CLICK,this.onMinusClick,false,0,true);
			this.plusCLIK.addEventListener(ButtonEvent.CLICK,this.onPlusClick,false,0,true);
			this.minusCLIK.focusable = false;
			this.plusCLIK.focusable = false;
		}
		
		private function onSliderValueChange(param1:SliderEvent) : void
		{
			this.count = this.sliderCLIK.value;
		}
		
		private function onMinusClick(param1:ButtonEvent) : void
		{
			this.sliderCLIK.value--;
		}
		
		private function onPlusClick(param1:ButtonEvent) : void
		{
			this.sliderCLIK.value++;
		}
		
		protected function updateSliderVisual() : void
		{
			var _loc1_:MovieClip = null;
			if(this.sliderCLIK)
			{
				_loc1_ = this.sliderCLIK.getChildByName("fill") as MovieClip;
				_loc1_.width = this.sliderCLIK.thumb.x + this.sliderCLIK.thumb.width / 2;
				this.minusCLIK.enabled = this.sliderCLIK.value > this.sliderCLIK.minimum;
				this.plusCLIK.enabled = this.sliderCLIK.value < this.sliderCLIK.maximum;
			}
		}
		
		override public function get count() : uint
		{
			return this._currentCount;
		}
		
		override public function set count(param1:uint) : *
		{
			if(this._currentCount != param1)
			{
				this._currentCount = param1;
				dispatchEvent(new CustomEvent(QUANTITY_CHANGED,param1,true));
			}
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:Shape = null;
			var _loc2_:Shape = null;
			if(TopBracketHolder_mc.numChildren == 0)
			{
				_loc1_ = new Shape();
				_loc1_.graphics.lineStyle(2,16777215,1,true,LineScaleMode.NONE);
				_loc1_.graphics.moveTo(0,0);
				_loc1_.graphics.lineTo(Background_mc.x + (Background_mc.width - Header_tf.textWidth) / 2 - TopBracketHolder_mc.x - 12.5,0);
				TopBracketHolder_mc.addChild(_loc1_);
				_loc2_ = new Shape();
				_loc2_.graphics.lineStyle(2,16777215,1,true,LineScaleMode.NONE);
				_loc2_.graphics.moveTo(Background_mc.x + (Background_mc.width + Header_tf.textWidth) / 2 - TopBracketHolder_mc.x + 12.5,0);
				_loc2_.graphics.lineTo(Background_mc.x + Background_mc.width - TopBracketHolder_mc.x - 4,0);
				TopBracketHolder_mc.addChild(_loc2_);
			}
			GlobalFunc.SetText(Count_tf,this.count.toString(),false);
			this.updateSliderVisual();
			this.visible = true;
		}
		
		override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			return false;
		}
		
		function __setProp_sliderCLIK_MobileQuantityMenu_CLIKSlider_0() : *
		{
			try
			{
				this.sliderCLIK["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.sliderCLIK.enabled = true;
			this.sliderCLIK.focusable = false;
			this.sliderCLIK.liveDragging = true;
			this.sliderCLIK.maximum = 10;
			this.sliderCLIK.minimum = 0;
			this.sliderCLIK.offsetLeft = 20;
			this.sliderCLIK.offsetRight = 20;
			this.sliderCLIK.snapInterval = 1;
			this.sliderCLIK.snapping = true;
			this.sliderCLIK.value = 1;
			this.sliderCLIK.visible = true;
			try
			{
				this.sliderCLIK["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_minusCLIK_MobileQuantityMenu_arrows_0() : *
		{
			try
			{
				this.minusCLIK["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.minusCLIK.autoRepeat = false;
			this.minusCLIK.autoSize = "none";
			this.minusCLIK.data = "";
			this.minusCLIK.enabled = true;
			this.minusCLIK.enableInitCallback = false;
			this.minusCLIK.focusable = true;
			this.minusCLIK.label = "Button";
			this.minusCLIK.selected = false;
			this.minusCLIK.toggle = false;
			this.minusCLIK.visible = true;
			try
			{
				this.minusCLIK["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_plusCLIK_MobileQuantityMenu_arrows_0() : *
		{
			try
			{
				this.plusCLIK["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.plusCLIK.autoRepeat = false;
			this.plusCLIK.autoSize = "none";
			this.plusCLIK.data = "";
			this.plusCLIK.enabled = true;
			this.plusCLIK.enableInitCallback = false;
			this.plusCLIK.focusable = true;
			this.plusCLIK.label = "";
			this.plusCLIK.selected = false;
			this.plusCLIK.toggle = false;
			this.plusCLIK.visible = true;
			try
			{
				this.plusCLIK["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
