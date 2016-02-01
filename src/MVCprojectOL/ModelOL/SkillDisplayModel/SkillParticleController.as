package MVCprojectOL.ModelOL.SkillDisplayModel {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	//import Spark.SoarVision.multiple.MultiSpriteVision;
	//import Spark.SoarVision.VisionCenter;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 * @version 12.12.17.10.35
	 */
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.CommandsStrLad;
	
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MotionKeyStr;
	
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import Spark.SoarParticle.ParticleCenter;
	import Spark.SoarParticle.basic.IEffect;
	 
	public final class SkillParticleController {
		private var _ID:String;//ID  同時也用來做播放容器的ID
		//private var _OriMovieClip:MovieClip;//原始影片
		private var _MotionClip:IEffect;//傳給外部的播放容器
		//private var _MotionConfig:Object;//動作圖列切割設定
		
		//private var _Direction:Boolean = false;//預設圖向左  因此向左為false 向右為true
		
		//private var _LeftSeries:Array;//向左的動畫圖列
		//private var _RightSeries:Array;//向右的動畫圖列
		
		//private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		//private var _VisionCenter:VisionCenter = VisionCenter.GetInstance();
		private var _ParticleCenter:ParticleCenter = ParticleCenter.GetInstance();
		private var _LastTime:Number = 0; //粒子持續時間
		//private var _onCompleteAddress:Function;
		
		//private var _CurrentMotionCommand:String = MotionKeyStr.Idle;//default as "Idle"
		
		public function SkillParticleController( _InputSkillID:String , _InputParticleID:String , _InputLastSec:Number = 0 ) {
			this._ID = _InputSkillID;
			//this._OriMovieClip = _InputSkillClip;
			//this._MotionClip = new MultiSpriteVision( this._ID );//新增動作控制容器
			/*this._MotionConfig = { 	(MotionKeyStr.Statue) : { op : 1 , ed : 1 } , 
									(MotionKeyStr.Idle) : { op : 1 , ed : 5 } , 
									(MotionKeyStr.Attack) : { op : 6 , ed : 10 } , 
									(MotionKeyStr.Hurt) : { op : 11 , ed : 15 } , 
									(MotionKeyStr.Dead) : { op : 16 , ed : 20 } 	}; */
									
			//this.DeserializeMotion( this._OriMovieClip , this._Direction );
			this._MotionClip = this._ParticleCenter.GetParticleByKey( _InputParticleID );
			
			this._LastTime = _InputLastSec;
		}
		
		public function Clear():void {
			//EventExpress.RevokeAddressRequest( this.onComplete );//QRC
			
			/*trace( this._MotionClip.parent.name );
			trace( this._MotionClip.parent.parent );*/
			/*if ( this._MotionClip != null && this._MotionClip.parent != null ) {//自行清空所有快取層
				//this._MotionClip.parent 是外部快取容器(Sprite)
				if ( this._MotionClip.parent.parent != null ) {
					this._MotionClip.parent.parent.removeChild( this._MotionClip.parent );
				}
				this._MotionClip.parent.removeChild( this._MotionClip );
			}*/
			if ( this._MotionClip != null ) {
				this._MotionClip.Destroy();
				this._MotionClip = null;
			}
			//trace( "Cleared" );
		}
		
		/*private function DeserializeMotion( _InputParticleID:String ):void {
			var _GraphicSeries:Array = this.GetGraphicSeries( _InputMClip , _InputDirection );//預設圖向左  因此向左為false 向右為true
										
			//this._VisionCenter.AddMultiPlay( this._MotionClip , _GraphicSeries , this._MotionConfig , this._CurrentMotionCommand , true , true , false , 166 );
			this._VisionCenter.AddSinglePlay( this._MotionClip , _GraphicSeries , false , true , false , 166 );
			//this._VisionCenter.MoviePlay( this._ID , MotionKeyStr.Attack );
			EventExpress.AddEventRequest( ( VisionCenter.VISION_ENDONCE + this._ID ) , this.onComplete );//QRC 動作播放完畢後的偵測器
		}*/
		
		/*private function GetGraphicSeries( _InputMClip:MovieClip , _InputDirection:Boolean = false ):Array{ //預設圖向左  因此向左為false 向右為true{
			var _GraphicSeries:Array;
			if ( _InputDirection == false ) {//向左的動畫圖列
				_GraphicSeries = ( _LeftSeries == null ) ? this._SourceProxy.GetMovieClipHandler( _InputMClip , _InputDirection ) : _LeftSeries;
			}else {//向右的動畫圖列
				_GraphicSeries = ( _RightSeries == null ) ? this._SourceProxy.GetMovieClipHandler( _InputMClip , _InputDirection ) : _RightSeries;
			}
			
			return _GraphicSeries;
		}*/
		
		//private function ChangeDirection( _InputDirection:Boolean ):void {//播放途中變換方向
			//var _GraphicSeries:Array = this.GetGraphicSeries( this._OriMovieClip , _InputDirection );//更換動畫圖列
			
			/*if( this._CurrentMotionCommand != MotionKeyStr.Dead ){//死亡更換方向 不播放  且停在最後一張   因此要分開處理
				this._VisionCenter.MovieChangeSource( this._ID , _GraphicSeries , true , this._MotionConfig , this._CurrentMotionCommand , true );//刷新播放容器的圖列  並以當前的播放狀態播放(死亡狀態除外)
			}else {
				this._VisionCenter.MovieChangeSource( this._ID , _GraphicSeries , false , this._MotionConfig , this._CurrentMotionCommand , true );
				this._VisionCenter.MovieStopAt( this._ID , 20 );
			}*/
			//this._VisionCenter.MovieChangeSource( this._ID , _GraphicSeries , false , null , "" , true );
		//}
		
		public function Stop():void {
			//this._VisionCenter.MovieStop( this._ID );
			this.Clear();
		}
		
		/*private function onComplete( _EVT:EventExpressPackage ):void {
			//trace( _EVT.EventName , _EVT.Status , _EVT.Content , "<<========================================" );
			//if ( _EVT.Status != MotionKeyStr.Statue && _EVT.Status != MotionKeyStr.Dead ) this.Act( MotionKeyStr.Idle );//讓其他動作播放完畢後 回復IDLE狀態
			( this._onCompleteAddress != null ) ? this._onCompleteAddress( this._ID ) : null;//通知指定地址 該特效已播放完畢
			//this.Clear();//自行移除顯示物件
			//trace( this._ID , "Completed <=========================" );
			//this.Act( this._onCompleteAddress );
			
		}*/
		
		
		public function Act( _InputCompleteAddress:Function = null ):void {
			//this._onCompleteAddress = _InputCompleteAddress;
			if ( _InputCompleteAddress != null ) {
				this._ParticleCenter.RegisterParticle( this._MotionClip , _InputCompleteAddress );
			}
			this._MotionClip.Start( this._LastTime );
			//this._VisionCenter.MoviePlay( this._ID );
		}
		
		
		
		
		
		public function get MotionClip():DisplayObject {
			return DisplayObject( this._MotionClip );
		}
		
		/*public function get Direction():Boolean {
			return this._Direction;
		}*/
		
		
		
		/*public function set Direction( value:Boolean ):void {
			if ( this._Direction != value ) {//方向不同時才作刷新動作
				this._Direction = value;
				this.ChangeDirection( this._Direction );
			}
			
		}*/
		
		
		
		
		
	}//end class
}//end package