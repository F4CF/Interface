package bhvr.modules
{
	import bhvr.views.Alien;
	
	public class AlienColumn
	{
		 
		
		private var _aliens:Vector.<Alien>;
		
		public function AlienColumn()
		{
			super();
			this.initialize();
		}
		
		public function get isEmpty() : Boolean
		{
			return this._aliens.length == 0;
		}
		
		public function get length() : int
		{
			return this._aliens.length;
		}
		
		private function initialize() : void
		{
			this._aliens = new Vector.<Alien>();
		}
		
		public function add(alien:Alien) : void
		{
			this._aliens.push(alien);
		}
		
		public function remove(alien:Alien) : void
		{
			for(var i:uint = 0; i < this._aliens.length; i++)
			{
				if(alien == this._aliens[i])
				{
					this._aliens.splice(i,1);
				}
			}
		}
		
		public function getCurrentShooter() : Alien
		{
			if(this.isEmpty)
			{
				return null;
			}
			return this._aliens[this._aliens.length - 1];
		}
		
		public function getAlien(rowId:uint) : Alien
		{
			if(rowId < this._aliens.length)
			{
				return this._aliens[rowId];
			}
			return null;
		}
		
		public function move() : void
		{
			for(var i:uint = 0; i < this._aliens.length; i++)
			{
				this._aliens[i].move();
			}
		}
		
		public function dispose() : void
		{
			for(var i:uint = 0; i < this._aliens.length; i++)
			{
				this._aliens[i].dispose();
			}
			this._aliens = null;
		}
	}
}
