package bhvr.views
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import bhvr.module.event.SentenceInfo;
	import flash.display.InteractiveObject;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import flash.events.MouseEvent;
	import scaleform.clik.events.ButtonEvent;
	import bhvr.constants.GameConstants;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import scaleform.gfx.TextFieldEx;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import bhvr.data.assets.PortraitSymbols;
	import scaleform.clik.managers.FocusHandler;
	import scaleform.clik.controls.Button;
	import flash.events.Event;
	import bhvr.data.LocalizationStrings;
	
	public class UIWindowEvent extends EventDispatcher
	{
		
		public static const ACTION_SELECTED_EVENT:String = "ActionSelectedEvent";
		 
		
		private var _assets:MovieClip;
		
		private var _locationNameTxt:TextField;
		
		private var _portraitNameTxt:TextField;
		
		private var _descriptionTxt:TextField;
		
		private var _goldValueTxt:TextField;
		
		private var _portraitMc:MovieClip;
		
		private var _actionsMenuMc:MovieClip;
		
		private var _partyStatsMc:MovieClip;
		
		private var _paused:Boolean = false;
		
		private const MAX_ACTIONS:uint = 5;
		
		private const OFFSET_TEXT_CUT:Number = 300;
		
		private const PARTY_MEMBER_HIGHLIGHTED_COLOR:uint = 0;
		
		private const PARTY_MEMBER_NORMAL_COLOR:uint = 10066329;
		
		private const NORMAL_FRAME_LABEL:String = "normal";
		
		private const HERO_HIT_FRAME_LABEL:String = "heroHitStart>heroHitEnd";
		
		private const ENEMY_HIT_FRAME_LABEL:String = "enemyHitStart>enemyHitEnd";
		
		private const ENEMY_DEATH_FRAME_LABEL:String = "enemyDeathStart>enemyDeathEnd";
		
		private const MOBILE_ACTION_DISABLED_ALPHA:Number = 0.2;
		
		private const MOBILE_ACTION_NORMAL_ALPHA:Number = 1.0;
		
		private const MOBILE_SELECTION_BLINK_NUM:uint = 3;
		
		private var _textboxContent:Vector.<String>;
		
		private var _currentSentenceInfo:SentenceInfo;
		
		private var _focusedObjAtPause:InteractiveObject = null;
		
		private var _actionsNum:uint;
		
		public function UIWindowEvent(assets:MovieClip)
		{
			super();
			this._assets = assets;
			this._locationNameTxt = this._assets.windowEventMc.locationNameTxt;
			this._portraitNameTxt = this._assets.windowEventMc.portraitNameTxt;
			this._descriptionTxt = this._assets.windowEventMc.descriptionTxt;
			this._goldValueTxt = this._assets.windowEventMc.goldValueTxt;
			this._portraitMc = this._assets.windowEventMc.portraitMc;
			this._actionsMenuMc = this._assets.windowEventMc.actionsMenuMc;
			this._partyStatsMc = this._assets.windowEventMc.statsMc;
			this._partyStatsMc.nameLabelTxt.text = LocalizationStrings.NAME_LABEL.toUpperCase();
			this._partyStatsMc.hpLabelTxt.text = LocalizationStrings.HP_LABEL.toUpperCase();
			this._partyStatsMc.focusLabelTxt.text = LocalizationStrings.FOCUS_LABEL.toUpperCase();
			this._assets.windowEventMc.goldLabelTxt.text = LocalizationStrings.GOLD_LABEL.toUpperCase();
			TextFieldEx.setVerticalAlign(this._descriptionTxt,TextFieldEx.VALIGN_BOTTOM);
			TextFieldEx.setVerticalAutoSize(this._descriptionTxt,TextFieldEx.VAUTOSIZE_BOTTOM);
			this.reset();
		}
		
		private function get needToCutText() : Boolean
		{
			return this._descriptionTxt.getBounds(this._descriptionTxt.parent).y < this._assets.windowEventMc.textboxZoneMc.y - this.OFFSET_TEXT_CUT;
		}
		
		private function reset() : void
		{
			var btn:MovieClip = null;
			var i:uint = 0;
			this.setLocationName("");
			this.setPortraitName("");
			this.clearDialogBox();
			this.setGoldValue(0);
			this._actionsMenuMc.visible = false;
			this.disableActions();
			this._actionsNum = 0;
			for(i = 0; i < this.MAX_ACTIONS; i++)
			{
				btn = this._actionsMenuMc["btn" + i].btnCLIK;
				btn.id = i;
				if(CompanionAppMode.isOn)
				{
					btn.addEventListener(MouseEvent.MOUSE_OVER,this.onActionOver,false,0,true);
					btn.addEventListener(MouseEvent.MOUSE_UP,this.onActionSelected,false,0,true);
					btn.addEventListener(MouseEvent.MOUSE_OUT,this.onActionOut,false,0,true);
				}
				else
				{
					btn.addEventListener(ButtonEvent.CLICK,this.onActionSelected,false,0,true);
				}
			}
			this.setPortraitNormalState();
			this.setPortrait("");
			for(i = 0; i < GameConstants.MAX_PARTY_MEMBERS; i++)
			{
				this.resetPartyMemberStats(i);
			}
		}
		
		public function setLocationName(name:String) : void
		{
			this._locationNameTxt.text = name;
		}
		
		public function setPortraitName(name:String) : void
		{
			this._portraitNameTxt.text = name;
		}
		
		public function setGoldValue(value:int) : void
		{
			this._goldValueTxt.text = value.toString();
		}
		
		public function setPartyMemberStats(memberId:uint, name:String, hp:int, maxHp:int, focus:int, maxFocus:int) : void
		{
			this._partyStatsMc["partyStats" + memberId].nameTxt.text = name;
			this._partyStatsMc["partyStats" + memberId].hpTxt.text = hp.toString() + "/" + maxHp.toString();
			this._partyStatsMc["partyStats" + memberId].focusTxt.text = focus.toString() + "/" + maxFocus.toString();
		}
		
		public function resetPartyMemberStats(memberId:uint) : void
		{
			this._partyStatsMc["partyStats" + memberId].nameTxt.text = "";
			this._partyStatsMc["partyStats" + memberId].hpTxt.text = "";
			this._partyStatsMc["partyStats" + memberId].focusTxt.text = "";
			this._partyStatsMc["partyStats" + memberId].highlightMc.visible = false;
		}
		
		public function setPartyMemberTurn(memberId:uint) : void
		{
			this._partyStatsMc["partyStats" + memberId].highlightMc.visible = true;
			this.setPartyMemberStatsColor(memberId,this.PARTY_MEMBER_HIGHLIGHTED_COLOR);
		}
		
		public function resetPartyMemberTurn() : void
		{
			for(var i:uint = 0; i < GameConstants.MAX_PARTY_MEMBERS; i++)
			{
				this._partyStatsMc["partyStats" + i].highlightMc.visible = false;
				this.setPartyMemberStatsColor(i,this.PARTY_MEMBER_NORMAL_COLOR);
			}
		}
		
		private function setPartyMemberStatsColor(memberId:uint, color:uint) : void
		{
			this._partyStatsMc["partyStats" + memberId].nameTxt.textColor = color;
			this._partyStatsMc["partyStats" + memberId].hpTxt.textColor = color;
			this._partyStatsMc["partyStats" + memberId].focusTxt.textColor = color;
		}
		
		public function addSentence(text:String, delayBeforeCallback:Number, callback:Function) : void
		{
			var prefix:String = this._descriptionTxt.text == ""?"":"\n\n";
			var sentence:String = prefix + "> " + text;
			this.onSkipSentence(null);
			this._currentSentenceInfo = new SentenceInfo(sentence,delayBeforeCallback,callback);
			SoundManager.instance.startSound(SoundList.MUSIC_TEXT_PRINT);
			this.addLetter();
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onSkipSentence,false,0,true);
		}
		
		private function addLetter() : void
		{
			var content:String = null;
			TextFieldEx.appendHtml(this._descriptionTxt,this._currentSentenceInfo.letters.shift());
			if(this._currentSentenceInfo.letters.length > 0)
			{
				eaze(this).delay(0).onComplete(this.addLetter);
			}
			else
			{
				eaze(this).killTweens();
				InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onSkipSentence);
				this._textboxContent.push(this._currentSentenceInfo.text);
				SoundManager.instance.stopSound(SoundList.MUSIC_TEXT_PRINT);
				this.NotifyTextWritten(this._currentSentenceInfo.delay,this._currentSentenceInfo.callback);
				while(this.needToCutText)
				{
					this._textboxContent.shift();
					content = this._textboxContent.join("");
					this._descriptionTxt.text = content;
				}
			}
		}
		
		private function onSkipSentence(e:EventWithParams) : void
		{
			while(this._currentSentenceInfo != null && this._currentSentenceInfo.letters.length > 0)
			{
				this.addLetter();
			}
		}
		
		private function NotifyTextWritten(duration:Number, callback:Function) : void
		{
			if(callback != null)
			{
				eaze(this).delay(duration).onComplete(callback);
			}
		}
		
		public function clearDialogBox() : void
		{
			this._descriptionTxt.text = "";
			this._textboxContent = new Vector.<String>();
			this._currentSentenceInfo = null;
		}
		
		public function setPortrait(assetsLink:String) : void
		{
			var frameToShow:String = assetsLink == ""?PortraitSymbols.NO_IMAGE:assetsLink;
			this._portraitMc.portraitAnimMc.gotoAndStop(frameToShow);
		}
		
		public function setPortraitNormalState() : void
		{
			this._portraitMc.gotoAndPlay(this.NORMAL_FRAME_LABEL);
		}
		
		public function setPortraitHeroHitState(assetsLink:String) : void
		{
			eaze(this._portraitMc).play(this.HERO_HIT_FRAME_LABEL).onComplete(this.setPortraitNormalState);
			this._portraitMc.vfxMc.gotoAndPlay(assetsLink);
		}
		
		public function setPortraitEnemyHitState() : void
		{
			eaze(this._portraitMc).play(this.ENEMY_HIT_FRAME_LABEL).onComplete(this.setPortraitNormalState);
		}
		
		public function setPortraitEnemyDeathState() : void
		{
			eaze(this._portraitMc).play(this.ENEMY_DEATH_FRAME_LABEL);
		}
		
		public function setActions(list:Vector.<String>) : void
		{
			var btn:MovieClip = null;
			this._actionsNum = Math.min(list.length,this.MAX_ACTIONS);
			for(var i:uint = 0; i < this.MAX_ACTIONS; i++)
			{
				btn = this._actionsMenuMc["btn" + i].btnCLIK;
				if(i < this._actionsNum)
				{
					btn.label = list[i];
					btn.visible = true;
					btn.enabled = true;
				}
				else
				{
					btn.visible = false;
					btn.enabled = false;
				}
			}
		}
		
		private function onActionOver(e:MouseEvent) : void
		{
			FocusHandler.instance.setFocus(e.target as Button);
		}
		
		private function onActionOut(e:MouseEvent) : void
		{
			FocusHandler.instance.setFocus(this._assets);
		}
		
		private function onActionSelected(e:Event) : void
		{
			var i:uint = 0;
			var btn:MovieClip = e.target as MovieClip;
			SoundManager.instance.playSound(SoundList.SOUND_WINDOW_EVENT_SELECTION);
			if(CompanionAppMode.isOn)
			{
				for(i = 0; i < this.MAX_ACTIONS; i++)
				{
					this._actionsMenuMc["btn" + i].btnCLIK.enabled = false;
					if(i != btn.id)
					{
						this._actionsMenuMc["btn" + i].alpha = this.MOBILE_ACTION_DISABLED_ALPHA;
					}
				}
				this.blinkButton(btn,0);
			}
			else
			{
				this.onSelectionEnd(btn);
			}
		}
		
		private function blinkButton(btn:MovieClip, blinkNum:uint) : void
		{
			if(blinkNum < this.MOBILE_SELECTION_BLINK_NUM)
			{
				btn.alpha = 0;
				eaze(this._actionsMenuMc["btn" + btn.id]).play("hideStart>hideEnd").chain(btn).apply({"alpha":1}).chain(this._actionsMenuMc["btn" + btn.id]).play("showStart>showEnd").onComplete(this.blinkButton,btn,blinkNum + 1);
			}
			else
			{
				this.onSelectionEnd(btn);
			}
		}
		
		private function onSelectionEnd(btn:MovieClip) : void
		{
			var i:uint = 0;
			if(CompanionAppMode.isOn)
			{
				this._actionsMenuMc["btn" + btn.id].gotoAndStop("normal");
				for(i = 0; i < this.MAX_ACTIONS; i++)
				{
					this._actionsMenuMc["btn" + i].alpha = this.MOBILE_ACTION_NORMAL_ALPHA;
					this._actionsMenuMc["btn" + i].btnCLIK.enabled = true;
				}
			}
			dispatchEvent(new EventWithParams(ACTION_SELECTED_EVENT,{"actionId":btn.id}));
		}
		
		public function enableActions() : void
		{
			this._actionsMenuMc.visible = true;
			if(!CompanionAppMode.isOn)
			{
				FocusHandler.instance.setFocus(this._actionsMenuMc.btn0.btnCLIK);
			}
			if(this._actionsNum > 1)
			{
				InputManager.instance.addEventListener(GameInputs.MOVE_UP,this.onNavUp,false,0,true);
				InputManager.instance.addEventListener(GameInputs.MOVE_DOWN,this.onNavDown,false,0,true);
			}
		}
		
		public function disableActions() : void
		{
			if(this._actionsNum > 1)
			{
				InputManager.instance.removeEventListener(GameInputs.MOVE_UP,this.onNavUp);
				InputManager.instance.removeEventListener(GameInputs.MOVE_DOWN,this.onNavDown);
			}
			FocusHandler.instance.setFocus(this._assets);
			this._actionsMenuMc.visible = false;
		}
		
		private function onNavUp(e:EventWithParams) : void
		{
			var currentFocus:MovieClip = FocusHandler.instance.getFocus(0) as MovieClip;
			if(currentFocus.id == 0)
			{
				eaze(this._actionsMenuMc).delay(0).onComplete(FocusHandler.instance.setFocus,this._actionsMenuMc["btn" + (this._actionsNum - 1)].btnCLIK);
			}
			SoundManager.instance.playSound(SoundList.SOUND_WINDOW_EVENT_NAVIGATION);
		}
		
		private function onNavDown(e:EventWithParams) : void
		{
			var currentFocus:MovieClip = FocusHandler.instance.getFocus(0) as MovieClip;
			if(currentFocus.id == this._actionsNum - 1)
			{
				eaze(this._actionsMenuMc).delay(0).onComplete(FocusHandler.instance.setFocus,this._actionsMenuMc["btn" + 0].btnCLIK);
			}
			SoundManager.instance.playSound(SoundList.SOUND_WINDOW_EVENT_NAVIGATION);
		}
		
		public function pause() : void
		{
			var i:uint = 0;
			if(!this._paused)
			{
				this._paused = true;
				this._focusedObjAtPause = FocusHandler.instance.getFocus(0);
				for(i = 0; i < this.MAX_ACTIONS; i++)
				{
					this._actionsMenuMc["btn" + i].btnCLIK.enabled = false;
				}
			}
		}
		
		public function resume() : void
		{
			var btn:MovieClip = null;
			var i:uint = 0;
			if(this._paused)
			{
				this._paused = false;
				FocusHandler.instance.setFocus(this._focusedObjAtPause);
				for(i = 0; i < this.MAX_ACTIONS; i++)
				{
					btn = this._actionsMenuMc["btn" + i].btnCLIK;
					btn.enabled = btn.visible;
				}
			}
		}
		
		public function dispose() : void
		{
			var btn:MovieClip = null;
			var i:uint = 0;
			eaze(this).killTweens();
			for(i = 0; i < this.MAX_ACTIONS; i++)
			{
				btn = this._actionsMenuMc["btn" + i].btnCLIK;
				if(CompanionAppMode.isOn)
				{
					btn.removeEventListener(MouseEvent.MOUSE_OVER,this.onActionOver);
					btn.removeEventListener(MouseEvent.MOUSE_OUT,this.onActionOut);
					btn.removeEventListener(MouseEvent.MOUSE_UP,this.onActionSelected);
				}
				else
				{
					btn.removeEventListener(ButtonEvent.CLICK,this.onActionSelected);
				}
			}
			this._locationNameTxt = null;
			this._portraitNameTxt = null;
			this._descriptionTxt = null;
			this._goldValueTxt = null;
			this._portraitMc = null;
			this._actionsMenuMc = null;
			this._partyStatsMc = null;
			this._textboxContent = null;
		}
	}
}
