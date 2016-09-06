package bhvr.controller
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.data.ScreenData;
	import bhvr.views.Player;
	import bhvr.views.InteractiveObject;
	import bhvr.data.GamePersistantData;
	import bhvr.constants.GameConstants;
	import flash.events.Event;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.views.Rope;
	import bhvr.views.RadioActivePool;
	import bhvr.views.Crabs;
	import bhvr.views.RadiationCloud;
	import bhvr.views.BobbleHead;
	import bhvr.views.LandMines;
	import bhvr.views.Barrels;
	import bhvr.views.MutatedMonster;
	import bhvr.views.MutatedBird;
	import bhvr.views.Ladder;
	import bhvr.views.TunnelWall;
	import bhvr.debug.Log;
	import bhvr.utils.FlashUtil;
	import bhvr.events.GameEvents;
	import bhvr.events.EventWithParams;
	import aze.motion.eaze;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.modules.LevelGenerator;
	import bhvr.utils.Collision;
	import flash.geom.Point;
	
	public class LevelController extends EventDispatcher
	{
		 
		
		private var _assets:MovieClip;
		
		private var _data:Vector.<ScreenData>;
		
		private var _currentScreenId:int;
		
		private var _player:Player;
		
		private var _interactiveObjects:Vector.<InteractiveObject>;
		
		private var _timeIsOver:Boolean;
		
		private const TUNNEL_TRAVEL_DELAY:Number = 0.5;
		
		private const TUNNEL_TRAVEL_BLUR_X:Number = 2;
		
		private const TUNNEL_TRAVEL_BLUR_Y:Number = 0;
		
		public function LevelController(assets:MovieClip, data:Vector.<ScreenData>)
		{
			super();
			this._assets = assets;
			this._data = data;
			this._currentScreenId = -1;
			this._assets.playerContainerMc.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
			this._assets.windLeftMc.visible = false;
			this._assets.windRightMc.visible = false;
		}
		
		public function get playerCanClimbUp() : Boolean
		{
			return this._player && this._player.canClimbUp;
		}
		
		public function get playerCanClimbDown() : Boolean
		{
			return this._player && this._player.canClimbDown;
		}
		
		private function get gameIsOver() : Boolean
		{
			return GamePersistantData.lifeNum == 0 || this._timeIsOver || GamePersistantData.bobbleHeadNum == GameConstants.numBobbleHead;
		}
		
		public function setInitialScreen() : void
		{
			this.goToStartScreen();
			this._timeIsOver = false;
		}
		
		public function start() : void
		{
			this.addPlayer();
		}
		
		public function stop() : void
		{
			this._player.stop();
		}
		
		public function pause() : void
		{
			this._assets.playerContainerMc.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			for(var i:uint = 0; i < InteractiveObject.NUMBER_OF_OBSTACLES; i++)
			{
				if(this._interactiveObjects[i] != null)
				{
					this._interactiveObjects[i].pause();
				}
			}
			if(this._player)
			{
				this._player.pause();
			}
			this._assets.windLeftMc.stop();
			this._assets.windRightMc.stop();
		}
		
		public function resume() : void
		{
			this._assets.playerContainerMc.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
			for(var i:uint = 0; i < InteractiveObject.NUMBER_OF_OBSTACLES; i++)
			{
				if(this._interactiveObjects[i] != null)
				{
					this._interactiveObjects[i].resume();
				}
			}
			if(this._player)
			{
				this._player.resume();
			}
			if(!CompanionAppMode.isOn)
			{
				this._assets.windLeftMc.play();
				this._assets.windRightMc.play();
			}
		}
		
		private function onUpdate(e:Event) : void
		{
			var obj:InteractiveObject = null;
			if(this._player != null && !this.gameIsOver)
			{
				if(this._interactiveObjects != null)
				{
					if(this._player.location == Player.TUNNEL_LOCATION)
					{
						this.checkCollisionWithWall();
					}
					else if(this._player.location == Player.OUTSIDE_LOCATION)
					{
						this.checkCollisionWithBobbleHead();
						this.checkCollisionWithRope();
						this.checkCollisionWithRadioActivePool();
						this.checkCollisionWithCrabs();
						this.checkCollisionWithLandMines();
						this.checkCollisionWithRollingBarrels();
						this.checkCollisionWithRadiationCloud();
						this.checkCollisionWithMutatedMonster();
						this.checkCollisionWithMutatedBird();
					}
					else if(this._player.location == Player.LADDER_LOCATION)
					{
						this.checkCollisionWithRollingBarrels();
						this.checkCollisionWithMutatedMonster();
						this.checkCollisionWithMutatedBird();
					}
					if(!this.gameIsOver)
					{
						this.checkCollisionWithLadder();
					}
				}
				if(this._player.location == Player.OUTSIDE_LOCATION || this._player.location == Player.TUNNEL_LOCATION)
				{
					this.checkChangeScreen();
				}
			}
		}
		
		private function clean() : void
		{
			var i:uint = 0;
			if(this._assets.backgroundContainerMc.numChildren > 0)
			{
				this._assets.backgroundContainerMc.removeChildAt(0);
			}
			if(this._interactiveObjects != null)
			{
				for(i = 0; i < InteractiveObject.NUMBER_OF_OBSTACLES; i++)
				{
					if(this._interactiveObjects[i] != null)
					{
						this._interactiveObjects[i].dispose();
					}
				}
				this._interactiveObjects = null;
			}
		}
		
		private function buildScreen(screenId:int) : void
		{
			var data:ScreenData = null;
			var mc:MovieClip = null;
			var rope:Rope = null;
			var radioactivePool:RadioActivePool = null;
			var crabs:Crabs = null;
			var cloud:RadiationCloud = null;
			var bobbleHead:BobbleHead = null;
			var mines:LandMines = null;
			var barrels:Barrels = null;
			var monster:MutatedMonster = null;
			var bird:MutatedBird = null;
			var ladder:Ladder = null;
			var wall:TunnelWall = null;
			this.clean();
			this._currentScreenId = screenId;
			this._interactiveObjects = new Vector.<InteractiveObject>(InteractiveObject.NUMBER_OF_OBSTACLES);
			data = this._data[this._currentScreenId];
			var linkageId:String = "";
			Log.info("Current ScreenId = " + screenId);
			mc = FlashUtil.getLibraryItem(this._assets,"Background" + data.background) as MovieClip;
			this._assets.backgroundContainerMc.addChild(mc);
			if(data.hazardGroupA == InteractiveObject.SWINGING_ROPE)
			{
				rope = new Rope(this._assets.objectsContainerMc);
				this._interactiveObjects[InteractiveObject.SWINGING_ROPE] = rope;
			}
			if(data.hazardGroupB != InteractiveObject.NONE)
			{
				switch(data.hazardGroupB)
				{
					case InteractiveObject.RADIOACTIVE_POOL:
						radioactivePool = new RadioActivePool(this._assets.objectsContainerMc);
						this._interactiveObjects[InteractiveObject.RADIOACTIVE_POOL] = radioactivePool;
						break;
					case InteractiveObject.CRABS:
						crabs = new Crabs(this._assets.objectsContainerMc);
						this._interactiveObjects[InteractiveObject.CRABS] = crabs;
						break;
					case InteractiveObject.RADIATION_CLOUD:
						cloud = new RadiationCloud(this._assets.objectsContainerMc);
						this._interactiveObjects[InteractiveObject.RADIATION_CLOUD] = cloud;
						break;
					default:
						linkageId = InteractiveObject.getLinkageId(data.hazardGroupB);
						mc = FlashUtil.getLibraryItem(this._assets,linkageId) as MovieClip;
						this._assets.objectsContainerMc.addChild(mc);
				}
			}
			if(data.hazardGroupC != InteractiveObject.NONE)
			{
				switch(data.hazardGroupC)
				{
					case InteractiveObject.BOBBLE_HEAD:
						bobbleHead = new BobbleHead(this._assets.objectsContainerMc);
						this._interactiveObjects[InteractiveObject.BOBBLE_HEAD] = bobbleHead;
						break;
					case InteractiveObject.ONE_LANDMINE:
					case InteractiveObject.THREE_LANDMINE:
						mines = new LandMines(this._assets.objectsContainerMc,data.hazardGroupC);
						this._interactiveObjects[data.hazardGroupC] = mines;
						break;
					case InteractiveObject.ONE_ROLLING_BARREL:
					case InteractiveObject.TWO_ROLLING_BARREL:
					case InteractiveObject.THREE_ROLLING_BARREL:
						barrels = new Barrels(this._assets.objectsContainerMc,data.hazardGroupC);
						this._interactiveObjects[data.hazardGroupC] = barrels;
						break;
					case InteractiveObject.MUTATED_MONSTER:
						monster = new MutatedMonster(this._assets.objectsContainerMc);
						this._interactiveObjects[data.hazardGroupC] = monster;
						break;
					case InteractiveObject.MUTATED_BIRD:
						bird = new MutatedBird(this._assets.objectsContainerMc);
						this._interactiveObjects[data.hazardGroupC] = bird;
						break;
					default:
						linkageId = InteractiveObject.getLinkageId(data.hazardGroupC);
						mc = FlashUtil.getLibraryItem(this._assets,linkageId) as MovieClip;
						this._assets.objectsContainerMc.addChild(mc);
				}
			}
			if(data.tunnelEntrance != InteractiveObject.NONE)
			{
				ladder = new Ladder(this._assets.objectsContainerMc);
				this._interactiveObjects[InteractiveObject.LADDER] = ladder;
				wall = new TunnelWall(this._assets.objectsContainerMc,data.tunnelEntrance);
				this._interactiveObjects[data.tunnelEntrance] = wall;
			}
		}
		
		public function addPlayer() : void
		{
			this._player = new Player(this._assets.playerContainerMc);
			this._player.addEventListener(GameEvents.PLAYER_DEAD,dispatchEvent,false,0,true);
			this._player.addEventListener(GameEvents.PLAYER_LOOSE,dispatchEvent,false,0,true);
			this._player.addEventListener(GameEvents.PLAYER_WIN,dispatchEvent,false,0,true);
			this._player.setPosition(GameConstants.PLAYER_POSITION_FROM_SCREEN_EDGE,GameConstants.OUTSIDE_FLOOR_POSITION);
			this._player.start();
		}
		
		public function removePlayer() : void
		{
			if(this._player != null)
			{
				this._player.removeEventListener(GameEvents.PLAYER_DEAD,dispatchEvent);
				this._player.removeEventListener(GameEvents.PLAYER_LOOSE,dispatchEvent);
				this._player.removeEventListener(GameEvents.PLAYER_WIN,dispatchEvent);
				this._player.dispose();
				this._player = null;
			}
		}
		
		private function damagePlayer() : void
		{
			GamePersistantData.removeLife();
			dispatchEvent(new EventWithParams(GameEvents.PLAYER_DAMAGED));
			if(GamePersistantData.lifeNum > 0)
			{
				this._player.damage();
			}
			else
			{
				this._player.kill();
			}
		}
		
		public function setTimerOver() : void
		{
			this._timeIsOver = true;
			this._player.loose();
		}
		
		public function setVictory() : void
		{
			this._player.win();
		}
		
		private function goToStartScreen() : void
		{
			this.goToScreen(0);
		}
		
		public function goToNextScreen() : void
		{
			this.goToScreen(this._currentScreenId + 1);
			this._player.setPosition(GameConstants.PLAYER_POSITION_FROM_SCREEN_EDGE,this._player.position.y);
		}
		
		public function goToPreviousScreen() : void
		{
			this.goToScreen(this._currentScreenId - 1);
			this._player.setPosition(GameConstants.STAGE_WIDTH - GameConstants.PLAYER_POSITION_FROM_SCREEN_EDGE,this._player.position.y);
		}
		
		public function goToNextTunnel(fastTravel:Boolean = false) : void
		{
			if(fastTravel)
			{
				this.onFastTravel(GameConstants.TUNNEL_JUMP_SCREEN_NUM,false);
				this.setFastTravelEffect(true,false);
			}
			else
			{
				this.goToScreen(this._currentScreenId + GameConstants.TUNNEL_JUMP_SCREEN_NUM);
			}
			this._player.setPosition(GameConstants.PLAYER_POSITION_FROM_SCREEN_EDGE,this._player.position.y);
		}
		
		public function goToPreviousTunnel(fastTravel:Boolean = false) : void
		{
			if(fastTravel)
			{
				this.onFastTravel(GameConstants.TUNNEL_JUMP_SCREEN_NUM,true);
				this.setFastTravelEffect(true,true);
			}
			else
			{
				this.goToScreen(this._currentScreenId - GameConstants.TUNNEL_JUMP_SCREEN_NUM);
			}
			this._player.setPosition(GameConstants.STAGE_WIDTH - GameConstants.PLAYER_POSITION_FROM_SCREEN_EDGE,this._player.position.y);
		}
		
		private function onFastTravel(screenNumRemaining:uint, leftDirection:Boolean) : void
		{
			var screenId:uint = 0;
			if(screenNumRemaining > 0)
			{
				screenId = !!leftDirection?uint(this._currentScreenId - 1):uint(this._currentScreenId + 1);
				this.goToScreen(screenId);
				if(screenNumRemaining > 1)
				{
					eaze(this).delay(this.TUNNEL_TRAVEL_DELAY).onComplete(this.onFastTravel,screenNumRemaining - 1,leftDirection);
				}
				else
				{
					this.onFastTravel(screenNumRemaining - 1,leftDirection);
				}
			}
			else
			{
				eaze(this).killTweens();
				this.setFastTravelEffect(false,leftDirection);
			}
		}
		
		private function setFastTravelEffect(isOn:Boolean, leftDirection:Boolean) : void
		{
			var blur:BlurFilter = null;
			if(leftDirection)
			{
				if(CompanionAppMode.isOn)
				{
					this._assets.windLeftMc.stop();
				}
				this._assets.windLeftMc.visible = isOn;
			}
			else
			{
				if(CompanionAppMode.isOn)
				{
					this._assets.windRightMc.stop();
				}
				this._assets.windRightMc.visible = isOn;
			}
			this._player.slowMotion = isOn;
			this._player.setVisibility(!isOn);
			if(!CompanionAppMode.isOn)
			{
				if(isOn)
				{
					blur = new BlurFilter();
					blur.blurX = this.TUNNEL_TRAVEL_BLUR_X;
					blur.blurY = this.TUNNEL_TRAVEL_BLUR_Y;
					blur.quality = BitmapFilterQuality.MEDIUM;
					this._assets.filters = [blur];
				}
				else
				{
					this._assets.filters = null;
				}
			}
		}
		
		public function goToScreen(param1:int) : void
		{
			if(param1 < 0 || param1 > GameConstants.numScreen - 1)
			{
				SoundManager.instance.startLongSound(SoundList.TRANSITION_SOUND_ID);
			}
			param1 = LevelGenerator.getScreenId(param1);
			this.buildScreen(param1);
		}
		
		private function checkChangeScreen() : void
		{
			if(this._player.position.x + this._player.thickness / 2 > GameConstants.STAGE_WIDTH)
			{
				if(this._player.location == Player.OUTSIDE_LOCATION)
				{
					this.goToNextScreen();
				}
				else
				{
					this.goToNextTunnel(true);
				}
			}
			else if(this._player.position.x - this._player.thickness / 2 < 0)
			{
				if(this._player.location == Player.OUTSIDE_LOCATION)
				{
					this.goToPreviousScreen();
				}
				else
				{
					this.goToPreviousTunnel(true);
				}
			}
		}
		
		private function checkCollisionWithLadder() : void
		{
			var ladder:Ladder = null;
			var couldClimbUp:Boolean = this._player.canClimbUp;
			var couldClimbDown:Boolean = this._player.canClimbDown;
			if(this._interactiveObjects[InteractiveObject.LADDER] != null)
			{
				ladder = this._interactiveObjects[InteractiveObject.LADDER] as Ladder;
				if(this._player.position.x <= ladder.snapPosition + ladder.thickness / Ladder.LADDER_DELTA_DETECTION && this._player.position.x >= ladder.snapPosition - ladder.thickness / Ladder.LADDER_DELTA_DETECTION)
				{
					if(this._player.location == Player.OUTSIDE_LOCATION)
					{
						this._player.canClimbDown = true;
						this._player.canClimbUp = false;
						this._player.canRun = true;
						this._player.canJump = true;
					}
					else if(this._player.location == Player.TUNNEL_LOCATION)
					{
						this._player.canClimbDown = false;
						this._player.canClimbUp = true;
						this._player.canRun = true;
						this._player.canJump = true;
					}
					else if(this._player.location == Player.LADDER_LOCATION)
					{
						if(this._player.position.y <= GameConstants.OUTSIDE_FLOOR_POSITION)
						{
							this._player.canClimbUp = false;
							this._player.canRun = true;
							this._player.canJump = true;
							this._player.setPosition(this._player.position.x,GameConstants.OUTSIDE_FLOOR_POSITION);
							this._player.setLocation(Player.OUTSIDE_LOCATION);
						}
						else if(this._player.position.y >= GameConstants.TUNNEL_FLOOR_POSITION)
						{
							this._player.canClimbDown = false;
							this._player.canRun = true;
							this._player.canJump = true;
							this._player.setPosition(this._player.position.x,GameConstants.TUNNEL_FLOOR_POSITION);
							this._player.setLocation(Player.TUNNEL_LOCATION);
						}
						else
						{
							this._player.canRun = false;
							this._player.canJump = false;
							this._player.canClimbDown = true;
							this._player.canClimbUp = true;
							this._player.setPosition(ladder.snapPosition,this._player.position.y);
						}
					}
				}
				else if(!this.gameIsOver)
				{
					this._player.canClimb = false;
					this._player.canRun = true;
					this._player.canJump = true;
				}
			}
			if(couldClimbUp != this._player.canClimbUp || couldClimbDown != this._player.canClimbDown)
			{
				dispatchEvent(new EventWithParams(GameEvents.PLAYER_CLIMB_STATUS_UPDATE));
			}
		}
		
		private function checkCollisionWithWall() : void
		{
			var wallPosX:Number = NaN;
			var wall:TunnelWall = null;
			if(this._interactiveObjects[InteractiveObject.TUNNEL_LEFT_WALL] != null)
			{
				wall = this._interactiveObjects[InteractiveObject.TUNNEL_LEFT_WALL] as TunnelWall;
			}
			else if(this._interactiveObjects[InteractiveObject.TUNNEL_RIGHT_WALL] != null)
			{
				wall = this._interactiveObjects[InteractiveObject.TUNNEL_RIGHT_WALL] as TunnelWall;
			}
			if(wall != null)
			{
				if(this._player.collider.hitTestObject(wall.collider))
				{
					if(this._player.position.x > wall.position)
					{
						this._player.setPosition(wall.position + (wall.thickness + this._player.thickness) / 2 + TunnelWall.WALL_DELTA_DETECTION,this._player.position.y);
					}
					else
					{
						this._player.setPosition(wall.position - (wall.thickness + this._player.thickness) / 2 - TunnelWall.WALL_DELTA_DETECTION,this._player.position.y);
					}
				}
			}
		}
		
		private function checkCollisionWithBobbleHead() : void
		{
			var bobbleHead:BobbleHead = null;
			if(this._interactiveObjects[InteractiveObject.BOBBLE_HEAD] != null)
			{
				bobbleHead = this._interactiveObjects[InteractiveObject.BOBBLE_HEAD] as BobbleHead;
				if(this._player.collider.hitTestObject(bobbleHead.collider))
				{
					this._data[this._currentScreenId].hazardGroupC = InteractiveObject.NONE;
					GamePersistantData.addBobbleHead();
					GamePersistantData.addLife();
					bobbleHead.collect(GamePersistantData.bobbleHeadNum == GameConstants.numBobbleHead);
					dispatchEvent(new EventWithParams(GameEvents.PLAYER_WIN_LIFE));
					dispatchEvent(new EventWithParams(GameEvents.BOBBLE_HEAD_COLLECTED));
				}
			}
		}
		
		private function checkCollisionWithRope() : void
		{
			var rope:Rope = null;
			if(this._interactiveObjects[InteractiveObject.SWINGING_ROPE] != null)
			{
				if(this._player.state != Player.FALLING_STATE && this._player.state != Player.SWINGING_STATE)
				{
					rope = this._interactiveObjects[InteractiveObject.SWINGING_ROPE] as Rope;
					if(Collision.simpleHitTestPoint(rope.colliderPoint,this._player.collider))
					{
						this._player.swing(rope);
					}
				}
			}
		}
		
		private function checkCollisionWithRadioActivePool() : void
		{
			var pool:RadioActivePool = null;
			if(!this._player.invincible)
			{
				if(this._interactiveObjects[InteractiveObject.RADIOACTIVE_POOL] != null)
				{
					pool = this._interactiveObjects[InteractiveObject.RADIOACTIVE_POOL] as RadioActivePool;
					if(this._player.collider.hitTestObject(pool.collider))
					{
						this.damagePlayer();
					}
				}
			}
		}
		
		private function checkCollisionWithCrabs() : void
		{
			var crabs:Crabs = null;
			var crabColliders:Vector.<MovieClip> = null;
			var crabCollider:MovieClip = null;
			var i:uint = 0;
			if(this._interactiveObjects[InteractiveObject.CRABS] != null)
			{
				crabs = this._interactiveObjects[InteractiveObject.CRABS] as Crabs;
				crabColliders = crabs.crabColliders;
				for(i = 0; i < crabColliders.length; i++)
				{
					crabCollider = crabColliders[i];
					if(this._player.collider.hitTestObject(crabCollider))
					{
						if(this._player.state == Player.JUMPING_STATE || this._player.state == Player.FALLING_STATE)
						{
							this._player.jumpOnObstacle(new Point(crabs.getCrabHeadPosition(i).x,crabs.getCrabHeadPosition(i).y));
							crabCollider.hasPlayerOnHead = true;
						}
						if(!this._player.invincible && crabs.states[i])
						{
							this.damagePlayer();
						}
						break;
					}
					if(crabCollider.hasPlayerOnHead)
					{
						this._player.fallOfObstacle();
						crabCollider.hasPlayerOnHead = false;
					}
				}
				if(this._player.collider.hitTestObject(crabs.collider))
				{
					if(!this._player.invincible)
					{
						this.damagePlayer();
					}
				}
			}
		}
		
		private function checkCollisionWithLandMines() : void
		{
			var objType:int = 0;
			var landMines:LandMines = null;
			var colliders:Vector.<MovieClip> = null;
			var collider:MovieClip = null;
			var i:uint = 0;
			if(this._interactiveObjects[InteractiveObject.ONE_LANDMINE] != null || this._interactiveObjects[InteractiveObject.THREE_LANDMINE] != null)
			{
				objType = this._interactiveObjects[InteractiveObject.ONE_LANDMINE] != null?int(InteractiveObject.ONE_LANDMINE):int(InteractiveObject.THREE_LANDMINE);
				landMines = this._interactiveObjects[objType] as LandMines;
				colliders = landMines.mineColliders;
				for(i = 0; i < colliders.length; i++)
				{
					collider = colliders[i];
					if(collider.isActive)
					{
						if(this._player.collider.hitTestObject(collider))
						{
							landMines.explode(collider.id);
							if(!this._player.invincible)
							{
								this.damagePlayer();
							}
						}
					}
				}
			}
		}
		
		private function checkCollisionWithRollingBarrels() : void
		{
			var objType:int = 0;
			var barrels:Barrels = null;
			var colliders:Vector.<MovieClip> = null;
			var collider:MovieClip = null;
			var i:uint = 0;
			if(this._interactiveObjects[InteractiveObject.ONE_ROLLING_BARREL] != null || this._interactiveObjects[InteractiveObject.TWO_ROLLING_BARREL] != null || this._interactiveObjects[InteractiveObject.THREE_ROLLING_BARREL] != null)
			{
				objType = this._interactiveObjects[InteractiveObject.ONE_ROLLING_BARREL] != null?int(InteractiveObject.ONE_ROLLING_BARREL):this._interactiveObjects[InteractiveObject.TWO_ROLLING_BARREL] != null?int(InteractiveObject.TWO_ROLLING_BARREL):int(InteractiveObject.THREE_ROLLING_BARREL);
				barrels = this._interactiveObjects[objType] as Barrels;
				colliders = barrels.barrelColliders;
				for(i = 0; i < colliders.length; i++)
				{
					collider = colliders[i];
					if(collider.visible)
					{
						if(this._player.collider.hitTestObject(collider))
						{
							if(!this._player.invincible)
							{
								this.damagePlayer();
							}
						}
					}
				}
			}
		}
		
		private function checkCollisionWithRadiationCloud() : void
		{
			var cloud:RadiationCloud = null;
			if(!this._player.invincible)
			{
				if(this._interactiveObjects[InteractiveObject.RADIATION_CLOUD] != null)
				{
					cloud = this._interactiveObjects[InteractiveObject.RADIATION_CLOUD] as RadiationCloud;
					if(this._player.collider.hitTestObject(cloud.collider))
					{
						this.damagePlayer();
					}
				}
			}
		}
		
		private function checkCollisionWithMutatedMonster() : void
		{
			var monster:MutatedMonster = null;
			var colliders:Vector.<MovieClip> = null;
			var collider:MovieClip = null;
			var i:uint = 0;
			if(!this._player.invincible)
			{
				if(this._interactiveObjects[InteractiveObject.MUTATED_MONSTER] != null)
				{
					monster = this._interactiveObjects[InteractiveObject.MUTATED_MONSTER] as MutatedMonster;
					if(this._player.collider.hitTestObject(monster.collider))
					{
						this.damagePlayer();
					}
					colliders = monster.barrelColliders;
					for(i = 0; i < colliders.length; i++)
					{
						collider = colliders[i];
						if(collider.visible)
						{
							if(this._player.collider.hitTestObject(collider))
							{
								this.damagePlayer();
							}
						}
					}
				}
			}
		}
		
		private function checkCollisionWithMutatedBird() : void
		{
			var bird:MutatedBird = null;
			var colliders:Vector.<MovieClip> = null;
			var collider:MovieClip = null;
			var i:uint = 0;
			if(!this._player.invincible)
			{
				if(this._interactiveObjects[InteractiveObject.MUTATED_BIRD] != null)
				{
					bird = this._interactiveObjects[InteractiveObject.MUTATED_BIRD] as MutatedBird;
					colliders = bird.fireBallColliders;
					for(i = 0; i < colliders.length; i++)
					{
						collider = colliders[i];
						if(collider.isActive)
						{
							if(this._player.collider.hitTestObject(collider))
							{
								bird.explodeFireBall(i);
								this.damagePlayer();
							}
						}
					}
				}
			}
		}
		
		public function dispose() : void
		{
			this.stop();
			this._assets.playerContainerMc.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			this.clean();
			this.removePlayer();
			this._data = null;
		}
	}
}
