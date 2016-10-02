package bhvr.controller
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.views.Character;
	import flash.geom.Point;
	import bhvr.utils.MathUtil;
	import bhvr.constants.GameConstants;
	
	public class CharacterController extends EventDispatcher
	{
		 
		
		protected var _container:MovieClip;
		
		protected var _charactersContainer:MovieClip;
		
		protected var _characters:Vector.<Character>;
		
		protected var _started:Boolean;
		
		public function CharacterController(param1:MovieClip)
		{
			super();
			this._started = false;
			this._container = param1;
			this._charactersContainer = new MovieClip();
			this._container.addChild(this._charactersContainer);
		}
		
		public function get characters() : Vector.<Character>
		{
			return this._characters;
		}
		
		public function get started() : Boolean
		{
			return this._started;
		}
		
		public function start() : void
		{
			var _loc1_:Character = null;
			if(this._characters == null)
			{
				this.createCharacters();
			}
			else
			{
				this.spawnCharacters();
			}
			var _loc2_:uint = 0;
			while(_loc2_ < this._characters.length)
			{
				_loc1_ = this._characters[_loc2_];
				_loc1_.start();
				_loc2_++;
			}
			this._started = true;
		}
		
		public function stop() : void
		{
			var _loc1_:Character = null;
			var _loc2_:uint = 0;
			this._started = false;
			if(this._characters != null)
			{
				_loc2_ = 0;
				while(_loc2_ < this._characters.length)
				{
					_loc1_ = this._characters[_loc2_];
					_loc1_.stop();
					_loc2_++;
				}
			}
		}
		
		public function update(param1:Point) : void
		{
			var _loc2_:Character = null;
			var _loc3_:uint = 0;
			if(this._started && this._characters != null)
			{
				_loc3_ = 0;
				while(_loc3_ < this._characters.length)
				{
					this._characters[_loc3_].update(param1);
					_loc3_++;
				}
			}
		}
		
		protected function createCharacters() : void
		{
			this._characters = new Vector.<Character>();
		}
		
		protected function spawnCharacters() : void
		{
			var _loc1_:Character = null;
			var _loc2_:int = 0;
			while(_loc2_ < this._characters.length)
			{
				_loc1_ = this._characters[_loc2_];
				this.spawnCharacter(_loc1_);
				_loc2_++;
			}
		}
		
		protected function spawnCharacter(param1:Character) : void
		{
			var _loc2_:Point = this.getRandomPosition(param1);
			param1.setPosition(_loc2_.x,_loc2_.y);
		}
		
		protected function getRandomPosition(param1:Character) : Point
		{
			var _loc2_:Number = MathUtil.random(GameConstants.gameZoneArea.x + param1.dimension.x / 2,GameConstants.gameZoneArea.x + GameConstants.gameZoneArea.width - param1.dimension.x / 2);
			var _loc3_:Number = MathUtil.random(GameConstants.gameZoneArea.y + param1.dimension.y / 2,GameConstants.gameZoneArea.y + GameConstants.gameZoneArea.height - param1.dimension.y / 2);
			return new Point(_loc2_,_loc3_);
		}
		
		protected function deleteReference(param1:Character) : void
		{
			if(param1 != null)
			{
				param1.dispose();
				this.removeFromList(param1);
			}
		}
		
		protected function removeFromList(param1:Character) : void
		{
			var _loc2_:Character = null;
			var _loc3_:uint = 0;
			if(this._characters != null)
			{
				_loc3_ = 0;
				while(_loc3_ < this._characters.length)
				{
					_loc2_ = this._characters[_loc3_];
					if(param1 == _loc2_)
					{
						this._characters.splice(_loc3_,1);
						break;
					}
					_loc3_++;
				}
			}
		}
		
		protected function deleteCharacters() : void
		{
			if(this._characters != null)
			{
				while(this._characters.length > 0)
				{
					this.deleteReference(this._characters[0]);
				}
				this._characters = null;
			}
		}
		
		public function pause() : void
		{
			var _loc1_:Character = null;
			var _loc2_:uint = 0;
			if(this._characters != null)
			{
				_loc2_ = 0;
				while(_loc2_ < this._characters.length)
				{
					_loc1_ = this._characters[_loc2_];
					_loc1_.pause();
					_loc2_++;
				}
			}
		}
		
		public function resume() : void
		{
			var _loc1_:Character = null;
			var _loc2_:uint = 0;
			if(this._characters != null)
			{
				_loc2_ = 0;
				while(_loc2_ < this._characters.length)
				{
					_loc1_ = this._characters[_loc2_];
					_loc1_.resume();
					_loc2_++;
				}
			}
		}
		
		public function dispose() : void
		{
			this.deleteCharacters();
			this._container.removeChild(this._charactersContainer);
			this._charactersContainer = null;
		}
	}
}
