package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.data.LevelUpVariables;
	
	public class ConveyorBelt extends Girder
	{
		
		public static const NO_DIRECTION:uint = 0;
		
		public static const DIRECTION_RIGHT:uint = 1;
		
		public static const DIRECTION_LEFT:uint = 2;
		 
		
		private const MAX_DIRECTION_INDICATORS:uint = 3;
		
		private const ARROWS_NUM:uint = 3;
		
		private var _arrowsIndicators:Vector.<MovieClip>;
		
		private var _direction:uint;
		
		public function ConveyorBelt(assets:MovieClip)
		{
			super(assets);
			this.getArrowsIndicators();
			this.stopMovement();
		}
		
		public function get direction() : uint
		{
			return this._direction;
		}
		
		private function getArrowsIndicators() : void
		{
			var indicator:MovieClip = null;
			this._arrowsIndicators = new Vector.<MovieClip>();
			for(var i:uint = 0; i < this.MAX_DIRECTION_INDICATORS; i++)
			{
				indicator = _assets["arrows" + i];
				if(indicator != null)
				{
					this._arrowsIndicators.push(indicator);
				}
			}
		}
		
		public function changeDirection() : void
		{
			switch(this._direction)
			{
				case DIRECTION_LEFT:
					this.setDirection(DIRECTION_RIGHT);
					break;
				case DIRECTION_RIGHT:
					this.setDirection(DIRECTION_LEFT);
			}
		}
		
		public function setDirection(dir:uint) : void
		{
			if(dir != this._direction)
			{
				switch(dir)
				{
					case NO_DIRECTION:
						this.stopMovement();
						break;
					case DIRECTION_RIGHT:
					case DIRECTION_LEFT:
						this.setMovement(dir,this._direction);
				}
				this._direction = dir;
			}
		}
		
		private function stopMovement() : void
		{
			this.setRollersDirection(NO_DIRECTION);
			for(var i:uint = 0; i < this._arrowsIndicators.length; i++)
			{
				this._arrowsIndicators[i].visible = false;
			}
			_speed = 0;
		}
		
		private function setMovement(newDirection:uint, prevDirection:uint) : void
		{
			var frameToPlay:String = null;
			var indicator:MovieClip = null;
			var arrow:MovieClip = null;
			var j:uint = 0;
			if(newDirection == NO_DIRECTION)
			{
				this.stopMovement();
				return;
			}
			this.setRollersDirection(newDirection);
			for(var i:uint = 0; i < this._arrowsIndicators.length; i++)
			{
				indicator = this._arrowsIndicators[i];
				indicator.visible = true;
				for(j = 0; j < this.ARROWS_NUM; j++)
				{
					arrow = indicator["arrow" + j];
					if(newDirection == DIRECTION_RIGHT)
					{
						if(prevDirection == DIRECTION_LEFT)
						{
							arrow.gotoAndPlay("switchRightDirection");
						}
						else
						{
							arrow.gotoAndPlay("blinkRightDirection");
						}
					}
					else if(prevDirection == DIRECTION_RIGHT)
					{
						arrow.gotoAndPlay("switchLeftDirection");
					}
					else
					{
						arrow.gotoAndPlay("blinkLeftDirection");
					}
				}
			}
			_speed = LevelUpVariables.getStage2ConveyorSpeed();
			if(newDirection == DIRECTION_LEFT)
			{
				_speed = -_speed;
			}
		}
		
		private function setRollersDirection(dir:uint) : void
		{
			var frameToPlay:String = null;
			switch(dir)
			{
				case NO_DIRECTION:
					frameToPlay = "noDirection";
					break;
				case DIRECTION_RIGHT:
					frameToPlay = "rightDirection";
					break;
				case DIRECTION_LEFT:
					frameToPlay = "leftDirection";
			}
			_assets.rollerLeftMc.gotoAndPlay(frameToPlay);
			_assets.rollerRightMc.gotoAndPlay(frameToPlay);
		}
		
		override public function pause() : void
		{
			var indicator:MovieClip = null;
			var i:uint = 0;
			var arrow:MovieClip = null;
			var j:uint = 0;
			super.pause();
			if(this._direction != NO_DIRECTION)
			{
				_assets.rollerLeftMc.stop();
				_assets.rollerRightMc.stop();
				for(i = 0; i < this._arrowsIndicators.length; i++)
				{
					indicator = this._arrowsIndicators[i];
					indicator.visible = true;
					for(j = 0; j < this.ARROWS_NUM; j++)
					{
						arrow = indicator["arrow" + j];
						arrow.stop();
					}
				}
			}
		}
		
		override public function resume() : void
		{
			var indicator:MovieClip = null;
			var i:uint = 0;
			var arrow:MovieClip = null;
			var j:uint = 0;
			super.resume();
			if(this._direction != NO_DIRECTION)
			{
				_assets.rollerLeftMc.play();
				_assets.rollerRightMc.play();
				for(i = 0; i < this._arrowsIndicators.length; i++)
				{
					indicator = this._arrowsIndicators[i];
					indicator.visible = true;
					for(j = 0; j < this.ARROWS_NUM; j++)
					{
						arrow = indicator["arrow" + j];
						arrow.play();
					}
				}
			}
		}
	}
}
