package bhvr.states
{
	import bhvr.data.GamePersistantData;
	import bhvr.constants.GameConstants;
	import bhvr.data.LocalizationStrings;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import flash.display.MovieClip;
	
	public class TransitionState extends GameState
	{
		 
		
		public function TransitionState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.titleTxt.text = LocalizationStrings.TRANSITION_TITLE;
			_assets.instructionsMc.instructionsAnimMc.instructionsTxt.text = LocalizationStrings.PLAY_PROMPT;
		}
		
		override public function enter() : void
		{
			super.enter();
			var height:Number = ((GamePersistantData.level - 1) * (GamePersistantData.STAGE_3 + 1) + (GamePersistantData.stage + 1)) * GameConstants.HeightToReachPerStage;
			_assets.heightTxt.text = height.toString() + LocalizationStrings.DISTANCE_UNIT;
			InputManager.instance.addEventListener(GameInputs.ACCEPT,onNavContinue,false,0,true);
		}
		
		override public function exit() : void
		{
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,onNavContinue);
			super.exit();
		}
		
		override public function Pause(paused:Boolean) : void
		{
			if(paused)
			{
				_assets.animationMc.stop();
				_assets.instructionsMc.stop();
			}
			else
			{
				_assets.animationMc.play();
				_assets.instructionsMc.play();
			}
		}
	}
}
