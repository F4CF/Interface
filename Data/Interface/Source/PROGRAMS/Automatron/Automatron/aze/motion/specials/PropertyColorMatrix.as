package aze.motion.specials
{
	import aze.motion.EazeTween;
	import flash.filters.ColorMatrixFilter;
	import flash.display.DisplayObject;
	
	public class PropertyColorMatrix extends EazeSpecial
	{
		 
		
		private var removeWhenComplete:Boolean;
		
		private var colorMatrix:ColorMatrix;
		
		private var delta:Array;
		
		private var start:Array;
		
		private var temp:Array;
		
		public function PropertyColorMatrix(param1:Object, param2:*, param3:*, param4:EazeSpecial)
		{
			var _loc5_:uint = 0;
			super(param1,param2,param3,param4);
			this.colorMatrix = new ColorMatrix();
			if(param3.brightness)
			{
				this.colorMatrix.adjustBrightness(param3.brightness * 255);
			}
			if(param3.contrast)
			{
				this.colorMatrix.adjustContrast(param3.contrast);
			}
			if(param3.hue)
			{
				this.colorMatrix.adjustHue(param3.hue);
			}
			if(param3.saturation)
			{
				this.colorMatrix.adjustSaturation(param3.saturation + 1);
			}
			if(param3.colorize)
			{
				_loc5_ = "tint" in param3?uint(uint(param3.tint)):uint(16777215);
				this.colorMatrix.colorize(_loc5_,param3.colorize);
			}
			this.removeWhenComplete = param3.remove;
		}
		
		public static function register() : void
		{
			EazeTween.specialProperties["colorMatrixFilter"] = PropertyColorMatrix;
			EazeTween.specialProperties[ColorMatrixFilter] = PropertyColorMatrix;
		}
		
		override public function init(param1:Boolean) : void
		{
			var _loc4_:Array = null;
			var _loc5_:Array = null;
			var _loc2_:DisplayObject = DisplayObject(target);
			var _loc3_:ColorMatrixFilter = PropertyFilter.getCurrentFilter(ColorMatrixFilter,_loc2_,true) as ColorMatrixFilter;
			if(!_loc3_)
			{
				_loc3_ = new ColorMatrixFilter();
			}
			if(param1)
			{
				_loc5_ = _loc3_.matrix;
				_loc4_ = this.colorMatrix.matrix;
			}
			else
			{
				_loc5_ = this.colorMatrix.matrix;
				_loc4_ = _loc3_.matrix;
			}
			this.delta = new Array(20);
			var _loc6_:int = 0;
			while(_loc6_ < 20)
			{
				this.delta[_loc6_] = _loc5_[_loc6_] - _loc4_[_loc6_];
				_loc6_++;
			}
			this.start = _loc4_;
			this.temp = new Array(20);
			PropertyFilter.addFilter(_loc2_,new ColorMatrixFilter(_loc4_));
		}
		
		override public function update(param1:Number, param2:Boolean) : void
		{
			var _loc3_:DisplayObject = DisplayObject(target);
			PropertyFilter.getCurrentFilter(ColorMatrixFilter,_loc3_,true) as ColorMatrixFilter;
			if(this.removeWhenComplete && param2)
			{
				_loc3_.filters = _loc3_.filters;
				return;
			}
			var _loc4_:int = 0;
			while(_loc4_ < 20)
			{
				this.temp[_loc4_] = this.start[_loc4_] + param1 * this.delta[_loc4_];
				_loc4_++;
			}
			PropertyFilter.addFilter(_loc3_,new ColorMatrixFilter(this.temp));
		}
		
		override public function dispose() : void
		{
			this.colorMatrix = null;
			this.delta = null;
			this.start = null;
			this.temp = null;
			super.dispose();
		}
	}
}

import flash.filters.ColorMatrixFilter;

class ColorMatrix
{
	
	private static const LUMA_R:Number = 0.212671;
	
	private static const LUMA_G:Number = 0.71516;
	
	private static const LUMA_B:Number = 0.072169;
	
	private static const LUMA_R2:Number = 0.3086;
	
	private static const LUMA_G2:Number = 0.6094;
	
	private static const LUMA_B2:Number = 0.082;
	
	private static const ONETHIRD:Number = 1 / 3;
	
	private static const IDENTITY:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
	
	private static const RAD:Number = Math.PI / 180;
	 
	
	public var matrix:Array;
	
	function ColorMatrix(param1:Object = null)
	{
		super();
		if(param1 is ColorMatrix)
		{
			this.matrix = param1.matrix.concat();
		}
		else if(param1 is Array)
		{
			this.matrix = param1.concat();
		}
		else
		{
			this.reset();
		}
	}
	
	public function reset() : void
	{
		this.matrix = IDENTITY.concat();
	}
	
