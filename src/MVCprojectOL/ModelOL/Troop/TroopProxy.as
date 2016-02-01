package MVCprojectOL.ModelOL.Troop
{
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Vo.EditTroop;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Troop;
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
	import strLib.proxyStr.TroopStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.05.03.16.14
		@documentation 組隊資料層
	 */
	public class TroopProxy extends ProxY
	{
		
		private static var _troopProxy:TroopProxy;
		private var _camp:TroopCamp;
		private var _hasData:Boolean = false;
		private var _SetBackRequire:int =0;//需要等待Set VO回來的數量
		
		public function TroopProxy(registerName:String,key:TroopKey):void 
		{
			super(registerName, this);
			
			if (TroopProxy._troopProxy != null || key==null) {
				throw new Error("TroopProxy can't be constructed");
			}
			this._camp = new TroopCamp();
			TroopProxy._troopProxy = this;
			//初始註冊連線監聽
			EventExpress.AddEventRequest(NetEvent.NetResult, this.ConnectBack, this);
		}
		
		public static function GetInstance():TroopProxy 
		{
			if (TroopProxy._troopProxy == null) TroopProxy._troopProxy = new TroopProxy(TroopStr.TROOP_SYSTEM,new TroopKey());
			return TroopProxy._troopProxy;
		}
		
		//============================================Link↓
		
		//取得初始資料
		public function ConnectData():void
		{
			if (!this._hasData) {//初次介面撈取資料
				this.ConnectCall(new Get_Troop());
				this._hasData = true;
			}else {
				//已有資料且無等待回收SET資料時發送資料完成處理通知
				//if (this._SetBackRequire == 0) 
				this.SendNotify(TroopStr.TROOP_READY);
				//trace("發送組隊資料SERVER完成");
			}
			
		}
		
		//處理隊伍成員變更 //已改為VO group Call方式
		public function ConnectSetTroop(value:Set_Troop):void 
		{
			//this.ConnectCall(value);
			//Set VO 加入VO囤貨區
			this._SetBackRequire++;
			AmfConnector.GetInstance().VoCallGroup(value,true);
			//----2013/3/8---暫時更動
			//AmfConnector.GetInstance().VoCall(value);
		}
		
		//統一呼叫位置
		private function ConnectCall(VO:Object):void
		{
			AmfConnector.GetInstance().VoCall(VO);
			//trace("send to SERVER" , VO);
		}
		//統一回接位置
		private function ConnectBack(e:EventExpressPackage):void
		{
			//this._camp.WriteTroopData 	//初始
			//this._camp.EditTroopData			//既有隊伍
			//this._camp.RebackNewTroop	//新創隊伍
			//trace("dataBack",e);
			
			
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
					this._hasData = true;
				break;
				case "NewTroop" ://新創建隊伍時 (隊伍成員變更) SERVER回傳確認資料 ( Set_Troop )
					//this._camp.RebackNewTroop(content as NewTroop);
					//this.decreaseRequire();
				break;
				case "EditTroop" ://編輯既有隊伍時 (隊伍成員變更) SERVER回傳確認資料 ( Set_Troop )
					//this._camp.EditTroopData(content as EditTroop);
					//this.decreaseRequire();
				break;
			}
			
		}
		//============================================Link↑
		
		//收到回傳SETVO後做數量檢查全部回歸則回寫真實隊伍ID並發送完成通知
		private function decreaseRequire():void 
		{
			this._SetBackRequire--;
			if (this._SetBackRequire == 0) {
				this.ReleaseToMonsterProxy(true);//回寫怪物真實的隊伍ID
				this.SendNotify(TroopStr.TROOP_READY);
			}
		}
		
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
		 * 取得玩家全部隊伍VO
		 */
		public function GetAllTroop():Array
		{
			return this._camp.GetAllTroop();
		}
		
		/**
		 * 取得該頁數隊伍資料列
		 * @param	amount 每頁數隊伍數量
		 * @param	page 取得的頁數
		 */
		public function GetTroopByPage(amount:int,page:int):Array
		{
			return this._camp.GetTroopPack(amount, page);
		}
		
		/**
		 * 編輯已有GUID隊伍後的資料回寫(不論清空與否)
		 * @param	guid 隊伍GUID
		 * @param	member 新編輯隊伍
		 */
		public function SetTroopMember(guid:String,member:Object):void 
		{
			this._camp.ReplaceMember(guid, member);
		}
		
		/**
		 * 新增隊伍(無擁有GUID)
		 * @param	member 新隊伍成員
		 */
		public function SetNewTroop(symbol:String,member:Object):void 
		{
			this._camp.AddTroop(symbol,member);
		}
		
		//每次操作完隊伍變更時做資料暫存
		public function SaveTeamChange(info:Object):void 
		{
			this._camp.SaveTeamChange(info);
		}
		
		//UI關閉的時候一次寫回全部暫存的怪物變更資料 >> 改成group發送後 會先回寫假的隊伍ID , 之後收到SET回傳會在複寫一次真實ID
		public function ReleaseToMonsterProxy(newTroopOnly:Boolean=false):void 
		{
			this._camp.ReleaseToMonsterData(newTroopOnly);
		}
		
		//確認是否為做假TEAM_ID 若"是" 則回傳正確對應的GUID "否" 則不變值回傳
		public function GetSymbolToGuid(symbol:String):String
		{
			return this._camp.GetSymbolToGuid(symbol);
		}
		
		//清除所有做假的暫存TEAM_ID ( UI關閉時會清除一次 )
		public function WashAllSymbol():void 
		{
			this._camp.WashAllSymbol();
		}
		
		
		/**
		 * 刪除惡魔時隊伍清單的調整動作 (溶解) (拍賣會先篩選掉選擇故不列入)
		 * @param	memberGuid 惡魔Guid
		 */
		public function DeleteMember(memberGuid:String):void 
		{
			this._camp.DeleteMember(memberGuid);
			//trace("I GOT I GOT THE MONSTER",memberGuid);
		}
		
		/**
		 * 隊伍 "戰鬥" / "探索" 終了回程之CD時間設置 (倒數完畢時會發出通知)
		 * @param	troopGuid 隊伍的GUID
		 * @param	CD 隊伍的CD時間
		 */
		//public function JoinTroopCD(troopGuid:String,CD:uint):void 
		//{
			//this._camp.JoinTroopCD(troopGuid, CD);
		//}
		
		/**
		 * 加快隊伍回歸時間或直接完成 (若達完成狀態會發出通知)
		 * @param	troopGuid 隊伍GUID
		 * @param	seconds 加快的秒數 /  0 為直接完成
		 */
		//public function QuickenTroopCD(troopGuid:String,seconds:uint):void 
		//{
			//this._camp.QuickenTroopCD(troopGuid, seconds);
		//}
		
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
		
		//變更出擊隊伍的各個成員狀態
		public function SetFightStatus(teamID:String):void
		{
			this._camp.SetTeamFight(teamID);
		}
		
		/**
		 * 取得當前隊伍分配的旗幟編號
		 */
		public function GetTeamFlagNum(teamID:String):int
		{
			return this._camp.GetTeamFlagNum(teamID);
		}
		
		/**
		 * 取得下一組隊伍需要採用的旗幟編號
		 */
		public function GetNextTeamFlag():int
		{
			return this._camp.GetNextFlagNum();
		}
		
		
		
		
		
	}
	
}

class TroopKey 
{
	
}