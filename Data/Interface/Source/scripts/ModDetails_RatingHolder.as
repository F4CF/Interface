package
{
   import Shared.AS3.BSUIComponent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import Shared.GlobalFunc;
   
   public class ModDetails_RatingHolder extends BSUIComponent
   {
      
      public static const MAX_RATING:uint = 5;
       
      public var StarHolder_mc:MovieClip;
      
      public var RatingCount_tf:TextField;
      
      private var _RatingVal:Number;
      
      private var _RatingCount:uint;
      
      private const STAR_SPACING:uint = 2.0;
      
      public function ModDetails_RatingHolder()
      {
         super();
         this._RatingVal = -1;
         this._RatingCount = 0;
      }
      
      public function set rating(param1:Number) : *
      {
         this._RatingVal = param1;
         SetIsDirty();
      }
      
      public function set ratingCount(param1:uint) : *
      {
         this._RatingCount = param1;
         SetIsDirty();
      }
      
      override public function redrawUIComponent() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         if(this.RatingCount_tf != null)
         {
            GlobalFunc.SetText(this.RatingCount_tf,"(" + this._RatingCount + ")",false);
         }
         while(this.StarHolder_mc.numChildren > 0)
         {
            this.StarHolder_mc.removeChildAt(0);
         }
         var _loc1_:uint = 0;
         while(this._RatingVal >= 0 && _loc1_ < MAX_RATING)
         {
            _loc3_ = this._RatingVal - _loc1_;
            if(_loc3_ <= 0.25)
            {
               _loc2_ = new Star_Empty();
            }
            else if(_loc3_ > 0.25 && _loc3_ <= 0.75)
            {
               _loc2_ = new Star_HalfFull();
            }
            else
            {
               _loc2_ = new Star_Full();
            }
            _loc2_.x = (_loc2_.width + this.STAR_SPACING) * _loc1_;
            this.StarHolder_mc.addChild(_loc2_);
            _loc1_++;
         }
      }
   }
}
