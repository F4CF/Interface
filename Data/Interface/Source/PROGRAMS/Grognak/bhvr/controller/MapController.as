package bhvr.controller
{
	import flash.events.EventDispatcher;
	import bhvr.data.database.MapTilesData;
	import bhvr.data.database.MapHeroData;
	import bhvr.data.database.MapObjectData;
	import flash.display.MovieClip;
	import bhvr.views.Tile;
	import bhvr.views.GrognakView;
	import bhvr.views.MapObject;
	import bhvr.views.MapShip;
	import bhvr.views.MapEnemy;
	import flash.geom.Point;
	import bhvr.data.GamePersistantData;
	import bhvr.module.map.MapActions;
	import bhvr.events.ShipEvents;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import bhvr.events.EventWithParams;
	import flash.ui.Keyboard;
	import bhvr.constants.GameConstants;
	import bhvr.debug.Log;
	import bhvr.utils.MathUtil;
	import bhvr.data.database.MapShipData;
	import bhvr.data.database.MapEnemyData;
	import bhvr.data.database.MapLocationData;
	import bhvr.views.MapLocation;
	import bhvr.data.database.MapBlockerData;
	import bhvr.views.MapBlocker;
	import aze.motion.eaze;
	import bhvr.events.MapEvents;
	import bhvr.data.database.CombatEvent;
	import bhvr.data.database.MapEvent;
	
	public class MapController extends EventDispatcher
	{
		
		public static const NO_DIRECTION:uint = 0;
		
		public static const LEFT_DIRECTION:uint = 1;
		
		public static const RIGHT_DIRECTION:uint = 2;
		
		public static const UP_DIRECTION:uint = 3;
		
		public static const DOWN_DIRECTION:uint = 4;
		 
		
		private var _mapData:MapTilesData;
		
		private var _mapHeroData:MapHeroData;
		
		private var _mapObjectsData:Vector.<MapObjectData>;
		
		private var _mapMaskMc:MovieClip;
		
		private var _mapContainerMc:MovieClip;
		
		private var _tileContainerMc:MovieClip;
		
		private var _objContainerMc:MovieClip;
		
		private var _heroContainerMc:MovieClip;
		
		private var _tiles:Vector.<Vector.<Tile>>;
		
		private var _currentCenteredTile:Tile;
		
		private var _grognak:GrognakView;
		
		private var _mapObjects:Vector.<MapObject>;
		
		private var _shipController:bhvr.controller.ShipAnimationController;
		
		private var _ship:MapShip;
		
		private var _mobileEnemies:Vector.<MapEnemy>;
		
		private var _direction:uint;
		
		private var _prevHeroPosition:Point;
		
		public function MapController(mapHolder:MovieClip, mapData:MapTilesData, mapHeroData:MapHeroData, mapObjectsData:Vector.<MapObjectData>)
		{
			this._prevHeroPosition = new Point();
			super();
			this._mapData = mapData;
			this._mapHeroData = mapHeroData;
			this._mapObjectsData = mapObjectsData;
			this._mapMaskMc = mapHolder.mapMaskMc;
			this._mapContainerMc = mapHolder.mapContainerMc;
			this.createMapLayers();
			this.createTiles(this._mapData.tiles);
		}
		
		private function get tileRowNum() : uint
		{
			return this._tiles.length;
		}
		
		private function get tileColNum() : uint
		{
			return this._tiles[0].length;
		}
		
		private function get currentHeroTile() : Tile
		{
			return this.getTile(this._grognak.colId,this._grognak.rowId);
		}
		
		private function get hasInitialPositionFromSavedGame() : Boolean
		{
			return GamePersistantData.initialHeroMapColId >= 0 && GamePersistantData.initialHeroMapRowId >= 0;
		}
		
		public function fill(actionRequested:int = 0) : void
		{
			var initialTilePosition:Point = null;
			var initialTile:Tile = null;
			this.createMapObjects(this._mapObjectsData);
			if(actionRequested == MapActions.FLEE)
			{
				initialTilePosition = GamePersistantData.prevHeroPosition;
				initialTile = this.getTile(initialTilePosition.x,initialTilePosition.y);
			}
			else
			{
				initialTilePosition = !!this.hasInitialPositionFromSavedGame?new Point(GamePersistantData.initialHeroMapColId,GamePersistantData.initialHeroMapRowId):this._mapHeroData.initialPosition;
				initialTile = this.getTile(initialTilePosition.x,initialTilePosition.y);
			}
			this.centerOnTile(initialTilePosition.x,initialTilePosition.y);
			this.createHero(initialTile,this._mapHeroData);
		}
		
		public function init(actionRequested:int = 0) : void
		{
			if(actionRequested == MapActions.SHIP_TRAVEL)
			{
				if(this._ship != null)
				{
					this._shipController = new bhvr.controller.ShipAnimationController(this._grognak,this._ship.shipData,new Point(this._ship.colId,this._ship.rowId));
					this._shipController.addEventListener(ShipEvents.HERO_ON_SHIP,this.onHeroOnShip,false,0,true);
					this._shipController.addEventListener(ShipEvents.SHIP_POSITION_UPDATE,this.onShipPositionUpdate,false,0,true);
					this._shipController.addEventListener(ShipEvents.HERO_OUT_OF_SHIP,this.onHeroOutOfShip,false,0,true);
					this._shipController.startTravelSequence();
					SoundManager.instance.startSound(SoundList.MUSIC_MAP_SHIP_TRAVEL);
				}
				else
				{
					throw new Error("MapController::init --> Ship Travel requested, but no ship exists.");
				}
			}
			else
			{
				SoundManager.instance.startSound(SoundList.MUSIC_WORLD_MAP_SCREEN);
				this.addInputListeners();
			}
		}
		
		public function pause() : void
		{
			var i:uint = 0;
			this.stopInputRepeatTimer();
			this.removeInputListeners();
			this._direction = NO_DIRECTION;
			if(this._grognak)
			{
				this._grognak.pause();
			}
			if(this._mapObjects)
			{
				for(i = 0; i < this._mapObjects.length; i++)
				{
					this._mapObjects[i].pause();
				}
			}
		}
		
		public function resume() : void
		{
			var i:uint = 0;
			if(this._grognak)
			{
				this._grognak.resume();
			}
			if(this._mapObjects)
			{
				for(i = 0; i < this._mapObjects.length; i++)
				{
					this._mapObjects[i].resume();
				}
			}
			this.addInputListeners();
		}
		
		private function addInputListeners() : void
		{
			InputManager.instance.addEventListener(GameInputs.MOVE_LEFT,this.onMoveLeft,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_RIGHT,this.onMoveRight,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_DOWN,this.onMoveDown,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_UP,this.onMoveUp,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_MOVE,this.onMoveStop,false,0,true);
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onCheckInteraction,false,0,true);
		}
		
		private function removeInputListeners() : void
		{
			InputManager.instance.removeEventListener(GameInputs.MOVE_LEFT,this.onMoveLeft);
			InputManager.instance.removeEventListener(GameInputs.MOVE_RIGHT,this.onMoveRight);
			InputManager.instance.removeEventListener(GameInputs.MOVE_DOWN,this.onMoveDown);
			InputManager.instance.removeEventListener(GameInputs.MOVE_UP,this.onMoveUp);
			InputManager.instance.removeEventListener(GameInputs.STOP_MOVE,this.onMoveStop);
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onCheckInteraction);
		}
		
		private function onMoveLeft(e:EventWithParams) : void
		{
			var wasDirection:uint = this._direction;
			if(this._direction != LEFT_DIRECTION)
			{
				this._direction = LEFT_DIRECTION;
				if(wasDirection == NO_DIRECTION)
				{
					this.move();
				}
			}
		}
		
		private function onMoveRight(e:EventWithParams) : void
		{
			var wasDirection:uint = this._direction;
			if(this._direction != RIGHT_DIRECTION)
			{
				this._direction = RIGHT_DIRECTION;
				if(wasDirection == NO_DIRECTION)
				{
					this.move();
				}
			}
		}
		
		private function onMoveDown(e:EventWithParams) : void
		{
			var wasDirection:uint = this._direction;
			if(this._direction != DOWN_DIRECTION)
			{
				this._direction = DOWN_DIRECTION;
				if(wasDirection == NO_DIRECTION)
				{
					this.move();
				}
			}
		}
		
		private function onMoveUp(e:EventWithParams) : void
		{
			var wasDirection:uint = this._direction;
			if(this._direction != UP_DIRECTION)
			{
				this._direction = UP_DIRECTION;
				if(wasDirection == NO_DIRECTION)
				{
					this.move();
				}
			}
		}
		
		private function onMoveStop(e:EventWithParams) : void
		{
			var keyCode:int = e.params.keyCode;
			if((keyCode == Keyboard.LEFT || keyCode == Keyboard.A || keyCode == InputManager.MOVE_LEFT_CODE) && this._direction == LEFT_DIRECTION || (keyCode == Keyboard.RIGHT || keyCode == Keyboard.D || keyCode == InputManager.MOVE_RIGHT_CODE) && this._direction == RIGHT_DIRECTION || (keyCode == Keyboard.UP || keyCode == Keyboard.W || keyCode == InputManager.MOVE_UP_CODE) && this._direction == UP_DIRECTION || (keyCode == Keyboard.DOWN || keyCode == Keyboard.S || keyCode == InputManager.MOVE_DOWN_CODE) && this._direction == DOWN_DIRECTION)
			{
				this._direction = NO_DIRECTION;
				this.stopInputRepeatTimer();
			}
		}
		
		private function onCheckInteraction(e:EventWithParams) : void
		{
			var heroTile:Tile = this.getTile(this._grognak.colId,this._grognak.rowId);
			this.checkTriggerEvent(heroTile);
		}
		
		private function createMapLayers() : void
		{
			this._tileContainerMc = new MovieClip();
			this._mapContainerMc.addChild(this._tileContainerMc);
			this._objContainerMc = new MovieClip();
			this._mapContainerMc.addChild(this._objContainerMc);
			this._heroContainerMc = new MovieClip();
			this._mapContainerMc.addChild(this._heroContainerMc);
		}
		
		private function destroyMapLayers() : void
		{
			this._mapContainerMc.removeChild(this._tileContainerMc);
			this._tileContainerMc = null;
			this._mapContainerMc.removeChild(this._objContainerMc);
			this._objContainerMc = null;
			this._mapContainerMc.addChild(this._heroContainerMc);
			this._heroContainerMc = null;
		}
		
		private function createTiles(mapData:Vector.<Vector.<uint>>) : void
		{
			var tile:Tile = null;
			var tileType:uint = 0;
			var i:uint = 0;
			var j:uint = 0;
			this._tiles = new Vector.<Vector.<Tile>>();
			for(i = 0; i < mapData.length; i++)
			{
				this._tiles[i] = new Vector.<Tile>();
				for(j = 0; j < mapData[i].length; j++)
				{
					tileType = mapData[i][j];
					tile = new Tile(this._mapContainerMc,this._mapData.tileProperties[tileType],tileType,j,i);
					this._tiles[i].push(tile);
					this.addTileOnStage(tile);
				}
			}
			this._currentCenteredTile = this.getTile(Math.floor((GameConstants.VISIBLE_TILES_PER_ROW - 1) / 2),Math.floor((GameConstants.VISIBLE_TILES_PER_COL - 1) / 2));
		}
		
		private function destroyTiles() : void
		{
			var tile:Tile = null;
			var i:uint = 0;
			var j:uint = 0;
			if(this._tiles != null)
			{
				for(i = 0; i < this._tiles.length; i++)
				{
					for(j = 0; j < this._tiles[i].length; j++)
					{
						tile = this._tiles[i][j];
						tile.dispose();
						this.removeTileFromStage(tile);
					}
				}
				this._tiles = null;
			}
		}
		
		private function addTileOnStage(tile:Tile) : void
		{
			this._tileContainerMc.addChild(tile);
			tile.x = tile.width / 2 + tile.width * tile.colId;
			tile.y = tile.height / 2 + tile.height * tile.rowId;
		}
		
		private function removeTileFromStage(tile:Tile) : void
		{
			this._tileContainerMc.removeChild(tile);
		}
		
		private function getTile(colId:uint, rowId:uint) : Tile
		{
			if(colId < this.tileColNum && rowId < this.tileRowNum)
			{
				return this._tiles[rowId][colId];
			}
			Log.warn("MapController::getTile: There is no Tile with colId=" + colId + "and rowId=" + rowId);
			return null;
		}
		
		private function getAdjacentWalkableTile(tile:Tile) : Tile
		{
			var currentTile:Tile = null;
			var j:int = 0;
			for(var i:int = tile.rowId - 1; i <= tile.rowId + 1; i++)
			{
				if(i >= 0 && i < this.tileRowNum)
				{
					for(j = tile.colId - 1; j <= tile.colId + 1; j++)
					{
						if(j >= 0 && j < this.tileColNum)
						{
							currentTile = this._tiles[i][j];
							if(currentTile.tileData.walkable)
							{
								return currentTile;
							}
						}
					}
				}
			}
			return null;
		}
		
		public function centerOnTile(colId:uint, rowId:uint) : void
		{
			var centerColNum:uint = Math.floor((GameConstants.VISIBLE_TILES_PER_ROW - 1) / 2);
			var centerRowNum:uint = Math.floor((GameConstants.VISIBLE_TILES_PER_COL - 1) / 2);
			var clampedCenterColNum:Number = MathUtil.clamp(colId,centerColNum,this.tileColNum - (GameConstants.VISIBLE_TILES_PER_ROW - centerColNum));
			var clampedCenterRowNum:Number = MathUtil.clamp(rowId,centerRowNum,this.tileRowNum - (GameConstants.VISIBLE_TILES_PER_COL - centerRowNum));
			this._currentCenteredTile = this.getTile(clampedCenterColNum,clampedCenterRowNum);
			var tilePosX:Number = GameConstants.TILE_WIDTH / 2 + clampedCenterColNum * GameConstants.TILE_WIDTH;
			var tilePosY:Number = GameConstants.TILE_HEIGHT / 2 + clampedCenterRowNum * GameConstants.TILE_HEIGHT;
			var centerPosX:Number = GameConstants.TILE_WIDTH / 2 + centerColNum * GameConstants.TILE_WIDTH;
			var centerPosY:Number = GameConstants.TILE_HEIGHT / 2 + centerRowNum * GameConstants.TILE_HEIGHT;
			this._mapContainerMc.x = centerPosX - tilePosX;
			this._mapContainerMc.y = centerPosY - tilePosY;
		}
		
		private function createMapObjects(mapObjects:Vector.<MapObjectData>) : void
		{
			var data:MapObjectData = null;
			var obj:MapObject = null;
			var objTile:Tile = null;
			this._mapObjects = new Vector.<MapObject>();
			this._mobileEnemies = new Vector.<MapEnemy>();
			for(var i:uint = 0; i < mapObjects.length; i++)
			{
				if(mapObjects[i] is MapShipData)
				{
					data = mapObjects[i];
					if(GamePersistantData.isStoryConditionMet(MapShipData(data).presenceStoryCondition))
					{
						obj = new MapShip(this._objContainerMc,data as MapShipData);
						this.addMapObjectOnStage(obj);
						this._ship = MapShip(obj);
					}
				}
				if(mapObjects[i] is MapEnemyData)
				{
					data = mapObjects[i];
					if(GamePersistantData.isStoryConditionMet(MapEnemyData(data).activeStoryCondition) && (MapEnemyData(data).recurring || !GamePersistantData.isCombatEventCompleted(MapEnemyData(data).event)))
					{
						obj = new MapEnemy(this._objContainerMc,data as MapEnemyData);
						this.addMapObjectOnStage(obj);
						if(MapEnemyData(data).mobile)
						{
							this._mobileEnemies.push(obj as MapEnemy);
						}
					}
				}
				else if(mapObjects[i] is MapLocationData)
				{
					data = mapObjects[i] as MapLocationData;
					obj = new MapLocation(this._objContainerMc,data as MapLocationData);
					this.addMapObjectOnStage(obj);
				}
				else if(mapObjects[i] is MapBlockerData)
				{
					data = mapObjects[i] as MapBlockerData;
					obj = new MapBlocker(this._objContainerMc,data as MapBlockerData);
					if(MapBlocker(obj).hasVisual)
					{
						this.addMapObjectOnStage(obj);
					}
				}
				if(obj)
				{
					this._mapObjects.push(obj);
					if(obj.colId >= this.tileColNum && obj.rowId >= this.tileRowNum)
					{
						throw new Error("MapController::getTile: There is no Tile with colId=" + obj.colId + "and rowId=" + obj.rowId);
					}
					objTile = this.getTile(obj.colId,obj.rowId);
					if(objTile)
					{
						if(obj is MapBlocker)
						{
							objTile.assignMapBlocker(obj as MapBlocker);
						}
						else
						{
							objTile.assignMapObject(obj);
						}
					}
				}
			}
		}
		
		private function destroyMapObjects() : void
		{
			var i:uint = 0;
			if(this._mapObjects)
			{
				for(i = 0; i < this._mapObjects.length; i++)
				{
					this._mapObjects[i].dispose();
					this.removeMapObjectFromStage(this._mapObjects[i]);
				}
				this._mapObjects = null;
				this._mobileEnemies = null;
			}
		}
		
		private function addMapObjectOnStage(obj:MapObject) : void
		{
			this._objContainerMc.addChild(obj);
			obj.x = GameConstants.TILE_WIDTH / 2 + GameConstants.TILE_WIDTH * obj.colId;
			obj.y = GameConstants.TILE_HEIGHT / 2 + GameConstants.TILE_HEIGHT * obj.rowId;
		}
		
		private function removeMapObjectFromStage(obj:MapObject) : void
		{
			this._objContainerMc.removeChild(obj);
		}
		
		private function move() : void
		{
			var nextTile:Tile = null;
			var currentColRef:uint = Boolean(this._grognak)?uint(this._grognak.colId):uint(this._currentCenteredTile.colId);
			var currentRowRef:uint = Boolean(this._grognak)?uint(this._grognak.rowId):uint(this._currentCenteredTile.rowId);
			switch(this._direction)
			{
				case LEFT_DIRECTION:
					nextTile = this.getTile(currentColRef - 1,currentRowRef);
					break;
				case RIGHT_DIRECTION:
					nextTile = this.getTile(currentColRef + 1,currentRowRef);
					break;
				case UP_DIRECTION:
					nextTile = this.getTile(currentColRef,currentRowRef - 1);
					break;
				case DOWN_DIRECTION:
					nextTile = this.getTile(currentColRef,currentRowRef + 1);
					break;
				case NO_DIRECTION:
					nextTile = null;
			}
			if(this._direction != NO_DIRECTION)
			{
				this.startInputRepeatTimer();
			}
			if(nextTile != null)
			{
				if(this.checkBlocker(nextTile))
				{
					return;
				}
				if(nextTile.tileData.walkable)
				{
					this.centerOnTile(nextTile.colId,nextTile.rowId);
					this.setHeroPosition(nextTile);
					if(this.checkTriggerEvent(nextTile))
					{
						return;
					}
					this.updateMobileEnemiesPosition();
				}
			}
		}
		
		private function startInputRepeatTimer() : void
		{
			eaze(this).delay(GameConstants.mapRepeatInputDelay).onComplete(this.move);
		}
		
		private function stopInputRepeatTimer() : void
		{
			eaze(this).killTweens();
		}
		
		private function createHero(defaultTile:Tile, data:MapHeroData) : void
		{
			this._grognak = new GrognakView(this._heroContainerMc,data);
			this._heroContainerMc.addChild(this._grognak);
			this.setHeroPosition(defaultTile);
		}
		
		private function destroyHero() : void
		{
			if(this._grognak)
			{
				this._heroContainerMc.removeChild(this._grognak);
				this._grognak = null;
			}
		}
		
		private function setHeroPosition(tile:Tile) : void
		{
			if(this._grognak)
			{
				this._prevHeroPosition.x = this._grognak.colId;
				this._prevHeroPosition.y = this._grognak.rowId;
				this._grognak.setTilePosition(tile.colId,tile.rowId);
				this._grognak.x = tile.x;
				this._grognak.y = tile.y;
				this.checkLocation(tile);
			}
		}
		
		private function checkLocation(tile:Tile) : void
		{
			var currentTile:Tile = null;
			var locationName:String = null;
			var j:int = 0;
			for(var i:int = tile.rowId - 1; i <= tile.rowId + 1; i++)
			{
				if(i >= 0 && i < this.tileRowNum)
				{
					for(j = tile.colId - 1; j <= tile.colId + 1; j++)
					{
						if(j >= 0 && j < this.tileColNum)
						{
							currentTile = this._tiles[i][j];
							if(currentTile.hasMapObject)
							{
								if(currentTile.mapObject is MapEnemy)
								{
									locationName = MapEnemy(currentTile.mapObject).enemyData.name != ""?MapEnemy(currentTile.mapObject).enemyData.name:MapEnemy(currentTile.mapObject).enemyData.locationName;
									dispatchEvent(new EventWithParams(MapEvents.LOCATION_UPDATE,{"locationName":locationName}));
									return;
								}
								if(currentTile.mapObject is MapLocation)
								{
									locationName = MapLocation(currentTile.mapObject).locationData.locationName;
									dispatchEvent(new EventWithParams(MapEvents.LOCATION_UPDATE,{"locationName":locationName}));
									return;
								}
							}
						}
					}
					locationName = !!tile.hasMapBlocker?tile.mapBlocker.blockerData.locationName:tile.tileData.name;
					dispatchEvent(new EventWithParams(MapEvents.LOCATION_UPDATE,{"locationName":locationName}));
				}
			}
		}
		
		private function checkTriggerEvent(tile:Tile) : Boolean
		{
			var locationName:String = null;
			var enemyObj:MapEnemy = null;
			var combatEvent:CombatEvent = null;
			var locationObj:MapLocation = null;
			var event:MapEvent = null;
			if(tile.mapObject)
			{
				if(tile.mapObject is MapEnemy)
				{
					GamePersistantData.prevHeroPosition = this._prevHeroPosition;
					enemyObj = MapEnemy(tile.mapObject);
					locationName = enemyObj.enemyData.locationName != ""?enemyObj.enemyData.locationName:tile.tileData.name;
					combatEvent = enemyObj.enemyData.event;
					this.delayTriggerEvent(new EventWithParams(MapEvents.TRIGGER_COMBAT_EVENT,{
						"locationName":locationName,
						"combatEvent":combatEvent
					}));
					SoundManager.instance.playSound(SoundList.SOUND_MAP_COMBAT);
					return true;
				}
				if(tile.mapObject is MapLocation)
				{
					GamePersistantData.prevHeroPosition = this._prevHeroPosition;
					locationObj = MapLocation(tile.mapObject);
					if(!locationObj.cleared)
					{
						locationName = locationObj.locationData.locationName;
						event = locationObj.locationData.event;
						if(locationObj.hasCombatEvent)
						{
							SoundManager.instance.playSound(SoundList.SOUND_MAP_COMBAT);
							this.delayTriggerEvent(new EventWithParams(MapEvents.TRIGGER_COMBAT_EVENT,{
								"locationName":locationName,
								"combatEvent":event
							}));
							return true;
						}
						if(locationObj.hasInteractionEvent)
						{
							SoundManager.instance.playSound(SoundList.SOUND_MAP_INTERACTION);
							this.delayTriggerEvent(new EventWithParams(MapEvents.TRIGGER_INTERACTION_EVENT,{
								"interactionEvent":event,
								"locationName":locationName,
								"locationPortrait":locationObj.locationData.portrait,
								"locationDescription":locationObj.locationData.description
							}));
							return true;
						}
					}
				}
			}
			return false;
		}
		
		private function delayTriggerEvent(e:EventWithParams) : void
		{
			this.removeInputListeners();
			eaze(this).delay(GameConstants.mapTriggerEventDelay).onComplete(dispatchEvent,e);
		}
		
		private function checkBlocker(tile:Tile) : Boolean
		{
			var needTriggerEvent:Boolean = false;
			if(tile.mapBlocker)
			{
				needTriggerEvent = tile.mapBlocker.blockerData.explanation != "";
				if(!tile.mapBlocker.unblocked)
				{
					if(needTriggerEvent)
					{
						dispatchEvent(new EventWithParams(MapEvents.TRIGGER_BLOCKER_EVENT,{"explanation":tile.mapBlocker.blockerData.explanation}));
					}
					return true;
				}
				return false;
			}
			return false;
		}
		
		private function onHeroOnShip(e:EventWithParams) : void
		{
			var pos:Point = e.params.position;
			var tile:Tile = this.getTile(pos.x,pos.y);
			this.centerOnTile(pos.x,pos.y);
			this._grognak.x = tile.x;
			this._grognak.y = tile.y;
			this._shipController.continueTravelSequence();
		}
		
		private function onShipPositionUpdate(e:EventWithParams) : void
		{
			var pos:Point = e.params.position;
			var tile:Tile = this.getTile(pos.x,pos.y);
			this.centerOnTile(pos.x,pos.y);
			this._ship.setTilePosition(pos.x,pos.y);
			this._ship.x = tile.x;
			this._ship.y = tile.y;
			this._grognak.x = this._ship.x;
			this._grognak.y = this._ship.y;
			this.checkLocation(tile);
		}
		
		private function onHeroOutOfShip(e:EventWithParams) : void
		{
			var pos:Point = e.params.position;
			var tile:Tile = this.getTile(pos.x,pos.y);
			var isNorth:Boolean = e.params.isNorth;
			SoundManager.instance.stopSound(SoundList.MUSIC_MAP_SHIP_TRAVEL);
			var tileToGo:Tile = this.getAdjacentWalkableTile(tile);
			if(tileToGo != null)
			{
				this.centerOnTile(tileToGo.colId,tileToGo.rowId);
				this._grognak.setTilePosition(tileToGo.colId,tileToGo.rowId);
				this._grognak.x = tileToGo.x;
				this._grognak.y = tileToGo.y;
				this._shipController.dispose();
				this._shipController = null;
				GamePersistantData.saveShipMapPosition(tile.colId,tile.rowId);
				GamePersistantData.setShipNorthDocksStoryCondition(isNorth);
				this.addInputListeners();
				SoundManager.instance.startSound(SoundList.MUSIC_WORLD_MAP_SCREEN);
				return;
			}
			throw new Error("There is no walkable tile where Grognak can go! He\'s still in the ship...");
		}
		
		private function updateMobileEnemiesPosition() : void
		{
			var enemy:MapEnemy = null;
			var nextPositionId:uint = 0;
			var nextPosition:Point = null;
			var currentTile:Tile = null;
			var heroTile:Tile = null;
			for(var i:uint = 0; i < this._mobileEnemies.length; i++)
			{
				enemy = this._mobileEnemies[i];
				currentTile = this.getTile(enemy.colId,enemy.rowId);
				currentTile.unassignMapObject();
				nextPositionId = enemy.enemyData.getNextPositionId(enemy.pathId,enemy.pathPositionId);
				nextPosition = enemy.enemyData.getPosition(enemy.pathId,nextPositionId);
				enemy.setTilePosition(nextPosition.x,nextPosition.y,nextPositionId);
				GamePersistantData.setMobileEnemyPositionId(enemy.enemyData,nextPositionId);
				currentTile = this.getTile(enemy.colId,enemy.rowId);
				currentTile.assignMapObject(enemy);
				enemy.x = currentTile.x;
				enemy.y = currentTile.y;
				heroTile = this.getTile(this._grognak.colId,this._grognak.rowId);
				this.checkLocation(heroTile);
				this.checkTriggerEvent(heroTile);
			}
		}
		
		private function saveData() : void
		{
			GamePersistantData.saveHeroMapPosition(this.currentHeroTile);
		}
		
		public function dispose() : void
		{
			this.saveData();
			this._mapData = null;
			this._mapHeroData = null;
			this._mapObjectsData = null;
			this.stopInputRepeatTimer();
			this.removeInputListeners();
			this._direction = NO_DIRECTION;
			this.destroyHero();
			this.destroyTiles();
			this.destroyMapObjects();
			this.destroyMapLayers();
			this._ship = null;
		}
	}
}
