package MVCprojectOL.ModelOL.PvpSystem
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import MVCprojectOL.ModelOL.BattleImaging.BattleImagingProxy;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.Vo.Buildschedule;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Mission;
	import MVCprojectOL.ModelOL.Vo.Get.Get_PvpInit;
	import MVCprojectOL.ModelOL.Vo.ItemDrop;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionComplete;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpCompetition;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpDayVary;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpFightingReport;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpInitData;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpRankingUpdate;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpReward;
	import MVCprojectOL.ModelOL.Vo.Set.Set_PvpFighting;
	import MVCprojectOL.ModelOL.Vo.Set.Set_PvpReceiveReward;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class PvpSystemProxy extends ProxY 
	{
		
		private static var _pvpSystem:PvpSystemProxy;
		private var _operator:PvpOperator;
		
		
		
		public function PvpSystemProxy(name:String):void 
		{
			
			super(name, this);
			if (PvpSystemProxy._pvpSystem != null) throw new Error("Singleton Mode");
			
			PvpSystemProxy._pvpSystem = this;
			
			this._operator = new PvpOperator();
			EventExpress.AddEventRequest(NetEvent.NetResult , this.pvpDataBack, this);
			//調用時兌換GUID
			this._operator.Guid = BuildingProxy.GetInstance().GetBuildingGuid(int(this._operator.Guid));
		}
		
		public static function GetInstance():PvpSystemProxy
		{
			if (PvpSystemProxy._pvpSystem == null) PvpSystemProxy._pvpSystem = new PvpSystemProxy(ArchivesStr.PVP_SYSTEM);
			return PvpSystemProxy._pvpSystem;
		}
		
		//做無法使用建築物的判斷 > 若回false則代表會不處理 否則就能正常運作
		//初始只撈一次後續開UI不立即刷新 點選過程中會做檢查不符資料才重刷
		public function GetPvpInitData():Boolean
		{
			if (!this.checkUsable()) return false;
			!this._operator.Initialize ? this.callServer(new Get_PvpInit()) : this.dataReadyNotify();
			return true;
		}
		
		//純刷新清單的方式(預留做可能的手動刷新或定時刷新處理)
		//public function GetRankUpdate():void 
		//{
			//this.callServer(new Get_PvpRankList());
		//}
		
		//GROUP方式 立即呼叫SERVER處理
		private function callServer(VO:Object):void
		{
			//this.missionDataProcess(VO);
			AmfConnector.GetInstance().VoCallGroup(VO, true);
		}
		
		//夾帶任務需要的判斷資訊送出
		private function missionDataProcess(VO:Object):void 
		{
			//可依照VO類型來判斷TYPE種類 目前只有一種 (每日獎勵SERVER當作任務類處理 一般對戰SET時候台會處理 故ProxyPVEStrList.MISSION_Cal_PVP_RANK 不處理)
			var _missionHave:MissionConditionComplete= new MissionConditionComplete();
			_missionHave._missionType = ProxyPVEStrList.MISSION_Cal_PVP_RANK;
			AmfConnector.GetInstance().VoCallGroup(new Get_Mission([_missionHave]));
		}
		
		private function checkUsable():Boolean 
		{
			return BuildingProxy.GetInstance().GetBuildingEnable(this._operator.Guid);
		}
		
		private function dataReadyNotify():void 
		{
			this.viewActionNotify(ArchivesStr.PVP_SYSTEM_INIT, { _initData : this._operator.InitData , _fightable : this.PvpSallyCheck(),_aryDrop : this._operator.GetAwardDrop()});
		}
		
		private function pvpDataBack(e:EventExpressPackage):void 
		{
			var content:Object = NetResultPack(e.Content) ._result;
			if (content == null) {
				MessageTool.InputMessageKey(001);//SERVER回傳資料為空
				return;
			}
			
			switch (e.Status)//VO _replyDataType
			{
				case "PvpInitData" ://初始化取得資料 ( Get_PvpInit )
					this._operator.InitData = content as PvpInitData;
					this._operator.Initialize = true;
					this.dataReadyNotify();
					
					//this.ReceiveReward();//TEST USE
					//this.StartFighting("10613503830319939");//TEST USE
				break;
				//case "PvpRankingUpdate"://Get_PvpRankList //手動刷新或是循環刷新可用
					//var rankUpdate:PvpRankingUpdate = content as PvpRankingUpdate;
					//this._operator.RankingUpdate = rankUpdate;
					//this.viewActionNotify(ArchivesStr.PVP_SYSTEM_RANKUPDATE, rankUpdate);
				//break;
				case "PvpReward"://玩家領取獎勵時回傳實際的獎勵內容 (排程部分的獎勵回傳也會相同)
					var reward:PvpReward = content as PvpReward;
					if (reward._isReceiveBack) {//點選領取獎勵回來的確認包
						//reward._rewardItem._material
						this._operator.AwardDropProcess(reward._rewardItem);
					}
				break;
				case "PvpFightingReport"://Set_PvpFighting
					var report:PvpFightingReport = content as PvpFightingReport;
					if (report == null) return ;
					
					this._operator.RankingUpdate = report._rankUpdate;
					this.fightBackProcess(report);
					this._operator.GoFight = false;
					//BattleImagingProxy.GetInstance().ReadyToImaging("BTL136861163683296");//TEST USE
					//BattleImagingProxy.GetInstance().ReadyToImaging(report._battleReport._battleId);//TEST USE
				break;
				
			}
		}
		
		
		//發送通知SERVER挑戰對象後回傳的檢查判斷
		private function fightBackProcess(report:PvpFightingReport):void 
		{
			//clone and mixed ItemDisplay
			report._rankUpdate = this._operator.cloneRankingUpdate(report._rankUpdate);
			
			var needCD:Boolean = false;//是否需要顯示CD倒數
			var fightStop:Boolean = true;//是否中斷挑戰 刷新資料
			
			if (report._fightAvailable) {//已戰鬥
				//不論勝負皆有戰報 / 戰鬥失敗會加上CD值
				fightStop = false;
				
				if (!report._battleReport._isWin) {//打輸的狀態下通知排程處理
					this._operator.DataValue("_isCD", true);
					this.timeLineNotify(0, report._schedule);//新增排程處理
					needCD = true;
				}
				
				//VIEW需同時做清單更新與戰果UI顯示
				this._operator.DecreaseFightingCount();//減少可使用次數
				//PVP積分變更from ItemDrop內的屬性來抓變更值
				this._operator.ItemDropProcess(report._battleReport._itemDrop);
				
				//BattleImagingProxy.GetInstance().ReadyToImaging(report._battleReport._battleId);//TEST USE
				
				//VIEW做清單更新與戰報顯示(有戰鬥過程才會發送)
				this.viewActionNotify(ArchivesStr.PVP_SYSTEM_FIGHTBACK, this._operator.GetBattleResult(report));
			}
				
			//VIEW做單獨清單相關資料更新(出擊後皆會發送)
			this.viewActionNotify(ArchivesStr.PVP_SYSTEM_RANKUPDATE,{ _rankingUpdate : report._rankUpdate , _needCD : needCD , _fightTimes : this._operator.FightTimes , _fightStop : fightStop} );
			
			
		}
		//統一發送處
		private function viewActionNotify(type:String , content : Object):void 
		{
			this.SendNotify(type, content);
		}
		
		/*
		 * _buidID = "pvp"
		 * _buildType = 
		case -3: // PVP戰鬥歸零
		case -2: // PVP每日獎勵
		case 10: //PVP建築  PVP打輸CD
		*/
		//統一排程新增處(目前應該只會用到CD的排程)
		private function timeLineNotify(type:int,content:Object):void 
		{
			//TimeLineProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.TIMELINE_PROXY)).AddTimeLine();
			if (content == null) {
				trace("THE THING is NULL");
				return;
			}
			
			switch (type) 
			{
				case 0://用VO schedule 方式新增排程
					//CD用
					TimeLineObject.GetTimeLineObject().AddVoTimeLine([content]);
				break;
			}
			
		}
		
		//檢查顯示上會有更新到的區塊
		//有設置隊伍的問題
		//-1 = 輸入type錯誤 , 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中 , 3 = 血量不足   ,   4 = 可用出擊次數不足  ,  5 = PVP戰敗系統冷卻中 , <6 = 已點擊出征>
		public function StartFighting(playerId:String):int
		{
			if (this._operator.GoFight) return 6;
			
			var check:int = this.PvpSallyCheck();
			
			if (check == 0) {
				this._operator.GoFight = true;
				this.callServer(this._operator.GetFightCheckData(playerId));
			}
			
			return check;
		}
		
		//點選編輯隊伍按鈕 編輯完畢會收到ArchivesStr.PVP_CREW_EDIT 通知
		public function StartCrewEditing():void 
		{
			this.SendNotify(ArchivesStr.CREW_DEFAULT_SHOW, { _notifyString : ArchivesStr.PVP_CREW_EDIT , _type : 0 } );
		}
		
		//取得預設隊伍ItemDisplay
		public function GetPvpCrewDisplay():Object
		{
			return this._operator.GetCrewDisplay();
		}
		
		
		//-1 = 輸入type錯誤 , 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中 , 3 = 血量不足   ,   4 = 可用出擊次數不足  ,  5 = PVP戰敗系統冷卻中
		public function PvpSallyCheck():int
		{
			return this._operator.PvpSallyCheck();
		}
		
		//玩家領取配給的獎勵(點領獎按鈕)
		public function ReceiveReward():void 
		{
			//向SERVER通知玩家領取資料的VO 有獎勵需要回復(沒領過/有獎勵 才會發送通知)
			if(this._operator.CheckReward()) this.callServer( new Set_PvpReceiveReward());
		}
		
		//===============================排程相關資料取得===========================
		//1.CD時間到重刷戰鬥次數歸零(DAY)(變動率較大 , 或為配合一些活動作調整-應該會單獨做一個排程) [ 不做即時UI更新 ]
		//2.CD時間到統計名次發送獎勵積分(WEEK)與第一項不同步(應該會與期間內發送獎勵同步處理會由信件部分呼叫) [ 不做即時UI更新 ]
		//3.CD時間到,系統可以再次進行征戰
		
		//皆不處理public var _buildschedule:Buildschedule = null;此排程屬性 (PvpDayVary , PvpReward)
		
		//1.重刷戰鬥次數 (排程器)(CYCLE)
		public function SetPvpDayVary(vary:PvpDayVary):void 
		{
			if (!this._operator.Initialize) return;//PVP運作前就通知 可忽略
			
			//目前做法 重開視窗重拿InitData才會有變化
			this.PvpFightTimes = vary._fightTimes;
			
		}
		
		//2.發送獎勵品更新(排程器)(CYCLE) [UI點選領取]
		public function SetPvpReward(reward:PvpReward):void 
		{
			if (!this._operator.Initialize) return;//PVP運作前就通知 可忽略
			
			//獎勵處理 視需求發送通知
			//目前做法 重開視窗重拿InitData才會有變化
			this._operator.Reward = reward;
		}
		
		//3.CD完成系統可以再次進行征戰 (排程器)
		public function SetPvpFightable():void 
		{
			if (!this._operator.Initialize) return;//PVP運作前就通知 可忽略
			
			this._operator.DataValue("_isCD", false);
		}
		//==========================================================================
		
		
		//重置戰鬥次數(商店晶鑽 or 重置時間到)
		public function set PvpFightTimes(times:int):void 
		{
			this._operator.DataValue("_fightTimes", times);
		}
		//重置最大限制次數(建築物升級)
		public function set UpgradeChangeLimit(limit:int):void 
		{
			this._operator.DataValue("_fightLimit", limit);
		}
		
		
		
		
	}
	

}

