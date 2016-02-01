package MVCprojectOL.ModelOL.Explore.Majidan {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.02.18.14.29
	 */
	
	
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	import MVCprojectOL.ModelOL.Vo.Explore.Get_ExploreAreas;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	 
	 
	 
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
		
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	import ProjectOLFacade;
	//----------------------------------------------------------------------VOs

	//-------------------------------------------------------------END------VOs
	import strLib.proxyStr.ProxyNameLib;
	
	import MVCprojectOL.ModelOL.LoadingCache.RemoteCache;
	 
	import strLib.commandStr.MajidanStrLib;
		
	public final class MajidanProxy extends ProxY{//extends ProxY
		private static var _MajidanProxy:MajidanProxy;
		
		private var _isInitialized:Boolean = false;
		
		private var _MajidanUiKey:String;//真正的UI Key 紀錄在Catch控制器中
		private var _RemoteCache:RemoteCache;
		
		
		
		private var _Net:AmfConnector = AmfConnector.GetInstance();
		private var _ExploreDataCenter:ExploreDataCenter = ExploreDataCenter.GetInstance();
		
		
		
		public static function GetInstance():MajidanProxy {
			return MajidanProxy._MajidanProxy = ( MajidanProxy._MajidanProxy == null ) ? new MajidanProxy() : MajidanProxy._MajidanProxy; //singleton pattern
		}
		
		public function MajidanProxy() {
			//constructor
			MajidanProxy._MajidanProxy = this;
			super( ProxyNameLib.Proxy_MajidanProxy , this );
			
			//this.GetUrlData();
			trace( "MajidanProxy constructed !!" );
		}
		
		public function init( _InputUiKey:String ):void {
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			
			this._MajidanUiKey = _InputUiKey;
			
			this.FlashExploreAreas();//開始載入資料
			/*130121
			載入流程
			1.魔神殿資料
			2.魔神殿素材
			
			3.完成初始*/
			//this.LoadMaJidanUi( _InputUiKey );//暫時跳過VO載入
			
		}
		
		public function Terminate():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			ProjectOLFacade.GetFacadeOL().RemoveProxy( ProxyNameLib.Proxy_MajidanProxy );
			MajidanProxy._MajidanProxy = null;
			EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			
			if ( this._RemoteCache != null ) {
				this._RemoteCache.Destroy();
				this._RemoteCache = null;
			}
			
			
			this.SendNotify( "MajidanEvent.Terminate_MajidanProxy" );
			
		}
		
		
		//=========================================================================Actions
		public function FlashExploreAreas():void {//該段會進入循環結構    在地圖資訊更新時將會重複呼叫 (初始時也會呼叫)
			//this._Net.VoCall( "new Get_ExploreAreas()" );
			this._Net.VoCall( new Get_ExploreAreas() );//取得ExploreAreaList資料清單(或是刷新)
			//trace("new Get_UrlData()--------------------------------------------------------------");
		}
		
		private function LoadMaJidanUi( _InputUiKey:String ):void {//魔神殿素材   當資料與素材皆載入完畢時  代表模組已OK  則發送Ready Signal
			this._RemoteCache = ( this._RemoteCache == null ) ? new RemoteCache( _InputUiKey , this.onMediaComponentReturned ) : this._RemoteCache;
			this._RemoteCache.UpdateFailListening( this.onMediaComponentInvalid );
			this._RemoteCache.StartLoad();
		}
		
		
		//================================================================END======Actions
		
		
		
		
		private function onMediaComponentReturned( _InpurKey:String ):void {
			//魔神殿素材回來時
			trace( "魔神殿素材回來了" );
			this._isInitialized = true;//初始化完成
			this.SendNotify( _InpurKey );
			//開始進入控制流程
			 
		}
		
		private function onMediaComponentInvalid( _InpurKey:String ):void {
			//魔神殿素材錯誤
			this._isInitialized = false;//初始化未完成
			this.SendNotify( _InpurKey + "Invalid" );
			//結束控制流程
		}
		
		
		
		
		//=====================================================================Net message transport router
		private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );
			switch ( _Result.Status ) {
				case "ExploreAreaList" :	//每次刷新地圖資訊時  將其寫回資訊中心
						this._ExploreDataCenter.DeserializeExploreAreaList( _NetResultPack._result as Array );	//寫入魔神殿區塊資料
						this.SendNotify( MajidanStrLib.RenewExploreArea );		//發送區域狀態變更資訊 相關人員向ExploreDataCenter確認資料
						
						this._isInitialized == false ? this.LoadMaJidanUi( this._MajidanUiKey ) : null;		//若是初始程序，則導入素材載入階段
						//注意：該段在進行地圖資訊更新的時候，會被重複執行，需考慮初始與循環狀態的差異性
					break;
					
				default :
					break;
			}
		}
		//=============================================================END=====Net message transport router
		
		
		
		
		
		
		
	}//end class
}//end package