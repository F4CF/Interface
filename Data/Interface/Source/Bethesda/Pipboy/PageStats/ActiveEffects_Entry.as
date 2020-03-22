package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class ActiveEffects_Entry extends BSUIComponent
	{
		 
		
		public var Source_tf:TextField;
		
		public var Effects_tf:TextField;
		
		private var _SourceText:String;
		
		private var _EffectsText:String;
		
		private var _hasDuration:Boolean;
		
		public function ActiveEffects_Entry()
		{
			super();
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.Source_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			TextFieldEx.setTextAutoSize(this.Effects_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			this._hasDuration = false;
		}
		
		public function set sourceText(param1:String) : *
		{
			this._SourceText = param1 + ":";
			SetIsDirty();
		}
		
		public function set effectsList(param1:Array) : *
		{
			var _loc2_:String = null;
			var _loc5_:Object = null;
			this._EffectsText = "";
			param1.sortOn("text");
			var _loc3_:uint = 0;
			while(_loc3_ < param1.length)
			{
				if(_loc2_ == param1[_loc3_].text && _loc3_ > 0)
				{
					param1[_loc3_ - 1].value = param1[_loc3_ - 1].value + param1[_loc3_].value;
					if(param1[_loc3_].duration > param1[_loc3_ - 1].duration)
					{
						param1[_loc3_ - 1].duration = param1[_loc3_].duration;
					}
					param1.splice(_loc3_,1);
					_loc3_--;
				}
				else
				{
					_loc2_ = param1[_loc3_].text;
				}
				_loc3_++;
			}
			var _loc4_:Boolean = true;
			for each(_loc5_ in param1)
			{
				if(_loc4_)
				{
					_loc4_ = false;
				}
				else
				{
					this._EffectsText = this._EffectsText + "  ";
				}
				if(_loc5_.usesCustomDesc == true)
				{
					this._EffectsText = this._EffectsText + _loc5_.text.toUpperCase();
				}
				else
				{
					this._EffectsText = this._EffectsText + (_loc5_.text.toUpperCase() + " " + (_loc5_.value > 0?"+":"") + (Math.round(_loc5_.value * 100) / 100).toString() + (_loc5_.showAsPercent == true?"%":""));
				}
				this._hasDuration = _loc5_.duration != undefined && _loc5_.duration > 0;
			}
			SetIsDirty();
		}
		
		public function get hasDuration() : Boolean
		{
			return this._hasDuration;
		}
		
		override public function redrawUIComponent() : void
		{
			GlobalFunc.SetText(this.Source_tf,this._SourceText,false);
			GlobalFunc.SetText(this.Effects_tf,this._EffectsText,false);
		}
	}
}
