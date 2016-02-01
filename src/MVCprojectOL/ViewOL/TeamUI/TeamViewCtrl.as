package MVCprojectOL.ViewOL.TeamUI
{
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	import Spark.Timers.TimeDriver;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.commandStr.TeamCmdStr;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.proxyStr.TroopStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.28.11.28
		@documentation UI控制
	 */
	public class TeamViewCtrl extends ViewCtrl
	{
		
		public static const TEAM_VIEWCTRL:String = "TeamViewCtrl";//Regist
		//public static const TEAM_NOTIFY:String = "TeamNotify";
		//public static const TEAM_SWITCH:String = "TeamSwitch";
		//public static const TEAM_PAGE_NEXT:String = "TeamPageNext";
		//public static const TEAM_PAGE_PREV:String = "TeamPagePrev";
		public static const TEAM_MEMBER_EDIT:String = "TeamMemberEdit";
		public static const TEAM_MEMBER_NEW:String = "TeamMemberNew";
		public static const TEAM_SELECT_REMOVE:String = "TeamSelectRemove";
		public static const TEAM_SELECT_ADD:String = "TeamSelectAdd";
		public static const TEAM_SELECT_ON:String = "TeamSelectOn";
		public static const TEAM_GROUP_CHANGE:String = "TeamGroupChange";//怪物隊伍變更
		public static const TEAM_CHOOSE_CHANGE:String = "TeamChooseChange";//怪物選擇 增/減
		public static const TEAM_EDIT_FLAGNUM:String = "TeamEditFlagNum";//新旗幟編號的取得
		//public static const TEAM_CHECK_SALLY:String = "TeamCheckSally";//檢測隊伍可否出征
		public static const TEAM_SORT_UPDATE:String = "TeamSortUpdate";//點選排序的種類時發送
		public static const TEAM_DESTROY:String = "TeamDestroy";
		
		
		
		private var _inShow:Boolean;//是否為展示隊伍畫面(第一頁)
		private var _filters:BlurFilter;
		private var _showWork:TeamShowWork;//first page
		private var _editWork:TeamEditWork;//second page
		private var _teamShift:TeamShift;//first page shift
		private var _monsterShift:MonsterShift;//second page shift
		private var _dataGuard:TeamDataGuard;//data
		private var _dragTool:HeadDragTool;
		private var _teamPage:int = 1;//current first page pages
		private var _teamLimit:int;//total page
		private var _monsterPage:int = 1;//current second page pages
		private var _monsterLimit:int;//total page
		private var _bgWidth:Number;
		private var _bgHeigh:Number;
		private var _mode:int;// 0 >> 一般組隊(可編輯)  ,  1 >> 出征選隊(可讀)
		private var _fightTeamNotify:String;//出征模式下 點選隊伍後發送的通知隊伍訊號
		
		public function TeamViewCtrl(name:String,container:DisplayObjectContainer,fightTeamNotify:String):void
		{
			super(name, container);
			this._inShow = true;
			this._mode = fightTeamNotify == "" ? 0 : 1;
			this._fightTeamNotify = fightTeamNotify;
			container.addEventListener(MouseEvent.CLICK, playerClickProcess);
			this._dragTool = new HeadDragTool(container,this.ActionProcess);
			
			TweenPlugin.activate([BlurFilterPlugin]);
			//trace("我是新的Team View Ctrl.....................................................................");
		}
		
		
		public function InitEnvironment(aryWork:Array):void
		{
			var leng:int = aryWork.length;
			for (var i:int = 0; i < leng; i++) 
			{
				aryWork[i].SetAddress(this.ActionProcess);
				if (i < 2) {
					aryWork[i].SetSize(this._bgWidth, this._bgHeigh);
				}
			}
			this._showWork = aryWork[0];
			this._editWork = aryWork[1];
			this._teamShift = aryWork[2];
			this._teamShift.Mode = this._mode;
			this._monsterShift = aryWork[3];
			this._dataGuard = new TeamDataGuard();
			this._dataGuard.SetShowNum("team", 3);
			this._dataGuard.SetShowNum("edit", 6);
		}
		
		public function InitData(type:String,data:Object):void
		{
			this._dataGuard.AddInData(type, data);
			if (type == TroopStr.TROOP_READY) this._teamLimit = this._dataGuard.TeamLimit;
			if (type == "monsterProxySourceReady" ) this._monsterLimit = this._dataGuard.MonsterLimit;
		}
		
		public function DrawBackGround(backGround:BitmapData):void
		{
			this._filters = new BlurFilter();
			var bg:Bitmap = new Bitmap(backGround);
			bg.name = "backGround";
			this._viewConterBox.addChild(bg);
			this._bgWidth = backGround.width;
			this._bgHeigh = backGround.height;
		}
		
		private function SwitchBoard(extendData:Object):void
		{
			var bg:Bitmap = this._viewConterBox.getChildByName("backGround") as Bitmap;
			var blurValue:int;
			if (this._inShow) {//切換到編輯畫面 會帶隊伍ID進來
				blurValue = 20;
				//trace("SWITCHBOARD >>>", extendData);
				this.StartEditWork(this._dataGuard.GetMemberByTroop(String(extendData)));//將隊伍ID轉成成員資料
				TweenLite.to(this._showWork, 1, { y: -this._showWork.Hei } );
				TweenLite.to(this._editWork, 1, { y:0 } );
			}else {
				blurValue = 0;
				this.StartShowWork(this._teamPage);//重刷當頁顯示
				TweenLite.to(this._showWork, 1, { y:0 } );
				TweenLite.to(this._editWork, 1, { y:this._editWork.Hei } );
			}
			this._inShow = !this._inShow;
			var objTween:Object = { blurFilter: { blurX:blurValue, blurY:blurValue }, onUpdateParams :[bg], onComplete:this.ChangeBoard };
			TweenLite.to(bg, 1, objTween);
		}
		private function BlurChange(bg:Bitmap):void
		{
			bg.filters = [];
		}
		
		private function ChangeBoard():void 
		{
			if (this._inShow) {
				
			}else {
				
			}
		}
		
		public function LoadingPreview(loading:Class):void 
		{
			//(系統操作用)
			//if (this._mode == 0) {
				this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE);
				this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			//}
			var load:LoadingBar = new loading();
			var pStage:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			this._viewConterBox.addChild(load);
			load.x = pStage.x / 2 - load.width / 2;
			load.y = pStage.y / 2 - load.height / 2;
			load.name = "TeamLoad";
		}
		
		private function removeLoad():void 
		{
			var load:LoadingBar = this._viewConterBox.getChildByName("TeamLoad") as LoadingBar;
			if (load != null) {
				this._viewConterBox.removeChild(load);
				load.stop();
			}
		}
		
		//初始化首次開啟UI狀態
		public function StartCover():void
		{
			this.removeLoad();
			
			this.SetShiftAction();
			
			this.StartPage();
			
		}
		
		//開啟介面的起始頁
		private function StartPage(page:uint=1):void
		{
			
			this._viewConterBox.addChild(this._showWork);
			this._showWork.y = -this._showWork.Hei;
			
			
			TweenLite.to(this._showWork, 1, { y:0 } );
			
			//匯入第一頁資料進隊伍頁面 // 注意翻頁效果中要有初始化判斷
			this.StartShowWork(page);
			
			this._viewConterBox.addChild(this._editWork);
			this._editWork.y = this._editWork.Hei;
		}
		
		//第一版面的顯示頁
		private function StartShowWork(page:uint):void
		{
			if (page > 0 && page <= this._teamLimit) this._teamPage = page;
			//編輯完成隊伍 與 畫面初始化 要做是否顯示下頁或縮排的檢查
			//this._teamLimit = this._dataGuard.CheckPageExtend(this._teamLimit);
			this._teamLimit = this._dataGuard.TeamLimit;
			this.checkTeamPageBtn();
			if (this._teamPage == 1) this._showWork.LimitShow("left");
			if (this._teamLimit == 1) this._showWork.LimitShow("right");
			this._teamShift.AddUnitSource(this._dataGuard.GetDataMixer(this._teamPage),true);
		}
		
		private function checkTeamPageBtn():void 
		{
			//trace("檢測頁數之按鈕型態變更", this._teamPage, this._teamLimit);
			this._showWork.LimitShow("normal");//simple reset
			if (this._teamPage < this._teamLimit) this._showWork.LimitShow("normal");
			
			if (this._teamPage == this._teamLimit) this._showWork.LimitShow("right");
		}
		
		//會收到成員資料( 位置 : ID )
		private function StartEditWork(showInfo:Object):void
		{
			
			this._editWork.CleanAllHead();
			if (showInfo == null) {//新創隊伍
				//trace("新創隊伍");
				this._editWork.InitHeadBoard( { }, null);
			}else {//既有隊伍
				//trace("既有隊伍");
				var ca:Object = this._dataGuard.GetHeadWithObj(showInfo);//成員資料取得頭像檔案
				this._editWork.InitHeadBoard( showInfo ,ca );
			}
			
			this.showEditWork();
		}
		
		private function showEditWork():void 
		{
			this._monsterPage = 1;//重置畫面頁數
			
			this._editWork.LimitShow("normal");
			if (this._monsterPage == 1) this._editWork.LimitShow("left");
			if (this._monsterLimit == 1) this._editWork.LimitShow("right");
			var aryFirstPage:Array = this._dataGuard.GetPage("monster", this._monsterPage);
			this._monsterShift.AddUnitSource(aryFirstPage , true);
			this._monsterShift.MemberNum = this._editWork.CurrentEditAmount;//處理全怪物面板的手指變更(需在 InitHeadBoard 後)
			//trace(" 編輯頁面的單位數量", this._editWork.CurrentEditAmount);
			//trace("開啟編輯頁面的頁數", this._monsterPage, this._monsterLimit);
		}
		
		//刷新排序過後的怪物資料與顯示
		public function FlashSortMonster(vecDisplay:Vector.<MonsterDisplay>):void 
		{
			this._dataGuard.SortMonsterBack(vecDisplay);
			
			this.showEditWork();
		}
		
		
		private function checkMonsterPageBtn():void 
		{
			//trace("CHECK MONSTER PAGE", this._monsterPage, this._monsterLimit);
			this._editWork.LimitShow("normal");//重刷一次
			if (this._monsterPage == 1) this._editWork.LimitShow("left");
			if (this._monsterPage >= this._monsterLimit) this._editWork.LimitShow("right");
		}
		
		//可挑選不同的動作項目導入
		private function SetShiftAction():void
		{
			var TeamAction:SlidingControl=new SlidingControl();
			var MonsterAction:SlidingControl=new SlidingControl();
			
			
			TeamAction.InitContainer(this._showWork.ShiftContainer);
			
			this._teamShift.SetAction(TeamAction);
			TeamAction._Cols = 3;
			TeamAction._Rows = 1;
			TeamAction._HorizontalInterval =290;
			TeamAction._VerticalInterval = 180;
			TeamAction._adjustHeight = 180;
			
			MonsterAction.InitContainer(this._editWork.ShiftContainer);
			
			this._monsterShift.SetAction(MonsterAction);
			MonsterAction._Cols = 3;
			MonsterAction._HorizontalInterval =195;
			MonsterAction._VerticalInterval = 240;
			MonsterAction._adjustHeight = 90;
			
		}
		
		//玩家操作的物件動作
		private function playerClickProcess(e:MouseEvent):void 
		{
			//trace("UI CLICK", e.target.name	, e.currentTarget.name	);
			var name:String = e.target.name;
			
			switch (name) 
			{
				case "teamLeft"://第一頁面的左翻
					if (this._teamPage > 1 ) {
						this._teamPage--;
						this._showWork.LimitShow("normal");
						this._teamShift.AddUnitSource(this._dataGuard.GetDataMixer(this._teamPage), false);
					}
						if(this._teamPage==1) this._showWork.LimitShow("left");
						
				break;
				case "teamRight"://第一頁面的右翻
					if (this._teamPage < this._teamLimit) {
						this._teamPage ++;
						this._showWork.LimitShow("normal");
						this._teamShift.AddUnitSource(this._dataGuard.GetDataMixer(this._teamPage), true);
					}
						if(this._teamPage==this._teamLimit) this._showWork.LimitShow("right");
						
				break;
				case "monsterLeft":
					if (this._monsterPage > 1) {
						this._monsterPage--;
						this._editWork.LimitShow("normal");
						var aryMonPage:Array = this._dataGuard.GetPage("monster", this._monsterPage);
						this._monsterShift.AddUnitSource(aryMonPage , false);
						//翻頁時可能需要將該頁的成員寫入TeamEditWork內做單位移除時的該頁面被移除單位的狀態變更****************************************************************
					}
						//trace("怪物往左翻", "當前頁數" + this._monsterPage , "最大頁數" + this._monsterLimit);
					if (this._monsterPage == this._monsterLimit) this._editWork.LimitShow("right");
					if (this._monsterPage == 1) this._editWork.LimitShow("left");
				break;
				case "monsterRight":
					if (this._monsterPage < this._monsterLimit) {
						this._monsterPage++;
						this._editWork.LimitShow("normal");
						var aryMon:Array = this._dataGuard.GetPage("monster", this._monsterPage);
						this._monsterShift.AddUnitSource(aryMon, true);
					}
					//trace("怪物往左翻", "當前頁數" + this._monsterPage , "最大頁數" + this._monsterLimit);
					if (this._monsterPage == this._monsterLimit) this._editWork.LimitShow("right");
				break;
				case "clean_btn"://編輯隊伍面板按鈕
					this._editWork.CleanAllHead(true);//需要做移除成員的標記
					
					//this.ActionProcess(TEAM_SORT_UPDATE);//測試sort功能使用
				break;
				case "finish_btn"://編輯隊伍面板按鈕
					
					//點擊若有閃爍方格狀態須清除動作
					this._editWork.CheckCleanBox();
					//清除記錄的點擊灰階單位對應表
					this._editWork.CleanGrayBoard();
					
					//夾帶Object { _symbol  ,  _member } ;
					var symbol:String = this._editWork.EditTeamID == "" ? this._dataGuard.GetSymbol() : this._editWork.EditTeamID;
					var member:Object = this._editWork.PickUpAllMember();
					//變更暫存的資料內容
					this._dataGuard.TroopEditRewrite(this._editWork.EditTeamID == "" ? "new" : "edit"  , symbol  , member);//隊伍量與成員變更
					//this._dataGuard.ChangeTeamGroup(this._editWork.RemoveMember);//怪物隊伍值變更//需先移除再新增,避免同一隻移掉再選擇的錯誤狀況////// 改在編擊面板移除挑選時就先改値了 配合印章的同步操作處理
					this._dataGuard.ChangeTeamGroup(this._editWork.CurrentMember, symbol);//怪物隊伍值變更
					//發送通知PROXY >> SERVER 成員變更
					this.ActionProcess(this._editWork.EditTeamID=="" ? TeamViewCtrl.TEAM_MEMBER_NEW : TeamViewCtrl.TEAM_MEMBER_EDIT, {_symbol : symbol  , _member : member});
					//發送通知PROXY >> 變更CLIENT端記錄的隊伍資訊
					
					this.ActionProcess(TeamViewCtrl.TEAM_GROUP_CHANGE, { name : symbol , current : this._editWork.CurrentMember , remove : this._editWork.RemoveMember } );
					
					this.SwitchBoard(null);
				break;
			default:
					var cutName:String = name.substr(0, 3);
					//trace("CUT", cutName);
					
					switch (cutName)
					{
						case "Tea"://隊伍按鈕
							var teamID:String = e.target._guid;
							switch (this._mode) 
							{
								case 0://normal edition
									this._editWork.EditTeamID = teamID;
									//若點選隊伍為新增則取得下一組旗幟編號 否則 清空該組紀錄的編號
									teamID == "" ? this.ActionProcess(TeamViewCtrl.TEAM_EDIT_FLAGNUM) : this.InputTeamFlagNum = this._dataGuard.GetFlagByTeam(teamID);
									this.SwitchBoard(teamID);
								break;
								case 1://sally mode
									//有隊伍且可出征的隊伍發送通知隊伍消息	{ _teamGroup : 隊伍KEY , _teamMember : 隊伍成員Object位置對應成員KEY }
									//trace(teamID, e.target._lock);
									if (teamID != "" && e.target._lock == false) {
										var objSelect:Object = { _teamGroup : teamID , _teamMember : this._dataGuard.GetMemberByTroop(teamID) };
										//this.SendNotify(this._fightTeamNotify,  );
										this.ActionProcess(TeamViewCtrl.TEAM_DESTROY,{_status : "Sally" , _send : objSelect });//選擇完隊伍後關閉處理(城牆收到會由panel撈出當前底板,若被洗掉則會錯誤)
									}
									
								break;
							}
							
							//trace("點擊隊伍的隊伍ID為>>>>>> ",this._editWork.EditTeamID ,e.target.width, e.target.height);
						break;
						case "box"://編輯視窗頭像
							//點擊選取編輯的方式下頭像的變化操作(舊版)
							//var box:MovieClip = e.target as MovieClip;
							//this._editWork.chooseHeadPlace(box);
						break;
						case "Mon"://點擊編輯頁面的怪物卡片
							//var monster:MovieClip = e.target as MovieClip;
							//trace("點擊卡片該怪物的當前狀態", e.target.status , this._dataGuard.CheckSelectable(monster.guid) );
							//當怪物印章狀態為空値時才可操作
							
							//if (this._dataGuard.CheckSelectable(monster.guid) == "") {
								//舊版點選方式編輯模式
								//if (this._editWork.SetClickHead(monster.guid, this._dataGuard.GetHeadByKey(monster.guid))) {
									//this._editWork.ColorfulEffect(monster, true);//版子變灰
									//this._editWork.MonsterInGray(monster.guid, monster);//記錄變灰的版子
									
								//}
							//}
						break;
					}
				break;
			}
			
		}
		
		
		
		public function ActionProcess(type:String, note:Object = null, sendOut:Boolean = true):void 
		{
			switch (type)
			{
				//case TeamViewCtrl.TEAM_NOTIFY:
					
				//break;
				case TeamViewCtrl.TEAM_SELECT_ADD:// {target : "team" / "monster" }   //重新編輯時似乎沒用到 //編輯模式改拖曳後銜接來用 >>點擊怪物模板 導入怪物圖示
					//this._dataGuard.StatusSetting(String(note) , true);//(舊版)
							//trace("AM OUNT " , this._editWork.CurrentEditAmount);
							//trace("GET NOTify >>>>>>>>>>>>>>>>>>>>>TEAM_SELECT_ADD<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
							//trace("monsterSELECT><<>", this._dataGuard.CheckSelectable(note._monsterName));
					if ( this._editWork.CurrentEditAmount < 5 && this._dataGuard.CheckSelectable(note._monsterName) == "") {
						this._dragTool.SetDragHead(this._dataGuard.GetHeadByKey(note._monsterName)as Sprite);
						this._editWork.DragPickCardMonster(note._monsterName);
					}
				break;
				case TeamViewCtrl.TEAM_SELECT_REMOVE://重新編輯時似乎沒用到 //編輯模式改拖曳後銜接來用 >> 點擊怪物框框版 有怪物頭像則拔除 黏在滑鼠上
					//this._dataGuard.StatusSetting(String(note ), false);//(舊版)
							//trace("GET NOTify >>>>>>>>>>>>>>>>>>>>>TEAM_SELECT_REMOVE<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
					
					if (note._monsterName != "") {
						this._editWork.DragPickBoxMonster(note._target);
						this._dragTool.SetDragHead(this._dataGuard.GetHeadByKey(note._monsterName) as Sprite);
						//this._monsterShift.MemberNum = this._editWork.CurrentEditAmount;//處理全怪物面板的手指變更
					}
					//trace(note._target.name);
				break;
				case TeamViewCtrl.TEAM_SELECT_ON://>>新版用來做滑鼠拖曳放掉後的黏在目標框上的頭像處理
					//拖曳方式處理編輯隊伍(新版)
							//trace("GET NOTify >>>>>>>>>>>>>>>>>>>>>TEAM_SELECT_ON<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
					if (note._head != null) {
						this._editWork.DragPutMonster(note._target, note._head, note._from);
						//this._monsterShift.MemberNum = this._editWork.CurrentEditAmount;//處理全怪物面板的手指變更
					}
				break;
				case TeamViewCtrl.TEAM_CHOOSE_CHANGE://<TeamEditWork>  Send >> 怪物選擇編輯更動 新增 / 移除 (純粹計數的操作******************************************選擇怪物後的影響重置區塊  
					
					this._dataGuard.ChangeTeamShow(note["guid"], note["isAdd"]);//改變怪物的隊伍顯示型態(有無組隊狀態的型態切換);
					
					this._monsterShift.MemberNumShift = note["isAdd"];//變更編輯成員計數
					
					
					//點擊選取編輯的方式下頭像的變化操作(舊版)
					
					//this._dataGuard.ChangeTeamStatusForPage(note["guid"], note["isAdd"]);//改變隊伍status
					//this._dataGuard.ChangeRealAmount(note["isAdd"]);
					//this._monsterLimit = this._dataGuard.MonsterLimit;//點擊頭像變化時做頁數確認
					//if (this._monsterLimit == 1 ) {
						//var checkNum:int = this._dataGuard.CheckMonsterNumber;
						//trace("檢測中", checkNum, this._dataGuard.MonPageNum);
						//switch (true) 
						//{
							//case (checkNum == this._dataGuard.MonPageNum):
							//case (checkNum < this._dataGuard.MonPageNum && !note["isAdd"]):
								//this._monsterPage = 1;
								//this._monsterShift.AddUnitSource(this._dataGuard.GetPage("monster", this._monsterPage), true);
							//break;
						//}
					//}
					//this.checkMonsterPageBtn();
				break;
				case 'TeamViewCtrl.TEAM_PAGE_NEXT'://note { target : "team" / "monster"  , aryMonster : []  , aryHead : []  }
					
					if (note.target == "team") {
						//if (this._teamPage < this._teamLimit) this._teamPage ++;
						//note.page = this._teamPage;
					}else {
						//if (this._monsterPage < this._monsterLimit) this._monsterPage++;
						//note.page = this._monsterPage;
					}
					
				break;
				case 'TeamViewCtrl.TEAM_PAGE_PREV'://note { target : "team" / "monster"  , aryMonster : []  , aryHead : []  }
					if (note.target == "team") {
						//if (this._teamPage > 1 ) this._teamPage--;
						//note.page = this._teamPage;
					}else {
						//if (this._monsterPage > 1) this._monsterPage--;
						//note.page = this._monsterPage;
					}
					
				break;
			}
			
			
			if(sendOut) this.SendNotify(TeamCmdStr.TEAM_CMD_PROCESS, {_Status : type , _Content : note});
		}
		
		//暫無
		public function ForeignProcess(type:String,note:Object=null):void
		{
			
			switch (type) 
			{
				case TeamViewCtrl.TEAM_DESTROY://收到點擊EXIT後的內部銷毀程序啟動
					
					
				break;
			}
			
		}
		
		//寫入下一組新隊伍需要的旗幟編號
		public function set InputTeamFlagNum(num:int):void 
		{
			this._dataGuard.CurrentFlagNum = num;
			//trace("寫入的隊伍旗幟 編號 >>>>>", num);
		}
		
		public function get FightTeamNotify():String 
		{
			return this._fightTeamNotify;
		}
		
		
		override public function onRemoved():void
		{
			//trace("呼叫了VIEWＣＴＲＬ的 ON REMOVE");
			this.Destroy();
		}
		
		override public function onRegisted():void
		{
			
		}
		
		
		public function Destroy():void 
		{
			this._dataGuard.Destroy();
			this._showWork.Destroy();
			this._editWork.Destroy();
			this._teamShift.Destroy();
			this._monsterShift.Destroy();
			
			this._dataGuard = null;
			this._showWork = null;
			this._editWork = null;
			this._teamShift = null;
			this._monsterShift = null;
			this._filters = null;
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClickProcess);
			
			this.removeLoad();
			
			while (this._viewConterBox.numChildren>0) 
			{
				this._viewConterBox.removeChildAt(0);
				//trace("移除動作");
			}
			
			//避免上層被移掉
			if(this._viewConterBox.parent!=null) this._viewConterBox.parent.removeChild(this._viewConterBox);//移掉統一層
			this._viewConterBox = null;
			
		}
		
		
		
	}
	
}