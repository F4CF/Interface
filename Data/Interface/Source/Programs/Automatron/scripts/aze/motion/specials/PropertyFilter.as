package aze.motion.specials
{
	import aze.motion.EazeTween;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.BitmapFilter;
	import flash.display.DisplayObject;
	
	public class PropertyFilter extends EazeSpecial
	{
		
		public static var fixedProp:Object = {
			"quality":true,
			"color":true
		};
		 
		
		private var properties:Array;
		
		private var fvalue:BitmapFilter;
		
		private var start:Object;
		
		private var delta:Object;
		
		private var fColor:Object;
		
		private var startColor:Object;
		
		private var deltaColor:Object;
		
		private var removeWhenComplete:Boolean;
		
		private var isNewFilter:Boolean;
		
		private var filterClass:Class;
		
		public function PropertyFilter(param1:Object, param2:*, param3:*, param4:EazeSpecial)
		{
			var _loc7_:* = null;
			var _loc8_:* = undefined;
			super(param1,param2,param3,param4);
			this.filterClass = this.resolveFilterClass(param2);
			var _loc5_:DisplayObject = DisplayObject(param1);
			var _loc6_:BitmapFilter = PropertyFilter.getCurrentFilter(this.filterClass,_loc5_,false);
			if(!_loc6_)
			{
				this.isNewFilter = true;
				_loc6_ = new this.filterClass();
			}
			this.properties = [];
			this.fvalue = _loc6_.clone();
			for(_loc7_ in param3)
			{
				_loc8_ = param3[_loc7_];
				if(_loc7_ == "remove")
				{
					this.removeWhenComplete = _loc8_;
				}
				else
				{
					if(_loc7_ == "color" && !this.isNewFilter)
					{
						this.fColor = {
							"r":_loc8_ >> 16 & 255,
							"g":_loc8_ >> 8 & 255,
							"b":_loc8_ & 255
						};
					}
					this.fvalue[_loc7_] = _loc8_;
					this.properties.push(_loc7_);
				}
			}
		}
		
		public static function register() : void
		{
			EazeTween.specialProperties["blurFilter"] = PropertyFilter;
			EazeTween.specialProperties["glowFilter"] = PropertyFilter;
			EazeTween.specialProperties["dropShadowFilter"] = PropertyFilter;
			EazeTween.specialProperties[BlurFilter] = PropertyFilter;
			EazeTween.specialProperties[GlowFilter] = PropertyFilter;
			EazeTween.specialProperties[DropShadowFilter] = PropertyFilter;
		}
		
		public static function getCurrentFilter(param1:Class, param2:DisplayObject, param3:Boolean) : BitmapFilter
		{
			var _loc4_:int = 0;
			var _loc5_:Array = null;
			var _loc6_:BitmapFilter = null;
			if(param2.filters)
			{
				_loc5_ = param2.filters;
				_loc4_ = 0;
				while(_loc4_ < _loc5_.length)
				{
					if(_loc5_[_loc4_] is param1)
					{
						if(param3)
						{
							_loc6_ = _loc5_.splice(_loc4_,1)[0];
							param2.filters = _loc5_;
							return _loc6_;
						}
						return _loc5_[_loc4_];
					}
					_loc4_++;
				}
			}
			return null;
		}
		
		public static function addFilter(param1:DisplayObject, param2:BitmapFilter) : void
		{
			var _loc3_:Array = param1.filters || [];
			_loc3_.push(param2);
			param1.filters = _loc3_;
		}
		
		private function resolveFilterClass(param1:*) : Class
		{
			if(param1 is Class)
			{
				return param1;
			}
			switch(param1)
			{
				case "blurFilter":
					return BlurFilter;
				case "glowFilter":
					return GlowFilter;
				case "dropShadowFilter":
					return DropShadowFilter;
				default:
					return BlurFilter;
			}
		}
		
		override public function init(param1:Boolean) : void
		{
			var _loc4_:BitmapFilter = null;
			var _loc5_:BitmapFilter = null;
			var _loc6_:Object = null;
			var _loc7_:Object = null;
			var _loc8_:* = undefined;
			var _loc10_:String = null;
			var _loc2_:DisplayObject = DisplayObject(target);
			var _loc3_:BitmapFilter = PropertyFilter.getCurrentFilter(this.filterClass,_loc2_,true);
			if(!_loc3_)
			{
				_loc3_ = new this.filterClass();
			}
			if(this.fColor)
			{
				_loc8_ = _loc3_["color"];
				_loc6_ = {
					"r":_loc8_ >> 16 & 255,
					"g":_loc8_ >> 8 & 255,
					"b":_loc8_ & 255
				};
			}
			if(param1)
			{
				_loc4_ = this.fvalue;
				_loc5_ = _loc3_;
				this.startColor = this.fColor;
				_loc7_ = _loc6_;
			}
			else
			{
				_loc4_ = _loc3_;
				_loc5_ = this.fvalue;
				this.startColor = _loc6_;
				_loc7_ = this.fColor;
			}
			this.start = {};
			this.delta = {};
			var _loc9_:int = 0;
			for(; _loc9_ < this.properties.length; _loc9_++)
			{
				_loc10_ = this.properties[_loc9_];
				_loc8_ = this.fvalue[_loc10_];
				if(_loc8_ is Boolean)
				{
					_loc3_[_loc10_] = _loc8_;
					this.properties[_loc9_] = null;
				}
				else
				{
					if(this.isNewFilter)
					{
						if(_loc10_ in fixedProp)
						{
							_loc3_[_loc10_] = _loc8_;
							this.properties[_loc9_] = null;
							continue;
						}
						_loc3_[_loc10_] = 0;
					}
					else if(_loc10_ == "color" && this.fColor)
					{
						this.deltaColor = {
							"r":_loc7_.r - this.startColor.r,
							"g":_loc7_.g - this.startColor.g,
							"b":_loc7_.b - this.startColor.b
						};
						this.properties[_loc9_] = null;
						continue;
					}
					this.start[_loc10_] = _loc4_[_loc10_];
					this.delta[_loc10_] = _loc5_[_loc10_] - this.start[_loc10_];
				}
			}
			this.fvalue = null;
			this.fColor = null;
			PropertyFilter.addFilter(_loc2_,_loc4_);
		}
		
		override public function update(param1:Number, param2:Boolean) : void
		{
			var _loc6_:String = null;
			var _loc3_:DisplayObject = DisplayObject(target);
			var _loc4_:BitmapFilter = PropertyFilter.getCurrentFilter(this.filterClass,_loc3_,true);
			if(this.removeWhenComplete && param2)
			{
				_loc3_.filters = _loc3_.filters;
				return;
			}
			if(!_loc4_)
			{
				_loc4_ = new this.filterClass();
			}
			var _loc5_:int = 0;
			while(_loc5_ < this.properties.length)
			{
				_loc6_ = this.properties[_loc5_];
				if(_loc6_)
				{
					_loc4_[_loc6_] = this.start[_loc6_] + param1 * this.delta[_loc6_];
				}
				_loc5_++;
			}
			if(this.startColor)
			{
				_loc4_["color"] = this.startColor.r + param1 * this.deltaColor.r << 16 | this.startColor.g + param1 * this.deltaColor.g << 8 | this.startColor.b + param1 * this.deltaColor.b;
			}
			PropertyFilter.addFilter(_loc3_,_loc4_);
		}
		
		override public function dispose() : void
		{
			this.filterClass = null;
			this.start = this.delta = null;
			this.startColor = this.deltaColor = null;
			this.fvalue = null;
			this.fColor = null;
			this.properties = null;
			super.dispose();
		}
	}
}
