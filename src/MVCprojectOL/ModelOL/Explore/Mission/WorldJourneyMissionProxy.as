package MVCprojectOL.ModelOL.Explore.Mission {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.06.05.10.50
	 */
	
	
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	import MVCprojectOL.ModelOL.Explore.Data.WorldJourneyDataCenter;
	import MVCprojectOL.ModelOL.LoadingCache.MultiRemoteCache;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	import MVCprojectOL.ModelOL.Vo.Explore.Get_ExploreAreas;
	import MVCprojectOL.ModelOL.Vo.Explore.Get_ExploreChapter;
	import MVCprojectOL.ModelOL.Vo.Explore.RouteNode;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Mission;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
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
	
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionComplete;
	//----------------------------------------------------------------------VOs

	//-------------------------------------------------------------END------VOs
	import strLib.proxyStr.ProxyNameLib;
	
	import MVCprojectOL.ModelOL.LoadingCache.RemoteCache;
	 
	import strLib.commandStr.MajidanStrLib;
		
	public final class WorldJourneyMissionProxy extends ProxY {//extends ProxY
		private static var _ProxyName:String = "WorldJourneyMissionProxy";
		private static var _WorldJourneyMissionProxy:WorldJourneyMissionProxy;
		
		
		private var _Net:AmfConnector = AmfConnector.GetInstance();
		private var _WorldJourneyDataCenter:WorldJourneyDataCenter = WorldJourneyDataCenter.GetInstance();
		private var _ExploreDataCenter:ExploreDataCenter = ExploreDataCenter.GetInstance();
		
		//private var _TimeLineProxy:TimeLineProxy = FacadeCenter.GetFacadeCenter().GetProxy( ProxyPVEStrList.TIMELINE_PROXY );
		private var _currentRouteNode:RouteNode;
		
		public static function GetInstance():WorldJourneyMissionProxy {
			return WorldJourneyMissionProxy._WorldJourneyMissionProxy = ( WorldJourneyMissionProxy._WorldJourneyMissionProxy == null ) ? new WorldJourneyMissionProxy() : WorldJourneyMissionProxy._WorldJourneyMissionProxy; //singleton pattern
		}
		
		public function WorldJourneyMissionProxy() {
			//constructor
			WorldJourneyMissionProxy._WorldJourneyMissionProxy = this;
			super( WorldJourneyMissionProxy._ProxyName , this );
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			//this.GetUrlData();
			trace( "WorldJourneyMissionProxy constructed !! " );
		}
		
		/*public function init( ):void {
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
		}*/
		
		public function Terminate():void {
			ProjectOLFacade.GetFacadeOL().RemoveProxy( WorldJourneyMissionProxy._ProxyName );
			WorldJourneyMissionProxy._WorldJourneyMissionProxy = null;
			EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			
			this._Net = null;
			this._ExploreDataCenter = null;
			this._WorldJourneyDataCenter = null;
		}
		
		
		
		//=====================================================================Net message transport router
		private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );
			switch ( _Result.Status ) {
				case "RouteNode" :	//每次刷新地圖資訊時  將其寫回資訊中心
						//var _currentRouteNode:RouteNode = _NetResultPack._result as RouteNode
							//_currentRouteNode != null ? this.ConditionDeserializer( _currentRouteNode ) : null;
						this._currentRouteNode = _NetResultPack._result as RouteNode;
					break;
					
				default :
					break;
			}
		}
		//=============================================================END=====Net message transport router
		
		public function goCheckMission():void {
			this._currentRouteNode != null ? this.ConditionDeserializer( _currentRouteNode ) : null;
		}
		
		
		private function ConditionDeserializer( _InputRouteNode:RouteNode ):void {
			var _ConditionList:Array = [ ];
			
			var _MissionConditionComplete:MissionConditionComplete;
			var _CurrentTarget:*;
			
			if ( _InputRouteNode._itemDrop != null ) {
					_CurrentTarget = _InputRouteNode._itemDrop._monsters;
				if ( _CurrentTarget != null ) {//惡魔[%s]有[%s]隻被擁有
					var _Length:uint = _CurrentTarget.length;
					for (var i:int = 0; i < _Length; i++) {
						_MissionConditionComplete = new MissionConditionComplete();
						_MissionConditionComplete._missionType = ProxyPVEStrList.MISSION_Cal_MONSTER_HAVE;
						_MissionConditionComplete._target = PlayerMonster( _CurrentTarget[ i ] )._gruopGuid ;
						_ConditionList.push( _MissionConditionComplete );
					}
				}
			}
			
			
			
				_MissionConditionComplete = new MissionConditionComplete();
				_MissionConditionComplete._missionType = ProxyPVEStrList.MISSION_Cal_MSP_EXPLORE;
				//_MissionConditionComplete._target = this._ExploreDataCenter._currentSelectedAreaKey;
				_MissionConditionComplete._target = this._WorldJourneyDataCenter.LocateChapterID_ByAreaID( this._ExploreDataCenter._currentSelectedAreaKey );//使用AreaID反查ChapterID
				_ConditionList.push( _MissionConditionComplete );//區域[%s]探索[%s]難度第[%s]節點[%s]次
				
				_CurrentTarget = _InputRouteNode._battleScript;
			if ( _CurrentTarget != null ) {
				_CurrentTarget = Object( _InputRouteNode._battleScript._objEnemy );
				for (var j:* in _CurrentTarget ) {
					_MissionConditionComplete = new MissionConditionComplete();
					_MissionConditionComplete._missionType = ProxyPVEStrList.MISSION_Cal_NPC_KO;
					_MissionConditionComplete._target = BattleFighter( _CurrentTarget[ j ] )._guid;
					_ConditionList.push( _MissionConditionComplete );//NPC[%s]被打倒[%s]次
				}
			}
			
			
			this._Net.VoCallGroup( new Get_Mission( _ConditionList ) );//通知SERVER做任務條件檢查
			
		}
		
		
		
		
		
	}//end class
}//end package