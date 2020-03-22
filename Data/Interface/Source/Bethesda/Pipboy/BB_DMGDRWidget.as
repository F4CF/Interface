package
{
	import flash.display.MovieClip;
	
	public class BB_DMGDRWidget extends MovieClip
	{
		 
		
		public var Icon_mc:MovieClip;
		
		private const ENTRY_SPACING:uint = 15;
		
		public function BB_DMGDRWidget()
		{
			super();
		}
		
		public function redraw(param1:Boolean, param2:Array) : *
		{
			var _loc4_:int = 0;
			while(this.numChildren > 1)
			{
				this.removeChildAt(this.numChildren - 1);
			}
			this.Icon_mc.gotoAndStop(!!param1?"Weapon":"Armor");
			var _loc3_:Number = 0;
			if(param2.length == 0)
			{
				_loc3_ = this.AddEntry(param1,{
					"type":1,
					"value":0
				},_loc3_);
			}
			else
			{
				_loc4_ = param2.length - 1;
				while(_loc4_ >= 0)
				{
					if(param2[_loc4_].value > 0)
					{
						_loc3_ = this.AddEntry(param1,param2[_loc4_],_loc3_);
					}
					_loc4_--;
				}
			}
			this.Icon_mc.x = _loc3_ - 25;
		}
		
		private function AddEntry(param1:Boolean, param2:Object, param3:Number) : Number
		{
			var _loc4_:BB_DMGDRWidget_Entry = new BB_DMGDRWidget_Entry();
			_loc4_.redraw(param1,param2.type,param2.value);
			this.addChild(_loc4_);
			_loc4_.x = param3;
			return param3 + _loc4_.leftX - this.ENTRY_SPACING;
		}
	}
}
