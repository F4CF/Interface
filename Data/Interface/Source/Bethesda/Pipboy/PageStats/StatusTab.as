package
{
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.AS3.COMPANIONAPP.MobileScrollMovieClip;
	import Shared.AS3.ConditionBoy;
	import Shared.BGSExternalInterface;
	import Shared.GlobalFunc;
	import Shared.PlatformChangeEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class StatusTab extends PipboyTab
	{
		 
		
		public var Name_tf:TextField;
		
		public var Head_Meter:Pipboy_Meter;
		
		public var Torso_Meter:Pipboy_Meter;
		
		public var LArm_Meter:Pipboy_Meter;
		
		public var RArm_Meter:Pipboy_Meter;
		
		public var LLeg_Meter:Pipboy_Meter;
		
		public var RLeg_Meter:Pipboy_Meter;
		
		public var ConditionBoy_mc:ConditionBoy;
		
		public var DMGWidget_mc:Stats_DMGDRWidget;
		
		public var DRWidget_mc:Stats_DMGDRWidget;
		
		public var ActiveEffects_mc:MovieClip;
		
		public var ActiveEffects_HideRect:MovieClip;
		
		public var ActiveEffects_MaskRect:MovieClip;
		
		private var _ActiveEffect_Clips:Vector.<ActiveEffectsWidget>;
		
		private var _ShowingActiveEffects:Boolean;
		
		private var _ActiveEffect_OrigY:Number;
		
		private var _ActiveEffect_ScrollDist:Number;
		
		private var _DataObj:Object;
		
		private var _DamageDirty:Boolean;
		
		private var _EffectsDirty:Boolean;
		
		private var StimpakButton:BSButtonHintData;
		
		private var RadawayButton:BSButtonHintData;
		
		private var ActiveEffectsButton:BSButtonHintData;
		
		private var _isDragging:Boolean = false;
		
		private var _lastMouseY:Number = 1.7976931348623157E308;
		
		private const COMPANION_ACTIVE_EFFECT_MASK_OFFSET:int = -45;
		
		private var _activeEffectsScroll:MobileScrollMovieClip;
		
		public function StatusTab()
		{
			var _loc1_:Rectangle = null;
			this.StimpakButton = new BSButtonHintData("$Stimpak","E","PSN_A","Xenon_A",1,this.UseStimpak);
			this.RadawayButton = new BSButtonHintData("$Radaway","R","PSN_X","Xenon_X",1,this.UseRadaway);
			this.ActiveEffectsButton = new BSButtonHintData("$SHOW EFFECTS","Q","PSN_R1","Xenon_R1",1,this.ToggleShowingEffects);
			super();
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.Name_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			this._ActiveEffect_Clips = new Vector.<ActiveEffectsWidget>();
			this._ShowingActiveEffects = false;
			this._ActiveEffect_OrigY = this.ActiveEffects_mc.y;
			this._ActiveEffect_ScrollDist = 0;
			this._DamageDirty = false;
			this._EffectsDirty = false;
			addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			if(CompanionAppMode.isOn)
			{
				this.ActiveEffects_MaskRect.height = this.ActiveEffects_MaskRect.height + this.COMPANION_ACTIVE_EFFECT_MASK_OFFSET;
				this.ActiveEffects_HideRect.height = this.ActiveEffects_HideRect.height + this.COMPANION_ACTIVE_EFFECT_MASK_OFFSET;
				_loc1_ = new Rectangle(this.ActiveEffects_HideRect.x,this.ActiveEffects_HideRect.y,this.ActiveEffects_HideRect.width,this.ActiveEffects_HideRect.height);
				this._activeEffectsScroll = new MobileScrollMovieClip(this.ActiveEffects_mc,_loc1_);
			}
		}
		
		override public function PopulateButtonHintData(param1:Vector.<BSButtonHintData>) : *
		{
			param1.push(this.StimpakButton);
			param1.push(this.RadawayButton);
			param1.push(this.ActiveEffectsButton);
		}
		
		override public function onAddedToStage() : void
		{
			super.onAddedToStage();
			stage.addEventListener(KeyboardEvent.KEY_UP,this.onStatusKeyUp);
		}
		
		override protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.Stats;
		}
		
		private function ToggleShowingEffects() : *
		{
			var _loc1_:ActiveEffectsWidget = null;
			this._ShowingActiveEffects = !this._ShowingActiveEffects;
			for each(_loc1_ in this._ActiveEffect_Clips)
			{
				_loc1_.showingEffects = this._ShowingActiveEffects;
			}
			if(this._ShowingActiveEffects)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStatusTabKeyDown);
			}
			else
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStatusTabKeyDown);
			}
			this.ActiveEffectsButton.ButtonText = !!this._ShowingActiveEffects?"$HIDE EFFECTS":"$SHOW EFFECTS";
			this._EffectsDirty = true;
			SetIsDirty();
			BGSExternalInterface.call(this.codeObj,"PlaySmallTransition");
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			var _loc3_:Object = null;
			var _loc4_:Number = NaN;
			var _loc5_:* = undefined;
			super.onPipboyChangeEvent(param1);
			if(param1.DataObj.CurrentTab == this.TabIndex && stage.focus != null)
			{
				stage.focus = null;
			}
			this._DataObj = param1.DataObj;
			this._ActiveEffect_Clips.splice(0,this._ActiveEffect_Clips.length);
			param1.DataObj.ActiveEffects.sortOn("type");
			var _loc2_:uint = uint.MAX_VALUE;
			for each(_loc3_ in param1.DataObj.ActiveEffects)
			{
				if(_loc3_.type != _loc2_)
				{
					_loc5_ = new ActiveEffectsWidget();
					_loc5_.effectsType = _loc3_.type;
					_loc5_.effectList = param1.DataObj.ActiveEffects;
					_loc5_.showingEffects = this._ShowingActiveEffects;
					this._ActiveEffect_Clips.push(_loc5_);
					_loc2_ = _loc3_.type;
				}
			}
			this.Head_Meter.SetMeter(param1.DataObj.HeadCondition,0,100);
			this.LArm_Meter.SetMeter(param1.DataObj.LArmCondition,0,100);
			this.RArm_Meter.SetMeter(param1.DataObj.RArmCondition,0,100);
			this.LLeg_Meter.SetMeter(param1.DataObj.LLegCondition,0,100);
			this.RLeg_Meter.SetMeter(param1.DataObj.RLegCondition,0,100);
			_loc4_ = 0;
			if(param1.DataObj.CurrentHPGain > 0)
			{
				_loc4_ = param1.DataObj.CurrHP + param1.DataObj.MaxHP * param1.DataObj.CurrentHPGain;
			}
			this.Torso_Meter.SetMeter(param1.DataObj.CurrHP,Math.min(_loc4_,param1.DataObj.MaxHP),param1.DataObj.MaxHP);
			this.ConditionBoy_mc.HeadFlags = param1.DataObj.HeadFlags;
			this.ConditionBoy_mc.BodyFlags = param1.DataObj.BodyFlags;
			this._DamageDirty = param1.DataObj.CurrentTab == this.TabIndex;
			this._EffectsDirty = param1.DataObj.CurrentTab == this.TabIndex;
			this.StimpakButton.ButtonVisible = this.visible;
			this.RadawayButton.ButtonVisible = this.visible;
			this.UpdateStimpakRadawayEnabled();
			this.ActiveEffectsButton.ButtonVisible = this.visible && param1.DataObj.ActiveEffects.length > 0;
			if(this._ShowingActiveEffects && param1.DataObj.ActiveEffects.length == 0)
			{
				this.ToggleShowingEffects();
			}
			SetIsDirty();
		}
		
		public function UpdateStimpakRadawayEnabled() : *
		{
			var _loc1_:String = null;
			if(this._DataObj !== null)
			{
				this.StimpakButton.ButtonEnabled = this._DataObj.StimpakCount > 0 && !this._DataObj.ReadOnlyMode;
				this.RadawayButton.ButtonEnabled = this._DataObj.RadawayCount > 0 && !this._DataObj.ReadOnlyMode;
				if(CompanionAppMode.isOn)
				{
					_loc1_ = this.Name_tf.text;
					this.Name_tf.text = "$Stimpak";
					this.StimpakButton.ButtonText = this.Name_tf.text + " (" + this._DataObj.StimpakCount.toString() + ")";
					this.Name_tf.text = "$Radaway";
					this.RadawayButton.ButtonText = this.Name_tf.text + " (" + this._DataObj.RadawayCount.toString() + ")";
					this.Name_tf.text = _loc1_;
				}
				else
				{
					this.StimpakButton.ButtonText = "$$Stimpak (" + this._DataObj.StimpakCount.toString() + ")";
					this.RadawayButton.ButtonText = "$$Radaway (" + this._DataObj.RadawayCount.toString() + ")";
				}
			}
		}
		
		override protected function onReadOnlyChanged(param1:Boolean) : void
		{
			super.onReadOnlyChanged(param1);
			this.UpdateStimpakRadawayEnabled();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:Number = NaN;
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:ActiveEffectsWidget = null;
			super.redrawUIComponent();
			GlobalFunc.SetText(this.Name_tf,this._DataObj.PlayerName,false);
			if(this._DamageDirty)
			{
				this.DMGWidget_mc.redraw(true,this._DataObj.TotalDamages);
				this.DRWidget_mc.redraw(false,this._DataObj.TotalResists);
				_loc1_ = 20;
				_loc2_ = 876;
				_loc3_ = (_loc2_ - (this.DMGWidget_mc.width + this.DRWidget_mc.width + _loc1_)) / 2;
				this.DMGWidget_mc.x = _loc3_;
				this.DRWidget_mc.x = this.DMGWidget_mc.x + this.DMGWidget_mc.width + _loc1_;
				this._DamageDirty = false;
			}
			if(this._EffectsDirty)
			{
				while(this.ActiveEffects_mc.numChildren > 0)
				{
					this.ActiveEffects_mc.removeChildAt(0);
				}
				_loc4_ = 0;
				_loc5_ = 10;
				for each(_loc6_ in this._ActiveEffect_Clips)
				{
					if(_loc6_.bIsDirty)
					{
						_loc6_.redrawUIComponent();
					}
					this.ActiveEffects_mc.addChild(_loc6_);
					_loc6_.y = _loc4_;
					_loc4_ = _loc4_ + (_loc6_.height + _loc5_);
				}
				if(CompanionAppMode.isOn)
				{
					if(this.ActiveEffects_mc.height > this.ActiveEffects_HideRect.height)
					{
						this._activeEffectsScroll.activate();
					}
					else
					{
						this._activeEffectsScroll.deactivate();
						this.ActiveEffects_mc.y = this._ActiveEffect_OrigY;
					}
				}
				else
				{
					this._ActiveEffect_ScrollDist = Math.max(0,this.ActiveEffects_mc.y + _loc4_ - this.ActiveEffects_HideRect.y - this.ActiveEffects_HideRect.height);
				}
				this.ActiveEffects_HideRect.visible = this._ShowingActiveEffects;
				this._EffectsDirty = false;
			}
		}
		
		override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!param2)
			{
				if(param1 == "Accept" && this.iPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.StimpakButton.ButtonVisible && this.StimpakButton.ButtonEnabled)
				{
					this.UseStimpak();
					_loc3_ = true;
				}
				else if(param1 == "XButton" && this.RadawayButton.ButtonVisible && this.RadawayButton.ButtonEnabled)
				{
					this.UseRadaway();
					_loc3_ = true;
				}
				else if(param1 == "RShoulder" && this.ActiveEffectsButton.ButtonVisible && this.ActiveEffectsButton.ButtonEnabled)
				{
					this.ToggleShowingEffects();
					_loc3_ = true;
				}
			}
			return _loc3_;
		}
		
		private function onStatusKeyUp(param1:KeyboardEvent) : *
		{
			if(param1.keyCode == Keyboard.E && this.iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE && this.StimpakButton.ButtonVisible && this.StimpakButton.ButtonEnabled)
			{
				this.UseStimpak();
				param1.stopPropagation();
			}
		}
		
		private function UseStimpak() : void
		{
			BGSExternalInterface.call(this.codeObj,"UseStimpak");
		}
		
		private function UseRadaway() : void
		{
			BGSExternalInterface.call(this.codeObj,"UseRadaway");
		}
		
		private function onStatusTabKeyDown(param1:KeyboardEvent) : *
		{
			var _loc2_:* = undefined;
			if(this._ShowingActiveEffects && this.visible && this._ActiveEffect_ScrollDist != 0)
			{
				_loc2_ = this.ActiveEffects_mc.y;
				if(param1.keyCode == Keyboard.UP)
				{
					this.ScrollActiveEffects(true);
				}
				else if(param1.keyCode == Keyboard.DOWN)
				{
					this.ScrollActiveEffects(false);
				}
				if(_loc2_ != this.ActiveEffects_mc.y)
				{
					dispatchEvent(new Event(BSScrollingList.PLAY_FOCUS_SOUND,true,true));
				}
			}
		}
		
		override public function onRightThumbstickInput(param1:uint) : *
		{
			var _loc2_:* = undefined;
			if(this._ShowingActiveEffects && this.visible && this._ActiveEffect_ScrollDist != 0)
			{
				_loc2_ = this.ActiveEffects_mc.y;
				if(param1 == 1)
				{
					this.ScrollActiveEffects(true);
				}
				else if(param1 == 3)
				{
					this.ScrollActiveEffects(false);
				}
				if(_loc2_ != this.ActiveEffects_mc.y)
				{
					dispatchEvent(new Event(BSScrollingList.PLAY_FOCUS_SOUND,true,true));
				}
			}
		}
		
		private function ScrollActiveEffects(param1:Boolean) : *
		{
			var _loc2_:Number = 75;
			this.ScrollActiveEffectsBy(_loc2_ * (!!param1?1:-1));
		}
		
		private function ScrollActiveEffectsBy(param1:Number) : *
		{
			this.ActiveEffects_mc.y = this.ActiveEffects_mc.y + param1;
			this.ActiveEffects_mc.y = Math.min(this.ActiveEffects_mc.y,this._ActiveEffect_OrigY);
			this.ActiveEffects_mc.y = Math.max(this.ActiveEffects_mc.y,this._ActiveEffect_OrigY - this._ActiveEffect_ScrollDist);
		}
		
		public function onMouseWheel(param1:MouseEvent) : *
		{
			var _loc2_:* = undefined;
			if(this._ShowingActiveEffects && this.visible && this._ActiveEffect_ScrollDist != 0)
			{
				_loc2_ = this.ActiveEffects_mc.y;
				if(param1.delta < 0)
				{
					this.ScrollActiveEffects(false);
				}
				else if(param1.delta > 0)
				{
					this.ScrollActiveEffects(true);
				}
				param1.stopPropagation();
				if(_loc2_ != this.ActiveEffects_mc.y)
				{
					dispatchEvent(new Event(BSScrollingList.PLAY_FOCUS_SOUND,true,true));
				}
			}
		}
		
		override public function onRemovedFromStage() : void
		{
			if(CompanionAppMode.isOn)
			{
				this._activeEffectsScroll.deactivate();
				this._activeEffectsScroll = null;
			}
			super.onRemovedFromStage();
		}
	}
}
