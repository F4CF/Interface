package Shared
{
	import Shared.AS3.BSSlider;
	import Shared.AS3.BSUIComponent;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class QuantityMenuNEW extends BSUIComponent
	{
		
		public static const QUANTITY_CHANGED = "QuantityChanged";
		 
		
		public var Header_tf:TextField;
		
		public var TopBracketHolder_mc:MovieClip;
		
		public var Count_tf:TextField;
		
		public var Slider_mc:BSSlider;
		
		public var Background_mc:MovieClip;
		
		private var _CurrCount:uint;
		
		private var _MaxCount:uint;
		
		public function QuantityMenuNEW(param1:uint)
		{
			super();
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.Header_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Count_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			this._MaxCount = param1;
			if(this.Slider_mc != null)
			{
				this.Slider_mc.maxValue = this._MaxCount;
				this.Slider_mc.minValue = 1;
				this.Slider_mc.value = this._MaxCount;
				this.Slider_mc.controllerBumberJumpSize = Math.max(param1 / 20,1);
				this.Slider_mc.controllerTriggerJumpSize = Math.max(param1 / 4,1);
			}
			this.count = param1;
			addEventListener(BSSlider.VALUE_CHANGED,this.onSliderValueChanged);
			this.visible = false;
		}
		
		public function get count() : uint
		{
			return this._CurrCount;
		}
		
		public function set count(param1:uint) : *
		{
			this._CurrCount = param1;
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:Point = null;
			var _loc2_:int = 0;
			var _loc3_:Shape = null;
			var _loc4_:Shape = null;
			super.redrawUIComponent();
			if(this.TopBracketHolder_mc.numChildren == 0)
			{
				_loc1_ = new Point();
				_loc2_ = this.Header_tf.x + this.Header_tf.getLineMetrics(0).x;
				_loc1_.x = _loc2_ + this.Header_tf.getCharBoundaries(0).x;
				_loc1_.y = _loc2_ + this.Header_tf.getCharBoundaries(this.Header_tf.text.length - 1).right;
				_loc3_ = new Shape();
				_loc3_.graphics.lineStyle(2,16777215,1,true,LineScaleMode.NONE);
				_loc3_.graphics.moveTo(0,0);
				_loc3_.graphics.lineTo(_loc1_.x - this.TopBracketHolder_mc.x - 12.5,0);
				this.TopBracketHolder_mc.addChild(_loc3_);
				_loc4_ = new Shape();
				_loc4_.graphics.lineStyle(2,16777215,1,true,LineScaleMode.NONE);
				_loc4_.graphics.moveTo(_loc1_.y - this.TopBracketHolder_mc.x + 12.5,0);
				_loc4_.graphics.lineTo(this.Background_mc.x + this.Background_mc.width - this.TopBracketHolder_mc.x - 4,0);
				this.TopBracketHolder_mc.addChild(_loc4_);
			}
			GlobalFunc.SetText(this.Count_tf,this.count.toString(),false);
			this.visible = true;
		}
		
		public function onSliderValueChanged(param1:CustomEvent) : *
		{
			var _loc2_:uint = param1.params as uint;
			if(this.count != _loc2_)
			{
				this.count = _loc2_;
				dispatchEvent(new CustomEvent(QUANTITY_CHANGED,_loc2_,true));
			}
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			return this.Slider_mc.ProcessUserEvent(param1,param2);
		}
	}
}
