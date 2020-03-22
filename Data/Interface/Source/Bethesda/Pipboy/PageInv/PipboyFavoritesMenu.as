package
{
	import Shared.AS3.BSUIComponent;
	import Shared.GlobalFunc;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.text.TextField;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;

	// TODO: Fix the 1009 error for `getCharBoundaries` line 49

	public class PipboyFavoritesMenu extends BSUIComponent
	{

		public var TopBracketHolder_mc:MovieClip;

		public var Background_mc:MovieClip;

		public var Header_tf:TextField;

		public var SelectionName_tf:TextField;

		public var SelectionAmmo_tf:TextField;

		public var Cross_mc:FavoritesCross;

		private var _SelectedItemName:String;

		private var _SelectedItemAmmo:String;


		public function PipboyFavoritesMenu()
		{
			try
			{
				var _loc1_:Point = null;
				var _loc2_:int = 0;
				var _loc3_:Shape = null;
				var _loc4_:Shape = null;
				super();
				Extensions.enabled = true;
				TextFieldEx.setTextAutoSize(this.SelectionName_tf, TextFieldEx.TEXTAUTOSZ_SHRINK);
				TextFieldEx.setTextAutoSize(this.SelectionAmmo_tf, TextFieldEx.TEXTAUTOSZ_SHRINK);
				if(this.TopBracketHolder_mc.numChildren == 0)
				{
					_loc1_ = new Point();
					_loc2_ = this.Header_tf.x + this.Header_tf.getLineMetrics(0).x;
					_loc1_.x = _loc2_ + this.Header_tf.getCharBoundaries(0).x;
					_loc1_.y = _loc2_ + this.Header_tf.getCharBoundaries(this.Header_tf.text.length - 1).right;

					_loc3_ = new Shape();
					_loc3_.graphics.lineStyle(2, 16777215, 1, true, LineScaleMode.NONE);
					_loc3_.graphics.moveTo(0, 0);
					_loc3_.graphics.lineTo(_loc1_.x - this.TopBracketHolder_mc.x - 12.5, 0);
					this.TopBracketHolder_mc.addChild(_loc3_);

					_loc4_ = new Shape();
					_loc4_.graphics.lineStyle(2, 16777215, 1, true, LineScaleMode.NONE);
					_loc4_.graphics.moveTo(_loc1_.y - this.TopBracketHolder_mc.x + 12.5, 0);
					_loc4_.graphics.lineTo(this.Background_mc.x + this.Background_mc.width - this.TopBracketHolder_mc.x - 4, 0);
					this.TopBracketHolder_mc.addChild(_loc4_);
				}
				this.Cross_mc.addEventListener(FavoritesCross.SELECTION_UPDATE, this.onFavSelection);
			}
			catch (error:Error)
			{
				trace("[Scrivene07][PipboyMenu.swf][Pipboy_InvPage.swf][PipboyFavoritesMenu](ctor) "+error.toString());
			}
		}


		private function onFavSelection():*
		{
			try
			{
				if(this.Cross_mc.selectedEntry != null)
				{
					this._SelectedItemName = this.Cross_mc.selectedEntry.text;
					if(this.Cross_mc.selectedEntry.count != 1)
					{
						this._SelectedItemName = this._SelectedItemName + (" (" + this.Cross_mc.selectedEntry.count + ")");
					}
					if(this.Cross_mc.selectedEntry.ammoText != undefined)
					{
						this._SelectedItemAmmo = this.Cross_mc.selectedEntry.ammoText + " (" + this.Cross_mc.selectedEntry.ammoCount + ")";
					}
					else
					{
						this._SelectedItemAmmo = " ";
					}
				}
				else
				{
					this._SelectedItemName = " ";
					this._SelectedItemAmmo = " ";
				}
				SetIsDirty();
			}
			catch (error:Error)
			{
				trace("[Scrivene07][PipboyMenu.swf][Pipboy_InvPage.swf][PipboyFavoritesMenu](onFavSelection) "+error.toString());
			}
		}


		override public function redrawUIComponent():void
		{
			try
			{
				super.redrawUIComponent();
				GlobalFunc.SetText(this.SelectionName_tf, this._SelectedItemName, false);
				GlobalFunc.SetText(this.SelectionAmmo_tf, this._SelectedItemAmmo, false);
			}
			catch (error:Error)
			{
				trace("[Scrivene07][PipboyMenu.swf][Pipboy_InvPage.swf][PipboyFavoritesMenu](redrawUIComponent) "+error.toString());
			}
		}


	}
}
