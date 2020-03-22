package
{
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ConfirmPanelComponentSourceEntry extends MovieClip
	{
		 
		
		public var textField:TextField;
		
		private var XBufferBeforeComponentsC = 1;
		
		private var EntriesA:Array;
		
		private var ItemCount:uint;
		
		private var ItemName:String;
		
		private var OriginalWidth:Number;
		
		private var OriginalY:Number;
		
		public function ConfirmPanelComponentSourceEntry(param1:String)
		{
			super();
			this.EntriesA = new Array();
			this.ItemName = param1;
		}
		
		public function get itemCount() : uint
		{
			return this.ItemCount;
		}
		
		public function set itemCount(param1:uint) : *
		{
			this.ItemCount = param1;
			this.UpdateText();
		}
		
		public function get itemName() : String
		{
			return this.ItemName;
		}
		
		public function get numComponents() : uint
		{
			return this.EntriesA.length;
		}
		
		public function get originalY() : Number
		{
			return this.OriginalY;
		}
		
		public function set originalY(param1:Number) : *
		{
			this.OriginalY = param1;
		}
		
		public function get textWidth() : Number
		{
			return this.textField.textWidth;
		}
		
		public function get textFieldWidth() : Number
		{
			return this.textField.width;
		}
		
		public function set textFieldWidth(param1:*) : *
		{
			var _loc2_:* = param1 - this.textField.width;
			this.textField.width = param1;
			this.textField.x = this.textField.x - _loc2_;
		}
		
		public function AddComponent(param1:String, param2:uint, param3:uint = 4.294967295E9) : *
		{
			var _loc4_:* = null;
			var _loc5_:* = this.EntriesA.length;
			var _loc6_:* = 0;
			while(_loc6_ < _loc5_)
			{
				if(this.EntriesA[_loc6_].componentName == param1)
				{
					_loc4_ = this.EntriesA[_loc6_];
					break;
				}
				_loc6_++;
			}
			if(_loc4_ == null)
			{
				_loc4_ = new ConfirmPanelComponentEntry(param1);
				addChild(_loc4_);
				this.EntriesA.push(_loc4_);
			}
			_loc4_.componentRequiredCount = _loc4_.componentRequiredCount + param2;
			_loc4_.componentInventoryCount = param3;
		}
		
		public function Clip(param1:Number, param2:Number) : Boolean
		{
			var _loc8_:* = undefined;
			var _loc3_:Boolean = false;
			var _loc4_:Number = param1 - y;
			var _loc5_:Number = param2 - y;
			this.textField.visible = this.textField.y >= _loc4_ && this.textField.y + this.textField.textHeight <= _loc5_;
			var _loc6_:* = this.EntriesA.length;
			var _loc7_:* = 0;
			while(_loc7_ < _loc6_)
			{
				_loc8_ = this.EntriesA[_loc7_] as ConfirmPanelComponentEntry;
				if(_loc8_.y < _loc4_ - 1)
				{
					_loc8_.visible = false;
				}
				else if(_loc8_.y + _loc8_.height > _loc5_)
				{
					_loc8_.visible = false;
					_loc3_ = true;
				}
				else
				{
					_loc8_.visible = true;
				}
				_loc7_++;
			}
			return _loc3_;
		}
		
		public function GetComponentOriginalY(param1:uint) : Number
		{
			var _loc2_:* = this.EntriesA[0] as ConfirmPanelComponentEntry;
			return this.OriginalY + param1 * _loc2_.height;
		}
		
		public function UpdateList() : *
		{
			var _loc4_:* = undefined;
			var _loc1_:* = 0;
			var _loc2_:* = this.EntriesA.length;
			var _loc3_:* = 0;
			while(_loc3_ < _loc2_)
			{
				_loc4_ = this.EntriesA[_loc3_] as ConfirmPanelComponentEntry;
				_loc4_.x = this.textField.width + this.textField.x + this.XBufferBeforeComponentsC;
				_loc4_.y = _loc1_;
				_loc1_ = _loc1_ + _loc4_.height;
				_loc3_++;
			}
		}
		
		public function UpdateText() : *
		{
			if(this.ItemCount > 1)
			{
				GlobalFunc.SetText(this.textField,this.ItemName + " (" + this.ItemCount.toString() + ")",false);
			}
			else
			{
				GlobalFunc.SetText(this.textField,this.ItemName,false);
			}
		}
	}
}
