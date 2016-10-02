package bhvr.views
{
	import aze.motion.eaze;
	import bhvr.constants.GameConstants;
	import flash.events.Event;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.display.MovieClip;
	
	public class RadiationCloud extends InteractiveObject
	{
		 
		
		private const CRANE_JUMP:String = "CraneJump";
		
		private const SMOKE_EJECT:String = "SmokeEject";
		
		public function RadiationCloud(container:MovieClip)
		{
			_type = InteractiveObject.RADIATION_CLOUD;
			super(container,_type);
			_collider = _mainObject.radiationCloudViewMc;
			eaze(_mainObject).delay(GameConstants.delayRadiationCloudStart).onComplete(this.startLoopAnimationSequence);
			_mainObject.addEventListener(this.CRANE_JUMP,this.onCraneJump,false,0,true);
			_mainObject.addEventListener(this.SMOKE_EJECT,this.onSmokeEject,false,0,true);
		}
		
		private function startLoopAnimationSequence() : void
		{
			eaze(_mainObject.skullMc).play("warnStart>warnEnd").chain(_mainObject.radiationCloudViewMc).play("expand>retractEnd").chain(_mainObject.skullMc).play("idleStart>idleEnd").chain(_mainObject).delay(GameConstants.delayRadiationCloudSequence).onComplete(this.startLoopAnimationSequence);
		}
		
		private function onCraneJump(e:Event) : void
		{
			SoundManager.instance.playSound(SoundList.CRANE_JUMP);
		}
		
		private function onSmokeEject(e:Event) : void
		{
			SoundManager.instance.playSound(SoundList.SMOKE_EJECT);
		}
		
		override public function dispose() : void
		{
			if(_mainObject != null)
			{
				eaze(_mainObject).killTweens();
				eaze(_mainObject.radiationCloudViewMc).killTweens();
				_mainObject.removeEventListener(this.CRANE_JUMP,this.onCraneJump);
				_mainObject.removeEventListener(this.SMOKE_EJECT,this.onSmokeEject);
			}
			super.dispose();
		}
	}
}
