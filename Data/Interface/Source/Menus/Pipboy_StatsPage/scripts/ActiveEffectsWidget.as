package
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	
	public class ActiveEffectsWidget extends BSUIComponent
	{
		 
		
		public var IconBackground_mc:MovieClip;
		
		public var Icon_mc:MovieClip;
		
		public var TimerIcon_mc:MovieClip;
		
		public var EffectsBackground_mc:MovieClip;
		
		public var EntryHolder_mc:MovieClip;
		
		private var _EffectType:uint;
		
		private var _EffectsA:Array;
		
		private var _ShowingEffects:Boolean;
		
		private var _ShowingTimer:Boolean;
		
		private var _EntryClipsA:Vector.<ActiveEffects_Entry>;
		
		private var ORIGINAL_HEIGHT:Number;
		
		public function ActiveEffectsWidget()
		{
			super();
			this._EffectType = uint.MAX_VALUE;
			this._ShowingEffects = false;
			this._ShowingTimer = false;
			this._EntryClipsA = new Vector.<ActiveEffects_Entry>();
			this.ORIGINAL_HEIGHT = this.height;
		}
		
		public function set effectsType(param1:uint) : *
		{
			this._EffectType = param1;
			this.RefreshEntries();
			SetIsDirty();
		}
		
		public function set effectList(param1:Array) : *
		{
			this._EffectsA = param1;
			this.RefreshEntries();
			SetIsDirty();
		}
		
		public function set showingEffects(param1:Boolean) : *
		{
			this._ShowingEffects = param1;
			SetIsDirty();
		}
		
		private function RefreshEntries() : *
		{
			var _loc1_:Object = null;
			var _loc2_:ActiveEffects_Entry = null;
			this._EntryClipsA.splice(0,this._EntryClipsA.length);
			this._ShowingTimer = false;
			if(this._EffectsA != null)
			{
				for each(_loc1_ in this._EffectsA)
				{
					if(_loc1_.type == this._EffectType)
					{
						_loc2_ = new ActiveEffects_Entry();
						_loc2_.sourceText = _loc1_.text;
						_loc2_.effectsList = _loc1_.effects;
						if(_loc2_.hasDuration)
						{
							this._ShowingTimer = true;
						}
						this._EntryClipsA.push(_loc2_);
					}
				}
			}
		}
		
		override public function redrawUIComponent() : void
		{
			var _loc1_:Number = NaN;
			var _loc2_:ActiveEffects_Entry = null;
			var _loc3_:Number = NaN;
			super.redrawUIComponent();
			this.Icon_mc.gotoAndStop(this._EffectType);
			while(this.EntryHolder_mc.numChildren > 0)
			{
				this.EntryHolder_mc.removeChildAt(0);
			}
			if(this._ShowingEffects)
			{
				_loc1_ = 0;
				for each(_loc2_ in this._EntryClipsA)
				{
					if(_loc2_.bIsDirty)
					{
						_loc2_.redrawUIComponent();
					}
					this.EntryHolder_mc.addChild(_loc2_);
					_loc2_.y = _loc1_;
					_loc1_ = _loc1_ + _loc2_.height;
				}
				_loc3_ = 20;
				this.EffectsBackground_mc.height = this.EntryHolder_mc.height + _loc3_;
				this.IconBackground_mc.height = this.EffectsBackground_mc.height;
			}
			else
			{
				this.EffectsBackground_mc.height = this.EntryHolder_mc.height;
				this.IconBackground_mc.height = this.ORIGINAL_HEIGHT;
			}
			this.EffectsBackground_mc.visible = this._ShowingEffects;
			this.EntryHolder_mc.visible = this._ShowingEffects;
			this.TimerIcon_mc.visible = this._ShowingTimer;
		}
	}
}
