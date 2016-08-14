package
{
   import Shared.AS3.BSScrollingListEntry;
   import flash.text.TextField;
   import flash.display.MovieClip;
   import Shared.GlobalFunc;
   
   public class RequirementsListEntry extends BSScrollingListEntry
   {
       
      public var count:TextField;
      
      public var TaggedIcon_mc:MovieClip;
      
      const MAX_TEXT_LENGTH:uint = 18;
      
      public function RequirementsListEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc3_:* = param1.text;
         var _loc4_:String = "";
         if(param1.text.charAt(0) == "<")
         {
            _loc6_ = param1.text.indexOf(">");
            _loc7_ = param1.text.indexOf("<",_loc6_);
            _loc3_ = param1.text.substring(_loc6_ + 1,_loc7_);
            _loc4_ = param1.text.substring(0,_loc6_ + 1);
         }
         if(_loc3_.length > this.MAX_TEXT_LENGTH)
         {
            _loc3_ = _loc3_.slice(0,this.MAX_TEXT_LENGTH - 3) + "...";
         }
         var _loc5_:String = !!_loc4_.length?_loc4_ + _loc3_ + "</font>":_loc3_;
         GlobalFunc.SetText(textField,_loc5_,true);
         GlobalFunc.SetText(this.count,param1.counts,true);
         this.TaggedIcon_mc.visible = param1.taggedForSearch;
      }
   }
}
