package Spark.MVCs.Models.SoundPlayer {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	 
	 
	public final class MusicTrack {
		
		private var _ID:String;
		private var _Music:Sound;
		
		private var _Volume:Number = 0.0;// default volume
		private var _SoundChannel:SoundChannel=new SoundChannel();//sound channel  ( 32 sound rail play simultaneously max in flash)
		private var _SoundTransform:SoundTransform = new SoundTransform( _Volume );
		
		private var _isPlaying:Boolean = false; 
		
		private var _LastPlayPosition:Number = 0;
		
		public function MusicTrack( _InputID:String , _InputMusic:Sound ) {// , _InputVolume:Number
			this._ID = _InputID;
			this._Music = _InputMusic;
			//this._Volume = _InputVolume;
			
			this._SoundTransform.volume = this._Volume;
			this._SoundChannel.soundTransform = this._SoundTransform;
		}
		
		public function Play( _InputStartTime:Number = 0 , _InputRepeat:uint = 0 ):void {
			//trace( "Repeat" , _InputRepeat , "times" );
			if ( this._isPlaying == false && this._Music != null ) {
				this._isPlaying = true;
				this._SoundChannel = this._Music.play( _InputStartTime , _InputRepeat , this._SoundTransform );
				this._SoundChannel.addEventListener( Event.SOUND_COMPLETE , this.MusicComplete );
			}else {
				return;
			}
		}
		
		private function MusicComplete( EVT:Event = null ):void {
			//trace("Complete");
			this._SoundChannel.removeEventListener( Event.SOUND_COMPLETE , this.MusicComplete );
			this._isPlaying = false;
		}
		
		
		public function Stop():void {
			this._LastPlayPosition = this._SoundChannel.position;
			this._SoundChannel.stop();
			this.MusicComplete();
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
		
		public function get Position():Number {
			return this._SoundChannel.position;
		}
		
		public function get LastPlayPosition():Number {
			return _LastPlayPosition;
		}
		
		public function get isPlaying():Boolean {
			return _isPlaying;
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