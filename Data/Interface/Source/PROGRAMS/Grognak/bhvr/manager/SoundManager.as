package bhvr.manager
{
	import Shared.BGSExternalInterface;
	import bhvr.debug.Log;
	
	public class SoundManager
	{
		
		private static var _instance:bhvr.manager.SoundManager;
		
		private static var _allowInstance:Boolean;
		
		public static const NO_SOUND:String = "";
		 
		
		public var BGSCodeObj:Object;
		
		private var _isPaused:Boolean = false;
		
		private var _registeredSounds:Vector.<String>;
		
		private var _playingSounds:Vector.<String>;
		
		private var _playingLongSounds:Vector.<String>;
		
		private const INVALID_SOUND_ID:uint = 999;
		
		public function SoundManager()
		{
			super();
			if(!SoundManager._allowInstance)
			{
				throw new Error("Error: Use SoundManager.instance instead of new SoundManager().");
			}
			this._registeredSounds = new Vector.<String>();
			this._playingSounds = new Vector.<String>();
			this._playingLongSounds = new Vector.<String>();
		}
		
		public static function get instance() : bhvr.manager.SoundManager
		{
			if(SoundManager._instance == null)
			{
				SoundManager._allowInstance = true;
				SoundManager._instance = new bhvr.manager.SoundManager();
				SoundManager._allowInstance = false;
			}
			return SoundManager._instance;
		}
		
		public function registerSound(soundName:String) : void
		{
			if(soundName == NO_SOUND)
			{
				return;
			}
			BGSExternalInterface.call(this.BGSCodeObj,"registerSound",soundName);
			this._registeredSounds.push(soundName);
			Log.info("SoundManager::registerSound: " + soundName);
		}
		
		public function playSound(soundName:String) : void
		{
			if(soundName == NO_SOUND)
			{
				return;
			}
			BGSExternalInterface.call(this.BGSCodeObj,"playSound",soundName);
			Log.info("SoundManager::playSound: " + soundName);
		}
		
		public function startSound(soundName:String, gameResumed:Boolean = false) : void
		{
			var soundId:uint = this.getRegisteredSoundId(soundName);
			if(soundId != this.INVALID_SOUND_ID)
			{
				BGSExternalInterface.call(this.BGSCodeObj,"playRegisteredSound",soundId);
			}
			Log.info("SoundManager::startSound: " + soundName);
			if(!gameResumed)
			{
				this._playingSounds.push(soundName);
			}
		}
		
		public function startLongSound(soundName:String) : void
		{
			var soundId:uint = this.getRegisteredSoundId(soundName);
			if(soundId != this.INVALID_SOUND_ID)
			{
				BGSExternalInterface.call(this.BGSCodeObj,"playRegisteredSound",soundId);
			}
			Log.info("SoundManager::startLongSound: " + soundName);
			this._playingLongSounds.push(soundName);
		}
		
		public function stopLongSound(soundName:String) : void
		{
			var soundId:uint = this.getRegisteredSoundId(soundName);
			if(soundId != this.INVALID_SOUND_ID)
			{
				BGSExternalInterface.call(this.BGSCodeObj,"stopRegisteredSound",soundId);
			}
			Log.info("SoundManager::stopLongSound: " + soundName);
			var playingLongSoundId:uint = this.getPlayingLongSoundId(soundName);
			if(playingLongSoundId != this.INVALID_SOUND_ID)
			{
				this._playingLongSounds.splice(playingLongSoundId,1);
			}
		}
		
		public function stopSound(soundName:String) : void
		{
			var soundId:uint = this.getRegisteredSoundId(soundName);
			if(soundId != this.INVALID_SOUND_ID)
			{
				BGSExternalInterface.call(this.BGSCodeObj,"stopRegisteredSound",soundId);
			}
			Log.info("SoundManager::stopSound: " + soundName);
			var playingSoundId:uint = this.getPlayingSoundId(soundName);
			if(playingSoundId != this.INVALID_SOUND_ID)
			{
				this._playingSounds.splice(playingSoundId,1);
			}
		}
		
		public function pauseSound(soundName:String) : void
		{
			var soundId:uint = this.getRegisteredSoundId(soundName);
			if(soundId != this.INVALID_SOUND_ID)
			{
				BGSExternalInterface.call(this.BGSCodeObj,"pauseRegisteredSound",soundId);
			}
			Log.info("SoundManager::pauseSound: " + soundName);
		}
		
		private function getPlayingSoundId(soundName:String) : uint
		{
			for(var i:uint = 0; i < this._playingSounds.length; i++)
			{
				if(this._playingSounds[i] == soundName)
				{
					return i;
				}
			}
			return this.INVALID_SOUND_ID;
		}
		
		private function getPlayingLongSoundId(soundName:String) : uint
		{
			for(var i:uint = 0; i < this._playingLongSounds.length; i++)
			{
				if(this._playingLongSounds[i] == soundName)
				{
					return i;
				}
			}
			return this.INVALID_SOUND_ID;
		}
		
		private function getRegisteredSoundId(soundName:String) : uint
		{
			for(var i:uint = 0; i < this._registeredSounds.length; i++)
			{
				if(this._registeredSounds[i] == soundName)
				{
					return i;
				}
			}
			return this.INVALID_SOUND_ID;
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
		
		public function Pause(paused:Boolean) : void
		{
			var i:uint = 0;
			var playingSoundName:String = null;
			if(this._isPaused != paused)
			{
				for(i = 0; i < this._playingSounds.length; i++)
				{
					playingSoundName = this._playingSounds[i];
					if(paused)
					{
						this.pauseSound(playingSoundName);
					}
					else
					{
						this.startSound(playingSoundName,true);
					}
				}
				if(paused)
				{
					while(this._playingLongSounds.length > 0)
					{
						this.stopLongSound(this._playingLongSounds[0]);
					}
				}
				this._isPaused = paused;
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
	}
}
