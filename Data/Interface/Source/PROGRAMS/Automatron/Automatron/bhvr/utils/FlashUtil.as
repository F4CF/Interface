package bhvr.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedSuperclassName;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import flash.display.BitmapData;
	
	public class FlashUtil
	{
		
		private static const BITMAP_DATA_CLASS_NAME:String = getQualifiedClassName(BitmapData);
		 
		
		public function FlashUtil()
		{
			super();
		}
		
		public static function getLibraryItem(param1:MovieClip, param2:String) : DisplayObject
		{
			var _loc3_:Class = getLibraryClass(param1,param2);
			if(getQualifiedSuperclassName(_loc3_) == BITMAP_DATA_CLASS_NAME)
			{
				return new Bitmap(new _loc3_(),"auto",true);
			}
			return new _loc3_();
		}
		
		public static function getLibraryClass(param1:MovieClip, param2:String) : Class
		{
			var _loc3_:Class = param1.loaderInfo.applicationDomain.getDefinition(param2) as Class;
			return _loc3_;
		}
		
		public static function tintMovieClip(param1:MovieClip, param2:uint, param3:Number = 1.0) : void
		{
			var _loc4_:uint = 0;
			var _loc5_:ColorTransform = null;
			_loc4_ = param2;
			_loc5_ = new ColorTransform();
			_loc5_.redMultiplier = ((_loc4_ & 16711680) >> 16) / 255;
			_loc5_.greenMultiplier = ((_loc4_ & 65280) >> 8) / 255;
			_loc5_.blueMultiplier = (_loc4_ & 255) / 255;
			_loc5_.alphaMultiplier = param3;
			param1.transform.colorTransform = _loc5_;
		}
		
		public static function localToGlobalPosition(param1:DisplayObject) : Point
		{
			var _loc2_:Point = new Point(param1.x,param1.y);
			var _loc3_:Point = param1.parent.localToGlobal(_loc2_);
			return _loc3_;
		}
	}
}
