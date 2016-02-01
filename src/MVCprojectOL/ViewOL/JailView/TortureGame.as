package MVCprojectOL.ViewOL.JailView 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import MVCprojectOL.ViewOL.SharedMethods.TimeConversion;
	import Spark.SoarVision.single.BitmapVision;
	/**
	 * ...
	 * @author brook
	 */
	public class TortureGame 
	{
		private var _MainContainer:DisplayObjectContainer;
		private var _JailObj:Object;
		private var _BGObj:Object;
		
		private var _CtrlMoveBar:Boolean;
		private var _MoveBarSpeed:uint = 15;//移動速度
		private var _Metering:uint = 3;//點擊次數
		private var _IntervalTimer:int = 0;
		private var _NumBmp:Vector.<Bitmap> = new <Bitmap>[new Bitmap(),new Bitmap(),new Bitmap(),new Bitmap(),new Bitmap()];
		private var _TimeNum:Vector.<int> = new Vector.<int>;
		
		private var _Timer:Timer = new Timer(1000);
		private var _TotalTime:int = 30;//倒數時間
		private var _TxtFormat:TextFormat = new TextFormat();
		private var _ReduceSensingArea:int;
		private var _Countdown:uint = 3;//倒數時間
		
		public function TortureGame(_InputContainer:DisplayObjectContainer, _InputJailObj:Object, _InputBGObj:Object, _InputAreaWidth:int ) 
		{
			this._MainContainer = _InputContainer;
			this._JailObj = _InputJailObj;
			this._BGObj = _InputBGObj;
			
			var _CrossBar:Sprite = new (this._JailObj.CrossBar as Class);
				_CrossBar.x = 100;
				_CrossBar.y = 400;
				_CrossBar.name = "CrossBar";
			this._MainContainer.addChild(_CrossBar);
			
			var _SensingArea:Sprite = this.DrawRect(0xCCCCCC, 0, 0, _InputAreaWidth, 24);
			var _RandomNum:int = (490 - _InputAreaWidth) - 155;
				_SensingArea.x = 155 + Math.random() * _RandomNum;
				_SensingArea.y = 63;
				_SensingArea.alpha = 0.5;
				_SensingArea.name = "SensingArea";
			_CrossBar.addChild(_SensingArea);
			this._ReduceSensingArea = _SensingArea.width / this._Metering;
			
			var _MoveBar:Sprite = new (this._JailObj.MoveBar as Class);
				_MoveBar.x = 155;
				_MoveBar.y = 63;
				_MoveBar.name = "MoveBar";
			_CrossBar.addChild(_MoveBar);
			
			var _StopBtn:MovieClip=new (this._JailObj.StopBtn as Class);
				_StopBtn.x = 657;
				_StopBtn.y = 32;
				_StopBtn.name = "StopBtn";
				_StopBtn.buttonMode = true;
				_StopBtn.gotoAndStop(2);
				//_StopBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
			_CrossBar.addChild(_StopBtn);
			
			var _Fire:BitmapVision = this._JailObj.Fire
				_Fire.x = 85;
				_Fire.y = -30;
			_CrossBar.addChild(_Fire);
			
			this._TxtFormat.color = 0xF5C401;
			this._TxtFormat.size = 50;
			this._TxtFormat.bold = true;
			var _NumberTimeText:TextField = new TextField();
				_NumberTimeText.defaultTextFormat = this._TxtFormat;
				_NumberTimeText.x = 95;
				_NumberTimeText.y = -10;
				_NumberTimeText.width = 40;
				_NumberTimeText.height = 50;
				_NumberTimeText.mouseEnabled = false;
				_NumberTimeText.name = "NumTime";
				_NumberTimeText.text = String(this._Metering);
			_CrossBar.addChild(_NumberTimeText);
			
			for (var i:int = 0; i < 5; i++) 
			{
				(i != 2)?this._NumBmp[i].bitmapData = this._BGObj.timerBasic[0]:this._NumBmp[i].bitmapData = this._BGObj.timerBasic[10];
				this._NumBmp[i].x = 53 + i * 20;
				this._NumBmp[i].y = 105;
				_CrossBar.addChild(this._NumBmp[i]);
			}
			this.TimingHandler(this._TotalTime);
			
			this._Timer.start();
			this._Timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
		}
		
		private function StartGame():void
		{
			this._MainContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("StopBtn").addEventListener(MouseEvent.CLICK, onClickHandler);
			MovieClip(Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("StopBtn")).gotoAndStop(1);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (this._Metering > 0) { 
				//var _RandomNum:int = Math.random() * 10;
				if (Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").x <= 155 /*+ _RandomNum*/ ) { 
					this._CtrlMoveBar = true;
				}
				else if (Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").x >= 620 - this._MoveBarSpeed /*- _RandomNum*/ ) {
					this._CtrlMoveBar = false;
				}
				(this._CtrlMoveBar == true)?Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").x += this._MoveBarSpeed /*+_RandomNum*/ :Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").x -= this._MoveBarSpeed /*+_RandomNum*/;
			}else {
				this._MainContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("StopBtn").removeEventListener(MouseEvent.CLICK, onClickHandler);
			if (this._Metering > 0) {
				TextField(Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("NumTime")).text = String(this._Metering - 1);
				MovieClip(Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("StopBtn")).gotoAndStop(2);
				this._IntervalTimer = 0;
				this._MainContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				this._MainContainer.addEventListener(Event.ENTER_FRAME, onTimer);
			}else {
				Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("StopBtn").removeEventListener(MouseEvent.CLICK, onClickHandler);
			}
		}
		
		private function onTimerHandler(e:TimerEvent):void
		{
			if (this._TotalTime >= 29 )(this._Countdown > 0 )? this._Countdown--:this.StartGame();
			
			if (this._TotalTime > 0 && this._Countdown == 0) { 
				this.TimingHandler(this._TotalTime);
				this._TotalTime--;
			} 
			
			if (this._TotalTime == 0) this.onRemove();
		}
		
		public function TimingHandler(_InputNowTime:int):void
		{
			this._TimeNum.length= 0;
			var _TimeConversion:TimeConversion = new TimeConversion();
			var _TimeStr:String = _TimeConversion.TimerConversion(_InputNowTime);
			for (var i:int = 1; i < 6; i++) 
			{
				this._TimeNum.push(_TimeStr.substr(i - 1, 1));
				(i != 3)?this._NumBmp[i-1].bitmapData = this._BGObj.timerBasic[this._TimeNum[i-1]]:this._NumBmp[i-1].bitmapData = this._BGObj.timerBasic[10];
			}
		}
		
		private function onTimer(e:Event):void
		{
			this._IntervalTimer ++;
			if (this._IntervalTimer == 10) 
			{
				if ((Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").x >= Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea").x && Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").x <= Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea").x + Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea").width)
				&&(Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").x + Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").width >= Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea").x && Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").x + Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").width <= Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea").x + Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea").width)) 
				{
					trace("中了,中了,中了");
				}else {
					trace("爛透了");
				}
				
				/*if (Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("MoveBar").hitTestObject(Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea"))) {
					trace("中了,中了,中了");
				}else {
					trace("爛透了");
				}*/
				
				Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("StopBtn").addEventListener(MouseEvent.CLICK, onClickHandler);
				MovieClip(Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("StopBtn")).gotoAndStop(1);
				if (this._Metering > 1) {
					Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea").width = Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea").width - this._ReduceSensingArea;
					var _RandomNum:int = (490 - Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea").width) - 155;
					Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("SensingArea").x = 155 + Math.random() * _RandomNum;
				}else {
					this.onRemove();
				}
				this._MainContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				this._MainContainer.removeEventListener(Event.ENTER_FRAME, onTimer);
				this._Metering--;
			}
		}
		
		private function onRemove():void
		{
			MovieClip(Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("StopBtn")).gotoAndStop(2);
			this._Timer.stop();
			this._Timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
			this._MainContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			Sprite(this._MainContainer.getChildByName("CrossBar")).getChildByName("StopBtn").removeEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		private function DrawRect(_Color:int,_LocationX:int, _LocationY:int, _Width:int, _Height:int):Sprite
		{
			var _sp:Sprite = new Sprite ();
				_sp.graphics.beginFill(_Color);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}
		
	}
}