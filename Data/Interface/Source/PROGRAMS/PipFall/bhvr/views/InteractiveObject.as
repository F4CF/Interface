package bhvr.views
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.utils.FlashUtil;
	
	public class InteractiveObject extends EventDispatcher
	{
		
		public static const NUMBER_OF_OBSTACLES:uint = 15;
		
		public static const NONE:int = -1;
		
		public static const SWINGING_ROPE:int = 0;
		
		public static const ONE_LANDMINE:int = 1;
		
		public static const THREE_LANDMINE:int = 2;
		
		public static const ONE_ROLLING_BARREL:int = 3;
		
		public static const TWO_ROLLING_BARREL:int = 4;
		
		public static const THREE_ROLLING_BARREL:int = 5;
		
		public static const MUTATED_BIRD:int = 6;
		
		public static const MUTATED_MONSTER:int = 7;
		
		public static const BOBBLE_HEAD:int = 8;
		
		public static const RADIOACTIVE_POOL:int = 9;
		
		public static const CRABS:int = 10;
		
		public static const RADIATION_CLOUD:int = 11;
		
		public static const LADDER:int = 12;
		
		public static const TUNNEL_LEFT_WALL:int = 13;
		
		public static const TUNNEL_RIGHT_WALL:int = 14;
		
		public static const PLAYER:int = 15;
		 
		
		protected var _container:MovieClip;
		
		protected var _mainObject:MovieClip;
		
		protected var _type:int = -1;
		
		protected var _collider:MovieClip;
		
		public function InteractiveObject(container:MovieClip, type:int)
		{
			super();
			this._type = type;
			this._container = container;
			this._mainObject = FlashUtil.getLibraryItem(this._container,getLinkageId(this._type)) as MovieClip;
			this._container.addChild(this._mainObject);
		}
		
		public static function getLinkageId(type:int) : String
		{
			switch(type)
			{
				case SWINGING_ROPE:
					return "RopeMc";
				case ONE_LANDMINE:
					return "LandMinesMc";
				case THREE_LANDMINE:
					return "LandMinesMc";
				case ONE_ROLLING_BARREL:
					return "BarrelsMc";
				case TWO_ROLLING_BARREL:
					return "BarrelsMc";
				case THREE_ROLLING_BARREL:
					return "BarrelsMc";
				case MUTATED_BIRD:
					return "MutatedBirdMc";
				case MUTATED_MONSTER:
					return "MutatedMonsterMc";
				case BOBBLE_HEAD:
					return "BobbleHeadMc";
				case RADIOACTIVE_POOL:
					return "RadioactivePoolMc";
				case CRABS:
					return "CrabsMc";
				case RADIATION_CLOUD:
					return "RadiationCloudMc";
				case LADDER:
					return "LadderMc";
				case TUNNEL_LEFT_WALL:
					return "LeftWallMc";
				case TUNNEL_RIGHT_WALL:
					return "RightWallMc";
				case PLAYER:
					return "PipFallMc";
				default:
					return "";
			}
		}
		
		public function get type() : int
		{
			return this._type;
		}
		
		public function get collider() : MovieClip
		{
			return this._collider;
		}
		
		public function pause() : void
		{
		}
		
		public function resume() : void
		{
		}
		
		public function destroy() : void
		{
			this._collider = null;
		}
		
		public function dispose() : void
		{
			this._container.removeChild(this._mainObject);
			this._collider = null;
		}
	}
}
