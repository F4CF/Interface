package bhvr.controller
{
	import flash.events.EventDispatcher;
	import bhvr.views.GrognakView;
	import flash.geom.Point;
	import aze.motion.eaze;
	import bhvr.constants.GameConstants;
	import bhvr.events.EventWithParams;
	import bhvr.events.ShipEvents;
	import bhvr.data.database.MapShipData;
	
	public class ShipAnimationController extends EventDispatcher
	{
		 
		
		private var _grognak:GrognakView;
		
		private var _path:Vector.<Point>;
		
		private var _currentStep:uint;
		
		public function ShipAnimationController(grognak:GrognakView, shipData:MapShipData, initialPos:Point)
		{
			super();
			this._grognak = grognak;
			this._path = shipData.path.tiles;
			if(initialPos.x == this._path[this._path.length - 1].x && initialPos.y == this._path[this._path.length - 1].y)
			{
				this._path.reverse();
			}
			else if(initialPos.x != this._path[0].x || initialPos.y != this._path[0].y)
			{
				throw new Error("ShipAnimationController: Ship initial position must be the first or the last element of its Path.");
			}
			this._currentStep = 0;
		}
		
		public function startTravelSequence() : void
		{
			eaze(this).delay(GameConstants.mapGrognakToShipDuration).onComplete(this.onHeroMoveOnShip);
		}
		
		private function onHeroMoveOnShip() : void
		{
			dispatchEvent(new EventWithParams(ShipEvents.HERO_ON_SHIP,{"position":this._path[this._currentStep]}));
		}
		
		public function continueTravelSequence() : void
		{
			eaze(this._grognak).to(GameConstants.mapGrognakFadeShipDuration,{"alpha":0}).onComplete(this.moveShip);
		}
		
		public function moveShip() : void
		{
			this._currentStep++;
			if(this._currentStep <= this._path.length - 1)
			{
				dispatchEvent(new EventWithParams(ShipEvents.SHIP_POSITION_UPDATE,{"position":this._path[this._currentStep]}));
				if(this._currentStep == this._path.length - 1)
				{
					this.showHero();
				}
				else
				{
					eaze(this).delay(GameConstants.mapShipStepDuration).onComplete(this.moveShip);
				}
			}
		}
		
		public function showHero() : void
		{
			eaze(this._grognak).to(GameConstants.mapGrognakFadeShipDuration,{"alpha":1}).onComplete(this.onEndOfTravel);
		}
		
		private function onEndOfTravel() : void
		{
			dispatchEvent(new EventWithParams(ShipEvents.HERO_OUT_OF_SHIP,{
				"position":this._path[this._currentStep],
				"isNorth":this._path[this._path.length - 1].y < this._path[0].y
			}));
		}
		
		public function dispose() : void
		{
			eaze(this).killTweens();
			eaze(this._grognak).killTweens();
			this._path = null;
		}
	}
}
