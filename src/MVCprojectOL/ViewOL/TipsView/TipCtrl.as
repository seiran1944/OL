
package MVCprojectOL.ViewOL.TipsView 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	//import MVCprojectOL.ModelOL.ShowSideSys.BaseItemView;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.BaseItemView;
	/**
	 * ...
	 * @author brook
	 */
	public class TipCtrl extends EventDispatcher
	{
		private var _MainContainer:DisplayObjectContainer;
		private var _CurrentTip:Vector.<BaseItemView> = new Vector.<BaseItemView>;
		
		private var _AdmittanceX:int = 0;//x軸入場位置
		private var _AdmittanceY:int = 0;//y軸入場位置
		public var _FinalX:int = 0;//x軸最後位置
		public var _FinalY:int = 0;//y軸最後位置
		private var _Interval:int = 85;//tip間隔
		public var _Timer:int = 150;//顯示時間長度
		private var _sendFunction:Function;
		private var _onTimer:Timer = new Timer(1000);
		private var _Length:int;
		
		public function TipCtrl(_InputContainer:DisplayObjectContainer,_sendfun:Function)
		{
			this._MainContainer = _InputContainer;
			this._sendFunction = _sendfun;
		}
		
		public function SetAdmittanceInfo(_x:int,_y:int,_finalX:int,_finalY:int):void 
		{
			this._AdmittanceX = _x;
			this._AdmittanceY = _y;
			this._FinalX = _finalX;
			this._FinalY = _finalY;
		}
		
		public function AddTip(_InputSprite:Sprite):void
		{
			trace("Tip 進來拉");
			this._CurrentTip.push(_InputSprite);
			var _IndexNum:int = this._CurrentTip.length - 1;
				this._CurrentTip[_IndexNum].x = _AdmittanceX;
				this._CurrentTip[_IndexNum].y = _AdmittanceY;
				this._CurrentTip[_IndexNum].alpha = 0;
			this._MainContainer.addChild(this._CurrentTip[_IndexNum]);
			this._MainContainer.setChildIndex(this._CurrentTip[_IndexNum], 0);
			
			if (this._CurrentTip.length == 1 ) {
				this._Length = this._CurrentTip.length;
				this.InitialAction(_IndexNum);
				this._onTimer.start();
				this._onTimer.addEventListener(TimerEvent.TIMER, _onDisplay);
			}
		}
		private function _onDisplay(event:TimerEvent):void 
		{
			//trace(this._CurrentTip.length, "---------------------------------------------------------");
			if (this._Length != this._CurrentTip.length) {
				this._Length++;
				this.RisingAction(this._Length);
			}
		}
		//tip初始動作
		private function InitialAction(_InputNum:int):void
		{
			TweenLite.to( this._CurrentTip[_InputNum], 1, { x:this._FinalX, y:this._FinalY, alpha:1 } );
			this.TimerHandler(this._CurrentTip[_InputNum]);
		}
		//tip上升動作
		private function RisingAction(_InputNum:int):void
		{
			for (var i:int = 0; i < _InputNum - 1; i++) 
			{
				TweenLite.to( this._CurrentTip[i], 1, { y:this._CurrentTip[i].y - this._Interval } );
			}
			this.InitialAction(_InputNum - 1);
		}
		
		private function TimerHandler(_InputCurrentTip:Sprite):void
		{
			var _TimerNum:int = 0;
			//var _CtrlBoolean:Boolean = true;
			this._MainContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			function onEnterFrame(e:Event):void
			{
				_TimerNum += 1;
				if (_TimerNum == _Timer) {
					TweenLite.to( _InputCurrentTip, 2, { alpha:0, onComplete:RemoveHandler, onCompleteParams:[_InputCurrentTip] } );
					_MainContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
		
		public function StopHandler():void 
		{
			var _TipLength:int = this._CurrentTip.length;
			for (var i:int = 0; i < _TipLength; i++) 
			{
				this._CurrentTip[i].visible = false;
			}
		}
		
		private function RemoveHandler(_InputCurrentTip:BaseItemView):void
		{
			this._MainContainer.removeChild(_InputCurrentTip);
			//trace(this._MainContainer.numChildren,"+++++++++++++++++++++++++++++++++");
			if (this._MainContainer.numChildren == 2) {
				this._CurrentTip.splice(0, this._CurrentTip.length);
				this._onTimer.stop();
				this._onTimer.removeEventListener(TimerEvent.TIMER, _onDisplay);
			}
			this._sendFunction(_InputCurrentTip._groupName,_InputCurrentTip._guid);
		}

	}
}