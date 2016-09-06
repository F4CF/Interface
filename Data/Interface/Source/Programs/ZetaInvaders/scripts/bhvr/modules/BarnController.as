package bhvr.modules
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.views.Barn;
	import bhvr.constatnts.GameConstants;
	import flash.geom.Point;
	
	public class BarnController extends EventDispatcher
	{
		 
		
		private var _container:MovieClip;
		
		private var _barns:Vector.<Barn>;
		
		public function BarnController(container:MovieClip)
		{
			super();
			this._container = container;
			this._barns = new Vector.<Barn>();
			this.createBarns();
		}
		
		public function get barns() : Vector.<Barn>
		{
			return this._barns;
		}
		
		public function createBarns() : void
		{
			var barn:Barn = null;
			var barnPos:Vector.<Point> = this.getBarnPositions(GameConstants.NUMBER_OF_BARNS);
			for(var i:uint = 0; i < GameConstants.NUMBER_OF_BARNS; i++)
			{
				barn = new Barn(i,this._container);
				this._container.addChild(barn);
				barn.x = Math.round(barnPos[i].x);
				barn.y = Math.round(barnPos[i].y);
				this._barns.push(barn);
			}
		}
		
		private function getBarnPositions(barnNum:int) : Vector.<Point>
		{
			var pos:Point = null;
			var posVect:Vector.<Point> = new Vector.<Point>();
			var posY:Number = GameConstants.barnsInitialYPosition;
			var startPosX:Number = GameConstants.barnsInitialXPosition;
			var endPosX:Number = GameConstants.STAGE_WIDTH - GameConstants.barnsInitialXPosition - GameConstants.NUMBER_OF_BARN_PIECES_COL * GameConstants.BARN_PIECE_SIZE;
			var deltaPosX:Number = (endPosX - startPosX) / (barnNum - 1);
			for(var i:uint = 0; i < barnNum; i++)
			{
				pos = new Point(startPosX + deltaPosX * i,posY);
				posVect.push(pos);
			}
			return posVect;
		}
		
		public function getBarnfromPosition(posX:Number) : Barn
		{
			var i:uint = 0;
			var barn:Barn = null;
			var barnPosX:Number = NaN;
			for(i = 0; i < GameConstants.NUMBER_OF_BARNS; i++)
			{
				barn = this._barns[i];
				barnPosX = barn.getBounds(this._container).x;
				if(posX >= barnPosX && posX <= barnPosX + barn.width)
				{
					return barn;
				}
			}
			return null;
		}
		
		public function reset() : void
		{
			for(var i:uint = 0; i < this._barns.length; i++)
			{
				this._barns[i].reset();
			}
		}
		
		public function dispose() : void
		{
			for(var i:uint = 0; i < this._barns.length; i++)
			{
				this._container.removeChild(this._barns[i]);
				this._barns[i].dispose();
			}
			this._barns = null;
			this._container = null;
		}
	}
}
