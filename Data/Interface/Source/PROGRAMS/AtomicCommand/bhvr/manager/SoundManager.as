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
		
		public function registerSound(soundName:String) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"registerSound",soundName);
			this._registeredSounds.push(soundName);
		}
		
		public function playSound(soundName:String) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"playSound",soundName);
			Log.info("SoundManager::playSound: " + soundName);
		}
		
		public function startSound(soundId:uint, gameResumed:Boolean = false) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"playRegisteredSound",soundId);
			Log.info("SoundManager::startSound: " + soundId);
			if(!gameResumed)
			{
				this._playingSounds.push(soundId);
			}
		}
		
		public function startLongSound(soundId:uint) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"playRegisteredSound",soundId);
			Log.info("SoundManager::startLongSound: " + soundId);
			this._playingLongSounds.push(soundId);
		}
		
		public function stopLongSound(soundId:uint) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"stopRegisteredSound",soundId);
			Log.info("SoundManager::stopLongSound: " + soundId);
			var playingLongSoundId:uint = this.getPlayingLongSoundIdFromRegisterId(soundId);
			if(playingLongSoundId != this.INVALID_SOUND_ID)
			{
				this._playingLongSounds.splice(playingLongSoundId,1);
			}
		}
		
		public function pauseSound(soundId:uint) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"pauseRegisteredSound",soundId);
			Log.info("SoundManager::pauseSound: " + soundId);
		}
		
		public function stopSound(soundId:uint) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"stopRegisteredSound",soundId);
			Log.info("SoundManager::stopSound: " + soundId);
			var playingSoundId:uint = this.getPlayingSoundIdFromRegisterId(soundId);
			if(playingSoundId != this.INVALID_SOUND_ID)
			{
				this._playingSounds.splice(playingSoundId,1);
			}
		}
		
		private function getPlayingSoundIdFromRegisterId(soundId:uint) : uint
		{
			for(var i:uint = 0; i < this._playingSounds.length; i++)
			{
				if(this._playingSounds[i] == soundId)
				{
					return i;
				}
			}
			return this.INVALID_SOUND_ID;
		}
		
		private function getPlayingLongSoundIdFromRegisterId(soundId:uint) : uint
		{
			for(var i:uint = 0; i < this._playingLongSounds.length; i++)
			{
				if(this._playingLongSounds[i] == soundId)
				{
					return i;
				}
			}
			return this.INVALID_SOUND_ID;
		}
		
		public function Pause(paused:Boolean) : void
		{
			var i:uint = 0;
			var registeredSoundId:uint = 0;
			if(this._isPaused != paused)
			{
				if(paused)
				{
					for(i = 0; i < this._playingSounds.length; i++)
					{
						registeredSoundId = this._playingSounds[i];
						if(registeredSoundId != this.INVALID_SOUND_ID)
						{
							this.pauseSound(registeredSoundId);
						}
					}
					while(this._playingLongSounds.length > 0)
					{
						registeredSoundId = this._playingLongSounds[0];
						if(registeredSoundId != this.INVALID_SOUND_ID)
						{
							this.stopLongSound(registeredSoundId);
						}
					}
				}
				else
				{
					for(i = 0; i < this._playingSounds.length; i++)
					{
						registeredSoundId = this._playingSounds[i];
						if(registeredSoundId != this.INVALID_SOUND_ID)
						{
							this.startSound(registeredSoundId,true);
						}
					}
				}
				this._isPaused = paused;
			}
		}
	}
}
