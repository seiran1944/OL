package MVCprojectOL.ModelOL.MonsterDisplayModel {
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
	 * @version 13.03.11.13.40
	 */
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.CommandsStrLad;
	
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MotionKeyStr;
	
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	 
	import MVCprojectOL.ViewOL.Effects.ShakeEffect;
	import MVCprojectOL.ViewOL.Effects.BlingEffect;
	
	import MVCprojectOL.ModelOL.MotionSettings.MotionValue;
	import Spark.SoarVision.multiple.MultiSpriteVision;
	import Spark.SoarVision.VisionCenter;
	
	public final class MonsterMotionController {
		private var _MonsterID:String;//怪物ID  同時也用來做播放容器的ID
		private var _MonsterMaterialKey:String;
		private var _OriMovieClip:MovieClip;//原始影片
		private var _MotionClip:MultiSpriteVision;//傳給外部的播放容器
		private var _MotionConfig:Object;//動作圖列切割設定
		
		private var _Direction:Boolean = false;//預設圖向左  因此向左為false 向右為true
		
		private var _LeftSeries:Array;//向左的動畫圖列
		private var _RightSeries:Array;//向右的動畫圖列
		
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		private var _VisionCenter:VisionCenter = VisionCenter.GetInstance();
		private var _MotionValue:MotionValue = MotionValue.GetInstance();
		
		private var _CurrentMotionCommand:String = MotionKeyStr.Idle;//default as "Idle"
		
		private var _MonsterVisionKey:String;
		
		public function MonsterMotionController( _InputMonsterID:String , _InputMonsterMaterialKey:String , _InputMonsterClip:MovieClip , _InputIDSplit:String = "" ) {
			this._MonsterID = _InputMonsterID;
			this._MonsterMaterialKey = _InputMonsterMaterialKey;
			this._OriMovieClip = _InputMonsterClip;
			this._MonsterVisionKey = this._MonsterID + _InputIDSplit;
			this._MotionClip = new MultiSpriteVision( this._MonsterVisionKey );//新增動作控制容器
			this._MotionConfig = { 	( MotionKeyStr.Statue ) : { op : 1 , ed : 1 } , 
									( MotionKeyStr.Idle ) : { op : 1 , ed : 4 } , 
									( MotionKeyStr.Attack ) : { op : 11 , ed : 15 } ,
									( MotionKeyStr.MAttack ) : { op : 6 , ed : 10 } ,
									( MotionKeyStr.Hurt ) : { op : 16 , ed : 16 } , 
									( MotionKeyStr.Dead ) : { op : 16 , ed : 16 } 	}; 
									
			this.DeserializeMotion( this._OriMovieClip , this._Direction );
			this.MotionValueAttention();
		}
		
		internal function Clear():void {
			EventExpress.RevokeAddressRequest( this.JudgeAndPlay );//QRC
			EventExpress.RevokeAddressRequest( this.UpdateFrameRate );
			( this._VisionCenter.CheckRegister( this._MonsterVisionKey ) ) ? this._VisionCenter.MovieRemove( this._MonsterVisionKey , true ) : null;
		}
		
		internal function Destroy():void {
			this.Clear();
			this._MotionClip = null;
			this._MotionConfig = null;
			
			this._OriMovieClip = null;
			
			this._LeftSeries = null;
			this._RightSeries = null;
			
			this._SourceProxy = null;
			this._VisionCenter = null;
			this._MotionValue = null;
			
		}
		
		private function DeserializeMotion( _InputMClip:MovieClip , _InputDirection:Boolean = false ):void {
			var _GraphicSeries:Array = this.GetGraphicSeries( _InputMClip , _InputDirection );//預設圖向左  因此向左為false 向右為true
										
			this._VisionCenter.AddMultiPlay( this._MotionClip , _GraphicSeries , this._MotionConfig , this._CurrentMotionCommand , true , true , false , this._MotionValue.MonsterFrameRate );
			//this._VisionCenter.MoviePlay( this._MonsterVisionKey , MotionKeyStr.Attack );
			EventExpress.AddEventRequest( ( VisionCenter.VISION_ENDONCE + this._MonsterVisionKey ) , this.JudgeAndPlay );//QRC 動作播放完畢後的偵測器
		}
		
		private function GetGraphicSeries( _InputMClip:MovieClip , _InputDirection:Boolean = false ):Array{ //預設圖向左  因此向左為false 向右為true{
			var _GraphicSeries:Array;
			( _InputDirection == false ) ?
				_GraphicSeries = ( _LeftSeries == null ) ? this._SourceProxy.GetMovieClipHandler( _InputMClip , _InputDirection , this._MonsterMaterialKey ) : _LeftSeries//向左的動畫圖列
				:
				_GraphicSeries = ( _RightSeries == null ) ? this._SourceProxy.GetMovieClipHandler( _InputMClip , _InputDirection , this._MonsterMaterialKey ) : _RightSeries;//向右的動畫圖列
			
			
			return _GraphicSeries;
		}
		
		private function ChangeDirection( _InputDirection:Boolean ):void {//播放途中變換方向
			var _GraphicSeries:Array = this.GetGraphicSeries( this._OriMovieClip , _InputDirection );//更換動畫圖列
			
			if( this._CurrentMotionCommand != MotionKeyStr.Dead ){//死亡更換方向 不播放  且停在最後一張   因此要分開處理
				this._VisionCenter.MovieChangeSource( this._MonsterVisionKey , _GraphicSeries , true , this._MotionConfig , this._CurrentMotionCommand , true );//刷新播放容器的圖列  並以當前的播放狀態播放(死亡狀態除外)
			}else {
				this._VisionCenter.MovieChangeSource( this._MonsterVisionKey , _GraphicSeries , false , this._MotionConfig , this._CurrentMotionCommand , true );
				this._VisionCenter.MovieStopAt( this._MonsterVisionKey , 16 );
			}
		}
		
		public function Stop():void {
			this._VisionCenter.MovieStop( this._MonsterVisionKey );
		}
		
		private function JudgeAndPlay( _EVT:EventExpressPackage ):void {
			//trace( _EVT.EventName , _EVT.Status , _EVT.Content , "<<========================================" );
			switch( true ) {
				case ( _EVT.Status == MotionKeyStr.Hurt ) :
						setTimeout( this.Act , this._MotionValue.MonsterStunnedDuration , MotionKeyStr.Idle );
					break;
					
				case ( _EVT.Status != MotionKeyStr.Statue && _EVT.Status != MotionKeyStr.Dead ) :
						this.Act( MotionKeyStr.Idle );//讓其他動作播放完畢後 回復IDLE狀態
					break;
				
			}
			
		}
		
		
		public function Act( _InputMotionKey:String ):void {
			
			switch ( _InputMotionKey ) {
				case MotionKeyStr.Statue :	//播放靜態動作
				case MotionKeyStr.Idle :	//播放閒置動作
				case MotionKeyStr.Attack :	//播放攻擊動作
				case MotionKeyStr.MAttack :	//播放魔法攻擊動作
				case MotionKeyStr.Dead :	//播放死亡動作
						this._CurrentMotionCommand = _InputMotionKey;
					break;
					
				case MotionKeyStr.Hurt :	//播放受創動作
						this._CurrentMotionCommand = _InputMotionKey;
						ShakeEffect.ShakeMe( this._MotionClip , 6 , this._MotionValue.MonsterStunnedDuration );
						//BlingEffect.BlingMe( this._MotionClip , this._MotionValue.MonsterStunnedBlingTimes , this._MotionValue.MonsterStunnedBlingInterv );
					break;
					
				default:
						//預設靜態動作 防止無效字串
						this._CurrentMotionCommand = MotionKeyStr.Statue;
					break;
			}
			this._VisionCenter.MoviePlay( this._MonsterVisionKey , this._CurrentMotionCommand );
		}
		
		
		private function MotionValueAttention():void {
			EventExpress.AddEventRequest( MotionValue.MonsterMotionValueChanged , this.UpdateFrameRate , this );
		}
		
		private function UpdateFrameRate( _EVT:EventExpressPackage ):void {
			( this._VisionCenter.CheckRegister( this._MonsterVisionKey) ) ? this._VisionCenter.MovieChangeSpeed( this._MonsterVisionKey , _EVT.Content as uint ) : null;
		}
		
		
		
		
		
		internal function get MotionClip():MultiSpriteVision {
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