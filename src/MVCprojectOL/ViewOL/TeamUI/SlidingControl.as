package MVCprojectOL.ViewOL.TeamUI {
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import MVCprojectOL.ViewOL.TeamUI.IActionCtrl;
	/**
	 * ...
	 * @author K.J. Aris
	 * rewrite Paladin 121114
	 */
	public class SlidingControl extends EventDispatcher implements IActionCtrl
	{
		private var _MainContainer:DisplayObjectContainer;
		private var _Content:Array = [];
		
		public var _Cols:uint = 4;//直排數
		public var _Rows:uint = 2;//橫列數(定值)
		public const _MaxContains:uint = _Cols * _Rows;//顯示總數
		
		public var _HorizontalInterval:uint = 20;
		public var _VerticalInterval:uint = 20;
		
		private var _CurrentGuests:Vector.<DisplayObject>;
		
		public var _RightInPosX:Number = 500;//右邊出入場位置
		public var _LeftInPosX:Number = -500;//左邊出入場位置
		
		public var _FlyDuration:Number = 0.8;
		public var _IndividualDelay:Number = 0.05;
		
		public var _adjustHeight:int;
		
		public function SlidingControl( ) {
			
		}
		
		public function InitContainer(container:DisplayObjectContainer):void
		{
			this._MainContainer = container;
		}
		
		public function NextPage(group:Vector.<DisplayObject>):void
		{
			this.TurnPage(group);
			//this._MainContainer.addChild(group[0]);
		}
		
		public function PrevPage(group:Vector.<DisplayObject>):void
		{
			this.TurnPage(group, false);
		}
		
		public function TurnPage( _InputMember:Vector.<DisplayObject> , _InputLeftOrRight:Boolean = true ):void {
			//_InputLeftOrRight	=>	true : 由右入場   false : 由左入場
			this._CurrentGuests != null ? this.GoOutStage( this._CurrentGuests , _InputLeftOrRight ) : null;
			this._CurrentGuests = _InputMember;
			var _CurrentTarget:DisplayObject;
			var _objAction:Object;
			var _StartPosX:Number = ( _InputLeftOrRight == true ) ? this._RightInPosX : this._LeftInPosX ;//決定入場初始位置
			var _CurrentIndividualDelay:Number = 0;
			//trace("TURN PAGE INIT ", _InputMember, _InputLeftOrRight);
			for (var i:int = 0; i < _InputMember.length && i < this._MaxContains ; i++) {
				//var _objAction:Object = { delay:_CurrentIndividualDelay , ease:Quad.easeInOut };
				_CurrentTarget = _InputMember[ i ];
				_CurrentTarget.x = _StartPosX;
				_CurrentIndividualDelay = ( _InputLeftOrRight == true ) ? this._IndividualDelay * i : this._IndividualDelay * (_InputMember.length - i);
				
				this._MainContainer.addChild( _CurrentTarget );
					_objAction = { delay:_CurrentIndividualDelay , ease:Quad.easeInOut };
					_objAction.x = this._HorizontalInterval * ( i  % _Cols ) + 70;//暫時微調用
					_objAction.y = this._VerticalInterval * Math.floor( i / _Cols ) + this._adjustHeight;
					//trace("FLYING Y >>>>",_objAction.y,this._VerticalInterval,Math.floor(i / _Cols),_Cols);
				if (_InputMember.length-1 == i )  _objAction.onComplete = this.MovingDone;
				TweenLite.to( _CurrentTarget , this._FlyDuration , _objAction);
			}
			
		}
		
		private function GoOutStage( _InputMember:Vector.<DisplayObject> , _InputLeftOrRight:Boolean = true ):void {
			//_InputLeftOrRight	=>	true : 由右入場   false : 由左入場
			var _NextPosX:Number = ( _InputLeftOrRight == true ) ? this._LeftInPosX : this._RightInPosX ;//決定出場初始位置
			var _CurrentIndividualDelay:Number = 0;
			for (var i:int = 0; i < _InputMember.length && i < this._MaxContains ; i++) {
				_CurrentIndividualDelay = ( _InputLeftOrRight == true ) ? this._IndividualDelay * i : this._IndividualDelay * (_InputMember.length - i);
				TweenLite.to( _InputMember[ i ] , this._FlyDuration , { x:_NextPosX , delay:_CurrentIndividualDelay , ease:Quad.easeOut , onComplete:this.RemoveTarget , onCompleteParams:[ _InputMember[ i ] ] } );
			}
		}
		
		public function ClearStage( _InputLeftOrRight:Boolean = true ):void {
			//_InputLeftOrRight	=>	true : 由左出場   false : 由右出場
			//作清場動作 Note : 只會清除目標容器的內容(由該控制類add的子類)
			( this._CurrentGuests != null ) ? this.GoOutStage( this._CurrentGuests , _InputLeftOrRight ) : null;
			this._CurrentGuests = null;
		}
		
		public function RemoveTarget( _InputTarget:Sprite ):void {
			TweenLite.killTweensOf( _InputTarget , true );
			if(this._MainContainer.contains(_InputTarget))  this._MainContainer.removeChild( _InputTarget );
			
		}
		
		private function MovingDone():void {
			this.dispatchEvent( new Event( "MovingDone" ) );
		}
		
		public function get CurrentGuests():Vector.<DisplayObject> {
			return this._CurrentGuests;
		}
		
		public function Destroy():void 
		{
			while (this._MainContainer.numChildren>0) 
			{
				this._MainContainer.removeChildAt(0);
			}
		}
		
		
	}//end class
}//end package