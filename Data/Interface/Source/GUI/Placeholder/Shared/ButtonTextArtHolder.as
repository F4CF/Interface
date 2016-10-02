class Shared.ButtonTextArtHolder extends MovieClip
{
	function ButtonTextArtHolder()
	{
		super();
	}
	function SetButtonName(aText)
	{
		this.strButtonName = aText;
	}
	function CreateButtonArt(aInputText)
	{
		var _loc5_ = aInputText.text.indexOf("[");
		var _loc2_ = _loc5_ == -1?-1:aInputText.text.indexOf("]",_loc5_);
		var _loc7_ = undefined;
		if(_loc5_ != -1 && _loc2_ != -1)
		{
			_loc7_ = aInputText.text.substr(0,_loc5_);
			while(_loc5_ != -1 && _loc2_ != -1)
			{
				var _loc10_ = aInputText.text.substring(_loc5_ + 1,_loc2_);
				gfx.io.GameDelegate.call("GetButtonFromUserEvent",[_loc10_],this,"SetButtonName");
				if(this.strButtonName != undefined)
				{
					var _loc6_ = flash.display.BitmapData.loadBitmap(this.strButtonName + ".png");
					if(_loc6_ != undefined && _loc6_.height > 0)
					{
						var _loc8_ = 26;
						var _loc11_ = Math.floor(_loc8_ / _loc6_.height * _loc6_.width);
						_loc7_ = _loc7_ + ("<img src=\'" + this.strButtonName + ".png\' vspace=\'-5\' height=\'" + _loc8_ + "\' width=\'" + _loc11_ + "\'>");
					}
					else
					{
						_loc7_ = _loc7_ + aInputText.text.substring(_loc5_,_loc2_ + 1);
					}
				}
				else
				{
					_loc7_ = _loc7_ + aInputText.text.substring(_loc5_,_loc2_ + 1);
				}
				var _loc4_ = aInputText.text.indexOf("[",_loc2_);
				var _loc9_ = _loc4_ == -1?-1:aInputText.text.indexOf("]",_loc4_);
				if(_loc4_ != -1 && _loc9_ != -1)
				{
					_loc7_ = _loc7_ + aInputText.text.substring(_loc2_ + 1,_loc4_);
				}
				else
				{
					_loc7_ = _loc7_ + aInputText.text.substr(_loc2_ + 1);
				}
				_loc5_ = _loc4_;
				_loc2_ = _loc9_;
			}
		}
		return _loc7_;
	}
}
