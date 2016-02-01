package Spark.MVCs.Models.NetWork.ConnectionControl {
	/**
	 * @Engine Ignitor
	 * @Author K.J. Aris
	 * @version 12.12.05.10.20 
	 * @FlashPlayerVersion 11.2
	 * @Note 
	 */
	/*import GlobalEvent.EventExpress;
	import GlobalEvent.EventExpressPackage;*/
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	
	//import Spark.MVCs.Models.NetWork.AmfConnection.ConnectionControl.ConnectionRequest;
	
	import flash.net.NetConnection;
	
	import Spark.MVCs.Models.NetWork.GroupCall.Get_ResultGroup;
	import Spark.MVCs.Models.NetWork.ConnectionControl.ConnectionRequest;
	
	public final class ConnectionManager {
		/*public static const _PackageInf:String = " * From Package ConnectionManager.as ";
		public static const _ActionMessage:String = "#ver 12.11.19.17.24 : ";*/
		private var _ServerConnection:NetConnection;
		private var _FunctionCaller:Function;
		
		private const _ConnectionRequestQueue:Vector.<ConnectionRequest> = new Vector.<ConnectionRequest>();
		
		private var _QueueIsOnTheRun:Boolean = false;
		
		private var _Mode:String = "Auto";
		
		private var _TimeOutID:uint = 0;
		private var _QueueExecutePeriod:uint = 100;
		
		private var _GroupCallVo:Get_ResultGroup;
		
		private var _CurrentCaller:Array;
		
		public function ConnectionManager( _InputServerConnection:NetConnection ) {
			this._ServerConnection = _InputServerConnection;
			this._FunctionCaller = this._ServerConnection.call;
			//trace( "ConnectionMannager Constructed" );
		}
		
		public function AddCall( _InputConnectionRequest:ConnectionRequest ):void {
			this.StatusJudgement( this._Mode , _InputConnectionRequest );
			//this._QueueIsOnTheRun == false ? this.Active( this._ConnectionRequestQueue ) : null ;//if the queue has done , reactivate.
		}
		
		private function Active( _InputQueue:Vector.<ConnectionRequest> ):void {
			clearTimeout( this._TimeOutID );
			if ( _InputQueue.length > 0 ) {
				this._QueueIsOnTheRun = true;
				//trace( _InputQueue[ 0 ] );
					this._CurrentCaller = _InputQueue[0].ParamArray;
					this._FunctionCaller.apply( null , _InputQueue[0].ParamArray );
					_InputQueue.shift();
				//trace( _InputQueue , _InputQueue.length );
				this._TimeOutID = setTimeout( this.Active , this._QueueExecutePeriod , _InputQueue );
			}else {
				this._QueueIsOnTheRun = false;
				//clearTimeout( this._TimeOutID );
				return;
			}
		}
		
		public function StartQueue():void {
			( this._QueueIsOnTheRun == false ) ? this.Active( this._ConnectionRequestQueue ) : null;
		}
		
		public function StopQueue():void {
			clearTimeout( this._TimeOutID );
		}
		
		public function set Mode( value:String ):void {
			this._Mode = value;
			this.StatusJudgement( this._Mode );
		}
		
		public function get Mode( ):String {
			return this._Mode;
		}
		
		public function get QueueExecutionPeriod():uint {
			return _QueueExecutePeriod;
		}
		
		public function set QueueExecutionPeriod(value:uint):void {
			_QueueExecutePeriod = value;
		}
		
		public function get GroupCallVo():Get_ResultGroup {//121127
			return _GroupCallVo;
		}
		
		private function StatusJudgement( _InputStatus:String , _InputConnectionRequest:ConnectionRequest = null ):void {
			//var _ActiveOrNot:Boolean = false;
			switch( _InputStatus ) {
				case "Manual":
						clearTimeout( this._TimeOutID );
						( _InputConnectionRequest != null ) ? this._ConnectionRequestQueue.push( _InputConnectionRequest ) : null ;
					break;
					
				case "Instant":
						//clearTimeout( this._TimeOutID );
						( _InputConnectionRequest != null ) ? this._ConnectionRequestQueue.unshift( _InputConnectionRequest ) : null ;
						this.StartQueue();
						//( this._QueueIsOnTheRun == false ) ? this.Active( this._ConnectionRequestQueue ) : null;
						//( _InputConnectionRequest != null ) ? this._FunctionCaller.apply( null , _InputConnectionRequest.ParamArray ) : null;
						//( _InputConnectionRequest != null ) ? trace( _InputConnectionRequest.ParamArray ) : null;
					break;
					
				default://Auto
						( _InputConnectionRequest != null ) ? this._ConnectionRequestQueue.push( _InputConnectionRequest ) : null ;
						//( this._QueueIsOnTheRun == false ) ? this.Active( this._ConnectionRequestQueue ) : null;
						this.StartQueue();
					break;
			}
			//return _ActiveOrNot;
		}
		
		
		//-------------------------------------------------------連線群組
		public function addGroupCall( _InputVo:* ):void {
			this._GroupCallVo = ( this._GroupCallVo == null ) ? new Get_ResultGroup() : this._GroupCallVo;
			this._GroupCallVo.AddRequest( _InputVo );
		}
		
		public function clearGroupCall( ):void {
			this._GroupCallVo = null;
		}
		
		public function get currentGroupRequestingList():Array {
			return ( this._GroupCallVo != null ) ? this._GroupCallVo._requestQueue : null;
		}
		
		public function get CurrentCaller():Array {
			return _CurrentCaller;
		}
		
		
		
		
		//---------------------------------------------END-------連線群組
		
	}//end class

}//end package