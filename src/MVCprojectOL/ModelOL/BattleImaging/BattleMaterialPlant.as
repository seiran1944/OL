package MVCprojectOL.ModelOL.BattleImaging
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.TipsCenter.TipsLab.TipsDataLab;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleReport;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleResult;
	import MVCprojectOL.ModelOL.Vo.Tip;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class BattleMaterialPlant
	{
		
		private var _aryHistoricalList:Array;
		private var _dicReport:Dictionary;
		private var _aryReportKeys:Array;
		private var _dicKeys:Dictionary;
		/*
		"探索" / "PVP" ---帶色碼
		_fightAim"戰鬥結果 
		"勝利" / "失敗" ---帶色碼
		"戰鬥區域: " <COLOR>_fightAim</COLOR>
		"探索結果: " <COLOR>_isWin</COLOR>
		*******預計新增
		_fightAim"戰鬥結果 夾色碼
		<COLOR>_date</COLOR>
		*/
		
		public function BattleMaterialPlant():void 
		{
			this._aryReportKeys = ["FIGHT_LOG_EXPLORE","FIGHT_LOG_PVP","FIGHT_LOG_RESULT","FIGHT_LOG_WIN","FIGHT_LOG_LOSE","FIGHT_LOG_AREA","FIGHT_LOG_RESULT2","FIGHT_LOG_DATE"];
			//Str Prepare
			var vecUiStr:Vector.<Tip> = TipsDataLab.GetTipsData().GetTipsGroup(this._aryReportKeys);
			var leng:int = vecUiStr.length;
			this._dicKeys = new Dictionary(true);
			for (var i:int = 0; i < leng; i++) 
			{
				this._dicKeys[vecUiStr[i]._keyVaule] = vecUiStr[i]._tips;
			}
		}
		
		private function getStringWithKey(key:String):String 
		{
			return key in this._dicKeys ? this._dicKeys[key] : "";
		}
		
		public function InitHistorical(data:Array):void 
		{
			this._aryHistoricalList = data;
			this._dicReport = new Dictionary(true);
			var leng:int = data.length;
			var report:BattleReport;
			for (var i:int = 0; i < leng; i++) 
			{
				report = data[i];
				this._dicReport[report._battleId] = report;
			}
			//資料完成後通知完成並夾帶所需要的參數(object)陣列
			BattleImagingProxy.GetInstance().SendNotify(ArchivesStr.BATTLEIMAGING_DATA_READY,this.GetAllShowList());
		}
		
		public function get HistoricalList():Array 
		{
			return this._aryHistoricalList;
		}
		
		public function GetBattleReport(battleId:String):BattleReport
		{
			if (!(battleId in this._dicReport)) {
				throw new Error("BattleReport is not exist");
				return null;
			}
			return this._dicReport[battleId];
		}
		
		//
		public function GetAllShowList():Array
		{
			var leng:int = this._aryHistoricalList.length;
			var aryList:Array = [];
			var objInfo:Object;
			var report:BattleReport;
			for (var i:int = 0; i < leng; i++) 
			{
				report = this._aryHistoricalList[i];
				objInfo = 
				{
					_battleId : report._battleId ,//single id
					_dateTitle : this.getColorfulDay(report._date), //memory date
					//暫時整合調整130613
					//_typeTitle : this.getTypeTitle(report._battleType),//fight type
					//_infoTitle : this.getInfoTitle(report._fightAim),//content show
					//_resultTitle : this.getResultTitle(report._isWin),//fight result
					//>>>>
					_infoTitle : "[" + this.getTypeTitle(report._battleType) + "]" + this.getInfoTitle(report._fightAim) + "[" + this.getResultTitle(report._isWin) + "]"
				};
				aryList[i] = objInfo;
			}
			
			return aryList;
		}
		
		private function getColorfulDay(date:String):String
		{
			var strDate:String = this.getStringWithKey("FIGHT_LOG_DATE");
			strDate = strDate.replace("^_date^", date);
			return strDate;
		}
		
		//<color>PVP</color>
		private function getTypeTitle(battleType:int):String 
		{
			//_battleType:int;//戰鬥的種類 ( 0 王國 , 1 PVP , 2探索 )
			var type:String;
			switch (battleType) 
			{
				case 2:
					type = "FIGHT_LOG_PVP";//new one
					//type = "PVP";
				break;
				case 1:
					type = "FIGHT_LOG_EXPLORE";//new one
					//type = "探索";
				break;
			}
			return this.getStringWithKey(type);//new one
			//return type;
		}
		
		//普羅米修斯戰鬥結果
		private function getInfoTitle(fightAim:String):String
		{
			var strAim:String = this.getStringWithKey("FIGHT_LOG_RESULT");
			strAim = strAim.replace("^_fightAim^", fightAim);
			return strAim;
			//return fightAim=="unknown" ? "普羅米修斯戰鬥結果" : fightAim+"戰鬥結果";
		}
		
		//戰鬥目標: <color>^_fightAim^</color>
		private function getFightAimTitle(fightAim:String):String
		{
			var strAim:String = this.getStringWithKey("FIGHT_LOG_AREA");
			strAim = strAim.replace("^_fightAim^", fightAim);
			return strAim;
		}
		
		//<color>勝利</color>
		private function getResultTitle(isWin:Boolean):String
		{
			//trace("Battle report get the fight is win or not value >> the value is >>>>>", isWin);
			return this.getStringWithKey(isWin ? "FIGHT_LOG_WIN" : "FIGHT_LOG_LOSE");//new one
			//return isWin ? "勝利" : "失敗";
		}
		
		//戰鬥結果: <color>勝利</color>
		private function getBattleEndTitle(isWin:Boolean):String
		{
			var strEnd:String = this.getStringWithKey("FIGHT_LOG_RESULT2");
			strEnd = strEnd.replace("^_isWin^", this.getResultTitle(isWin));
			return strEnd;
		}
		
		//照ID取得組裝素材資料
		public function GetInfoContent(battleID:String,report:BattleReport=null):BattleResult
		{
			var report:BattleReport = report == null ? this.GetBattleReport(battleID) : report;
			if (report == null) return null;
			
			var result:BattleResult = new BattleResult();
			result._battleId = report._battleId;
			result._aryArmy = this.GetFightUnitDisplay(report._aryArmy);
			result._aryEnemy = this.GetFightUnitDisplay(report._battleType == 2 ? report._aryEnemy : report._itemDrop._monsters);//PVP給敵隊伍 / 王國給掉落怪
			result._aryDrop = report._itemDrop ? this.GetItemDropDisplay(report._itemDrop._material) : [];
			result._dateTitle = this.getColorfulDay(report._date);
			result._battleType = report._battleType;
			//欲將下列四屬性替換 ------------------------------------------需要連同PVP戰報做屬性內容替換處理
			//result._fightAim = report._fightAim;//------------------------------------------------of no use
			//result._typeTitle = this.getTypeTitle(report._battleType);
			//result._infoTitle = this.getInfoTitle(report._fightAim);
			//result._resultTitle = this.getResultTitle(report._isWin);
			//
			//戰鬥區域: 城下廢墟-第1節點
			result._typeTitle = this.getFightAimTitle(report._fightAim);
			//[王國]城下廢墟-第5節點戰鬥結果[勝利]
			result._infoTitle = "[" + this.getTypeTitle(report._battleType) + "]" + this.getInfoTitle(report._fightAim) + "[" + this.getResultTitle(report._isWin) + "]";
			//戰鬥結果: 勝利
			result._resultTitle = this.getBattleEndTitle(report._isWin);
			
			//var txt:TextField = new TextField();
			//txt.autoSize = TextFieldAutoSize.LEFT;
			//txt.htmlText = result._typeTitle;
			//txt.htmlText += result._infoTitle;
			//txt.htmlText += result._resultTitle;
			//ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).addChild(txt);
				//txt.y = Math.random()*600;
				
			
			return result;
		}
		
		//戰鬥成員Object  //只用到頭像故用ItemDisplay
		//{
			//_picItem : String
			//_nowhpValue : int
			//_addExp : int
		//}
		//取得戰鬥成員頭像元件/資料 處理
		public function GetFightUnitDisplay(aryData:Array):Array
		{
			var leng:int = aryData.length;
			var itemDp:ItemDisplay;
			var aryBag:Array = [];
			for (var i:int = 0; i < leng; i++) 
			{
				itemDp = new ItemDisplay(aryData[i]);
				aryBag.push(itemDp);
			}
			return aryBag;
		}
		
		 /*
		_material 
		{ 
			itemGUID : PlayerSource VO
		}
		*/
		//取得煉金素材掉落ICON元件/資料 處理
		public function GetItemDropDisplay(objData:Object):Array
		{
			var aryBag:Array = [];
			var itemDp:ItemDisplay;
			for each (var item:Object in objData) 
			{
				itemDp = new ItemDisplay(item);
				aryBag.push(itemDp);
				//itemDp.ShowContent();
				//ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).addChild(itemDp.ItemIcon);
				//itemDp.ItemIcon.x = 100;
				//itemDp.ItemIcon.y = 100;
			}
			return aryBag;
		}
		
		
		
		
		
	}
	
}