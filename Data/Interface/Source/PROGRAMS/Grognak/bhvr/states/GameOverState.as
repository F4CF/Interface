package bhvr.states
{
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import bhvr.data.SoundList;
	import bhvr.manager.SoundManager;
	import bhvr.data.GamePersistantData;
	import bhvr.manager.SaveManager;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	
	public class GameOverState extends GameState
	{
		 
		
		private var _soundName:String;
		
		public function GameOverState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.gameOverMc.win.statusTxt.text = LocalizationStrings.WIN_STATUS;
			_assets.gameOverMc.win.endStoryTxt.text = LocalizationStrings.WIN_END_STORY;
			_assets.gameOverMc.win.promptMc.promptAnimMc.promptTxt.text = LocalizationStrings.PLAY_AGAIN_PROMPT;
			_assets.gameOverMc.lose.statusTxt.text = LocalizationStrings.LOSE_STATUS;
			_assets.gameOverMc.lose.endStoryTxt.text = LocalizationStrings.LOSE_END_STORY;
			_assets.gameOverMc.lose.promptMc.promptAnimMc.promptTxt.text = LocalizationStrings.PLAY_AGAIN_PROMPT;
		}
		
		private function init() : void
		{
			_assets.gameOverMc.win.promptMc.visible = true;
			_assets.gameOverMc.lose.promptMc.visible = true;
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onContinue,false,0,true);
		}
		
		override public function enter(obj:Object = null) : void
		{
			super.enter();
			_assets.gameOverMc.win.promptMc.visible = false;
			_assets.gameOverMc.lose.promptMc.visible = false;
			var isWon:Boolean = obj.won;
			this._soundName = !!isWon?SoundList.SOUND_GAME_VICTORY:SoundList.SOUND_GAME_OVER;
			SoundManager.instance.startLongSound(this._soundName);
			_assets.gameOverMc.win.visible = isWon;
			_assets.gameOverMc.lose.visible = !isWon;
			GamePersistantData.reset();
			SaveManager.instance.clearSave();
			eaze(_assets).play("introStart>introEnd").onComplete(this.init);
		}
		
		protected function onContinue() : void
		{
			SoundManager.instance.playSound(SoundList.SOUND_GAME_OVER_CONTINUE);
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{"target":this}));
		}
		
		override public function exit() : void
		{
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onContinue);
			super.exit();
		}
		
		override public function Pause(paused:Boolean) : void
		{
			super.Pause(paused);
			if(paused)
			{
				_assets.gameOverMc.win.promptMc.stop();
				_assets.gameOverMc.lose.promptMc.stop();
			}
			else
			{
				_assets.gameOverMc.win.promptMc.play();
				_assets.gameOverMc.lose.promptMc.play();
			}
		}
	}
}
