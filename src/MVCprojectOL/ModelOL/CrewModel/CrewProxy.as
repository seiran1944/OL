package MVCprojectOL.ModelOL.CrewModel
{
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.Vo.EditTroop;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Mission;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Troop;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionComplete;
	import MVCprojectOL.ModelOL.Vo.NewTroop;
	import MVCprojectOL.ModelOL.Vo.Set.Set_Troop;
	import MVCprojectOL.ModelOL.Vo.Troop;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyPVEStrList;
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.05.03.14.50
		@documentation 組隊資料層
	 */
	public class CrewProxy extends ProxY
	{
		
		private static var _crewProxy:CrewProxy;
		private var _amfConnector:AmfConnector;
		private var _camp:CrewCamp;
		private var _hasData:Boolean = false;
		
		public function CrewProxy(registerName:String):void 
		{
			super(registerName, this);
			
			if (CrewProxy._crewProxy != null) {
				throw new Error("CrewProxy can't be constructed");
			}
			this._amfConnector = AmfConnector.GetInstance();
			this._camp = new CrewCamp();
			CrewProxy._crewProxy = this;
			//初始註冊連線監聽
			EventExpress.AddEventRequest(NetEvent.NetResult, this.ConnectBack, this);
		}
		
		public static function GetInstance():CrewProxy
		{
			if (CrewProxy._crewProxy == null) CrewProxy._crewProxy = new CrewProxy(ArchivesStr.CREW_SYSTEM);
			return CrewProxy._crewProxy;
		}
		
		//============================================Link↓
		
		//取得初始資料
		public function ConnectData():void
		{
			if (!this._hasData) {//初次介面撈取資料
				this.ConnectCall(new Get_Troop());
				this._hasData = true;
			}else {
				this.SendNotify(ArchivesStr.CREW_READY);
				//trace("發送組隊資料SERVER完成");
			}
		}
		
		//處理隊伍成員變更 
		public function ConnectSetTroop(vo:Object , target:CrewCamp):void 
		{
			if (target != null) {
				this.ConnectCall(vo);
			}
		}
		
		//統一呼叫位置
		private function ConnectCall(VO:Object):void
		{
			this._amfConnector.VoCallGroup(VO);
			this.missionDataProcess(VO);
		}
		
		//多夾任務相關確認資料給SERVER處理
		private function missionDataProcess(VO:Object):void 
		{
			//可依照VO發送類型來判斷需要的TYPE
			var voName:String = getQualifiedClassName(VO);
			var index:int = voName.lastIndexOf(":") +1 ;
			voName = voName.substr(index, voName.length - index);
			
			if (voName == "Set_Troop") {
				var _missionHave:MissionConditionComplete= new MissionConditionComplete();
				_missionHave._missionType = ProxyPVEStrList.MISSION_Cal_MONSTER_TEAM;
				this._amfConnector.VoCallGroup(new Get_Mission([_missionHave]),true);
			}else {
				this._amfConnector.SendVoGroup();
			}
		}
		
		//統一回接位置
		private function ConnectBack(e:EventExpressPackage):void
		{
			//this._camp.WriteTroopData 	//初始
			//this._camp.EditTroopData			//既有隊伍
			//this._camp.RebackNewTroop	//新創隊伍
			
			
			var content:Object = NetResultPack(e.Content)._result;
			if (content == null ) {
				MessageTool.InputMessageKey(001);//SERVER回傳資料為空
				return;
			}
			
			//trace("檢測來源GUID", content[0]._guid);
			
			switch (e.Status)
			{
				case "Troop" ://初始取得玩家所有隊伍VO資料 ( Get_Troop )
					this._camp.WriteTroopData(content as Array);
				break;
				case "NewTroop" ://新創建隊伍時 (隊伍成員變更) SERVER回傳確認資料 ( Set_Troop )
					this._camp.RebackNewTroop(content as NewTroop);
				break;
				case "EditTroop" ://編輯既有隊伍時 (隊伍成員變更) SERVER回傳確認資料 ( Set_Troop )
					this._camp.EditTroopData(content as EditTroop);
				break;
			}
			
		}
		//============================================Link↑
		
		
		
		/**
		 * 隊伍ID取得隊伍資料
		 * @param	guid 隊伍GUID
		 */
		public function GetTroopByID(troopGuid:String):Troop
		{
			return this._camp.GetTroop(troopGuid);
		}
		
		/**
		 * 隊伍ID取得隊伍成員
		 * @param	troopGuid 隊伍GUID
		 */
		public function GetTroopMember(troopGuid:String):Array
		{
			return this._camp.GetMember(troopGuid);
		}
		
		
		/**
		 * 取得玩家全部隊伍VO Clone
		 */
		public function GetAllTroop():Array
		{
			return this._camp.GetAllTroop();
		}
		
		//New set use
		public function SetCrewMember(num:int, objMember:Object):String
		{
			return this._camp.SetCrewMember(num, objMember);
		}
		
		
		/**
		 * 編輯已有GUID隊伍後的資料回寫(不論清空與否)
		 * @param	guid 隊伍GUID
		 * @param	member 新編輯隊伍
		 */
		//public function SetTroopMember(guid:String,member:Object):void 
		//{
			//this._camp.ReplaceMember(guid, member);
		//}
		
		/**
		 * 新增隊伍(無擁有GUID)
		 * @param	member 新隊伍成員
		 */
		//public function SetNewTroop(symbol:int,member:Object):void 
		//{
			//this._camp.AddTroop(symbol,member);
		//}
		
		/**
		 * 變更PVP/PVE 預設隊伍 (僅既有隊伍可設置)
		 * @param	num 隊伍編號
		 * @param	isPvp 設定為PVP預設
		 * @param	isPve 設定為PVE預設
		 */
		public function SetDefaultCrew(num:int, isPvp:Boolean , isPve:Boolean):void 
		{
			this._camp.ChangeDefaultCrew(num, isPvp, isPve);
		}
		
		//寫新編資料進怪物DATA(既有隊伍回寫 / 新隊伍暫待ID回來 [搭配ReleaseNewCrewID] )
		public function UpdateToMonsterProxy(objChange:Object,num:int):void 
		{
			this._camp.UpdateToMonsterProxy(objChange,num);
		}
		
		//關閉最終CREW UI時回寫新隊伍的編輯成員TeamGroup
		//public function ReleaseAllNewCrewID():void 
		//{
			//this._camp.ReleaseNewCrewID();
		//}
		
		//每次操作完隊伍變更時做資料暫存
		//public function SaveTeamChange(info:Object):void 
		//{
			//this._camp.SaveTeamChange(info);
		//}
		
		//UI關閉的時候一次寫回全部暫存的怪物變更資料 >> 改成group發送後 會先回寫假的隊伍ID , 之後收到SET回傳會在複寫一次真實ID
		//public function ReleaseToMonsterProxy(newTroopOnly:Boolean=false):void 
		//{
			//this._camp.ReleaseToMonsterData(newTroopOnly);
		//}
		
		//確認是否為做假TEAM_ID 若"是" 則回傳正確對應的GUID "否" 則不變值回傳
		//public function GetSymbolToGuid(symbol:String):String
		//{
			//return this._camp.GetSymbolToGuid(symbol);
		//}
		
		//清除所有做假的暫存TEAM_ID ( UI關閉時會清除一次 )
		//public function WashAllSymbol():void 
		//{
			//this._camp.WashAllSymbol();
		//}
		
		
		/**
		 * 刪除惡魔時隊伍清單的調整動作 (有隊伍不能溶解 拍賣 可以學習)
		 * @param	memberGuid 惡魔Guid
		 */
		public function DeleteMember(memberGuid:String):void 
		{
			this._camp.DeleteMember(memberGuid);
			//trace("I GOT I GOT THE MONSTER",memberGuid);
		}
		
		
		
		/**
		 * 檢測隊伍是否  可操作 會回傳隊伍狀態 ( 閒置中0 / 回程中 1 /  疲勞中 2 )
		 * @param	troopGuid 隊伍GUID
		 */
		//public function SallyCheck(troopGuid:String):int
		//{
			//return this._camp.SallyCheck(troopGuid);
		//}
		
		/**
		 * 檢測隊伍是(true)  /  否(false)  可編輯
		 * @param	troopGuid 隊伍GUID
		 */
		//public function EditCheck(troopGuid:String):Boolean
		//{
			//return this._camp.EditCheck(troopGuid);
		//}
		
		/**
		 * 取得預設隊伍成員
		 * @param	type 0 >> pvP , 1 >> pvE
		 */
		public function GetDefaultCrewMember(type:int):Object
		{
			return this._camp.GetDefaultCrewMember(type);
		}
		
		/**
		 * PVP取得預設隊伍成員素材需要相關資料
		 * @param	type 0 >> pvP , 1 >> pvE 
		 */
		public function GetDefaultCrewShowMember(type:int):Object
		{
			return this._camp.GetDefaultCrewShowMember(type);
		}
		
		/**
		 *取得預設隊伍ID  
		 * @param	type 0 >> pvP , 1 >> pvE
		 */
		public function GetDefaultCrewID(type:int):String
		{
			return this._camp.GetDefaultCrew(type);
		}
		
		/**
		 * 檢測預設隊伍是否能出征 
		 * @param	type 0 >> pvP , 1 >> pvE
		 */
		public function CrewSallyCheck(type:int):int
		{
			return this._camp.SallyCheck(type);
		}
		
		/**
		 * 取得預設隊伍編號 預設的PVP[0]  /  PVE[1]隊伍
		 */
		public function GetDefaultCrewNum():Array
		{
			return this._camp.GetDefaultCrewNum();
		}
		
		/**
		 * 取得隊伍的編號
		 */
		public function GetTeamFlagNum(troopID:String):int
		{
			return this._camp.GetTeamFlagNum(troopID);
		}
		
		//篩選若怪物隊伍不能選擇則排除清單中(別的隊伍中的狀態) 將保留本隊伍的編輯中怪物 與 可選擇的未組隊怪物 20130606
		public function PureCrewSorting(troopID:String , vecMember:Vector.<MonsterDisplay>):void 
		{
			this._camp.PureCrewSorting(troopID, vecMember);
		}
		
		//檢測是否需要開啟頁面
		public function CheckPureCrew(troopID:String , vecMember:Vector.<MonsterDisplay>):Boolean
		{
			return this._camp.CheckPureCrew(troopID , vecMember);
		}
		
		//可以為舊的怪物ID或是隊伍位置來查找  ,  替換成新的怪物GUID   (20130606)
		//{_monster , _teamGroup , _newMonster} / {_monster , _teamGroup}
		public function EvolutionCrewVary(mainMonster:Object,sacrificedMonster:Object=null):void
		{
			//mainMonster = {_monster : "MOB137022563104529",_teamGroup : "GRP137085598143664",_newMonster : "test123456789000"}
			//sacrificedMonster = {_monster : "MOB137059692688815",_teamGroup : "GRP137049070208318"}
			this._camp.EvolutionCrewVary(mainMonster,sacrificedMonster);
		}
		
		
	}
	
}

