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
	
	
	//import flash.utils.getDefinitionByName;
	//import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 * @version 13.01.04.11.06
	 */
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.CommandsStrLad;
	
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MotionKeyStr;
	
	import Spark.SoarVision.VisionCenter;
	import Spark.SoarVision.single.SpriteVision;
	import Spark.SoarVision.multiple.MultiSpriteVision;
	import MVCprojectOL.ModelOL.MotionSettings.MotionValue;
	
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	 
	public final class SkillAnimateController {
		private var _ID:String;//技能ID  
		private var _SkillComponentKey:String;
		private var _OriMovieClip:MovieClip;//原始影片
		private var _MotionClip:SpriteVision;//傳給外部的播放容器
		//private var _MotionConfig:Object;//動作圖列切割設定
		
		private var _Direction:Boolean = false;//預設圖向左  因此向左為false 向右為true
		
		private var _LeftSeries:Array;//向左的動畫圖列
		private var _RightSeries:Array;//向右的動畫圖列
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		private var _VisionCenter:VisionCenter = VisionCenter.GetInstance();
		private var _MotionValue:MotionValue = MotionValue.GetInstance();
		
		private var _onCompleteAddress:Function;
		
		private var _VisionID:String;//實際播放容器的ID
		//private var _CurrentMotionCommand:String = MotionKeyStr.Idle;//default as "Idle"
		
		public function SkillAnimateController( _InputSkillID:String , _InputSkillComponentKey:String , _InputSkillClip:MovieClip ) {
			this._ID = _InputSkillID;
			this._SkillComponentKey = _InputSkillComponentKey;
			this._OriMovieClip = _InputSkillClip;
			
			
			this._VisionID = this._ID;// this.IDChecker( this._ID );//this._ID + Math.random();
			//trace( this._VisionID , "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD" );
			this._MotionClip = new SpriteVision( this._VisionID );//新增動作控制容器
			
			/*this._MotionConfig = { 	(MotionKeyStr.Statue) : { op : 1 , ed : 1 } , 
										(MotionKeyStr.Idle) : { op : 1 , ed : 5 } , 
										(MotionKeyStr.Attack) : { op : 6 , ed : 10 } , 
										(MotionKeyStr.Hurt) : { op : 11 , ed : 15 } , 
										(MotionKeyStr.Dead) : { op : 16 , ed : 20 } 	}; */
									
			this.DeserializeMotion( this._OriMovieClip , this._Direction );
		}
		
		private function IDChecker( _InputID:String , _InputIndex:uint = 0 ):String {
			//to prevant registering the same ID of vision container in VisionCenter , that would cause an error
			_InputIndex++;
			return ( this._VisionCenter.CheckRegister( _InputID ) == false ) ? ( _InputID + _InputIndex ) : this.IDChecker( _InputID , _InputIndex ) ;
		}
		
		public function Clear():void {
			EventExpress.RevokeAddressRequest( this.onComplete );//QRC
			EventExpress.RevokeAddressRequest( this.UpdateFrameRate );
			//trace( this._MotionClip.parent.name );
			//trace( this._MotionClip.parent.parent );
			if ( this._MotionClip != null && this._MotionClip.parent != null ) {//自行清空所有快取層
				//this._MotionClip.parent 是外部快取容器(Sprite)
				if ( this._MotionClip.parent.parent != null ) {
					this._MotionClip.parent.parent.removeChild( this._MotionClip.parent );
				}
				this._MotionClip.parent.removeChild( this._MotionClip );
			}
			//trace( "Cleared--->" , this._VisionID );
			( this._VisionCenter.CheckRegister( this._VisionID ) == true ) ? this._VisionCenter.MovieRemove( this._VisionID , true ) : null;
			
		}
		
		public function Destroy():void {
			this.Clear();
			this._MotionClip = null;
			this._OriMovieClip = null;
			
			this._OriMovieClip = null;
			
			this._LeftSeries = null;
			this._RightSeries = null;
			
			this._SourceProxy = null;
			this._VisionCenter = null;
			this._MotionValue = null;
			
			this._onCompleteAddress = null;
		}
		
		private function DeserializeMotion( _InputMClip:MovieClip , _InputDirection:Boolean = false ):void {
			var _GraphicSeries:Array = this.GetGraphicSeries( _InputMClip , _InputDirection );//預設圖向左  因此向左為false 向右為true
					
			//this._VisionCenter.AddMultiPlay( this._MotionClip , _GraphicSeries , this._MotionConfig , this._CurrentMotionCommand , true , true , false , 166 );
			this._VisionCenter.AddSinglePlay( this._MotionClip , _GraphicSeries , false , true , false , this._MotionValue.SkillFrameRate );
			//this._VisionCenter.MoviePlay( this._ID , MotionKeyStr.Attack );
			EventExpress.AddEventRequest( ( VisionCenter.VISION_ENDONCE + this._VisionID ) , this.onComplete );//QRC 動作播放完畢後的偵測器
		}
		
		
		
		private function GetGraphicSeries( _InputMClip:MovieClip , _InputDirection:Boolean = false ):Array{ //預設圖向左  因此向左為false 向右為true{
			var _GraphicSeries:Array;
			if ( _InputDirection == false ) {//向左的動畫圖列
				_GraphicSeries = ( _LeftSeries == null ) ? this._SourceProxy.GetMovieClipHandler( _InputMClip , _InputDirection , this._SkillComponentKey ) : _LeftSeries;
			}else {//向右的動畫圖列
				_GraphicSeries = ( _RightSeries == null ) ? this._SourceProxy.GetMovieClipHandler( _InputMClip , _InputDirection , this._SkillComponentKey ) : _RightSeries;
			}
			
			return _GraphicSeries;
		}
		
		private function ChangeDirection( _InputDirection:Boolean ):void {//播放途中變換方向
			var _GraphicSeries:Array = this.GetGraphicSeries( this._OriMovieClip , _InputDirection );//更換動畫圖列
			
			/*if( this._CurrentMotionCommand != MotionKeyStr.Dead ){//死亡更換方向 不播放  且停在最後一張   因此要分開處理
				this._VisionCenter.MovieChangeSource( this._ID , _GraphicSeries , true , this._MotionConfig , this._CurrentMotionCommand , true );//刷新播放容器的圖列  並以當前的播放狀態播放(死亡狀態除外)
			}else {
				this._VisionCenter.MovieChangeSource( this._ID , _GraphicSeries , false , this._MotionConfig , this._CurrentMotionCommand , true );
				this._VisionCenter.MovieStopAt( this._ID , 20 );
			}*/
			( this._VisionCenter.CheckRegister( this._VisionID ) == true ) ? this._VisionCenter.MovieChangeSource( this._VisionID , _GraphicSeries , true , null , "" , true  ) : null;
		}
		
		public function Stop():void {
			( this._VisionCenter.CheckRegister( this._VisionID ) == true ) ? this._VisionCenter.MovieStop( this._VisionID ) : null;
		}
		
		
		private function onComplete( _EVT:EventExpressPackage ):void {
			//trace( _EVT.EventName , _EVT.Status , _EVT.Content , "<<========================================" );
			//if ( _EVT.Status != MotionKeyStr.Statue && _EVT.Status != MotionKeyStr.Dead ) this.Act( MotionKeyStr.Idle );//讓其他動作播放完畢後 回復IDLE狀態
			( this._onCompleteAddress != null ) ? this._onCompleteAddress( this._VisionID ) : null;//通知指定地址 該特效已播放完畢
			this.Clear();//自行移除顯示物件
			//trace( this._ID , "Completed <=========================" );
			//this.Act( this._onCompleteAddress );
			
		}
		
		
		public function Act( _InputCompleteAddress:Function = null ):void {
			this._onCompleteAddress = _InputCompleteAddress;
			this._VisionCenter.MoviePlay( this._VisionID );
		}
		
		
		private function MotionValueAttention():void {
			EventExpress.AddEventRequest( MotionValue.SkillMotionValueChanged , this.UpdateFrameRate , this );
		}
		
		private function UpdateFrameRate( _EVT:EventExpressPackage ):void {
			( this._VisionCenter.CheckRegister( this._VisionID ) ) ? this._VisionCenter.MovieChangeSpeed( this._VisionID , _EVT.Content as uint ) : null;
		}
		
		
		
		
		
		
		public function get MotionClip():SpriteVision {
			return this._MotionClip;
		}
		
		public function get Direction():Boolean {
			return this._Direction;
		}
		
		
		
		public function set Direction( value:Boolean ):void {
			if ( this._Direction != value ) {//方向不同時才作刷新動作
				this._Direction = value;
				this.ChangeDirection( this._Direction );
			}
			
		}
		
		
		
		
		
	}//end class
}//end package