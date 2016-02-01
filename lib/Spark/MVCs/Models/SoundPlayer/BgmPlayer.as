package  Spark.MVCs.Models.SoundPlayer{
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.31.15.51
	 */
	//import SourceProxys.SourceProxy;
	//import BGM.MusicTrack;
	import Spark.MVCs.Models.SoundPlayer.MusicTrack;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
		
	public final class BgmPlayer {
		public static var _BgmPlayer:BgmPlayer;
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		private var _MusicTrackList:Dictionary = new Dictionary();
		
		private var _Volume:Number = 1.0;
		
		//--------------------------Operator
		private var _CurrentTarget:MusicTrack;
		private var _LastTarget:MusicTrack;
		//-------------------END---Operator
		
		public var _TransferDuration:Number = 4.0;//sec
		public var _SlienceBufferTime:Number = 2.0;//sec
		
		//public var _SwitchingMode:String = "Casual";
		
		private var _isTransfering:Boolean = false;
		
		public static function GetInstance():BgmPlayer {
			return BgmPlayer._BgmPlayer ||= new BgmPlayer();
		}
		
		public function BgmPlayer() {
			BgmPlayer._BgmPlayer = this;
		}
		
		private function AddMusic( _InputKey:String ):MusicTrack {
			this.CheckStock( _InputKey ) != null ? this._MusicTrackList[ _InputKey ] = new MusicTrack( _InputKey , this.CheckStock( _InputKey ) ) : null;
			return this._MusicTrackList[ _InputKey ];
		}
		
		private function CheckStock( _InputKey:String ):Sound {
			//this._SourceProxy.PreloadMaterial( _InputKey );
			var _SoundFile:* = this._SourceProxy.GetMaterialSound( _InputKey );
			return ( _SoundFile is Sound ) ? Sound( _SoundFile ) : null ;//防錯機制(目前無效  尚需設定非空值的聲音載體)
			//return new Sound( new URLRequest( "http://castellan-wg.runewaker.com/gamedata/sound/Epic Ending 2_1.mp3" ) );
		}
		
		/*public function Play( _InputKey:String , _InputRepeat:uint = 0 , _InputFromLastPlay:Boolean = false ):void {
			this._CurrentTarget = ( this._MusicTrackList[ _InputKey ] == null ) ? this.AddMusic( _InputKey ) : this._MusicTrackList[ _InputKey ];
				( _InputFromLastPlay == true ) ? this._CurrentTarget.Play( this._CurrentTarget.LastPlayPosition ) :  this._CurrentTarget.Play();//使音樂從上個位置開始播放
				
				TweenLite.to( this._CurrentTarget , 8 , { Volume:this._Volume , onComplete:this.MusicTransformComplete } );
				this._LastTarget = this._CurrentTarget;
		}*/
		
		private function MakeOnlyOneSurvived(  ):void {//_InputTarget:MusicTrack
			trace( "Check and make sure there's only one player" );
			var _Target:MusicTrack;
			for ( var i:String in this._MusicTrackList ) {
				_Target = this._MusicTrackList[ i ];
				( _Target != this._CurrentTarget ) ? this.SilenceTarget( _Target ) : _Target.Volume = this._Volume;//disable anyother sounds except the one who's playing
			}
			this._isTransfering = false;
			//this._LastTarget = this._CurrentTarget;
			
		}
		
		private function SilenceTarget( _InputTarget:MusicTrack ):void {
			if ( _InputTarget != null && _InputTarget.isPlaying == true ) {
				TweenLite.to( _InputTarget , this._SlienceBufferTime , { Volume:0 , onComplete:this.SlientTarget , onCompleteParams:[ _InputTarget ] } );
			}
			
		}
		
		private function SlientTarget( _InputTarget:MusicTrack ):void {
				TweenLite.killTweensOf( _InputTarget ); 
				_InputTarget.Stop(); 
				//trace( _InputTarget.ID , _InputTarget.isPlaying );
		}
		
		
		
		private function SwitchTrack( _InputLastTrack:MusicTrack , _InputNextTrack:MusicTrack ):void {
			this._isTransfering = true;
			if ( _InputLastTrack != null ) {
				TweenLite.killTweensOf( _InputLastTrack );
				TweenLite.to( _InputLastTrack , this._TransferDuration , { Volume:0 , onComplete:this.MakeOnlyOneSurvived } );
			}
			
			if ( _InputNextTrack != null ) {
				TweenLite.killTweensOf( _InputNextTrack );
				TweenLite.to( _InputNextTrack , this._TransferDuration , { Volume:this._Volume } );
			}
		}
		
		
		//=========================================================音樂轉換
		public function SwitchTo( _InputKey:String , _InputRepeat:uint = 0 , _InputFromLastPlay:Boolean = false ):void {
			
			this._CurrentTarget = ( this._MusicTrackList[ _InputKey ] == null ) ? this.AddMusic( _InputKey ) : this._MusicTrackList[ _InputKey ];
			if ( this._CurrentTarget != this._LastTarget && this._CurrentTarget != null ) {
				
				( _InputFromLastPlay == true ) ? this._CurrentTarget.Play( this._CurrentTarget.LastPlayPosition , _InputRepeat ) : this._CurrentTarget.Play( 0 , _InputRepeat );//使音樂從上個位置開始播放
				
				this.SwitchTrack( this._LastTarget , this._CurrentTarget );
				this._LastTarget = this._CurrentTarget;
			}
			
		}
		
		public function ParallelSwitchTo( _InputKey:String , _InputRepeat:uint = 0 ):void {
			//音樂平行轉換
			this._CurrentTarget = ( this._MusicTrackList[ _InputKey ] == null ) ? this.AddMusic( _InputKey ) : this._MusicTrackList[ _InputKey ];
			if ( this._CurrentTarget != this._LastTarget && this._LastTarget != null && this._CurrentTarget != null ) {
				this._CurrentTarget.Play( this._LastTarget.Position , _InputRepeat );
				this.SwitchTrack( this._LastTarget , this._CurrentTarget );
				this._LastTarget = this._CurrentTarget;
			}
		}
		//================================================END======音樂轉換
		
		//----------------------------------------------------------------------------------------------Getter & setter
		public function Stop():void {
			this.SilenceTarget( this._CurrentTarget );
		}
		
		public function get Volume():Number {
			return this._Volume;
		}
		
		public function set Volume(value:Number):void {
			this._Volume = value;
			if ( this._CurrentTarget != null ) {
				TweenLite.killTweensOf( this._CurrentTarget );
				TweenLite.to( this._CurrentTarget , this._TransferDuration , { Volume:this._Volume } );
			}
		}
		
		public function get isTransfering():Boolean {
			return this._isTransfering;
		}
		//-----------------------------------------------------------------------------END--------------Getter & setter
		
		
	}//end class

}//end package


	
	
