package bhvr.modules
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.views.Target;
	import bhvr.debug.Log;
	import bhvr.views.Landmark;
	import bhvr.events.GameEvents;
	import bhvr.constatnts.GameConstants;
	import bhvr.data.GamePersistantData;
	import bhvr.events.EventWithParams;
	import bhvr.utils.MathUtil;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	
	public class LandmarkSystem extends EventDispatcher
	{
		 
		
		protected var _assets:MovieClip;
		
		protected var _extraLandmarks:Vector.<int>;
		
		protected var _landmarks:Vector.<Target>;
		
		public function LandmarkSystem(assets:MovieClip)
		{
			super();
			this._assets = assets;
			this.initialize();
		}
		
		public function get landmarks() : Vector.<Target>
		{
			return this._landmarks;
		}
		
		public function get activeLandmarks() : Vector.<Target>
		{
			var actives:Vector.<Target> = new Vector.<Target>();
			for(var i:int = 0; i < this._landmarks.length; i++)
			{
				if(this._landmarks[i].destroyed == false)
				{
					actives.push(this._landmarks[i]);
				}
			}
			return actives;
		}
		
		public function get landmarkNumberRemaining() : int
		{
			return this.activeLandmarks.length;
		}
		
		public function initialize() : void
		{
			Log.info("Landmark System initialized");
		}
		
		public function start() : void
		{
			this.reset();
		}
		
		public function stop() : void
		{
			this._landmarks.splice(0,this._landmarks.length);
		}
		
		public function reset() : void
		{
			var landmark:Landmark = null;
			this.checkForExtraLandmark();
			this._landmarks = new Vector.<Target>();
			for(var i:int = 0; i < GameConstants.NUMBER_OF_LANDMARKS; i++)
			{
				landmark = new Landmark(this._assets["landmark" + i]);
				landmark.addEventListener(GameEvents.LANDMARK_DESTROYED,this.onLandmarkDestroyed,false,0,true);
				landmark.destroyed = this.isLandmarkDestroyed(i);
				landmark.setVisual(i);
				if(!landmark.destroyed && this.isExtraLandmark(i))
				{
					landmark.playBonusAnimation();
				}
				this._landmarks.push(landmark);
			}
		}
		
		private function isLandmarkDestroyed(landmarkId:int) : Boolean
		{
			var aliveLandmarkId:int = 0;
			var isDestroyed:Boolean = true;
			for(var i:int = 0; i < GamePersistantData.aliveLandmarks.length; i++)
			{
				aliveLandmarkId = GamePersistantData.aliveLandmarks[i];
				if(aliveLandmarkId == landmarkId)
				{
					isDestroyed = false;
					break;
				}
			}
			return isDestroyed;
		}
		
		private function isExtraLandmark(landmarkId:int) : Boolean
		{
			var isExtra:Boolean = false;
			for(var i:int = 0; i < this._extraLandmarks.length; i++)
			{
				if(this._extraLandmarks[i] == landmarkId)
				{
					isExtra = true;
					break;
				}
			}
			return isExtra;
		}
		
		private function onLandmarkDestroyed(e:EventWithParams) : void
		{
			var target:Landmark = e.params.target as Landmark;
			dispatchEvent(new EventWithParams(GameEvents.LANDMARK_DESTROYED,{"target":target}));
		}
		
		private function checkForExtraLandmark() : void
		{
			var landmarkId:int = 0;
			this._extraLandmarks = new Vector.<int>();
			var extraLandmarkNum:int = Math.floor(GamePersistantData.totalScore / GameConstants.LANDMARK_BONUS_POINTS_MILESTONE) - GamePersistantData.extraLandmarkReceived;
			while(extraLandmarkNum > 0)
			{
				if(GamePersistantData.destroyedLandmarks.length > 0)
				{
					landmarkId = MathUtil.random(0,GamePersistantData.destroyedLandmarks.length - 1);
					Log.info("Landmark " + GamePersistantData.destroyedLandmarks[landmarkId] + " has been resurected.");
					this._extraLandmarks.push(GamePersistantData.destroyedLandmarks[landmarkId]);
					GamePersistantData.addLandmark(landmarkId);
					SoundManager.instance.startLongSound(SoundList.EXTRA_LANDMARK_BONUS_SOUND_ID);
					extraLandmarkNum--;
					continue;
				}
				return;
			}
		}
		
		public function pause() : void
		{
			var landmark:Landmark = null;
			for(var i:uint = 0; i < this._landmarks.length; i++)
			{
				landmark = this._landmarks[i] as Landmark;
				landmark.pause();
			}
		}
		
		public function resume() : void
		{
			var landmark:Landmark = null;
			for(var i:uint = 0; i < this._landmarks.length; i++)
			{
				landmark = this._landmarks[i] as Landmark;
				landmark.resume();
			}
		}
		
		public function dispose() : void
		{
			var i:int = 0;
			this._assets = null;
			if(this._landmarks)
			{
				for(i = 0; i < this._landmarks.length; i++)
				{
					this._landmarks[i].removeEventListener(GameEvents.LANDMARK_DESTROYED,this.onLandmarkDestroyed);
					this._landmarks[i].dispose();
					this._landmarks[i] = null;
				}
				this._landmarks = null;
			}
			this._extraLandmarks = null;
		}
	}
}
