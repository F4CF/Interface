package bhvr.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.constatnts.GameConstants;
	import bhvr.utils.FlashUtil;
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	
	public class Barn extends MovieClip
	{
		 
		
		private const ASSET_LINKAGE_ID:String = "BarnPiece";
		
		private const VFX_LINKAGE_ID:String = "BarnExplosionMc";
		
		private var _assets:MovieClip;
		
		private var _id:uint;
		
		private var _alivePieces:Vector.<Vector.<MovieClip>>;
		
		public function Barn(id:uint, flashAssets:MovieClip)
		{
			super();
			this._id = id;
			this._assets = flashAssets;
			this._alivePieces = new Vector.<Vector.<MovieClip>>();
			this.reset();
		}
		
		public function get id() : uint
		{
			return this._id;
		}
		
		public function get alivePieces() : Vector.<MovieClip>
		{
			var j:uint = 0;
			var pieces:Vector.<MovieClip> = new Vector.<MovieClip>();
			for(var i:uint = 0; i < this._alivePieces.length; i++)
			{
				for(j = 0; j < this._alivePieces[i].length; j++)
				{
					pieces.push(this._alivePieces[i][j]);
				}
			}
			return pieces;
		}
		
		public function createBarn() : void
		{
			var piece:MovieClip = null;
			var linkageId:String = null;
			var pos:Point = new Point(0,0);
			var piecesNum:int = GameConstants.NUMBER_OF_BARN_PIECES_COL * GameConstants.NUMBER_OF_BARN_PIECES_ROW;
			var i:uint = 0;
			var j:uint = 0;
			for(i = 0; i < GameConstants.NUMBER_OF_BARN_PIECES_COL; i++)
			{
				this._alivePieces[i] = new Vector.<MovieClip>();
				for(j = 0; j < GameConstants.NUMBER_OF_BARN_PIECES_ROW; j++)
				{
					linkageId = i < GameConstants.NUMBER_OF_BARN_PIECES_COL / 2?this.ASSET_LINKAGE_ID + (j + i * GameConstants.NUMBER_OF_BARN_PIECES_ROW):this.ASSET_LINKAGE_ID + (j + i * GameConstants.NUMBER_OF_BARN_PIECES_ROW - piecesNum / 2);
					piece = FlashUtil.getLibraryItem(this._assets,linkageId) as MovieClip;
					piece.x = pos.x + piece.width / 2;
					piece.scaleX = i < GameConstants.NUMBER_OF_BARN_PIECES_COL / 2?Number(1):Number(-1);
					piece.y = pos.y + piece.height / 2;
					addChild(piece);
					this._alivePieces[i].push(piece);
					pos.y = (j + 1) * piece.height;
				}
				pos.x = i < GameConstants.NUMBER_OF_BARN_PIECES_COL / 2 - 1?Number((i + 1) * piece.width):Number((GameConstants.NUMBER_OF_BARN_PIECES_COL + (GameConstants.NUMBER_OF_BARN_PIECES_COL / 2 - 1) - (i + 1)) * piece.width);
				pos.y = 0;
			}
		}
		
		public function destroyPiece(target:MovieClip) : void
		{
			var vfx:MovieClip = null;
			var i:uint = 0;
			if(target)
			{
				vfx = FlashUtil.getLibraryItem(this._assets,this.VFX_LINKAGE_ID) as MovieClip;
				vfx.x = target.x;
				vfx.y = target.y;
				addChild(vfx);
				eaze(vfx).play("start>end").onComplete(this.onPieceDestroyed,vfx);
				SoundManager.instance.playSound(SoundList.BARN_EXPLOSION_SOUND);
				removeChild(target);
				for(i = 0; i < GameConstants.NUMBER_OF_BARN_PIECES_COL; i++)
				{
					if(!this.isColumnEmpty(i))
					{
						if(target == this._alivePieces[i][0])
						{
							this._alivePieces[i].splice(0,1);
						}
						else if(target == this._alivePieces[i][this._alivePieces[i].length - 1])
						{
							this._alivePieces[i].pop();
						}
					}
				}
			}
		}
		
		private function onPieceDestroyed(vfx:MovieClip) : void
		{
			removeChild(vfx);
			vfx = null;
		}
		
		private function getColumnFromPosition(posX:Number) : Vector.<MovieClip>
		{
			var i:uint = 0;
			var piece:MovieClip = null;
			var piecePos:Point = null;
			for(i = 0; i < GameConstants.NUMBER_OF_BARN_PIECES_COL; i++)
			{
				if(!this.isColumnEmpty(i))
				{
					piece = this._alivePieces[i][0];
					piecePos = FlashUtil.localToGlobalPosition(piece);
					if(posX >= piecePos.x - piece.width / 2 && posX <= piecePos.x + piece.width / 2)
					{
						return this._alivePieces[i];
					}
				}
			}
			return null;
		}
		
		private function isColumnEmpty(id:uint) : Boolean
		{
			if(id >= this._alivePieces.length)
			{
				return true;
			}
			return this._alivePieces[id].length == 0;
		}
		
		public function getPiecefromPosition(posX:Number, fromTop:Boolean) : MovieClip
		{
			var columnId:uint = 0;
			var column:Vector.<MovieClip> = this.getColumnFromPosition(posX);
			if(column != null)
			{
				columnId = !!fromTop?uint(0):uint(column.length - 1);
				return column[columnId];
			}
			return null;
		}
		
		public function reset() : void
		{
			while(numChildren > 0)
			{
				removeChildAt(0);
			}
			this._alivePieces = new Vector.<Vector.<MovieClip>>();
			this.createBarn();
		}
		
		public function dispose() : void
		{
			this.reset();
			this._alivePieces = null;
		}
	}
}
