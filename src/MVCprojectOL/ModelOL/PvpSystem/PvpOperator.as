package MVCprojectOL.ModelOL.PvpSystem
{
	import flash.utils.ByteArray;
	import MVCprojectOL.ModelOL.BattleImaging.BattleImagingProxy;
	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleResult;
	import MVCprojectOL.ModelOL.Vo.ItemDrop;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionBackReward;
	import MVCprojectOL.ModelOL.Vo.PlayerSource;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpCompetition;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpFightingReport;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpInitData;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpRankingUpdate;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpReward;
	import MVCprojectOL.ModelOL.Vo.Set.Set_PvpFighting;
	import Spark.Timers.TimeDriver;
	import strLib.GameSystemStrLib;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class PvpOperator 
	{
		private var _initData:PvpInitData;
		private var _initialize:Boolean = false;	//系統是否初始化
		private var _guid:String = "10";//建築物編號換GUID
		private var _goFight:Boolean = false;
		
		/*
		 * _buidID = "pvp"
		 * _buildType = 
		case -3: // PVP戰鬥歸零
		case -2: // PVP每日獎勵
		case 10: //PVP建築  PVP打輸CD
		 */
		
		
		private const TIMELINE_INDEX:String = "pvp";
		
		
		public function PvpOperator():void 
		{
			
		}
		
		//CLIENT 玩家資料 變更處理>>>>
		
		//目前收到的都會是PlayerSource****************************************************************NOTICE   20130517
		public function AwardDropProcess(award:Array):void 
		{
			if (award == null) return;
			if (award.length == 0) return ;
			
			var objPickout:Object = this.pickoutAward(award);
			//新增素材
			if (objPickout._source.length > 0) UserSourceCenter.GetUserSourceCenter().AddSource( objPickout._source );
			//新增裝備
			if(objPickout._equipment.length>0) EquipmentDataCenter.GetEquipment().AddEquipment( objPickout._equipment );
		}
		
		public function ItemDropProcess(itemDrop:ItemDrop):void 
		{
			if (itemDrop == null) return;
			
			var arySource:Array = [];
			
			for each (var item:PlayerSource in itemDrop._material) 
			{
				arySource.push(item);
			}
			
			UserSourceCenter.GetUserSourceCenter().AddSource( arySource );
		}
		//CLIENT 玩家資料 變更處理<<<<
		
		
		
		public function DecreaseFightingCount():void
		{
			this._initData._fightTimes--;
		}
		
		public function get FightTimes():int
		{
			return this._initData._fightTimes;
		}
		
		
		public function GetBattleResult(report:PvpFightingReport):BattleResult
		{
			return BattleImagingProxy.GetInstance().GetInfoContentWithData(report._battleReport);
		}
		
		//取得獎勵品ItemDisplay
		//會有一堆MissionBackReward 012346會對應PlayerSource
		//----0=木頭/1=石頭/2=皮毛/3=soul/--4素材/--5裝備/6道具/7怪獸/8.金鑽/9.魔晶石
		//目前收到的都會是PlayerSource****************************************************************NOTICE   20130517
		public function GetAwardDrop():Array
		{
			if (this._initData._reward == null) return [];
			var aryDrop:Array = this._initData._reward._rewardItem;
			var leng:int = aryDrop.length;
			var award:MissionBackReward;
			var aryBack:Array = [];
			for (var i:int = 0; i < leng; i++) 
			{
				award = aryDrop[i];
				aryBack[i] = new ItemDisplay(award._reward);
				//ItemDisplay(aryBack[i]).ShowContent();//TEST
				//ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).addChild(ItemDisplay(aryBack[i]).ItemIcon);
				//ItemDisplay(aryBack[i]).ItemIcon.x = Math.random() * 1000;
				//ItemDisplay(aryBack[i]).ItemIcon.y = Math.random() * 700;
			}
			return aryBack;
		}
		
		//目前收到的都會是PlayerSource****************************************************************NOTICE   20130517
		//預留做TYPE處理的分類(尚未操作)20130517
		private function pickoutAward(reward:Array):Object
		{
			var leng:int = reward.length;
			var award:MissionBackReward;
			var objDrop:Object = {_source:[] , _item : [] , _equipment : []};
			
			for (var i:int = 0; i < leng; i++) 
			{
				award = reward[i];
				switch (award._type) 
				{
					case 0:
					case 1:
					case 2:
					case 3:
					case 4:
					case 6:
						objDrop._source.push(award._reward);
					break;
					
					case 5:
						objDrop._equipment.push(award._reward);
					break;
					
					case 7:
					case 8:
					case 9:
						
					break;
				}
			}
			
			return objDrop;
		}
		
		//槓掉的
		//public function GetAwardDrop():Array
		//{
			//return this._initData._reward != null ? BattleImagingProxy.GetInstance().GetItemDisplayMixed(this._initData._reward._rewardItem._material) : [];
		//}
		
		//取得預設隊伍ItemDisplay
		public function GetCrewDisplay():Object
		{
			var objMember:Object = CrewProxy.GetInstance().GetDefaultCrewMember(0);
			var monsterCenter:PlayerMonsterDataCenter = PlayerMonsterDataCenter.GetMonsterData();
			var objData:Object;
			for (var name:String in objMember) 
			{
				objData = monsterCenter.GetSingleMonster(objMember[name]);
				objData._picItem = monsterCenter.getSinglePicItem(objMember[name]);
				objMember[name] = this.getItemDisplay(objData);
			}
			return objMember;
		}
		
		//素材準備 在原有Competition隊伍成員 與 陣營資料內 加入顯示素材
		public function DisplayMixed(update:PvpRankingUpdate):void 
		{
			var competition:PvpCompetition;
			var leng:int = update._aryRankBoard.length;
			for (var i:int = 0; i < leng; i++) 
			{
				competition = update._aryRankBoard[i];
				for (var item:String in competition._objMember) 
				{
					competition._objMember[item] = this.getItemDisplay(competition._objMember[item]);
				}
				competition._objFaction = this.getItemDisplay(competition._objFaction);
			}
		}
		
		private function getItemDisplay(objData:Object):ItemDisplay
		{
			return new ItemDisplay(objData);
		}
		
		//取得出征供SERVER判斷的資料包
		public function GetFightCheckData(playerId:String):Set_PvpFighting
		{
			var leng:int = this._initData._rankingData._aryRankBoard.length;
			var competition:PvpCompetition;
			for (var i:int = 0; i < leng; i++) 
			{
				if (this._initData._rankingData._aryRankBoard[i]._playerId == playerId) {
					competition = this._initData._rankingData._aryRankBoard[i];
					break;
				}
			}
			
			if (competition == null) {
				trace("輸入的PVP對手ID不存在");
				return null;
			}
			
			//只篩選出怪物的位置對應其GUID
			var objMem:Object = { };
			for (var name:String in competition._objMember) 
			{
				objMem[name] = competition._objMember[name]._guid;
			}
			
			return new Set_PvpFighting(CrewProxy.GetInstance().GetDefaultCrewID(0),competition._playerId,competition._place,objMem); 
		}
		
		//-1 = 輸入type錯誤 , 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中 , 3 = 血量不足   ,   4 = 可用出擊次數不足  ,  5 = PVP戰敗系統冷卻中 
		public function PvpSallyCheck():int
		{
			////回傳檢測值 -1 = 輸入type錯誤 , 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中 , 3 = 血量不足 (溶解跟拍賣不影響 有隊伍之下不可操作該些項目)
			var check:int = 0;//CrewProxy.GetInstance().CrewSallyCheck(0); //20130528 不做隊伍內成員的狀態判斷
			
			if (this._initData._fightTimes <= 0) return 4;
			if (this._initData._isCD) return 5;
			
			return check;
		}
		
		//取得最新的隊伍資訊
		private function renewCrewMember():void 
		{
			var objCrew:Object = CrewProxy.GetInstance().GetDefaultCrewShowMember(0);
			
			var competition:PvpCompetition = this._initData._rankingData.GetUserData();
			competition._objMember = objCrew;
			
		}
		
		public function get InitData():PvpInitData 
		{
			if (this._initData == null) return null;
			this.renewCrewMember();
			var cloneData:PvpInitData = new PvpInitData();
			cloneData._isCD = this._initData._isCD;
			cloneData._fightTimes = this._initData._fightTimes;
			cloneData._fightLimit = this._initData._fightLimit;
			cloneData._rankingData = this.cloneRankingUpdate(this._initData._rankingData);//see conditions to clone //and notice mixed display
			//cloneData._reward不處理 另外夾帶在初始訊號處有做素材組裝後的資料
			
			return cloneData;
		}
		
		public function cloneRankingUpdate(ranking:PvpRankingUpdate):PvpRankingUpdate 
		{
			var clone:PvpRankingUpdate = new PvpRankingUpdate();
			clone._aryRankBoard = [];
			var competition:PvpCompetition;
			var cloneCompetition:PvpCompetition;
			var leng:int = ranking._aryRankBoard.length;
			for (var i:int = 0; i < leng; i++) 
			{
				competition = ranking._aryRankBoard[i];
				cloneCompetition = new PvpCompetition();
				cloneCompetition._countPoint = competition._countPoint;
				cloneCompetition._name = competition._name;
				cloneCompetition._place = competition._place;
				cloneCompetition._playerId = competition._playerId;
				cloneCompetition._objFaction = this.complexClone(competition._objFaction);//object 可視狀況clone
				cloneCompetition._objMember = this.complexClone(competition._objMember);//object 可視狀況clone
				clone._aryRankBoard[i] = cloneCompetition;
			}
			this.DisplayMixed(clone);
			return clone;
		}
		private function complexClone(source:Object):*
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return(myBA.readObject());
		}
		
		public function CheckReward():Boolean
		{
			if (this._initData._reward != null) {
				this._initData._reward = null;
				return true;
			}
			return false;
		}
		
		public function set InitData(data:PvpInitData):void 
		{
			this._initData = data;
		}
		
		public function DataValue(param:String,value:Object):void 
		{
			this._initData[param] = value;
		}
		
		public function set RankingUpdate(data:PvpRankingUpdate):void
		{
			this._initData._rankingData = data;
		}
		
		public function set Reward(data:PvpReward):void 
		{
			this._initData._reward = data;
		}
		
		public function get Guid():String 
		{
			return this._guid;
		}
		
		public function set Guid(id:String):void 
		{
			this._guid = id;
		}
		
		public function get IsCD():Boolean
		{
			return this._initData._isCD;
		}
		
		public function get Initialize():Boolean 
		{
			return this._initialize;
		}
		
		public function set Initialize(init:Boolean):void 
		{
			this._initialize = init;
		}
		
		public function get GoFight():Boolean 
		{
			return this._goFight;
		}
		
		public function set GoFight(go:Boolean):void 
		{
			this._goFight = go;
		}
		
		
		
		
		
		
	}
	
}