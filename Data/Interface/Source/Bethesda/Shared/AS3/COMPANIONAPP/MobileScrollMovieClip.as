package Shared.AS3.COMPANIONAPP
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MobileScrollMovieClip
	{
		 
		
		private var _scrollMovieClip:MovieClip;
		
		private var _scrollMovieClipOrigPosY:Number;
		
		private var _scrollZone:Rectangle;
		
		private var _activated:Boolean;
		
		private var _mouseDown:Boolean;
		
		private var _velocity:Number = 0;
		
		private const EPSILON:Number = 0.01;
		
		private const VELOCITY_MOVE_FACTOR:Number = 0.4;
		
		private const VELOCITY_MOUSE_DOWN_FACTOR:Number = 0.5;
		
		private const VELOCITY_MOUSE_UP_FACTOR:Number = 0.8;
		
		private const RESISTANCE_OUT_BOUNDS:Number = 0.15;
		
		private const BOUNCE_FACTOR:Number = 0.6;
		
		private var _prevMouseDownPoint:Point;
		
		public function MobileScrollMovieClip(param1:MovieClip, param2:Rectangle)
		{
			this._prevMouseDownPoint = new Point();
			super();
			this._scrollMovieClip = param1;
			this._scrollZone = param2;
			this._scrollMovieClipOrigPosY = param1.y;
			this._activated = false;
			this._mouseDown = false;
		}
		
		public function activate() : void
		{
			if(!this._activated)
			{
				this._scrollMovieClip.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler,false,0,true);
				this._scrollMovieClip.stage.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler,false,0,true);
			}
			this._activated = true;
		}
		
		public function deactivate() : void
		{
			if(this._activated)
			{
				this._scrollMovieClip.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
				this._scrollMovieClip.stage.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
			}
			this._activated = false;
		}
		
		private function mouseDownHandler(param1:MouseEvent) : void
		{
			if(!this._mouseDown)
			{
				this._prevMouseDownPoint = new Point(param1.stageX,param1.stageY);
				this._mouseDown = true;
				this._scrollMovieClip.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
				this._scrollMovieClip.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,false,0,true);
			}
		}
		
		private function mouseUpHandler(param1:MouseEvent) : void
		{
			if(this._mouseDown)
			{
				this._mouseDown = false;
				this._scrollMovieClip.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
				this._scrollMovieClip.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
			}
		}
		
		private function mouseMoveHandler(param1:MouseEvent) : void
		{
			var _loc2_:Point = null;
			var _loc3_:Number = NaN;
			if(this._mouseDown)
			{
				if(!isNaN(param1.stageX) && !isNaN(param1.stageY))
				{
					_loc2_ = new Point(param1.stageX,param1.stageY);
					_loc3_ = _loc2_.y - this._prevMouseDownPoint.y;
					if(this._scrollMovieClip.y > this._scrollMovieClipOrigPosY || this._scrollMovieClip.y < this._scrollZone.y - (this._scrollMovieClip.height - this._scrollZone.height))
					{
						this._scrollMovieClip.y = this._scrollMovieClip.y + _loc3_ * this.RESISTANCE_OUT_BOUNDS;
					}
					else
					{
						this._scrollMovieClip.y = this._scrollMovieClip.y + _loc3_;
					}
					this._velocity = this._velocity + (_loc2_.y - this._prevMouseDownPoint.y) * this.VELOCITY_MOVE_FACTOR;
					this._prevMouseDownPoint = _loc2_;
				}
				if(isNaN(_loc2_.x) || isNaN(_loc2_.y) || _loc2_.y < this._scrollZone.y || _loc2_.y > this._scrollZone.height + this._scrollZone.y || _loc2_.x < this._scrollZone.x || _loc2_.x > this._scrollZone.width + this._scrollZone.x)
				{
					this.mouseUpHandler(null);
				}
			}
		}
		
		private function enterFrameHandler(param1:Event) : void
		{
			var _loc3_:Number = NaN;
			var _loc2_:Number = !!this._mouseDown?Number(this.VELOCITY_MOUSE_DOWN_FACTOR):Number(this.VELOCITY_MOUSE_UP_FACTOR);
			this._velocity = this._velocity * _loc2_;
			if(!this._mouseDown)
			{
				_loc3_ = 0;
				if(this._scrollMovieClip.y > this._scrollMovieClipOrigPosY)
				{
					_loc3_ = (this._scrollMovieClipOrigPosY - this._scrollMovieClip.y) * this.BOUNCE_FACTOR;
				}
				else if(this._scrollMovieClip.y + this._scrollMovieClip.height < this._scrollZone.y + this._scrollZone.height)
				{
					_loc3_ = (this._scrollZone.y + this._scrollZone.height - this._scrollMovieClip.height - this._scrollMovieClip.y) * this.BOUNCE_FACTOR;
				}
				if(Math.abs(this._velocity) > this.EPSILON || _loc3_ != 0)
				{
					this._scrollMovieClip.y = this._scrollMovieClip.y + (this._velocity + _loc3_);
				}
			}
		}
	}
}
