package
{
   import Shared.AS3.BSScrollingListEntry;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   import Shared.GlobalFunc;
   
   public class SaveLoadListEntry extends BSScrollingListEntry
   {
      
      public static const MaxLocationNameLength = 30;
       
      public var Location_tf:TextField;
      
      public var PlayTime_tf:TextField;
      
      private var DefaultLocationWidth;
      
      public function SaveLoadListEntry()
      {
         super();
         this.DefaultLocationWidth = this.Location_tf.width;
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc3_:* = param1.text;
         if(_loc3_ != undefined && _loc3_.length > SaveLoadListEntry.MaxLocationNameLength)
         {
            _loc3_ = _loc3_.substr(0,SaveLoadListEntry.MaxLocationNameLength - 3) + "...";
         }
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Location_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         GlobalFunc.SetText(this.Location_tf,_loc3_,false,false,false);
         if(param1.playTime)
         {
            _loc4_ = param1.playTime.split(".");
            if(_loc4_.length == 6)
            {
               _loc5_ = _loc4_[0];
               _loc6_ = "";
               if(_loc5_.charAt(0) != "0")
               {
                  _loc6_ = _loc6_ + (_loc4_[0] + " ");
               }
               _loc6_ = _loc6_ + (_loc4_[1] + " " + _loc4_[2]);
               GlobalFunc.SetText(this.PlayTime_tf,_loc6_,false);
            }
            else
            {
               GlobalFunc.SetText(this.PlayTime_tf,"-d -h -m",false);
            }
            this.Location_tf.width = this.DefaultLocationWidth;
         }
         else
         {
            GlobalFunc.SetText(this.PlayTime_tf,"",false);
            this.Location_tf.width = this.DefaultLocationWidth + this.PlayTime_tf.width;
         }
         border.alpha = !!this.selected?Number(GlobalFunc.SELECTED_RECT_ALPHA):Number(0);
         this.Location_tf.textColor = !!this.selected?uint(0):uint(16777215);
         this.PlayTime_tf.textColor = !!this.selected?uint(0):uint(16777215);
      }
   }
}
