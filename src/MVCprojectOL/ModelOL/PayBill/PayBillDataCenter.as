package MVCprojectOL.ModelOL.PayBill {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.04.02.17.02
	 */
	
	
	
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Vo.PayBill;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	 
	 
	 
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
		
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	//----------------------------------------------------------------------VOs
	import MVCprojectOL.ModelOL.Vo.Get.Get_PayBillData;
	//-------------------------------------------------------------END------VOs

	import strLib.proxyStr.ProxyNameLib;
		
	public final class PayBillDataCenter extends ProxY{//extends ProxY
		private static var _PayBillDataCenter:PayBillDataCenter;
		
		private var _Net:AmfConnector = AmfConnector.GetInstance();
		
		private var _dicPayBill:Dictionary;
		//private var _PayBillList:Object;
		//--PayBill
		
		public static function GetInstance():PayBillDataCenter {
			return PayBillDataCenter._PayBillDataCenter = ( PayBillDataCenter._PayBillDataCenter == null ) ? new PayBillDataCenter() : PayBillDataCenter._PayBillDataCenter; //singleton pattern
		}
		
		public function PayBillDataCenter() {
			//constructor
			super( ProxyNameLib.Proxy_PayBillDataCenter , this );
			PayBillDataCenter._PayBillDataCenter = this;
		
			
		}
		
		override public function onRegisteredProxy():void 
		{
			this._dicPayBill = new Dictionary(true);
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			//取得PayBill資料清單
			this._Net.VoCall( new Get_PayBillData());
			//this.GetPayBillData();
			trace( "PayBillDataCenter constructed !!" );
			
		}
		
		
		//=========================================================================Actions
		/*
		private function GetPayBillData():void {
			
		}*/
		
		private function TerminateNetRequist():void {
			EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
		}
		//================================================================END======Actions
		
		//=====================================================================Net message transport router
		private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			switch ( _Result.Status ) {
				case "PayBillData" ://
						//trace("PayBillData________>>"+_NetResultPack._result);
						//this._PayBillList = _NetResultPack._result as Object;
						var _ary:Array=_NetResultPack._result as Array;
						if (_ary != null) this.SetPayBillHandler(_ary);
						
						
				break;
					
				default :
			   break;
			}
		}
		
		
		
		private function SetPayBillHandler(_ary:Array):void 
		{
			var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._dicPayBill[_ary[i]._guid]==null && this._dicPayBill[_ary[i]._guid]==undefined) {
					this._dicPayBill[_ary[i]._guid] = _ary[i];
				}
				
			}
			
			this.TerminateNetRequist();
			this.SendNotify( CommandsStrLad.PayBillDataReady );
		}
		
		
		
		//=============================================================END=====Net message transport router
		
		public function Inquiry( _InputRequireKey:String ):PayBill {
			
			var _PayBill:PayBill;
			if (this._dicPayBill[_InputRequireKey]!=null && this._dicPayBill[_InputRequireKey]!=undefined) {
				_PayBill = this._dicPayBill[_InputRequireKey] as PayBill;
			
			}
			
			return _PayBill;
			//return ( this._PayBillList != null && this._PayBillList[ _InputRequireKey ] != null ) ? this._PayBillList[ _InputRequireKey ] : 0;
		}
		
		override public function onRemovedProxy():void {
			this.TerminateNetRequist();
			PayBillDataCenter._PayBillDataCenter = null;
			this._Net = null;
			//this._PayBillList = null;
		}
		
		
	}//end class
}//end package