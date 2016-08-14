package
{
   import Shared.AS3.BSReversedScrollingList;
   import Shared.AS3.BSScrollingListEntry;
   
   public class InputMappingList extends BSReversedScrollingList
   {
       
      public function InputMappingList()
      {
         super();
      }
      
      override protected function GetEntryHeight(param1:Number) : Number
      {
         var _loc2_:BSScrollingListEntry = GetClipByIndex(0);
         return _loc2_.height;
      }
   }
}