	public function adjustSaturation(param1:Number) : void
	{
		var _loc2_:Number = NaN;
		var _loc3_:Number = NaN;
		var _loc4_:Number = NaN;
		var _loc5_:Number = NaN;
		_loc2_ = 1 - param1;
		_loc3_ = _loc2_ * LUMA_R;
		_loc4_ = _loc2_ * LUMA_G;
		_loc5_ = _loc2_ * LUMA_B;
		this.concat([_loc3_ + param1,_loc4_,_loc5_,0,0,_loc3_,_loc4_ + param1,_loc5_,0,0,_loc3_,_loc4_,_loc5_ + param1,0,0,0,0,0,1,0]);
	}
	
	public function adjustContrast(param1:Number, param2:Number = NaN, param3:Number = NaN) : void
	{
		if(isNaN(param2))
		{
			param2 = param1;
		}
		if(isNaN(param3))
		{
			param3 = param1;
		}
		param1 = param1 + 1;
		param2 = param2 + 1;
		param3 = param3 + 1;
		this.concat([param1,0,0,0,128 * (1 - param1),0,param2,0,0,128 * (1 - param2),0,0,param3,0,128 * (1 - param3),0,0,0,1,0]);
	}
	
	public function adjustBrightness(param1:Number, param2:Number = NaN, param3:Number = NaN) : void
	{
		if(isNaN(param2))
		{
			param2 = param1;
		}
		if(isNaN(param3))
		{
			param3 = param1;
		}
		this.concat([1,0,0,0,param1,0,1,0,0,param2,0,0,1,0,param3,0,0,0,1,0]);
	}
	
	public function adjustHue(param1:Number) : void
	{
		param1 = param1 * RAD;
		var _loc2_:Number = Math.cos(param1);
		var _loc3_:Number = Math.sin(param1);
		this.concat([LUMA_R + _loc2_ * (1 - LUMA_R) + _loc3_ * -LUMA_R,LUMA_G + _loc2_ * -LUMA_G + _loc3_ * -LUMA_G,LUMA_B + _loc2_ * -LUMA_B + _loc3_ * (1 - LUMA_B),0,0,LUMA_R + _loc2_ * -LUMA_R + _loc3_ * 0.143,LUMA_G + _loc2_ * (1 - LUMA_G) + _loc3_ * 0.14,LUMA_B + _loc2_ * -LUMA_B + _loc3_ * -0.283,0,0,LUMA_R + _loc2_ * -LUMA_R + _loc3_ * -(1 - LUMA_R),LUMA_G + _loc2_ * -LUMA_G + _loc3_ * LUMA_G,LUMA_B + _loc2_ * (1 - LUMA_B) + _loc3_ * LUMA_B,0,0,0,0,0,1,0]);
	}
	
	public function colorize(param1:int, param2:Number = 1) : void
	{
		var _loc3_:Number = NaN;
		var _loc4_:Number = NaN;
		var _loc5_:Number = NaN;
		var _loc6_:Number = NaN;
		_loc3_ = (param1 >> 16 & 255) / 255;
		_loc4_ = (param1 >> 8 & 255) / 255;
		_loc5_ = (param1 & 255) / 255;
		_loc6_ = 1 - param2;
		this.concat([_loc6_ + param2 * _loc3_ * LUMA_R,param2 * _loc3_ * LUMA_G,param2 * _loc3_ * LUMA_B,0,0,param2 * _loc4_ * LUMA_R,_loc6_ + param2 * _loc4_ * LUMA_G,param2 * _loc4_ * LUMA_B,0,0,param2 * _loc5_ * LUMA_R,param2 * _loc5_ * LUMA_G,_loc6_ + param2 * _loc5_ * LUMA_B,0,0,0,0,0,1,0]);
	}
	
	public function get filter() : ColorMatrixFilter
	{
		return new ColorMatrixFilter(this.matrix);
	}
	
	public function concat(param1:Array) : void
	{
		var _loc4_:int = 0;
		var _loc5_:int = 0;
		var _loc2_:Array = [];
		var _loc3_:int = 0;
		_loc5_ = 0;
		while(_loc5_ < 4)
		{
			_loc4_ = 0;
			while(_loc4_ < 5)
			{
				_loc2_[int(_loc3_ + _loc4_)] = Number(param1[_loc3_]) * Number(this.matrix[_loc4_]) + Number(param1[int(_loc3_ + 1)]) * Number(this.matrix[int(_loc4_ + 5)]) + Number(param1[int(_loc3_ + 2)]) * Number(this.matrix[int(_loc4_ + 10)]) + Number(param1[int(_loc3_ + 3)]) * Number(this.matrix[int(_loc4_ + 15)]) + (_loc4_ == 4?Number(param1[int(_loc3_ + 4)]):0);
				_loc4_++;
			}
			_loc3_ = _loc3_ + 5;
			_loc5_++;
		}
		this.matrix = _loc2_;
	}
}
