package MVCprojectOL.ViewOL.Effects {
	
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 @version 13.01.09.15.20
	 */
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.Dictionary;
	
	public final class ShakeEffect {

		//Package Info for debug
		//private static const _PackageInf:String = " * From Package ShakeEffect.as ";
		//private static const _ActionMessage:String = "#ver 12.02.23.10.37 : ";//@Original Author: pixelwelders.earthShake  @ Modified By K.J. Aris

		private static const _FrameRate:uint = 30;//25
		private static const _ShakingList:Dictionary = new Dictionary( true );
		
		private static const _msPerUpdate:uint = uint( 1000 / _FrameRate );
		
		public static function ShakeMe( _InputTarget:DisplayObject , _Input_Intensity:Number = 6 , _InputDurations:uint = 1000 , _InputEase:Boolean = false , _InputIntensityDecayRate:Number = 0.01 ):void {
			( _ShakingList[ _InputTarget ] == null ) ? StartShake( _InputTarget , _Input_Intensity , _InputDurations , _InputEase , _InputIntensityDecayRate ) : null;
		}
		
		public static function StopMe( _InputTarget:DisplayObject ):void {
			if ( !( _InputTarget in _ShakingList ) ) {
				ShakeEffect._ShakingList[ _InputTarget ].Stop();
			}
		}
		
		private static function StartShake( _InputTarget:DisplayObject , _Input_Intensity:Number = 6 , _InputDurations:uint = 1000 , _InputEase:Boolean = false , _InputIntensityDecayRate:Number = 0.01 ):void {
			//trace( "Start Shaking " + _InputTarget.name );
			if ( !( _InputTarget in _ShakingList ) ) {
				ShakeEffect._ShakingList[ _InputTarget ] = new Shake( ShakeEffect.Clear , _InputTarget , _Input_Intensity , _InputDurations , _InputEase , _InputIntensityDecayRate , _msPerUpdate );
				ShakeEffect._ShakingList[ _InputTarget ].Start();
			}
			
		}//end ShakeMe

		private static function Clear( _InputTarget:DisplayObject ):void {
			delete ShakeEffect._ShakingList[ _InputTarget ];
		}


	}//end class
}//end package



	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	class Shake {
		private var _EndAddress:Function;
		private var _Target:DisplayObject;
		private var _Intensity:Number;
		private var _Durations:int;
		private var _Ease:Boolean;
		private var _IntensityDecayRate:Number;
		
		
		private var _OriPoint:Point;
		private var _IntensityOffset:int;
		private var _ShakingTimer:Timer;
		
		public function Shake( _InputEndAddress:Function , _InputTarget:DisplayObject , _Input_Intensity:Number = 6 , _InputDurations:uint = 1000 , _InputEase:Boolean = false , _InputIntensityDecayRate:Number = 0.01 , _msPerUpdate:uint = 30 ){
			this._EndAddress = _InputEndAddress;
			this._Target = _InputTarget;
			this._Intensity = _Input_Intensity;
			this._Durations = _InputDurations;
			this._Ease = _InputEase;
			this._IntensityDecayRate = _InputIntensityDecayRate;
			
			this._OriPoint = new Point( _InputTarget.x , _InputTarget.y );
			
			var _OriginalX:int = _InputTarget.x;
			var _OriginalY:int = _InputTarget.y;

			this._IntensityOffset = _Input_Intensity >> 1;//*0.5

			// truncations and Numbereger math are faster
			//var _msPerUpdate:int = int( 1000 / _FrameRate );
			
			var _totalUpdates:uint = uint( _InputDurations / _msPerUpdate );

			this._ShakingTimer = new Timer( _msPerUpdate , _totalUpdates );
			

			
		}
		
		public function Start():void {
			this._ShakingTimer.addEventListener( TimerEvent.TIMER , this.StartShake );
			this._ShakingTimer.addEventListener( TimerEvent.TIMER_COMPLETE , this.EndShake );

			this._ShakingTimer.start();
		}
		
		public function Stop():void {
			this.EndShake();
		}
		
		
		private function StartShake( EVT:TimerEvent ):void {
				this._Intensity = this._Ease == true ? ( this._Intensity > 0 ? this._Intensity -= this._IntensityDecayRate : 0 )  : this._Intensity;
				this._Target.x = this._OriPoint.x + Math.random() * this._Intensity - this._IntensityOffset;
				this._Target.y = this._OriPoint.y + Math.random() * this._Intensity - this._IntensityOffset;
		}

		private function EndShake( EVT:TimerEvent = null ):void {
				this._ShakingTimer.stop();
				
				this._Target.x = this._OriPoint.x;
				this._Target.y = this._OriPoint.y;

				this.CleanUp();
		}

		private function CleanUp():void {
				this._ShakingTimer.removeEventListener( TimerEvent.TIMER, this.StartShake );
				this._ShakingTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, this.EndShake );
				this._ShakingTimer = null;
				
				this._EndAddress( this._Target );
		}
	}