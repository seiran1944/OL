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
	
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 * @version 121210
	 */
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.CommandsStrLad;
	
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	 
	
	import Spark.SoarVision.multiple.MultiSpriteVision;//動畫處理器
	import Spark.SoarVision.VisionCenter;
	 
	public final class MonsterDisplay {
		private var _MonsterData:Object;
		private var _MonsterHead:Sprite = new Sprite();//this is a Cache Container
		private var _MonsterBody:Sprite = new Sprite();//this is a Cache Container
		
		private var _MonsterID:String = "";
		private var _MonsterComponentKey:String = "";
		
		private const _HeadSize:uint = 64;//64 X 64
		private const _BodySize:uint = 150;//150 X 150
		
		//private const _HalfHeadSize:uint = _HeadSize * 0.5;
		//private const _HalfBodySize:uint = _BodySize * 0.5;
		
		private const _LoadingMarkName:String = "LoadingMark";
		
		private const _HeadClassName:String = "head";
		private const _BodyClassName:String = "body";
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		private var _isWaiting:Boolean = false;
		private var _ComponentAdded:Boolean = false;
		
		private const _RecheckPeriodlyValue:uint = 500;//每0.5秒重複檢查素材狀態
		private var _MaxCheckTime:uint = 60;//若檢查超過60次  便逾期處理
		private var _TimeoutID:uint = 0;
		
		public var _status:uint = 0;
		
		
		private var _Alive:Boolean = false;//為true 時才給動態控制器
		private var _MotionController:MonsterMotionController;//怪物動作控制器 Note : Alive模式才有用
		
		//private var _Direction:Boolean = false;//預設圖向左  因此向左為false 向右為true  Note : Alive模式才有用
		
		public final function MonsterDisplay( _InputMonsterData:Object , _InputAlive:Boolean = false ) {
			this.UpdateMonsterValue( _InputMonsterData );
			this._Alive = _InputAlive;
		}
		
		public function UpdateMonsterValue( _InputMonsterData:Object ):void {
			/*
			 * _picItem//頭像素材KEY
			 * _motionItem//動態素材KEY
			*/
			this._MonsterData = _InputMonsterData;
			this._MonsterComponentKey = this._MonsterData._motionItem;
			this._MonsterID = this.MonsterData._guid;
			
			this._MonsterHead.name = this._MonsterData._guid;
			this._MonsterBody.name = this._MonsterData._guid;
		}
		
		
		public function Clear():void {
			/*if ( this._MonsterHead != null && this._MonsterHead.parent != null ) {
				this._MonsterHead.parent.removeChild( this._MonsterHead );
				this._MonsterHead = null;
			}*/
			
			/*if ( this._MonsterBody != null && this._MonsterBody.parent != null ) {
				this._MonsterBody.parent.removeChild( this._MonsterBody );
				this._MonsterBody = null;
			}*/
			this.ClearContent( this._MonsterBody );
			this.ClearContent( this._MonsterHead );
			
			if ( this._MotionController != null ) {//確保控制類被清乾淨
				this._MotionController.Clear();
				this._MotionController = null;
			}
			
			this.RevockCheckAndWait();
			
			this._ComponentAdded = false;
		}
		
		public function ShowContent():Boolean {
			var _ComponentExist:Boolean = this._SourceProxy.PreloadMaterial( this._MonsterComponentKey );
			//var _ComponentExist:Boolean = false;
			//trace( _ComponentExist , "有無載過" );
			( _ComponentExist == true ) ? 
				this.GetContentShown() //當有素材時，直接將內容物SHOW出
				:
				this.WaitForComponentReturn();////當沒有素材時，加入LOADING MARK   並且等待素材回來後，再SHOW出
			return _ComponentExist;
		}
		
		private function WaitForComponentReturn():void {
			
			//if ( EventExpress.CheckEventRequestStatus( CommandsStrLad.Source_Complete , this.ComponentReturned ) == false ) {
			if ( this._isWaiting == false ) {
				this._isWaiting = true;
				this.AddLoadingStatus();
				EventExpress.AddEventRequest( CommandsStrLad.Source_Complete , this.ComponentReturned , this );
				this._TimeoutID = setTimeout( this.CheckPeriodly , this._RecheckPeriodlyValue , this._MonsterComponentKey );
			}
			
		}//end WaitForComponentReturn
		
		private function CheckPeriodly( _InputCheckTargetKey:String , _InputCheckTime:uint = 0 ):void {
			clearTimeout( this._TimeoutID );
			_InputCheckTime++;
			//trace( _InputCheckTargetKey , "檢察第" , _InputCheckTime , "次" );
			
			if ( _InputCheckTime >= this._MaxCheckTime ) {
				this.OverTimeError( _InputCheckTargetKey );
			}else {
				( this.ShowContent() == false ) ? //重複檢查素材狀態
					this._TimeoutID = setTimeout( this.CheckPeriodly , this._RecheckPeriodlyValue , _InputCheckTargetKey , _InputCheckTime ) : null ;//若仍然沒有則持續定期檢查素材狀態
			}
			
		}
		
		private function OverTimeError( _InputInvalidKey:String ):void {
			this.RevockCheckAndWait();
			trace( "'" , _InputInvalidKey , "' respond Timeout !! From MonsterDisplay" );
		}
		
		private function RevockCheckAndWait():void {
			clearTimeout( this._TimeoutID );//Check
			EventExpress.RevokeAddressRequest( this.ComponentReturned );//Wait
			this._isWaiting = false;
		}
		
		private function ComponentReturned( _Result:EventExpressPackage ):void {
			switch( _Result.Status ) {
				case String( this._MonsterComponentKey ) ://如果是這個怪物的檔案回來了
						//trace( this._MonsterComponentKey , "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<回來了" );
						/*clearTimeout( this._TimeoutID );//移除連線逾時服務
						EventExpress.RevokeAddressRequest( this.ComponentReturned );//移除素材回應服務*/
						this.RevockCheckAndWait();
						this.GetContentShown();
					break;
				
				default :
					break;
				
			}
		}//end ComponentReturned
		
		private function GetContentShown():void {
			
			if ( this._ComponentAdded == false ) {//當素材已加過便不能再加
				//clearTimeout( this._TimeoutID );//移除檢察等待
				this.RevockCheckAndWait();
				this.RemoveLoadingStatus();
				
				var _Head:Sprite = new ( this._SourceProxy.GetMaterialSWP( this._MonsterComponentKey , this._HeadClassName ) as Class );
				var _Body:DisplayObjectContainer;
				
				if ( this._Alive == false ) {//當為非動態狀態時  
					//只給靜態圖
					var _BodySprite:Sprite = new ( this._SourceProxy.GetMaterialSWP( this._MonsterComponentKey , this._BodyClassName ) as Class );
					_Body = _BodySprite;
				}else {
					var _SourceClip:MovieClip = new ( this._SourceProxy.GetMaterialSWP( this._MonsterComponentKey , this._BodyClassName ) as Class );
					this._MotionController = new MonsterMotionController( this._MonsterID , _SourceClip );//加入動態控制
					var _BodyClip:MultiSpriteVision = this._MotionController.MotionClip;//動態容器
					_Body = _BodyClip;
				}
				
				
				
				
					_Head.alpha = 0;
					_Body.alpha = 0;
				
				//this._MonsterHead == null ? this._MonsterHead = new Sprite() : null;
				//this._MonsterBody == null ? this._MonsterBody = new Sprite() : null;
					
					
				this._MonsterHead.addChild( _Head );
				this._MonsterBody.addChild( _Body );
					
					TweenLite.to( _Head , 1 , { alpha:1 , ease:Quad.easeOut } );
					TweenLite.to( _Body , 1 , { alpha:1 , ease:Quad.easeOut } );
				
				this._ComponentAdded = true;
			}
			
		}//end GetContentShown
		
		
		
		
		//--------------------------------------------------------getters
		public function get MonsterID():String {
			return _MonsterID;
		}
		
		public function get MonsterData():Object {
			return this._MonsterData;
		}
		
		public function get MonsterHead():Sprite {
				//this.ShowContent();
			return this._MonsterHead;
		}
		
		public function get MonsterBody():Sprite {
				//this.ShowContent();
			return this._MonsterBody;
		}
		
		public function get HeadSize():uint {
			return this._HeadSize;
		}
		
		public function get BodySize():uint {
			return this._BodySize;
		}
		
		public function get Motion():MonsterMotionController {
			//要檢查怪物素材回來了沒
			//要檢查_MotionController 有沒有New過
			return _MotionController;
		}
		
		public function get Alive():Boolean {
			return _Alive;
		}
		
		
		
		
		//--------------------------------------------END---------getters
		
		//--------------------------------------------------------setters
		public function set Alive( value:Boolean ):void {
			if ( this._Alive != value ) {//當狀態不同時才做改變
				this._Alive = value;
				this.Clear();//刷掉既有的內容物
				this.ShowContent();//重新啟始容器
			}
		}
		
		//--------------------------------------------END---------setters
		
		
		
		//-------------------------------------------------Cache Status
		private function AddLoadingStatus():void {//產生LoadingMark在怪物顯示內容上
				//this._MonsterHead == null ? this._MonsterHead = new Sprite() : null;
				//this._MonsterBody == null ? this._MonsterBody = new Sprite() : null;
				
				this.AddLoadingBar( this._MonsterBody , this._BodySize );
				this.AddLoadingBar( this._MonsterHead , this._HeadSize );
		}
		
		private function RemoveLoadingStatus():void {
			//this.RemoveLoadingBar( this._MonsterBody );
			//this.RemoveLoadingBar( this._MonsterHead );
			
			this.ClearContent( this._MonsterBody );
			this.ClearContent( this._MonsterHead );
		}
		
		private function AddLoadingBar( _InputTarget:Sprite , _InputPreloadSize:uint ):void {
			
			var _LoadingMarkClass:Class = this._SourceProxy.GetLoadingMark();
			var _CurrentLoadingMark:LoadingBar = new _LoadingMarkClass();
			
				with ( _CurrentLoadingMark ) {
					name = this._LoadingMarkName;
					width = _InputPreloadSize;
					height = _InputPreloadSize;
					x = 10;
				}
				
			_InputTarget.addChild( _CurrentLoadingMark );
		}
		
		/*private function RemoveLoadingBar( _InputTarget:Sprite ):void {
			var _CurrentChild:*;
			var _NumChildren:uint = _InputTarget.numChildren;
			//if ( _NumChildren > 0 ) {
				
				for (var i:int = 0; i < _NumChildren; i++) {
					_CurrentChild = _InputTarget.getChildAt( i );
					_CurrentChild.name == this._LoadingMarkName ? _InputTarget.removeChild( _CurrentChild ) : null ;
				}
			//}
		}*/
		
		private function ClearContent( _InputTarget:Sprite ):void {
			while ( _InputTarget.numChildren > 0 ) {
				_InputTarget.removeChildAt( 0 );
			}
		}
		//--------------------------------------END--------Cache Status
		
	}//end class
}//end package