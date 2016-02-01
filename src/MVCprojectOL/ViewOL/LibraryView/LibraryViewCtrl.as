package MVCprojectOL.ViewOL.LibraryView 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.SingleTimerBar;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.SharedMethods.SchedulePanel;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.MallBtn.MallBtn;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import MVCprojectOL.ViewOL.SharedMethods.TimeConversion;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class LibraryViewCtrl extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _LibraryObj:Object;
		private var _ScheduledNum:Array;
		private var _TableBoolean:Vector.<Boolean>;
		private var _MonsterDisplay:Vector.<MonsterDisplay>;
		private var _onTabElement:Vector.<Sprite>;
		private var _CurrentTabM:int;
		private var _CtrlPageNum:int = 0;
		private var _PageList:Array = null;
		private var SkillsMenuSP:Vector.<Sprite>;
		private var _LearnFatigue:int;
		private var _LearnTime:int;
		private var _ShowTip:Sprite;
		private var _MonsterID:String;
		private var _Skill:Sprite;
		private var _SkillName:String;
		private var _Num:int = -1;
		private var _AskPanel:AskPanel = new AskPanel();
		private var _CurrentDiamond:int;
		private var _TipsView:TipsView = new TipsView("Library");//---tip---
		
		private var _SchedulePanel:SchedulePanel = new SchedulePanel();
		private var _SchedulePanelBg:Sprite;
		private var _CurrentTable:int;
		private var _MallBtn:MallBtn = new MallBtn ();
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"LEFT", _col:0xFFFFFF, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
		private var _BuildLineMax:int;
		
		private var _dicUiStr:Dictionary;
		
		public function LibraryViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			TweenPlugin.activate([GlowFilterPlugin]);
			TweenPlugin.activate([BlurFilterPlugin]);
			
			super( _InputViewName , _InputConter );
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE); 
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		
		public function BackGroundElement(_InputLibraryObj:Object, _InputObj:Object, _BuildLineMax:int, _dicUiStr:Dictionary):void
		{
			this._BGObj = _InputObj;
			this._LibraryObj = _InputLibraryObj;
			this._BuildLineMax = _BuildLineMax;
			this._dicUiStr = _dicUiStr;
			
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			
			//var _BackGround:Bitmap = new Bitmap( BitmapData( new (this._LibraryObj .bg5 as Class) )  );
			//	_BackGround.name = "BackGround";
			//this._viewConterBox.addChild( _BackGround );
			
			this._SchedulePanel.AddElement(this._BGObj, this._viewConterBox, "魔書大館",UICmdStrLib.LibraryRemoveALL);
			this._SchedulePanelBg = this._viewConterBox.getChildByName("SchedulePanel") as Sprite;
			var _TableS:Sprite = new (this._LibraryObj.Workbench as Class);
				_TableS.scaleX = 0.3;
				_TableS.scaleY = 0.3;
				_TableS.x = 2;
				_TableS.y = -5;
			Sprite(this._SchedulePanelBg.getChildByName("Tab")).addChild(_TableS);
		}
		
		//圖書館第一層
		public function OneLayer(_InputScheduledNum:Array = null):void
		{
			trace("圖書館第一層");
			var _LibraryLayer:Object = new Object();
				_LibraryLayer["Layer"] = 1;
			this.SendNotify( UICmdStrLib.LibraryLayer, _LibraryLayer);
			
			//NEW 
			var _CurrentListBoard:Sprite;
			var _TimerBar:Sprite;
			var _TableBg:Bitmap;
			//NEW 
			
			this._ScheduledNum = _InputScheduledNum;
			this._TableBoolean = new <Boolean>[false, false, false, false, false,false,false];// 檢查是否有排程
			for (var K:int = 0; K < _InputScheduledNum.length ; K++) 
			{
				this._TableBoolean[K] = true;
			}
			
			/*var _NewX:Vector.<uint> = new <uint>[130,425,720,270,575];
			var _NewY:Vector.<uint> = new <uint>[285,285,285,445,445];*/
			var _Workbench:Sprite;
			var _CandleR:Bitmap;
			var _CandleL:Bitmap;
			var _Fire:Sprite;
			var _Light:Sprite;
			var _WorkbenchBox:Vector.<Sprite> = new Vector.<Sprite>;
			for (var i:int = 0; i < this._BuildLineMax; i++ ) {
				_CurrentListBoard = this._SchedulePanelBg.getChildByName("CurrentListBoard" + i) as Sprite;
				if (_CurrentListBoard != null) { 
					_TimerBar = _CurrentListBoard.getChildByName("TimerBar") as Sprite;
					SingleTimerBar(_TimerBar).ResetTimer(ServerTimework.GetInstance().ServerTime);
				}
				
				_TableBg = this._SchedulePanelBg.getChildByName("TableBg" + i) as Bitmap;
				if (this._TableBoolean[i] == false) {
					_Workbench = new (this._LibraryObj.Workbench as Class);
					_CandleR = new Bitmap( BitmapData( new (this._LibraryObj .CandleR as Class) )  );
					_CandleR.x = 10;
					_CandleR.y = -15;
					_Workbench.addChild(_CandleR);
					_CandleL = new Bitmap( BitmapData( new (this._LibraryObj .CandleL as Class) )  );
					_CandleL.x = 140;
					_CandleL.y = -15;
					_Workbench.addChild(_CandleL);
					_Workbench.buttonMode = true;
					_WorkbenchBox.push(_Workbench);
				}else {
					_Workbench = new (this._LibraryObj.Workbench as Class);
					_CandleR = new Bitmap( BitmapData( new (this._LibraryObj .CandleR as Class) )  );
					_CandleR.x = 10;
					_CandleR.y = -15;
					_Workbench.addChild(_CandleR);
					_CandleL = new Bitmap( BitmapData( new (this._LibraryObj .CandleL as Class) )  );
					_CandleL.x = 140;
					_CandleL.y = -15;
					_Workbench.addChild(_CandleL);
					for (var j:int = 0; j < 2; j++) 
					{
						_Fire = new (this._LibraryObj.Fire as Class);
						_Fire.x = 22 + 145 * j;
						_Fire.y = -10;
						_Fire.name = "Fire" + j;
						(j == 1)?this.onCompleteShake(_Fire, true):this.onCompleteShake(_Fire, false);
						_Workbench.addChild(_Fire);
						
						_Light = new (this._LibraryObj.Light as Class);
						_Light.x = 2;
						_Light.y = -8;
						_Light.name = "Light" + j;
						(j == 1)?this.onCompleteFlicker(_Light , true ):this.onCompleteFlicker(_Light , false );
						_Fire.addChild(_Light);
					}
					_WorkbenchBox.push(_Workbench);
				}
				_WorkbenchBox[i].scaleX = 0.75;
				_WorkbenchBox[i].scaleY = 0.75;
				_WorkbenchBox[i].x = _TableBg.x + 20;
				_WorkbenchBox[i].y = _TableBg.y + 130;
				_WorkbenchBox[i].name = "Workbench" + i;
				this._SchedulePanelBg.addChild(_WorkbenchBox[i]);
				
				this.AddCompleteHandler(_WorkbenchBox[i]);
			}
		}
		
		public function LockBoiler():void 
		{
			var _TableBg:Bitmap;
			var _Workbench:Sprite;
			var _Lock:Bitmap;
			for (var i:int = this._BuildLineMax; i < 6; i++ ) {
				_TableBg = this._SchedulePanelBg.getChildByName("TableBg" + i) as Bitmap;
				_Workbench = new (this._LibraryObj.Workbench as Class);
				_Workbench.scaleX = 0.75;
				_Workbench.scaleY = 0.75;
				_Workbench.x = _TableBg.x + 20;
				_Workbench.y = _TableBg.y + 130;
				//_Workbench.name = "Workbench" + i;
				this._SchedulePanelBg.addChild(_Workbench);
				
				_Lock = new Bitmap(BitmapData(new (this._BGObj.Lock as Class)));
				_Lock.x = _TableBg.x;
				_Lock.y = _TableBg.y;
				this._SchedulePanelBg.addChild(_Lock);
			}
		}
		
		public function AddListBoard(_Num:int, _Monster:MonsterDisplay, _CurrentSkillPic:BitmapData, _InputTimerBar:Sprite):void 
		{
			var _ListBoard:Sprite = new Sprite();
				_ListBoard.x = 60;
				_ListBoard.y = 155 + _Num * 65;
				_ListBoard.name = "CurrentListBoard" + _Num;
			this._SchedulePanelBg.addChild(_ListBoard);
			_Monster.ShowContent();
			
			var _MonsterHead:Sprite = _Monster.MonsterHead;
				_MonsterHead.width = 48;
				_MonsterHead.height = 48;
			_ListBoard.addChild(_MonsterHead);
			
			this._TextObj._str = _Monster.MonsterData._showName;
			var _MonsterName:Text = new Text(this._TextObj);
				_MonsterName.x = 55;
				_MonsterName.y = 3;
			_ListBoard.addChild(_MonsterName);
			
			var _CurrentSkill:Bitmap = new Bitmap(_CurrentSkillPic);
				_CurrentSkill.x = _MonsterName.x + _MonsterName.width;
				_CurrentSkill.y = 2;
			_ListBoard.addChild(_CurrentSkill);
			
			var _TimerBar:Sprite = _InputTimerBar;
				_TimerBar.x = -40;
				_TimerBar.y = 15;
				_TimerBar.name = "TimerBar";
			_ListBoard.addChild(_TimerBar);
			SingleTimerBar(_TimerBar).StarTimes();
			
			var _DiamondBtn:Sprite = new Sprite();
			var _Diamond:Bitmap = new Bitmap(BitmapData(new (this._BGObj.Diamond as Class)));
				_DiamondBtn.addChild(_Diamond);
				_DiamondBtn.scaleX = 0.5;
				_DiamondBtn.scaleY = 0.5;
				_DiamondBtn.x = 155;
				_DiamondBtn.y = 20;
				_DiamondBtn.name = "" + _Num;
			//(this._ScheduledNum[i]._schID != "")?_DiamondBtn.visible = true:_DiamondBtn.visible = false;
			_ListBoard.addChild(_DiamondBtn);
			this._MallBtn.AddMallBtn(_DiamondBtn);
		}
		public function RemoveListBoard(_Length:int, _CurrentNum:int):void 
		{
			var _CurrentNumber:int;
			(_CurrentNum != -1)?_CurrentNumber = _CurrentNum:_CurrentNumber = 0;
			
			var _CurrentListBoard:Sprite = this._SchedulePanelBg.getChildByName("CurrentListBoard" + _CurrentNumber) as Sprite;
			var _TimerBar:Sprite = _CurrentListBoard.getChildByName("TimerBar") as Sprite;
			SingleTimerBar(_TimerBar).Close();
			this._SchedulePanelBg.removeChild(_CurrentListBoard);
			
			var _ListBoard:Sprite = this._SchedulePanelBg.getChildByName("ListBoard"+_CurrentNumber) as Sprite;
				_ListBoard.name = "ListBoard6";
				_ListBoard.alpha = 0;
				_ListBoard.x = 270;
				_ListBoard.y = 470;
			TweenLite.to(_ListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
			
			var _Num:int;
			var _LengthNum:int = _Length + 1;
			for (var i:int = _CurrentNumber + 1; i < 6; i++) 
			{
				_ListBoard = this._SchedulePanelBg.getChildByName("ListBoard" + i) as Sprite;
				_Num = i - 1;
				_ListBoard.name = "ListBoard" + _Num;
				TweenLite.to(_ListBoard, 1, { y:145 + _Num * 65 } );
				TweenLite.to(_ListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				if (i < _LengthNum) { 
					_CurrentListBoard = this._SchedulePanelBg.getChildByName("CurrentListBoard" + i) as Sprite;
					_CurrentListBoard.name = "CurrentListBoard" + _Num;
					_CurrentListBoard.getChildByName("" + i).name = "" + _Num;
					TweenLite.to(_CurrentListBoard, 1, { y:155 + _Num * 65 } );
				}
			}
			_ListBoard = this._SchedulePanelBg.getChildByName("ListBoard6") as Sprite;
			_ListBoard.name = "ListBoard5";
			TweenLite.to(_ListBoard, 1, { x:45, alpha:1 } );
		}
		private function RemoveTimeBar():void 
		{
			var _CurrentListBoard:Sprite;
			var _TimerBar:Sprite;
			for (var i:int = 0; i < 6; i++) 
			{
				_CurrentListBoard = this._SchedulePanelBg.getChildByName("CurrentListBoard" + i) as Sprite;
				if (_CurrentListBoard != null) { 
					_TimerBar = _CurrentListBoard.getChildByName("TimerBar") as Sprite;
					SingleTimerBar(_TimerBar).Remove();
				}
			}
		}
		
		/*public function DiamondBtnVisible():void 
		{
			for (var i:int = 0; i < 5; i++ ) {
				if (this._TableBoolean[i] == true) Sprite(this._viewConterBox.getChildByName("" + i)).visible = true;
			}
		}*/
		
		//燭火搖動
		private function onCompleteShake(target:Object,isLeft:Boolean):void 
		{
			TweenLite.to(target, 2, { rotation:isLeft ? -int(Math.random()*15) : int(Math.random()*15) , onComplete:this.onCompleteShake , onCompleteParams : [target, !isLeft] } );
		}
		//燭光放大縮小
		private function onCompleteFlicker(target:Object,isLeft:Boolean):void 
		{
			TweenLite.to(target, 1, { scaleX:isLeft ? 1.3 : 1 ,scaleY:isLeft ? 1.3 : 1, onComplete:this.onCompleteFlicker , onCompleteParams : [target, !isLeft] } );
		}
		private function AddCompleteHandler(_InputMC:*):void
		{
			this.WorkbenchbtnFactory(_InputMC);
		}
		private function WorkbenchbtnFactory(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, WorkbenchbtnChange);
			btn.addEventListener(MouseEvent.ROLL_OUT, WorkbenchbtnChange);
			btn.addEventListener(MouseEvent.MOUSE_MOVE, WorkbenchbtnChange);
		}
		private function WorkbenchbtnChange(e:MouseEvent):void 
		{
			var _Num:int = int(e.currentTarget.name.substr(9, 1));
			switch (e.type) 
			{
				case "rollOver":
					TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
					this.JudgeTip(_Num);
				(this._TableBoolean[_Num] == false)?this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Library", ProxyPVEStrList.TIP_STRBASIC, "GLOBAL_TIP_SCHEDULING03", "", null, e.stageX, e.stageY)):
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				break;
				case "rollOut":
					TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
					this.RemoveTip(_Num);
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				break;
				case "mouseMove":
					(this._TableBoolean[_Num] == false)?TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).TipsMove(e.stageX, e.stageY):null;
				break;
			}
		}
		private function JudgeTip(_Num:int):void
		{
			if (this._TableBoolean[_Num] == true) this.TipMessage(_Num, true);
		}
		private function TipMessage(_InputNum:int, _CtrlBoolean:Boolean):void
		{
			var _ListBoard:Sprite = Sprite(this._SchedulePanelBg.getChildByName("ListBoard" + _InputNum));
			(_CtrlBoolean == true)?TweenLite.to(_ListBoard, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} ):
			TweenLite.to(_ListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
			/*var _TipMessage:Object = new Object();
				_TipMessage["Tip"] = this._ScheduledNum[_InputNum]._tipsInfo;
				_TipMessage["needTime"] = this._ScheduledNum[_InputNum]._needTime;
				_TipMessage["finishTime"] = this._ScheduledNum[_InputNum]._finishTime;
				_TipMessage["_learning"] = this._ScheduledNum[_InputNum]._learning;
				_TipMessage["BoilerName"] = _InputName;
			this.SendNotify( UICmdStrLib.ShowTip, _TipMessage);*/
		}
		//創建Tip
		public function AddTip(_InputSpr:Sprite, _InputBoilerName:String):void
		{
			if (this._ShowTip == null) {
				this._ShowTip = _InputSpr;
				this._viewConterBox.addChild(this._ShowTip );
			}else {
				this._viewConterBox.setChildIndex(this._ShowTip, this._viewConterBox.numChildren - 1);
			}
			this._ShowTip.x = this._viewConterBox.getChildByName(_InputBoilerName).x - this._ShowTip.width / 2 + this._viewConterBox.getChildByName(_InputBoilerName).width / 2;
			this._ShowTip.y = this._viewConterBox.getChildByName(_InputBoilerName).y - this._ShowTip.height - 40;
		}
		private function RemoveTip(_Num:int):void
		{
			if (this._TableBoolean[_Num] == true) this.TipMessage(_Num, false);
		}
		
		//移除
		public function RemoveBoiler():void
		{
			var _WorkbenchBox:Sprite;
			for (var i:int = 0; i < this._BuildLineMax; i++) {
					if (this._TableBoolean[i] == true && this._viewConterBox.getChildByName("" + i) != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("" + i));
					_WorkbenchBox = Sprite(this._SchedulePanelBg.getChildByName("Workbench" + i));
					this.RemoveWorkbenchbtnFactory(_WorkbenchBox);
					this.RemoveCompleteHandler(_WorkbenchBox);
				}
		}
		private function RemoveCompleteHandler(_InputMC:*):void
		{
			this._SchedulePanelBg.removeChild(_InputMC);
		}
		private function RemoveWorkbenchbtnFactory(btn:*):void 
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, WorkbenchbtnChange);
			btn.removeEventListener(MouseEvent.ROLL_OUT, WorkbenchbtnChange);
		}
		
		private function playerClickProcess(e:MouseEvent):void 
		{
			var name:String = e.target.name;
			//var _Num:int = int(name.substr(9, 1));
			//if (this._TableBoolean[_Num] == false) this.RemoveOneLayer();
			switch (name) 
			{
				//排程
				case "Workbench0":
					if (this._TableBoolean[0] == false) this.RemoveOneLayer();	
				break;
				case "Workbench1":
					if (this._TableBoolean[1] == false) this.RemoveOneLayer();
				break;
				case "Workbench2":
					if (this._TableBoolean[2] == false) this.RemoveOneLayer();	
				break;
				case "Workbench3":
					if (this._TableBoolean[3] == false) this.RemoveOneLayer();	
				break;
				case "Workbench4":
					if (this._TableBoolean[4] == false) this.RemoveOneLayer();
				break;
				case "Workbench5":
					if (this._TableBoolean[5] == false) this.RemoveOneLayer();
				break;
			}
		}
		
		private function RemoveOneLayer():void
		{
			this.RemoveBoiler();
			this.SecondLayer();//圖書館第二層
		}
		
		private function SecondLayer():void
		{
			this.SendNotify( UICmdStrLib.MonsterMenu );
		}
		
		public function MonsterMenuElement(_InputMonsterDisplayList:Vector.<MonsterDisplay>):void
		{
			TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
			var _CurrentListBoard:Sprite;
			var _TimerBar:Sprite;
			for (var i:int = 0; i < this._BuildLineMax; i++) 
			{
				_CurrentListBoard = this._SchedulePanelBg.getChildByName("CurrentListBoard" + i) as Sprite;
				if (_CurrentListBoard != null) { 
					_TimerBar = _CurrentListBoard.getChildByName("TimerBar") as Sprite;
					SingleTimerBar(_TimerBar).Close();
				}
			}
			
			trace("圖書館第二層");
			var _LibraryLayer:Object = new Object();
				_LibraryLayer["Layer"] = 2;
			this.SendNotify( UICmdStrLib.LibraryLayer, _LibraryLayer);
			
			this._MonsterDisplay = _InputMonsterDisplayList;
			/*this._MonsterDisplay = new Vector.<MonsterDisplay>;
			for (var i:int = 0; i < _InputMonsterDisplayList.length; i++) {
				(_InputMonsterDisplayList[i].MonsterData._useing == 2 )?null:this._MonsterDisplay.push(_InputMonsterDisplayList[i]);
			}*/
			var _AddMonsterMenu:Object = new Object();
				_AddMonsterMenu["Monster"] = this._MonsterDisplay;
				_AddMonsterMenu["BGObj"] = this._BGObj;
			this.SendNotify( UICmdStrLib.AddMonsterMenu, _AddMonsterMenu);
		}
		
		public function UpdateMonsterMenu(_SkillGroup:uint, _InputMonsterDisplayList:Vector.<MonsterDisplay> = null):void
		{
			(_InputMonsterDisplayList != null)?this._MonsterDisplay = _InputMonsterDisplayList:null;
			var _MonsterDisplay:Vector.<MonsterDisplay> = new Vector.<MonsterDisplay>;
			for (var i:int = 0; i < this._MonsterDisplay.length; i++) 
			{
				if (this._MonsterDisplay[i].MonsterData._learnSkill[_SkillGroup] == 1) _MonsterDisplay.push(this._MonsterDisplay[i]);
			}
			var _UpdateMonsterMenu:Object = new Object();
				_UpdateMonsterMenu["Monster"] = _MonsterDisplay;
			this.SendNotify( UICmdStrLib.UpdateMonsterMenu, _UpdateMonsterMenu);
		}
		
		public function AddPanel():void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
			
			var _BgM:Sprite = new (this._BGObj.BgM as Class);
				_BgM.width = 440;//960
				_BgM.height = 180;//510
				_BgM.x = 510;
				_BgM.y = 150;
			_Panel.addChild(_BgM);
			
			var _Box:Bitmap;
			for (var i:int = 0; i < 24; i++) 
			{
				_Box = new Bitmap(BitmapData(new(this._BGObj.Box as Class)));
				_Box.x = 521 + ( i % 8 ) * (48 + 5);
				_Box.y = 163 + ( int( i / 8 ) * (48 + 5));
				_Panel.addChild(_Box);
			}
			
			var _PageBtnS:MovieClip;
			for (var j:int = 0; j < 2; j++) 
			{
				_PageBtnS = new (this._BGObj.PageBtnS as Class);
				_PageBtnS.x = 700 + j * 80;
				_PageBtnS.y = 330;
				(j == 0)?_PageBtnS.name = "btn2":_PageBtnS.name = "btn3";
				if (_PageBtnS.name == "btn2") _PageBtnS.scaleX = -1;
				_PageBtnS.addEventListener(MouseEvent.CLICK, _onClickHandler);
				_PageBtnS.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler);
				_PageBtnS.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler);
				_Panel.addChild(_PageBtnS);
			}
			
			_TextObj._str = "0" +" / " +"0";
			var _PageText:Text = new Text(_TextObj);
				_PageText.x = 724;
				_PageText.y = 330;
				_PageText.name = "SkillPageText";
				//_PageText.mouseEnabled = false;
			_Panel.addChild(_PageText);
			
			var _ContentBg:Bitmap;
			for (var k:int = 0; k < 2; k++) 
			{
				_ContentBg = new Bitmap(BitmapData(new(this._BGObj.ContentBg as Class)));
				_ContentBg.x = 510;
				(k == 0)?_ContentBg.y = 355:_ContentBg.y = 445;
				_Panel.addChild(_ContentBg);
			}
			
			var _ContentBgText:TextField = new TextField();
				_ContentBgText.multiline = true;
				_ContentBgText.x = 555;
				_ContentBgText.y = 480;
				_ContentBgText.width = 500;
				_ContentBgText.mouseEnabled = false;
				_ContentBgText.htmlText = this._dicUiStr["LIB_TIP_INTRO1"];
			_Panel.addChild(_ContentBgText);	
			
			var _Fatigue:Bitmap = new Bitmap(BitmapData(new(this._BGObj.Fatigue as Class)));
				_Fatigue.scaleX = 0.7;
				_Fatigue.scaleY = 0.7;
				_Fatigue.x = 715;
				_Fatigue.y = 385;
			_Panel.addChild(_Fatigue);
			
			var _Hourglass:Bitmap = new Bitmap(BitmapData(new(this._BGObj.Hourglass as Class)));
				_Hourglass.scaleX = 0.7;
				_Hourglass.scaleY = 0.7;
				_Hourglass.x = 570;
				_Hourglass.y = 385;
			_Panel.addChild(_Hourglass);
			
			var _SoulText:Text = new Text(_TextObj);
				_SoulText.x = 760;
				_SoulText.y = 395;
				_SoulText.name = "SoulText";
			_Panel.addChild(_SoulText);
			
			var _TimerText:Text = new Text(_TextObj);
				_TimerText.x = 630;
				_TimerText.y = 395;
				_TimerText.name = "TimerText";
			_Panel.addChild(_TimerText);
			
			var _CheckBtn:MovieClip = new (this._BGObj.CheckBtn as Class);
				_CheckBtn.width = 85;	
				_CheckBtn.x = 835;
				_CheckBtn.y = 385;
				_CheckBtn.name = "CheckBtn";
				_CheckBtn.buttonMode = true;
				_CheckBtn.visible = false;
				this._SharedEffect.MovieClipMouseEffect(_CheckBtn);
				_CheckBtn.addEventListener(MouseEvent.CLICK, CheckBtnHandler);
			_Panel.addChild(_CheckBtn);
			_TextObj._str = "確認";
			var _CheckBtnText:Text = new Text(_TextObj);
				_CheckBtnText.x = 45;
				_CheckBtnText.y = 10;
			_CheckBtn.addChild(_CheckBtnText);
			this._TipsView.MouseEffect(_CheckBtn);
			
			this.Tab();
		}
		
		private function Tab():void
		{
			var _Attack:Sprite = new (this._LibraryObj.Attack as Class);
				_Attack.name = "0";
			this._TipsView.MouseEffect(_Attack);
			//var _Guard:Sprite = new (this._LibraryObj.Guard as Class);
				//_Guard.name = "1";
			var _Gain:Sprite = new (this._LibraryObj.Gain as Class);
				_Gain.name = "2";
			this._TipsView.MouseEffect(_Gain);
			var _Debuff:Sprite = new (this._LibraryObj.Debuff as Class);
				_Debuff.name = "3";
			this._TipsView.MouseEffect(_Debuff);
			//var _Dot:Sprite = new (this._LibraryObj.Dot as Class);
				//_Dot.name = "4";
			var _Recovery:Sprite = new (this._LibraryObj.Recovery as Class);
				_Recovery.name = "1";
			this._TipsView.MouseEffect(_Recovery);
			//var _Control:Sprite = new (this._LibraryObj.Control as Class);
				//_Control.name = "6";
			
			this._onTabElement = new < Sprite > [_Attack,_Recovery, _Gain, _Debuff];
			this._CurrentTabM = 0;
			this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
			
			var _CurrentTab:Object = new Object();
				_CurrentTab["guid"] = this._onTabElement[0].name;
			this.SendNotify( UICmdStrLib.CurrentSkills, _CurrentTab);
		}
		private function TabMFactory(_InputSP:Sprite,InputNum:int):void
		{
			var _TabElement:Sprite = _InputSP;
				_TabElement.x = 6;
				_TabElement.y = -7;
				_TabElement.scaleX = 0.75;
				_TabElement.scaleY = 0.75;
			//TweenLite.to(_TabElement, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
			//_TabElement.filters = [];
			var _TabM:MovieClip = new  (this._BGObj.Tab as Class);
				_TabM.x = 512 + InputNum * 62;//160 + InputNum * 97;
				_TabM.y = 125;
				_TabM.gotoAndStop(2);
				_TabM.buttonMode = true;
				_TabM.name = "" + InputNum;
				_TabM.addChild(_TabElement);
			Sprite(this._viewConterBox.getChildByName("Panel")).addChild(_TabM);
			for (var i:int = 0; i < this._onTabElement.length; i++)(i == this._CurrentTabM)?null:this.TabSFactory(this._onTabElement[i], i);
		}
		private function TabSFactory(_InputSP:Sprite,InputNum:int):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _TabElement:Sprite = _InputSP;
				_TabElement.x = 6;
				_TabElement.y = -5;
				_TabElement.name = this._onTabElement[InputNum].name;
				_TabElement.scaleX = 0.75;
				_TabElement.scaleY = 0.75;
			TweenLite.to(_TabElement, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
			var _TabS:MovieClip = new  (this._BGObj.Tab as Class);
				_TabS.scaleX = 0.6;
				_TabS.scaleY = 0.6;
				(this._CurrentTabM < InputNum)?_TabS.x = _Panel.getChildByName("" + this._CurrentTabM).x + (InputNum - this._CurrentTabM) * 50:_TabS.x = _Panel.getChildByName("" + this._CurrentTabM).x - (this._CurrentTabM - InputNum) * 50;
				_TabS.y = 130;
				_TabS.buttonMode = true;
				_TabS.name = "" + InputNum;
				_TabS.addChild(_TabElement);
			_Panel.addChild(_TabS);
			this.move(_TabS, InputNum);
		}
		private function move(_InputSP:Sprite,InputNum:int):void
		{
			if (InputNum == this._CurrentTabM ) {
				this.removebtnFactory(_InputSP);
				Sprite(this._viewConterBox.getChildByName("Panel")).removeChild(_InputSP);
				this.TabMFactory(this._onTabElement[InputNum], InputNum);
			}else if (InputNum != this._CurrentTabM&&this._CurrentTabM > -1 ){
				TweenLite.to(_InputSP, 0.2, { x:512 + InputNum * 62, y:125, scaleX:1, scaleY:1,onComplete:btnFactoryHandler,onCompleteParams:[_InputSP] } );
			}
		}
		private function btnFactoryHandler(_InputSP:Sprite):void
		{
			this.btnFactory(_InputSP);
		}
		private function btnFactory(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, btnStatus);
			btn.addEventListener(MouseEvent.ROLL_OUT, btnStatus);
			btn.addEventListener(MouseEvent.CLICK, btnStatus);
		}
		private function btnStatus(e:MouseEvent):void 
		{
			var _CurrentTabM:Sprite = Sprite(e.currentTarget);
			switch (e.type) 
			{
				case "click":
					this._CurrentTabM = int(e.currentTarget.name);
					this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
					var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
					if (_Panel.getChildByName("MsgText") != null) this.RemoveMsg();
					for (var i:int = 0; i < this._onTabElement.length; i++) 
					{
						Sprite(this._onTabElement[i]).filters = [];
						this.removebtnFactory(_Panel.getChildByName(""+i));
						_Panel.removeChild(_Panel.getChildByName(""+i));
					}
					
					if (this.SkillsMenuSP.length != 0) { 
						for (var j:int = 0; j < this.SkillsMenuSP.length ; j++) {
						_Panel.removeChild(this.SkillsMenuSP[j]);
						}
					}
					
					var _CurrentTab:Object = new Object();
						_CurrentTab["guid"] = this._onTabElement[int(e.currentTarget.name)].name;
					this.SendNotify( UICmdStrLib.CurrentSkills, _CurrentTab);
				break;
				case "rollOver":
					Sprite(_CurrentTabM.getChildByName(e.currentTarget.name)).filters = [];
				break;
				case "rollOut":
					TweenLite.to(Sprite(_CurrentTabM.getChildByName(e.currentTarget.name)), .01, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
				break;
			}
		}
		private function removebtnFactory(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, btnStatus);
			btn.removeEventListener(MouseEvent.ROLL_OUT, btnStatus);
			btn.removeEventListener(MouseEvent.CLICK, btnStatus);
		}
		
		//關閉確認按鈕
		public function CloseCheckBtn():void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			if (_Panel.getChildByName("CheckBtn") != null ) {
				var _CheckBtn:MovieClip = MovieClip(_Panel.getChildByName("CheckBtn"));
					_CheckBtn.visible = false;
			}
		}
		
		//技能列表
		public function SkillsList(_InputListBoardMenu:Vector.<SkillDisplay>, _InputLearnSoul:int, _InputLearnTime:int):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			this._LearnFatigue = _InputLearnSoul;
			Text(_Panel.getChildByName("SoulText")).ReSetString(String(this._LearnFatigue));
			this._LearnTime = _InputLearnTime;
			var _TimeConversion:TimeConversion = new TimeConversion();	
			Text(_Panel.getChildByName("TimerText")).ReSetString(_TimeConversion.TimerConversion(this._LearnTime));
			
			this._CtrlPageNum = 0;
			var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
			this._PageList = _SplitPageMethod.SplitPage(_InputListBoardMenu, 24);
			
			var _Btn0:MovieClip = MovieClip(_Panel.getChildByName("btn2"));
			var _Btn1:MovieClip = MovieClip(_Panel.getChildByName("btn3"));
			if (this._PageList.length != 0 && this._PageList.length != 1)  {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = true;
			}else {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = false;
			}
			
			this._PageList.length != 0?Text(_Panel.getChildByName("SkillPageText")).ReSetString(this._CtrlPageNum + 1 + " / " + this._PageList.length):Text(_Panel.getChildByName("SkillPageText")).ReSetString(this._CtrlPageNum + " / " + this._PageList.length);
			this._PageList.length != 0?this.CtrlPage(this._CtrlPageNum):null;
		}
		private function CtrlPage( _InputPage:int ):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			Text(_Panel.getChildByName("SkillPageText")).ReSetString(this._CtrlPageNum + 1 + " / " + this._PageList.length);
			var _MyPage:Array = this._PageList[_InputPage];
			var _MyPageLength:uint = _MyPage.length;
			this.SkillsMenuSP = new Vector.<Sprite>;
			
			for (var i:int = 0; i < _MyPageLength ; i++) {
				_MyPage[i].ShowContent();
				this.SkillsMenuSP.push(_MyPage[i].Icon);
				this.SkillsMenuSP[i].width = 48;
				this.SkillsMenuSP[i].height = 48;
				this.SkillsMenuSP[i].x = 521 + ( i % 8 ) * (48 + 5);
				this.SkillsMenuSP[i].y = 163 + ( int( i / 8 ) * (48 + 5));
				this.SkillsMenuSP[i].name = _MyPage[i].ID;
				SkillsMenuSP[i].addEventListener(MouseEvent.ROLL_OVER, SkillsRollOver);
				SkillsMenuSP[i].addEventListener(MouseEvent.ROLL_OUT, SkillsRollOut);
				_Panel.addChild(this.SkillsMenuSP[i]);
			}
			
		}
		
		private function SkillsRollOver(e:MouseEvent):void
		{
			var _CurrentSkill:Sprite = Sprite(e.target);
			this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("LibrarySkill", ProxyPVEStrList.TIP_STRBASIC, "SysTip_SKL", ProxyPVEStrList.LIBRARY_SKILLTips, e.currentTarget.name , (_CurrentSkill.x >= 733)?_CurrentSkill.x + 48:_CurrentSkill.x - 5 , _CurrentSkill.y + 30 ));
			TweenLite.to(_CurrentSkill, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
		}
		private function SkillsRollOut(e:MouseEvent):void
		{
			TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
			TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
		}
		
		public function StartButton():void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _CheckBtn:MovieClip = MovieClip(_Panel.getChildByName("CheckBtn"));
				_CheckBtn.visible = true;
			if (_Panel.getChildByName("MsgText") != null) this.RemoveMsg();
		}
		
		private function CheckBtnHandler(e:MouseEvent):void
		{
			this.SendNotify( UICmdStrLib.UseMonsterMenu);
		}
		
		//----檢查怪獸學習技能的狀況
		//---0=技能以滿,詢問是否附蓋/1=技能尚有空位/2=error(沒有該怪獸的資料/怪獸不存在)/3=怪獸目前疲勞滿百無法使用/4=金錢不夠
		public function CheckMonsterStatus(_InputNum:int, _MonsterID:String, _SkillGroup:int):void
		{
			switch (String(_InputNum))
			{
				case "0":
					var _ChangeSkills:Object = new Object();
						_ChangeSkills["guid"] = _MonsterID;
						_ChangeSkills["SkillGroup"] = _SkillGroup;
					this.SendNotify( UICmdStrLib.ChangeSkills, _ChangeSkills);
				break;
				case "1":
					var _LearningSkills:Object = new Object();
						_LearningSkills["guid"] = _MonsterID;
					this.SendNotify( UICmdStrLib.LearningSkills, _LearningSkills);
				break;
				case "2":
					this.Msg("惡魔資料有誤");
				break;
				case "3":
					this.Msg("惡魔疲勞中");
				break;
				case "4":
					this.Msg("金錢不足");
				break;
			}
		}
		//顯示2.3.4狀況
		private function Msg(_InputMsg:String):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			if (_Panel.getChildByName("MsgText") == null) { 
				var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:20, _bold:true, _font:"Times New Roman", _leading:null };
					_TextObj._str = _InputMsg;
				var _MsgText:Text= new Text(_TextObj);
					_MsgText.x = 560;
					_MsgText.y = 480;
					_MsgText.name = "MsgText";
				_Panel.addChild(_MsgText);
			}
			
		}
		private function RemoveMsg():void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			_Panel.removeChild(_Panel.getChildByName("MsgText"));
		}
		
		//替換技能
		public function ChangeSkill(_InputSkill:SkillDisplay, _SkillGroup:int, _MonsterID:String):void
		{
			/*var _LibraryLayer:Object = new Object();
				_LibraryLayer["Layer"] = 3;
			this.SendNotify( UICmdStrLib.LibraryLayer, _LibraryLayer);*/
			
			this._MonsterID = _MonsterID;
			
			this.AddInform();
			var _Inform:Sprite = this._viewConterBox.getChildByName("Inform") as Sprite;
			
			var _SkillList:MovieClip = new (this._LibraryObj.SkillList as Class);
				_SkillList.x = 155;
				_SkillList.y = 70;
				_SkillList.gotoAndStop(_SkillGroup - 1);
			_Inform.addChild(_SkillList);
				
			var _currentTarget:SkillDisplay;
				_currentTarget = _InputSkill;
				_currentTarget.ShowContent();
			this._Skill=(_currentTarget.Icon);
			this._Skill.x = 215;
			this._Skill.y = 60;
			this._Skill.name = _currentTarget.ID;
			_Inform.addChild(this._Skill);
			
			this._AskPanel.AddMsgText("是否將「舊技能」更新為「新技能」", 65, 150);
			this._viewConterBox.addEventListener(MouseEvent.CLICK, InformClickHandler);
		}
		public function AddInform():void 
		{
			this._AskPanel.AddInform();
		}
		//商城
		public function GetPay(_Price:uint, _Name:int):void 
		{
			/*trace("圖書館第三層");
			var _LibraryLayer:Object = new Object();
				_LibraryLayer["Layer"] = 3;
			this.SendNotify( UICmdStrLib.LibraryLayer, _LibraryLayer);*/
			
			this._CurrentDiamond = _Name;
			//Sprite(this._viewConterBox.getChildByName("" + this._CurrentDiamond)).visible = false;
			this._AskPanel.AddMsgText(" 快速完成排程需要支付" + _Price + "晶鑽", 65);
			this._viewConterBox.addEventListener(MouseEvent.CLICK, PayClickHand);
		}
		//商城是否加速
		private function PayClickHand(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "Make0"://yes
					Sprite(Sprite(this._SchedulePanelBg.getChildByName("CurrentListBoard" + this._CurrentDiamond)).getChildByName("" + this._CurrentDiamond)).visible = false;
					var _Num:Object = { _Num:this._CurrentDiamond };
					this.SendNotify(UICmdStrLib.Consumption, _Num);
					this.RemoveInform(true);
				break;
				case "Make1"://no
					//Sprite(this._SchedulePanelBg.getChildByName("" + this._CurrentDiamond)).visible = true;
					this._CurrentDiamond = -1;
					TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:393, y:255, scaleX:0.5, scaleY:0.5 , onComplete:RemoveInform, onCompleteParams:[true] } );
					this.SendNotify( UICmdStrLib.RecoverBtn );
				break;
			}
		}
		//是否更換技能
		private function InformClickHandler(e:MouseEvent) :void
		{
			switch(e.target.name)
			{
				case "Make0":
					var _LearningSkills:Object = new Object();
						_LearningSkills["guid"] = this._MonsterID;
						_LearningSkills["SkillName"] = this._Skill.name;
					this.SendNotify( UICmdStrLib.LearningChangeSkills, _LearningSkills);
				break;
				case "Make1":
					TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:393, y:255, scaleX:0.5, scaleY:0.5 ,onComplete:RemoveInform } );
				break;
			}
		}
		
		public function RemoveInform(_CtrlBoolean:Boolean = false):void
		{
			if (_CtrlBoolean == false) { 
				TweenLite.to(this._Skill, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				this.RemoveMouseEffect(this._Skill);
			}
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, PayClickHand);
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, InformClickHandler);
			this._AskPanel.RemovePanel();
		}
		
		//頁數控制按鈕
		private function _onClickHandler(e:MouseEvent):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
				switch(e.currentTarget.name)
				{
					case "btn0":
						if (this._CtrlPageNum != 0) {
							this._CtrlPageNum == this._PageList.length-1?MovieClip(_Panel.getChildByName("btn1")).gotoAndStop(1):null;
							this._CtrlPageNum == 1?MovieClip(e.currentTarget).gotoAndStop(1):null;
							this._CtrlPageNum <= 0?this._CtrlPageNum = this._CtrlPageNum:(this._CtrlPageNum --) && (this.CtrlPage(this._CtrlPageNum));
						}
						break;
					case "btn1":
						if (this._CtrlPageNum != this._PageList.length - 1 && this._PageList.length > 1) {
							this._CtrlPageNum == 0?MovieClip(_Panel.getChildByName("btn0")).gotoAndStop(1):null;
							this._CtrlPageNum == this._PageList.length-2?MovieClip(e.currentTarget).gotoAndStop(1):null;
							this._CtrlPageNum ++;
							this._CtrlPageNum < this._PageList.length?this.CtrlPage(this._CtrlPageNum):this._CtrlPageNum --;
						}
						break;
				}
			this._CtrlPageNum == 0?Sprite(_Panel.getChildByName("btn0")).buttonMode = false:Sprite(_Panel.getChildByName("btn0")).buttonMode = true;
			(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1) ?Sprite(_Panel.getChildByName("btn1")).buttonMode = false:Sprite(_Panel.getChildByName("btn1")).buttonMode = true;
		}
		private function _onRollOverBtnHandler(e:MouseEvent):void
		{
			switch(e.currentTarget.name)
				{
					case "btn0":
						this._CtrlPageNum == 0?MovieClip(e.currentTarget).gotoAndStop(1):MovieClip(e.currentTarget).gotoAndStop(2);
						break;
					case "btn1":
						(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1)?MovieClip(e.currentTarget).gotoAndStop(1):MovieClip(e.currentTarget).gotoAndStop(2);
						break;
				}
		}
		private function _onRollOutBtnHandler(e:MouseEvent):void
		{
			switch(e.currentTarget.name)
				{
					case "btn0":
						this._CtrlPageNum == 0?MovieClip(e.currentTarget).gotoAndStop(1):MovieClip(e.currentTarget).gotoAndStop(1);
						break;
					case "btn1":
						(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1)?MovieClip(e.currentTarget).gotoAndStop(1):MovieClip(e.currentTarget).gotoAndStop(1);
						break;
				}
		}
		
		//滑鼠滑入滑出效果
		private function MouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
		}
		private function BtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					 TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				break;
				case "rollOut":
					 TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				break;
				
			}
		}
		//移除滑入滑出效果
		private function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
		}
		
		override public function onRemoved():void 
		{
			this.RemoveTimeBar();
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClickProcess);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("ScheduleBox"));
			this._viewConterBox.removeChild(this._SchedulePanelBg);
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
	}
}