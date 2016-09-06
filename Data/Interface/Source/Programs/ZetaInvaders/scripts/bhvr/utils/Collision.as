package bhvr.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.display.DisplayObjectContainer;
	
	public class Collision
	{
		 
		
		private var _targetCoordinateSpace:DisplayObject;
		
		private var _alphaThreshold:uint;
		
		private var _obj1Bounds:Rectangle;
		
		private var _obj2Bounds:Rectangle;
		
		private var _obj1BitmapData:BitmapData;
		
		private var _obj2BitmapData:BitmapData;
		
		private var _obj1RefPoint:Point;
		
		private var _obj2RefPoint:Point;
		
		private var _obj1Offset:Matrix;
		
		private var _obj2Offset:Matrix;
		
		public function Collision(targetCoordinateSpace:DisplayObject, alphaThresholdDetection:uint = 255)
		{
			super();
			this._targetCoordinateSpace = targetCoordinateSpace;
			this._alphaThreshold = alphaThresholdDetection;
		}
		
		public function simpleBitmapDataHitTest(obj1:DisplayObjectContainer, obj2:DisplayObjectContainer) : Boolean
		{
			if(obj1 == null || obj2 == null)
			{
				return false;
			}
			var collisionDetected:Boolean = false;
			this._obj1Bounds = obj1.getBounds(this._targetCoordinateSpace);
			this._obj1BitmapData = new BitmapData(this._obj1Bounds.width,this._obj1Bounds.height,true,0);
			this._obj1BitmapData.draw(obj1);
			this._obj2Bounds = obj1.getBounds(this._targetCoordinateSpace);
			this._obj2BitmapData = new BitmapData(this._obj2Bounds.width,this._obj2Bounds.height,true,0);
			this._obj2BitmapData.draw(obj2);
			this._obj1RefPoint = new Point(obj1.x,obj1.y);
			this._obj2RefPoint = new Point(obj2.x,obj2.y);
			collisionDetected = this._obj1BitmapData.hitTest(this._obj1RefPoint,this._alphaThreshold,this._obj2BitmapData,this._obj2RefPoint,this._alphaThreshold);
			this.reset();
			return collisionDetected;
		}
		
		public function complexBitmapDataHitTest(obj1:DisplayObjectContainer, obj2:DisplayObjectContainer) : Boolean
		{
			if(obj1 == null || obj2 == null)
			{
				return false;
			}
			var collisionDetected:Boolean = false;
			this._obj1Bounds = obj1.getBounds(this._targetCoordinateSpace);
			this._obj1Offset = obj1.transform.matrix;
			this._obj1Offset.tx = obj1.x - this._obj1Bounds.x;
			this._obj1Offset.ty = obj1.y - this._obj1Bounds.y;
			this._obj1BitmapData = new BitmapData(this._obj1Bounds.width,this._obj1Bounds.height,true,0);
			this._obj1BitmapData.draw(obj1,this._obj1Offset);
			this._obj2Bounds = obj1.getBounds(this._targetCoordinateSpace);
			this._obj2Offset = obj2.transform.matrix;
			this._obj2Offset.tx = obj2.x - this._obj2Bounds.x;
			this._obj2Offset.ty = obj2.y - this._obj2Bounds.y;
			this._obj2BitmapData = new BitmapData(this._obj2Bounds.width,this._obj2Bounds.height,true,0);
			this._obj2BitmapData.draw(obj2,this._obj2Offset);
			this._obj1RefPoint = new Point(this._obj1Bounds.x,this._obj1Bounds.y);
			this._obj2RefPoint = new Point(this._obj2Bounds.x,this._obj2Bounds.y);
			collisionDetected = this._obj1BitmapData.hitTest(this._obj1RefPoint,this._alphaThreshold,this._obj2BitmapData,this._obj2RefPoint,this._alphaThreshold);
			this.reset();
			return collisionDetected;
		}
		
		public function simpleHitTestObject(obj1:DisplayObject, obj2:DisplayObject) : Boolean
		{
			if(obj1 == null || obj2 == null)
			{
				return false;
			}
			return obj1.hitTestObject(obj2);
		}
		
		public function simpleHitTestPoint(pt:Point, obj:DisplayObject) : Boolean
		{
			if(pt == null || obj == null)
			{
				return false;
			}
			return obj.hitTestPoint(pt.x,pt.y,true);
		}
		
		private function reset() : void
		{
			this._obj1Bounds = null;
			this._obj2Bounds = null;
			if(this._obj1BitmapData)
			{
				this._obj1BitmapData.dispose();
				this._obj1BitmapData = null;
			}
			if(this._obj2BitmapData)
			{
				this._obj2BitmapData.dispose();
				this._obj2BitmapData = null;
			}
			this._obj1RefPoint = null;
			this._obj2RefPoint = null;
			this._obj1Offset = null;
			this._obj2Offset = null;
		}
		
		public function dispose() : void
		{
			this.reset();
			this._targetCoordinateSpace = null;
		}
	}
}
