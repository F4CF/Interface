package bhvr.modules
{
	import flash.display.MovieClip;
	import bhvr.views.Target;
	import bhvr.views.Nuke;
	import bhvr.views.Projectile;
	import bhvr.utils.MathUtil;
	import bhvr.constatnts.GameConstants;
	import bhvr.views.Bomber;
	
	public class NukeGenerator
	{
		 
		
		private var _flashAssets:MovieClip;
		
		private var _targets:Vector.<Target>;
		
		private var _nukesArray:Array;
		
		private var _numSplit:int;
		
		private var _maxNukes:int;
		
		public function NukeGenerator(flashAssets:MovieClip, targets:Vector.<Target>, maxNum:int, canSplitNum:int)
		{
			super();
			this._flashAssets = flashAssets;
			this._targets = targets;
			this._maxNukes = maxNum;
			this._numSplit = canSplitNum;
			this._nukesArray = [];
		}
		
		public function getStartingNukes() : Vector.<Nuke>
		{
			var nuke:Nuke = null;
			var nukeType:int = 0;
			for(var i:uint = 0; i < this._maxNukes; i++)
			{
				nuke = this.getSingleNuke(Projectile.NUKE_TYPE,i < this._numSplit);
				this._nukesArray.push(nuke);
			}
			return Vector.<Nuke>(this.randomize(this._nukesArray));
		}
		
		public function getSingleNuke(type:int, canSplit:Boolean = false) : Nuke
		{
			var nukeCanSplit:Boolean = type == Projectile.NUKE_TYPE && canSplit;
			var nuke:Nuke = new Nuke(this._flashAssets,type);
			var targetId:int = MathUtil.random(0,this._targets.length - 1);
			nuke.target = this._targets[targetId];
			nuke.splitNum = !!nukeCanSplit?int(MathUtil.random(2,4)):int(0);
			nuke.splitHeight = !!nukeCanSplit?Number(MathUtil.random(GameConstants.clusterYMin,GameConstants.clusterYMax)):Number(0);
			return nuke;
		}
		
		public function getCluster(parentNuke:Nuke, nukeNum:int) : Vector.<Nuke>
		{
			var target:Target = null;
			var nuke:Nuke = null;
			var targets:Vector.<Target> = this._targets.concat();
			var cluster:Vector.<Nuke> = new Vector.<Nuke>();
			for(var i:int = 0; i < nukeNum; i++)
			{
				nuke = this.getSingleNuke(Projectile.NUKE_SPLIT_TYPE,false);
				nuke.parentRef = parentNuke;
				nuke.target = targets.splice(MathUtil.random(0,targets.length - 1),1)[0];
				cluster.push(nuke);
			}
			return cluster;
		}
		
		public function getBomber() : Bomber
		{
			var bomber:Bomber = new Bomber(this._flashAssets);
			bomber.dropPosX = MathUtil.random(0,GameConstants.STAGE_WIDTH);
			return bomber;
		}
		
		private function randomize(data:Array) : Array
		{
			for(var i:uint = 0; i < data.length; i++)
			{
				data[i].id = MathUtil.random(0,1000);
			}
			data.sortOn("id",Array.NUMERIC);
			return data;
		}
		
		public function dispose() : void
		{
			this._flashAssets = null;
			this._nukesArray = null;
		}
	}
}
