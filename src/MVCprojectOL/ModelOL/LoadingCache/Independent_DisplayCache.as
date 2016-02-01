package MVCprojectOL.ModelOL.LoadingCache {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import Spark.CommandsStrLad;
	//import flash.display.DisplayObject;
	//import flash.display.DisplayObjectContainer;
	//import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	
	
	/*import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;*/
	
	/**
	 * ...
	 * @author K.J. Aris
	 * @note This class is a single Display Cache thread , open a loading cache thread by newing this class.
	 * @version 12.12.12.12.12
	 */
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	 
	 
	public final class DisplayCache {
		//vitals
		private var _ComponentKey:String = "";
		private var _CacheContainer:Sprite;
		private var _CompleteAddress:Function;
		
		private var _DisplaySize:uint = 64;//64 X 64
		private var _LoadingTweakX:Number = 0;
		private var _LoadingTweakY:Number = 0;
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		
		private const _LoadingMarkName:String = "LoadingMark";
		
		private var _isWaiting:Boolean = false;
		
		private const _RecheckPeriodlyValue:uint = 500;//每0.5秒重複檢查素材狀態
		private var _MaxCheckTime:uint = 60;//若檢查超過60次  便逾期處理
		private var _TimeoutID:uint = 0;
		
		
		public function DisplayCache( _InputComponentKey:String , _InputCacheContainer:Sprite , _InputCompleteAddress:Function , _InputLoadingDisplaySize:uint = 64 , _InputLoadingTweakX:Number = 0 , _InputLoadingTweakY:Number = 0  ) {
			this._ComponentKey = _InputComponentKey;
			this._CacheContainer = _InputCacheContainer;
			this._CompleteAddress = _InputCompleteAddress;
			
			this._DisplaySize = _InputLoadingDisplaySize;
			this._LoadingTweakX = _InputLoadingTweakX;
			this._LoadingTweakY = _InputLoadingTweakY;
			
			trace( "Starting" , this._ComponentKey , "Display Cache" );
		}
		
		public function Clear():void {
			this.ClearContent( this._CacheContainer );
			this.RevockCheckAndWait();
		}
		
		public function StartLoad():Boolean {
			var _ComponentExist:Boolean = this._SourceProxy.PreloadMaterial( this._ComponentKey );
			//var _ComponentExist:Boolean = false;
			//trace( _ComponentExist , "有無載過" );
			( _ComponentExist == true ) ? 
				this.onComplete() //當有素材時，直接將內容物SHOW出
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
				this._TimeoutID = setTimeout( this.CheckPeriodly , this._RecheckPeriodlyValue , this._ComponentKey );
			}
			
		}//end WaitForComponentReturn
		
		private function CheckPeriodly( _InputCheckTargetKey:String , _InputCheckTime:uint = 0 ):void {
			clearTimeout( this._TimeoutID );
			_InputCheckTime++;
			//trace( _InputCheckTargetKey , "檢察第" , _InputCheckTime , "次" );
			
			if ( _InputCheckTime >= this._MaxCheckTime ) {
				this.OverTimeError( _InputCheckTargetKey );
			}else {
				( this.StartLoad() == false ) ? //重複檢查素材狀態
					this._TimeoutID = setTimeout( this.CheckPeriodly , this._RecheckPeriodlyValue , _InputCheckTargetKey , _InputCheckTime ) : null ;//若仍然沒有則持續定期檢查素材狀態
			}
			
		}
		
		private function OverTimeError( _InputInvalidKey:String ):void {
			this.RevockCheckAndWait();
			trace( "'" , _InputInvalidKey , "' respond Timeout !! From DisplayCache" );
		}
		
		private function RevockCheckAndWait():void {
			clearTimeout( this._TimeoutID );//Check
			EventExpress.RevokeAddressRequest( this.ComponentReturned );//Wait
			this._isWaiting = false;
		}
		
		private function ComponentReturned( _Result:EventExpressPackage ):void {
			switch( _Result.Status ) {
				case String( this._ComponentKey ) ://如果是這個素材的檔案回來了
						//trace( this._ComponentKey , "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<回來了" );
						//this.RevockCheckAndWait();
						//this.GetContentShown();
						this.onComplete();
					break;
			}
		}//end ComponentReturned
		
		private function onComplete():void {
			this.Clear();
			this._CompleteAddress( this._ComponentKey );
		}//end GetContentShown
		
		
		
		
		//--------------------------------------------------------getters
		public function get isWaiting():Boolean {
			return this._isWaiting;
		}
		
		//--------------------------------------------END---------getters
		
		
		//--------------------------------------------------------setters
		
		//--------------------------------------------END---------setters
		
		
		
		//-------------------------------------------------Cache Status
		private function AddLoadingStatus():void {//產生LoadingMark在怪物顯示內容上
			this.AddLoadingBar( this._CacheContainer , this._DisplaySize , this._LoadingTweakX , this._LoadingTweakY );
		}
		
		private function RemoveLoadingStatus():void {
			this.ClearContent( this._CacheContainer );
		}
		
		private function AddLoadingBar( _InputCacheTarget:Sprite , _InputPreloadSize:uint , _InputLoadingTweakX:Number = 0 , _InputLoadingTweakY:Number = 0 ):void {
			
			var _LoadingMarkClass:Class = this._SourceProxy.GetLoadingMark();
			var _CurrentLoadingMark:LoadingBar = new _LoadingMarkClass();
			
				with ( _CurrentLoadingMark ) {
					name = this._LoadingMarkName;
					width = _InputPreloadSize;
					height = _InputPreloadSize;
					x = _InputLoadingTweakX;
					y = _InputLoadingTweakY;
				}
				
			_InputCacheTarget.addChild( _CurrentLoadingMark );
		}
		
		
		private function ClearContent( _InputTarget:Sprite ):void {
			while ( _InputTarget.numChildren > 0 ) {
				_InputTarget.removeChildAt( 0 );
			}
		}
		
		//--------------------------------------END--------Cache Status
		
	}//end class
}//end package