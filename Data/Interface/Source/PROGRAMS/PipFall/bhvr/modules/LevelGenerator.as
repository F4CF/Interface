package bhvr.modules
{
	import bhvr.constants.GameConstants;
	import flash.display.MovieClip;
	import bhvr.data.ScreenData;
	import bhvr.views.InteractiveObject;
	import bhvr.utils.MathUtil;
	import bhvr.debug.Log;
	
	public class LevelGenerator
	{
		 
		
		private var _assets:MovieClip;
		
		private var _screensData:Vector.<ScreenData>;
		
		private var _poolA:bhvr.modules.DataPool;
		
		private var _poolB:bhvr.modules.DataPool;
		
		private var _poolC:bhvr.modules.DataPool;
		
		private var _currentScreenId:int;
		
		private const INVALID_SCREEN:int = -1;
		
		public function LevelGenerator(assets:MovieClip)
		{
			super();
			this._assets = assets;
			this.resetData();
			this._poolA = new bhvr.modules.DataPool();
			this._poolA.add(InteractiveObject.NONE,GameConstants.weightGroupANone);
			this._poolA.add(InteractiveObject.NONE,GameConstants.weightGroupANone);
			this._poolA.add(InteractiveObject.SWINGING_ROPE,GameConstants.weightGroupARope);
			this._poolB = new bhvr.modules.DataPool();
			this._poolB.add(InteractiveObject.RADIOACTIVE_POOL,GameConstants.weightGroupBRadioactivePool);
			this._poolB.add(InteractiveObject.CRABS,GameConstants.weightGroupBCrabs);
			this._poolB.add(InteractiveObject.RADIATION_CLOUD,GameConstants.weightGroupBRadiationCloud);
			this._poolC = new bhvr.modules.DataPool();
			this._poolC.add(InteractiveObject.ONE_LANDMINE,GameConstants.weightGroupCOneMine);
			this._poolC.add(InteractiveObject.THREE_LANDMINE,GameConstants.weightGroupCThreeMine);
			this._poolC.add(InteractiveObject.ONE_ROLLING_BARREL,GameConstants.weightGroupCOneBarrel);
			this._poolC.add(InteractiveObject.TWO_ROLLING_BARREL,GameConstants.weightGroupCTwoBarrel);
			this._poolC.add(InteractiveObject.THREE_ROLLING_BARREL,GameConstants.weightGroupCThreeBarrel);
			this._poolC.add(InteractiveObject.MUTATED_BIRD,GameConstants.weightGroupCBird);
			this._poolC.add(InteractiveObject.MUTATED_MONSTER,GameConstants.weightGroupCMonster);
		}
		
		public static function getScreenId(id:int) : uint
		{
			if(id < 0)
			{
				return GameConstants.numScreen + id;
			}
			if(id > GameConstants.numScreen - 1)
			{
				return id - GameConstants.numScreen;
			}
			return id;
		}
		
		public function get screensData() : Vector.<ScreenData>
		{
			return this._screensData;
		}
		
		public function resetData() : void
		{
			this._screensData = new Vector.<ScreenData>();
			this._currentScreenId = this.INVALID_SCREEN;
		}
		
		public function randomizeData() : void
		{
			this.resetData();
			this.createAllScreensData();
			this.generateFirstScreenData();
			this.generateBobbleHeadScreensData();
			this.generateTunnelScreensData();
			this.generateRemainingData();
		}
		
		private function createAllScreensData() : void
		{
			var screenData:ScreenData = null;
			for(var i:uint = 0; i < GameConstants.numScreen; i++)
			{
				screenData = new ScreenData(i);
				this._screensData.push(screenData);
			}
		}
		
		private function generateFirstScreenData() : void
		{
			this._screensData[0].hazardGroupC = InteractiveObject.ONE_LANDMINE;
			this._screensData[0].tunnelEntrance = MathUtil.random(InteractiveObject.TUNNEL_LEFT_WALL,InteractiveObject.TUNNEL_RIGHT_WALL);
			this._screensData[0].isGenerated = true;
		}
		
		private function generateBobbleHeadScreensData() : void
		{
			var validBobbleHeadFound:Boolean = false;
			var distfromFirstScreenRightSide:int = MathUtil.random(GameConstants.minDistFirstScreenAndBobbleHead,GameConstants.maxDistFirstScreenAndBobbleHead);
			var distfromFirstScreenLeftSide:int = MathUtil.random(GameConstants.minDistFirstScreenAndBobbleHead,GameConstants.maxDistFirstScreenAndBobbleHead);
			for(var i:uint = 0; i < GameConstants.numBobbleHead; i++)
			{
				Log.info("BoobbleHead Id: " + i);
				Log.info("-----------------");
				validBobbleHeadFound = false;
				while(!validBobbleHeadFound)
				{
					validBobbleHeadFound = this.findValidBobbleHeadScreen(i,distfromFirstScreenRightSide,distfromFirstScreenLeftSide);
				}
			}
		}
		
		private function findValidBobbleHeadScreen(bobbleHeadScreenId:uint, distfromFirstScreenRightSide:int, distfromFirstScreenLeftSide:int) : Boolean
		{
			var screenId:uint = 0;
			if(bobbleHeadScreenId == 0)
			{
				screenId = distfromFirstScreenRightSide;
			}
			else if(bobbleHeadScreenId == GameConstants.numBobbleHead - 1)
			{
				screenId = GameConstants.numScreen - distfromFirstScreenLeftSide;
			}
			else
			{
				screenId = MathUtil.random(distfromFirstScreenRightSide + 2,GameConstants.numScreen - distfromFirstScreenLeftSide - 2);
			}
			if(this._screensData[screenId].hazardGroupC != InteractiveObject.BOBBLE_HEAD && this._screensData[getScreenId(screenId - 1)].hazardGroupC != InteractiveObject.BOBBLE_HEAD && this._screensData[getScreenId(screenId + 1)].hazardGroupC != InteractiveObject.BOBBLE_HEAD)
			{
				this._screensData[screenId].hazardGroupB = InteractiveObject.RADIATION_CLOUD;
				this._screensData[screenId].hazardGroupC = InteractiveObject.BOBBLE_HEAD;
				this._screensData[screenId].isGenerated = true;
				Log.info("BobbleHead screenId:" + screenId + " is a success!");
				return true;
			}
			Log.info("BobbleHead screenId:" + screenId + " is a fail... continue searching...");
			return false;
		}
		
		private function generateTunnelScreensData() : void
		{
			var entranceId:uint = 0;
			var exitScreenDeltaId:uint = 0;
			for(var i:uint = 0; i <= GameConstants.tunnelGenLoops; i++)
			{
				entranceId = i == 0?uint(0):uint(this.generateTunnelEntranceData());
				exitScreenDeltaId = MathUtil.random(GameConstants.tunnelMinDist,GameConstants.tunnelMaxDist) * GameConstants.TUNNEL_JUMP_SCREEN_NUM;
				this.generateTunnelExitData(this._screensData[entranceId],exitScreenDeltaId);
			}
		}
		
		private function generateTunnelEntranceData() : int
		{
			var validEntranceFound:int = 0;
			var screenId:uint = MathUtil.random(0,GameConstants.numScreen - 1);
			if(!this._screensData[screenId].isGenerated)
			{
				this._screensData[screenId].tunnelEntrance = MathUtil.random(InteractiveObject.TUNNEL_LEFT_WALL,InteractiveObject.TUNNEL_RIGHT_WALL);
				this._screensData[screenId].hazardGroupC = this._poolC.getRandomData();
				this._screensData[screenId].isGenerated = true;
				Log.info("Tunnel entrance screenId:" + screenId + " is a success!");
				return screenId;
			}
			Log.info("Tunnel entrance screenId:" + screenId + " is a fail... continue searching...");
			validEntranceFound = this.INVALID_SCREEN;
			if(validEntranceFound == this.INVALID_SCREEN)
			{
				validEntranceFound = this.generateTunnelEntranceData();
			}
			return validEntranceFound;
		}
		
		private function generateTunnelExitData(entranceScreenData:ScreenData, randomDeltaId:uint) : Boolean
		{
			var validExitFound:Boolean = false;
			var entranceScreenId:uint = entranceScreenData.id;
			var exitScreenId:uint = entranceScreenData.tunnelEntrance == InteractiveObject.TUNNEL_LEFT_WALL?uint(getScreenId(entranceScreenId + randomDeltaId)):uint(getScreenId(entranceScreenId - randomDeltaId));
			if(this._screensData[exitScreenId].tunnelEntrance == InteractiveObject.NONE)
			{
				if(this._screensData[exitScreenId].hazardGroupC != InteractiveObject.BOBBLE_HEAD)
				{
					this._screensData[exitScreenId].tunnelEntrance = entranceScreenData.tunnelEntrance == InteractiveObject.TUNNEL_LEFT_WALL?int(InteractiveObject.TUNNEL_RIGHT_WALL):int(InteractiveObject.TUNNEL_LEFT_WALL);
					this._screensData[exitScreenId].hazardGroupC = this._poolC.getRandomData();
					this._screensData[exitScreenId].isGenerated = true;
					Log.info("Tunnel exit screenId:" + exitScreenId + " is a success!");
				}
				else
				{
					Log.info("Tunnel exit screenId:" + exitScreenId + " is a fail... continue searching...");
					validExitFound = false;
					while(!validExitFound)
					{
						validExitFound = this.generateTunnelExitData(entranceScreenData,randomDeltaId + GameConstants.TUNNEL_JUMP_SCREEN_NUM);
					}
				}
			}
			else
			{
				Log.info("Tunnel exit screenId:" + exitScreenId + " already exist - Let\'s Skip -");
			}
			return true;
		}
		
		private function generateRemainingData() : void
		{
			var hazardB:int = 0;
			for(var i:uint = 0; i < this._screensData.length; i++)
			{
				if(!this._screensData[i].isGenerated)
				{
					hazardB = this._poolB.getRandomData();
					this._screensData[i].hazardGroupB = hazardB;
					this._screensData[i].isGenerated = true;
					switch(hazardB)
					{
						case InteractiveObject.RADIOACTIVE_POOL:
							this._screensData[i].hazardGroupA = InteractiveObject.SWINGING_ROPE;
							this._screensData[i].hazardGroupC = this._poolC.getRandomData();
							break;
						case InteractiveObject.CRABS:
							this._screensData[i].hazardGroupA = this._poolA.getRandomData();
							break;
						case InteractiveObject.RADIATION_CLOUD:
							this._screensData[i].hazardGroupA = this._poolA.getRandomData();
							this._screensData[i].hazardGroupC = this._poolC.getRandomData();
							break;
						default:
							this._screensData[i].isGenerated = false;
							Log.error("No Hazard from group B has been generated for screen: " + i);
					}
				}
			}
		}
	}
}
