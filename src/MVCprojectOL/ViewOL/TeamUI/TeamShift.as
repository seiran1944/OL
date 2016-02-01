package MVCprojectOL.ViewOL.TeamUI
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.Vo.Troop;
	import MVCprojectOL.ViewOL.TeamUI.ShiftBasic;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TeamShift extends ShiftBasic 
	{
		
		private var _classTeam:Class;
		private var _grayFilters:ColorMatrixFilter;
		private var _dicStatusIcon:Dictionary;
		private var _dicCDNeeded:Dictionary;
		private var _aryCdArea:Array;
		private var _mode:int;
		public const _gapWid:int = 80;//左右減少間距值
		public const _gapHei:int = 60;//上下減少間距值
		public const _picSize:int = 150;//圖檔寬高值
		
		public function TeamShift():void
		{
			//for (var i:int = 0; i < 8; i++) 
			//{
				//trace("POSITION OF MONSTER TO TEST LINE PLACE", this.getMonsterLocate(i));
			//}
			this._grayFilters = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);//Gray
			this._dicStatusIcon = new Dictionary(true);
			this._aryCdArea = [];
		}
		
		//後續組隊CD時間去掉後會拿掉出征圖示的處理
		override public function AddSource(source:Object):void
		{
			this._classTeam = source["team"];
			
			var statusIcon:MovieClip = new source["DemonState"]();
			var aryPick:Array = [1, 3, 4];
			var aryList:Array = [2, 3, 1];//閒置中0 / 回程中 1 /  疲勞中 2 /  忙碌中(有單位在排程[學習技能]) 3
			var bmdIcon:BitmapData;
			for (var i:int = 0; i < 3; i++) 
			{
				statusIcon.gotoAndStop(aryPick[i]);
				bmdIcon = new BitmapData(statusIcon.width, statusIcon.height, true, 0);
				bmdIcon.draw(statusIcon);
				this._dicStatusIcon[aryList[i]] = bmdIcon;
			}
		}
		
		//檢測是否需要狀態ICON
		//private function checkIconNeeded(status:int):Boolean
		//{
			//return status == 0 ? false : this._mode == 0 ? status == 1 ? true : false : true;
		//}
		
		//	0	3	6
		//	1	4	7
		//	2	5	8
		//obj{ data : array ,  monster : dic }
		//丟素材進來處理完成會執行翻頁
		override public function AddUnitSource(source:Object,gotoNext:Boolean):void
		{
			var leng:int = source.data.length;
			var vecBoard:Vector.<DisplayObject> = new Vector.<DisplayObject>(leng);
			var troop:Troop;
			var board:MovieClip;
			var monsterBody:Sprite;//注意回傳型態
			var locate:Point;
			var monsterData:MonsterDisplay;
			var checkIcon:int;//>>>閒置中0 / 回程中 1 /  疲勞中 2  /  忙碌中(有單位在排程[學習技能]) 3
			var bmIcon:Bitmap;
			var aryCatchBody:Array;//暫存該隊伍成員動態圖檔
			
			//戰鬥回程中 , 隊伍有成員疲勞 , 學習技能中   為無法出戰的情況
			// troop status>> 閒置中0 / 回程中 1 /  疲勞中 2  /  忙碌中(有單位在排程[學習技能]) 3
			for (var i:int = 0; i < leng; i++)
			{
				troop = source.data[i];
				board = new this._classTeam();
				board.name = "Team" + String(i);
				board.mouseChildren = false;
				board.buttonMode = true;
				if (troop != null) {
					checkIcon = 0;
					board.gotoAndStop(2);
					aryCatchBody = [];
					for (var place:String in troop._objMember)
					{
						//注意回傳型態
						//trace("需要的怪物ID為>>>", troop._objMember[place]);
						monsterData = source.monster[troop._objMember[place]];
						//trace("搜尋的怪物資料>>>", monsterData,monsterData.MonsterData["_motionItem"]);
						//checkIcon = this.checkMonsterStraight(monsterData);//檢測怪物是否有無法出征的狀況
						if(checkIcon==0) checkIcon = this.checkMonsterStraight(monsterData);
						monsterData.AddStamp = false;
						monsterData.Alive = true;
						monsterData.ShowContent();
						monsterBody = monsterData.MonsterBody;
						
						aryCatchBody[aryCatchBody.length] = monsterBody;
						//trace("放置順序", place,board.numChildren);
						monsterBody.name = "monster" + place;
						board.addChild(monsterBody);
						locate = this.getMonsterLocate(int(place));
						monsterBody.x = locate.x;
						monsterBody.y = locate.y;
					}
					
					this.resetMonsterLayer(board);
					//checkIcon = this.checkTroopStraight(troop) == 0 ? checkIcon : 1;//檢測隊伍的CD回程時間
					
					//整個隊伍CD時間的判斷處理應該都會拿掉(可直接略過)
					//if (this.checkTroopStraight(troop) != 0 ) {//隊伍有CD的狀態
						//checkIcon = 1;
						//產生一個倒數的顯示元件
						//var cdA:CdArea = new CdArea(troop._guid, this._dicCDNeeded[troop._guid]);
						//board.addChild(cdA);
						//this._aryCdArea[this._aryCdArea.length] = cdA;
					//}
					
					//trace("寫入隊伍的GUID", troop._guid,troop._flagNum);
					board._guid = troop._guid;
					board._status = troop._status;
					//if (checkIcon != 0) board._lock = true
					board._lock = checkIcon != 0 ? true : false;
					trace(board._lock);
					//最後確認隊伍是否非出征回歸途中
					//board._lock = this.checkShowStamp(checkIcon);//檢測是否需要顯示印章
					//非閒置中的隊伍處理
					if (board._lock) {
						this.grayMonster(aryCatchBody);//染黑隊伍全怪
						bmIcon = new Bitmap(this._dicStatusIcon[checkIcon]);
						board.addChild(bmIcon);
						bmIcon.x = 145 - (bmIcon.width >> 1);
						bmIcon.y = 165 - (bmIcon.height>> 1);
					}
				}else {
					board._guid = "";
				}
				vecBoard[i] = board;
				board.addChild(this.getFillShape(290, 330));
			}
			gotoNext ? this.NextPage(vecBoard) : this.PrevPage(vecBoard);
		}
		
		private function grayMonster(aryBody:Array):void 
		{
			var leng:int = aryBody.length;
			for (var i:int = 0; i < leng; i++) 
			{
				aryBody[i].filters = [this._grayFilters];
			}
		}
		
		//是(true)   /   否(false)  要顯示印章
		//private function checkShowStamp(status:int):Boolean 
		//{
			//return this._mode == 0 ? status != 1 ? false : true : status != 0 ? true : false;
		//}
		//檢測隊伍的CD時間並回標記值
		//private function checkTroopStraight(troop:Troop):int
		//{
			//return this._dicCDNeeded[troop._guid] == "" ? 0 : 1;
		//}
		//檢測怪物的當前使用狀態並回標記值
		private function checkMonsterStraight(monDisplay:MonsterDisplay):int
		{
			var objData:Object = monDisplay.MonsterData;
			var reback:int=0;
			//須注意疲勞狀態的判斷方式 >>>> center的値應該會變成最大與當前差額間距允許値***********************************************************************
			if (objData["_nowEng"] >= objData["_maxEng"]) reback = 2;
			//trace(objData["_maxEng"], objData["_nowEng"],"*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-");
			//objData["_maxEng"]
			////----使用狀態-0:刪除, 1:閒置, 2:溶解 3Learn 4Battle
			if (objData["_useing"] == 3) reback = 3;
			trace("檢查怪物當前狀態數值", objData["_nowEng"], objData["_maxEng"], objData["_useing"], objData._showName);
			
			return reback;
		}
		
		private function resetMonsterLayer(board:MovieClip):void 
		{
			var monster:DisplayObject;
			var count:int;
			var aryPosition:Array = [0, 3, 6, 1, 4, 7, 2, 5, 8];//可調整低至高LAYER
			for (var i:int = 0; i < 9; i++)
			{
				monster = board.getChildByName("monster" + String(aryPosition[i]));
				if (monster != null) {
					board.setChildIndex(monster, i - count);
				}else {
					count++;
				}
			}
		}
		
		//調用擺放位置
		private function getMonsterLocate(place:int):Point
		{
			var locate:Point = new Point();
			locate.x = int(place / 3 ) * (this._picSize-this._gapWid);
			locate.y = (place % 3 ) * (this._picSize - this._gapHei);
			return locate;
		}
		
		private function getFillShape(wid:Number,hei:Number):Shape
		{
			var sh:Shape = new Shape();
			sh.graphics.beginFill(0xFF0000,0);
			sh.graphics.drawRect(0, 0, wid, hei);
			sh.graphics.endFill();
			return sh;
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
			this._classTeam = null;
			this._dicStatusIcon = null;
			this._dicCDNeeded = null;
			this._grayFilters = null;
			this._aryCdArea = null;
		}
		
		public function set Mode(mode:int):void 
		{
			this._mode = mode;
		}
		
		//刷新 需要CD的隊伍ID 同時清空暫存顯示元件陣列
		public function set DicCDNeeded(dicCd:Dictionary):void 
		{
			this._dicCDNeeded = dicCd;
			this._aryCdArea.length = 0;
		}
		
		//PROXY的寫回資料會是字串"00:00:00" or ""
		public function RenewShowCd():void 
		{
			var leng:int = this._aryCdArea.length;
			var cdA:CdArea;
			for (var i:int = 0; i < leng; i++) 
			{
				cdA = this._aryCdArea[i];
				//當頁數有CD倒數的隊伍才會有顯示元件 故次處的雜湊表查找時間都會是有的
				cdA.RenewCdShow(this._dicCDNeeded[cdA._teamId]);
			}
		}
		
	}
	
}
import flash.display.Sprite;
import flash.text.TextField;


class CdArea extends Sprite
{
	
	public var _teamId:String;
	private var _txtCD:TextField;
	
	public function CdArea(teamId:String,cdInfo:String):void 
	{
		this._teamId = teamId;
		this.drawSelf(cdInfo);
	}
	
	private function drawSelf(cdInfo:String):void 
	{
		this.graphics.beginFill(0xFFFFFF, .3);
		this.graphics.drawRoundRect(0, 0, 100, 50, 10);
		this.graphics.endFill();
		
		this._txtCD = new TextField();
		this._txtCD.text = cdInfo;
		addChild(this._txtCD);
		this._txtCD.x = 10;
	}
	
	public function RenewCdShow(cdInfo:String):void 
	{
		this._txtCD.text = cdInfo;
	}
	
}


