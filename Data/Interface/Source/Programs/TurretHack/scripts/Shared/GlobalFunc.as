package Shared
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import scaleform.gfx.Extensions;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	
	public class GlobalFunc
	{
		
		public static const PIPBOY_GREY_OUT_ALPHA:Number = 0.5;
		
		public static const SELECTED_RECT_ALPHA:Number = 0.65;
		
		public static const DIMMED_ALPHA:Number = 0.65;
		
		public static const INV_MAX_NUM_BEFORE_QUANTITY_MENU:uint = 5;
		
		protected static const CLOSE_ENOUGH_EPSILON:Number = 0.001;
		
		public static const PLATFORM_PC_KB_MOUSE:uint = 0;
		
		public static const PLATFORM_PC_GAMEPAD:uint = 1;
		
		public static const PLATFORM_XB1:uint = 2;
		
		public static const PLATFORM_PS4:uint = 3;
		
		public static const INVALID_PLATFORM:uint = uint.MAX_VALUE;
		
		private static var WarningColorRed:Number = 252;
		
		private static var WarningColorGreen:Number = 128;
		
		private static var WarningColorBlue:Number = 2;
		
		private static var uiWarningColorGlow:uint = 16711680;
		
		private static var uiDefaultColor:uint = 0;
		
		private static var GlowBlurX:Number = 10;
		
		private static var GlowBlurY:Number = 10;
		
		private static var GlowStrength:Number = 1.04;
		
		private static var GlowQuality:int = 3;
		
		private static var DropShadowAlpha:Number = 5;
		
		private static var DropShadowBlurX:Number = 5;
		
		private static var DropShadowBlurY:Number = 5;
		
		private static var DropShadowStrength:Number = 0.5;
		
		private static var DropShadowAngle:Number = 0;
		
		private static var DropShadowDistance:Number = 0;
		
		private static var DropShadowColor:uint = 0;
		
		private static var DropShadowQuality:int = 3;
		
		private static var WarningDropShadowColor:uint = 0;
		 
		
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
				if(param3)
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
		
		public static function SetText(param1:TextField, param2:String, param3:Boolean, param4:Boolean = false) : *
		{
			var _loc6_:Number = NaN;
			var _loc7_:Boolean = false;
			if(!param2 || param2 == "")
			{
				param2 = " ";
			}
			if(param4)
			{
				param2 = param2.toUpperCase();
			}
			var _loc5_:TextFormat = param1.getTextFormat();
			if(param3)
			{
				_loc6_ = Number(_loc5_.letterSpacing);
				_loc7_ = _loc5_.kerning;
				param1.htmlText = param2;
				_loc5_ = param1.getTextFormat();
				_loc5_.letterSpacing = _loc6_;
				_loc5_.kerning = _loc7_;
				param1.setTextFormat(_loc5_);
			}
			else
			{
				param1.text = param2;
				param1.setTextFormat(_loc5_);
			}
		}
		
		public static function SetLockFunction() : *
		{
			MovieClip.prototype.Lock = function(param1:String, param2:Number = 0, param3:Number = 0):*
			{
				var _loc4_:Point = new Point(Extensions.visibleRect.x + param2,Extensions.visibleRect.y + param3);
				var _loc5_:Point = new Point(Extensions.visibleRect.x + Extensions.visibleRect.width - param2,Extensions.visibleRect.y + Extensions.visibleRect.height - param3);
				var _loc6_:Point = this.parent.globalToLocal(_loc4_);
				var _loc7_:Point = this.parent.globalToLocal(_loc5_);
				if(param1 == "T" || param1 == "TL" || param1 == "TR")
				{
					this.y = _loc6_.y;
				}
				if(param1 == "B" || param1 == "BL" || param1 == "BR")
				{
					this.y = _loc7_.y;
				}
				if(param1 == "L" || param1 == "TL" || param1 == "BL")
				{
					this.x = _loc6_.x;
				}
				if(param1 == "R" || param1 == "TR" || param1 == "BR")
				{
					this.x = _loc7_.x;
				}
			};
		}
		
		public static function SetWarningColor(param1:uint, param2:uint) : *
		{
			WarningColorRed = (param1 & 16711680) >> 16;
			WarningColorGreen = (param1 & 65280) >> 8;
			WarningColorBlue = param1 & 255;
			uiWarningColorGlow = param2;
		}
		
		public static function SetWarningDropShadowColor(param1:uint) : *
		{
			WarningDropShadowColor = param1;
		}
		
		public static function SetFilterInfo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:uint, param11:int, param12:int) : *
		{
			GlowBlurX = param1;
			GlowBlurY = param2;
			GlowStrength = param3;
			GlowQuality = param11;
			DropShadowAlpha = param4;
			DropShadowBlurX = param5;
			DropShadowBlurY = param6;
			DropShadowStrength = param7;
			DropShadowAngle = param8;
			DropShadowDistance = param9;
			DropShadowColor = param10;
			DropShadowQuality = param12;
		}
		
		public static function SetDefaultColor(param1:uint) : *
		{
			uiDefaultColor = param1;
		}
		
		public static function SetDisplayObjectColor(param1:DisplayObject, param2:uint, param3:Boolean = false) : *
		{
			var _loc4_:ColorTransform = null;
			if(param1.filters && param1.filters.length > 0)
			{
				param1.filters = new Array();
			}
			var _loc5_:Boolean = (param1 as Object).bWarningColor != undefined && (param1 as Object).bWarningColor || param3;
			if(_loc5_)
			{
				_loc4_ = new ColorTransform(0,0,0,1,WarningColorRed,WarningColorGreen,WarningColorBlue,0);
			}
			else
			{
				_loc4_ = new ColorTransform();
				_loc4_.color = param2 == 0?uint(uiDefaultColor):uint(param2);
			}
			param1.transform.colorTransform = _loc4_;
		}
		
		public static function SetHUDColorFunctions() : *
		{
			Object.prototype.SetHUDFilters = function(param1:Number):*
			{
				SetDisplayObjectColor(this,param1);
			};
			TextField.prototype.SetColor = function(param1:Number):*
			{
				this.textColor = param1;
			};
			MovieClip.prototype.SetColor = function(param1:Number):*
			{
				var _loc2_:* = new ColorTransform();
				_loc2_.color = param1;
				this.transform.colorTransform = _loc2_;
			};
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
