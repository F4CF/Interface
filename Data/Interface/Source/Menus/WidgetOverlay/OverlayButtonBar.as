// 5000: The class 'OverlayButtonBar' must subclass 'flash.display.MovieClip' since it is linked to a library symbol of that type.
package
{
	import scaleform.clik.controls.ButtonBar;
	import flash.display.MovieClip;
	import scaleform.clik.controls.Button;
	import scaleform.clik.data.DataProvider;
	import scaleform.clik.events.ButtonEvent;
	
	public class OverlayButtonBar extends ButtonBar
	{
		
		public var Border:MovieClip;
		public var BGSCodeObj:Object;

		private const BUTTON_DEFINITION_STRIDE:Number = 2;
		private var _buttonHeight:Number;
		

		public function OverlayButtonBar()
		{
			super();
			this.itemRendererName = "OverlayButton";
			addEventListener(ButtonEvent.CLICK,this.ButtonCallback);
			this.BGSCodeObj = new Object();
			this.Border.visible = false;
		}
		
		public function get buttonHeight() : Number
		{
			return this._buttonHeight;
		}
		

		public function set buttonHeight(param1:Number) : void
		{
			this._buttonHeight = param1;
			invalidate();
		}

		override protected function setupRenderer(param1:Button, param2:uint) : void
		{
			super.setupRenderer(param1,param2);
			param1.height = this._buttonHeight > 0?Number(this._buttonHeight):Number(param1.actualHeight);
		}
		
		public function SetupButtons() : *
		{
			var _loc5_:Object = null;
			var _loc2_:Number = arguments.length / this.BUTTON_DEFINITION_STRIDE;
			var _loc3_:Array = new Array(_loc2_);
			var _loc4_:Number = 0;
			while(_loc4_ < _loc2_)
			{
				_loc5_ = {
					"label":arguments[_loc4_ * this.BUTTON_DEFINITION_STRIDE],
					"data":arguments[_loc4_ * this.BUTTON_DEFINITION_STRIDE + 1]
				};
				_loc3_[_loc4_] = _loc5_;
				_loc4_++;
			}
			this.dataProvider = new DataProvider(_loc3_);
			if(this.direction == DIRECTION_HORIZONTAL)
			{
				this.width = _loc2_ * this.buttonWidth + (_loc2_ - 1) * this.spacing + 1;
			}
			else
			{
				this.height = _loc2_ * this.buttonWidth + (_loc2_ - 1) * this.spacing + 1;
			}
			validateNow();
		}
		
		public function ButtonCallback(param1:ButtonEvent) : *
		{
			this.BGSCodeObj.onButtonPress(this.selectedIndex,this.data);
		}

		
	}
}
