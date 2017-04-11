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
		
		public static const MAX_TRUNCATED_TEXT_LENGTH = 42;
		
		public static const PLAY_FOCUS_SOUND:String = "GlobalFunc::playFocusSound";
		 
		
		public function GlobalFunc()
		{
			super();
		}
		
		public static function Lerp(aTargetMin:Number, aTargetMax:Number, aSourceMin:Number, aSourceMax:Number, aSource:Number, abClamp:Boolean) : Number
		{
			var fresult:Number = aTargetMin + (aSource - aSourceMin) / (aSourceMax - aSourceMin) * (aTargetMax - aTargetMin);
			if(abClamp)
			{
				if(aTargetMin < aTargetMax)
				{
					fresult = Math.min(Math.max(fresult,aTargetMin),aTargetMax);
				}
				else
				{
					fresult = Math.min(Math.max(fresult,aTargetMax),aTargetMin);
				}
			}
			return fresult;
		}
		
		public static function RoundDecimal(aNumber:Number, aPrecision:Number) : Number
		{
			var decimal:Number = Math.pow(10,aPrecision);
			return Math.round(decimal * aNumber) / decimal;
		}
		
		public static function CloseToNumber(aNumber1:Number, aNumber2:Number) : Boolean
		{
			return Math.abs(aNumber1 - aNumber2) < CLOSE_ENOUGH_EPSILON;
		}
		
		public static function MaintainTextFormat() : *
		{
			TextField.prototype.SetText = function(aText:String, abHTMLText:Boolean, aUpperCase:Boolean = false):*
			{
				var oldSpacing:Number = NaN;
				var oldKerning:Boolean = false;
				if(!aText || aText == "")
				{
					aText = " ";
				}
				if(aUpperCase && aText.charAt(0) != "$")
				{
					aText = aText.toUpperCase();
				}
				var format:TextFormat = this.getTextFormat();
				if(abHTMLText)
				{
					oldSpacing = Number(format.letterSpacing);
					oldKerning = format.kerning;
					this.htmlText = aText;
					format = this.getTextFormat();
					format.letterSpacing = oldSpacing;
					format.kerning = oldKerning;
					this.setTextFormat(format);
					this.htmlText = aText;
				}
				else
				{
					this.text = aText;
					this.setTextFormat(format);
					this.text = aText;
				}
			};
		}
		
		public static function SetText(aTextField:TextField, aText:String, abHTMLText:Boolean, abUpperCase:Boolean = false, abTruncate:* = false) : *
		{
			var format:TextFormat = null;
			var oldSpacing:Number = NaN;
			var oldKerning:Boolean = false;
			if(!aText || aText == "")
			{
				aText = " ";
			}
			if(abUpperCase && aText.charAt(0) != "$")
			{
				aText = aText.toUpperCase();
			}
			if(abHTMLText)
			{
				format = aTextField.getTextFormat();
				oldSpacing = Number(format.letterSpacing);
				oldKerning = format.kerning;
				aTextField.htmlText = aText;
				format = aTextField.getTextFormat();
				format.letterSpacing = oldSpacing;
				format.kerning = oldKerning;
				aTextField.setTextFormat(format);
			}
			else
			{
				aTextField.text = aText;
			}
			if(abTruncate && aTextField.text.length > MAX_TRUNCATED_TEXT_LENGTH)
			{
				aTextField.text = aTextField.text.slice(0,MAX_TRUNCATED_TEXT_LENGTH - 3) + "...";
			}
		}
		
		public static function LockToSafeRect(aDisplayObject:DisplayObject, aPosition:String, aSafeX:Number = 0, aSafeY:Number = 0) : *
		{
			var visibleRect:Rectangle = Extensions.visibleRect;
			var topLeft_Global:Point = new Point(visibleRect.x + aSafeX,visibleRect.y + aSafeY);
			var bottomRight_Global:Point = new Point(visibleRect.x + visibleRect.width - aSafeX,visibleRect.y + visibleRect.height - aSafeY);
			var topLeft:Point = aDisplayObject.parent.globalToLocal(topLeft_Global);
			var bottomRight:Point = aDisplayObject.parent.globalToLocal(bottomRight_Global);
			var centerPoint:Point = Point.interpolate(topLeft,bottomRight,0.5);
			if(aPosition == "T" || aPosition == "TL" || aPosition == "TR" || aPosition == "TC")
			{
				aDisplayObject.y = topLeft.y;
			}
			if(aPosition == "CR" || aPosition == "CC" || aPosition == "CL")
			{
				aDisplayObject.y = centerPoint.y;
			}
			if(aPosition == "B" || aPosition == "BL" || aPosition == "BR" || aPosition == "BC")
			{
				aDisplayObject.y = bottomRight.y;
			}
			if(aPosition == "L" || aPosition == "TL" || aPosition == "BL" || aPosition == "CL")
			{
				aDisplayObject.x = topLeft.x;
			}
			if(aPosition == "TC" || aPosition == "CC" || aPosition == "BC")
			{
				aDisplayObject.x = centerPoint.x;
			}
			if(aPosition == "R" || aPosition == "TR" || aPosition == "BR" || aPosition == "CR")
			{
				aDisplayObject.x = bottomRight.x;
			}
		}
		
		public static function AddMovieExploreFunctions() : *
		{
			MovieClip.prototype.getMovieClips = function():Array
			{
				var i:* = undefined;
				var movieClips:* = new Array();
				for(i in this)
				{
					if(this[i] is MovieClip && this[i] != this)
					{
						movieClips.push(this[i]);
					}
				}
				return movieClips;
			};
			MovieClip.prototype.showMovieClips = function():*
			{
				var i:* = undefined;
				for(i in this)
				{
					if(this[i] is MovieClip && this[i] != this)
					{
						trace(this[i]);
						this[i].showMovieClips();
					}
				}
			};
		}
		
		public static function AddReverseFunctions() : *
		{
			MovieClip.prototype.PlayReverseCallback = function(event:Event):*
			{
				if(event.currentTarget.currentFrame > 1)
				{
					event.currentTarget.gotoAndStop(event.currentTarget.currentFrame - 1);
				}
				else
				{
					event.currentTarget.removeEventListener(Event.ENTER_FRAME,event.currentTarget.PlayReverseCallback);
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
			MovieClip.prototype.PlayForward = function(aFrameLabel:String):*
			{
				delete this.onEnterFrame;
				this.gotoAndPlay(aFrameLabel);
			};
			MovieClip.prototype.PlayForward = function(aFrame:Number):*
			{
				delete this.onEnterFrame;
				this.gotoAndPlay(aFrame);
			};
		}
		
		public static function StringTrim(astrText:String) : String
		{
			var strResult:String = null;
			var startIndex:Number = 0;
			var endIndex:Number = 0;
			var strLength:Number = astrText.length;
			while(astrText.charAt(startIndex) == " " || astrText.charAt(startIndex) == "\n" || astrText.charAt(startIndex) == "\r" || astrText.charAt(startIndex) == "\t")
			{
				startIndex++;
			}
			strResult = astrText.substring(startIndex);
			endIndex = strResult.length - 1;
			while(strResult.charAt(endIndex) == " " || strResult.charAt(endIndex) == "\n" || strResult.charAt(endIndex) == "\r" || strResult.charAt(endIndex) == "\t")
			{
				endIndex--;
			}
			strResult = strResult.substring(0,endIndex + 1);
			return strResult;
		}
	}
}
