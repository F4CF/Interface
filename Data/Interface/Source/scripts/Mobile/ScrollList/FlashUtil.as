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
   }
}
