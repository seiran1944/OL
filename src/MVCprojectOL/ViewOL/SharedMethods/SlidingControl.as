package MVCprojectOL.ViewOL.SharedMethods 
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author K.J. Aris
	 * rewrite Paladin 121114
	 */
	public class SlidingControl extends EventDispatcher{
		private var _MainContainer:Sprite;
		private var _Content:Array = [];
		
		public var _Cols:uint = 1;//直排數
		public var _Rows:uint = 1;//橫列數(定值)
		public var _MaxContains:uint = 1;//顯示總數
		
		public var _HorizontalInterval:uint = 1;
		public var _VerticalInterval:uint = 1;
		
		private var _CurrentGuests:Vector.<Sprite>;
		
		public var _RightInPosX:Number = 1;//右邊出入場位置
		public var _LeftInPosX:Number = 1;//左邊出入場位置
		
		public var _FlyDuration:Number = 0.8;
		public var _IndividualDelay:Number = 0.05;
		
		public function SlidingControl( _InputContainer:Sprite ) {
			this._MainContainer = _InputContainer;
		}
		
		public function NextPage( _InputMember:Vector.<Sprite> , _InputLeftOrRight:Boolean = true ):void {
			//_InputLeftOrRight	=>	true : 由右入場   false : 由左入場
			this._CurrentGuests != null ? this.GoOutStage( this._CurrentGuests , _InputLeftOrRight ) : null;
			this._CurrentGuests = _InputMember;
			var _CurrentTarget:Sprite;
			var _objAction:Object;
			var _StartPosX:Number = ( _InputLeftOrRight == true ) ? this._RightInPosX : this._LeftInPosX ;//決定入場初始位置
			var _CurrentIndividualDelay:Number = 0;
			
			for (var i:int = 0; i < _InputMember.length && i < this._MaxContains ; i++) {
				//var _objAction:Object = { delay:_CurrentIndividualDelay , ease:Quad.easeInOut };
					
				_CurrentTarget = _InputMember[ i ];
				_CurrentTarget.x = _StartPosX;
				_CurrentTarget.y = int(i / _Cols) * _VerticalInterval;

				//trace(i,_CurrentTarget.y);
				_CurrentTarget.alpha = 0;
				_CurrentIndividualDelay = ( _InputLeftOrRight == true ) ? this._IndividualDelay * i : this._IndividualDelay * (_InputMember.length - i);
				
				this._MainContainer.addChild( _CurrentTarget );
				
					_objAction = { /*delay:_CurrentIndividualDelay ,*/ ease:Quad.easeInOut , alpha:1 };
					_objAction.x = this._HorizontalInterval * ( i  % _Cols );
					_objAction.y = this._VerticalInterval * Math.floor( i / _Cols );
				if ( i >= _InputMember.length - 1  )  _objAction.onComplete = this.MovingDone;
				TweenLite.to( _CurrentTarget , this._FlyDuration , _objAction);
			}
			
		}
		
		private function GoOutStage( _InputMember:Vector.<Sprite> , _InputLeftOrRight:Boolean = true ):void {
			//_InputLeftOrRight	=>	true : 由右入場   false : 由左入場
			var _NextPosX:Number = ( _InputLeftOrRight == true ) ? this._LeftInPosX : this._RightInPosX ;//決定出場初始位置
			var _CurrentIndividualDelay:Number = 0;
			for (var i:int = 0; i < _InputMember.length && i < this._MaxContains ; i++) {
				_CurrentIndividualDelay = ( _InputLeftOrRight == true ) ? this._IndividualDelay * i : this._IndividualDelay * (_InputMember.length - i);
				//_InputMember[ i ].alpha = 0;
				TweenLite.to( _InputMember[ i ] , this._FlyDuration , { x:_NextPosX , /*delay:_CurrentIndividualDelay ,*/ alpha:0 , ease:Quad.easeOut , onComplete:this.RemoveTarget , onCompleteParams:[ _InputMember[ i ] ] } );
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
			this._MainContainer.removeChild( _InputTarget );
		}
		
		private function MovingDone():void {
			this.dispatchEvent( new Event( "MovingDone" ) );
		}
		
		public function get CurrentGuests():Vector.<Sprite> {
			return this._CurrentGuests;
		}
		
		
		
	}//end class

}