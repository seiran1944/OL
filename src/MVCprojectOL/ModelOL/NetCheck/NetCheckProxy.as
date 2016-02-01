package MVCprojectOL.ModelOL.NetCheck {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.08.11.41
	 * 這個ProxY在有NetCheckProxy封包時   會將server time 數值更新至 PlayerDataCenter.as
	 * 
	 * 121228
	 */
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import strLib.proxyStr.ProxyNameLib;
	 
	 
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.MVCs.Models.NetWork.GroupCall.NetResultPackGroup;
	 
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	 
	//-----------------------------VOs
	//import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerData;
	//import MVCprojectOL.ModelOL.Vo.PlayerData;
	//-----------------------------VOs
	//import strLib.proxyStr.ProxyNameLib;
	//import Spark.CommandsStrLad;
	 
	import MVCprojectOL.ModelOL.DataCenter.DataCenterEvent;
	 
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	
	import MVCprojectOL.ControllOL.SysError.Error503;
	 
	public class NetCheckProxy extends ProxY{
		private static var _NetCheckProxy:NetCheckProxy;
		
		private var _Net:AmfConnector;
		private var _ServerTimework:ServerTimework;
		
		public static function GetInstance():NetCheckProxy {
			return NetCheckProxy._NetCheckProxy = ( NetCheckProxy._NetCheckProxy == null ) ? new NetCheckProxy() : NetCheckProxy._NetCheckProxy; //singleton pattern
		}
		
		public function NetCheckProxy() {
			super( ProxyNameLib.Proxy_NetCheckProxy , this );
			NetCheckProxy._NetCheckProxy = this;
			
			EventExpress.AddEventRequest( NetEvent.NetResultGroup , this.onNetResultGroup , this );//建立連線事件接收
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			
			this._Net = AmfConnector.GetInstance();
			this._ServerTimework = ServerTimework.GetInstance();
			
			
		}
		
		private function TerminateModule():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			//this.SendNotify( DataCenterEvent.Terminate_NetCheckProxy );
			NetCheckProxy._NetCheckProxy = null;
		}
		
		//=====================================================================Net message transport router
		private function onNetResultGroup( _Result:EventExpressPackage ):void {
			var _NetResultPackGroup:NetResultPackGroup =  _Result.Content as NetResultPackGroup;
			
			PlayerDataCenter.WriteServTime( _NetResultPackGroup._serverTime );//儲存該次對齊的Server時間
			this._ServerTimework.SetServerTime( uint( _NetResultPackGroup._serverTime ) );//將Client對齊Server時間
			//trace( PlayerDataCenter.LastServTime );
			trace( " +Time Clock Adjusted--------------------- " , this );
			
			//this.ServerStatusCheck( _NetResultPackGroup._serverStatus );
			//this.ServerStatusCheck( _NetResultPack );
		}
		
		private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			
			PlayerDataCenter.WriteServTime( _NetResultPack._serverTime );//儲存該次對齊的Server時間
			this._ServerTimework.SetServerTime( uint( _NetResultPack._serverTime ) );//將Client對齊Server時間
			//trace( PlayerDataCenter.LastServTime );
			trace( " +Time Clock Adjusted--------------------- " , this );
			
			//this.ServerStatusCheck( _NetResultPack._serverStatus );
			this.ServerStatusCheck( _NetResultPack );
			
		}
		//=============================================================END=====Net message transport router
		
		
		//private function ServerStatusCheck( _InputServerStatus:String ):void {
		private function ServerStatusCheck( _InputServerStatus:NetResultPack ):void {
			//伺服器狀態檢查接這裡
			var _netStr:String = _InputServerStatus._serverStatus as String;
			//if(_netStr)
			//---503-玩家資料錯誤/999-runewaker帳號被鎖住
			if (_netStr=="503" || _netStr=="999") this.SendNotify( Error503.Error503Event , _InputServerStatus );
			//if (_netStr=="999") this.SendNotify( Error503.Error503Event , _InputServerStatus );
				
				
			/*
			switch ( _netStr ) {
				case "503"	: 
						this.SendNotify( Error503.Error503Event , _InputServerStatus );
					break;
					
				default:
				break;
			}*/
			//this.SendNotify( Error503.Error503Event , _InputServerStatus );//for test
			trace( " ---------Checking Server Status----------- " , this );
		}
		

		
	}//end class
}//end package