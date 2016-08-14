package
{
   import Shared.IMenu;
   import flash.display.MovieClip;
   import Shared.AS3.BSButtonHintBar;
   import Shared.AS3.BSButtonHintData;
   import Shared.GlobalFunc;
   import scaleform.gfx.TextFieldEx;
   import flash.text.TextFormat;
   import scaleform.gfx.Extensions;
   
   public class Workshop extends IMenu
   {
       
      public var ItemNameBase_mc:MovieClip;
      
      public var RequirementsBase_mc:MovieClip;
      
      public var IconCardBase_mc:MovieClip;
      
      public var LoadingIconsBase_mc:MovieClip;
      
      public var BuiltItemCountText_mc:MovieClip;
      
      public var SelectionBracket_mc:MovieClip;
      
      public var HappinessPeopleBase_mc:MovieClip;
      
      public var HappinessFoodBase_mc:MovieClip;
      
      public var HappinessWaterBase_mc:MovieClip;
      
      public var HappinessPowerBase_mc:MovieClip;
      
      public var HappinessSafetyBase_mc:MovieClip;
      
      public var HappinessBedsBase_mc:MovieClip;
      
      public var HappinessHappyBase_mc:MovieClip;
      
      public var HappinessSizeBase_mc:MovieClip;
      
      public var HappyBarBackground1_mc:MovieClip;
      
      public var HappyBarBackground2_mc:MovieClip;
      
      public var HappyBarBackground3_mc:MovieClip;
      
      public var HappyBarBackground4_mc:MovieClip;
      
      public var HappyBarBackground5_mc:MovieClip;
      
      public var HappyBarBackground6_mc:MovieClip;
      
      public var HappyBarBackground7_mc:MovieClip;
      
      public var HappyBarBackground8_mc:MovieClip;
      
      public var HappinessBarBrackets_mc:MovieClip;
      
      public var ButtonBackground_mc:BSButtonHintBar;
      
      public var RowBrackets_mc:MovieClip;
      
      public var DisplayPathBase_mc:MovieClip;
      
      public var PerkPanel0_mc:MovieClip;
      
      public var PerkPanel1_mc:MovieClip;
      
      public var DescriptionBase_mc:MovieClip;
      
      public var IconBackground_mc:MovieClip;
      
      public var NewRecipeIcon_mc:MovieClip;
      
      private var _buttonHintDataV:Vector.<BSButtonHintData>;
      
      private var Language:String = "en";
      
      private var AButtonData:BSButtonHintData;
      
      private var BButtonData:BSButtonHintData;
      
      private var XButtonData:BSButtonHintData;
      
      private var YButtonData:BSButtonHintData;
      
      private var RBButtonData:BSButtonHintData;
      
      private var ExitButtonData:BSButtonHintData;
      
      public var LoadingIcons:Array;
      
      public var ListInfoA:Array;
      
      public const CATEGORIES:uint = 0;
      
      public const GROUPS:uint = 1;
      
      public const ITEMS:uint = 2;
      
      protected var Filter:uint = 0;
      
      public function Workshop()
      {
         this.AButtonData = new BSButtonHintData("$Place","Enter","PSN_A","Xenon_A",1,null);
         this.BButtonData = new BSButtonHintData("$CANCEL","Tab","PSN_B","Xenon_B",1,null);
         this.XButtonData = new BSButtonHintData("$Delete","R","PSN_X","Xenon_X",1,null);
         this.YButtonData = new BSButtonHintData("$ATTACH WIRE","Space","PSN_Y","Xenon_Y",1,null);
         this.RBButtonData = new BSButtonHintData("$WNPC_Caravan","Q","PSN_R1","Xenon_R1",1,null);
         this.ExitButtonData = new BSButtonHintData("$EXIT","ESC","PSN_Select","Xenon_Select",1,null);
         this.LoadingIcons = new Array();
         this.ListInfoA = [{"position":"Right"},{"position":"Right"},{"position":"Right"}];
         super();
         this.requirements = [];
         this.HideRequirements();
         this.filter = 2;
         this.peopleCount = 0;
         this.foodCount = 0;
         this.waterCount = 0;
         this.powerCount = 0;
         this.safetyCount = 0;
         this.bedsCount = 0;
         this.happyCount = 0;
         this.happyTarget = 0;
         this._buttonHintDataV = new Vector.<BSButtonHintData>();
         this._buttonHintDataV.push(this.AButtonData);
         this._buttonHintDataV.push(this.BButtonData);
         this._buttonHintDataV.push(this.XButtonData);
         this._buttonHintDataV.push(this.YButtonData);
         this._buttonHintDataV.push(this.RBButtonData);
         this._buttonHintDataV.push(this.ExitButtonData);
         this.ButtonBackground_mc.SetButtonHintData(this._buttonHintDataV);
         this.descriptionText = "";
         Extensions.enabled = true;
         ShrinkFontToFit(this.HappinessSizeBase_mc.textField,1);
         TextFieldEx.setTextAutoSize(this.PerkPanel0_mc.PerkName_tf,"shrink");
         TextFieldEx.setTextAutoSize(this.PerkPanel1_mc.PerkName_tf,"shrink");
         GlobalFunc.SetText(this.HappinessHappyBase_mc.HappyLabel_tf,"$HAPPINESS",false);
         ShrinkFontToFit(this.HappinessPeopleBase_mc.PeopleLabel_tf,1);
         ShrinkFontToFit(this.HappinessFoodBase_mc.FoodLabel_tf,1);
         ShrinkFontToFit(this.HappinessWaterBase_mc.WaterLabel_tf,1);
         ShrinkFontToFit(this.HappinessPowerBase_mc.PowerLabel_tf,1);
         ShrinkFontToFit(this.HappinessSafetyBase_mc.SafetyLabel_tf,1);
         ShrinkFontToFit(this.HappinessBedsBase_mc.BedsLabel_tf,1);
         ShrinkFontToFit(this.HappinessHappyBase_mc.HappyLabel_tf,1);
         this.happinessBarVisible = false;
         this.__setProp_DescriptionBase_mc_WorkshopBase_Description_0();
      }
      
      public function set peopleCount(param1:uint) : *
      {
         param1 = Math.min(Math.max(0,param1),999);
         GlobalFunc.SetText(this.HappinessPeopleBase_mc.PeopleValue_tf,param1.toString(),false);
         ShrinkFontToFit(this.HappinessPeopleBase_mc.PeopleValue_tf,1);
      }
      
      public function set foodCount(param1:Number) : *
      {
         param1 = Math.min(Math.max(0,param1),999);
         GlobalFunc.SetText(this.HappinessFoodBase_mc.FoodValue_tf,param1.toString(),false);
         ShrinkFontToFit(this.HappinessFoodBase_mc.FoodValue_tf,1);
      }
      
      public function set waterCount(param1:uint) : *
      {
         param1 = Math.min(Math.max(0,param1),999);
         GlobalFunc.SetText(this.HappinessWaterBase_mc.WaterValue_tf,param1.toString(),false);
         ShrinkFontToFit(this.HappinessWaterBase_mc.WaterValue_tf,1);
      }
      
      public function set powerCount(param1:uint) : *
      {
         param1 = Math.min(Math.max(0,param1),999);
         GlobalFunc.SetText(this.HappinessPowerBase_mc.PowerValue_tf,param1.toString(),false);
         ShrinkFontToFit(this.HappinessPowerBase_mc.PowerValue_tf,1);
      }
      
      public function set safetyCount(param1:uint) : *
      {
         param1 = Math.min(Math.max(0,param1),999);
         GlobalFunc.SetText(this.HappinessSafetyBase_mc.SafetyValue_tf,param1.toString(),false);
         ShrinkFontToFit(this.HappinessSafetyBase_mc.SafetyValue_tf,1);
      }
      
      public function set bedsCount(param1:uint) : *
      {
         param1 = Math.min(Math.max(0,param1),999);
         GlobalFunc.SetText(this.HappinessBedsBase_mc.BedsValue_tf,param1.toString(),false);
         ShrinkFontToFit(this.HappinessBedsBase_mc.BedsValue_tf,1);
      }
      
      public function set happyCount(param1:uint) : *
      {
         param1 = Math.min(Math.max(0,param1),999);
         GlobalFunc.SetText(this.HappinessHappyBase_mc.HappyValue_tf,param1.toString(),false);
         ShrinkFontToFit(this.HappinessHappyBase_mc.HappyValue_tf,1);
      }
      
      public function set happyTarget(param1:int) : *
      {
         if(param1 == 0)
         {
            this.HappinessHappyBase_mc.HappyArrow_mc.visible = false;
         }
         else
         {
            this.HappinessHappyBase_mc.HappyArrow_mc.visible = true;
            this.HappinessHappyBase_mc.HappyArrow_mc.gotoAndStop(param1 > 0?1:2);
         }
      }
      
      public function set happinessBarVisible(param1:Boolean) : *
      {
         this.HappinessPeopleBase_mc.visible = this.HappinessFoodBase_mc.visible = this.HappinessWaterBase_mc.visible = this.HappinessPowerBase_mc.visible = this.HappinessSafetyBase_mc.visible = this.HappinessBedsBase_mc.visible = this.HappinessHappyBase_mc.visible = this.HappinessSizeBase_mc.visible = this.HappyBarBackground1_mc.visible = this.HappyBarBackground2_mc.visible = this.HappyBarBackground3_mc.visible = this.HappyBarBackground4_mc.visible = this.HappyBarBackground5_mc.visible = this.HappyBarBackground6_mc.visible = this.HappyBarBackground7_mc.visible = this.HappyBarBackground8_mc.visible = this.HappinessBarBrackets_mc.visible = param1;
      }
      
      public function SetValidDirections(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean) : *
      {
         this.SelectionBracket_mc.Left_mc.gotoAndStop(!!param1?"On":"Off");
         this.SelectionBracket_mc.Right_mc.gotoAndStop(!!param2?"On":"Off");
         this.SelectionBracket_mc.Up_mc.gotoAndStop(!!param3?"On":"Off");
         this.SelectionBracket_mc.Down_mc.gotoAndStop(!!param4?"On":"Off");
      }
      
      public function set requirementsText(param1:String) : *
      {
         GlobalFunc.SetText(this.RequirementsBase_mc.TopListText_tf,param1,false);
      }
      
      public function set descriptionText(param1:String) : *
      {
         if(param1.length == 0)
         {
            this.DescriptionBase_mc.visible = false;
         }
         else
         {
            this.DescriptionBase_mc.visible = true;
            GlobalFunc.SetText(this.DescriptionBase_mc.Description_tf,param1,false);
            ShrinkFontToFit(this.DescriptionBase_mc.Description_tf,2);
         }
      }
      
      public function set language(param1:String) : *
      {
         this.Language = param1.toLowerCase();
      }
      
      public function set displayName(param1:String) : *
      {
         GlobalFunc.SetText(this.ItemNameBase_mc.ItemName_tf,param1,false,true);
         TextFieldEx.setTextAutoSize(this.ItemNameBase_mc.ItemName_tf,"shrink");
      }
      
      public function set displayPath(param1:String) : *
      {
         GlobalFunc.SetText(this.DisplayPathBase_mc.DisplayPath_tf,param1.split(";").join(" >  "),true,true);
      }
      
      public function get requirements() : Array
      {
         return this.RequirementsBase_mc.RequirementsList_mc.entryList;
      }
      
      public function set requirements(param1:Array) : *
      {
         this.ShowRequirements();
         this.RequirementsBase_mc.RequirementsList_mc.entryList = param1;
         this.RequirementsBase_mc.RequirementsList_mc.InvalidateData();
         this.RequirementsBase_mc.RequirementsListBackground_mc.LowerRequirementsBracket_mc.y = this.RequirementsBase_mc.RequirementsList_mc.y + this.RequirementsBase_mc.RequirementsList_mc.shownItemsHeight;
      }
      
      public function ShowRequirements() : *
      {
         this.HideIconCard();
         this.RequirementsBase_mc.visible = true;
         this.RequirementsBase_mc.RequirementsListBackground_mc.visible = true;
      }
      
      public function HideRequirements() : *
      {
         this.RequirementsBase_mc.visible = false;
         this.RequirementsBase_mc.RequirementsListBackground_mc.visible = false;
      }
      
      public function set showIconCard(param1:Object) : *
      {
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         this.IconCardBase_mc.IconBackgroundClip_mc.visible = true;
         this.IconCardBase_mc.visible = true;
         if(param1.assignedTo == undefined)
         {
            _loc7_ = !!param1.requiresWorker?uint(1):uint(0);
            _loc7_ = _loc7_ + (param1.powerRequired > 0 || Boolean(param1.bpowerRequired)?1:0);
            _loc8_ = param1.powerRequired > 0?param1.powerRequired.toString():"";
            switch(_loc7_)
            {
               case 2:
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon1_mc.visible = true;
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon1_mc.x = 41.05;
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon2_mc.visible = true;
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon1_mc.gotoAndStop("Power");
                  GlobalFunc.SetText(this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon1_mc.ResourceCount_tf,_loc8_,false);
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon2_mc.gotoAndStop("People");
                  GlobalFunc.SetText(this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon2_mc.ResourceCount_tf,"",false);
                  break;
               case 1:
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon1_mc.visible = true;
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon1_mc.x = 87.05;
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon2_mc.visible = false;
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon1_mc.gotoAndStop(param1.powerRequired > 0 || Boolean(param1.bpowerRequired)?param1.powerRequired > 0?"Power":"PowerCentered":"People");
                  GlobalFunc.SetText(this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon1_mc.ResourceCount_tf,param1.powerRequired > 0 || Boolean(param1.bpowerRequired)?_loc8_:"",false);
                  break;
               case 0:
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon1_mc.visible = false;
                  this.IconCardBase_mc.RequirementIcons_mc.RequiresIcon2_mc.visible = false;
            }
            this.IconCardBase_mc.IconBackgroundClip_mc.RequiresText_tf.visible = _loc7_ != 0;
            this.IconCardBase_mc.IconBackgroundClip_mc.RequiresText_tf.y = _loc7_ != 0?6:72;
            this.IconCardBase_mc.IconBackgroundClip_mc.IconCardUpperBracket_mc.y = _loc7_ == 0?65:0;
            this.IconCardBase_mc.IconBackgroundClip_mc.AssignedText_tf.visible = false;
            this.IconCardBase_mc.IconBackgroundClip_mc.AssignedText_tf.y = _loc7_ != 0?6:72;
            this.IconCardBase_mc.RequirementIcons_mc.visible = true;
            this.IconCardBase_mc.AssignmentIcon_mc.visible = false;
         }
         else
         {
            this.IconCardBase_mc.AssignmentIcon_mc.gotoAndStop(param1.assignedTo);
            this.IconCardBase_mc.IconBackgroundClip_mc.RequiresText_tf.visible = false;
            this.IconCardBase_mc.IconBackgroundClip_mc.RequiresText_tf.y = 0;
            this.IconCardBase_mc.RequirementIcons_mc.visible = false;
            this.IconCardBase_mc.IconBackgroundClip_mc.AssignedText_tf.visible = true;
            this.IconCardBase_mc.AssignmentIcon_mc.visible = true;
            GlobalFunc.SetText(this.IconCardBase_mc.IconBackgroundClip_mc.AssignedText_tf,param1.assignedTo == "Unassigned"?"$UNASSIGNED":"$ASSIGNED TO",true);
            this.IconCardBase_mc.IconBackgroundClip_mc.IconCardUpperBracket_mc.y = 0;
            this.IconCardBase_mc.IconBackgroundClip_mc.AssignedText_tf.y = 6;
         }
         var _loc2_:Array = [{
            "val":param1.safetyCount,
            "frame":"Safety"
         },{
            "val":param1.powerGenerated,
            "frame":"Power"
         },{
            "val":param1.waterCount,
            "frame":"Water"
         },{
            "val":param1.foodCount,
            "frame":"Food"
         },{
            "val":param1.happyCount,
            "frame":"Happy"
         }];
         var _loc3_:uint = 0;
         var _loc4_:uint = uint.MAX_VALUE;
         var _loc5_:uint = uint.MAX_VALUE;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc2_.length)
         {
            if(_loc2_[_loc6_].val > 0 || _loc6_ == _loc3_ && param1.showSafetyWarning == true)
            {
               if(_loc4_ == uint.MAX_VALUE)
               {
                  _loc4_ = _loc6_;
               }
               else if(_loc5_ == uint.MAX_VALUE)
               {
                  _loc5_ = _loc6_;
               }
            }
            _loc6_++;
         }
         if(_loc5_ != uint.MAX_VALUE)
         {
            this.IconCardBase_mc.ProducesIcons_mc.gotoAndStop(3);
            this.IconCardBase_mc.ProducesIcons_mc.ProducesIcon1_mc.gotoAndStop(_loc2_[_loc4_].frame);
            GlobalFunc.SetText(this.IconCardBase_mc.ProducesIcons_mc.ProducesIcon1_mc.ResourceCount_tf,_loc2_[_loc4_].val.toString(),false);
            this.IconCardBase_mc.ProducesIcons_mc.ProducesIcon1_mc.ResourceCount_tf.visible = _loc4_ != 4;
            this.IconCardBase_mc.ProducesIcons_mc.ProducesIcon2_mc.gotoAndStop(_loc2_[_loc5_].frame);
            GlobalFunc.SetText(this.IconCardBase_mc.ProducesIcons_mc.ProducesIcon2_mc.ResourceCount_tf,_loc2_[_loc5_].val.toString(),false);
            this.IconCardBase_mc.ProducesIcons_mc.ProducesIcon2_mc.ResourceCount_tf.visible = _loc5_ != 4;
         }
         else if(_loc4_ != uint.MAX_VALUE)
         {
            this.IconCardBase_mc.ProducesIcons_mc.gotoAndStop(2);
            this.IconCardBase_mc.ProducesIcons_mc.ProducesIcon1_mc.gotoAndStop(_loc2_[_loc4_].frame);
            GlobalFunc.SetText(this.IconCardBase_mc.ProducesIcons_mc.ProducesIcon1_mc.ResourceCount_tf,_loc2_[_loc4_].val.toString(),false);
            this.IconCardBase_mc.ProducesIcons_mc.ProducesIcon1_mc.ResourceCount_tf.visible = _loc4_ != 4;
         }
         else
         {
            this.IconCardBase_mc.ProducesIcons_mc.gotoAndStop(1);
         }
         if(_loc5_ == uint.MAX_VALUE && _loc4_ == uint.MAX_VALUE)
         {
            this.IconCardBase_mc.IconBackgroundClip_mc.LowerRequirementsBracket_mc.y = 70;
            this.IconCardBase_mc.IconBackgroundClip_mc.ProducesText_tf.y = 50;
            this.IconCardBase_mc.IconBackgroundClip_mc.ProducesText_tf.visible = false;
         }
         else
         {
            this.IconCardBase_mc.IconBackgroundClip_mc.ProducesText_tf.y = 70;
            this.IconCardBase_mc.IconBackgroundClip_mc.ProducesText_tf.visible = true;
            this.IconCardBase_mc.IconBackgroundClip_mc.LowerRequirementsBracket_mc.y = 130;
         }
      }
      
      public function HideIconCard() : *
      {
         this.IconCardBase_mc.visible = false;
         this.IconCardBase_mc.IconBackgroundClip_mc.visible = false;
      }
      
      public function HidePerkPanels() : *
      {
         this.PerkPanel0_mc.visible = false;
         this.PerkPanel1_mc.visible = false;
      }
      
      public function set perkData(param1:Array) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TextFormat = null;
         if(param1.length == 0)
         {
            this.HidePerkPanels();
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               _loc3_ = getChildByName("PerkPanel" + _loc2_ + "_mc") as MovieClip;
               if(_loc2_ < param1.length)
               {
                  _loc3_.visible = true;
                  if(this.Language == "ru" || this.Language == "pl")
                  {
                     _loc4_ = _loc3_.Requires_tf.getTextFormat();
                     _loc4_.font = "$MAIN_Font_Bold";
                     GlobalFunc.SetText(_loc3_.Requires_tf,"$Req:",false);
                     GlobalFunc.SetText(_loc3_.Requires_tf,!!param1[_loc2_].perkRank?_loc3_.Requires_tf.text + " " + param1[_loc2_].perkRank.toString():"",false);
                     _loc3_.Requires_tf.setTextFormat(_loc4_);
                  }
                  else
                  {
                     GlobalFunc.SetText(_loc3_.Requires_tf,"$Req:",false);
                     GlobalFunc.SetText(_loc3_.Requires_tf,!!param1[_loc2_].perkRank?_loc3_.Requires_tf.text + " " + param1[_loc2_].perkRank.toString():"",false);
                  }
                  _loc3_.PerkLock_mc.visible = param1[_loc2_].perkLocked;
                  if(param1[_loc2_].perkName != _loc3_.PerkName_tf.text)
                  {
                     if(this.Language == "ru" || this.Language == "pl")
                     {
                        _loc4_ = _loc3_.PerkName_tf.getTextFormat();
                        _loc4_.font = "$MAIN_Font_Bold";
                        _loc3_.PerkName_tf.setTextFormat(_loc4_);
                        GlobalFunc.SetText(_loc3_.PerkName_tf,param1[_loc2_].perkName,false);
                        _loc3_.PerkName_tf.setTextFormat(_loc4_);
                     }
                     else
                     {
                        GlobalFunc.SetText(_loc3_.PerkName_tf,param1[_loc2_].perkName,false);
                     }
                     _loc3_.PerkLoaderClip_mc.clipScale = 0.29;
                     _loc3_.PerkLoaderClip_mc.clipAlpha = 1;
                     if(Boolean(param1[_loc2_].swfName) && param1[_loc2_].swfName.length > 0)
                     {
                        _loc3_.PerkLoaderClip_mc.SWFLoad(param1[_loc2_].swfName.slice(0,param1[_loc2_].swfName.indexOf(".swf")));
                     }
                     else
                     {
                        _loc3_.PerkLoaderClip_mc.SWFLoadAlt("Components/Vaultboys/Perks/WorkshopPerkClip_" + param1[_loc2_].perkID.toString(16),"Components/Vaultboys/Perks/PerkClip_" + param1[_loc2_].perkID.toString(16));
                     }
                  }
               }
               else
               {
                  _loc3_.visible = false;
               }
               _loc2_++;
            }
         }
      }
      
      public function PositionItemCardInformation() : *
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc1_:Boolean = this.RequirementsBase_mc.visible;
         var _loc2_:Boolean = this.IconCardBase_mc.visible;
         var _loc3_:Boolean = this.PerkPanel0_mc.visible;
         var _loc4_:uint = 160;
         if(_loc1_)
         {
            this.RequirementsBase_mc.y = _loc4_;
            _loc4_ = this.RequirementsBase_mc.y + this.RequirementsBase_mc.RequirementsListBackground_mc.y + this.RequirementsBase_mc.RequirementsListBackground_mc.LowerRequirementsBracket_mc.y + 10;
         }
         if(_loc2_)
         {
            _loc5_ = this.IconCardBase_mc.IconBackgroundClip_mc.IconCardUpperBracket_mc.y + this.IconCardBase_mc.IconBackgroundClip_mc.y;
            this.IconCardBase_mc.y = _loc4_ - _loc5_;
            _loc4_ = this.IconCardBase_mc.y + this.IconCardBase_mc.IconBackgroundClip_mc.y + this.IconCardBase_mc.IconBackgroundClip_mc.LowerRequirementsBracket_mc.y + 10;
         }
         if(_loc3_)
         {
            _loc6_ = 1050;
            _loc4_ = 165;
            this.PerkPanel0_mc.y = _loc4_;
            this.PerkPanel0_mc.x = _loc6_;
            _loc4_ = _loc4_ + this.PerkPanel0_mc.height;
            if(this.PerkPanel1_mc.visible)
            {
               if(_loc4_ > 373)
               {
                  _loc4_ = 160;
               }
               this.PerkPanel1_mc.y = _loc4_ + 2;
               this.PerkPanel1_mc.x = _loc6_;
            }
         }
      }
      
      public function set size(param1:Number) : *
      {
         this.HappinessSizeBase_mc.SizeMeter_mc.SetMeter(param1,0,1.005);
      }
      
      public function SetItemCount(param1:uint) : *
      {
         GlobalFunc.SetText(this.BuiltItemCountText_mc.ItemCount_tf,param1 > 0?param1.toString():"",false);
      }
      
      public function SetItemIsNew(param1:uint) : *
      {
         if(param1 == 0)
         {
            this.NewRecipeIcon_mc.alpha = 0;
         }
         else
         {
            this.NewRecipeIcon_mc.alpha = 1;
            switch(param1)
            {
               case 1:
               case 2:
               case 3:
               case 4:
               case 5:
               case 6:
                  this.NewRecipeIcon_mc.gotoAndStop(param1);
                  break;
               case uint.MAX_VALUE - 1:
                  this.NewRecipeIcon_mc.gotoAndStop(7);
                  break;
               default:
                  this.NewRecipeIcon_mc.gotoAndStop(8);
            }
         }
      }
      
      public function set filter(param1:uint) : *
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 5)
         {
            if(param1 == _loc2_)
            {
               this.ListInfoA[param1].position = "Right";
            }
            _loc2_++;
         }
         this.Filter = param1;
      }
      
      public function Animate(param1:Boolean) : *
      {
         this.ListInfoA[this.Filter].position = !!param1?"Left":"Right";
      }
      
      public function SetButtonText(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean, param11:Boolean, param12:Boolean, param13:Boolean, param14:Boolean, param15:Boolean, param16:Boolean, param17:Boolean, param18:Boolean, param19:Boolean, param20:Boolean, param21:Boolean, param22:Boolean, param23:uint) : *
      {
         this.RBButtonData.ButtonVisible = false;
         this.YButtonData.ButtonVisible = false;
         if(param14)
         {
            this.AButtonData.ButtonText = !!param15?"$Assign":"$Go";
            this.AButtonData.ButtonVisible = true;
            this.AButtonData.ButtonEnabled = true;
            this.BButtonData.ButtonText = "$CANCEL";
            this.BButtonData.ButtonVisible = true;
            this.BButtonData.ButtonEnabled = true;
            this.XButtonData.ButtonVisible = false;
         }
         else if(param13)
         {
            this.AButtonData.ButtonText = "$WNPC_Command";
            this.AButtonData.ButtonEnabled = param18;
            this.AButtonData.ButtonVisible = true;
            this.BButtonData.ButtonVisible = false;
            this.RBButtonData.ButtonVisible = param20;
            this.RBButtonData.ButtonEnabled = param21;
            this.RBButtonData.ButtonText = "$WNPC_Caravan";
            this.XButtonData.ButtonText = "$WNPC_Move";
            this.XButtonData.ButtonEnabled = param19;
            this.XButtonData.ButtonVisible = true;
         }
         else if(!param1 && !param2)
         {
            this.RBButtonData.ButtonVisible = param22;
            this.RBButtonData.ButtonEnabled = true;
            this.RBButtonData.ButtonText = "$TAG FOR SEARCH";
            if(!param3)
            {
               this.AButtonData.ButtonVisible = false;
               this.BButtonData.ButtonVisible = false;
               this.XButtonData.ButtonVisible = false;
            }
            else
            {
               this.AButtonData.ButtonVisible = Boolean(param6) || Boolean(param7);
               this.AButtonData.ButtonEnabled = Boolean(param6) || Boolean(param7);
               if(param6)
               {
                  this.AButtonData.ButtonText = "$REPAIR";
                  this.AButtonData.ButtonEnabled = !param16;
               }
               else if(param7)
               {
                  this.AButtonData.ButtonText = "$Select";
               }
               this.BButtonData.ButtonText = "$STORE";
               this.BButtonData.ButtonVisible = param4;
               this.BButtonData.ButtonEnabled = param4;
               this.XButtonData.ButtonText = "$SCRAP";
               if(param17)
               {
                  this.XButtonData.ButtonVisible = true;
                  this.XButtonData.ButtonEnabled = false;
               }
               else
               {
                  this.XButtonData.ButtonVisible = param5;
                  this.XButtonData.ButtonEnabled = param5;
               }
               if(param11)
               {
                  this.YButtonData.ButtonVisible = true;
                  this.YButtonData.ButtonEnabled = param12;
                  switch(param23)
                  {
                     case 1:
                        this.YButtonData.ButtonText = "$CONNECT INPUT";
                        break;
                     case 2:
                        this.YButtonData.ButtonText = "$CONNECT OUTPUT";
                        break;
                     default:
                        this.YButtonData.ButtonText = "$ATTACH WIRE";
                  }
               }
            }
         }
         else
         {
            this.BButtonData.ButtonText = "$CANCEL";
            this.BButtonData.ButtonEnabled = true;
            this.BButtonData.ButtonVisible = true;
            this.RBButtonData.ButtonVisible = true;
            this.RBButtonData.ButtonEnabled = param22;
            this.RBButtonData.ButtonText = "$TAG FOR SEARCH";
            this.XButtonData.ButtonVisible = !param1;
            this.XButtonData.ButtonText = "$SCRAP";
            this.XButtonData.ButtonEnabled = param5;
            if(param10)
            {
               this.AButtonData.ButtonVisible = false;
               this.YButtonData.ButtonVisible = true;
               this.YButtonData.ButtonEnabled = param12;
               switch(param23)
               {
                  case 1:
                     this.YButtonData.ButtonText = "$CONNECT INPUT";
                     break;
                  case 2:
                     this.YButtonData.ButtonText = "$CONNECT OUTPUT";
                     break;
                  default:
                     this.YButtonData.ButtonText = "$ATTACH WIRE";
               }
            }
            else
            {
               this.AButtonData.ButtonVisible = true;
               this.AButtonData.ButtonEnabled = param8;
               if(param1)
               {
                  this.AButtonData.ButtonText = "$BUILD";
               }
               else if(param2)
               {
                  this.AButtonData.ButtonText = "$PLACE";
               }
            }
         }
      }
      
      function __setProp_DescriptionBase_mc_WorkshopBase_Description_0() : *
      {
         try
         {
            this.DescriptionBase_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.DescriptionBase_mc.bracketCornerLength = 6;
         this.DescriptionBase_mc.bracketLineWidth = 1.5;
         this.DescriptionBase_mc.bracketPaddingX = 0;
         this.DescriptionBase_mc.bracketPaddingY = 0;
         this.DescriptionBase_mc.BracketStyle = "horizontal";
         this.DescriptionBase_mc.bShowBrackets = true;
         this.DescriptionBase_mc.bUseShadedBackground = true;
         this.DescriptionBase_mc.ShadedBackgroundMethod = "Shader";
         this.DescriptionBase_mc.ShadedBackgroundType = "normal";
         try
         {
            this.DescriptionBase_mc["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
