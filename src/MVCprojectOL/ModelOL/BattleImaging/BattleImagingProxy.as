package MVCprojectOL.ModelOL.BattleImaging
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.LoadingCache.MultiRemoteCache;
	import MVCprojectOL.ModelOL.LoadingCache.RemoteCache;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleBasic;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleEffect;
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldInit;
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldSteps;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleReport;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleResult;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleRound;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleRoundEffect;
	import MVCprojectOL.ModelOL.Vo.Get.Get_BattleHistorical;
	import MVCprojectOL.ModelOL.Vo.Get.Get_BattleInfoList;
	import MVCprojectOL.ModelOL.Vo.Get.Get_BattleInfoList_Design;
	import MVCprojectOL.ModelOL.Vo.Get.Get_BattleInit;
	import MVCprojectOL.ModelOL.Vo.Get.Get_BattleInit_Design;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ArchivesStr;
	import flash.system.Security;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.03.07.17.30
		@documentation 戰場歷史記錄 & 播放器
	 */
	public class BattleImagingProxy extends ProxY
	{
		
		private static var _battleImaging:BattleImagingProxy;
		//戰場 / 探索流程與企劃版本用參數
		private var _manager:BattleManager;
		private var _isPlaying:Boolean = false;
		private var _isPause:Boolean;
		private var _needPauseNotify:String;
		private var _dataReady:Boolean;
		private var _needCount:int;//需要預先載入的UI數量
		private const _uiKey:String = "GUI00010_ANI";
		private const GAME_MODE:Boolean = true;//是否為遊戲模式true  >>企劃模式(false)
		//戰鬥日誌相關參數
		private var _dicBattleInit:Dictionary;
		private var _materialPlant:BattleMaterialPlant;//素材組裝廠
		
		
		
		public function BattleImagingProxy(name:String , key:BIPKey):void
		{
			super(name, this);
			if (BattleImagingProxy._battleImaging != null || key == null) throw new Error("Singleton");
			BattleImagingProxy._battleImaging = this;
			
			this._manager = new BattleManager();
			this._materialPlant = new BattleMaterialPlant();
			this._dicBattleInit = new Dictionary ();
			EventExpress.AddEventRequest(NetEvent.NetResult , this.historicalBack, this);
		}
		
		
		public static function GetInstance():BattleImagingProxy
		{
			if (BattleImagingProxy._battleImaging == null) BattleImagingProxy._battleImaging = new BattleImagingProxy(ArchivesStr.BATTLEIMAGING_SYSTEM, new BIPKey());
			return BattleImagingProxy._battleImaging;
		}
		
		//取得SERVER播放清單
		//討論是否需要載清單後要看再分開點載內容 或 一次載完
		public function GetHistoricalFilm():void
		{
			this.callServer(new (this.GAME_MODE ? Get_BattleInfoList : Get_BattleInfoList_Design)());
			//this.TestUsingSelect(2);
		}
		
		//首次撈取資料後的後續開啟內容更新動作
		//還要多一個區間總數來限制暫存最大値
		public function GetBattleInit(battleId:String):void
		{
			this.callServer( this.GAME_MODE ? new Get_BattleInit(battleId) : new Get_BattleInit_Design(battleId));
			trace("CALL SERVER >>> " , battleId);
		}
		
		private function callServer(VO:Object):void
		{
			AmfConnector.GetInstance().VoCall(VO);//正常運作
		}
		
		
		private function historicalBack(e:EventExpressPackage):void 
		{
			var content:Object = NetResultPack(e.Content) ._result;
			if (content == null) {
				MessageTool.InputMessageKey(001);//SERVER回傳資料為空
				return;
			}
			
			switch (e.Status)//VO _replyDataType
			{
				case "BattlefieldInit" ://初始化取得所有VO資料 ( Get_BattleHistorical )
					//this._aryHistorical = content as Array;
					this._dicBattleInit[BattlefieldInit(content)._battleId] = content;
					this.SendNotify(ArchivesStr.BATTLEIMAGING_INIT_BACK);//通知外部已有BattlefieldInit可做顯示資料,視外部操作使用或為loading取消用
					
					this.ToImagingBattle(content as BattlefieldInit);
				break;
				case "BattleReport"://只撈取清單的資料部分
					this._materialPlant.InitHistorical(content as Array);
					//this.TestUsingSelect(content.length);
					this.GetServerID();
					
				break;
				
			}
		}
		
		//JS call //收到SERVER夾帶戰場ID //跳新頁面時載入完成同頁面取ID資料
		public function GetServerID():void 
		{
			if (!this.GAME_MODE) {
				flash.system.Security.allowDomain("*");
				this._battleID = ExternalInterface.available ? ExternalInterface.call("get_battle_id") : "Test";//SERVER端JS的function名稱 >> get_battle_id
				this.TestUsingSelect(0);//顯示ID訊息通知
				TextField(this._spChoose.getChildByName("txtInput")).text = this._battleID;
			}
		}
		//↓
		//TEST FOR SELECT UI
		private var _battleID:String;
		private var _spChoose:Sprite;
		private function TestUsingSelect(length:int):void 
		{
			_spChoose = new Sprite();
			var txtFormat:TextFormat = new TextFormat("微軟正黑體", 20);
			var txtFormatR:TextFormat = new TextFormat("微軟正黑體", 18,0xFF0000);
			var spBtn:Sprite = new Sprite();
			var txtBtn:TextField = new TextField();
			txtBtn.text = "SEND";
			txtBtn.selectable = false;
			spBtn.mouseChildren = false;
			spBtn.addChild(txtBtn);
			var txtInput:TextField = new TextField();
			var txtLeng:TextField = new TextField();
			//txtInput.autoSize = TextFieldAutoSize.LEFT;
			txtInput.width = 150;
			txtLeng.autoSize = TextFieldAutoSize.LEFT;
			txtInput.defaultTextFormat = txtFormatR;
			txtLeng.defaultTextFormat = txtFormat;
			this.drawSp(_spChoose, 0xABCDEF, 100);
			this.drawSp(spBtn, 0xFF6666, 20);
			//txtInput.type = TextFieldType.INPUT;//***************
			//txtInput.restrict = "0-9";//***************
			txtLeng.selectable = false;
			txtLeng.text = length > 0 ? "資料範圍為" + "0   ~   " + String(length - 1) : "觀看戰場ID為";
			txtInput.text = length > 0 ? "請輸入讀取資料..." : "NO DATA";
			txtInput.name = "txtInput";
			txtInput.y = 50;
			_spChoose.addChild(txtLeng);
			_spChoose.addChild(txtInput);
			_spChoose.addChild(spBtn);
			spBtn.x = 150;
			spBtn.y = 50;
			spBtn.buttonMode = true;
			spBtn.name = "send";
			_spChoose.addEventListener(MouseEvent.CLICK, gotoShow);
			
			ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).addChild(_spChoose);
			var pp:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			_spChoose.x = pp.x / 2 - _spChoose.width / 2;
			_spChoose.y = pp.y / 2 - _spChoose.height / 2;
			
		}
		
		private function gotoShow(e:MouseEvent):void 
		{
			//trace(e.target.name,input, "asdfasdfasdfasdfasfdfdfasdsdfdfadfafasfd");
			switch (e.target.name) 
			{
				case "txtInput":
					//TextField(_spChoose.getChildByName("txtInput")).text = "";
				break;
				case "send":
					//var input:int = int(TextField(_spChoose.getChildByName("txtInput")).text);
					//trace(input < this._aryHistorical.length , TextField(_spChoose.getChildByName("txtInput")).text , input);
					//var check:Boolean;
					//check = (String(input) != TextField(_spChoose.getChildByName("txtInput")).text) ? false : true;
						//if (input < this._aryHistoricalList.length && check) {
							//ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).removeChild(_spChoose);
							//_spChoose.removeEventListener(MouseEvent.CLICK, gotoShow);
							//this.ToImagingBattle(this._aryHistoricalList[int(input)]);
						//}else{
							//TextField(_spChoose.getChildByName("txtInput")).text = "Error";
						//}
						if (this._battleID != "") this.ReadyToImaging(this._battleID);
				break;
			}
		}
		private function drawSp(sprite:Sprite,color:uint,size:int):void 
		{
			sprite.graphics.beginFill(color);
			sprite.graphics.drawRoundRect(0, 0, size*2, size,5,5);
			sprite.graphics.endFill();
		}
		//TEST FOR
		//↑
		
		
		public function GetBattleInitData(listNumber:uint):BattlefieldInit
		{
			return listNumber < this._materialPlant.HistoricalList.length ? this._materialPlant.HistoricalList[listNumber] : null;
		}
		
		//王國/PVP取得戰場報告需求素材與資料包↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
		public function GetInfoContentWithData(report:BattleReport):BattleResult
		{
			return report != null ? this._materialPlant.GetInfoContent("", report) : null;
		}
		
		//可供外部用組裝廠內層Object 有_picItem 即可
		public function GetItemDisplayMixed(objData:Object):Array
		{
			return this._materialPlant.GetItemDropDisplay(objData);
		}
		
		//=================================================================================================
		
		
		
		//戰報系統UI可使用↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
		//點選清單後使用ID來換第二頁的顯示元件
		public function GetInfoContentWithID(battleID:String):BattleResult
		{
			return battleID != "" ? this._materialPlant.GetInfoContent(battleID) : null;
		}
		
		//清單中點選觀看戰報清單撈取資料 導入ID
		public function ReadyToImaging(battleId:String):void 
		{
			if (battleId in this._dicBattleInit) {
				this.SendNotify(ArchivesStr.BATTLEIMAGING_INIT_BACK);//通知外部已有BattlefieldInit可做顯示資料,視外部操作使用或為loading取消用
				this.ToImagingBattle(this._dicBattleInit[battleId]);
			}else {
				this.GetBattleInit(battleId);
			}
		}
		
		
		//戰報系統UI可使用↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
		
		
		//外部需要戰鬥顯示者操作
		//直接執行播放>>會回傳是(true) /  否(false) 成功執行
		//needPause == true >> 會先載入必要素材等待開啟播放才做動作
		public function ToImagingBattle(battleInit:BattlefieldInit, needPauseNotify:String=""):Boolean
		{
			if (this._isPlaying) {
				MessageTool.InputMessageKey(1901);//當前UI正在播放處理中
				return !this._isPlaying;
			}
			
			this._needCount = 1;//需要載入的UI數量
			this._dataReady = false;//資料未準備完成
			this._needPauseNotify = needPauseNotify;//是否需要讀取完成後暫停
			this._isPause = needPauseNotify == "" ? false : true;//當前是否為暫停狀態
			this._isPlaying = true;//是否正在播放
			this._manager.Screenplay = battleInit;
			
			//預先載入指定的地圖樣式圖片  >> 
			if (battleInit._areaPic != "") {
				this._needCount++;
				var loadCarpet:RemoteCache = new RemoteCache(battleInit._areaPic, this.LoadUIComplete);
				loadCarpet.StartLoad();
			}
			
			//撈取UI素材檔案
			var catchUI:RemoteCache = new RemoteCache(this._uiKey, this.LoadUIComplete);// null , true);//先關閉掉抓檔完成自動清除的功能(新版有ERROR)
			catchUI.StartLoad();
			
			//setTimeout(this.PauseThrough, 4000);
			return this._isPlaying;
		}
		
		//needPause為True的狀態下會暫停播放過程 , 呼叫後即停止暫停 (探索切換戰鬥時會用到)
		public function PauseThrough():void
		{
			if (this._dataReady && this.NeedPause) {
				this.startViewShow();
			}else {
				this._isPause = false;
			}
		}
		
		
		//UI載入完成( UI元件 /  底圖 )
		private function LoadUIComplete(key:String):void
		{
			this._needCount--;
			if (this._needCount == 0) this.battleEffectPrepare(this._manager.InfoData);
		}
		
		//戰鬥素材處理
		private function battleEffectPrepare(initData:BattlefieldInit):void
		{
			var vecFighter:Vector.<BattleFighter> = new Vector.<BattleFighter>();
			this.outFighters(initData._objArmy, vecFighter);
			this.outFighters(initData._objEnemy, vecFighter);
			this.ToBridge(ArchivesStr.BATTLEIMAGING_VIEW_PREPARE, { _skill : initData._arySkill , _monster : vecFighter , _bgKey : initData._areaPic} );
		}
		
		private function outFighters(fighterInfo:Object,boxer:Vector.<BattleFighter>):void
		{
			for each (var item:BattleFighter in fighterInfo)
			{
				boxer[boxer.length] = item;
			}
			
		}
		
		//留給自command通知呼叫使用
		//怪物與技能效果載入完成(若非暫停狀態下則會直接運行)
		public function LoadReady():void
		{
			this._dataReady = true;//資料準備完成
			if (!this._isPause) {
				this.startViewShow();
			}else {
				//發送一個通知訊號讓探索知道載入完成
				this.SendNotify(this._needPauseNotify, { _status : "READY" , _content : null } );
								/*
								_status : "LEAVING" , _content : {...}
								_status : "CLOSE"    , _content : null
								_status : "READY"    , _content : null
								會收到的三種可能性 
							 */
			}
			
		}
		
		private function startViewShow():void 
		{
			this.ToBridge(ArchivesStr.BATTLEIMAGING_VIEW_START, { _manager : this._manager ,_bgKey : this._manager.InfoData._areaPic , _needPause : this._needPauseNotify} );
		}
		
		private function ToBridge(status:String,data:Object):void
		{
			this.SendNotify(ArchivesStr.BATTLEIMAGING_BRIDGE, { _status : status , _data : data  ,_needPause : this._needPauseNotify} );
		}
		
		public function get Manager():BattleManager
		{
			return this._manager;
		}
		
		public function get NeedPause():Boolean 
		{
			return this._needPauseNotify == "" ? false : true;
		}
		
		//播放完成後通知變更開關
		public function EndOfShow():void
		{
			this._isPlaying = false;
		}
		
		//探索有暫停運作狀態下(有帶發送通知字串),不繼續播放的狀態下(PauseThrough),CombatSkill/Monster由探索回收/呼叫此讓BattleInit檔案回收
		public function EraseInitData():void
		{
			this._manager.Destroy();
		}
		
	}
	
}

class BIPKey 
{
	
}