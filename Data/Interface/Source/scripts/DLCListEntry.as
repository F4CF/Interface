package
{
   import Shared.AS3.BSScrollingListEntry;
   
   public class DLCListEntry extends BSScrollingListEntry
   {
       
      public function DLCListEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         super.SetEntryText(param1,param2);
         var _loc3_:* = border.alpha;
         if(param1.disabled)
         {
            border.alpha = !!this.selected?Number(0.35):Number(0);
            textField.textColor = !!this.selected?uint(2236962):uint(4473924);
         }
         else
         {
            border.alpha = !!this.selected?Number(_loc3_):Number(0);
            textField.textColor = !!this.selected?uint(0):uint(16777215);
         }
      }
   }
}
