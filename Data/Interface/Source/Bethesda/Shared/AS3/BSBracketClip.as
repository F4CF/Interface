package Shared.AS3
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public dynamic class BSBracketClip extends MovieClip
	{
		
		static const BR_HORIZONTAL:String = "horizontal";
		
		static const BR_VERTICAL:String = "vertical";
		
		static const BR_CORNERS:String = "corners";
		
		static const BR_FULL:String = "full";
		 
		
		private var _drawPos:Point;
		
		private var _clipRect:Rectangle;
		
		private var _lineThickness:Number;
		
		private var _cornerLength:Number;
		
		private var _padding:Point;
		
		private var _style:String;
		
		public function BSBracketClip()
		{
			super();
		}
		
		public function BracketPair() : *
		{
		}
		
		public function ClearBrackets() : *
		{
			graphics.clear();
		}
		
		public function redrawUIComponent(param1:BSUIComponent, param2:Number, param3:Number, param4:Point, param5:String) : *
		{
			this._clipRect = param1.getBounds(param1);
			this._lineThickness = param2;
			this._cornerLength = param3;
			this._padding = param4;
			this._clipRect.inflatePoint(this._padding);
			this._style = param5;
			this.ClearBrackets();
			graphics.lineStyle(this._lineThickness,16777215,1,false,"normal",CapsStyle.SQUARE,JointStyle.MITER,3);
			switch(this._style)
			{
				case BR_HORIZONTAL:
					this.doHorizontal();
					break;
				case BR_VERTICAL:
					this.doVertical();
					break;
				case BR_CORNERS:
					this.doCorners();
					break;
				case BR_FULL:
					this.doFull();
			}
		}
		
		private function doHorizontal() : *
		{
			this._drawPos = new Point(this._clipRect.left + this._cornerLength,this._clipRect.top);
			this.moveTo();
			this.LineX(this._clipRect.left);
			this.LineY(this._clipRect.bottom);
			this.LineX(this._clipRect.left + this._cornerLength);
			this.MoveX(this._clipRect.right - this._cornerLength);
			this.LineX(this._clipRect.right);
			this.LineY(this._clipRect.top);
			this.LineX(this._clipRect.right - this._cornerLength);
		}
		
		private function doVertical() : *
		{
			this._drawPos = new Point(this._clipRect.left,this._clipRect.top + this._cornerLength);
			this.moveTo();
			this.LineY(this._clipRect.top);
			this.LineX(this._clipRect.right);
			this.LineY(this._clipRect.top + this._cornerLength);
			this.MoveY(this._clipRect.bottom - this._cornerLength);
			this.LineY(this._clipRect.bottom);
			this.LineX(this._clipRect.left);
			this.LineY(this._clipRect.bottom - this._cornerLength);
		}
		
		private function doCorners() : *
		{
			this._drawPos = new Point(this._clipRect.left + this._cornerLength,this._clipRect.top);
			this.moveTo();
			this.LineX(this._clipRect.left);
			this.LineY(this._clipRect.top + this._cornerLength);
			this.MoveY(this._clipRect.bottom - this._cornerLength);
			this.LineY(this._clipRect.bottom);
			this.LineX(this._clipRect.left + this._cornerLength);
			this.MoveX(this._clipRect.right - this._cornerLength);
			this.LineX(this._clipRect.right);
			this.LineY(this._clipRect.bottom - this._cornerLength);
			this.MoveY(this._clipRect.top + this._cornerLength);
			this.LineY(this._clipRect.top);
			this.LineX(this._clipRect.right - this._cornerLength);
		}
		
		private function doFull() : *
		{
			this._drawPos = new Point(this._clipRect.left,this._clipRect.top);
			this.moveTo();
			this.LineY(this._clipRect.bottom);
			this.LineX(this._clipRect.right);
			this.LineY(this._clipRect.top);
			this.LineX(this._clipRect.left);
		}
		
		private function LineX(param1:Number) : *
		{
			this._drawPos.x = param1;
			this.lineTo();
		}
		
		private function LineY(param1:Number) : *
		{
			this._drawPos.y = param1;
			this.lineTo();
		}
		
		private function MoveX(param1:Number) : *
		{
			this._drawPos.x = param1;
			this.moveTo();
		}
		
		private function MoveY(param1:Number) : *
		{
			this._drawPos.y = param1;
			this.moveTo();
		}
		
		private function lineTo() : *
		{
			graphics.lineTo(this._drawPos.x,this._drawPos.y);
		}
		
		private function moveTo() : *
		{
			graphics.moveTo(this._drawPos.x,this._drawPos.y);
		}
	}
}
