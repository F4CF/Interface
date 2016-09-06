package bhvr.views
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import bhvr.constatnts.GameConstants;
	import flash.ui.Mouse;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	
	public class CustomCursor extends MovieClip
	{
		 
		
		private var _stage:Stage;
		
		private var _cursorView:MovieClip;
		
		private var _linkageId:String;
		
		public function CustomCursor(mainStage:Stage, assets:MovieClip, linkageId:String)
		{
			super();
			this._stage = mainStage;
			this._linkageId = linkageId;
			this._cursorView = FlashUtil.getLibraryItem(assets,this._linkageId) as MovieClip;
			this._cursorView.x = -1000;
			this._cursorView.y = -1000;
			addChild(this._cursorView);
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this._cursorView.visible = false;
		}
		
		private function onMouseMove(e:MouseEvent) : void
		{
			var posX:Number = e.stageX;
			var posY:Number = e.stageY;
			if(this._cursorView != null)
			{
				this._cursorView.x = Math.max(Math.min(posX,GameConstants.STAGE_WIDTH),0);
				this._cursorView.y = Math.max(Math.min(posY,GameConstants.STAGE_HEIGHT),0);
			}
		}
		
		public function show(hideDefaultMouseCursor:Boolean = true) : void
		{
			if(this._cursorView != null && !this._cursorView.visible)
			{
				this._cursorView.visible = true;
				this._cursorView.x = stage.mouseX;
				this._cursorView.y = stage.mouseY;
				if(hideDefaultMouseCursor)
				{
					Mouse.hide();
				}
				this.startMoving();
			}
		}
		
		public function hide(showDefaultMouseCursor:Boolean = true) : void
		{
			if(this._cursorView != null && this._cursorView.visible)
			{
				this._cursorView.visible = false;
				if(showDefaultMouseCursor)
				{
					Mouse.show();
				}
				this.stopMoving();
			}
		}
		
		public function startMoving() : void
		{
			this._stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove,false,0,true);
		}
		
		public function stopMoving() : void
		{
			this._stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
		}
		
		public function setPosition(pos:Point) : void
		{
			this._cursorView.x = pos.x;
			this._cursorView.y = pos.y;
		}
		
		public function getPosition() : Point
		{
			return new Point(this._cursorView.x,this._cursorView.y);
		}
		
		public function setAlpha(alphaValue:Number) : void
		{
			this.alpha = alphaValue;
		}
		
		public function dispose() : void
		{
			this.stopMoving();
			removeChild(this._cursorView);
			this._cursorView = null;
			Mouse.show();
		}
	}
}
