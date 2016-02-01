package MVCprojectOL.ModelOL.LoadingCache {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	//import com.greensock.easing.Quad;
	//import com.greensock.TweenLite;
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
	 * @note This class is a single Remote Cache thread , open a loading cache thread by newing this class.
	 * @version 12.12.12.12.12
	 * @lastversion 13.02.19.16.32
	 */
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	 
	 
	public class RemoteCache {
		//vitals
		protected var _ComponentKey:String = "";
		protected var _CompleteAddress:Function;
		protected var _FailAddress:Function;
		
		protected var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		protected var _isWaiting:Boolean = false;
		
		protected const _RecheckPeriodlyValue:uint = 500;//每0.5秒重複檢查素材狀態
		protected var _MaxCheckTime:uint = 60;//若檢查超過60次  便逾期處理
		protected var _TimeoutID:uint = 0;
		
		protected var _SelfDestruction:Boolean;
		
		public function RemoteCache( _InputComponentKey:String , _InputCompleteAddress:Function , _InputFailAddress:Function = null , _InputSelfDestruction:Boolean = false ) {
			this._ComponentKey = _InputComponentKey;
			this._CompleteAddress = _InputCompleteAddress;
			this._FailAddress = _InputFailAddress;
			this._SelfDestruction = _InputSelfDestruction;
		}
		
		public function Clear():void {
			this.RevockCheckAndWait();
		}
		
		public function Destroy():void {
			this.Clear();
			this._CompleteAddress = null;
			this._FailAddress = null;
			this._SourceProxy = null;
		}
		
		public function UpdateComponentKey( _InputComponentKey:String ):void {
			this._ComponentKey = _InputComponentKey;
		}
		
		public function UpdateCompleteAddress( _InputAddress:Function ):void {
			this._CompleteAddress = _InputAddress;
		}
		
		public function UpdateFailListening( _InputAddress:Function ):void {
			this._FailAddress = _InputAddress;
		}
		
		public function StartLoad():Boolean {
			var _ComponentExist:Boolean = this._SourceProxy.PreloadMaterial( this._ComponentKey );
			//var _ComponentExist:Boolean = false;
			//trace( _ComponentExist , "有無載過" );
			( _ComponentExist == true ) ? 
				this.onComplete() //當有素材時，直接回傳
				:
				this.WaitForComponentReturn();//當沒有素材時，等待素材回來後，再回傳
			return _ComponentExist;
		}
		
		protected function WaitForComponentReturn():void {
			
			//if ( EventExpress.CheckEventRequestStatus( CommandsStrLad.Source_Complete , this.ComponentReturned ) == false ) {
			if ( this._isWaiting == false ) {
				this._isWaiting = true;
				EventExpress.AddEventRequest( CommandsStrLad.Source_Complete , this.ComponentReturned , this );
				this._TimeoutID = setTimeout( this.CheckPeriodly , this._RecheckPeriodlyValue , this._ComponentKey );
			}
			
		}//end WaitForComponentReturn
		
		protected function CheckPeriodly( _InputCheckTargetKey:String , _InputCheckTime:uint = 0 ):void {
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
		
		protected function OverTimeError( _InputInvalidKey:String ):void {
			this.RevockCheckAndWait();
			trace( "'" , _InputInvalidKey , "' respond Timeout !! From RemoteCache" );
			( this._FailAddress != null ) ? this._FailAddress( _InputInvalidKey ) : null;
		}
		
		protected function RevockCheckAndWait():void {
			clearTimeout( this._TimeoutID );//Check
			EventExpress.RevokeAddressRequest( this.ComponentReturned );//Wait
			this._isWaiting = false;
		}
		
		protected function ComponentReturned( _Result:EventExpressPackage ):void {
			switch( _Result.Status ) {
				case String( this._ComponentKey ) ://如果是這個素材的檔案回來了
						//trace( this._ComponentKey , "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<回來了" );
						this.onComplete();
					break;
			}
		}//end ComponentReturned
		
		
		protected function onComplete():void {
			this.Clear();
			this._CompleteAddress( this._ComponentKey );
			//this._SelfDestruction == true ? this.Destroy() : null;
		}//end GetContentShown
		
		
		
		
		
		//--------------------------------------------------------getters
		public function get isWaiting():Boolean {
			return this._isWaiting;
		}
		//--------------------------------------------END---------getters
		
		
		//--------------------------------------------------------setters
		//--------------------------------------------END---------setters
		
		
		
		//-------------------------------------------------Cache Status
		
		//--------------------------------------END--------Cache Status
		
	}//end class
}//end package