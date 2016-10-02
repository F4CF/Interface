package bhvr.views
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import bhvr.constants.GameConstants;
	import flash.ui.Mouse;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	
	public class CustomCursor extends MovieClip
	{
		 
		
		private var _stage:Stage;
		
		private var _cursorView:MovieClip;
		
		private var _linkageId:String;
		
		public function CustomCursor(param1:Stage, param2:MovieClip, param3:String)
		{
			super();
			this._stage = param1;
			this._linkageId = param3;
			this._cursorView = FlashUtil.getLibraryItem(param2,this._linkageId) as MovieClip;
			this._cursorView.x = -1000;
			this._cursorView.y = -1000;
			addChild(this._cursorView);
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this._cursorView.visible = false;
		}
		
		private function onMouseMove(param1:MouseEvent) : void
		{
			var _loc2_:Number = param1.stageX;
			var _loc3_:Number = param1.stageY;
			if(this._cursorView != null)
			{
				this._cursorView.x = Math.max(Math.min(_loc2_,GameConstants.STAGE_WIDTH),0);
				this._cursorView.y = Math.max(Math.min(_loc3_,GameConstants.STAGE_HEIGHT),0);
			}
		}
		
		public function show(param1:Boolean = true) : void
		{
			if(this._cursorView != null && !this._cursorView.visible)
			{
				this._cursorView.visible = true;
				this._cursorView.x = stage.mouseX;
				this._cursorView.y = stage.mouseY;
				if(param1)
				{
					Mouse.hide();
				}
				this.startMoving();
			}
		}
		
		public function hide(param1:Boolean = true) : void
		{
			if(this._cursorView != null && this._cursorView.visible)
			{
				this._cursorView.visible = false;
				if(param1)
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
		
		public function setPosition(param1:Point) : void
		{
			this._cursorView.x = param1.x;
			this._cursorView.y = param1.y;
		}
		
		public function getPosition() : Point
		{
			return new Point(this._cursorView.x,this._cursorView.y);
		}
		
		public function setAlpha(param1:Number) : void
		{
			this.alpha = param1;
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
