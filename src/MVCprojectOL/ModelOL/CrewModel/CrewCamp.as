package MVCprojectOL.ModelOL.CrewModel
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.Vo.EditTroop;
	import MVCprojectOL.ModelOL.Vo.NewTroop;
	import MVCprojectOL.ModelOL.Vo.Set.Set_Troop;
	import MVCprojectOL.ModelOL.Vo.Set.Set_TroopDefault;
	import MVCprojectOL.ModelOL.Vo.Troop;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.ErrorsInfo.MessageTool;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyMonsterStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.05.03.14.50
		@documentation 組隊資料處理區塊
	 */
	public class CrewCamp 
	{
		
		private var _dicCamp:Dictionary;//隊伍查找用
		//private var _dicSymbol:Dictionary;//替代隊伍ID使用
		private var _arrTroop:Array;//初始Troop VO資料
		
		private var _vecDefaultCrew:Vector.<Troop>;//預設的PVP[0]  /  PVE[1]隊伍
		private var _aryCrew:Array;//照編號排列的對照
		private var _objChange:Object;
		
		
		public function CrewCamp():void
		{
			this._dicCamp = new Dictionary(true);
			//this._dicSymbol = new Dictionary();
			this._vecDefaultCrew = new Vector.<Troop>(2);
			this._aryCrew = [];
		}
		
		//===================================================================↓SERVER資料處理
		
		//初始SERVER資料匯入
		public function WriteTroopData(source:Array,key:String="_guid"):void
		{
			if (source is Array && source != null) {
				this._arrTroop = source;
				var leng:int = source.length;
				var troop:Troop;
				for (var i:int = 0; i < leng; i++)
				{
					troop = source[i];
					this._aryCrew[troop._teamNum] = troop;
					this._dicCamp[troop[key]] = troop;
					if (troop._isPvpTeam) this._vecDefaultCrew[0] = troop;
					if (troop._isPveTeam) this._vecDefaultCrew[1] = troop;
				}
			}else {
				trace("SERVER資料非陣列或為null");
			}
			//trace("發送組隊資料SERVER完成");
			//發送資料完成處理通知
			CrewProxy.GetInstance().SendNotify(ArchivesStr.CREW_READY);
		}
		
		//編輯既有隊伍SERVER回傳的確認狀態VO
		public function EditTroopData(VO:EditTroop):void
		{
			if (VO._error!=0) {//SERVER處理失敗時錯誤碼判定
				//發送錯誤碼通知
				//MessageTool.InputMessageKey(VO._error);
			}
		}
		
		//新增隊伍Server回傳的含guid資料寫回隊伍列
		public function RebackNewTroop(newTroop:NewTroop):void
		{
			if (newTroop._error == 0) {//成功新增隊伍
				
				var insteadTroop:Troop = this._dicCamp[newTroop._symbol];
				
				//修改symbol寫回新的TroopDIC guid
				delete this._dicCamp[newTroop._symbol];
				insteadTroop._guid = newTroop._guid;
				this._dicCamp[newTroop._guid] = insteadTroop;
				
				//更新給monsterProxy // symbol存了編號
				this._objChange._name = newTroop._guid;
				this.UpdateToMonsterProxy(this._objChange, int(newTroop._symbol));
				
				//通知VIEW可以往下操作
				CrewProxy.GetInstance().SendNotify(ArchivesStr.CREW_NEW_BACK);
				
			}else {
				//錯誤碼通知
				//MessageTool.InputMessageKey(newTroop._error);
			}
			
		}
		
		
		//===================================================================↑SERVER資料處理
		
		//取得隊伍編號
		public function GetTeamFlagNum(crewID:String):int
		{
			var tp:Troop = this.getRealTroop(crewID);
			return tp ? tp._teamNum : -1;
		}
		
		//取得預設隊伍編號
		public function GetDefaultCrewNum():Array
		{
			return [this._vecDefaultCrew[0]._teamNum, this._vecDefaultCrew[1]._teamNum];
		}
		
		//取得預設隊伍GUID
		public function GetDefaultCrew(type:int):String
		{
			return type > -1 && type < 3 ? this._vecDefaultCrew[type]._guid : "Type is over range";
		}
		
		//取得預設成員
		public function GetDefaultCrewMember(type:int):Object
		{
			return type > -1 && type < 3 ? this.complexClone(this._vecDefaultCrew[type]._objMember) : "Type is over range";
		}
		
		//組裝素材需要的資料
		public function GetDefaultCrewShowMember(type:int):Object
		{
			var objMemberID:Object = this._vecDefaultCrew[type]._objMember;
			
			var objGetMonster:Object;
			var objReback:Object={};
			for (var name:String in objMemberID) 
			{
				objGetMonster = PlayerMonsterDataCenter.GetMonsterData().GetSingleMonster(objMemberID[name]);
				objGetMonster._picItem = PlayerMonsterDataCenter.GetMonsterData().getSinglePicItem(objMemberID[name]);
				objReback[name] = {_guid : objGetMonster._guid ,_picItem : objGetMonster._picItem ,_showName : objGetMonster._showName };
			}
			
			return objReback;
		}
		
		//需要資料時取得真實GUID
		//public function GetSymbolToGuid(symbol:String):String
		//{
			//不存在暫存symbol中的應當是正確GUID 則回復傳送值
			//return	symbol in this._dicSymbol ? this._dicSymbol[symbol] : symbol ;
		//}
		
		private function getRealTroop(teamID:String):Troop
		{
			return teamID in this._dicCamp ? this._dicCamp[teamID] : null;
		}
		
		//依照ID取得該項隊伍資料
		public function GetTroop(guid:String):Troop 
		{
			return this.cloneTroop(this._dicCamp[guid]);
		}
		
		//依照ID取得該項隊伍資料
		public function GetMember(guid:String):Array
		{
			var tp:Troop = this._dicCamp[guid];
			
			if (tp != null) {
				var member:Array = [];
				for each (var ol:String in tp._objMember)
				{
					member[member.length] = ol;
				}
				return member;
			}else {
				return null;
			}
		}
		
		
		//不切頁取全隊伍
		public function GetAllTroop():Array
		{
			var leng:int = this._arrTroop.length;
			var aryClone:Array = [];
			for (var i:int = 0; i < leng; i++) 
			{
				aryClone[i] = this.cloneTroop(this._arrTroop[i]);
			}
			return aryClone;
		}
		//just clone
		private function cloneTroop(troop:Troop):Troop
		{
			if (troop != null) {
				var clone:Troop = new Troop();
				clone._guid = troop._guid;
				clone._status = troop._status;
				clone._isPveTeam = troop._isPveTeam;
				clone._isPvpTeam = troop._isPvpTeam;
				clone._teamNum = troop._teamNum;
				clone._objMember = this.complexClone(troop._objMember);
			}else {
				MessageTool.InputMessageKey(002);//查無此guid隊伍
			}
			
			return troop != null ? clone : null;
		}
		private function complexClone(source:Object):*
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return(myBA.readObject());
		}
		
		
		//=====================================================================變更隊伍內容項目↓
		
		//依照ID回寫變更資料內容 (用於隊伍成員外的屬性變更)-用不太到-預留
		public function WriteParam(guid:String,key:String,value:Object):void
		{
			var troop:Troop = this._dicCamp[guid];
			if (troop) {
				if (key in troop) {
					troop[key] = value;
				}else {
					MessageTool.InputMessageKey(003);//寫入屬性不存在
				}
			}else {
				MessageTool.InputMessageKey(002);//查無此guid
			}
		}
		
		
		public function SetCrewMember(num:int,objMember:Object):String
		{
			var tp:Troop = this._aryCrew[num];
			
			if (tp) {//edit troop
				
				switch (this.checkMember(objMember)) 
				{
					case 2://成員空
						//已有隊伍GUID但成員刪除為空(SERVER 需注意須清除此GUID隊伍欄位)**************
						//Client移除該GUID對應並調整陣列空間
						delete this._dicCamp[tp._guid];
						this._arrTroop.splice(this._arrTroop.indexOf(tp), 1);
						this._aryCrew[num] = null;
						
						//回寫SERVER隊伍成員清除
						this.rebackServer(new Set_Troop(false, { }, "", tp._guid, num));
						return "delete";
					break;
					case 1://有成員
						tp._objMember = objMember;
						this.rebackServer(new Set_Troop(false, objMember, "", tp._guid, num));
						return tp._guid;
					break;
				}
				//未關閉前重複編輯新隊伍 其GUID都會是symbol
				
			}else {//new troop
				
				if (this.checkMember(objMember) == 1) {//新增隊伍成員不為空且屬性型態正確下回傳SERVER
				//先製一份隊伍成員清單資料加入資料列 待SERVER回傳寫入後的GUID通知做更新動作
					var insteadTroop:Troop = new Troop();
					insteadTroop._guid =String(num);
					insteadTroop._objMember = objMember;
					insteadTroop._teamNum = num;
					insteadTroop._isPveTeam = false;
					insteadTroop._isPvpTeam = false;
					
					this._arrTroop[this._arrTroop.length] = insteadTroop;
					this._dicCamp[insteadTroop._guid] = insteadTroop;
					
					this._aryCrew[num] = insteadTroop;
					
					//寫回SERVER的新隊伍資訊-夾帶辨識碼-
					var backTroop:Set_Troop = new Set_Troop(true,objMember,insteadTroop._guid,"",num);
					this.rebackServer(backTroop);
					
					return insteadTroop._guid;
				}
				
			}
			
			return "";//新隊伍沒成員
		}
		
		
		//成員整筆重置(既有隊伍重組)
		//public function ReplaceMember(guid:String,member:Object):void
		//{
			//var troop:Troop = this._dicCamp[guid];
			//trace("team", guid, member);
			//if (troop) {
				//switch (this.checkMember(member)) 
				//{
					//case 2://成員空
						//已有隊伍GUID但成員刪除為空(SERVER 需注意須清除此GUID隊伍欄位)**************
						//Client移除該GUID對應並調整陣列空間
						//delete this._dicCamp[guid];
						//this._arrTroop.splice(this._arrTroop.indexOf(troop), 1);
						//
						//
						//回寫SERVER隊伍成員清除
						//this.rebackServer(new Set_Troop(false, { }, "", guid));
					//break;
					//case 1://有成員
						//troop._objMember = member;
						//this.rebackServer(new Set_Troop(false,member, "",guid));
					//break;
				//}
			//}else {
				//MessageTool.InputMessageKey(002);//查無此guid隊伍
			//}
		//}
		
		
		//接收client新增的隊伍處理(新增隊伍)
		//public function AddTroop(symbol:int,member:Object):void
		//{
			//if (this.checkMember(member) == 1) {//新增隊伍成員不為空且屬性型態正確下回傳SERVER
				//先製一份隊伍成員清單資料加入資料列 待SERVER回傳寫入後的GUID通知做更新動作
				//var insteadTroop:Troop = new Troop();
				//insteadTroop._guid = "fake"+String(symbol);
				//insteadTroop._objMember = member;
				//insteadTroop._status = 0;
				//insteadTroop._backCD = 0;
				//this._arrTroop[this._arrTroop.length] = insteadTroop;
				//this._dicCamp[insteadTroop._guid] = insteadTroop;
				//
				//
				//寫回SERVER的新隊伍資訊-夾帶辨識碼-
				//var backTroop:Set_Troop = new Set_Troop(true,member,insteadTroop._guid);
				//this.rebackServer(backTroop);
				//
				//記錄symbol
				//this._dicSymbol[symbol] = symbol;
			//}
		//}
		
		//發送SERVER通知 預設隊伍的設定變更
		public function ChangeDefaultCrew(num:int, isPvp:Boolean,isPve:Boolean):void 
		{
			var troop:Troop = this._aryCrew[num];
			if (troop) {
				var duo:Boolean = false;
				if (isPvp) {
					this._vecDefaultCrew[0]._isPvpTeam = false;
					this._vecDefaultCrew[0] = troop;
					troop._isPvpTeam = isPvp;
					if (this._vecDefaultCrew[1] == troop) duo = true;
				}
				if (isPve) {
					this._vecDefaultCrew[1]._isPveTeam = false;
					this._vecDefaultCrew[1] = troop;
					troop._isPveTeam = isPve;
					if (this._vecDefaultCrew[0] == troop) duo = true;
				}
				
				var setDefault:Set_TroopDefault = new Set_TroopDefault(troop._guid, duo? true : isPvp, duo ? true : isPve);
				this.rebackServer(setDefault);
			}
			
		}
		
		
		//刪除成員(某GUID怪物被溶解賣出之類的惡魔從召喚者擁有清單中消失的情況)//不列入清除惡魔隊伍資訊
		public function DeleteMember(memberGuid:String):void
		{
			var groupKey:String = PlayerMonsterDataCenter.GetMonsterData().GetMonsterTeam(memberGuid);
			if (groupKey == "") return;//空的>>沒隊伍
			
			var troop:Troop = this._dicCamp[groupKey];
			
			if (troop) {
				
				for (var name:String in troop._objMember) 
				{
					if (troop._objMember[name] == memberGuid) {
						delete troop._objMember[name];
						return;
					}
				}
				MessageTool.InputMessageKey(005);//隊伍中查無此成員
				
			}else {
				MessageTool.InputMessageKey(002);//查無此guid隊伍
			}
		}
		
		//清除當前暫存的所有symbol
		//public function WashAllSymbol():void 
		//{
			//for (var name:String in this._dicSymbol) 
			//{
				//delete this._dicSymbol[name];
			//}
		//}
		
		//=====================================================================變更隊伍內容項目↑
		
		
		
		//=====================================================================與Proxy溝通項目↓
		
		//new crew use
		//objChange = { _name : this._currentTroop._guid , _add: aryAdd , remove : aryRemove }
		public function UpdateToMonsterProxy(objChange:Object,num:int):void 
		{
			var mP:MonsterProxy = ProjectOLFacade.GetFacadeOL().GetProxy(ProxyMonsterStr.MONSTER_PROXY) as MonsterProxy;
			
			if (this._aryCrew[num]==null) {//new troop
				
				this._objChange = objChange;
				
			}else {//old troop
				
				this.releaseToMonsterProxy("", objChange._remove, mP);
				this.releaseToMonsterProxy(objChange._name, objChange._add, mP);
				
			}
			
		}
		private function releaseToMonsterProxy(changeTo:String,aryMember:Array,mP:MonsterProxy):void 
		{
			if (aryMember == null) return;
			var leng:int = aryMember.length;
			for (var i:int = 0; i < leng; i++) 
			{
				mP.SetMonsterTeam(aryMember[i] , changeTo);
			}
		}
		
		//既有隊伍在確認編輯後會立即回寫怪物資料
		//新增隊伍在編輯完成後關閉視窗時呼叫此方法做處理(順利之下SET的新隊伍資料會回來)
		//public function ReleaseNewCrewID():void 
		//{
			//var mP:MonsterProxy = ProjectOLFacade.GetFacadeOL().GetProxy(ProxyMonsterStr.MONSTER_PROXY) as MonsterProxy;
			//var leng:int = this._aryTeamChange.length;
			//var objChange:Object;
			//for (var i:int = 0; i < leng; i++)
			//{
				//objChange = this._aryTeamChange[i];
				//this.releaseToMonsterProxy("", objChange._remove, mP);
				//this.releaseToMonsterProxy(objChange._name, objChange._add, mP);
			//}
			//this._aryTeamChange.length = 0;
		//}
		
		//收集暫存隊伍變更資料
		//public function SaveTeamChange(info:Object):void
		//{
			//this._aryTeamChange[this._aryTeamChange.length] = info;
		//}
		//一次回寫MonsterProxy所有暫存資料>>加入groupSET之後 會先回寫monProxy假的ID(false)   /   之後才會觸發撈取新的ID(newTroopOnly = true)
		//關閉UI回寫一次(有隊伍ID的編輯成員,移除成員 / 新增隊伍的假ID)   ;   發送Set Group後的(有隊伍ID成員變更,新隊伍ID的假值替換)
		//public function ReleaseToMonsterData(newTroopOnly:Boolean=false):void
		//{
			//{ name:  /  current:  /  remove:  }
			//var leng:int = this._aryTeamChange.length;
			//var data:Object;
			//var mp:MonsterProxy = ProjectOLFacade.GetFacadeOL().GetProxy(ProxyMonsterStr.MONSTER_PROXY) as MonsterProxy;
			//for (var i:int = 0 ; i <leng; i++)
			//{
				//data = this._aryTeamChange[i];
				//if (!newTroopOnly) this.doReleaseGroup("", data["remove"], mp);
				//this.doReleaseGroup(data["name"] , data["current"], mp);
			//}
			//if (newTroopOnly) {
				//this._aryTeamChange.length = 0;
				//this.WashAllSymbol();
			//}
		//}
		//隊伍名稱,怪物名稱,monsterProxy
		//private function doReleaseGroup(to:String,aryData:Array,proxy:MonsterProxy):void
		//{
			//var leng:int = aryData.length;
			//var trueTeam:String = this.GetSymbolToGuid(to);
			//for (var i:int = 0; i < leng; i++) 
			//{
				//proxy.SetMonsterTeam(aryData[i] , trueTeam);
				//trace("Monster>>><<<<>>>><<<<寫入的值變更", aryData[i], "----",trueTeam);//check yet
			//}
			//trace("====================================================================");
		//}
		
		
		//20130523 新增PVP出擊不判斷怪物的疲勞值處理
		//回傳檢測值 -1 = 輸入type錯誤 , 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中 , 3 = 血量不足 (溶解跟拍賣不影響 有隊伍之下不可操作該些項目)
		public function SallyCheck(type:int):int
		{
			if (type > 1 || type < 0) return -1;
			
			if (type == 0) return 0;//20130528 PVP出擊不做成員的狀態檢查
			
			//基本上會正常取得Troop
			var check:int = 0;
			var tp:Troop = this._vecDefaultCrew[type];
			
			for each (var monsterID:String in tp._objMember) 
			{
				if (check == 0) {
					check = this.MemberStatusCheck(monsterID,type);
				}else {
					break;
				}
			}
			
			return check;
		}
		//20130523 新增PVP出擊不判斷怪物的疲勞值處理
		// 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中 , 3 = 血量不足
		public function MemberStatusCheck(monsterID:String,type:int):int
		{
			var mP:PlayerMonsterDataCenter = PlayerMonsterDataCenter.GetMonsterData();
			var check:int = 0;
			var objMonster:Object = mP.GetSingleMonster(monsterID);
			
			if (objMonster._nowEng >= objMonster._maxEng) check = 1; // PVP不檢查疲勞值狀態
			if (objMonster._nowHp <= 0) check = 3; // PVP不檢查血量狀態
			if (objMonster._useing == 3) check = 2;// PVP不檢查血量狀態
			
			return check;
		}
		
		//檢測是否此隊伍可以編輯操作
		//public function EditCheck(guid:String):Boolean
		//{
			//var tp:Troop = this._dicCamp[guid];
			//if (tp == null) {
				//MessageTool.InputMessageKey(002);//查無此guid
				//return false;
			//}
			//return tp._status != 1 ? true : false;
		//}
		
		
		//需調用惡魔資料面的proxy資料中的疲勞值與疲勞值限制量 並須先取得系統預設疲勞值限制上限
		//切換頁讀取隊伍資料時有一隻疲勞值到達則無法出擊
		//向惡魔Proxy檢查隊伍成員的疲勞值若有超過限度則變更隊伍狀態非CD狀態(1)時  寫入2 ( 疲勞) 反之則轉為 0 ( 閒置)
		//private function markingTired(tp:Troop):void 
		//{
			//var tiredLimit:int = 8 //PlayerDataCenter.MonsterExhaustLimit;
			//
			//for each (var key:String in tp._objMember)
			//{
				//if (something(key) >= somethingMaximum) {
					//tp._status = 2;
					//return;
				//}
				//
			//}
			//
		//}
		
		
		//=====================================================================與Proxy溝通項目↑
		
		
		
		
		//簡略除錯檢測內容型態// 0 > 型態錯誤 / 1 > 正常有值 / 2 > 空值
		private function checkMember(member:Object):int
		{
			
			var count:int=0;
			for (var place:* in member)
			{
				if (!(place is int) || !(member[place] is String)) {
					MessageTool.InputMessageKey(006);//錯誤的成員型態
					return 0;
				}
				count++;
			}
			return count > 0 ? 1 : 2;
		}
		
		//篩選若怪物隊伍不能選擇則排除清單中(別的隊伍中的狀態) 將保留本隊伍的編輯中怪物 與 可選擇的未組隊怪物 20130606
		public function PureCrewSorting(troopID:String , vecMember:Vector.<MonsterDisplay>):void 
		{
			var currentID:String;
			var leng:int = vecMember.length;
			for (var i:int = leng-1 ; i >= 0 ; i--) 
			{
				currentID = vecMember[i].MonsterData._teamGroup;
				if (currentID != "" && currentID != troopID) vecMember.splice(i, 1);
			}
		}
		
		//檢測是否沒有可以選擇的成員(有成員則開啟 TRUE 反之則否)
		public function CheckPureCrew(troopID:String , vecMember:Vector.<MonsterDisplay>):Boolean 
		{
			var currentID:String;
			var leng:int = vecMember.length;
			for (var i:int = 0; i < leng; i++) 
			{
				currentID = vecMember[i].MonsterData._teamGroup;
				if (currentID == "" || currentID == troopID) return true;
			}
			return false;
		}
		
		//(20130606)
		//{_monster , _teamGroup , _newMonster} / {_monster , _teamGroup}
		public function EvolutionCrewVary(mainMonster:Object,sacrificedMonster:Object):void
		{
			var tp:Troop = this.getRealTroop(mainMonster._teamGroup);
			if (tp) this.changeMonsterID(tp, mainMonster._monster, mainMonster._newMonster);
				
			if (sacrificedMonster != null) {
				tp = this.getRealTroop(sacrificedMonster._teamGroup);
				if (tp) this.changeMonsterID(tp, sacrificedMonster._monster);
			}
		}
		
		private function changeMonsterID(troop:Troop,originName:String,newName:String=""):void 
		{
			for (var place:String in troop._objMember) 
			{
				if (troop._objMember[place] == originName) {
					newName != "" ? troop._objMember[place] = newName : delete troop._objMember[place];
					break;
				}
			}
		}
		
		//寫回SERVER呼叫 (新增隊伍 與  編輯既有隊伍都會通過此處理) (Set_VO)
		private function rebackServer(info:Object):void
		{
			CrewProxy.GetInstance().ConnectSetTroop(info,this);
		}
		
		
		
	}
	
}