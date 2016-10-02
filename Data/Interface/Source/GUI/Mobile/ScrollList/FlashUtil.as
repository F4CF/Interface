package Mobile.ScrollList
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedSuperclassName;
	import flash.display.Bitmap;
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
	}
}
