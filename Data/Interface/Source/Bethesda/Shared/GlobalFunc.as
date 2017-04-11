package Shared
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import scaleform.gfx.Extensions;
	
	public class GlobalFunc
	{
		
		public static const PIPBOY_GREY_OUT_ALPHA:Number = 0.5;
		
		public static const SELECTED_RECT_ALPHA:Number = 1;
		
		public static const DIMMED_ALPHA:Number = 0.65;
		
		public static const NUM_DAMAGE_TYPES:uint = 6;
		
		protected static const CLOSE_ENOUGH_EPSILON:Number = 0.001;
		
		private static const MAX_TRUNCATED_TEXT_LENGTH = 42;
		 
		
		public function GlobalFunc()
		{
			super();
		}
		
		public static function Lerp(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean) : Number
		{
			var _loc7_:Number = param1 + (param5 - param3) / (param4 - param3) * (param2 - param1);
			if(param6)
			{
				if(param1 < param2)
				{
					_loc7_ = Math.min(Math.max(_loc7_,param1),param2);
				}
				else
				{
					_loc7_ = Math.min(Math.max(_loc7_,param2),param1);
				}
			}
			return _loc7_;
		}
		
		public static function RoundDecimal(param1:Number, param2:Number) : Number
		{
			var _loc3_:Number = Math.pow(10,param2);
			return Math.round(_loc3_ * param1) / _loc3_;
		}
		
		public static function CloseToNumber(param1:Number, param2:Number) : Boolean
		{
			return Math.abs(param1 - param2) < CLOSE_ENOUGH_EPSILON;
		}
		
		public static function MaintainTextFormat() : *
		{
			TextField.prototype.SetText = function(param1:String, param2:Boolean, param3:Boolean = false):*
			{
				var _loc5_:Number = NaN;
				var _loc6_:Boolean = false;
				if(!param1 || param1 == "")
				{
					param1 = " ";
				}
				if(param3 && param1.charAt(0) != "$")
				{
					param1 = param1.toUpperCase();
				}
				var _loc4_:TextFormat = this.getTextFormat();
				if(param2)
				{
					_loc5_ = Number(_loc4_.letterSpacing);
					_loc6_ = _loc4_.kerning;
					this.htmlText = param1;
					_loc4_ = this.getTextFormat();
					_loc4_.letterSpacing = _loc5_;
					_loc4_.kerning = _loc6_;
					this.setTextFormat(_loc4_);
					this.htmlText = param1;
				}
				else
				{
					this.text = param1;
					this.setTextFormat(_loc4_);
					this.text = param1;
				}
			};
		}
		
		public static function SetText(param1:TextField, param2:String, param3:Boolean, param4:Boolean = false, param5:* = false) : *
		{
			var _loc6_:TextFormat = null;
			var _loc7_:Number = NaN;
			var _loc8_:Boolean = false;
			if(!param2 || param2 == "")
			{
				param2 = " ";
			}
			if(param4 && param2.charAt(0) != "$")
			{
				param2 = param2.toUpperCase();
			}
			if(param3)
			{
				_loc6_ = param1.getTextFormat();
				_loc7_ = Number(_loc6_.letterSpacing);
				_loc8_ = _loc6_.kerning;
				param1.htmlText = param2;
				_loc6_ = param1.getTextFormat();
				_loc6_.letterSpacing = _loc7_;
				_loc6_.kerning = _loc8_;
				param1.setTextFormat(_loc6_);
			}
			else
			{
				param1.text = param2;
			}
			if(param5 && param1.text.length > MAX_TRUNCATED_TEXT_LENGTH)
			{
				param1.text = param1.text.slice(0,MAX_TRUNCATED_TEXT_LENGTH - 3) + "...";
			}
		}
		
		public static function LockToSafeRect(param1:DisplayObject, param2:String, param3:Number = 0, param4:Number = 0) : *
		{
			var _loc5_:Rectangle = Extensions.visibleRect;
			var _loc6_:Point = new Point(_loc5_.x + param3,_loc5_.y + param4);
			var _loc7_:Point = new Point(_loc5_.x + _loc5_.width - param3,_loc5_.y + _loc5_.height - param4);
			var _loc8_:Point = param1.parent.globalToLocal(_loc6_);
			var _loc9_:Point = param1.parent.globalToLocal(_loc7_);
			var _loc10_:Point = Point.interpolate(_loc8_,_loc9_,0.5);
			if(param2 == "T" || param2 == "TL" || param2 == "TR" || param2 == "TC")
			{
				param1.y = _loc8_.y;
			}
			if(param2 == "CR" || param2 == "CC" || param2 == "CL")
			{
				param1.y = _loc10_.y;
			}
			if(param2 == "B" || param2 == "BL" || param2 == "BR" || param2 == "BC")
			{
				param1.y = _loc9_.y;
			}
			if(param2 == "L" || param2 == "TL" || param2 == "BL" || param2 == "CL")
			{
				param1.x = _loc8_.x;
			}
			if(param2 == "TC" || param2 == "CC" || param2 == "BC")
			{
				param1.x = _loc10_.x;
			}
			if(param2 == "R" || param2 == "TR" || param2 == "BR" || param2 == "CR")
			{
				param1.x = _loc9_.x;
			}
		}
		
		public static function AddMovieExploreFunctions() : *
		{
			MovieClip.prototype.getMovieClips = function():Array
			{
				var _loc2_:* = undefined;
				var _loc1_:* = new Array();
				for(_loc2_ in this)
				{
					if(this[_loc2_] is MovieClip && this[_loc2_] != this)
					{
						_loc1_.push(this[_loc2_]);
					}
				}
				return _loc1_;
			};
			MovieClip.prototype.showMovieClips = function():*
			{
				var _loc1_:* = undefined;
				for(_loc1_ in this)
				{
					if(this[_loc1_] is MovieClip && this[_loc1_] != this)
					{
						trace(this[_loc1_]);
						this[_loc1_].showMovieClips();
					}
				}
			};
		}
		
		public static function AddReverseFunctions() : *
		{
			MovieClip.prototype.PlayReverseCallback = function(param1:Event):*
			{
				if(param1.currentTarget.currentFrame > 1)
				{
					param1.currentTarget.gotoAndStop(param1.currentTarget.currentFrame - 1);
				}
				else
				{
					param1.currentTarget.removeEventListener(Event.ENTER_FRAME,param1.currentTarget.PlayReverseCallback);
				}
			};
			MovieClip.prototype.PlayReverse = function():*
			{
				if(this.currentFrame > 1)
				{
					this.gotoAndStop(this.currentFrame - 1);
					this.addEventListener(Event.ENTER_FRAME,this.PlayReverseCallback);
				}
				else
				{
					this.gotoAndStop(1);
				}
			};
			MovieClip.prototype.PlayForward = function(param1:String):*
			{
				delete this.onEnterFrame;
				this.gotoAndPlay(param1);
			};
			MovieClip.prototype.PlayForward = function(param1:Number):*
			{
				delete this.onEnterFrame;
				this.gotoAndPlay(param1);
			};
		}
		
		public static function StringTrim(param1:String) : String
		{
			var _loc5_:String = null;
			var _loc2_:Number = 0;
			var _loc3_:Number = 0;
			var _loc4_:Number = param1.length;
			while(param1.charAt(_loc2_) == " " || param1.charAt(_loc2_) == "\n" || param1.charAt(_loc2_) == "\r" || param1.charAt(_loc2_) == "\t")
			{
				_loc2_++;
			}
			_loc5_ = param1.substring(_loc2_);
			_loc3_ = _loc5_.length - 1;
			while(_loc5_.charAt(_loc3_) == " " || _loc5_.charAt(_loc3_) == "\n" || _loc5_.charAt(_loc3_) == "\r" || _loc5_.charAt(_loc3_) == "\t")
			{
				_loc3_--;
			}
			_loc5_ = _loc5_.substring(0,_loc3_ + 1);
			return _loc5_;
		}
	}
}
