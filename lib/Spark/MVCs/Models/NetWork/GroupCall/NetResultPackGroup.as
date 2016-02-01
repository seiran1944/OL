package Spark.MVCs.Models.NetWork.GroupCall 
{
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 * @version 12.11.23.11.52
	 */
	//import Spark.utils.GlobalEvent.EventExpress;
	//import Spark.MVCs.Models.NetWork.AmfConnection.NetEvent;
	//import GlobalEvent.EventExpress;
	
	public class NetResultPackGroup {
		
		public var _signature:String = "Get_ResultGroup";//發送者的簽名檔(取得這個回應VO的動作類別名稱)
		
		public var _replyDataType:String = "NetResultPack";//所包含的VO檔案型態	
		public var _responseQueue:Array = null;//NetResultPacks
		
		public var _serverTime:uint = 0;
		public var _serverStatus:String = "Unwritten";//伺服器檢查狀態
									/*
									 * 預設"Unwritten"	:	代表伺服器未填寫
									 * "其他陸續定義"
									 * 
									 * */
		
		
		public function NetResultPackGroup() {
			trace( "=====GroupNetResultPack=====" );
		}
		
		public function SendNotification():void {
			EventExpress.DispatchGlobalEvent( NetEvent.NetResultGroup , this._replyDataType , this , this._signature , false );
			if ( this._responseQueue != null ) {
				var _ResponseQueueLength:uint = this._responseQueue.length;
				for (var i:int = 0 ; i < _ResponseQueueLength ; i++) {
					NetResultPack( this._responseQueue[ i ] ).SendNotification();
				}
			}
			
		}//end function SendNotification

		
	}//end class

}//end package