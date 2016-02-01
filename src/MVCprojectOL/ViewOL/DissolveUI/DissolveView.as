package MVCprojectOL.ViewOL.DissolveUI 
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin; 
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.SingleTimerBar;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.SharedMethods.SchedulePanel;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.MallBtn.MallBtn;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.SoarVision.single.BitmapVision;
	import Spark.SoarVision.single.SpriteVision;
	import Spark.Utils.Text;
	import strLib.commandStr.DissolveStrLib;
	import com.greensock.plugins.BlurFilterPlugin; 
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.easing.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import Spark.coreFrameWork.View.ViewCtrl;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class DissolveView extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _SharedObj:Object;
		
		private var _MonsterDisplay:Vector.<MonsterDisplay>;
		private var _PageList:Array;
		private var _SlidingControl:SlidingControl;
		private var _MenuBGObj:Object;
		private var _CurrentMonster:Sprite = new Sprite();
		private var _BoilerFireBoolean:Vector.<Boolean>;
		private var _FireBoilerBox:Vector.<SpriteVision>;
		private var _DissoLv:Object = new Object();
		private var MonsterMenuSP:Vector.<Sprite>;
		private var _ScheduledNum:Array;
		private var _CurrentListBoard:Sprite = new Sprite();
		private var _TxtFormat:TextFormat = new TextFormat();
		
		private var _ShowTip:Sprite;
		private var _schFlag:Boolean = false;
		private var _AskPanel:AskPanel = new AskPanel();
		private var _CurrentDiamond:int;
		
		private var _SchedulePanel:SchedulePanel = new SchedulePanel();
		private var _SchedulePanelBg:Sprite;
		private var _CurrentTable:int;
		private var _MallBtn:MallBtn = new MallBtn ();
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"LEFT", _col:0xFFFFFF, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
		private var _BuildLineMax:int;
		
		public function DissolveView(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			TweenPlugin.activate([BlurFilterPlugin]);
			TweenPlugin.activate([GlowFilterPlugin]);
			
			super( _InputViewName , _InputConter );
		}
		
		//熔解所第一層
		public function BackGroundElement(_InputObj:Object, _InputFireBoiler:Vector.<SpriteVision>, _InputSharedObj:Object, _BuildLineMax:int):void
		{
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE); 
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			(Sprite(this._viewConterBox.getChildByName("DialogBox")) != null)?this._viewConterBox.removeChild(Sprite(this._viewConterBox.getChildByName("DialogBox"))):null;
			trace("熔解所第一層");
			this._BuildLineMax = _BuildLineMax;
			this._SharedObj = _InputSharedObj;
			this._BGObj = _InputObj;
			this._FireBoilerBox = _InputFireBoiler;
			/*var _bg:Bitmap = new Bitmap( BitmapData( new (this._BGObj.bg2 as Class) )  );
				_bg.name = "backGround";
				this._DisplayBox.addChild(_bg);
				this._DisplayBox.setChildIndex(_bg, 0);*/
				
			this._AskPanel.AddElement(this._viewConterBox, this._SharedObj);
				
			this._SchedulePanel.AddElement(this._SharedObj, this._viewConterBox, "熔解大殿", DissolveStrLib.RemoveALL);
			this._SchedulePanelBg = this._viewConterBox.getChildByName("SchedulePanel") as Sprite;
			var _TableS:Sprite = new (this._BGObj.Boiler as Class);
				_TableS.scaleX = 0.3;
				_TableS.scaleY = 0.3;
				_TableS.x = 12;
				_TableS.y = -8;
			Sprite(this._SchedulePanelBg.getChildByName("Tab")).addChild(_TableS);
		}
		
		public function BoilerElement(_InputScheduledNum:Array):void
		{
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
			var _DissolveLayer:Object = new Object();
				_DissolveLayer["Layer"] = 1;
			this.SendNotify( DissolveStrLib.DissolveLayer, _DissolveLayer);
			
			//NEW 
			var _CurrentListBoard:Sprite;
			var _TimerBar:Sprite;
			var _TableBg:Bitmap;
			//NEW 
			
			this._ScheduledNum = _InputScheduledNum;
			this._BoilerFireBoolean = new <Boolean>[false, false, false, false, false,false];
			for (var j:int = 0; j <this._ScheduledNum.length ; j++) 
			{
				this._BoilerFireBoolean[j] = true;
			}
			
			/*var _NewX:Vector.<uint> = new <uint>[160,445,760,297,597];
			var _NewY:Vector.<uint> = new <uint>[265,265,265,430,430];*/
			var _Boiler:MovieClip;
			var _FireBoilerBox:SpriteVision;
			var _BoilerBox:Vector.<Sprite> = new Vector.<Sprite>;
			for (var i:int = 0; i < this._BuildLineMax; i++ ) {
				_CurrentListBoard = this._SchedulePanelBg.getChildByName("CurrentListBoard" + i) as Sprite;
				if (_CurrentListBoard != null) { 
					_TimerBar = _CurrentListBoard.getChildByName("TimerBar") as Sprite;
					SingleTimerBar(_TimerBar).ResetTimer(ServerTimework.GetInstance().ServerTime);
				}
				
				_TableBg = this._SchedulePanelBg.getChildByName("TableBg" + i) as Bitmap;
				if (this._BoilerFireBoolean[i] == false) {
					_Boiler = new (this._BGObj.Boiler as Class);
					_Boiler.buttonMode = true;
					_BoilerBox.push(_Boiler);
				}else {
					_FireBoilerBox = this._FireBoilerBox[i];
					_BoilerBox.push(_FireBoilerBox);
				}
				//_BoilerBox[i].scaleX = 1;
				//_BoilerBox[i].scaleY = 1;
				_BoilerBox[i].x = _TableBg.x + 29;
				_BoilerBox[i].y = _TableBg.y + 90;
				_BoilerBox[i].name = "Boiler" + i;
				this._SchedulePanelBg.addChild(_BoilerBox[i]);
				this.AddCompleteHandler(_BoilerBox[i]);
			}
		}
		
		public function LockBoiler():void 
		{
			var _TableBg:Bitmap;
			var _Boiler:MovieClip;
			var _Lock:Bitmap;
			for (var i:int = this._BuildLineMax; i < 6; i++ ) {
				_TableBg = this._SchedulePanelBg.getChildByName("TableBg" + i) as Bitmap;
				_Boiler = new (this._BGObj.Boiler as Class);
				_Boiler.x = _TableBg.x + 29;
				_Boiler.y = _TableBg.y + 90;
				//_Boiler.name = "Boiler" + i;
				this._SchedulePanelBg.addChild(_Boiler);
				
				_Lock = new Bitmap(BitmapData(new (this._SharedObj.Lock as Class)));
				_Lock.x = _TableBg.x;
				_Lock.y = _TableBg.y;
				this._SchedulePanelBg.addChild(_Lock);
			}
		}
		
		public function AddListBoard(_Num:int, _Monster:MonsterDisplay, _InputTimerBar:Sprite):void 
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
			
			var _TimerBar:Sprite = _InputTimerBar;
				_TimerBar.x = -40;
				_TimerBar.y = 15;
				_TimerBar.name = "TimerBar";
			_ListBoard.addChild(_TimerBar);
			SingleTimerBar(_TimerBar).StarTimes();
			
			var _DiamondBtn:Sprite = new Sprite();
			var _Diamond:Bitmap = new Bitmap(BitmapData(new (this._SharedObj.Diamond as Class)));
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
			for (var i:int = 0; i < this._BuildLineMax; i++) 
			{
				_CurrentListBoard = this._SchedulePanelBg.getChildByName("CurrentListBoard" + i) as Sprite;
				if (_CurrentListBoard != null) { 
					_TimerBar = _CurrentListBoard.getChildByName("TimerBar") as Sprite;
					SingleTimerBar(_TimerBar).Remove();
				}
			}
		}
		
		private function AddCompleteHandler(_InputMC:*):void
		{
			this.AddbtnFactory(_InputMC);
		}
		
		private function AddbtnFactory(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, btnChange);
			btn.addEventListener(MouseEvent.ROLL_OUT, btnChange);
			btn.addEventListener(MouseEvent.MOUSE_MOVE, btnChange);
		}
		
		private function btnChange(e:MouseEvent):void 
		{
			var _Num:int = int(e.currentTarget.name.substr(6, 1));
			switch (e.type) 
			{
				case "rollOver":
					TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
					this.JudgeTip(_Num);
				(this._BoilerFireBoolean[_Num] == false)?this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Dissolve", ProxyPVEStrList.TIP_STRBASIC, "GLOBAL_TIP_SCHEDULING01", "", null, e.stageX, e.stageY)):
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();;
				break;
				case "rollOut":
					TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
					this.RemoveTip(_Num);
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				break;
				case "mouseMove":
					(this._BoilerFireBoolean[_Num] == false)?TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).TipsMove(e.stageX, e.stageY):null;
				break;
			}
		}
		
		private function JudgeTip(_Num:int):void
		{
			if (this._BoilerFireBoolean[_Num] == true) this.TipMessage(_Num, true);
		}
		private function TipMessage(_InputNum:int, _CtrlBoolean:Boolean):void
		{
			var _ListBoard:Sprite = Sprite(this._SchedulePanelBg.getChildByName("ListBoard" + _InputNum));
			(_CtrlBoolean == true)?TweenLite.to(_ListBoard, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} ):
			TweenLite.to(_ListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
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
			this._ShowTip.y = this._viewConterBox.getChildByName(_InputBoilerName).y - this._ShowTip.height;
		}
		private function RemoveTip(_Num:int):void
		{
			if (this._BoilerFireBoolean[_Num] == true) this.TipMessage(_Num, false);
		}
			
		private function playerClickProcess(e:MouseEvent):void 
		{
			var name:String = e.target.name;
			switch (name) 
			{
				case "Boiler0":
					if (this._BoilerFireBoolean[0] == false) this.SecondLayer(name);
				break;
				case "Boiler1":
					if (this._BoilerFireBoolean[1] == false) this.SecondLayer(name);
				break;
				case "Boiler2":
					if (this._BoilerFireBoolean[2] == false) this.SecondLayer(name);
				break;
				case "Boiler3":
					if (this._BoilerFireBoolean[3] == false) this.SecondLayer(name);
				break;
				case "Boiler4":
					if (this._BoilerFireBoolean[4] == false) this.SecondLayer(name);
				break;
				case "Boiler5":
					if (this._BoilerFireBoolean[5] == false) this.SecondLayer(name);
				break;
			}
		}
		
		private function SecondLayer(_InputBoilerName:String):void
		{
			this.SendNotify( DissolveStrLib.MonsterMenu );//Send第二層惡魔元件
		}
		
		public function RemoveBoiler():void
		{
			if (this._viewConterBox.getChildByName("Inform") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Inform"));
			
			var _BoilerBox:Sprite
			for (var i:int = 0; i <this._BuildLineMax; i++) 
			{
				if (this._BoilerFireBoolean[i] == true && this._viewConterBox.getChildByName("" + i) != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("" + i));
				_BoilerBox= Sprite(this._SchedulePanelBg.getChildByName("Boiler" + i));
				this.RemovebtnFactory(_BoilerBox);
				this.RemoveCompleteHandler(_BoilerBox);
			}
		}
		
		private function RemoveCompleteHandler(_InputMC:*):void
		{
			this._SchedulePanelBg.removeChild(_InputMC);
		}
		
		private function RemovebtnFactory(btn:*):void 
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, btnChange);
			btn.removeEventListener(MouseEvent.ROLL_OUT, btnChange);
		}
		
		//熔解所第二層
		public function MonsterMenuElement(_InputMonsterDisplayList:Vector.<MonsterDisplay>, _BuildingLV:uint):void
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
			
			var _DissolveLayer:Object = new Object();
				_DissolveLayer["Layer"] = 2;
			this.SendNotify( DissolveStrLib.DissolveLayer, _DissolveLayer);
			
			this._MonsterDisplay = _InputMonsterDisplayList;
			/*this._MonsterDisplay = new Vector.<MonsterDisplay>;
			for (var i:int = 0; i < _InputMonsterDisplayList.length; i++) {
				(_InputMonsterDisplayList[i].MonsterData._useing != 1 || _InputMonsterDisplayList[i].MonsterData._teamGroup != "" || _InputMonsterDisplayList[i].MonsterData._dissoLv > _BuildingLV)?null:this._MonsterDisplay.push(_InputMonsterDisplayList[i]);
			}*/
			var _AddMonsterMenu:Object = new Object();
				_AddMonsterMenu["Monster"] = this._MonsterDisplay;
				_AddMonsterMenu["BGObj"] = this._SharedObj;
				_AddMonsterMenu["BuildingLV"] = _BuildingLV;
			this.SendNotify( UICmdStrLib.AddMonsterMenu, _AddMonsterMenu);
			
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _SkilletBg:Bitmap = new Bitmap(BitmapData(new (this._SharedObj.SkilletBg as Class)));
				_SkilletBg.x = 505;
				_SkilletBg.y = 115;
				_SkilletBg.alpha = 0;
			_Panel.addChild(_SkilletBg);
			TweenLite.to(_SkilletBg, 3, { alpha:1 } );
		}
		
		//判斷是否能進行熔解
		public function JudgeDissolve(_InputNum:int, _CurrentMonster:Sprite):void
		{
			this._CurrentMonster = _CurrentMonster;
			
			this.AddInform();
			
			switch (_InputNum) 
			{
				case 1:
					this._AskPanel.AddMsgText("惡魔資訊有誤!!!!", 120);
				break;
				case 2:
					this._AskPanel.AddMsgText("建築物等級低於惡魔等級無法熔解!!", 110);
				break;
				case 3:
					this._AskPanel.AddMsgText("確定熔解此惡魔!!!!", 120);
					this._viewConterBox.addEventListener(MouseEvent.CLICK, _DialogBoxClickHandler);
				break;
			}
		}
		public function AddInform():void 
		{
			this._AskPanel.AddInform();
		}
		private function DialogHandler(_InputSp:Sprite):void
		{
			var _TimerNum:int = 0;
			_viewConterBox.addEventListener(Event.ENTER_FRAME, onDialogEnterFrame);	
			function onDialogEnterFrame(e:Event):void
			{
				_TimerNum += 1;
				if (_TimerNum == 15) {
					if (this._viewConterBox.getChildByName("InformBox") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("InformBox"));
					if (_viewConterBox.getChildByName("Inform") != null)_viewConterBox.removeChild(Sprite(_viewConterBox.getChildByName(_InputSp.name)));
					_viewConterBox.removeEventListener(Event.ENTER_FRAME, onDialogEnterFrame);
					SendNotify( UICmdStrLib.RecoverBtn );
				}
			}
		}
		
		//商城
		public function GetPay(_Price:uint, _Name:int):void 
		{
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
					this.RemoveInform();
				break;
				case "Make1"://no
					//Sprite(this._viewConterBox.getChildByName("" + this._CurrentDiamond)).visible = true;
					this._CurrentDiamond = -1;
					TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:393, y:255, scaleX:0.5, scaleY:0.5 , onComplete:RemoveInform } );
					this.SendNotify( UICmdStrLib.RecoverBtn );
				break;
			}
		}
		//是否溶解
		private function _DialogBoxClickHandler(e:MouseEvent):void
		{
			switch(e.target.name)
				{
					case "Make0"://yes
						var _Wrap:Object = new Object();
							_Wrap["_guid"] = this._CurrentMonster.name;
						this.SendNotify( DissolveStrLib.GetMonsterHead, _Wrap );
					break;
					case "Make1"://no
						TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:393, y:255, scaleX:0.5, scaleY:0.5 , onComplete:RemoveInform } );
						this.SendNotify( UICmdStrLib.RecoverBtn );
					break;
				}
		}
		
		private function RemoveInform():void
		{
			this._AskPanel.RemovePanel();
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, _DialogBoxClickHandler);
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, PayClickHand);
		}
		
		public function GetMonsterHead(_InputMD:MonsterDisplay):void
		{
			this.RemoveInform();
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			_InputMD.ShowContent();
			var _CurrentMonsterHead:Sprite = _InputMD.MonsterHead;
				_CurrentMonsterHead.x = -32;
				_CurrentMonsterHead.y = -32;
			var _AlphaBox:Sprite = this._SharedEffect.DrawRect( -32, -32, 64, 64);
				_AlphaBox.x = _Panel.x + this._CurrentMonster.x + 82;
				_AlphaBox.y = _Panel.y + this._CurrentMonster.y + 120;
				_AlphaBox.addChild(_CurrentMonsterHead);
				this._viewConterBox.addChild(_AlphaBox);
				
			var vx:int=0;
			var vy:int = 0;
			var ay:int = 0;
			switch(this._CurrentMonster.x)
				{
					case 0:
						if(this._CurrentMonster.y==0){
							vx = 13;
							vy = -15;
							ay = 1; 
						} else {
							vx = 13;
							vy = -20;
							ay = 1; 
						}
					break;
					case 155:
						if(this._CurrentMonster.y==0){
							vx = 10;
							vy = -15;
							ay = 1;
						} else {
							vx = 10;
							vy = -20;
							ay = 1;
						}
					break;
					case 310:
						if(this._CurrentMonster.y==0){
							vx = 6;
							vy = -15;
							ay = 1;
						} else {
							vx = 6;
							vy = -20;
							ay = 1;
						}
					break;
				}
				
			_AlphaBox.addEventListener(Event.ENTER_FRAME, onEnterFrame);		
			function onEnterFrame(e:Event):void
			{
				if (_AlphaBox.scaleX!=0.5&&_AlphaBox.scaleY!=0.5) {
					_AlphaBox.scaleX -= 0.01;
					_AlphaBox.scaleY -= 0.01;
				}
				if (_AlphaBox.y < 330) {
					vy+=ay;
					_AlphaBox.x+=vx;
					_AlphaBox.y+=vy;
					_AlphaBox.rotation += 10;
				}else {
					_AlphaBox.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					_AlphaBox.removeChild(_CurrentMonsterHead);
					_AlphaBox.parent.removeChild(_AlphaBox);
					SendNotify( DissolveStrLib.RemoveALL );
				}
			}
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