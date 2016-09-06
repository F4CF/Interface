package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.constants.GameConstants;
	import bhvr.utils.MathUtil;
	import aze.motion.eaze;
	import bhvr.data.SoundList;
	import bhvr.manager.SoundManager;
	import flash.geom.Point;
	
	public class Crabs extends RadioActivePool
	{
		 
		
		private const MAX_CRABS_NUM:uint = 3;
		
		private const WARNING_ANIMATION_FRAMES_NUM:uint = 3;
		
		private var _states:Vector.<Boolean>;
		
		private var _crabColliders:Vector.<MovieClip>;
		
		public function Crabs(container:MovieClip)
		{
			_type = InteractiveObject.CRABS;
			super(container);
			_collider = _mainObject.colliderMc;
			this.initStates();
		}
		
		public function get states() : Vector.<Boolean>
		{
			return this._states;
		}
		
		public function get crabColliders() : Vector.<MovieClip>
		{
			return this._crabColliders;
		}
		
		private function initStates() : void
		{
			this._states = new Vector.<Boolean>();
			this._crabColliders = new Vector.<MovieClip>();
			for(var i:uint = 0; i < this.MAX_CRABS_NUM; i++)
			{
				this.setState(i,GameConstants["clawsUpInitialStateCrab" + (i + 1)]);
				this._crabColliders[i] = _mainObject["crab" + i];
				this._crabColliders[i].hasPlayerOnHead = false;
				this.setCrabClawsAnimationSequence(i,this._states[i],GameConstants["initialTimingCrab" + (i + 1)]);
			}
		}
		
		private function setCrabClawsAnimationSequence(crabId:uint, clawsUp:Boolean, initialTiming:Number = 0.0) : void
		{
			var duration:Number = NaN;
			var delay:Number = NaN;
			var id:uint = this.getCrabId(crabId);
			var crabMc:MovieClip = _mainObject["crab" + id];
			var currentStateDuration:Number = !!clawsUp?Number(GameConstants.clawsUpDuration):Number(GameConstants.clawsDownDuration);
			var currentWarningDuration:Number = !!clawsUp?Number(GameConstants.clawsUpWarningDuration):Number(GameConstants.clawsDownWarningDuration);
			var initTime:Number = MathUtil.clamp(initialTiming,0,currentStateDuration + currentWarningDuration);
			if(initTime < currentStateDuration)
			{
				delay = currentStateDuration - initTime;
				duration = 0;
			}
			else
			{
				delay = 0;
				duration = initTime - currentStateDuration;
			}
			eaze(crabMc).delay(delay).onComplete(this.onWarningState,id,duration);
		}
		
		private function onWarningState(id:uint, initialTiming:Number = 0.0) : void
		{
			var initTime:Number = MathUtil.clamp(initialTiming,0,!!this._states[id]?Number(GameConstants.clawsUpWarningDuration):Number(GameConstants.clawsDownWarningDuration));
			var durationBetweenAnimationFrames:Number = !!this._states[id]?Number(GameConstants.clawsUpWarningDuration / this.WARNING_ANIMATION_FRAMES_NUM):Number(GameConstants.clawsDownWarningDuration / this.WARNING_ANIMATION_FRAMES_NUM);
			var currentAnimationFrame:uint = Math.floor(initTime / durationBetweenAnimationFrames) + 1;
			initTime = initTime - (currentAnimationFrame - 1) * durationBetweenAnimationFrames;
			this.playWarningFrame(id,durationBetweenAnimationFrames,currentAnimationFrame,initTime);
		}
		
		private function playWarningFrame(id:uint, delay:Number, frameId:uint, initialTiming:Number = 0.0) : void
		{
			var initTime:Number = NaN;
			var crabMc:MovieClip = null;
			if(frameId <= this.WARNING_ANIMATION_FRAMES_NUM)
			{
				initTime = MathUtil.clamp(initialTiming,0,delay);
				crabMc = _mainObject["crab" + id];
				crabMc.telegraphMc.gotoAndStop("telegraphFrame" + frameId);
				crabMc.staticEyesMc.visible = false;
				eaze(crabMc.telegraphMc).delay(delay - initTime).onComplete(this.playWarningFrame,id,delay,frameId + 1);
			}
			else
			{
				this.onChangeCrabState(id);
			}
		}
		
		private function onChangeCrabState(id:uint) : void
		{
			var soundToPlay:String = null;
			var crabMc:MovieClip = _mainObject["crab" + id];
			crabMc.telegraphMc.gotoAndStop("off");
			crabMc.staticEyesMc.visible = true;
			if(this._states != null)
			{
				this.setState(id,!this._states[id]);
				this.setCrabClawsAnimationSequence(id,this._states[id]);
				soundToPlay = !!this._states[id]?SoundList.CRAB_CLAWS_UP_SOUND:SoundList.CRAB_CLAWS_DOWN_SOUND;
				SoundManager.instance.playSound(soundToPlay);
			}
		}
		
		private function setState(crabId:uint, state:Boolean) : void
		{
			var id:uint = this.getCrabId(crabId);
			this._states[id] = state;
			this.setVisualState(id);
		}
		
		private function setVisualState(crabId:uint) : void
		{
			var frameLabel:String = !!this._states[crabId]?"on":"off";
			_mainObject["crab" + crabId].gotoAndPlay(frameLabel);
		}
		
		public function getCrabHeadPosition(crabId:uint) : Point
		{
			var id:uint = this.getCrabId(crabId);
			return new Point(this._crabColliders[id].x,this._crabColliders[id].y);
		}
		
		private function getCrabId(id:uint) : uint
		{
			return MathUtil.clamp(id,0,this.MAX_CRABS_NUM - 1);
		}
		
		override public function pause() : void
		{
			var crabMc:MovieClip = null;
			for(var i:uint = 0; i < this.MAX_CRABS_NUM; i++)
			{
				crabMc = _mainObject["crab" + i];
				if(crabMc != null && crabMc.clawsUpMc != null)
				{
					crabMc.clawsUpMc.stop();
				}
			}
		}
		
		override public function resume() : void
		{
			var crabMc:MovieClip = null;
			for(var i:uint = 0; i < this.MAX_CRABS_NUM; i++)
			{
				crabMc = _mainObject["crab" + i];
				if(crabMc != null && crabMc.clawsUpMc != null)
				{
					crabMc.clawsUpMc.play();
				}
			}
		}
		
		override public function dispose() : void
		{
			var crabMc:MovieClip = null;
			var i:uint = 0;
			if(_mainObject != null)
			{
				for(i = 0; i < this.MAX_CRABS_NUM; i++)
				{
					crabMc = _mainObject["crab" + i];
					if(crabMc != null)
					{
						eaze(crabMc).killTweens();
						if(crabMc.telegraphMc != null)
						{
							eaze(crabMc.telegraphMc).killTweens();
						}
					}
				}
			}
			this._states = null;
			this._crabColliders = null;
			super.dispose();
		}
	}
}
