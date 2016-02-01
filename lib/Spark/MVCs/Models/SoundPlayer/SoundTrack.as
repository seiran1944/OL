package Spark.MVCs.Models.SoundPlayer {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	 
	 
	public final class SoundTrack {
		
		private var _ID:String;
		private var _Sound:Sound;
		
		private var _Volume:Number = 0.0;// default volume
		private var _SoundChannel:SoundChannel=new SoundChannel();//sound channel  ( 32 sound rail play simultaneously max in flash)
		private var _SoundTransform:SoundTransform = new SoundTransform( _Volume );
		
		private var _isPlaying:Boolean = false;
		
		public function SoundTrack( _InputID:String , _InputSound:Sound ) {// , _InputVolume:Number
			this._ID = _InputID;
			this._Sound = _InputSound;
			//this._Volume = _InputVolume;
			
			this._SoundTransform.volume = this._Volume;
			this._SoundChannel.soundTransform = this._SoundTransform;
		}
		
		public function Play( _InputStartTime:Number = 0 , _InputVolume:Number = 0 , _InputRepeat:uint = 0 ):void {
			if ( this._isPlaying == false && this._Sound != null ) {
				this.Volume = _InputVolume;
				this._SoundChannel = this._Sound.play( _InputStartTime , _InputRepeat , this._SoundTransform );
				( _InputRepeat > 1 ) ? this.LockUpTrack() : null;
			}else {
				return;
			}
		}
		
		private function LockUpTrack():void {
				this._isPlaying = true;
				this._SoundChannel.addEventListener( Event.SOUND_COMPLETE , this.MusicComplete );
		}
		
		private function MusicComplete( EVT:Event = null ):void {
			//trace("Complete");
			this._SoundChannel.removeEventListener( Event.SOUND_COMPLETE , this.MusicComplete );
			this._isPlaying = false;
		}
		
		
		
		public function Stop():void {
			this._SoundChannel.stop();
		}
		
		
		public function get Volume():Number {
			return this._Volume;
		}
		
		public function set Volume( _value:Number ):void {
			this._Volume = _value;
			this._SoundTransform.volume = this._Volume;
			this._SoundChannel.soundTransform = this._SoundTransform;
			//trace( "now" , this._Volume );
		}
		
		public function get ID():String {
			return _ID;
		}
		
		/*public function get SoundTransform():SoundTransform {
			return this._SoundTransform;
		}
		
		public function get SoundChannel():SoundChannel {
			return this._SoundChannel;
		}*/
		
	}//end class
		
	

}//end package