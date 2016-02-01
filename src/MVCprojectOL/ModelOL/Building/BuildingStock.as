package MVCprojectOL.ModelOL.Building
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.PackageSys.PackageProxy;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.Vo.Building;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.Timers.TimeDriver;
	import strLib.proxyStr.BuildingStr;
	import strLib.proxyStr.ProxyMonsterStr;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.04.16.14.18
		@documentation 資料暫存庫
	 */
	public class BuildingStock 
	{
		
		private var _dicUser:Dictionary;//Search for VO
		private var _dicGuid:Dictionary;
		private var _arrUser:Array;//SERVER Back Source
		private var _vecUpgCD:Vector.<Building>;
		//private var _vecWorkCD:Vector.<Building>;
		//private var _getBuildUpgradeNum:int;
		//private var _initUpdate:Boolean;//確認初始的資料是否有需要向SERVER更新升級
		private var _dicFakeList:Dictionary;
		private const BUILDING_TIMELINE:String = "buildingTimeline";//當作timeline內的索引操作
		
		private var _countCheck:int;//當前計數量
		private const CHECK_LIMIT:int = 600;//滿額送測值
		
		public function BuildingStock():void
		{
			this._dicUser = new Dictionary(true);
			this._dicFakeList = new Dictionary(true);
			this._dicGuid = new Dictionary(true);
		}
		
		//==============================================================		↓SERVER回傳資料處理
		
		//初始化建築資料處理
		public function ConnectBackList(source:Array,key:String="_guid"):void
		{
			this._arrUser = source;
			var long:int = source.length;
			var data:Object;
			for (var i:int = 0; i < long; i++)
			{
				data = source[i];
				this._dicUser[data[key]] = data;
				this._dicGuid[data["_type"]] = data["_guid"];
			}
			
			//
			//this.checkOutCD();//整合後會拔掉計時處理
			
			//this.checkCallUpgradeFinCD();//篩選是否有升級建築物尚未更新資料的狀態 ( status == 1   &&   currentCD == 0  )//整合後會拔掉計時處理
			
			//讀取資料回來發送完成通知
			//if (!this._initUpdate) BuildingProxy.GetInstance().SendNotify(BuildingStr.BUILDING_READY);//可夾可不夾this.CloneList()
			BuildingProxy.GetInstance().SendNotify(BuildingStr.BUILDING_READY);
		}
		
		//建築物升級取得單筆建築物資訊VO判斷操作(Proxy處理回傳處)
		//public function BuildingUpgradeBack(VO:BuildingUpgrade):void 
		//{
			//if (this._getBuildUpgradeNum > 0) {
				//this._getBuildUpgradeNum--;
				//if (this._getBuildUpgradeNum == 0) {
					//this._initUpdate = false;
					//BuildingProxy.GetInstance().SendNotify(BuildingStr.BUILDING_READY);//可夾可不夾this.CloneList()
				//}
			//}
			//
			//if (VO._error != 0) {
				//建築物取得升級資訊時錯誤需做相對應的錯誤碼處理(若錯誤狀況無包含資料則重拿資料)
				//
				//MessageTool.InputMessageKey(VO._error);
			//}
			//
			//if (VO._CD == 0) {
				//if (VO._build != null) {
					//回傳成功正常資料
					//this.UpdateBuilding(VO._build);
				//}else {
					//MessageTool.InputMessageKey(003);//SERVER回傳建築升級資訊不存在
				//}
			//}else {
				//倒數計時與SERVER不符合需再次計時
				//計時端整合後就不處理了
				//var build:Building = this._dicUser[VO._guid];
				//var index:int = this._vecUpgCD.indexOf(build);
				//if (index != -1) {
					//Building(this._vecUpgCD[index])._currentUpCD = VO._CD;
				//}else {//起始檢測升級倒數終了的建築物STATUS=1 狀態下重新GET的情況
					//this._vecUpgCD[this._vecUpgCD.length] = build;
				//}
				//
			//}
			//
		//}
		
		//導入排程器的建築升級完成資料
		public function TimeLineUpgradeBack(vo:Building):void 
		{
			this.UpdateBuilding(vo);
		}
		
		//整合後無運作功能(升級會由TimeLineProxy同SERVER確認處理)
		//CLIENT當前資料確認可升級後同SERVER確認是否可升級 SERVER回傳>(Proxy處理回傳處)
		//public function CheckBuildingUpgrade(VO:CheckBuildUpgrade):void 
		//{
			//if (VO._error==0) {
				//整合後拔掉
				//this.doUpgradeProcess(this._dicUser[VO._guid]);//運行升級倒數動作//
				//
				//
			//}else {
				//CLIENT檢查可升級但SERVER判斷不可行時發送通知
				//BuildingProxy.GetInstance().SendNotify(BuildingStr.BUILDING_ERROR_UPGRADE + VO._guid , VO._error);
				//SERVER處理升級失敗錯誤碼處理
				//MessageTool.InputMessageKey(VO._error);
			//}
			//
		//}
		
		
		
		
		//==============================================================		↑SERVER回傳資料處理
		
		//20130617 改成無法升級與功能未開啟的不列入資料
		public function GetAllWithUpgrade():Array
		{
			var aryMixed:Array = this.GetUser() as Array;
			var leng:int = aryMixed.length;
			var build:Building;
			for (var i:int = leng-1; i >=0 ; i--) 
			{
				build = aryMixed[i];
				build._enable ? build._upgradable ? aryMixed[i] = { _building : build , _upgradable : this.UpgradeCheck(build._guid) } : aryMixed.splice(i, 1) : aryMixed.splice(i, 1);
			}
			return aryMixed;
		}
		
		
		//取得單資料物件或是資料清單
		public function GetUser(guid:String=""):Object
		{
			return guid != "" ? this.CloneInfo(guid) : this.CloneList();
		}
		
		//複製一份唯讀清單
		public function CloneList():Array
		{
			var clone:Array = [];
			var long:int = this._arrUser.length;
			for (var i:int = 0; i < long; i++) 
			{
				clone[i] = this.clone(this._arrUser[i]);
			}
			return clone;
		}
		
		//取得全建築物某簡易型屬性(複雜型未CLONE);
		public function GetAllParam(param:String):Array
		{
			var leng:int = this._arrUser.length;
			var aryBack:Array = [];
			for (var i:int = 0; i < leng; i++)
			{
				aryBack[i] = this._arrUser[i][param];
			}
			return aryBack;
		}
		
		public function GetParam(guid:String,param:String):Object
		{
			var build:Building = this._dicUser[guid];
			var unit:Object = build[param];
			return !(unit is Array) ? unit : this.complexClone(unit);
		}
		
		//複製一份唯讀的資料給外部操作
		public function CloneInfo(guid:String):Object
		{
			var info:Building = this._dicUser[guid];
			if (info != null) info = this.clone(info);
			return info;
		}
		
		//複製回新物件
		private function clone(source:Building):Building
		{
			var clone:Building = new Building();
			clone._guid = source._guid;
			clone._info = source._info;
			clone._type = source._type;
			clone._lv = source._lv;
			clone._name = source._name;
			clone._needUpCD = source._needUpCD;
			clone._picKey = source._picKey;
			clone._workLimit = source._workLimit;
			//clone._x = source._x;
			//clone._y = source._y;
			//clone._width = source._width;
			//clone._height = source._height;
			//clone._currentUpCD = source._currentUpCD;
			clone._status = source._status;
			clone._upgradable = source._upgradable;
			clone._enable = source._enable;
			clone._cost = source._cost;
			clone._fur = source._fur;
			clone._stone = source._stone;
			clone._wood = source._wood;
			clone._maxLv = source._maxLv;
			clone._gridLimit = source._gridLimit;
			clone._aryWorking = this.complexClone(source._aryWorking);
			return clone;
		}
		private function complexClone(source:Object):*
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return(myBA.readObject());
		}
		
		private function getBuilding(guid:String):Building
		{
			var build:Building = this._dicUser[guid];
			if (build != null) {
				return build;
			}else {
				MessageTool.InputMessageKey(002);//查無此建築物ID
				return null;
			}
		}
		
		public function getBuildingGuid(type:int):String
		{
			if (type in this._dicGuid) {
				return this._dicGuid[type];
			}else {
				MessageTool.InputMessageKey(009);//查無此type對照建築物
				return "";
			}
		}
		
		//=====================================================================↓資料回寫變更
		
		// 更改玩家建築物的參數
		public function SetValue(guid:String,param:String,value:Object):void
		{
			var obj:Building = this._dicUser[guid];
			if (obj == null) MessageTool.InputMessageKey(002);//建築物查無此Guid
			
			obj[param] = value;
		}
		
		public function SetWorkerLimit(guid:String,addLimit:uint):void
		{
			
			
			
		}
		
		//建築物升級更新單筆資料
		public function UpdateBuilding(value:Building):void
		{
			var long:int = this._arrUser.length;
			for (var i:int = 0; i < long ; i++)
			{
				if (this._arrUser[i]["_guid"] == value._guid) break;
			}
			this._arrUser[i].Destroy();
			this._arrUser[i] = value;
			
			//guid沒有變動的狀態下
			this._dicUser[value._guid] = value;
			
			
			//if(!this._initUpdate)BuildingProxy.GetInstance().SendNotify(BuildingStr.BUILDING_FIN_UPGRADE + value._guid, this.clone(value));
			//各系統的更新會在TimeLine通知
			//發送新的建築物資料訊號
			BuildingProxy.GetInstance().SendNotify(BuildingStr.BUILDING_FIN_UPGRADE, this.clone(value));
		}
		
		//=====================================================================↑資料回寫變更
		
		//升級運行與排程互斥 有一方另一方無法運作
		//確認是否達升級條件 與 條件達成時是否升級動作
		//需調用到"素材量條件"與"金錢量條件"
		//此處僅為CLIENT端檢查若確認要升級會發送SERVER確認,SERVER檢查錯誤則會發送錯誤通知
		//回傳的判斷值 ( 0 > 查無此建築 , 1 > 可升級 , 2 > 無升級制度 , 3 > 已達最高等級 , 4 > 有排程單位運作中 , 5 > 素材數量不足 , 6 > 建築正在升級中,7 > 建築物尚未開啟功能不能操作 )130617
		public function UpgradeCheck(guid:String ,doUpgrade:Boolean=false):int
		{
			var building:Building = this._dicUser[guid];
			if (building == null) {
				MessageTool.InputMessageKey(002);//建築物查無此GUID
				return 0;
			}
			if (!building._upgradable) return 2;
			if (!building._enable) return 7;//20130617
			if (building._maxLv == building._lv) return 3;
			if (!this.checkBuildingUpgrading(building._guid)) return 6;
			if (building._aryWorking.length != 0) return 4;//檢查當前掛載的排程量**********************************************************************
			
			//調用Proxy判斷金錢 & 各素材數量 (待確認是否寫回金錢素材消減量)****
			var check:int = 1;
			//building._material
			//building._materialNum
			//building._cost
			switch (true) 
			{
				case building._wood>PlayerDataCenter.PlayerWood:
				case building._fur>PlayerDataCenter.PlayerFur:
				case building._stone > PlayerDataCenter.PlayerStone:
				case building._cost>PlayerDataCenter.PlayerSoul:
					check = 5;
				break;
			}
			
			
			//trace("檢測升級", building._wood > PlayerDataCenter.PlayerWood, building._fur > PlayerDataCenter.PlayerFur, building._stone > PlayerDataCenter.PlayerStone, building._cost > PlayerDataCenter.PlayerSoul);
			//若符合條件且需要執行時
			if (doUpgrade && check==1 ) {
				//發送升級確認給SERVER//通知SERVER做計時起始動作//會由排程器那邊處理通知的動作
				//BuildingProxy.GetInstance().ConnectVO(new Set_BuildUpgrade(building._guid));
				//扣除消耗物資量
				if (building._wood > 0) PlayerDataCenter.addWood( -building._wood);
				if (building._fur > 0) PlayerDataCenter.addFur( -building._fur);
				if (building._stone> 0) PlayerDataCenter.addStone( -building._stone);
				if (building._cost> 0) PlayerDataCenter.addSoul( -building._cost);
				
				this.timeLineUpgrade(building);
			}
			return check;
		}
		
		//通知TimeLineProxy升級處理
		private function timeLineUpgrade(build:Building):void 
		{
			
			TimeLineProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.TIMELINE_PROXY)).AddTimeLine(this.BUILDING_TIMELINE, build._guid, ServerTimework.GetInstance().ServerTime, build._needUpCD,0,"build");
		}
		
		private function checkBuildingUpgrading(guid:String):Boolean
		{
			//false >> 升級中
			return (TimeLineProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.TIMELINE_PROXY)).CheckUpdataLine(guid));
		}
		
		//*****************整合後取消運作********************
		//檢測若玩家登入遊戲後之前升級的建築物倒數終了 需要向SERVER >Get_BuildUpgrade 才會有新的建築物等級資料
		//private function checkCallUpgradeFinCD():void 
		//{
			//var build:Building;
			//for (var i:int = 0; i < 8; i++)
			//{
				//build = this._arrUser[i];
				//if (build._status == 1 && build._currentUpCD == 0) {
					//this._getBuildUpgradeNum++;
					//BuildingProxy.GetInstance().ConnectVO(new Get_BuildUpgrade(build._guid));
				//}
			//}
		//}
		
		
		//=======================================================計時類↓
		
		//目前不處理(排程轉到排程器內處理)
		//SERVER確認可升級 ,  開始處理該建築物的升級倒數
		//private function doUpgradeProcess(building:Building):void
		//{
			//building._currentUpCD = building._needUpCD;
			//building._status = 1;//升級中狀態
			//this._vecUpgCD[this._vecUpgCD.length] = building;
			//trace("add in UpgCD");
			//this.checkDecreaseOperate();
		//}
		
		//通知SERVER的check起始排程會在各功能項目proxy處理這部分處理倒數計時與發送完成通知
		//加入惡魔單位運作排程 ( 確認過後排程類型都不做取消排程功能) 
		//public function AddWorker(guid:String,worker:String,CD:uint):Boolean
		//{
			//var build:Building = this._dicUser[guid];
			//if (this._vecWorkCD.indexOf(build) != -1) return false;//若升級中則無法進行排程
			//
			//if (build._aryWorking != null) {
				//build._aryWorking.push(worker, CD);
			//}else {
				//build._aryWorking = [worker, CD];
			//}
			//build._status = 2;//變更建築狀態為運作中
			//this._vecWorkCD[this._vecWorkCD.length] = build;
			//return true;
		//}
		
		//收到的GUID應該真真假假
		public function AddWorker(guid:String,worker:String):Boolean
		{
			var build:Building = this.getBuilding(guid);
			
			if (build != null) {
				
				//if (this._vecUpgCD.indexOf(build) != -1) return false;//若升級中則無法進行排程//改掉由TimeLineProxy檢查
				//TimeLineProxy >> true=閒置/false=進行//若升級中則無法進行排程
				if (TimeLineProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.TIMELINE_PROXY)).CheckUpdataLine(guid)) return false;
				
				if (build._aryWorking.length >= build._workLimit) return false;//若建築物當前的排程量已滿則回傳錯誤
				
				if (build._aryWorking != null) {
					if (build._aryWorking.indexOf(worker) == -1) {
						build._aryWorking.push(worker);
						this._dicFakeList[worker] = build;//記錄fake對應
					}
				}else {
					build._aryWorking = [worker];
					this._dicFakeList[worker] = build;//記錄fake對應
				}
				build._status = 2;//變更建築狀態為運作中
				return true;
			}
			return false;
			
		}
		public function FakeToRealWorker(fakeID:String,realID:String):void
		{
			if (fakeID in this._dicFakeList) {
				var build:Building = this._dicFakeList[fakeID];
				var index:int = build._aryWorking.indexOf(fakeID);
				build._aryWorking[index] = realID;
				delete this._dicFakeList[fakeID];
			}else {
				MessageTool.InputMessageKey(009);//查無此做假的排程ID
			}
			
		}
		public function CheckWorker(guid:String,workerID:String):Boolean 
		{
			var build:Building = this.getBuilding(guid);
			
			if (build != null) {
				if (build._aryWorking != null) {
					return build._aryWorking.indexOf(workerID) == -1 ? false : true;
				}
			}
			return false;
		}
		
		public function RemoveWorker(guid:String,worker:String):void 
		{
			var build:Building = this.getBuilding(guid);
			
			if (build != null) {
				var index:int = build._aryWorking.indexOf(worker);
				if (index != -1) {
					build._aryWorking.splice(worker, 1);
					if (build._aryWorking.length == 0) build._status = 0;
				}
				
				//若移除的為做假的ID
				if (worker in this._dicFakeList) delete this._dicFakeList[worker];
			}
			
		}
		//*****************整合後取消運作********************
		//初始檢測整筆資料是否有升級中倒數
		//private function checkOutCD():void
		//{
			//this._vecUpgCD = new Vector.<Building>();
			//this._vecWorkCD = new Vector.<Building>();
			//var long:int = this._arrUser.length;
			//var building:Building;
			//for (var i:int = 0; i < long ; i++)
			//{
				//building = this._arrUser[i];
				//if (building._currentUpCD > 0) this._vecUpgCD[this._vecUpgCD.length] = building;
				//if (building._aryWorking != null) {
					//if (building._aryWorking.length > 0) this._vecWorkCD[this._vecWorkCD.length] = building;
				//}
			//}
			//
			//this.checkDecreaseOperate();
		//}
		//*****************整合後取消運作********************
		//確認開關倒數計時驅動
		//private function checkDecreaseOperate():void
		//{
			//if (this._vecUpgCD.length > 0 ){//|| this._vecWorkCD.length>0 ) {
				//if (!TimeDriver.CheckRegister(this.decreaseCD)) TimeDriver.AddDrive(1010, 0, this.decreaseCD);
				//trace("adddrive");
			//}else {
				//if (TimeDriver.CheckRegister(this.decreaseCD)) TimeDriver.RemoveDrive(this.decreaseCD);
				//trace("removedrive");
			//}
		//}
		//*****************整合後取消運作********************
		//加速升級倒數進行 若秒數為0則直接完成
		public function QuickenUpgrade(guid:String,seconds:uint=0):void
		{
			//var build:Building = this._dicUser[guid];
			//var margin:int = build._currentUpCD - seconds;
			//
			//if (margin > 0 && seconds!=0 ) {
				//build._currentUpCD = margin;
			//}else {//倒數完成可升級
				//build._currentUpCD = 0;
				//會由遞減區塊進行通知處理
			//}
			
			//會改去通知TimeLineProxy加速操作********************************
			
		}
		
		//加速排程倒數進行 若秒數為0則直接完成
		//public function QuickenWorking(guid:String,worker:String,seconds:uint=0):void
		//{
			//var build:Building = this._dicUser[guid];
			//var index:int = build._aryWorking.indexOf(worker);
			//var margin:int = build._aryWorking[index + 1] - seconds;
			//if (margin > 0 && seconds != 0) {
				//build._aryWorking[index + 1] = margin;
			//}else {//排程終了處理
				//build._aryWorking[index + 1] = 0;
				//會由遞減區塊進行通知處理
			//}
		//}
		//*****************整合後取消運作********************
		//遞減倒數秒數
		//private function decreaseCD():void
		//{
			//this.decreaseUpdate();
			//this.decreaseWorking();
			//發送遞減時機通知
			//BuildingProxy.GetInstance().SendNotify(BuildingStr.BUILDING_TIMER);
		//}
		//*****************整合後取消運作********************
		//升級單位的倒數
		//private function decreaseUpdate():void 
		//{
			//var long:int = this._vecUpgCD.length;
			//var building:Building;
			//for (var i:int = long-1 ; i >= 0; i--)
			//{
				//building = this._vecUpgCD[i];
				//if (building._currentUpCD > 0) {
					//building._currentUpCD --;
					//trace(building._guid, building._currentUpCD);
				//}else {
					//this._vecUpgCD.splice(i, 1);
					//this.checkDecreaseOperate();
					//升級終了-需寫相對應的狀態/但會跟SERVER拿新建築資料故先不在本機做更改
					//BuildingProxy.GetInstance().ConnectVO(new Get_BuildUpgrade(building._guid));
				//}
			//}
			//this.autoServerCheck();//自動檢查計量
		//}
		
		//*****************整合後取消運作********************
		//累積達到某個時間 向SERVER發送檢測訊號
		//private function autoServerCheck():void 
		//{
			//if (this._countCheck < this.CHECK_LIMIT) {
				//this._countCheck++;
			//}else {
				//var leng:int = this._vecUpgCD.length;
				//var build:Building;
				//for (var i:int = 0; i < leng; i++) 
				//{
					//build = this._vecUpgCD[i];
					//剩餘時間大於一分鐘的做SERVER確認處理(可調整)
					//if (build._currentUpCD > 60) BuildingProxy.GetInstance().ConnectVO(new Get_BuildUpgrade(build._guid));
				//}
			//}
			
		//}
		//排程單位的倒數
		//private function decreaseWorking():void
		//{
			//var leng:int = this._vecWorkCD.length;
			//var workLeng:int;
			//var arrCheck:Array;
			//
			//for (var i:int = leng-1; i >= 0 ; i--)
			//{
				//arrCheck = this._vecWorkCD[i]._aryWorking;
				//workLeng = arrCheck.length;
				//for (var j:int = workLeng-1 ; j >= 0 ; j-=2)
				//{
					//if (arrCheck[j] > 0) {
						//arrCheck[j]--;
						//trace("work", arrCheck[j]);
					//}else {
						//通知外部排程單位倒數計時終了 //外部後續處理與SERVER確認相關新數值動作等等
						//BuildingProxy.GetInstance().SendNotify(BuildingStr.BUILDING_FIN_WORK + this._vecWorkCD[i]._guid, arrCheck[j - 1]);
						//arrCheck.splice(j - 1, 2);
						//if (arrCheck.length == 0) {
							//Building(this._vecWorkCD.splice(i, 1)[0])._status = 0;//排程終了轉為閒置狀態
							//this.checkDecreaseOperate();
						//}
					//}
				//}
			//}
		//}
		
		//=======================================================計時類↑
		
		//檢測是否尚有空間可貯藏
		//type 1=Source , 2=stone , 3=weapon , 4=shield , 5=accessories , 6=monster
		public function CheckStockpile(type:int):Boolean
		{
			var checkStr:String="";
			switch (type) 
			{
				case 1:checkStr = PlaySystemStrLab.Package_Source; break;
				case 2:checkStr = PlaySystemStrLab.Package_Stone; break;
				case 3:checkStr = PlaySystemStrLab.Package_Weapon; break;
				case 4:checkStr = PlaySystemStrLab.Package_Shield; break;
				case 5:checkStr = PlaySystemStrLab.Package_Accessories; break;
			}
			
			var currentAmount:int = checkStr != "" ? PackageProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.PACKAGE_PROXY)).GetSingleNumber(checkStr) : MonsterProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyMonsterStr.MONSTER_PROXY)).GetMonsterNumber();
			var gridLimit:int = this.GetParam(this.getBuildingGuid(checkStr != "" ? 5 : 2), "_gridLimit") as int;
			trace("取得的數量檢測", currentAmount, gridLimit);
			return currentAmount < gridLimit ? true : false;
		}
		
		
		
	}
	
}