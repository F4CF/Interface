class gfx.io.GameDelegate
{
	static var responseHash = {};
	static var callBackHash = {};
	static var nextID = 0;
	static var initialized = false;
	function GameDelegate()
	{
	}
	static function call(methodName, params, scope, callBack)
	{
		if(!gfx.io.GameDelegate.initialized)
		{
			gfx.io.GameDelegate.initialize();
		}
		gfx.io.GameDelegate.nextID = gfx.io.GameDelegate.nextID + 1;
		var _loc1_ = gfx.io.GameDelegate.nextID;
		gfx.io.GameDelegate.responseHash[_loc1_] = [scope,callBack];
		params.unshift(methodName,_loc1_);
		flash.external.ExternalInterface.call.apply(null,params);
		delete gfx.io.GameDelegate.responseHash.register1;
	}
	static function receiveResponse(uid)
	{
		var _loc2_ = gfx.io.GameDelegate.responseHash[uid];
		if(_loc2_ == null)
		{
			return undefined;
		}
		var _loc3_ = _loc2_[0];
		var _loc4_ = _loc2_[1];
		_loc3_[_loc4_].apply(_loc3_,arguments.slice(1));
	}
	static function addCallBack(methodName, scope, callBack)
	{
		if(!gfx.io.GameDelegate.initialized)
		{
			gfx.io.GameDelegate.initialize();
		}
		gfx.io.GameDelegate.callBackHash[methodName] = [scope,callBack];
	}
	static function removeCallBack(methodName)
	{
		gfx.io.GameDelegate.callBackHash[methodName] = null;
	}
	static function receiveCall(methodName)
	{
		var _loc2_ = gfx.io.GameDelegate.callBackHash[methodName];
		if(_loc2_ == null)
		{
			return undefined;
		}
		var _loc3_ = _loc2_[0];
		var _loc4_ = _loc2_[1];
		_loc3_[_loc4_].apply(_loc3_,arguments.slice(1));
	}
	static function initialize()
	{
		gfx.io.GameDelegate.initialized = true;
		flash.external.ExternalInterface.addCallback("call",gfx.io.GameDelegate,gfx.io.GameDelegate.receiveCall);
		flash.external.ExternalInterface.addCallback("respond",gfx.io.GameDelegate,gfx.io.GameDelegate.receiveResponse);
	}
}
