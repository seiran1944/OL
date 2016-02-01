package MVCprojectOL.ViewOL.ExploreView.Display{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author Aris
	 * @version 13.06.17.10.24
	 */
	public class RouteLine {
		
		private var _Panel:Sprite;
		private var _BrightRouteSpot:Class;
		private var _DarkRouteSpot:Class;
		
		private var _DisplayList:Array = [ ];
		
		public function RouteLine( _InputPanel:Sprite ,  _InputBrightRouteSpot:Class , _InputDarkRouteSpot:Class ) {
			this._Panel = _InputPanel;
			this._BrightRouteSpot = _InputBrightRouteSpot;
			this._DarkRouteSpot = _InputDarkRouteSpot;
		}
		
		public function UpdatePanel( _InputPanel:Sprite ):void {
			this.ClearAll();
			this._Panel = _InputPanel;
		}
		/*public function AddRouteLine( _InputSpot1:Sprite , _InputSpot2:Sprite , _InputSpot2Accessible:Boolean , _InputSpotInterval:Number = 20 ):void {
			var _SpotType:Class = ( _InputSpot2Accessible == true ) ? this._BrightRouteSpot : this._DarkRouteSpot;
			
			var _Theta:Number = this.CalculateTheta( new Point( _InputSpot1.x , _InputSpot1.y ) , new Point( _InputSpot2.x , _InputSpot2.y ) );
			
			var _CosTheta:Number = Math.cos( _Theta );
			var _SinTheta:Number = Math.sin( _Theta );
			var _hypotenuseLength:Number = ( Math.abs( _InputSpot1.x - _InputSpot2.x ) / _CosTheta );
			var _hypotenuseInterval:Number = _InputSpotInterval / _CosTheta;
			var _MaxSpots:uint =  _hypotenuseLength / _hypotenuseInterval;
			
			var _xpos:Number;
			var _ypos:Number;
			
			var _hypotenuseVar:Number;
			
			var _Display:DisplayObject;
			for (var i:int = 0; i < _MaxSpots - 1 ; i++) {
				_hypotenuseVar = _hypotenuseInterval * ( i + 1 );
				trace( _InputSpot1.x < _InputSpot2.x );
				//_hypotenuseVar = _InputSpot1.x < _InputSpot2.x ? Math.abs( _hypotenuseVar ) : -Math.abs( _hypotenuseVar );
				_xpos = _InputSpot1.x + ( _InputSpot1.width >> 1 ) + _hypotenuseVar * _CosTheta;
				
				//_hypotenuseVar = _InputSpot1.y < _InputSpot2.y ? Math.abs( _hypotenuseVar ) : -Math.abs( _hypotenuseVar );
				_ypos = _InputSpot1.y + ( _InputSpot1.height >> 1 ) + _hypotenuseVar * _SinTheta;
				
				_Display = new _SpotType();
				_Display.x = _xpos;
				_Display.y = _ypos;
				
				this._Panel.addChildAt( _Display , this._Panel.numChildren );

			}
			
		}*/
		
		/*private function CalculateTheta( _InputP1:Point , _InputP2:Point ):Number {
			var _xLength:Number = ( _InputP1.x - _InputP2.x );
			var _yLength:Number = ( _InputP1.y - _InputP2.y );
			
			var _Theta:Number =  _xLength < 0 ? Math.atan2( _yLength , _xLength ) : 1 - Math.atan2( _yLength , _xLength );// * 180 / Math.PI;
			
			return _Theta;
		}*/
		
		private function AddRouteLine( _InputSpot1:Sprite , _InputSpot2:Sprite , _InputSpot2Accessible:Boolean , _InputSpotInterval:Number = 10 ):void {
			var _SpotType:Class = ( _InputSpot2Accessible == true ) ? this._BrightRouteSpot : this._DarkRouteSpot;
			
			//var _Point1:Point = new Point( _InputSpot1.x + ( _InputSpot1.width >> 1 ) , _InputSpot1.y + ( _InputSpot1.height >> 1 ) );
			//var _Point1:Point = new Point( _InputSpot1.x + 35 , _InputSpot1.y + 35 );
			var _Point1:Point = new Point( _InputSpot1.x , _InputSpot1.y );
			//var _Point2:Point = new Point( _InputSpot2.x + ( _InputSpot2.width >> 1 ) , _InputSpot2.y + ( _InputSpot2.height >> 1 ) );
			//var _Point2:Point = new Point( _InputSpot2.x + 35 , _InputSpot2.y + 35 );
			var _Point2:Point = new Point( _InputSpot2.x , _InputSpot2.y );
			
			var _hypotenuseLength:Number = Point.distance( _Point1 , _Point2 );
			var _MaxSpots:uint =  _hypotenuseLength / _InputSpotInterval;
			
			var _xpos:Number;
			var _ypos:Number;
			
			var _hypotenuseVar:Number;
			
			var _xStepLength:Number = ( _Point1.x - _Point2.x ) / _MaxSpots;
			var _yStepLength:Number = ( _Point1.y - _Point2.y ) / _MaxSpots;
			
			var _Display:DisplayObject;
			for (var i:int = 0; i < _MaxSpots ; i++) {
				_xpos = _Point1.x - _xStepLength * i;
				
				_ypos = _Point1.y - _yStepLength * i;
				
				_Display = new _SpotType();
				_Display.x = _xpos;
				_Display.y = _ypos;
				_Display.scaleX = 0.2;
				_Display.scaleY = _Display.scaleX;
				_Display.alpha = 0;
				
				this._Panel.addChildAt( _Display , this._Panel.numChildren - 1 );
				
				//TweenLite.to( _Display , 0.5 , { delay:0.05*i , alpha:1.0 } );
				this._DisplayList.push( _Display );
			}
			
		}
		
		public function ClearAll():void {
			
			var _length:uint = this._DisplayList.length;
			for (var i:int = 0; i < _length; i++) {
				//this._Panel.removeChild( this._DisplayList[ i ] );
				this._DisplayList[ i ].parent != null ? this._DisplayList[ i ].parent.removeChild( this._DisplayList[ i ] ) : null;
				TweenLite.killTweensOf( this._DisplayList[ i ] );
			}
			this._DisplayList = [ ];
		}
		
		private function ShowCurrentRoute():void {
			var _length:uint = this._DisplayList.length;
			for (var i:int = 0; i < _length; i++) {
				TweenLite.to( this._DisplayList[ i ] , 0.5 , { delay:0.01*i , alpha:1.0 } );
			}
		}
		
		
		public function RouteFinder( _InputCurrentBigMap:Sprite , _InputMaxLevel:uint = 10 ):void {
			this.ClearAll();
			var _BigMapPt:Sprite = (_InputCurrentBigMap.getChildAt(0) as Sprite );
			this.UpdatePanel( _BigMapPt );
			var	_RouteFlag:Sprite;// = _BigMapPt.getChildByName("P" + i) as Sprite;
			var _LastRouteFlag:Sprite;
			for (var i:int = 1 ; i <= _InputMaxLevel ; i++) {
				
				for (var j:int = 1; j <= _InputMaxLevel; j++) {//先找子節點
					_RouteFlag = _BigMapPt.getChildByName("R" + ( i ) + "_" + ( j )  ) as Sprite;
					if ( _RouteFlag == null ) break;
					if ( _LastRouteFlag != null ) {
						this.AddRouteLine( _LastRouteFlag , _RouteFlag , true );
					}
					_LastRouteFlag = _RouteFlag;
				}
				
				_RouteFlag = _BigMapPt.getChildByName( "R" + ( i ) ) as Sprite;
				if ( _RouteFlag == null )	_RouteFlag = _BigMapPt.getChildByName("P" + i) as Sprite;
				if ( _LastRouteFlag != null ) {
					this.AddRouteLine( _LastRouteFlag , _RouteFlag , true );
				}
				
				_LastRouteFlag = _RouteFlag;
				
				
				
				
			}
			
			this.ShowCurrentRoute();
			
		}
		
		
	}//end class
}//end package