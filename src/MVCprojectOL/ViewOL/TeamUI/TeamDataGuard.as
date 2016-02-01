package MVCprojectOL.ViewOL.TeamUI
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.Vo.Troop;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.SoarVision.multiple.MultiBimtapVision;
	import Spark.Timers.TimeDriver;
	import strLib.proxyStr.TroopStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TeamDataGuard
	{
		
		private var _dicOL:Dictionary;
		private var _dicTP:Dictionary;
		private var _dicWrite:Dictionary;
		private var _aryTroop:Array;
		private var _aryMonster:Vector.<MonsterDisplay>;
		private var _teamPageNum:uint;
		private var _editPageNum:uint;
		private var _maxTeamPage:int = 3;//需要調整為由dataCenter取得最大隊伍限制數量再轉換為最大頁數 9 / 3
		private var _realAmount:int;
		private var _currentFlagNum:int;//當前組新隊伍旗幟分配到的編號
		
		public function AddInData(type:String,data:Object):void
		{
			var leng:int;
			var i:int;
			switch (type) 
			{
				case TroopStr.TROOP_READY://組隊資料
					this._aryTroop = data as Array;
					this._dicTP = new Dictionary(true);
					leng = this._aryTroop.length;
					for (i = 0; i < leng; i++)
					{
						this._dicTP[this._aryTroop[i]["_guid"]] = this._aryTroop[i];
						//trace("收到的TROOP屬性FLAG>>>", this._aryTroop[i]["_flagNum"]);
					}
				break;
				case "monsterProxySourceReady"://怪獸資料&素材
					this._aryMonster = data as Vector.<MonsterDisplay>;
					//trace("取得怪物資料長度>>>>>>>>>>", this._aryMonster.length);
					leng = this._aryMonster.length;
					
					this._dicOL = new Dictionary(true);
					this._dicWrite = new Dictionary(true);
					var monData:Object;
					for (i = leng-1; i >=0 ; i--)
					{
						monData = this._aryMonster[i]["MonsterData"];
						if (monData._useing != 2) {
							this._dicOL[monData["_guid"]] = this._aryMonster[i];
						}else {
							this._aryMonster.splice(i, 1);
						}
						
						
						//trace("初始怪物ID清單",monData["_guid"],monData._useing);
						//須篩選隊伍資料
						//if (monData["_teamGroup"] != "" || monData["_useing"] != 1 ) {
							// 0 空隊伍怪物 /  1 有隊伍怪物
							//this._aryMonster[i]["_status"] = 1;//有隊伍狀態
							//this._realAmount--;//有隊伍減少總計數值做正確頁數判斷
						//}
						//trace("撈到全怪物的隊伍資訊_teamGroup >>>> ",monData["_teamGroup"],this._aryMonster[i]["_status"],monData["_showName"],monData["_useing"]);
					}
					//事先寫入總數量做預設加減值
					this._realAmount = this._aryMonster.length;
				break;
			}
		}
		
		//monsterProxy拿到新的資料後導入
		//靜態sort屬性不合,monsterDispaly回來是沒有組隊紀錄的資料,不在此做sort,故複寫
		public function SortMonsterBack(vecDisplay:Vector.<MonsterDisplay>):void 
		{
			this._aryMonster.length = 0;
			this._aryMonster = vecDisplay;
			var leng:int = vecDisplay.length;
			this._realAmount = leng;
			var monDp:MonsterDisplay;//new Data
			var write:WriteBag;
			for (var i:int = 0; i < leng; i++) 
			{
				monDp = vecDisplay[i];
				//trace("新SORT的怪物資料",monDp.MonsterData["_guid"] ,monDp.MonsterData["_useing"]);
				//if (monDp.MonsterData._guid == "MOB136144228938135") trace("標記測試怪物-----------------------****-*-*-*-*-*-*-*");
				write = this._dicWrite[monDp.MonsterData._guid];
				//trace(write == null , write == undefined);
				if (write!=null){
					
					monDp.MonsterData["_teamGroup"] = write._teamGroup;
					monDp.MonsterData["_TeamFlag"] = write._TeamFlag;
					
					//trace("有取代資料的怪物",monDp.MonsterData["_guid"] ,monDp.MonsterData["_teamGroup"], monDp.MonsterData["_TeamFlag"]);
				}
				
				this._dicOL[monDp.MonsterData["_guid"]] = monDp;
			}
			
		}
		
		//空字串則是移除隊伍標記//按下確定編輯鈕後一次寫入當次隊伍
		public function ChangeTeamGroup(member:Array,groupID:String=""):void
		{
			var leng:int = member.length;
			var unit:MonsterDisplay;
			for (var i:int = 0; i < leng; i++) 
			{
				unit = this._dicOL[member[i]];
				unit.MonsterData["_teamGroup"] = groupID;
			}
		}
		
		//改變怪物的顯示型態(組隊與非組隊的印章) // 尚待銜接新的旗幟顏色組模式*****************************************************************
		public function ChangeTeamShow(guid:String,hasTeam:Boolean):void 
		{
			var monDisplay:MonsterDisplay = this._dicOL[guid];
			
			if (!(guid in this._dicWrite)) this._dicWrite[guid] = new WriteBag();
			
			//正式寫入隊伍ID前先做假判斷値//暫存編輯過程中的資料寫回SORT紀錄
			this._dicWrite[guid]["_teamGroup"]= monDisplay.MonsterData["_teamGroup"] = hasTeam ? "Orz" : "";
			
			//設定monsterDisplay的旗幟需求編號  ***********************************************************************************************************************************
			//暫存編輯過程中的資料寫回SORT紀錄
			this._dicWrite[guid]["_TeamFlag"]= monDisplay.MonsterData["_TeamFlag"] = hasTeam ? this._currentFlagNum : -1;
			
			
			//if (guid == "MOB136144228938135") trace("測試目標來源變更數值guid = MOB136144228938135",this._dicWrite[guid]["_TeamFlag"],this._dicWrite[guid]["_teamGroup"]);
			//trace("怪物的FLAG為>>>>>", monDisplay.MonsterData["_TeamFlag"],this._currentFlagNum,hasTeam,monDisplay.MonsterData["_teamGroup"]);
			
			//怪物無法點選時讓手指頭消失反之開啟
			var board:MovieClip = monDisplay.MonsterBody.parent as MovieClip;
			if (board != null) {
				board.buttonMode = hasTeam ? false : true;
				board.lockHand = !board.buttonMode;//monsterShift 辨識用
			}
			
			monDisplay.ShowContent();
		}
		
		//玩家編輯當下變更的判斷值做為翻頁怪物是否顯示的標記與頁數問題處理  *****怪物全部顯示後 應該沒用到
		public function ChangeTeamStatusForPage(guid:String,hasTeam:Boolean):void 
		{
			var monDisplay:MonsterDisplay = this._dicOL[guid];
			monDisplay._status = hasTeam ? 1 : 0;//舊版記錄的狀態値做為是否顯示的判斷値
		}
		
		
		public function SetShowNum(type:String,num:uint ):void 
		{
			switch (type) 
			{
				case "team":
					this._teamPageNum = num;
				break;
				case "edit":
					this._editPageNum = num;
				break;
			}
		}
		
		// 取得該頁數資料 ( 隊伍 , 怪物 ) // 主要給隊伍操作
		public function GetDataMixer(page:uint):Object
		{
			var aryData:Array = this.GetPage("team", page);
			var objMixer:Object = {data:aryData , monster:this._dicOL};
			
			return objMixer;
		}
		
		//"team" / "monster"
		public function GetPage(type:String,page:uint):Array
		{
			//var calculate:int = type == "monster" ? this._editPageNum : this._teamPageNum;
			//var start:int = (page-1) * calculate;
			//var limit:int = calculate * (page);
			
			return type == "monster" ? this.getMonster((page-1) * this._editPageNum ) : this.getTroop((page-1) * this._teamPageNum , this._teamPageNum * page);
		}
		
		private function getTroop(start:int,limit:int):Array 
		{
			var realLeng:int = this._aryTroop.length;
			var arrPick:Array = [];
			
			for (var i:int = start; i < limit; i++)
			{
				arrPick[i - start] = i < realLeng ? this._aryTroop[i] : null;
			}
			return arrPick;
		}
		
		
		private function getMonster(preAmount:int):Array
		{
			var leng:int = this._aryMonster.length;
			var pickCount:int = this._editPageNum;
			var aryPick:Array = [];
			var monster:MonsterDisplay;
			
			for (var i:int = 0; i < leng; i++)
			{
				//trace("TEST FOR MONSTER", preAmount, pickCount, i);
				monster = this._aryMonster[i];
				if (monster._status == 0) {//無隊伍
					preAmount--;
					if (preAmount < 0) {
						if (pickCount >=0) {
							pickCount--;
							aryPick[aryPick.length] = monster;
							//trace("CATCH", monster.MonsterData["_showName"],pickCount);
							if (pickCount == 0) break;
						}
					}
				}
			}
			return aryPick;
		}
		
		//重新編輯時似乎沒用到
		//public function StatusSetting(guid:String,isAdd:Boolean):void
		//{
			//this._dicOL[guid]["_status"] = isAdd as int;
			//trace("寫入的怪物隊伍狀態", this._dicOL[guid]);
			//
		//}
		
		//由怪物ID取得素材元件
		public function GetMonsterDisplayUnit(guid:String):MonsterDisplay
		{
			if (guid in this._dicOL) {
				MessageTool.InputMessageKey(2013);//怪物清單中查無此怪物的GUID 
				return this._dicOL[guid];
			}
			return null;
		}
		
		public function GetFlagByTeam(teamID:String):int
		{
			var tp:Troop = this.getTroopByKey(teamID);
			
			return tp != null ? tp._flagNum : -2;
		}
		
		private function getTroopByKey(teamID:String):Troop
		{
			return teamID in this._dicTP ? this._dicTP[teamID] : null;
		}
		
		public function GetMemberByTroop(guid:String):Object
		{
			return guid != "" ? this._dicTP[guid]["_objMember"] : null;
		}
		//object{ place : ID }
		public function GetHeadWithObj(obj:Object):Object
		{
			var reback:Object = { };
			for each (var id:String in obj)
			{
				reback[id] = this.GetHeadByKey(id);
			}
			return reback;
		}
		
		//type : "new " / "edit" 
		public function TroopEditRewrite(type:String,IDorSymbol:String,member:Object):void
		{
			var insteadTroop:Troop;
			if (type == "new") {
				
				if (this.checkObjectContain(member)) {
					insteadTroop= new Troop();
					insteadTroop._guid = IDorSymbol;
					insteadTroop._objMember = member;
					insteadTroop._status = 0;//須注意隊伍狀態的變更可能性
					this._aryTroop[this._aryTroop.length] = insteadTroop;
					this._dicTP[IDorSymbol] = insteadTroop;
					//trace("檢測新隊伍的寫入資料" , insteadTroop._guid, type, IDorSymbol, member);
				}
				
			}else {
				//改寫已存在隊伍成員
				//trace("檢測複寫隊伍", type, IDorSymbol, member, member == null);
				
				insteadTroop = this._dicTP[IDorSymbol];
				
				if (this.checkObjectContain(member)) {//有成員
					insteadTroop._objMember = member;
				}else {//無成員
					var index:int = this._aryTroop.indexOf(insteadTroop);
					this._aryTroop.splice(index, 1);
					delete this._dicTP[IDorSymbol];
				}
				
			}
			
			if (insteadTroop != null) insteadTroop._flagNum = this._currentFlagNum;//寫回旗幟顏色編號
		}
		
		private function checkObjectContain(obj:Object):Boolean
		{
			var check:Boolean = false;
				for each (var item:String in obj)
				{
					check = true;
					break;
				}
			return check;
		}
		
		
		//取得怪物當前是否具有無法選擇的鎖定狀態値
		public function CheckSelectable(guid:String):String
		{
			return this.GetMonsterDisplayUnit(guid).CurrentStamp;
		}
		
		
		public function GetHeadByKey(guid:String):DisplayObject 
		{
			return this._dicOL[guid]["MonsterHead"];
		}
		
		
		public function GetSymbol():String
		{
			return "fakeTroop" + String(this._aryTroop.length) + String(int(Math.random() * 50));
		}
		
		public function get DicOL():Dictionary
		{
			return this._dicOL;
		}
		
		public function get TeamLimit():uint
		{
			var leng:uint = this._aryTroop.length;
			var limit:uint = int(leng / this._teamPageNum);
			if (leng % this._teamPageNum > 0) limit++;
			//trace("TEamLIMIT be taken");
			if (leng % this._teamPageNum == 0) limit++;
			
			return limit == 0 ? 1 : limit <= this._maxTeamPage ? limit : this._maxTeamPage;
		}
		
		public function ChangeRealAmount(isAdd:Boolean):void 
		{
			this._realAmount += isAdd ? -1 : 1;
		}
		
		public function get MonsterLimit():uint
		{
			var leng:uint = this._realAmount;
			var limit:uint = int(leng / this._editPageNum);
			if (leng % this._editPageNum > 0) limit++;
			return limit == 0 ? 1 : limit;
		}
		
		public function get CheckMonsterNumber():int
		{
			var leng:int = this._aryMonster.length;
			var showNum:int;
			for (var i:int = 0; i < leng; i++) 
			{
				if (this._aryMonster[i]["_status"] == 0) showNum++;
			}
			//trace("取得的SHOWNUM>>>>", showNum);
			return showNum;
		}
		
		public function get MonPageNum():uint 
		{
			return this._editPageNum;
		}
		
		//寫入從PROXY取到的新隊伍FLAG編號
		public function set CurrentFlagNum(num:int):void 
		{
			this._currentFlagNum = num;
		}
		
		
		public function Destroy():void 
		{
			if (this._aryMonster != null) this._aryMonster.length = 0;
			this._aryMonster = null;
			if (this._aryTroop != null) this._aryTroop.length = 0;
			this._aryTroop = null;
			
			var name:String;
			for (name in this._dicOL) 
			{
				delete this._dicOL[name];
			}
			for (name in this._dicTP) 
			{
				delete this._dicTP[name];
			}
			this._dicOL = null;
			this._dicTP = null;
		}
		
		
	}
	
}
class WriteBag 
{
	public var _teamGroup:String;
	public var _TeamFlag:int;
}