package bhvr.modules
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.views.Alien;
	import bhvr.constatnts.GameConstants;
	import flash.geom.Point;
	import bhvr.events.GameEvents;
	import bhvr.utils.MathUtil;
	import bhvr.events.EventWithParams;
	
	public class AlienWave extends EventDispatcher
	{
		 
		
		private var _assets:MovieClip;
		
		private var _container:MovieClip;
		
		private var _alienColumns:Vector.<bhvr.modules.AlienColumn>;
		
		private var _alienUfoTractor:Alien;
		
		private var _moveDirection:uint;
		
		private const MOVE_LEFT:uint = 0;
		
		private const MOVE_RIGHT:uint = 1;
		
		private const MOVE_DOWN_LEFT:uint = 2;
		
		private const MOVE_DOWN_RIGHT:uint = 3;
		
		private var _horizontalMoveIncrement:Number;
		
		private var _rightLimit:Number;
		
		private var _startPosY:int;
		
		public function AlienWave(assets:MovieClip)
		{
			super();
			this._assets = assets;
			this._alienColumns = new Vector.<AlienColumn>();
			this.initialize();
		}
		
		public function get container() : MovieClip
		{
			return this._container;
		}
		
		public function get alienUfoTractor() : Alien
		{
			return this._alienUfoTractor;
		}
		
		public function get wavePosX() : Number
		{
			if(this._container == null)
			{
				return 0;
			}
			return this._container.getBounds(this._assets).x;
		}
		
		public function get wavePosY() : Number
		{
			if(this._container == null)
			{
				return 0;
			}
			return this._container.getBounds(this._assets).y;
		}
		
		public function get startPosY() : int
		{
			return this._startPosY;
		}
		
		public function get activeProjectileNum() : Number
		{
			return this._assets.projectileContainerMc.numChildren;
		}
		
		public function get activeAlienNum() : int
		{
			return this._container.numChildren;
		}
		
		public function get alienCount() : int
		{
			var alienNum:int = 0;
			for(var i:uint = 0; i < this._alienColumns.length; i++)
			{
				alienNum = alienNum + this._alienColumns[i].length;
			}
			return alienNum;
		}
		
		public function get isEmpty() : Boolean
		{
			for(var i:uint = 0; i < this._alienColumns.length; i++)
			{
				if(this._alienColumns[i].length > 0)
				{
					return false;
				}
			}
			return true;
		}
		
		public function get shooters() : Vector.<Alien>
		{
			var alienColumn:bhvr.modules.AlienColumn = null;
			var alien:Alien = null;
			var shooters:Vector.<Alien> = new Vector.<Alien>();
			for(var i:uint = 0; i < this._alienColumns.length; i++)
			{
				alienColumn = this._alienColumns[i];
				if(alienColumn.length > 0)
				{
					alien = alienColumn.getAlien(alienColumn.length - 1);
					if(alien.collider)
					{
						shooters.push(alien);
					}
				}
			}
			return shooters;
		}
		
		private function initialize() : void
		{
			var alienCol:bhvr.modules.AlienColumn = null;
			var alien:Alien = null;
			var j:uint = 0;
			this._rightLimit = GameConstants.GAME_ZONE_AREA.x + GameConstants.GAME_ZONE_AREA.width;
			this._container = new MovieClip();
			this._assets.addChild(this._container);
			var pos:Point = new Point(0,0);
			for(var i:uint = 0; i < GameConstants.NUMBER_OF_ALIEN_COLUMNS; i++)
			{
				alienCol = new bhvr.modules.AlienColumn();
				for(j = 0; j < GameConstants.NUMBER_OF_ALIEN_ROWS; j++)
				{
					alien = new Alien(this._assets.projectileContainerMc,this.getLinkageId(j));
					alien.parentColumn = alienCol;
					alien.addEventListener(GameEvents.ALIEN_EXPLODED,this.onAlienExploded,false,0,true);
					alien.addEventListener(GameEvents.ALIEN_SHOOT_BARN,this.onAlienShootBarn,false,0,true);
					alien.addEventListener(GameEvents.ALIEN_SHOOTING_LASER,this.onShootingLaser,false,0,true);
					this._container.addChild(alien);
					alien.x = pos.x + GameConstants.horizontalSpaceBetweenAliens / 2;
					alien.y = pos.y + alien.height;
					alienCol.add(alien);
					pos.y = (j + 1) * GameConstants.verticalSpaceBetweenAliens;
				}
				this._alienColumns.push(alienCol);
				pos.x = (i + 1) * GameConstants.horizontalSpaceBetweenAliens;
				pos.y = 0;
			}
			this._moveDirection = this.MOVE_RIGHT;
			this._horizontalMoveIncrement = (GameConstants.GAME_ZONE_AREA.width - this._container.width) / GameConstants.alienWaveMovesPerRowNum;
			this._container.x = GameConstants.GAME_ZONE_AREA.x - this.wavePosX + (GameConstants.GAME_ZONE_AREA.width - this._container.width) / 2;
			this._container.y = GameConstants.GAME_ZONE_AREA.y + GameConstants.alienWaveInitialYPosition - this.wavePosY;
			this._startPosY = this._container.y;
		}
		
		public function move() : void
		{
			var deltaX:Number = NaN;
			var stepNum:Number = NaN;
			if(this.alienCount == 1)
			{
				stepNum = MathUtil.clamp(GameConstants.alienWaveMovesPerRowNumLastAlien,1,GameConstants.alienWaveMovesPerRowNum);
				this._horizontalMoveIncrement = GameConstants.GAME_ZONE_AREA.width / stepNum;
			}
			if(this._moveDirection == this.MOVE_RIGHT)
			{
				this._container.x = this._container.x + this._horizontalMoveIncrement;
				deltaX = this._rightLimit - (this.wavePosX + this._container.width);
				if(Math.abs(deltaX) < this._horizontalMoveIncrement / 2 || this.wavePosX + this._container.width > this._rightLimit + this._horizontalMoveIncrement / 2)
				{
					this._container.x = this._container.x + deltaX;
					this._moveDirection = this.MOVE_DOWN_LEFT;
				}
			}
			else if(this._moveDirection == this.MOVE_LEFT)
			{
				this._container.x = this._container.x - this._horizontalMoveIncrement;
				deltaX = this.wavePosX - GameConstants.GAME_ZONE_AREA.x;
				if(Math.abs(deltaX) < this._horizontalMoveIncrement / 2 || this.wavePosX < GameConstants.GAME_ZONE_AREA.x - this._horizontalMoveIncrement / 2)
				{
					this._container.x = this._container.x - deltaX;
					this._moveDirection = this.MOVE_DOWN_RIGHT;
				}
			}
			else
			{
				this.moveDown();
			}
			this.moveAliens();
		}
		
		public function moveDown() : void
		{
			this._container.y = this._container.y + GameConstants.alienWaveDistMoveVertical;
			this._moveDirection = this._moveDirection == this.MOVE_DOWN_LEFT?uint(this.MOVE_LEFT):uint(this.MOVE_RIGHT);
			dispatchEvent(new EventWithParams(GameEvents.ALIEN_WAVE_STEP_DOWN,{"posY":this.wavePosY + this._container.height}));
		}
		
		private function moveAliens() : void
		{
			var i:uint = 0;
			if(this._alienColumns)
			{
				for(i = 0; i < this._alienColumns.length; i++)
				{
					this._alienColumns[i].move();
				}
			}
		}
		
		public function destroyAlien(target:Alien) : void
		{
			if(target == this._alienUfoTractor)
			{
				this.endUfoTractor();
			}
			target.destroy();
			target.parentColumn.remove(target);
		}
		
		public function endUfoTractor() : void
		{
			this._alienUfoTractor = null;
		}
		
		private function onAlienShootBarn(e:EventWithParams) : void
		{
			dispatchEvent(e);
		}
		
		private function onShootingLaser(e:EventWithParams) : void
		{
			dispatchEvent(e);
		}
		
		private function onAlienExploded(e:EventWithParams) : void
		{
			var target:Alien = e.params.target as Alien;
			target.removeEventListener(GameEvents.ALIEN_EXPLODED,this.onAlienExploded);
			target.removeEventListener(GameEvents.ALIEN_SHOOT_BARN,this.onAlienShootBarn);
			target.removeEventListener(GameEvents.ALIEN_SHOOTING_LASER,this.onShootingLaser);
			target.dispose();
			this._container.removeChild(target);
			if(this.activeAlienNum == 0)
			{
				dispatchEvent(new EventWithParams(GameEvents.ALIEN_WAVE_DESTROYED));
			}
		}
		
		private function getLinkageId(rowId:uint) : String
		{
			switch(rowId)
			{
				case 0:
					return Alien.ALIEN_UFO_TYPE;
				case 1:
				case 2:
					return Alien.ALIEN_2_TYPE;
				case 3:
				case 4:
				default:
					return Alien.ALIEN_1_TYPE;
			}
		}
		
		public function getRandomUfoTractor() : Alien
		{
			var alienColumn:bhvr.modules.AlienColumn = null;
			var alien:Alien = null;
			var alienId:uint = 0;
			var aliens:Vector.<Alien> = new Vector.<Alien>();
			for(var i:uint = 0; i < this._alienColumns.length; i++)
			{
				alienColumn = this._alienColumns[i];
				if(alienColumn.length > 0)
				{
					alien = alienColumn.getAlien(0);
					if(alien.type == Alien.ALIEN_UFO_TYPE)
					{
						aliens.push(alien);
					}
				}
			}
			if(aliens.length == 0)
			{
				this._alienUfoTractor = null;
			}
			else
			{
				alienId = MathUtil.random(0,aliens.length - 1);
				this._alienUfoTractor = aliens[alienId];
			}
			return this._alienUfoTractor;
		}
		
		public function dispose() : void
		{
			this.endUfoTractor();
			for(var i:uint = 0; i < this._alienColumns.length; i++)
			{
				this._alienColumns[i].dispose();
			}
			this._alienColumns = null;
			while(this._container.numChildren > 0)
			{
				this._container.removeChildAt(0);
			}
			this._assets.removeChild(this._container);
			this._container = null;
			this._assets = null;
		}
	}
}
