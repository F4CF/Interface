package bhvr.manager
{
	import Shared.BGSExternalInterface;
	import bhvr.debug.Log;
	
	public class SoundManager
	{
		
		private static var _instance:bhvr.manager.SoundManager;
		
		private static var _allowInstance:Boolean;
		 
		
		public var BGSCodeObj:Object;
		
		private var _isPaused:Boolean = false;
		
		private var _registeredSounds:Vector.<String>;
		
		private var _playingSounds:Vector.<uint>;
		
		private var _playingLongSounds:Vector.<uint>;
		
		private const INVALID_SOUND_ID:uint = 999;
		
		public function SoundManager()
		{
			super();
			if(!bhvr.manager.SoundManager._allowInstance)
			{
				throw new Error("Error: Use SoundManager.instance instead of new SoundManager().");
			}
			this._registeredSounds = new Vector.<String>();
			this._playingSounds = new Vector.<uint>();
			this._playingLongSounds = new Vector.<uint>();
		}
		
		public static function get instance() : bhvr.manager.SoundManager
		{
			if(bhvr.manager.SoundManager._instance == null)
			{
				bhvr.manager.SoundManager._allowInstance = true;
				bhvr.manager.SoundManager._instance = new bhvr.manager.SoundManager();
				bhvr.manager.SoundManager._allowInstance = false;
			}
			return bhvr.manager.SoundManager._instance;
		}
		
		public function registerSounds(param1:Vector.<String>) : void
		{
			var _loc2_:String = null;
			var _loc3_:uint = 0;
			if(param1 != null)
			{
				_loc3_ = 0;
				while(_loc3_ < param1.length)
				{
					_loc2_ = param1[_loc3_];
					this.registerSound(_loc2_);
					_loc3_++;
				}
			}
		}
		
		public function stopAllSounds() : void
		{
			while(this._playingSounds.length > 0)
			{
				this.stopSound(this._playingSounds[0]);
			}
			while(this._playingLongSounds.length > 0)
			{
				this.stopLongSound(this._playingLongSounds[0]);
			}
		}
		
		public function dispose() : void
		{
			this.stopAllSounds();
			this.BGSCodeObj = null;
			this._playingSounds = null;
			this._playingLongSounds = null;
			this._registeredSounds = null;
		}
		
		public function registerSound(param1:String) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"registerSound",param1);
			this._registeredSounds.push(param1);
		}
		
		public function playSound(param1:String) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"playSound",param1);
			Log.info("SoundManager::playSound: " + param1);
		}
		
		public function startSound(param1:uint, param2:Boolean = false) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"playRegisteredSound",param1);
			Log.info("SoundManager::startSound: " + param1);
			if(!param2)
			{
				this._playingSounds.push(param1);
			}
		}
		
		public function startLongSound(param1:uint) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"playRegisteredSound",param1);
			Log.info("SoundManager::startLongSound: " + param1);
			this._playingLongSounds.push(param1);
		}
		
		public function stopLongSound(param1:uint) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"stopRegisteredSound",param1);
			Log.info("SoundManager::stopLongSound: " + param1);
			var _loc2_:uint = this.getPlayingLongSoundIdFromRegisterId(param1);
			if(_loc2_ != this.INVALID_SOUND_ID)
			{
				this._playingLongSounds.splice(_loc2_,1);
			}
		}
		
		public function pauseSound(param1:uint) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"pauseRegisteredSound",param1);
			Log.info("SoundManager::pauseSound: " + param1);
		}
		
		public function stopSound(param1:uint) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"stopRegisteredSound",param1);
			Log.info("SoundManager::stopSound: " + param1);
			var _loc2_:uint = this.getPlayingSoundIdFromRegisterId(param1);
			if(_loc2_ != this.INVALID_SOUND_ID)
			{
				this._playingSounds.splice(_loc2_,1);
			}
		}
		
		private function getPlayingSoundIdFromRegisterId(param1:uint) : uint
		{
			var _loc2_:uint = 0;
			while(_loc2_ < this._playingSounds.length)
			{
				if(this._playingSounds[_loc2_] == param1)
				{
					return _loc2_;
				}
				_loc2_++;
			}
			return this.INVALID_SOUND_ID;
		}
		
		private function getPlayingLongSoundIdFromRegisterId(param1:uint) : uint
		{
			var _loc2_:uint = 0;
			while(_loc2_ < this._playingLongSounds.length)
			{
				if(this._playingLongSounds[_loc2_] == param1)
				{
					return _loc2_;
				}
				_loc2_++;
			}
			return this.INVALID_SOUND_ID;
		}
		
		public function Pause(param1:Boolean) : void
		{
			var _loc2_:uint = 0;
			var _loc3_:uint = 0;
			if(this._isPaused != param1)
			{
				if(param1)
				{
					_loc2_ = 0;
					while(_loc2_ < this._playingSounds.length)
					{
						_loc3_ = this._playingSounds[_loc2_];
						if(_loc3_ != this.INVALID_SOUND_ID)
						{
							this.pauseSound(_loc3_);
						}
						_loc2_++;
					}
					while(this._playingLongSounds.length > 0)
					{
						_loc3_ = this._playingLongSounds[0];
						if(_loc3_ != this.INVALID_SOUND_ID)
						{
							this.stopLongSound(_loc3_);
						}
					}
				}
				else
				{
					_loc2_ = 0;
					while(_loc2_ < this._playingSounds.length)
					{
						_loc3_ = this._playingSounds[_loc2_];
						if(_loc3_ != this.INVALID_SOUND_ID)
						{
							this.startSound(_loc3_,true);
						}
						_loc2_++;
					}
				}
				this._isPaused = param1;
			}
		}
	}
}
