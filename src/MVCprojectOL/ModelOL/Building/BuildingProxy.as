package MVCprojectOL.ModelOL.Building
{
	import flash.utils.setInterval;
	import MVCprojectOL.ModelOL.Vo.Building;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Building;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.BuildingStr;
	
	
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.04.09.14.52
		@documentation 建築物類型基本資料屬性處理
	 */
	public class BuildingProxy  extends ProxY
	{
		
		private var _stock:BuildingStock;
		private static var _buildingProxy:BuildingProxy;
		private var _hasData:Boolean = false;
		
		
		public function BuildingProxy(registerName:String,key:BuildingKey):void
		{
			
			super(registerName, this);
			if (BuildingProxy._buildingProxy != null || key==null) {
				throw new Error("BuildingProxy can't be construct");
			}
			BuildingProxy._buildingProxy = this;
			this._stock = new BuildingStock();
			//連線包監聽處理
			EventExpress.AddEventRequest(NetEvent.NetResult , this.ConnectBack, this);
		}
		
		//取singleton位置
		public static function GetInstance():BuildingProxy
		{
			if (BuildingProxy._buildingProxy == null) BuildingProxy._buildingProxy = new BuildingProxy(BuildingStr.BUILDING_SYSTEM,new BuildingKey());
			return BuildingProxy._buildingProxy;
		}
		
		override public function onRegisteredProxy():void
		{
			this.ConnectData();
		}
		
		//初始取玩家全建築資料
		public function ConnectData():void
		{
			if (!this._hasData) {
				this.ConnectCall(new Get_Building());//發送初始拿取建築物清單
				this._hasData = true;
			}else {
				this.SendNotify(BuildingStr.BUILDING_READY);//可夾可不夾this._stock.CloneList()
			}
		}
		
		//取玩家升級更新建築資料(撈完需sendNotify通知升級新資訊);
		internal function ConnectVO(VO:Object):void
		{
			this.ConnectCall(VO);
		}
		
		//統一發出連線操控位置
		private function ConnectCall(value:Object,group:Boolean=false):void
		{
			!group ? AmfConnector.GetInstance().VoCall(value) : AmfConnector.GetInstance().VoCallGroup(value);//正常運作
			//AmfConnector.GetInstance().Call("value");//進入錯誤連線區塊
			//trace(value);
		}
		
		//各種資料回來後的處理
		private function ConnectBack(e:EventExpressPackage):void
		{
			trace("netback", e.Content, e.EventName, e.SenderSignature, e.Status, e.Type);
			var _str:String = e.SenderSignature;
			var content:Object = NetResultPack(e.Content) ._result;
			if (content == null) {
				MessageTool.InputMessageKey(001);//SERVER回傳資料為空
				return;
			}
			
			switch (e.Status)//VO class name
			{
				case "Building" ://初始化取得所有建築VO資料 ( Get_Building )
					var _ary:Array = content as Array;
					this._stock.ConnectBackList(_ary);
					
				break;
				case "BuildingUpgrade" ://升級倒數終了取得新建築物VO資料 ( Get_BuildUpgrade ) //收到排程器發送的更新資料
						//this._stock.BuildingUpgradeBack(content as BuildingUpgrade);
				break;
				case "CheckBuildUpgrade" ://玩家建築物升級 Notify & check ( Set_BuildUpgrade )//發送通知SERVER開始升級處理
					//this._stock.CheckBuildingUpgrade(content as CheckBuildUpgrade);
				break;
				
			}
			
		}
		//private function checkTimeUse():void 
		//{
			//trace("CD Building", this.GetBuildCD("BLD135400202971195"));
		//}
		
		//建築物升級的VO更新
		public function TimeLineUpgradeBack(build:Building):void 
		{
			this._stock.TimeLineUpgradeBack(build);
		}
		
		//---2013/3/14---eric---
		public function GetTipsFunction(_obj:Object):Building 
		{
			var _return:Building;
			if (_obj != null) _return = this.GetBuilding(_obj._guid);
			return _return;
		}
		
		
		//外部數值變更寫回資料庫
		/**
		 * 可回寫建築物資料
		 * @param	guid 建築物GUID
		 * @param	param 建築物屬性
		 * @param	value 屬性值
		 */
		public function SetBuildingData(guid:String,param:String,value:Object):void
		{
			this._stock.SetValue(guid, param, value);
		}
		
		//擴增建築物排程上限值*****需確認排程解鎖的條件是否各建築相似 同時VO須開新屬性來做擴增的判斷與素材的變化回寫
		public function ExtendWorkerLimit(guid:String,addLimit:uint):void
		{
			
			
			
		}
		
		/**
		 * 使建築變更為可操作狀態
		 * @param	guid 建築物GUID
		 */
		public function UnlockBuilding(guid:String):void
		{
			this._stock.SetValue(guid, "_enable", true);
		}
		
		//依ID取得建築物資料
		public function GetBuilding(guid:String):Building
		{
			var back:Building = this._stock.GetUser(guid)as Building;
			if (back == null) MessageTool.InputMessageKey(002);//查無此組建築物guid
			return back;
		}
		
		/**
		 * 依照種類取得建築物ID >> 1.大廳（魔法陣）, 2.巢穴 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室;
		 * @param	buildingType  建築物的種類
		 */
		public function GetBuildingGuid(buildingType:int):String
		{
			return this._stock.getBuildingGuid(buildingType);
		}
		
		/**
		 * 取得全建築物素材KEY值
		 */
		public function GetBuildingPicKey():Array 
		{
			return this._stock.GetAllParam("_picKey");
		}
		
		//取得庫存class
		public function GetBuildingStock():BuildingStock
		{
			return this._stock;
		}
		
		//取得建築等級
		public function GetBuildLV(guid:String):uint
		{
			return this._stock.GetParam(guid, "_lv") as uint;
		}
		
		/**
		 * 取得建築物類型1.大廳（魔法陣）, 2.巢穴 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室
		 */
		public function GetBuildType(guid:String):uint
		{
			return this._stock.GetParam(guid, "_type") as uint;
		}
		
		/**
		 * 建築物狀態( 0 閒置  /  1升級中  /  2建築功能運作中 )
		 */
		public function GetBuildStatus(guid:String):int
		{
			return this._stock.GetParam(guid, "_status") as int;
		}
		
		
		public function GetBuildUpgradable(guid:String):Boolean
		{
			return this._stock.GetParam(guid, "_upgradable");
		}
		
		
		public function GetBuildingEnable(guid:String):Boolean
		{
			return this._stock.GetParam(guid,"_enable");
		}
		
		/**
		 * 取得建築物排程清單
		 * @param	guid 建築物GUID
		 */
		public function GetBuildWorking(guid:String):Array
		{
			return this._stock.GetParam(guid, "_aryWorking") as Array;
		}
		
		
		//public function GetBuildCD(guid:String):uint
		//{
			//return this._stock.GetParam(guid, "_currentUpCD") as uint;
		//}
		
		
		public function GetBuildUpCD(guid:String):uint
		{
			return this._stock.GetParam(guid, "_needUpCD") as uint;
		}
		
		//取得升級所需素材
		/**
		 * 取得升級所需素材, 回傳Object { "_fur" ,  "_wood" , "_stone" , "_soul" >> 數量  }
		 * @param	guid 建築物GUID
		 */
		public function GetBuildMaterial(guid:String):Object
		{
			var combine:Object =
			{
				"_fur" : this._stock.GetParam(guid, "_fur"),
				"_wood" : this._stock.GetParam(guid, "_wood"),
				"_stone" : this._stock.GetParam(guid, "_stone"),
				"_soul" : this._stock.GetParam(guid, "_cost")
			};
			return combine;
		}
		
		public function GetBuildLineMax(guid:String):uint
		{
			
			return this._stock.GetParam(guid,"_workLimit") as uint;
		}
		
		//取得TIP字串
		public function GetBuildingInfo(guid:String):String
		{
			return this._stock.GetParam(guid, "_info") as String;
		}
		
		//取得格子數量上限>>>巢穴、儲藏室、牢房、英靈室 會用到
		public function GetBuildingGridLimit(guid:String):int
		{
			return this._stock.GetParam(guid, "_gridLimit") as int;
		}
		
		//取得下一等級格子數量上限>>>巢穴、儲藏室、牢房、英靈室 會用到
		public function GetBuildingNextGridLimit(guid:String):int
		{
			return this._stock.GetParam(guid, "_nextGridLimit") as int;
		}
		
		//取得建築物清單
		/**
		 * 取得所有建築物VO
		 */
		public function GetAllBuilding():Array
		{
			return this._stock.GetUser() as Array;
		}
		
		/**
		 * 取得全建築物VO與升級與否的判斷值 ( _building : (Building) Vo , _upgradable : ( 0 > 查無此建築 , 1 > 可升級 , 2 > 無升級制度 , 3 > 已達最高等級 , 4 > 有排程單位運作中 , 5 > 素材數量不足 ) )
		 */
		public function GetAllWithUpgrade():Array
		{
			return this._stock.GetAllWithUpgrade();
		}
		
		//內部依排程單位存在與否會做接換 應當用不太到外部修改
		//變更建築物運作狀態>> 閒置/運行中 切換 ( true > 轉為運作中 /  false > 轉為閒置 )
		//public function BuildingOperatingStatus(guid:String,isOperative:Boolean):void
		//{
			//this._stock.SetValue(guid, "_status", isOperative ? 2 : 0);
		//}
		
		
		//確認是否達升級條件 與 條件達成時是否升級動作
		/**
		 * 檢查是否達到建築物升級條件 , 若直接升級SERVER對應錯誤會發送通知 "BUILDING_ERROR_UPGRADE+建築物GUID " (夾帶SERVER建築物升級錯誤碼)//回傳的判斷值 ( 0 > 查無此建築 , 1 > 可升級 , 2 > 無升級制度 , 3 > 已達最高等級 , 4 > 有排程單位運作中 , 5 > 素材數量不足 )
		 * @param	guid 建築物GUID
		 * @param	doUpgrade 是否檢查通過直接升級
		 */
		public function CheckUpgradable(guid:String,doUpgrade:Boolean=false):int
		{
			return this._stock.UpgradeCheck(guid, doUpgrade);
		}
		
		//若與SERVER確認結果時間不同步可操作排程時差計時
		/**
		 *加入新排程 ( 會回傳 true 已加入 /   false 無法加入(建築物升級狀態中) 
		 * @param	guid 建築物ID
		 * @param	fakeWorker新增排程項目做假ID
		 */
		public function AddWorker(guid:String,fakeWorker:String):Boolean
		{
			return this._stock.AddWorker(guid, fakeWorker);
		}
		
		/**
		 * 替換做假的ID為真實ID
		 * @param	fakeID 做假ID
		 * @param	trueID 真實ID
		 */
		public function WorkerFakeIdChange(fakeID:String,trueID:String):void
		{
			this._stock.FakeToRealWorker(fakeID, trueID);
		}
		
		/**
		 * 檢測此排程編號是否在此建築物排程中
		 * @param	guid 建築物ID
		 * @param	workerID 排程ID
		 */
		public function CheckWorker(guid:String , workerID:String):Boolean 
		{
			return this._stock.CheckWorker(guid, workerID);
		}
		
		/**
		 * 移除既有排程記錄
		 * @param	guid 建築物ID
		 * @param	worker 移除的排程ID
		 */
		public function RemoveWorker(guid:String,worker:String):void
		{
			this._stock.RemoveWorker(guid, worker);
		}
		
		//加速惡魔排程
		/**
		 * 減少排程單位CD秒數 ( 加速 ) , 完成倒數後發送通知 "BUILDING_FIN_WORK+單位建築物GUID"  ( 夾帶完成倒數單位ID  ,  各Proxy部分需向SERVER銜接後續運行動作 )
		 * @param	guid 建築物GUID
		 * @param	worker 排程單位ID
		 * @param	seconds 減少的秒數量(零為直接完成) , 秒數大於現在CD時間也會當做直接完成發出通知
		 */
		//public function QuickenWorker(guid:String,worker:String,seconds:uint=0):void 
		//{
			//this._stock.QuickenWorking(guid, worker, seconds);
		//}
		
		//加速升級
		/**
		 * 減少建築物升級CD秒數 (加速) , 確認升級完成後發送通知 "BUILDING_FIN_UPGRADE+單位建築物GUID"  ( 夾帶最新建築物完整資料 )
		 * @param	guid 建築物GUID
		 * @param	seconds 減少的秒數量(零為直接完成) , 秒數大於現在CD時間也會當做直接完成發出通知
		 */
		//public function QuickenUpgrade(guid:String,seconds:uint=0):void 
		//{
			//this._stock.QuickenUpgrade(guid, seconds);
		//}
		
		
		/**
		 * 檢測是否尚有空間可貯藏
		 * @param	type 1=Source , 2=stone , 3=weapon , 4=shield , 5=accessories , 6=monster
		 */
		public function CheckStockpile(type:int):Boolean
		{
			return this._stock.CheckStockpile(type);
		}
		
		
		
	}
	
}

class BuildingKey 
{
	
	
}