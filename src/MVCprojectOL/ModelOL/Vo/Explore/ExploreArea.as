package MVCprojectOL.ModelOL.Vo.Explore {
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Explore.Data.WorldJourneyDataCenter;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.Vo.Buildschedule;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import strLib.proxyStr.ProxyPVEStrList;
	//import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	
	import Spark.coreFrameWork.MVC.FacadeCenter;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.11.09
	 */
	registerClassAlias( "ExploreArea" , ExploreArea );
	public class ExploreArea {
		
		public var _guid:String;//GUID
		
		public var _name:String;//區域名稱
		
		public var _accessible:Boolean;//是否開放		開放條件為是否擊敗前相關區域的BOSS
		
		public var _info:String;//Tip
		
		//public var _boss:BattleFighter;//該區域的BOSS(或是可獲得的怪物)資訊 (Tip可能會用到)
		//public var _boss:Object;//該區域的BOSS(或是可獲得的怪物)資訊 (Tip可能會用到)
		
		//public var _uiKey:String;//底版素材KEY  ANI
		
		//public var _exploreSceneKey:Array;//探索場景清單 5張  當戰鬥時，則與該節點背景相同
		public var _exploreSceneKey:String;//探索場景清單 5張  當戰鬥時，則與該節點背景相同
		
		public var _bgmKey:String;//該區域探索背景音樂
		//public var _combatMKey:String;//該區域戰鬥音樂  
		
		public var _coolDown:Array;//冷卻所需的秒數 0.普通 1.困難 2.地獄
		
		public var _defaultDifficulty:uint = 1;//預設/上次記錄的難易度
		public var _MaxDifficulty:uint = 1;//目前最大難易度上限
		
		
		public var _length:uint;//總探索節點數
		
		
		
		
		//============================Client Only
		//private var _BuildSchedule:Object;//Buildschedule index : _startTime	,	_needTime	,	_finishTime	,	_target	,	_timeCheck	,	_schID	,
		private var _TimeLineProxy:TimeLineProxy = FacadeCenter.GetFacadeCenter().GetProxy( ProxyPVEStrList.TIMELINE_PROXY ) as TimeLineProxy;//TimeLineProxy   IfProxy
		
		public function ExploreArea() {
			//this.GetCoolDownStatus();//在建構時是拿不到值的
		}
		
		public function get CoolDown():Object {
			/*this._BuildSchedule = this._TimeLineProxy.GetExproleSingleLine( WorldJourneyDataCenter._BuildScheduleCode , this._guid );
			return this._BuildSchedule;*/
			return this._TimeLineProxy.GetExproleSingleLine( WorldJourneyDataCenter._BuildScheduleCode , this._guid );
			//return this._TimeLineProxy.GetExproleSingleLine( "-1" , this._guid );
		}
		
	}//end class

}//end package