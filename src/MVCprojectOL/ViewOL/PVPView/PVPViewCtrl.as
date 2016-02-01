package MVCprojectOL.ViewOL.PVPView 
{
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.SingleTimerBar;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleResult;
	import MVCprojectOL.ModelOL.Vo.PlayerSource;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpCompetition;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class PVPViewCtrl extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel;
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"LEFT", _col:0xF4F0C1, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
		private var _RankBoard:Array;
		private var _RankList:Vector.<Sprite>;
		private var _CurrentListBoard:Sprite;
		private var _AskPanel:AskPanel = new AskPanel();
		private var _Place:int;
		private var _FightLimit:int;
		private var _PlayerHonorMax:int;
		private var _ReportPanel:ReportPanel = new ReportPanel();
		private var _BattleId:String;
		private var _ReportBasisPanel:BasisPanel;
		private var _DropLength:int
		private var _Fightable:int;
		private var _TipsView:TipsView = new TipsView("PVP");//---tip---
		
		public function PVPViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE); 
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		
		public function AddElement(_InputObj:Object):void
		{
			this._BGObj = _InputObj;
			
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			
			this._Panel = new Sprite();
			this._Panel.x = 230;
			this._Panel.y = 105;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "PVPPanel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel);
			this._BasisPanel.AddBasisPanel("魔鬥道場", 1000, 700, 560);
			this._BasisPanel.AddCheckBtn("積分商店", 855, 115, 130, "Shop");
			this._TipsView.MouseEffect(this._Panel.getChildByName("Shop"));
			
			this._TextObj._str="目前排名"
			var _RankText:Text = new Text(this._TextObj);
				_RankText.x = 305;
				_RankText.y = 125;
				_RankText.name = "Rank";
			this._Panel.addChild(_RankText);
			
			this._TextObj._str = "積分點數";
			var _CountText:Text = new Text(this._TextObj);
				_CountText.x = 685;
				_CountText.y = 125;
				_CountText.name = "Count";
			this._Panel.addChild(_CountText);
			
			this._TextObj._str = "挑戰冷卻";
			var _CoolingText:Text = new Text(this._TextObj);
				_CoolingText.x = 70;
				_CoolingText.y = 720;
				_CoolingText.name = "Cooling";
			this._Panel.addChild(_CoolingText);
			var _CoolingBox:Sprite = this._SharedEffect.DrawRect(0, 0, 210, 20);
				_CoolingBox.x = 70;
				_CoolingBox.y = 720;
				_CoolingBox.alpha = 0;
				_CoolingBox.name = "CoolingBox";
			this._Panel.addChild(_CoolingBox);
			this._TipsView.MouseEffect(_CoolingBox);
			
			var _Box:Bitmap;
			for (var i:int = 0; i < 10; i++) 
			{
				_Box = new Bitmap(BitmapData(new(this._BGObj.Box as Class)));
				_Box.x = 305 + i * 53;
				_Box.y = 155;
				_Box.name = "Box" + i;
				this._Panel.addChild(_Box);
			}
			
			var _MapFram:Sprite = new (this._BGObj.MapFram as Class);
				_MapFram.width = 690;
				_MapFram.height = 420;
				_MapFram.x = 295;
				_MapFram.y = 215;
				_MapFram.name = "MapFram";
			this._Panel.addChild(_MapFram);
			
			var _PVPMap:Bitmap = new Bitmap(BitmapData(new (this._BGObj.PVPMap as Class)));
				_PVPMap.width = 660;
				_PVPMap.height = 390;
				_PVPMap.x = 310;
				_PVPMap.y = 230;
			this._Panel.addChild(_PVPMap);
			
			var _PitBg:Bitmap = new Bitmap(BitmapData(new (this._BGObj.PitBg as Class)));
				_PitBg.width = 695;
				_PitBg.x = 290;
				_PitBg.y = 632;
			this._Panel.addChild(_PitBg);
			
			this._TextObj._str = "魔鬥次數";
			var _FrequencyText:Text = new Text(this._TextObj);
				_FrequencyText.x = 765;
				_FrequencyText.y = 595;
				_FrequencyText.name = "Frequency";
			this._Panel.addChild(_FrequencyText);
			var _FrequencyBox:Sprite = this._SharedEffect.DrawRect(0, 0, 120, 20);
				_FrequencyBox.x = 765;
				_FrequencyBox.y = 595;
				_FrequencyBox.alpha = 0;
				_FrequencyBox.name = "FrequencyBox";
			this._Panel.addChild(_FrequencyBox);
			this._TipsView.MouseEffect(_FrequencyBox);
			
			this._BasisPanel.AddCheckBtn("編輯隊伍", 310, 580 , 135, "Team");
			this._TipsView.MouseEffect(this._Panel.getChildByName("Team"));
			this._BasisPanel.AddGrayCheckBtn("挑戰", 885, 580, 85, "GrayChallenge");
			this._BasisPanel.AddCheckBtn("挑戰", 885, 580, 85, "Challenge");
			this._Panel.getChildByName("Challenge").visible = false;
			this._TipsView.MouseEffect(this._Panel.getChildByName("Challenge"));
			
			var _MyTeam:Sprite = this.AddCrewBox();
				_MyTeam.x = 200;//400
				_MyTeam.y = 370;//370
				_MyTeam.name = "MyTeam";
				_MyTeam.alpha = 0;
			this._Panel.addChild(_MyTeam);
			this._TipsView.MouseEffect(_MyTeam);
			
			var _EnemyTeam:Sprite = this.AddCrewBox();
				_EnemyTeam.x = 910;//710
				_EnemyTeam.y = 370;//370
				_EnemyTeam.name = "EnemyTeam";
				_EnemyTeam.alpha = 0;
			this._Panel.addChild(_EnemyTeam);
			this._TipsView.MouseEffect(_EnemyTeam);
			
			this.SendNotify(UICmdStrLib.GetPlayerData);
		}
		//挑戰按鈕顯示  
		// _fightable : -1 = 輸入type錯誤 , 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中 , 3 = 血量不足   ,   4 = 可用出擊次數不足  ,  5 = PVP戰敗系統冷卻中
		public function AddChallengeBtn(_Fightable:int, _Num:int):void 
		{
			//_Fightable = 3;
			//trace(_Fightable, "@@@@@");
			this._Fightable = _Fightable;
			switch (_Num) 
			{
				case -1:
					this._AskPanel.AddInform(0);
					this._AskPanel.AddMsgText("輸入type錯誤", 150);
					//this.AddBtn(false);
				break;
				case 1:
					this._AskPanel.AddInform(0);
					this._AskPanel.AddMsgText("惡魔疲勞中.....", 150);
					//this.AddBtn(false);
				break;
				case 2:
					this._AskPanel.AddInform(0);
					this._AskPanel.AddMsgText("惡魔學習中.....", 150);
					//this.AddBtn(false);
				break;
				case 3:
					this._AskPanel.AddInform(0);
					this._AskPanel.AddMsgText("惡魔血量不足.....", 140);
					//this.AddBtn(false);
				break;
				case 0:
					this.AddBtn(true);
				break;
				case 4:
					this.AddBtn(false);
				break;
				case 5:
					this.AddBtn(false);
					this.SendNotify(UICmdStrLib.GetTimeLine);
				break;
				case 6:
					this._AskPanel.AddInform(0);
					this._AskPanel.AddMsgText("對戰者資料更新...", 140);
				break;
			}
		}
		
		private function AddBtn(_CtrlBoolean:Boolean):void 
		{
			//var _Challenge:Sprite = this._Panel.getChildByName("Challenge") as Sprite;
			if (_CtrlBoolean == true) {
				//if (this._Panel.getChildByName("GrayChallenge") != null) this._Panel.removeChild(this._Panel.getChildByName("GrayChallenge"));
				this._Panel.getChildByName("Challenge").visible = true;
			}else {
				this._Panel.getChildByName("Challenge").visible = false;
				//if (this._Panel.getChildByName("GrayChallenge") == null) this._BasisPanel.AddGrayCheckBtn("挑戰", 885, 580, 85, "GrayChallenge");
			}
		}
		
		public function AddDrop(_Drop:Array):void 
		{
			this._DropLength = _Drop.length;
			if (_DropLength != 0) {
				this._BasisPanel.AddCheckBtn("領取排名獎勵", 855, 165, 130, "Reward");
				this._TipsView.MouseEffect(this._Panel.getChildByName("Reward"));
				var _CurrentItem:ItemDisplay;
				var _CurrentIcon:Sprite;
				var _ItemText:Text;
				var _CurrentBox:Bitmap;
				var _StrLength:int;
				for (var i:int = 0; i < this._DropLength; i++) 
				{
					_CurrentBox = Bitmap(this._Panel.getChildByName("Box" + i));
					_CurrentItem = _Drop[i];
					_CurrentItem.ShowContent();
					_CurrentIcon = _CurrentItem.ItemIcon;
					_CurrentIcon.width = 48;
					_CurrentIcon.height = 48;
					_CurrentIcon.x = _CurrentBox.x;
					_CurrentIcon.y = _CurrentBox.y;
					_CurrentIcon.name = "Drop" + i;
					this._Panel.addChild(_CurrentIcon);
					
					if (_CurrentItem.ItemData is PlayerSource) {
						this._TextObj._col = 0xF4F0C1;
						this._TextObj._str = _CurrentItem.ItemData._number;
						_ItemText = new Text(this._TextObj);
						_StrLength = String(_CurrentItem.ItemData._number).length;
						_ItemText.x = _CurrentBox.x + _CurrentBox.height - 4 - _StrLength * 8;
						_ItemText.y = _CurrentBox.y +_CurrentBox.height - 20;
						_ItemText.name = "ItemText" + i;
						this._Panel.addChild(_ItemText);
					}
				}
			}else {
				this._BasisPanel.AddGrayCheckBtn("領取排名獎勵", 855, 165, 130, "GrayReward");
			}
		}
		public function RemoveDrop():void 
		{
			this._Panel.removeChild(this._Panel.getChildByName("Reward"));
			this._BasisPanel.AddGrayCheckBtn("領取排名獎勵", 855, 165, 130, "GrayReward");
			var _CurrentIcon:Sprite;
			for (var i:int = 0; i < this._DropLength; i++) 
			{
				_CurrentIcon = this._Panel.getChildByName("Drop" + i) as Sprite;
				this._Panel.removeChild(_CurrentIcon);
				if (this._Panel.getChildByName("ItemText" + i) != null) this._Panel.removeChild(this._Panel.getChildByName("ItemText" + i));
			}
		}
		
		//取得排程
		public function AddTimeLine(_TimeLine:Array):void 
		{
			var _TimeLineLength:int = _TimeLine.length;
			var _CurrentTimeLine:Object;
			for (var i:int = 0; i < _TimeLineLength; i++) 
			{
				_CurrentTimeLine = _TimeLine[i];
				if (_CurrentTimeLine._buildType == 10) {
					var _TimeLineObj:Object = { _finishTime:_CurrentTimeLine._finishTime, _needTime:_CurrentTimeLine._needTime, _schID:_CurrentTimeLine._schID };
					this.SendNotify(UICmdStrLib.SetTimeBar, _TimeLineObj);
				}
			}
		}
		//加入排程時間
		public function AddTimeBar(_InputSpr:Sprite):void
		{
			_InputSpr.x = 50;
			_InputSpr.y = 708;
			_InputSpr.name = "TimeBar";
			this._Panel.addChild(_InputSpr );
			SingleTimerBar(_InputSpr).StarTimes();
			this._Panel.setChildIndex(this._Panel.getChildByName("CoolingBox"), this._Panel.numChildren - 1);
		}
		public function RemoveTimeBar():void
		{
			var _TimeBar:Sprite = this._Panel.getChildByName("TimeBar") as Sprite;
			SingleTimerBar(_TimeBar).Close();
			this._Panel.removeChild(_TimeBar);
			this.AddChallengeBtn(0, 0);
		}
		
		//Rank底板
		public function AddRankBoard(_RankBoard:Array):void 
		{
			this._RankBoard = _RankBoard;
			this._RankList = new Vector.<Sprite>;
			var _CurrentRankList:Sprite;
			for (var i:int = 0; i < 21; i++) 
			{
				if (i < this._RankBoard.length) {
					this._RankList.push(this.ListBoardMenu(this._RankBoard[i])) as Sprite;
					_CurrentRankList = this._RankList[i];
					_CurrentRankList.buttonMode = true;
					_CurrentRankList.name = "" + i;
					this._SharedEffect.MouseEffect(_CurrentRankList);
					_CurrentRankList.addEventListener(MouseEvent.CLICK, ListBoardClickHandler);
					this._TipsView.MouseEffect(_CurrentRankList);
				}else {
					this._RankList.push(this.ListBoardMenu());
					_CurrentRankList = this._RankList[i];
				}
				_CurrentRankList.x = 45;
				_CurrentRankList.y = 150 + i * 27;
				this._Panel.addChild(_CurrentRankList);
			}
			
			this.CurrentListBoard(0);
		}
		//
		private function CurrentListBoard(_Num:int):void 
		{
			this._CurrentListBoard = this._RankList[_Num];
			this._CurrentListBoard.name = this._RankList[_Num].name;
			this._CurrentListBoard.buttonMode = false;
			this._SharedEffect.RemoveMouseEffect(this._CurrentListBoard);
			TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
			this.AddEnemyTeamData(this._RankBoard[int(this._CurrentListBoard.name)]);
		}
		
		//物件清單底板
		private function ListBoardMenu(_RankData:PvpCompetition = null):Sprite
		{
			var _ListBoardMenu:Sprite = new Sprite();
			var _ReportBg:Sprite = new (this._BGObj.ReportBg as Class);
				_ReportBg.width = 245;
			_ListBoardMenu.addChild(_ReportBg);
			
			this._TextObj._col = 0x777676;
			var _NumStr:String;
			if (_RankData != null) {
				if (String(_RankData._place).length == 1) _NumStr = "0000"; 
				if (String(_RankData._place).length == 2) _NumStr = "000"; 
				if (String(_RankData._place).length == 3) _NumStr = "00";
				if (String(_RankData._place).length == 4) _NumStr = "0";
				if (String(_RankData._place).length == 5) _NumStr = "";
				this._TextObj._str = _NumStr + _RankData._place + "  " + ItemDisplay(_RankData._objFaction).ItemData._name + "  " + _RankData._name;
				var _RankText:Text = new Text(this._TextObj);
					_RankText.x = 10;
					_RankText.y = 4;
				_ListBoardMenu.addChild(_RankText);
			}
			return _ListBoardMenu;
		}
		//我方惡魔
		public function AddMyTeamData(_MyTeamData:PvpCompetition, _PlayerHonor:int, _PlayerHonorMax:int, _FightLimit:int, _FightTimes:int):void
		{
			Text(this._Panel.getChildByName("Rank")).ReSetString("目前排名  " + _MyTeamData._place as String);
			this._PlayerHonorMax = _PlayerHonorMax;
			Text(this._Panel.getChildByName("Count")).ReSetString("積分點數  " + _PlayerHonor + " / " + this._PlayerHonorMax);
			this._FightLimit = _FightLimit;
			Text(this._Panel.getChildByName("Frequency")).ReSetString("魔鬥次數  " + _FightTimes + " / " + this._FightLimit);
			for (var i:int = 0; i < this._RankBoard.length; i++) 
			{
				if (this._RankBoard[i]._place == int(_MyTeamData._place)) { 
					this._Place = i;
					var _MyRank:Sprite = this._RankList[i];
						_MyRank.buttonMode = false;
						_MyRank.removeEventListener(MouseEvent.CLICK, ListBoardClickHandler);
					this._SharedEffect.RemoveMouseEffect(_MyRank);
					TweenLite.to(_MyRank, 0, { glowFilter: { color:0xFF0000, blurX:17, blurY:17, strength:3, alpha:.7 }} );
					//this._TipsView.RemoveMouseEffect(this._Panel.getChildByName("" + i));
				}
			}
			this.AddMyTeam(_MyTeamData._objMember);
			if (this._Place == 0) this.CurrentListBoard(1);
		}
		public function AddMyTeam(_MyTeamData:Object):void 
		{
			var _MyTeam:Sprite = this._Panel.getChildByName("MyTeam") as Sprite;
			var _CurrentMonster:ItemDisplay;
			var _MonsterIcon:Sprite;
			
			for (var j:int = 0; j < 9; j++) 
			{
				_MonsterIcon = _MyTeam.getChildByName("Icon" + j) as Sprite;
				if (_MonsterIcon != null) _MyTeam.removeChild(_MonsterIcon);
			}
			
			for (var i:String in _MyTeamData) {
				_CurrentMonster = _MyTeamData[i];
				_CurrentMonster.ShowContent();
				_MonsterIcon = _CurrentMonster.ItemIcon;
				_MonsterIcon.width = 48;
				_MonsterIcon.height = 48;
				_MonsterIcon.x = 122 - int(int(i) / 3) * 60;
				_MonsterIcon.y = 8 + (int(i) % 3) * 60;
				_MonsterIcon.name = "Icon" + i;
				_MyTeam.addChild(_MonsterIcon);
			}
			TweenLite.to(_MyTeam, 1, { x:400, alpha:1, delay:.5, ease:Back.easeOut } );
		}
		//敵方惡魔
		private function AddEnemyTeamData(_EnemyTeamData:PvpCompetition):void 
		{
			var _EnemyTeam:Sprite = this._Panel.getChildByName("EnemyTeam") as Sprite;
			var _CurrentMonster:ItemDisplay;
			var _MonsterIcon:Sprite;
			
			for (var j:int = 0; j < 9; j++) 
			{
				_MonsterIcon = _EnemyTeam.getChildByName("Icon" + j) as Sprite;
				if (_MonsterIcon != null) _EnemyTeam.removeChild(_MonsterIcon);
			}
			
			for (var i:String in _EnemyTeamData._objMember) {
				_CurrentMonster = _EnemyTeamData._objMember[i];
				_CurrentMonster.ShowContent();
				_MonsterIcon = _CurrentMonster.ItemIcon;
				_MonsterIcon.width = 48;
				_MonsterIcon.height = 48;
				_MonsterIcon.x = 2 + int(int(i) / 3) * 60;
				_MonsterIcon.y = 8 + (int(i) % 3) * 60;
				_MonsterIcon.name = "Icon" + i;
				_EnemyTeam.addChild(_MonsterIcon);
			}
			TweenLite.to(_EnemyTeam, 1, { x:710, alpha:1, delay:.5, ease:Back.easeOut } );
		}
		//
		private function ListBoardClickHandler(e:MouseEvent):void
		{
			if (this._CurrentListBoard.name != e.currentTarget.name) {
				TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				this._SharedEffect.MouseEffect(this._CurrentListBoard);
				this._CurrentListBoard.buttonMode = true;
				
				this.CurrentListBoard(int(e.currentTarget.name));
			}
		}
		
		public function UpDataRank(_FightStop:Boolean, _needCD:Boolean, _FightTimes:int, _RankBoard:Array, _MyTeamData:PvpCompetition, _PlayerHonor:int):void 
		{
			//_FightStop = true;
			if (_FightStop == true) this.AddChallengeBtn(6, 6);
			Text(this._Panel.getChildByName("Frequency")).ReSetString("魔鬥次數  " + _FightTimes + " / " + this._FightLimit);
			Text(this._Panel.getChildByName("Rank")).ReSetString("目前排名  " + _MyTeamData._place as String);
			Text(this._Panel.getChildByName("Count")).ReSetString("積分點數  " + _PlayerHonor + " / " + this._PlayerHonorMax);
			
			for (var j:int = 0; j < this._RankBoard.length; j++) 
			{
				if (this._Panel.getChildByName("" + j) != null) this._Panel.removeChild(this._Panel.getChildByName("" + j));
			}
			this.AddRankBoard(_RankBoard);
			
			for (var i:int = 0; i < this._RankBoard.length; i++) 
			{
				if (this._RankBoard[i]._place == int(_MyTeamData._place)) { 
					this._Place = i;
					var _MyRank:Sprite = this._RankList[i];
						_MyRank.buttonMode = false;
						_MyRank.removeEventListener(MouseEvent.CLICK, ListBoardClickHandler);
					this._SharedEffect.RemoveMouseEffect(_MyRank);
					TweenLite.to(_MyRank, 0, { glowFilter: { color:0xFF0000, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				}
			}
			if (this._Place == 0) this.CurrentListBoard(1);
			if (_FightTimes == 0) this.AddChallengeBtn(4, 4);
			if ( _needCD == true) this.AddChallengeBtn(5, 5);
		}
		
		public function UpDataPlayerHonor(_PlayerHonor:int):void 
		{
			Text(this._Panel.getChildByName("Count")).ReSetString("積分點數  " + _PlayerHonor + " / " + this._PlayerHonorMax);
		}
		
		//戰報
		public function AddReport(_DataObj:BattleResult):void 
		{
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "ReportAlphaBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			var _Panel:Sprite = new Sprite();
				_Panel.x = 373;//265 + 215-107;
				_Panel.y = 153;//25 + 255-127;
				_Panel.scaleX = 0.5;
				_Panel.scaleY = 0.5;
				_Panel.name = "ReportPanel";
			this._viewConterBox.addChild(_Panel);
			this._ReportBasisPanel = new BasisPanel(this._BGObj, _Panel, UICmdStrLib.onRemoveALL);
			this._ReportBasisPanel.AddBasisPanel("戰鬥報告", 430, 510, 256);
			this._ReportBasisPanel.AddCheckBtn("戰鬥回想", 200, 515 , 135, "Fight");
			this._ReportBasisPanel.AddCheckBtn("確認", 335, 515 , 85, "Confirm");
			this._ReportPanel.AddReportPanel(this._BGObj, _Panel, _DataObj);
			
			this._BattleId = _DataObj._battleId;
		}
		public function RemoveReport():void 
		{
			this._ReportBasisPanel = null;
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("ReportAlphaBox"));
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("ReportPanel"));
		}
		
		private function playerClickProcess(e:MouseEvent):void 
		{
			switch (e.target.name) 
			{
				case "Team":
					this.SendNotify(UICmdStrLib.GetTeam);
				break;
				case "Challenge":
					if (this._Fightable == -1 || this._Fightable == 1 || this._Fightable == 2 || this._Fightable == 3) {
						this.AddChallengeBtn(this._Fightable, this._Fightable)
					}else {
						this.AddChallengeBtn(4, 4);
						var _EnemyGuid:Object = { _Guid:this._RankBoard[int(this._CurrentListBoard.name)]._playerId };
						this.SendNotify(UICmdStrLib.GoFight, _EnemyGuid);
					}
				break;
				case "Reward":
					this.SendNotify(UICmdStrLib.Reward);
				break;
				case "Shop":
					this.SendNotify(UICmdStrLib.Init_DevilStore);
				break;
				
				case "Fight":
					var _BattleGuid:Object = { _Guid:this._BattleId };
					this.SendNotify(UICmdStrLib.Recall, _BattleGuid);
				break;
				case "Confirm":
					this.RemoveReport();
				break;
			}
		}
		
		private function AddCrewBox():Sprite 
		{
			var _Crew:Sprite = new Sprite();
			var _CrewBox:Bitmap;
			for (var i:int = 0; i < 9; i++) 
			{
				_CrewBox = new Bitmap(BitmapData(new (this._BGObj.CrewBox as Class)));
				_CrewBox.x = (i % 3) * 60;
				_CrewBox.y = int(i / 3) * 60;
				_Crew.addChild(_CrewBox);
			}
			return _Crew;
		}
		
		override public function onRemoved():void 
		{
			if (this._Panel.getChildByName("TimeBar") != null) SingleTimerBar(this._Panel.getChildByName("TimeBar")).Close();
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClickProcess);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("PVPPanel"));
			//this.SendNotify( ViewSystem_BuildCommands.MAINVIEW_CREAT );
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
	}
}