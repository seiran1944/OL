package MVCprojectOL.ViewOL.Effects {
	
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 @version 13.01.09.15.20
	 */
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.Dictionary;
	
	public final class BlingEffect {

		//Package Info for debug
		//private static const _PackageInf:String = " * From Package BlingEffect.as ";
		//private static const _ActionMessage:String = "#ver 13.01.10 : "; @ Modified By K.J. Aris

		private static const _FrameRate:uint = 30;//25
		private static const _BlingList:Dictionary = new Dictionary( true );
		
		private static const _msPerUpdate:uint = uint( 1000 / _FrameRate );
		
		public static function BlingMe( _InputTarget:Sprite , _InputTimes:Number = 2 , _InputDuration:Number = 0.1 ):void {
			( _BlingList[ _InputTarget ] == null ) ? StartBling( _InputTarget , _InputTimes , _InputDuration ) : null;
		}
		
		public static function StopMe( _InputTarget:Sprite ):void {
			if ( !( _InputTarget in _BlingList ) ) {
				BlingEffect._BlingList[ _InputTarget ].Stop();
			}
		}
		
		private static function StartBling( _InputTarget:Sprite , _InputTimes:Number , _InputDuration:Number ):void {
			//trace( "Start Shaking " + _InputTarget.name );
			if ( !( _InputTarget in _BlingList ) ) {
				BlingEffect._BlingList[ _InputTarget ] = new Bling( BlingEffect.Clear , _InputTarget , _InputTimes , _InputDuration );
				BlingEffect._BlingList[ _InputTarget ].Start();
			}
			
		}//end BlingMe

		private static function Clear( _InputTarget:DisplayObject ):void {
			delete BlingEffect._BlingList[ _InputTarget ];
		}


	}//end class
}//end package



	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	class Bling {
		private var _EndAddress:Function;
		private var _Target:Sprite;
		private var _Times:uint;
		private var _Durations:Number;
		
		public function Bling( _InputEndAddress:Function , _InputTarget:Sprite , _InputTimes:uint , _InputDuration:Number ){
			this._EndAddress = _InputEndAddress;
			this._Target = _InputTarget;
			this._Times = _InputTimes;
			this._Durations = _InputDuration;
		}
		
		public function Start():void {
			this.doBling( this._Target );
		}
		
		private function doBling( _InputTarget:Sprite , _InputCurrentTimes:uint = 0 ):void {
			_InputCurrentTimes++;
			//trace( "doBling" , _InputCurrentTimes );
			TweenMax.to(_InputTarget, this._Durations, { colorTransform : { redOffset : 255 , greenOffset : 255 , blueOffset : 255 }} );
			TweenMax.to(_InputTarget, this._Durations, { delay : this._Durations ,colorTransform : { redOffset : 0 , greenOffset : 0 , blueOffset : 0 } , onComplete:this.BlingDone , onCompleteParams:[ _InputTarget , _InputCurrentTimes ] } );
		}
		
		private function BlingDone( _InputTarget:Sprite , _InputTimes:uint ):void {
			//trace( "BlingDone" );
			( _InputTimes >= this._Times ) ? this.Stop() : this.doBling( _InputTarget , _InputTimes );
		}
		
		public function Stop():void {
			//trace( "Stop" );
			TweenMax.killTweensOf( this._Target );
			this._EndAddress( this._Target );
		}

	}//end class