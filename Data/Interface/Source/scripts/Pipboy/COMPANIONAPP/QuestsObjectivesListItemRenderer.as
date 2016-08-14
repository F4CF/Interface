package Pipboy.COMPANIONAPP
{
   import flash.display.MovieClip;
   import Shared.AS3.BSScrollingListEntry;
   
   public class QuestsObjectivesListItemRenderer extends QuestsListItemRenderer
   {
       
      public var Background_mc:MovieClip;
      
      public function QuestsObjectivesListItemRenderer()
      {
         super();
      }
      
      override protected function createScrollingListEntry() : BSScrollingListEntry
      {
         return new ObjectivesListEntry();
      }
      
      override protected function setupScrollinglistEntry() : *
      {
         super.setupScrollinglistEntry();
         var _loc1_:ObjectivesListEntry = _scrollingListEntry as ObjectivesListEntry;
         _loc1_.Background_mc = this.Background_mc;
      }
   }
}
