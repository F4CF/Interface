package Shared.AS3
{
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.AS3.COMPANIONAPP.MobileButtonHint;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public dynamic class BSButtonHintBar extends BSUIComponent
	{
		 
		
		public var ButtonBracket_Left_mc:MovieClip;
		
		public var ButtonBracket_Right_mc:MovieClip;
		
		public var ShadedBackground_mc:MovieClip;
		
		private var ButtonHintBarInternal_mc:MovieClip;
		
		private var _buttonHintDataV:Vector.<BSButtonHintData>;
		
		private var ButtonPoolV:Vector.<BSButtonHint>;
		
		private var _bRedirectToButtonBarMenu:Boolean = true;
		
		private var _backgroundColor:uint = 0;
		
		private var _backgroundAlpha:Number = 1.0;
		
		private var _bShowBrackets_Override:Boolean = true;
		
		private var _bUseShadedBackground_Override:Boolean = true;
		
		public var SetButtonHintData:Function;
		
		public function BSButtonHintBar()
		{
			this.SetButtonHintData = this.SetButtonHintData_Impl;
			super();
			visible = false;
			this.ButtonHintBarInternal_mc = new MovieClip();
			addChild(this.ButtonHintBarInternal_mc);
			this._buttonHintDataV = new Vector.<BSButtonHintData>();
			this.ButtonPoolV = new Vector.<BSButtonHint>();
		}
		
		public function get bRedirectToButtonBarMenu() : Boolean
		{
			return this._bRedirectToButtonBarMenu;
		}
		
		public function set bRedirectToButtonBarMenu(param1:Boolean) : *
		{
			if(this._bRedirectToButtonBarMenu != param1)
			{
				this._bRedirectToButtonBarMenu = param1;
				SetIsDirty();
			}
		}
		
		public function get BackgroundColor() : uint
		{
			return this._backgroundColor;
		}
		
		public function set BackgroundColor(param1:uint) : *
		{
			if(this._backgroundColor != param1)
			{
				this._backgroundColor = param1;
				SetIsDirty();
			}
		}
		
		public function get BackgroundAlpha() : Number
		{
			return this._backgroundAlpha;
		}
		
		public function set BackgroundAlpha(param1:Number) : *
		{
			if(this._backgroundAlpha != param1)
			{
				this._backgroundAlpha = param1;
			}
		}
		
		override public function get bShowBrackets() : Boolean
		{
			return this._bShowBrackets_Override;
		}
		
		override public function set bShowBrackets(param1:Boolean) : *
		{
			this._bShowBrackets_Override = param1;
			SetIsDirty();
		}
		
		override public function get bUseShadedBackground() : Boolean
		{
			return this._bUseShadedBackground_Override;
		}
		
		override public function set bUseShadedBackground(param1:Boolean) : *
		{
			this._bUseShadedBackground_Override = param1;
			SetIsDirty();
		}
		
		private function CanBeVisible() : Boolean
		{
			return !this.bRedirectToButtonBarMenu || !bAcquiredByNativeCode;
		}
		
		override public function onAcquiredByNativeCode() : *
		{
			var _loc1_:Vector.<BSButtonHintData> = null;
			super.onAcquiredByNativeCode();
			if(this.bRedirectToButtonBarMenu)
			{
				this.SetButtonHintData(this._buttonHintDataV);
				_loc1_ = new Vector.<BSButtonHintData>();
				this.SetButtonHintData_Impl(_loc1_);
				SetIsDirty();
			}
		}
		
		private function SetButtonHintData_Impl(param1:Vector.<BSButtonHintData>) : void
		{
			var abuttonHintDataV:Vector.<BSButtonHintData> = param1;
			this._buttonHintDataV.forEach(function(param1:BSButtonHintData, param2:int, param3:Vector.<BSButtonHintData>):*
			{
				if(param1)
				{
					param1.removeEventListener(BSButtonHintData.BUTTON_HINT_DATA_CHANGE,this.onButtonHintDataDirtyEvent);
				}
			},this);
			this._buttonHintDataV = abuttonHintDataV;
			this._buttonHintDataV.forEach(function(param1:BSButtonHintData, param2:int, param3:Vector.<BSButtonHintData>):*
			{
				if(param1)
				{
					param1.addEventListener(BSButtonHintData.BUTTON_HINT_DATA_CHANGE,this.onButtonHintDataDirtyEvent);
				}
			},this);
			this.CreateButtonHints();
		}
		
		public function onButtonHintDataDirtyEvent(param1:Event) : void
		{
			SetIsDirty();
		}
		
		private function CreateButtonHints() : *
		{
			visible = false;
			while(this.ButtonPoolV.length < this._buttonHintDataV.length)
			{
				if(CompanionAppMode.isOn)
				{
					this.ButtonPoolV.push(new MobileButtonHint());
				}
				else
				{
					this.ButtonPoolV.push(new BSButtonHint());
				}
			}
			var _loc1_:int = 0;
			while(_loc1_ < this.ButtonPoolV.length)
			{
				this.ButtonPoolV[_loc1_].ButtonHintData = _loc1_ < this._buttonHintDataV.length?this._buttonHintDataV[_loc1_]:null;
				_loc1_++;
			}
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc5_:BSButtonHint = null;
			var _loc6_:Rectangle = null;
			var _loc7_:Graphics = null;
			super.redrawUIComponent();
			if(this.ShadedBackground_mc && contains(this.ShadedBackground_mc))
			{
				removeChild(this.ShadedBackground_mc);
			}
			var _loc1_:* = false;
			var _loc2_:Number = 0;
			var _loc3_:Number = 0;
			while(_loc3_ < this.ButtonPoolV.length)
			{
				_loc5_ = this.ButtonPoolV[_loc3_];
				if(_loc5_.ButtonVisible && this.CanBeVisible())
				{
					_loc1_ = true;
					if(!this.ButtonHintBarInternal_mc.contains(_loc5_))
					{
						this.ButtonHintBarInternal_mc.addChild(_loc5_);
					}
					if(_loc5_.bIsDirty)
					{
						_loc5_.redrawUIComponent();
					}
					_loc5_.x = _loc2_;
					_loc2_ = _loc2_ + (_loc5_.width + 20);
				}
				else if(this.ButtonHintBarInternal_mc.contains(_loc5_))
				{
					this.ButtonHintBarInternal_mc.removeChild(_loc5_);
				}
				_loc3_++;
			}
			if(this.ButtonPoolV.length > this._buttonHintDataV.length)
			{
				this.ButtonPoolV.splice(this._buttonHintDataV.length,this.ButtonPoolV.length - this._buttonHintDataV.length);
			}
			if(!CompanionAppMode.isOn)
			{
				this.ButtonHintBarInternal_mc.x = -this.ButtonHintBarInternal_mc.width / 2;
			}
			var _loc4_:Rectangle = this.ButtonHintBarInternal_mc.getBounds(this);
			this.ButtonBracket_Left_mc.x = _loc4_.left - this.ButtonBracket_Left_mc.width;
			this.ButtonBracket_Right_mc.x = _loc4_.right;
			this.ButtonBracket_Left_mc.visible = this.bShowBrackets && !CompanionAppMode.isOn;
			this.ButtonBracket_Right_mc.visible = this.bShowBrackets && !CompanionAppMode.isOn;
			if(ShadedBackgroundMethod == "Flash" && this.bUseShadedBackground)
			{
				if(!this.ShadedBackground_mc)
				{
					this.ShadedBackground_mc = new MovieClip();
				}
				_loc6_ = getBounds(this);
				addChildAt(this.ShadedBackground_mc,0);
				_loc7_ = this.ShadedBackground_mc.graphics;
				_loc7_.clear();
				_loc7_.beginFill(this.BackgroundColor,this.BackgroundAlpha);
				_loc7_.drawRect(_loc6_.x,_loc6_.y,_loc6_.width,_loc6_.height);
				_loc7_.endFill();
			}
			visible = _loc1_;
		}
	}
}
