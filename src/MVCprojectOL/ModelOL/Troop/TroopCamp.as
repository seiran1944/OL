package MVCprojectOL.ModelOL.Troop
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.Vo.EditTroop;
	import MVCprojectOL.ModelOL.Vo.NewTroop;
	import MVCprojectOL.ModelOL.Vo.Set.Set_Troop;
	import MVCprojectOL.ModelOL.Vo.Troop;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.Timers.TimeDriver;
	import strLib.proxyStr.ProxyMonsterStr;
	import strLib.proxyStr.TroopStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.12.18.10.30
		@documentation 組隊資料處理區塊
	 */
	public class TroopCamp 
	{
		private var _dicCamp:Dictionary;//隊伍查找用
		private var _dicSymbol:Dictionary;//替代隊伍ID使用
		private var _arrTroop:Array;//初始Troop VO資料
		//private var _vecCD:Vector.<Troop>;//計時用GROUP
		private var _aryTeamChange:Array;//累積的隊伍編輯資料
		
		private var _dicFlag:Dictionary;//隊伍配對旗幟標記組
		private var _vecFlagUse:Vector.<int>;
		//private var _teamMax:int = 9 ;//最大隊伍數可調整由DATACENTER接
		
		
		
		public function TroopCamp():void
		{
			this._dicCamp = new Dictionary(true);
			this._dicSymbol = new Dictionary(true);
			this._dicFlag = new Dictionary(true);
			this._vecFlagUse = new Vector.<int>();
			//this._vecCD = new Vector.<Troop>();
			this._aryTeamChange = [];
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
					this._dicCamp[troop[key]] = troop;
				}
				//this.pickOutCD();
			}else {
				//trace("資料非陣列或為null");
			}
			//trace("發送組隊資料SERVER完成");
			//初始隊伍資料旗幟編號
			this.CheckFlagNeeded();
			//發送資料完成處理通知
			TroopProxy.GetInstance().SendNotify(TroopStr.TROOP_READY);
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
				
				//修改symbol寫回新的FlagDIC guid
				this.ReWriteGuid(newTroop._symbol, newTroop._guid);
				
				//寫回新的隊伍對應GUID
				this._dicSymbol[newTroop._symbol] = newTroop._guid;
				
				
			}else {
				//錯誤碼通知
				//MessageTool.InputMessageKey(newTroop._error);
			}
			
		}
		
		
		//===================================================================↑SERVER資料處理
		
		
		//需要資料時取得真實GUID
		public function GetSymbolToGuid(symbol:String):String
		{
			//不存在暫存symbol中的應當是正確GUID 則回復傳送值
			return	symbol in this._dicSymbol ? this._dicSymbol[symbol] : symbol ;
		}
		
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
		
		//照頁數與單頁數量取得該頁資料
		public function GetTroopPack(amount:int=0,page:int=0):Array
		{
			var calculate:int = amount * page;
			var limit:int = amount == 0 ? this._arrTroop.length : calculate + amount;
			var arrPick:Array = [];
			var clone:Troop;
			for (var i:int = calculate; i < limit; i++)
			{
				//this.markingTired(clone);//檢測隊伍的疲勞值標記狀態
				clone = this.cloneTroop(this._arrTroop[i]);
				if (clone == null) break;
				arrPick[arrPick.length] = clone;
			}
			return arrPick.length == 0 ? null : arrPick;
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
				clone._backCD = troop._backCD;
				clone._status = troop._status;
				clone._flagNum = troop._flagNum;
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
					//this.checkCDProcess(troop);//檢測是否變更CD時間
				}else {
					MessageTool.InputMessageKey(003);//寫入屬性不存在
				}
			}else {
				MessageTool.InputMessageKey(002);//查無此guid
			}
		}
		
		//設置隊伍CD時間(設定倒數)
		//public function JoinTroopCD(guid:String,cd:uint):void
		//{
			//var tp:Troop = this._dicCamp[guid];
			//if (cd != 0) {
				//tp._backCD = cd;
				//tp._status = 1;
				//this._vecCD[this._vecCD.length] = tp;
				//this.CheckDecreaseOperate();
			//}else {//使用CD清除道具之類操作
				//MessageTool.InputMessageKey(004);//設置CD時間錯誤
			//}
		//}
		
		//加速倒數進行(減少的秒數 or  直接歸零> seconds = 0 ) 
		//public function QuickenTroopCD(guid:String,seconds:uint):void
		//{
			//var tp:Troop = this._dicCamp[guid];
			//var margin:int = tp._backCD - seconds;
			//if (seconds != 0 && margin>0) {//加速
				//tp._backCD = margin;
			//}else {//歸零
				//tp._backCD = 0;
				//this.DecreaseOnTime(tp);
			//}
		//}
		
		//成員整筆重置(既有隊伍重組)
		public function ReplaceMember(guid:String,member:Object):void
		{
			var troop:Troop = this._dicCamp[guid];
			//trace("team", guid, member);
			if (troop) {
				switch (this.checkMember(member)) 
				{
					case 2://成員空
						//已有隊伍GUID但成員刪除為空(SERVER 需注意須清除此GUID隊伍欄位)**************
						//Client移除該GUID對應並調整陣列空間
						delete this._dicCamp[guid];
						this._arrTroop.splice(this._arrTroop.indexOf(troop), 1);
						//TroopProxy.GetInstance().SendNotify(TroopStr.TROOP_SHIFT);//發送陣列位移通知若為顯示狀態需重領頁數隊伍
						
						//隊伍釋放掉後做旗幟編號的激活處理
						this.ReleaseFlag(guid);
						
						//回寫SERVER隊伍成員清除
						this.rebackServer(new Set_Troop(false, { }, "", guid));
					break;
					case 1://有成員
						troop._objMember = member;
						this.rebackServer(new Set_Troop(false,member, "",guid));
					break;
				}
			}else {
				MessageTool.InputMessageKey(002);//查無此guid隊伍
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
						//若刪除成員後檢測隊伍為空 沒成員存在 則發送陣列位移通知
						//if (this.checkMember(troop._objMember) == 2) TroopProxy.GetInstance().SendNotify(TroopStr.TROOP_SHIFT);
						return;
					}
				}
				MessageTool.InputMessageKey(005);//隊伍中查無此成員
				
			}else {
				MessageTool.InputMessageKey(002);//查無此guid隊伍
			}
		}
		
		//接收client新增的隊伍處理(新增隊伍)
		public function AddTroop(symbol:String,member:Object):void
		{
			if (this.checkMember(member) == 1) {//新增隊伍成員不為空且屬性型態正確下回傳SERVER
				//先製一份隊伍成員清單資料加入資料列 待SERVER回傳寫入後的GUID通知做更新動作
				var insteadTroop:Troop = new Troop();
				insteadTroop._guid = symbol;
				insteadTroop._objMember = member;
				insteadTroop._status = 0;
				insteadTroop._backCD = 0;
				this._arrTroop[this._arrTroop.length] = insteadTroop;
				this._dicCamp[insteadTroop._guid] = insteadTroop;
				
				//同時做flag的新增編號處理
				this.WriteFlag(symbol);
				
				//寫回SERVER的新隊伍資訊-夾帶辨識碼-
				var backTroop:Set_Troop = new Set_Troop(true,member,insteadTroop._guid);
				this.rebackServer(backTroop);
				
				//記錄symbol
				this._dicSymbol[symbol] = symbol;
			}
		}
		
		//清除當前暫存的所有symbol
		public function WashAllSymbol():void 
		{
			for (var name:String in this._dicSymbol) 
			{
				delete this._dicSymbol[name];
			}
		}
		
		
		//********************************************************旗幟處理
		//新增不同隊伍不同旗幟的標記處理 *****
		//初始隊伍資料中的旗幟編號
		public function CheckFlagNeeded():void
		{
			var countFlag:int = 0;
			var tp:Troop;
			//正常狀況不會有超過最大值隊伍的問題
			for (var name:String in this._dicCamp)
			{
				this._dicFlag[name] = countFlag;
				//trace(countFlag,"============-------------------------======================");
				//變更TROOP旗幟編號
				this.SetTroopFlag(name, countFlag);
				
				this._vecFlagUse[this._vecFlagUse.length] = countFlag;
				countFlag++;
			}
		}
		//寫入ID對應旗幟
		public function WriteFlag(teamID:String):void 
		{
			if (this.GetTeamFlagNum(teamID) == -1) {//確認為新的隊伍
				var newFlagNum:int = this.GetNextFlagNum();
				//新增入已用清單
				this._vecFlagUse[this._vecFlagUse.length] = newFlagNum;
				
				this._dicFlag[teamID] = newFlagNum;
				//變更TROOP旗幟編號
				this.SetTroopFlag(teamID, newFlagNum);
			}
		}
		//取代成真實的ID
		public function ReWriteGuid(symbol:String,teamID:String):void 
		{
			if (this.GetTeamFlagNum(symbol) != -1) {
				this._dicFlag[teamID] = this._dicFlag[symbol];
				delete this._dicFlag[symbol];
			}
		}
		//隊伍清空時旗幟編號回收使用
		public function ReleaseFlag(teamID:String):void 
		{
			if (teamID in this._dicFlag) {
				this._vecFlagUse.splice(this._vecFlagUse.indexOf(this._dicFlag[teamID]), 1);
				delete this._dicFlag[teamID];
				//移除隊伍旗幟編號
				this.SetTroopFlag(teamID, -1);
			}
		}
		//變更TROOP FLAG NUM
		public function SetTroopFlag(teamID:String,flagNum:int):void 
		{
			var tp:Troop = this.getRealTroop(teamID);
			if (tp != null) tp._flagNum = flagNum;
		}
		//取得預設編隊旗幟編號
		public function GetTeamFlagNum(teamID:String):int
		{
			//trace("組隊隊伍" + teamID , "旗幟編號為" + this._dicFlag[teamID]);
			return teamID in this._dicFlag ? this._dicFlag[teamID] : -1;
		}
		//取得下一新隊伍採用的編號
		public function GetNextFlagNum():int
		{
			var num:int = 0;
			while (this._vecFlagUse.indexOf(num)>= 0 )
			{
				num++;
			}
			return num;
		}
		//********************************************************旗幟處理
		
		
		
		//=====================================================================變更隊伍內容項目↑
		
		
		
		//CD單位篩選
		//private function pickOutCD():void 
		//{
			//var leng:int = this._arrTroop.length;
			//for (var i:int = 0; i < leng; i++)
			//{
				//this.checkCDProcess(this._arrTroop[i]);
			//}
			//this.CheckDecreaseOperate();
		//}
		//private function checkCDProcess(troop:Troop):void
		//{
			//if (troop._backCD > 0) this._vecCD[this._vecCD.length] = troop;
		//}
		
		
		
		//遞減驅動處理
		//private function CheckDecreaseOperate():void
		//{
			//if (this._vecCD.length > 0) {
				//if (!TimeDriver.CheckRegister(this.DecreaseOperating)) TimeDriver.AddDrive(1100, 0, this.DecreaseOperating);
			//}else {
				//if (TimeDriver.CheckRegister(this.DecreaseOperating)) TimeDriver.RemoveDrive(this.DecreaseOperating);
			//}
		//}
		//private function DecreaseOperating():void 
		//{
			//var cdLeng :int = this._vecCD.length;
			//var tp:Troop;
			//for (var i:int = cdLeng-1 ; i >= 0 ; i--)
			//{
				//tp = this._vecCD[i];
				//if (tp._backCD > 0) {
					//tp._backCD--;
				//}else {
					//this._vecCD.splice(i, 1);
					//this.DecreaseOnTime(tp);
				//}
			//}
		//}
		//CD時間歸零處理
		//private function DecreaseOnTime(tp:Troop):void 
		//{
			//this.CheckDecreaseOperate();
			//tp._status = 0;//變更了隊伍狀態***
			//TroopProxy.GetInstance().SendNotify(TroopStr.TROOP_IDLE, tp._guid);//計時時間到時發出閒置通知 (GUID)
		//}
		
		
		
		
		
		//檢測既有隊伍成員與新組成員的 新增/移除 隊伍屬性更新處理
		//private function OverlordInfoCheck(troopGuid:String,newMember:Object,oldMember:Object=null):void
		//{
			//if (oldMember != null) {
				//var arrOld:Array = [];
				//var index:int;
				//for each(var name:String in oldMember)
				//{
					//arrOld[arrOld.length] = name;
				//}
			//}
			//
			//for each(name in newMember) 
			//{
				//if (oldMember != null) {
					//index = arrOld.indexOf(name);
					//index > -1 ? arrOld.splice(index, 1) : this.OverlordInfoChange(name, troopGuid);
				//}else {
					//this.OverlordInfoChange(name, troopGuid);
				//}
			//}
			//
			//if (oldMember != null) {
				//var leng:int = arrOld.length;
				//for (var i:int = 0; i < leng; i++) 
				//{
					//this.OverlordInfoChange(arrOld[i]);
				//}
			//}
			//
		//}
		
		
		//=====================================================================與Proxy溝通項目↓
		
		//收集暫存隊伍變更資料
		public function SaveTeamChange(info:Object):void
		{
			this._aryTeamChange[this._aryTeamChange.length] = info;
		}
		//一次回寫MonsterProxy所有暫存資料>>加入groupSET之後 會先回寫monProxy假的ID(false)   /   之後才會觸發撈取新的ID(newTroopOnly = true)
		//關閉UI回寫一次(有隊伍ID的編輯成員,移除成員 / 新增隊伍的假ID)   ;   發送Set Group後的(有隊伍ID成員變更,新隊伍ID的假值替換)
		public function ReleaseToMonsterData(newTroopOnly:Boolean=false):void
		{
			//{ name:  /  current:  /  remove:  }
			var leng:int = this._aryTeamChange.length;
			var data:Object;
			var mp:MonsterProxy = ProjectOLFacade.GetFacadeOL().GetProxy(ProxyMonsterStr.MONSTER_PROXY) as MonsterProxy;
			for (var i:int = 0 ; i <leng; i++)
			{
				data = this._aryTeamChange[i];
				if (!newTroopOnly) this.doReleaseGroup("", data["remove"], mp);
				this.doReleaseGroup(data["name"] , data["current"], mp);
			}
			if (newTroopOnly) {
				this._aryTeamChange.length = 0;
				this.WashAllSymbol();
			}
		}
		//隊伍名稱,怪物名稱,monsterProxy
		private function doReleaseGroup(to:String,aryData:Array,proxy:MonsterProxy):void
		{
			var leng:int = aryData.length;
			var trueTeam:String = this.GetSymbolToGuid(to);
			for (var i:int = 0; i < leng; i++) 
			{
				proxy.SetMonsterTeam(aryData[i] , trueTeam);
				//trace("Monster>>><<<<>>>><<<<寫入的值變更", aryData[i], "----",trueTeam);//check yet
			}
			//trace("====================================================================");
		}
		
		
		//變更出擊隊伍的各個成員狀態 與 隊伍本身狀態
		public function SetTeamFight(teamID:String):void
		{
			var tp:Troop = this.GetTroop(teamID);
			
			for each (var oL:String in tp._objMember)
			{
				//回寫變更怪物的當前狀態為出戰
				//PlayerMonsterDataCenter.GetMonsterData().
				
				
			}
			
		}
		
		
		//檢測隊伍是否可以出擊(目前已有影響狀態為 惡魔的疲勞值 / CD時間 / 且非佔領中) >> 閒置中0 / 回程中 1 /  疲勞中 2*****************
		//public function SallyCheck(guid:String):int
		//{
			//var tp:Troop = this._dicCamp[guid];
			//if (tp._backCD > 0) return 1;
			//
			//this.markingTired(tp);//檢測隊伍疲勞值成員有過勞則隊伍狀態會變更為2
			//if (tp._status == 2) return 2;
			//
			//return 0;
		//}
		
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
		private function markingTired(tp:Troop):void 
		{
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
			
		}
		
		
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
		
		//寫回SERVER呼叫 (新增隊伍 與  編輯既有隊伍都會通過此處理)
		private function rebackServer(info:Set_Troop):void
		{
			TroopProxy.GetInstance().ConnectSetTroop(info);
		}
		
	}
	
}