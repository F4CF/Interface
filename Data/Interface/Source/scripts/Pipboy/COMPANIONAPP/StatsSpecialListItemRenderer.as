package Pipboy.COMPANIONAPP
{
   import flash.text.TextField;
   import Shared.AS3.BSScrollingListEntry;
   
   public class StatsSpecialListItemRenderer extends PipboyListItemRenderer
   {
       
      public var Value_tf:TextField;
      
      public function StatsSpecialListItemRenderer()
      {
         super();
      }
      
      override protected function createScrollingListEntry() : BSScrollingListEntry
      {
         return new SPECIALListEntry();
      }
      
      override protected function setupScrollinglistEntry() : *
      {
         super.setupScrollinglistEntry();
         var _loc1_:SPECIALListEntry = _scrollingListEntry as SPECIALListEntry;
         _loc1_.Value_tf = this.Value_tf;
      }
   }
}
