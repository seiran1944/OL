package Spark.MVCs.Models.NetWork 
{
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.Utils.GlobalEvent.EventExpress;
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 * @version 12.11.23.11.52
	 */
	import Spark.Utils.GlobalEvent.EventExpress;
	//import Spark.MVCs.Models.NetWork.AmfConnection.NetEvent;
	//import GlobalEvent.EventExpress;
	
	public class NetResultPack {
		
		public var _signature:String = "Anonymous";//發送者的簽名檔(取得這個回應VO的動作類別名稱)
		
		public var _replyDataType:String = "null";//所包含的VO檔案型態	
		public var _result:* = null;//實際VO的內容(可以是ARRAY 或 單一物件 或 不給  端看需求者的需求)
		
		public var _serverTime:uint = 0;
		public var _serverStatus:String = "Unwritten";//伺服器檢查狀態
									/*
									 * 預設"Unwritten"	:	代表伺服器未填寫
									 * "其他陸續定義"
									 * 
									 * */
		
		
		public function NetResultPack() {
			trace("=====Server responded with a Value Object as Result=====" );
		}
		
		public function SendNotification():void {
			//trace("serverBack___(sendBefore)"+this._replyDataType);
			EventExpress.DispatchGlobalEvent( NetEvent.NetResult , this._replyDataType , this , this._signature , false );
			trace("serverBack___(sendAfter)"+this._replyDataType);
		}
		
		/*public function PrintResult():void {
			//trace("=====Value Object Contains=====" , _Signature , _ResultDataType , _ServerStatus );
		}*/
		
	}//end class

}//end package