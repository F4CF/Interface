package bhvr.controller
{
	import bhvr.views.Human;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.display.MovieClip;
	
	public class HumanController extends CharacterController
	{
		 
		
		private var _humansNum:uint;
		
		public function HumanController(param1:MovieClip, param2:uint)
		{
			this._humansNum = param2;
			super(param1);
		}
		
		public function get humans() : Vector.<Human>
		{
			return Vector.<Human>(_characters);
		}
		
		override protected function createCharacters() : void
		{
			var _loc1_:Human = null;
			super.createCharacters();
			var _loc2_:uint = 0;
			while(_loc2_ < this._humansNum)
			{
				_loc1_ = new Human(_charactersContainer);
				_characters.push(_loc1_);
				spawnCharacter(_loc1_);
				_loc2_++;
			}
		}
		
		private function removeHuman(param1:Human) : void
		{
			param1.destroy();
			deleteReference(param1);
		}
		
		public function killHuman(param1:Human) : void
		{
			SoundManager.instance.playSound(SoundList.HUMAN_DEATH_SOUND);
			this.removeHuman(param1);
		}
		
		public function transformHuman(param1:Human) : void
		{
			SoundManager.instance.playSound(SoundList.HUMAN_TRANSFORM_ENEMY_SOUND);
			this.removeHuman(param1);
		}
		
		public function saveHuman(param1:Human) : void
		{
			SoundManager.instance.playSound(SoundList.HUMAN_SAVED_SOUND);
			this.removeHuman(param1);
		}
	}
}
