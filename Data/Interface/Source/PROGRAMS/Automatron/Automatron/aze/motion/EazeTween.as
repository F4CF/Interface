package aze.motion
{
	import flash.utils.Dictionary;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	import aze.motion.specials.EazeSpecial;
	import aze.motion.easing.Quadratic;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import aze.motion.easing.Linear;
	
	public final class EazeTween
	{
		
		public static var defaultEasing:Function = Quadratic.easeOut;
		
		public static var defaultDuration:Object = {
			"slow":1,
			"normal":0.4,
			"fast":0.2
		};
		
		public static const specialProperties:Dictionary = new Dictionary();
		
		private static const running:Dictionary = new Dictionary();
		
		private static const ticker:Shape = createTicker();
		
		private static var pauseTime:Number;
		
		private static var head:aze.motion.EazeTween;
		
		private static var tweenCount:int = 0;
		
		{
			specialProperties.alpha = true;
			specialProperties.alphaVisible = true;
			specialProperties.scale = true;
		}
		
		private var prev:aze.motion.EazeTween;
		
		private var next:aze.motion.EazeTween;
		
		private var rnext:aze.motion.EazeTween;
		
		private var isDead:Boolean;
		
		private var target:Object;
		
		private var reversed:Boolean;
		
		private var overwrite:Boolean;
		
		private var autoStart:Boolean;
		
		private var _configured:Boolean;
		
		private var _started:Boolean;
		
		private var _inited:Boolean;
		
		private var duration;
		
		private var _duration:Number;
		
		private var _ease:Function;
		
		private var startTime:Number;
		
		private var endTime:Number;
		
		private var properties:EazeProperty;
		
		private var specials:EazeSpecial;
		
		private var autoVisible:Boolean;
		
		private var slowTween:Boolean;
		
		private var _chain:Array;
		
		private var _onStart:Function;
		
		private var _onStartArgs:Array;
		
		private var _onUpdate:Function;
		
		private var _onUpdateArgs:Array;
		
		private var _onComplete:Function;
		
		private var _onCompleteArgs:Array;
		
		public function EazeTween(param1:Object, param2:Boolean = true)
		{
			super();
			if(!param1)
			{
				throw new ArgumentError("EazeTween: target can not be null");
			}
			this.target = param1;
			this.autoStart = param2;
			this._ease = defaultEasing;
		}
		
		public static function killAllTweens() : void
		{
			var _loc1_:* = null;
			for(_loc1_ in running)
			{
				killTweensOf(_loc1_);
			}
		}
		
		public static function killTweensOf(param1:Object) : void
		{
			var _loc3_:aze.motion.EazeTween = null;
			if(!param1)
			{
				return;
			}
			var _loc2_:aze.motion.EazeTween = running[param1];
			while(_loc2_)
			{
				_loc2_.isDead = true;
				_loc2_.dispose();
				if(_loc2_.rnext)
				{
					_loc3_ = _loc2_;
					_loc2_ = _loc2_.rnext;
					_loc3_.rnext = null;
				}
				else
				{
					_loc2_ = null;
				}
			}
			delete running[param1];
		}
		
		public static function pauseAllTweens() : void
		{
			if(ticker.hasEventListener(Event.ENTER_FRAME))
			{
				pauseTime = getTimer();
				ticker.removeEventListener(Event.ENTER_FRAME,tick);
			}
		}
		
		public static function resumeAllTweens() : void
		{
			var _loc1_:Number = NaN;
			var _loc2_:aze.motion.EazeTween = null;
			if(!ticker.hasEventListener(Event.ENTER_FRAME))
			{
				_loc1_ = getTimer() - pauseTime;
				_loc2_ = head;
				while(_loc2_)
				{
					_loc2_.startTime = _loc2_.startTime + _loc1_;
					_loc2_.endTime = _loc2_.endTime + _loc1_;
					_loc2_ = _loc2_.next;
				}
				ticker.addEventListener(Event.ENTER_FRAME,tick);
			}
		}
		
		private static function createTicker() : Shape
		{
			var _loc1_:Shape = new Shape();
			_loc1_.addEventListener(Event.ENTER_FRAME,tick);
			return _loc1_;
		}
		
		private static function tick(param1:Event) : void
		{
			if(head)
			{
				updateTweens(getTimer());
			}
		}
		
		private static function updateTweens(param1:int) : void
		{
			var _loc6_:* = false;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			var _loc9_:Object = null;
			var _loc10_:EazeProperty = null;
			var _loc11_:EazeSpecial = null;
			var _loc12_:aze.motion.EazeTween = null;
			var _loc13_:aze.motion.EazeTween = null;
			var _loc14_:CompleteData = null;
			var _loc15_:int = 0;
			var _loc2_:Array = [];
			var _loc3_:int = 0;
			var _loc4_:aze.motion.EazeTween = head;
			var _loc5_:int = 0;
			while(_loc4_)
			{
				_loc5_++;
				if(_loc4_.isDead)
				{
					_loc6_ = true;
				}
				else
				{
					_loc6_ = param1 >= _loc4_.endTime;
					_loc7_ = !!_loc6_?Number(1):Number((param1 - _loc4_.startTime) / _loc4_._duration);
					_loc8_ = _loc4_._ease(_loc7_ || 0);
					_loc9_ = _loc4_.target;
					_loc10_ = _loc4_.properties;
					while(_loc10_)
					{
						_loc9_[_loc10_.name] = _loc10_.start + _loc10_.delta * _loc8_;
						_loc10_ = _loc10_.next;
					}
					if(_loc4_.slowTween)
					{
						if(_loc4_.autoVisible)
						{
							_loc9_.visible = _loc9_.alpha > 0.001;
						}
						if(_loc4_.specials)
						{
							_loc11_ = _loc4_.specials;
							while(_loc11_)
							{
								_loc11_.update(_loc8_,_loc6_);
								_loc11_ = _loc11_.next;
							}
						}
						if(_loc4_._onStart != null)
						{
							_loc4_._onStart.apply(null,_loc4_._onStartArgs);
							_loc4_._onStart = null;
							_loc4_._onStartArgs = null;
						}
						if(_loc4_._onUpdate != null)
						{
							_loc4_._onUpdate.apply(null,_loc4_._onUpdateArgs);
						}
					}
				}
				if(_loc6_)
				{
					if(_loc4_._started)
					{
						_loc14_ = new CompleteData(_loc4_._onComplete,_loc4_._onCompleteArgs,_loc4_._chain,_loc4_.endTime - param1);
						_loc4_._chain = null;
						_loc2_.unshift(_loc14_);
						_loc3_++;
					}
					_loc4_.isDead = true;
					_loc4_.detach();
					_loc4_.dispose();
					_loc12_ = _loc4_;
					_loc13_ = _loc4_.prev;
					_loc4_ = _loc12_.next;
					if(_loc13_)
					{
						_loc13_.next = _loc4_;
						if(_loc4_)
						{
							_loc4_.prev = _loc13_;
						}
					}
					else
					{
						head = _loc4_;
						if(_loc4_)
						{
							_loc4_.prev = null;
						}
					}
					_loc12_.prev = _loc12_.next = null;
				}
				else
				{
					_loc4_ = _loc4_.next;
				}
			}
			if(_loc3_)
			{
				_loc15_ = 0;
				while(_loc15_ < _loc3_)
				{
					_loc2_[_loc15_].execute();
					_loc15_++;
				}
			}
			tweenCount = _loc5_;
		}
		
		private function configure(param1:*, param2:Object = null, param3:Boolean = false) : void
		{
			var _loc4_:* = null;
			var _loc5_:* = undefined;
			this._configured = true;
			this.reversed = param3;
			this.duration = param1;
			if(param2)
			{
				for(_loc4_ in param2)
				{
					_loc5_ = param2[_loc4_];
					if(_loc4_ in specialProperties)
					{
						if(_loc4_ == "alpha")
						{
							this.autoVisible = true;
							this.slowTween = true;
						}
						else if(_loc4_ == "alphaVisible")
						{
							_loc4_ = "alpha";
							this.autoVisible = false;
						}
						else if(!(_loc4_ in this.target))
						{
							if(_loc4_ == "scale")
							{
								this.configure(param1,{
									"scaleX":_loc5_,
									"scaleY":_loc5_
								},param3);
							}
							else
							{
								this.specials = new specialProperties[_loc4_](this.target,_loc4_,_loc5_,this.specials);
								this.slowTween = true;
							}
							continue;
						}
					}
					if(_loc5_ is Array && this.target[_loc4_] is Number)
					{
						if("__bezier" in specialProperties)
						{
							this.specials = new specialProperties["__bezier"](this.target,_loc4_,_loc5_,this.specials);
							this.slowTween = true;
						}
					}
					else
					{
						this.properties = new EazeProperty(_loc4_,_loc5_,this.properties);
					}
				}
			}
		}
		
		public function start(param1:Boolean = true, param2:Number = 0) : void
		{
			if(this._started)
			{
				return;
			}
			if(!this._inited)
			{
				this.init();
			}
			this.overwrite = param1;
			this.startTime = getTimer() + param2;
			this._duration = (!!isNaN(this.duration)?this.smartDuration(String(this.duration)):Number(this.duration)) * 1000;
			this.endTime = this.startTime + this._duration;
			if(this.reversed || this._duration == 0)
			{
				this.update(this.startTime);
			}
			if(this.autoVisible && this._duration > 0)
			{
				this.target.visible = true;
			}
			this._started = true;
			this.attach(this.overwrite);
		}
		
		private function init() : void
		{
			if(this._inited)
			{
				return;
			}
			var _loc1_:EazeProperty = this.properties;
			while(_loc1_)
			{
				_loc1_.init(this.target,this.reversed);
				_loc1_ = _loc1_.next;
			}
			var _loc2_:EazeSpecial = this.specials;
			while(_loc2_)
			{
				_loc2_.init(this.reversed);
				_loc2_ = _loc2_.next;
			}
			this._inited = true;
		}
		
		private function smartDuration(param1:String) : Number
		{
			var _loc2_:EazeSpecial = null;
			if(param1 in defaultDuration)
			{
				return defaultDuration[param1];
			}
			if(param1 == "auto")
			{
				_loc2_ = this.specials;
				while(_loc2_)
				{
					if("getPreferredDuration" in _loc2_)
					{
						return _loc2_["getPreferredDuration"]();
					}
					_loc2_ = _loc2_.next;
				}
			}
			return defaultDuration.normal;
		}
		
		public function easing(param1:Function) : aze.motion.EazeTween
		{
			this._ease = param1 || defaultEasing;
			return this;
		}
		
		public function filter(param1:*, param2:Object, param3:Boolean = false) : aze.motion.EazeTween
		{
			if(!param2)
			{
				param2 = {};
			}
			if(param3)
			{
				param2.remove = true;
			}
			this.addSpecial(param1,param1,param2);
			return this;
		}
		
		public function tint(param1:* = null, param2:Number = 1, param3:Number = NaN) : aze.motion.EazeTween
		{
			if(isNaN(param3))
			{
				param3 = 1 - param2;
			}
			this.addSpecial("tint","tint",[param1,param2,param3]);
			return this;
		}
		
		public function colorMatrix(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:uint = 16777215, param6:Number = 0) : aze.motion.EazeTween
		{
			var _loc7_:Boolean = !param1 && !param2 && !param3 && !param4 && !param6;
			return this.filter(ColorMatrixFilter,{
				"brightness":param1,
				"contrast":param2,
				"saturation":param3,
				"hue":param4,
				"tint":param5,
				"colorize":param6
			},_loc7_);
		}
		
		public function short(param1:Number, param2:String = "rotation", param3:Boolean = false) : aze.motion.EazeTween
		{
			this.addSpecial("__short",param2,[param1,param3]);
			return this;
		}
		
		public function rect(param1:Rectangle, param2:String = "scrollRect") : aze.motion.EazeTween
		{
			this.addSpecial("__rect",param2,param1);
			return this;
		}
		
		private function addSpecial(param1:*, param2:*, param3:Object) : void
		{
			if(param1 in specialProperties && this.target)
			{
				if((!this._inited || this._duration == 0) && this.autoStart)
				{
					EazeSpecial(new specialProperties[param1](this.target,param2,param3,null)).init(true);
				}
				else
				{
					this.specials = new specialProperties[param1](this.target,param2,param3,this.specials);
					if(this._started)
					{
						this.specials.init(this.reversed);
					}
					this.slowTween = true;
				}
			}
		}
		
		public function onStart(param1:Function, ... rest) : aze.motion.EazeTween
		{
			this._onStart = param1;
			this._onStartArgs = rest;
			this.slowTween = !this.autoVisible || this.specials != null || this._onUpdate != null || this._onStart != null;
			return this;
		}
		
		public function onUpdate(param1:Function, ... rest) : aze.motion.EazeTween
		{
			this._onUpdate = param1;
			this._onUpdateArgs = rest;
			this.slowTween = !this.autoVisible || this.specials != null || this._onUpdate != null || this._onStart != null;
			return this;
		}
		
		public function onComplete(param1:Function, ... rest) : aze.motion.EazeTween
		{
			this._onComplete = param1;
			this._onCompleteArgs = rest;
			return this;
		}
		
		public function kill(param1:Boolean = false) : void
		{
			if(this.isDead)
			{
				return;
			}
			if(param1)
			{
				this._onUpdate = this._onComplete = null;
				this.update(this.endTime);
			}
			else
			{
				this.detach();
				this.dispose();
			}
			this.isDead = true;
		}
		
		public function killTweens() : aze.motion.EazeTween
		{
			aze.motion.EazeTween.killTweensOf(this.target);
			return this;
		}
		
		public function updateNow() : aze.motion.EazeTween
		{
			var _loc1_:Number = NaN;
			if(this._started)
			{
				_loc1_ = Math.max(this.startTime,getTimer());
				this.update(_loc1_);
			}
			else
			{
				this.init();
				this.endTime = this._duration = 1;
				this.update(0);
			}
			return this;
		}
		
		private function update(param1:Number) : void
		{
			var _loc2_:aze.motion.EazeTween = head;
			head = this;
			updateTweens(param1);
			head = _loc2_;
		}
		
		private function attach(param1:Boolean) : void
		{
			var _loc2_:aze.motion.EazeTween = null;
			if(param1)
			{
				killTweensOf(this.target);
			}
			else
			{
				_loc2_ = running[this.target];
			}
			if(_loc2_)
			{
				this.prev = _loc2_;
				this.next = _loc2_.next;
				if(this.next)
				{
					this.next.prev = this;
				}
				_loc2_.next = this;
				this.rnext = _loc2_;
			}
			else
			{
				if(head)
				{
					head.prev = this;
				}
				this.next = head;
				head = this;
			}
			running[this.target] = this;
		}
		
		private function detach() : void
		{
			var _loc1_:aze.motion.EazeTween = null;
			var _loc2_:aze.motion.EazeTween = null;
			if(this.target && this._started)
			{
				_loc1_ = running[this.target];
				if(_loc1_ == this)
				{
					if(this.rnext)
					{
						running[this.target] = this.rnext;
					}
					else
					{
						delete running[this.target];
					}
				}
				else if(_loc1_)
				{
					_loc2_ = _loc1_;
					_loc1_ = _loc1_.rnext;
					while(_loc1_)
					{
						if(_loc1_ == this)
						{
							_loc2_.rnext = this.rnext;
							break;
						}
						_loc2_ = _loc1_;
						_loc1_ = _loc1_.rnext;
					}
				}
				this.rnext = null;
			}
		}
		
		private function dispose() : void
		{
			var _loc1_:aze.motion.EazeTween = null;
			if(this._started)
			{
				this.target = null;
				this._onComplete = null;
				this._onCompleteArgs = null;
				if(this._chain)
				{
					for each(_loc1_ in this._chain)
					{
						_loc1_.dispose();
					}
					this._chain = null;
				}
			}
			if(this.properties)
			{
				this.properties.dispose();
				this.properties = null;
			}
			this._ease = null;
			this._onStart = null;
			this._onStartArgs = null;
			if(this.slowTween)
			{
				if(this.specials)
				{
					this.specials.dispose();
					this.specials = null;
				}
				this.autoVisible = false;
				this._onUpdate = null;
				this._onUpdateArgs = null;
			}
		}
		
		public function delay(param1:*, param2:Boolean = true) : aze.motion.EazeTween
		{
			return this.add(param1,null,param2);
		}
		
		public function apply(param1:Object = null, param2:Boolean = true) : aze.motion.EazeTween
		{
			return this.add(0,param1,param2);
		}
		
		public function play(param1:* = 0, param2:Boolean = true) : aze.motion.EazeTween
		{
			return this.add("auto",{"frame":param1},param2).easing(Linear.easeNone);
		}
		
		public function to(param1:*, param2:Object = null, param3:Boolean = true) : aze.motion.EazeTween
		{
			return this.add(param1,param2,param3);
		}
		
		public function from(param1:*, param2:Object = null, param3:Boolean = true) : aze.motion.EazeTween
		{
			return this.add(param1,param2,param3,true);
		}
		
		private function add(param1:*, param2:Object, param3:Boolean, param4:Boolean = false) : aze.motion.EazeTween
		{
			if(this.isDead)
			{
				return new aze.motion.EazeTween(this.target).add(param1,param2,param3,param4);
			}
			if(this._configured)
			{
				return this.chain().add(param1,param2,param3,param4);
			}
			this.configure(param1,param2,param4);
			if(this.autoStart)
			{
				this.start(param3);
			}
			return this;
		}
		
		public function chain(param1:Object = null) : aze.motion.EazeTween
		{
			var _loc2_:aze.motion.EazeTween = new aze.motion.EazeTween(param1 || this.target,false);
			if(!this._chain)
			{
				this._chain = [];
			}
			this._chain.push(_loc2_);
			return _loc2_;
		}
		
		public function get isStarted() : Boolean
		{
			return this._started;
		}
		
		public function get isFinished() : Boolean
		{
			return this.isDead;
		}
	}
}

