package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.MovieClip;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class Pipboy_BottomBar extends BSUIComponent
	{
		 
		
		public var Info_mc:MovieClip;
		
		private var _DataObj:Pipboy_DataObj;
		
		private const MAX_DISPLAY_CAPS:uint = 1000000;
		
		private const MAX_DISPLAY_CAPS_TEXT:String = "1000000+";
		
		public function Pipboy_BottomBar()
		{
			super();
			Extensions.enabled = true;
		}
		
		override public function onAddedToStage() : void
		{
			super.onAddedToStage();
			if(stage)
			{
				PipboyChangeEvent.Register(stage,this.onPipboyChangeEvent);
			}
		}
		
		override public function onRemovedFromStage() : void
		{
			if(stage)
			{
				PipboyChangeEvent.Unregister(stage,this.onPipboyChangeEvent);
			}
			super.onRemovedFromStage();
		}
		
		private function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			this._DataObj = param1.DataObj;
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:uint = 0;
			var _loc2_:uint = 0;
			var _loc3_:uint = 0;
			var _loc4_:Number = NaN;
			super.redrawUIComponent();
			if(this._DataObj != null)
			{
				switch(this._DataObj.CurrentPage)
				{
					case 0:
						this.Info_mc.gotoAndStop("StatsPage");
						TextFieldEx.setTextAutoSize(this.Info_mc.HP_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
						TextFieldEx.setTextAutoSize(this.Info_mc.LVL_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
						TextFieldEx.setTextAutoSize(this.Info_mc.AP_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
						GlobalFunc.SetText(this.Info_mc.HP_tf,"$HP",false);
						GlobalFunc.SetText(this.Info_mc.HP_tf,this.Info_mc.HP_tf.text + "  " + Math.max(0,Math.floor(this._DataObj.CurrHP)) + "/" + Math.floor(this._DataObj.MaxHP),false);
						GlobalFunc.SetText(this.Info_mc.LVL_tf,"$LEVEL",false);
						GlobalFunc.SetText(this.Info_mc.LVL_tf,this.Info_mc.LVL_tf.text + " " + this._DataObj.XPLevel,false);
						this.Info_mc.XPMeter_mc.SetMeter(this._DataObj.XPProgressPct * 100,0,100);
						GlobalFunc.SetText(this.Info_mc.AP_tf,"$AP",false);
						if(this._DataObj.MaxAP <= 0)
						{
							GlobalFunc.SetText(this.Info_mc.AP_tf,this.Info_mc.AP_tf.text + "  --/--",false);
						}
						else
						{
							GlobalFunc.SetText(this.Info_mc.AP_tf,this.Info_mc.AP_tf.text + "  " + Math.floor(this._DataObj.CurrAP) + "/" + Math.floor(this._DataObj.MaxAP),false);
						}
						break;
					case 1:
						switch(this._DataObj.CurrentTab)
						{
							case 0:
								this.Info_mc.gotoAndStop("InvPage_Weapons");
								this.Info_mc.DMGDRWidget_mc.redraw(true,this._DataObj.TotalDamages);
								break;
							case 1:
								this.Info_mc.gotoAndStop("InvPage_Apparel");
								this.Info_mc.DMGDRWidget_mc.redraw(false,this._DataObj.TotalResists);
								break;
							case 2:
								this.Info_mc.gotoAndStop("InvPage_Aid");
								_loc4_ = this._DataObj.CurrHP;
								if(this._DataObj.CurrentHPGain > 0)
								{
									_loc4_ = _loc4_ + this._DataObj.MaxHP * this._DataObj.CurrentHPGain;
								}
								if(this._DataObj.SelectedItemHPGain > 0)
								{
									_loc4_ = _loc4_ + this._DataObj.MaxHP * this._DataObj.SelectedItemHPGain;
								}
								if(this._DataObj.CurrentHPGain == 0 && this._DataObj.SelectedItemHPGain == 0)
								{
									_loc4_ = 0;
								}
								this.Info_mc.HPMeter.SetMeter(this._DataObj.CurrHP,Math.min(_loc4_,this._DataObj.MaxHP),this._DataObj.MaxHP);
								break;
							default:
								this.Info_mc.gotoAndStop("InvPage_Misc");
						}
						TextFieldEx.setTextAutoSize(this.Info_mc.Weight_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
						TextFieldEx.setTextAutoSize(this.Info_mc.Caps_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
						GlobalFunc.SetText(this.Info_mc.Weight_tf,Math.floor(this._DataObj.CurrWeight) + "/" + Math.floor(this._DataObj.MaxWeight),false);
						if(this._DataObj.Caps >= this.MAX_DISPLAY_CAPS)
						{
							GlobalFunc.SetText(this.Info_mc.Caps_tf,this.MAX_DISPLAY_CAPS_TEXT,false);
						}
						else
						{
							GlobalFunc.SetText(this.Info_mc.Caps_tf,this._DataObj.Caps.toString(),false);
						}
						break;
					case 2:
					case 3:
						this.Info_mc.gotoAndStop("DataPage");
						GlobalFunc.SetText(this.Info_mc.Date_tf,this._DataObj.DateMonth + "." + this._DataObj.DateDay + ".2" + this._DataObj.DateYear,false);
						_loc1_ = Math.floor(this._DataObj.TimeHour);
						_loc2_ = Math.floor((this._DataObj.TimeHour - _loc1_) * 60);
						_loc3_ = _loc1_ % 12;
						if(_loc3_ == 0)
						{
							_loc3_ = 12;
						}
						GlobalFunc.SetText(this.Info_mc.Time_tf,_loc3_ + ":" + (_loc2_ < 10?"0" + _loc2_:_loc2_.toString()) + " " + (_loc1_ < 12?"AM":"PM"),false);
						if(this._DataObj.CurrentPage == 3)
						{
							GlobalFunc.SetText(this.Info_mc.Location_tf,this._DataObj.CurrLocationName,false);
						}
						else
						{
							GlobalFunc.SetText(this.Info_mc.Location_tf," ",false);
						}
						break;
					default:
						this.Info_mc.gotoAndStop("None");
				}
			}
		}
	}
}
