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
		
		public static function getLibraryItem(mc:MovieClip, className:String) : DisplayObject
		{
			var classRef:Class = getLibraryClass(mc,className);
			if(getQualifiedSuperclassName(classRef) == BITMAP_DATA_CLASS_NAME)
			{
				return new Bitmap(new classRef(),"auto",true);
			}
			return new classRef();
		}
		
		public static function getLibraryClass(mc:MovieClip, className:String) : Class
		{
			var classRef:Class = mc.loaderInfo.applicationDomain.getDefinition(className) as Class;
			return classRef;
		}
		
		public static function tintMovieClip(target:MovieClip, color:uint) : void
		{
			var colorCode:uint = 0;
			var aColor:ColorTransform = null;
			colorCode = color;
			aColor = new ColorTransform();
			aColor.redMultiplier = ((colorCode & 16711680) >> 16) / 255;
			aColor.greenMultiplier = ((colorCode & 65280) >> 8) / 255;
			aColor.blueMultiplier = (colorCode & 255) / 255;
			aColor.alphaMultiplier = 1;
			target.transform.colorTransform = aColor;
		}
		
		public static function setColorTransformation(target:MovieClip, redOffset:Number, greenOffset:Number, blueOffset:Number) : void
		{
			var color:ColorTransform = new ColorTransform();
			color.redOffset = redOffset;
			color.greenOffset = greenOffset;
			color.blueOffset = blueOffset;
			target.transform.colorTransform = color;
		}
		
		public static function localToGlobalPosition(obj:DisplayObject) : Point
		{
			var localPos:Point = new Point(obj.x,obj.y);
			var globalPos:Point = obj.parent.localToGlobal(localPos);
			return globalPos;
		}
	}
}
