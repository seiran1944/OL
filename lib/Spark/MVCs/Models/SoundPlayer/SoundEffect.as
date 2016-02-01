package Spark.MVCs.Models.SoundPlayer{
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.04.19.16.58
	 */
	import flash.events.Event;
	import flash.media.Sound;

	import flash.utils.Dictionary;
	 
	//import SourceProxys.SourceProxy;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.MVCs.Models.SoundPlayer.SoundTrack;
	
	
	public final class SoundEffect {
		public static var _SoundEffect:SoundEffect
		
		private var _SoundEffectVolume:Number = 1.0;// default volume
		
		private var _Mute:Boolean = false;
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		private var _SoundEffectTrackList:Dictionary = new Dictionary();
		
		public static function GetInstance():SoundEffect {
			return SoundEffect._SoundEffect ||= new SoundEffect();
		}
		
		public function SoundEffect() {
			SoundEffect._SoundEffect = this;
		}
		
		private function AddSound( _InputKey:String , _InputSound:Sound ):SoundTrack {
			if ( _InputSound != null ) {
				this._SoundEffectTrackList[ _InputKey ] = new SoundTrack( _InputKey , _InputSound );
			}
			return this._SoundEffectTrackList[ _InputKey ];
		}
		
		
		
		
		//---------------------------------------------------------------------------------------------播放音效
		
		public function Play(  _InputSoundKey:String  , _InputRepeat:uint = 0 ):void {
			this._Mute == false ? this.InstancePlay( _InputSoundKey , _InputRepeat ) : null;//mute switch
		}
		
		public function Stop():void {
			for (var i:* in this._SoundEffectTrackList ) {
				SoundTrack( this._SoundEffectTrackList[ i ] ).Stop();
			}
		}
		
		private function InstancePlay(  _InputSoundKey:String  , _InputRepeat:uint = 0 ):void {
			//this._SoundEffect_channel = Sound( this.CheckStock( _InputSoundKey ) ).play( 0 , _InputRepeat , this._SoundEffect_Transformer );//自己開始play		//this.CheckStorageOrLoad( this._SoundList , _InputComboSoundList[ _Counter ] , this._Domain )
			var _Target:SoundTrack = SoundTrack( this.CheckStock( _InputSoundKey ) );
			( _Target != null ) ? _Target.Play( 0 , this._SoundEffectVolume , _InputRepeat ) : null;
			//( _InputRepeat > 0 ) ? this._SoundEffect_channel.addEventListener( Event.SOUND_COMPLETE , this.RepeatBridge ) : null; 
			//trace("Playing" , _InputSoundKey , this._SoundEffectVolume , this.CheckStock( _InputSoundKey ) );
		}
		
		/*private function ComboPlay():void {
			// I don't know how to do yet. 	120907		K.J.	Aris
		}*/
		
		private function CheckStock( _InputKey:String ):SoundTrack {
			var _Reply:SoundTrack;
				_Reply = ( this._SoundEffectTrackList[ _InputKey ] != null ) ? 
						this._SoundEffectTrackList[ _InputKey ] 
					: 
						this.AddSound( _InputKey , this._SourceProxy.GetMaterialSound( _InputKey ) );
				
			return _Reply;
			//return new Sound( new URLRequest( "http://castellan-wg.runewaker.com/gamedata/sound/Epic Ending 2_1.mp3" ) );
		}
		
		/*private function SoundFileCheck( _InputKey:String ):Sound {
			
		}*/
		
		//----------------------------------------------------------------------------------END--------播放音效
		
		
		
		
		
		//----------------------------------------------------------------------------------------------Getter & setter
		public function get Volume():Number {
			return this._SoundEffectVolume;
		}
		
		public function set Volume( _value:Number ):void {
			this._SoundEffectVolume = _value;
			
			this._Mute = this._SoundEffectVolume <= 0 ? true : false;//auto mute when volume value less than 0 
			
			for ( var i:* in this._SoundEffectTrackList ) {
				SoundTrack( this._SoundEffectTrackList[ i ] ).Volume = this._SoundEffectVolume;
			}
		}
		
		public function get Mute():Boolean {
			return this._Mute;
		}
		
		/*public function set Mute( _value:Boolean ):void {
			if ( this._Mute != _value ) {
				this._Mute = _value;
				for ( var i:* in this._SoundEffectTrackList ) {
					SoundTrack( this._SoundEffectTrackList[ i ] ).Stop();
				}
			}
			
		}*/
		public function setMute( ):void {
				for ( var i:* in this._SoundEffectTrackList ) {
					SoundTrack( this._SoundEffectTrackList[ i ] ).Stop();
				}
			
		}
		//----------------------------------------------------------------------------------END---------Getter & setter
		
		
		
		
		
		
		
	}//end class

}//end package