package MVCprojectOL.ModelOL.UrlData {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	
	
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	 
	 
	 
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
		
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	//import MVCprojectOL.ModelOL.Explore.ExploreEvent;
		
	import Spark.Utils.KeyCodeInfo.UrlKeeper;
		
	//----------------------------------------------------------------------VOs
	import MVCprojectOL.ModelOL.Vo.Get.Get_UrlData;
	//-------------------------------------------------------------END------VOs
	import MVCprojectOL.ModelOL.UrlData.UrlDataEvent;
	import strLib.proxyStr.ProxyNameLib;
		
	public final class GetUrlDataProxy extends ProxY{//extends ProxY
		private static var _GetUrlDataProxy:GetUrlDataProxy;
		
		/*private var _CurrentAreaID:String;
		private var _CurrentTeamID:String;
		
		private var _CurrentSceneData:ExploreData;
		private var _CurrentRoute:Vector.<RouteNode>;
		
		private var _CurrentFightResult:ExploreFightResult;
		
		
		private var _PlayerNotifyCenter:PlayerNotifyCenter = PlayerNotifyCenter.GetInstance();*/
		private var _Net:AmfConnector = AmfConnector.GetInstance();
		
		
		public static function GetInstance():GetUrlDataProxy {
			return GetUrlDataProxy._GetUrlDataProxy = ( GetUrlDataProxy._GetUrlDataProxy == null ) ? new GetUrlDataProxy() : GetUrlDataProxy._GetUrlDataProxy; //singleton pattern
		}
		
		public function GetUrlDataProxy() {
			//constructor
			super( ProxyNameLib.Proxy_GetUrlDataProxy , this );
			GetUrlDataProxy._GetUrlDataProxy = this;
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			this.GetUrlData();
			trace( "GetUrlDataProxy constructed !!" );
		}
		
		private function TerminateModule():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			this.SendNotify( UrlDataEvent.Terminate_GetUrlDataProxy );
			//GetUrlDataProxy._GetUrlDataProxy = null;
		}
		
		
		//=========================================================================Actions
		private function GetUrlData():void {
			//this._Net.VoCall( "new Get_UrlData()" );
			this._Net.VoCall( new Get_UrlData() );//取得URL資料清單
			//trace("new Get_UrlData()--------------------------------------------------------------");
		}
		
		//================================================================END======Actions
		
		
		
		//=====================================================================Net message transport router
		private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );
			switch ( _Result.Status ) {
				case "UrlList" ://
						trace("URLdata0301______"+_NetResultPack._result);
					    this.DeserializeUrlData( _NetResultPack._result as Object );//將UrlData 寫入 UrlKeeper.as 儲存 
						this.TerminateModule();//終止這個Proxy
					break;
					
				default :
					break;
			}
			
		}
		//=============================================================END=====Net message transport router
		
		private function DeserializeUrlData( _InputUrlList:Object ):void {
			
			for ( var i:* in _InputUrlList ) {
				UrlKeeper.addUrlCode( ( i as String ) , ( i as String ).substr( 0 , 3 ) , _InputUrlList[ i ] );
				//trace("getUrlDataProxy>>"+ i , _InputUrlList[i] );
			}
			
		}
		
		
		
		
		
	}//end class
}//end package