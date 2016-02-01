package MVCprojectOL.ModelOL.Explore.WorldJourney {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.11.09
	 */
	
	
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Explore.Data.WorldJourneyDataCenter;
	import MVCprojectOL.ModelOL.LoadingCache.MultiRemoteCache;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	import MVCprojectOL.ModelOL.Vo.Explore.Get_ExploreAreas;
	import MVCprojectOL.ModelOL.Vo.Explore.Get_ExploreChapter;
	import Spark.coreFrameWork.MVC.FacadeCenter;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.WorldJourneyStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	 
	 
	 
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
		
	public final class WorldJourneyProxy extends ProxY{//extends ProxY
		private static var _WorldJourneyProxy:WorldJourneyProxy;
		
		private var _isInitialized:Boolean = false;
		
		private var _WorldJourneyUiKey:String;//真正的UI Key 紀錄在Catch控制器中
		private var _RemoteCache:MultiRemoteCache;
		
		
		private var _Net:AmfConnector = AmfConnector.GetInstance();
		private var _WorldJourneyDataCenter:WorldJourneyDataCenter = WorldJourneyDataCenter.GetInstance();
		
		private var _ComponentKeyList:Vector.<String>;
		
		//private var _TimeLineProxy:TimeLineProxy = FacadeCenter.GetFacadeCenter().GetProxy( ProxyPVEStrList.TIMELINE_PROXY );
		public static function GetInstance():WorldJourneyProxy {
			return WorldJourneyProxy._WorldJourneyProxy = ( WorldJourneyProxy._WorldJourneyProxy == null ) ? new WorldJourneyProxy() : WorldJourneyProxy._WorldJourneyProxy; //singleton pattern
		}
		
		public function WorldJourneyProxy() {
			//constructor
			WorldJourneyProxy._WorldJourneyProxy = this;
			super( ProxyNameLib.Proxy_WorldJourneyProxy , this );
			
			//this.GetUrlData();
			trace( "WorldJourneyProxy constructed !! " );
		}
		
		public function init( _InputUiKey:String ):void {
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			
			this._WorldJourneyUiKey = _InputUiKey;
			
			this.FlashExploreChapters();//開始載入資料
			/*130121
			載入流程
			1.魔神殿資料
			2.魔神殿素材
			
			3.完成初始*/
			//this.LoadUi( _InputUiKey );//暫時跳過VO載入
			
		}
		
		public function Terminate():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			ProjectOLFacade.GetFacadeOL().RemoveProxy( ProxyNameLib.Proxy_WorldJourneyProxy );
			WorldJourneyProxy._WorldJourneyProxy = null;
			EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			
			if ( this._RemoteCache != null ) {
				this._RemoteCache.Stop();
				this._RemoteCache = null;
			}
			
			
			//this.SendNotify( "MajidanEvent.Terminate_WorldJourneyProxy" );
			
		}
		
		
		//=========================================================================Actions
		public function FlashExploreChapters():void {//該段會進入循環結構    在地圖資訊更新時將會重複呼叫 (初始時也會呼叫)
			this._Net.VoCall( new Get_ExploreChapter() );//取得ExploreChapterList資料清單(或是刷新)
			//trace("new Get_UrlData()--------------------------------------------------------------");
		}
		
		private function LoadUi( _InputUiKey:Vector.<String> ):void {//Chapter素材   當資料與素材皆載入完畢時  代表模組已OK  則發送Ready Signal
			_InputUiKey.push( "GUI00014_ANI" );
			this._RemoteCache ||= new MultiRemoteCache( _InputUiKey , onMediaComponentReturned , this.onMediaComponentInvalid , true );
			//this._RemoteCache.UpdateFailListening( this.onMediaComponentInvalid );
			this._RemoteCache.StartLoad();
		}
		
		
		//================================================================END======Actions
		
		
		
		
		private function onMediaComponentReturned( _InputKey:String ):void {
			//世界地圖素材回來時
			trace( "世界地圖素材回來了" );
			this._isInitialized = true;//初始化完成
			this.SendNotify( WorldJourneyStrLib.ComponentsAreReady );
			//開始進入控制流程
			 
		}
		
		private function onMediaComponentInvalid( _InputKey:String ):void {
			//世界地圖素材錯誤
			this._isInitialized = false;//初始化未完成
			this.SendNotify( _InputKey + "Invalid" );
			//結束控制流程
		}
		
		
		
		
		//=====================================================================Net message transport router
		private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );
			switch ( _Result.Status ) {
				case "ExploreChapterList" :	//每次刷新地圖資訊時  將其寫回資訊中心
						this._ComponentKeyList = this._WorldJourneyDataCenter.DeserializeExploreChapterList( _NetResultPack._result as Array );	//寫入Chapter資料
						//this.SendNotify( WorldJourneyStrLib.RenewExploreChapter );		//發送Chapter狀態變更資訊 相關人員向WorldJourneyDataCenter確認資料
						
						//this._isInitialized == false ? this.LoadUi( this._ComponentKeyList ) : null;		//若是初始程序，則導入素材載入階段
						this._isInitialized == false ? this.LoadUi( this._ComponentKeyList ) : this.SendNotify( WorldJourneyStrLib.RenewExploreChapter );		//若是初始程序，則導入素材載入階段
						//注意：該段在進行地圖資訊更新的時候，會被重複執行，需考慮初始與循環狀態的差異性
					break;
					
				default :
					break;
			}
		}
		//=============================================================END=====Net message transport router
		
		
		/*private function CheckBuildSchedule():void {//檢查排程 並建立ExploreArea._guid 與 Bildschedule._guid對照表 (PS:兩者ID代表意義不同)
			var _ScheduleList:Dictionary = new Dictionary( true );
			var _ExploreSchedule:Array = this._TimeLineProxy.GetAllLine();
			//Buildschedule index : _startTime	,	_needTime	,	_finishTime	,	_target	,	_timeCheck	,	_schID	,
			var _Length:uint = _ExploreSchedule.length;
			
			for (var i:int = 0; i < _Length; i++) {
				_ScheduleList[ _ExploreSchedule[ i ]._target ] = _ExploreSchedule[ i ]._schID;
			}
			
			//this._WorldJourneyDataCenter.
		}*/
		
		
		
		
		
	}//end class
}//end package