final class EazeProperty
{
	 
	
	public var name:String;
	
	public var start:Number;
	
	public var end:Number;
	
	public var delta:Number;
	
	public var next:EazeProperty;
	
	function EazeProperty(param1:String, param2:Number, param3:EazeProperty)
	{
		super();
		this.name = param1;
		this.end = param2;
		this.next = param3;
	}
	
	public function init(param1:Object, param2:Boolean) : void
	{
		if(param2)
		{
			this.start = this.end;
			this.end = param1[this.name];
			param1[this.name] = this.start;
		}
		else
		{
			this.start = param1[this.name];
		}
		this.delta = this.end - this.start;
	}
	
	public function dispose() : void
	{
		if(this.next)
		{
			this.next.dispose();
		}
		this.next = null;
	}
}

import aze.motion.EazeTween;

final class CompleteData
{
	 
	
	private var callback:Function;
	
	private var args:Array;
	
	private var chain:Array;
	
	private var diff:Number;
	
	function CompleteData(param1:Function, param2:Array, param3:Array, param4:Number)
	{
		super();
		this.callback = param1;
		this.args = param2;
		this.chain = param3;
		this.diff = param4;
	}
	
	public function execute() : void
	{
		var _loc1_:int = 0;
		var _loc2_:int = 0;
		if(this.callback != null)
		{
			this.callback.apply(null,this.args);
			this.callback = null;
		}
		this.args = null;
		if(this.chain)
		{
			_loc1_ = this.chain.length;
			_loc2_ = 0;
			while(_loc2_ < _loc1_)
			{
				EazeTween(this.chain[_loc2_]).start(false,this.diff);
				_loc2_++;
			}
			this.chain = null;
		}
	}
}
