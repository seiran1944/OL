package MVCprojectOL.ViewOL.TeamUI
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ViewOL.TeamUI.ShiftBasic;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class MonsterShift extends ShiftBasic 
	{
		
		private var _classOL:Class;
		private var _aryTxtName:Array = ["name_txt", "lv_txt", "atk_txt", "def_txt", "int_txt", "mnd_txt", "agi_txt"];
		private var _aryTxtInfo:Array = ["_showName", "_lv", "_atk", "_def", "_Int", "_mnd", "_speed"];
		private var _aryBarName:Array = ["hp_bar", "exp_bar", "eng_bar"];
		private var _aryBarInfo:Array = ["_nowHp", "_maxHP", "_nowExp", "_maxExp",  "_nowEng", "_maxEng"];
		private var _txtLeng:int;
		private var _vecStampStr:Vector.<String> = new < String > ["Group" ,"Battle"];
		
		private var _memberNum:int;
		private var _currentLock:int = 2;
		private var _vecMonDisplay:Vector.<DisplayObject>;
		
		public function MonsterShift():void 
		{
			this._txtLeng = _aryTxtName.length;
		}
		
		
		override public function AddSource(source:Object):void
		{
			this._classOL = source["olBoard"];
		}
		
		
		override public function AddUnitSource(source:Object,gotoNext:Boolean):void
		{
			var vecBoard:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var leng:int = source.length;
			var monsterData:MonsterDisplay;
			var monsterInfo:Object;
			var board:MovieClip;
			var body:Sprite;
			
			for (var i:int = 0; i < leng; i++)
			{
				monsterData = source[i];
				if (monsterData != null) {
					board = new this._classOL();
					board.name = "Monster" + String(i);
					board.mouseChildren = false;
					monsterInfo = monsterData.MonsterData;
					//trace("怪物當前FLAG參數>>", monsterInfo["_TeamFlag"]);
					board.guid = monsterInfo["_guid"];
					//trace("當頁數的怪物ID", board.guid , monsterInfo["_showName"],monsterData.MonsterData._teamGroup,monsterData.MonsterData._TeamFlag);
					board.status = monsterInfo["_useing"];
					monsterData.setStampSetting(this._vecStampStr);//設定需要篩選的怪物狀態
					monsterData.AddStamp = true;//印章模式開啟
					monsterData.Alive = true;
					monsterData.ShowContent();
					board.buttonMode = this._memberNum >= 5 ? false : monsterData.CurrentStamp == "" ? true : false;
					board.lockHand = monsterData.CurrentStamp == "" ? false : true;
					//trace("手指狀態變更", board.lockHand);
					//trace("monsterSTAMP", monsterData.CurrentStamp);
					//trace(monsterData.MonsterData["_teamGroup"],"_teamGroup_teamGroup_teamGroup_teamGroup_teamGroup_teamGroup_teamGroup_teamGroup",leng);
					body = monsterData.MonsterBody;
					body.name = "monsterBody";
					body.filters = [];
					body.x = 11.5;
					body.y = 26;
					board.addChild(body);
					for (var j:int = 0; j < this._txtLeng; j++)
					{
						//文字框內容設置
						TextField(board.getChildByName(this._aryTxtName[j])).text = String(monsterInfo[this._aryTxtInfo[j]]);
						//BAR設置
						if (j < 3) {
							board.getChildByName(this._aryBarName[j]).scaleX = monsterInfo[this._aryBarInfo[j*2]] / monsterInfo[this._aryBarInfo[j * 2 + 1]];
						}
					}
					vecBoard[i] = board;
					
				}
			}
			this._vecMonDisplay = vecBoard;
			gotoNext ? this.NextPage(vecBoard) : this.PrevPage(vecBoard);
		}
		
		
		public function ChangeAllBoardHand(handLock:int):void 
		{
			//trace("變更版面檢查>", handLock, this._currentLock);
			if (handLock == this._currentLock) return;
			this._currentLock = handLock;
			var leng:int = this._vecMonDisplay.length;
			var board:MovieClip;
			
			for (var i:int = 0; i < leng; i++) 
			{
				if (!handLock) {//開啟可選擇的底板手指
					board = this._vecMonDisplay[i] as MovieClip;
					//trace("openLock", board.lockHand);
					if (!board.lockHand) board.buttonMode = true;
				}else {//關閉全底板手指
					MovieClip(this._vecMonDisplay[i]).buttonMode = false;
				}
			}
		}
		
		override public function NextPage(group:Vector.<DisplayObject>):void 
		{
			this._actControl.NextPage(group);
		}
		
		override public function PrevPage(group:Vector.<DisplayObject>):void 
		{
			this._actControl.PrevPage(group);
		}
		
		
		override public function Destroy():void 
		{
			super.Destroy();
			this._classOL = null;
			this._aryTxtName = null;
			this._aryTxtInfo = null;
			this._aryBarName = null;
			this._aryBarInfo = null;
		}
		
		//寫入當前隊伍已組單位數量
		public function set MemberNum(num:int):void 
		{
			this._memberNum = num;
			
			//trace("輸入當前隊伍單位數為____" + num);
			this.ChangeAllBoardHand(num >= 5 ? 1 : 0);
			
		}
		public function set MemberNumShift(isAdd:Boolean):void 
		{
			this._memberNum += isAdd ? 1 : -1;
			//trace("輸入當前隊伍單位數為____" + _memberNum);
			this.ChangeAllBoardHand(this._memberNum >= 5 ? 1 : 0);
			
		}
		
	}
	
}