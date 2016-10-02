package bhvr.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	import bhvr.constants.GameConstants;
	
	public class Bullet extends MovieClip
	{
		 
		
		protected var _mainObject:MovieClip;
		
		private var _minX:int;
		
		private var _maxX:int;
		
		private var _minY:int;
		
		private var _maxY:int;
		
		public var _collider:MovieClip;
		
		protected var _deltaX:Number;
		
		protected var _deltaY:Number;
		
		public function Bullet(param1:MovieClip, param2:String)
		{
			super();
			this._mainObject = FlashUtil.getLibraryItem(param1,param2) as MovieClip;
			addChild(this._mainObject);
			this._collider = this._mainObject;
			this._deltaX = 0;
			this._deltaY = 0;
			this._minX = GameConstants.gameZoneArea.x;
			this._maxX = GameConstants.gameZoneArea.x + GameConstants.gameZoneArea.width;
			this._minY = GameConstants.gameZoneArea.y;
			this._maxY = GameConstants.gameZoneArea.y + GameConstants.gameZoneArea.height;
		}
		
		public function get collider() : MovieClip
		{
			return this._collider;
		}
		
		public function get deltaX() : Number
		{
			return this._deltaX;
		}
		
		public function get deltaY() : Number
		{
			return this._deltaY;
		}
		
		public function get position() : Point
		{
			return new Point(this.x,this.y);
		}
		
		public function setDirectionValues(param1:Number, param2:Number) : void
		{
			this._deltaX = param1;
			this._deltaY = param2;
		}
		
		public function update() : void
		{
			if(this.collider)
			{
				x = x + this._deltaX;
				y = y + this._deltaY;
				if(x < this._minX)
				{
					x = this._minX;
					this.explode();
				}
				else if(x > this._maxX)
				{
					x = this._maxX;
					this.explode();
				}
				else if(y < this._minY)
				{
					y = this._minY;
					this.explode();
				}
				else if(y > this._maxY)
				{
					y = this._maxY;
					this.explode();
				}
			}
		}
		
		public function explode() : void
		{
			this._collider = null;
			this._mainObject.visible = false;
		}
		
		public function dispose() : void
		{
			this._collider = null;
			if(this._mainObject)
			{
				removeChild(this._mainObject);
				this._mainObject = null;
			}
		}
	}
}
