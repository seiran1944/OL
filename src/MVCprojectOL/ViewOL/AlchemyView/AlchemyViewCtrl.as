package MVCprojectOL.ViewOL.AlchemyView 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplayProxyAll;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.SingleTimerBar;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.MallBtn.MallBtn;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SchedulePanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import MVCprojectOL.ViewOL.SharedMethods.TimeConversion;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.SoarVision.single.BitmapVision;
	import Spark.SoarVision.single.SpriteVision;
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
	public class AlchemyViewCtrl extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _DisplayBox:DisplayObjectContainer;
		private var _BGObj:Object;
		private var _AlchemyObj:Object;
		private var _onTabElement:Vector.<MovieClip>;
		private var _CurrentTabM:int;
		private var _RandomNum:uint;
		private var _TableBoolean:Vector.<Boolean>;
		private var _BoneFire:Vector.<BitmapVision>;
		private var _CurrentWorkbench:String;
		private var _PageList:Array;
		private var _CtrlPageNum:int = 0;
		private var _SlidingControl:SlidingControl;
		private var _CurrentItemDisplay:ItemDisplay;
		private var _TxtFormat:TextFormat = new TextFormat();
		private var _CurrentListBoard:Sprite;
		private var _ListBoardMenuSP:Vector.<Sprite>;
		private var _ScheduledNum:Array;
		private var _ShowTip:Sprite;
		private var _ItemDisplayID:Vector.<ItemDisplay>;
		private var _AskPanel:AskPanel = new AskPanel();
		private var _CurrentDiamond:int;
		private var _TipsView:TipsView = new TipsView("Alchemy");//---tip---
		
		private var _SchedulePanel:SchedulePanel = new SchedulePanel();
		private var _SchedulePanelBg:Sprite;
		private var _CurrentTable:int;
		private var _MallBtn:MallBtn = new MallBtn ();
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"LEFT", _col:0xFFFFFF, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
		private var _BuildLineMax:int;
		
		public function AlchemyViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			TweenPlugin.activate([GlowFilterPlugin]);
			TweenPlugin.activate([ColorMatrixFilterPlugin]);
			
			super( _InputViewName , _InputConter );
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE); 
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		
		public function BackGroundElement(_InputAlchemyObj:Object, _InputObj:Object, _InputBoneFire:Vector.<BitmapVision>, _BuildLineMax:int):void
		{
			this._BGObj = _InputObj;
			this._AlchemyObj = _InputAlchemyObj;
			this._BoneFire = _InputBoneFire;
			this._BuildLineMax = _BuildLineMax;
			
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			
			//var _BackGround:Bitmap = new Bitmap( BitmapData( new (this._AlchemyObj .bg4 as Class) )  );
			//this._viewConterBox.addChild( _BackGround );
			
			this._SchedulePanel.AddElement(this._BGObj, this._viewConterBox, "煉金大殿",UICmdStrLib.RemoveALL);
			this._SchedulePanelBg = this._viewConterBox.getChildByName("SchedulePanel") as Sprite;
			var _TableS:Sprite = new (this._AlchemyObj.Workbench as Class);
				_TableS.scaleX = 0.3;
				_TableS.scaleY = 0.3;
				_TableS.x = 2;
				_TableS.y = -5;
			Sprite(this._SchedulePanelBg.getChildByName("Tab")).addChild(_TableS);
		}
		
		//煉金所第一層
		public function OneLayer(_InputScheduledNum:Array):void
		{
			trace("煉金所第一層");
			var _AlchemyLayer:Object = new Object();
				_AlchemyLayer["Layer"] = 1;
			this.SendNotify( UICmdStrLib.AlchemyLayer, _AlchemyLayer);
			
			//NEW 
			var _CurrentListBoard:Sprite;
			var _TimerBar:Sprite;
			var _TableBg:Bitmap;
			//NEW 
			
			this._ScheduledNum = _InputScheduledNum;
			this._TableBoolean = new <Boolean>[false, false, false, false, false,false]; // 檢查是否有排程
			for (var j:int = 0; j < _InputScheduledNum.length ; j++) 
			{
				this._TableBoolean[j] = true;
			}
			
			//var _NewX:Vector.<uint> = new <uint>[130,425,720,270,575];
			//var _NewY:Vector.<uint> = new <uint>[285,285,285,445,445];
			var _Workbench:Sprite;
			var _BoneFireBox:BitmapVision;
			var _WorkbenchBox:Vector.<Sprite> = new Vector.<Sprite>;
			var _Bottle:Sprite;
			for (var i:int = 0; i < this._BuildLineMax; i++ ) {
				_CurrentListBoard = this._SchedulePanelBg.getChildByName("CurrentListBoard" + i) as Sprite;
				if (_CurrentListBoard != null) { 
					_TimerBar = _CurrentListBoard.getChildByName("TimerBar") as Sprite;
					SingleTimerBar(_TimerBar).ResetTimer(ServerTimework.GetInstance().ServerTime);
				}
				
				_TableBg = this._SchedulePanelBg.getChildByName("TableBg" + i) as Bitmap;
				if (this._TableBoolean[i] == false) {
					_Workbench = new (this._AlchemyObj.Workbench as Class);
					_Workbench.buttonMode = true;
					_WorkbenchBox.push(_Workbench);
				}else {
					_Workbench = new (this._AlchemyObj.Workbench as Class);
					_BoneFireBox = this._BoneFire[i];
					_BoneFireBox.x = 130;
					_BoneFireBox.y = -40;
					_Workbench.addChild(_BoneFireBox);
					_Bottle = new (this._AlchemyObj.Bottle as Class);
					_Bottle.x = 100;
					_Bottle.y = -70;
					_Workbench.addChild(_Bottle);
					this.onCompleteShake(_Bottle , true );
					var _ABox:Sprite = this._SharedEffect.DrawRect(0, 0, 80, 80);
						_ABox.x = 60;
						_ABox.y = -75;
						_ABox.alpha = 0;
					_Workbench.addChild(_ABox);
					_WorkbenchBox.push(_Workbench);
				}
				_WorkbenchBox[i].scaleX = 0.75;
				_WorkbenchBox[i].scaleY = 0.75;
				_WorkbenchBox[i].x = _TableBg.x + 20;
				_WorkbenchBox[i].y = _TableBg.y + 130;
				_WorkbenchBox[i].name = "Workbench" + i;
				this._SchedulePanelBg.addChild(_WorkbenchBox[i]);
				//TweenLite.to(_WorkbenchBox[i], 0.5, { x:_NewX[i], y:_NewY[i], alpha:1, ease:Back.easeOut } );
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
				_Workbench = new (this._AlchemyObj.Workbench as Class);
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
		
		public function AddListBoard(_Num:int, _Item:ItemDisplay, _InputTimerBar:Sprite):void 
		{
			var _ListBoard:Sprite = new Sprite();
				_ListBoard.x = 60;
				_ListBoard.y = 155 + _Num * 65;
				_ListBoard.name = "CurrentListBoard" + _Num;
			this._SchedulePanelBg.addChild(_ListBoard);
			_Item.ShowContent();
			
			var _MonsterHead:Sprite = _Item.ItemIcon;
				_MonsterHead.width = 48;
				_MonsterHead.height = 48;
			_ListBoard.addChild(_MonsterHead);
			
			this._TextObj._str = _Item.ItemData._showName;
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
			for (var i:int = 0; i < this._BuildLineMax; i++) 
			{
				_CurrentListBoard = this._SchedulePanelBg.getChildByName("CurrentListBoard" + i) as Sprite;
				if (_CurrentListBoard != null) { 
					_TimerBar = _CurrentListBoard.getChildByName("TimerBar") as Sprite;
					SingleTimerBar(_TimerBar).Remove();
				}
			}
		}
		
		//
		/*public function DiamondBtnVisible():void 
		{
			for (var i:int = 0; i < 5; i++ ) {
				if (this._TableBoolean[i] == true) Sprite(this._viewConterBox.getChildByName("" + i)).visible = true;
			}
		}*/
		//瓶子遙晃
		private function onCompleteShake(target:Object,isLeft:Boolean):void 
		{
			TweenLite.to(target, 0.2, { rotation:isLeft ? -25 : 25 , onComplete:this.onCompleteShake , onCompleteParams : [target, !isLeft] } );
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
				(this._TableBoolean[_Num] == false)?this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Alchemy", ProxyPVEStrList.TIP_STRBASIC, "GLOBAL_TIP_SCHEDULING02", "", null, e.stageX, e.stageY)):
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();;
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
			this._ShowTip.y = this._viewConterBox.getChildByName(_InputBoilerName).y - this._ShowTip.height - 80;
		}
		private function RemoveTip(_Num:int):void
		{
			if (this._TableBoolean[_Num] == true) this.TipMessage(_Num, false);
		}
		
		private function playerClickProcess(e:MouseEvent):void 
		{
			var name:String = e.target.name;
			switch (name) 
			{
				case "Workbench0":
					if (this._TableBoolean[0] == false) this.RemoveOneLayer(name);
				break;
				case "Workbench1":
					if (this._TableBoolean[1] == false) this.RemoveOneLayer(name);
				break;
				case "Workbench2":
					if (this._TableBoolean[2] == false) this.RemoveOneLayer(name);
				break;
				case "Workbench3":
					if (this._TableBoolean[3] == false) this.RemoveOneLayer(name);
				break;
				case "Workbench4":
					if (this._TableBoolean[4] == false) this.RemoveOneLayer(name);
				break;
				case "Workbench5":
					if (this._TableBoolean[5] == false) this.RemoveOneLayer(name);
				break;
			}
		}
		private function RemoveOneLayer(_InputName:String):void
		{
			this.RemoveBoiler();
			this.SecondLayer();//煉金所第二層
		}
		public function RemoveBoiler():void
		{
			var _WorkbenchBox:Sprite;
			for (var i:int = 0; i <this._BuildLineMax; i++) 
			{
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
		
		private function SecondLayer():void
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
			
			var _AlchemyLayer:Object = new Object();
				_AlchemyLayer["Layer"] = 2;
			this.SendNotify( UICmdStrLib.AlchemyLayer, _AlchemyLayer);
			
			var _AlphaBox:Sprite; 
			_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
			_AlphaBox.name = "AlphaBox";
			_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			var _Panel:Sprite = new Sprite();
				_Panel.x = 373;//265 + 215-107;
				_Panel.y = 127;//25 + 255-127;
				_Panel.scaleX = 0.5;
				_Panel.scaleY = 0.5;
				_Panel.name = "Panel";
			this._viewConterBox.addChild(_Panel);
			
			var _SlidingContainer:Sprite = new Sprite();
				_SlidingContainer.name = "SlidingContainer";
			this._SlidingControl = new SlidingControl( _SlidingContainer );
			_Panel.addChild( _SlidingContainer );
			
			var _BgB:Sprite = new (this._BGObj.BgB as Class);
				_BgB.width = 430;
				_BgB.height = 510;
				_BgB.x = 20;
				_BgB.y = 70;
			_Panel.addChild(_BgB);
			
			var _Title:Sprite = new (this._BGObj.Title as Class);
				_Title.x = 110;
				_Title.y = 85;
			_Panel.addChild(_Title);
			var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xf4f0c1, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
				_TextObj._str = "煉金大殿";
			var _TitleText:Text = new Text(_TextObj);
				_TitleText.x = 200;
				_TitleText.y = 92;
				_TitleText.mouseEnabled = false;
			_Panel.addChild(_TitleText);
			
			var _EdgeBg:Sprite;
			for (var i:int = 0; i < 2; i++) 
			{
				_EdgeBg = new (this._BGObj.EdgeBg as Class);
				(i == 0)?_EdgeBg.scaleY = -1:_EdgeBg.scaleY = 1;
				(i == 0)?_EdgeBg.y =  90:_EdgeBg.y = _BgB.height + 40;
				_EdgeBg.x = _BgB.width / 2 + _BgB.x;
				_Panel.addChild(_EdgeBg);
			}
			
			var _ExplainBtn:MovieClip = new (this._BGObj.ExplainBtn as Class);
				_ExplainBtn.x = 30;
				_ExplainBtn.y = 80;
				_ExplainBtn.name = "ExplainBtn";
				_ExplainBtn.buttonMode = true;
			_Panel.addChild(_ExplainBtn);
			this.MouseEffect(_ExplainBtn);
			this._TipsView.MouseEffect(_ExplainBtn);
			
			var _CloseBtn:MovieClip = new (this._BGObj.CloseBtn as Class);
				_CloseBtn.x = 415;
				_CloseBtn.y = 80;
				_CloseBtn.name = "CloseBtn";
				_CloseBtn.buttonMode = true;
			_Panel.addChild(_CloseBtn);
			this.MouseEffect(_CloseBtn);
			this._TipsView.MouseEffect(_CloseBtn);
			
			var _PageBtnS:MovieClip;
			for (var j:int = 0; j < 2; j++) 
			{
				_PageBtnS = new (this._BGObj.PageBtnS as Class);
				_PageBtnS.x = 195 + j * 80;
				_PageBtnS.y = 530;
				_PageBtnS.name = "btn" + j;
				if (_PageBtnS.name == "btn0") _PageBtnS.scaleX = -1;
				_PageBtnS.addEventListener(MouseEvent.CLICK, _onClickHandler);
				_PageBtnS.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler);
				_PageBtnS.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler);
				_Panel.addChild(_PageBtnS);
				this._TipsView.MouseEffect(_PageBtnS);
			}
				_TextObj._str = "0" +" / " +"0";
			var _PageText:Text = new Text(_TextObj);
				_PageText.x = 219;
				_PageText.y = 530;
				_PageText.name = "PageText";
				_PageText.mouseEnabled = false;
			_Panel.addChild(_PageText);
			
			var _PageSP:Sprite = this._SharedEffect.DrawRect(0, 0, _PageText.width, _PageText.height);
				_PageSP.x = _PageText.x;
				_PageSP.y = _PageText.y;
				_PageSP.name = "PageSP";
				_PageSP.alpha = 0;
			_Panel.addChild(_PageSP);
			this._TipsView.MouseEffect(_PageSP);
			
			var _BgM:Sprite = new (this._BGObj.BgM as Class);
				_BgM.width = 190;
				_BgM.height = 410;
				_BgM.x = 240;
				_BgM.y = 125;
			_Panel.addChild(_BgM);
				
			var _BgD:Sprite = new (this._BGObj.BgD as Class);
				_BgD.width = 170;
				_BgD.height = 100;
				_BgD.x = 250;
				_BgD.y = 270;
			_Panel.addChild(_BgD);
			
			var _Box:Bitmap;
			for (var k:int = 0; k < 6; k++) 
			{
				_Box = new Bitmap(BitmapData(new(this._BGObj.Box as Class)));
				_Box.x = 253 + ( k % 3 ) * (48 + 10);
				_Box.y = 137 + ( int( k / 3 ) * (48 + 15));
				_Panel.addChild(_Box);
			}
			
			var _CheckBtn:MovieClip = new (this._BGObj.CheckBtn as Class);
				_CheckBtn.width = 85;
				_CheckBtn.x = 295;
				_CheckBtn.y = 380;
				_CheckBtn.name = "CheckBtn";
				_CheckBtn.buttonMode = true;
				_CheckBtn.visible = false;
				this._SharedEffect.MovieClipMouseEffect(_CheckBtn);
				_CheckBtn.addEventListener(MouseEvent.CLICK, MakeBtnClick);
			_Panel.addChild(_CheckBtn);
			_TextObj._str = "確認";
			var _CheckBtnText:Text = new Text(_TextObj);
				_CheckBtnText.x = 50;
				_CheckBtnText.y = 10;
			_CheckBtn.addChild(_CheckBtnText);
			
			var _Fatigue:Bitmap = new Bitmap(BitmapData(new(this._BGObj.Fatigue as Class)));
				_Fatigue.scaleX = 0.7;
				_Fatigue.scaleY = 0.7;
				_Fatigue.x = 270;
				_Fatigue.y = 325;
			_Panel.addChild(_Fatigue);
			
			var _Hourglass:Bitmap = new Bitmap(BitmapData(new(this._BGObj.Hourglass as Class)));
				_Hourglass.scaleX = 0.7;
				_Hourglass.scaleY = 0.7;
				_Hourglass.x = 270;
				_Hourglass.y = 280;
			_Panel.addChild(_Hourglass);
			
			_TextObj._col = 0xd0cebc;
			_TextObj._str = "0";
			var _SoulText:Text = new Text(_TextObj);
				_SoulText.x = 340;
				_SoulText.y = 330;
				_SoulText.name = "SoulText";
			_Panel.addChild(_SoulText);
			
			var _TimerText:Text = new Text(_TextObj);
				_TimerText.x = 340;
				_TimerText.y = 290;
				_TimerText.name = "TimerText";
			_Panel.addChild(_TimerText);
			
			this.Tab();
			
			this._SharedEffect.ZoomIn(_Panel, 430, 510, 0.5);
		}
		
		private function Tab():void
		{
			var _Weapon:MovieClip = new (this._AlchemyObj.Weapon as Class);
				_Weapon.name = "wep";
			this._TipsView.MouseEffect(_Weapon);
			var _Armor:MovieClip = new (this._AlchemyObj.Armor as Class);
				_Armor.name = "Shield";
			this._TipsView.MouseEffect(_Armor);
			var _Accessories:MovieClip = new (this._AlchemyObj.Accessories as Class);
				_Accessories.name = "Accessories";
			this._TipsView.MouseEffect(_Accessories);
			var _Material:MovieClip = new (this._AlchemyObj.Material as Class);
				_Material.name =  "Basic";
			this._TipsView.MouseEffect(_Material);
			this._onTabElement = new <MovieClip>[_Weapon, _Armor,_Accessories,_Material];
			
			this._CurrentTabM = 0;
			this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
			
			var _CurrentTab:Object = new Object();
				_CurrentTab["TabName"] = this._onTabElement[0].name;
			this.SendNotify( UICmdStrLib.CurrentTab,_CurrentTab);
		}
		private function TabMFactory(_InputSP:MovieClip,InputNum:int):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _TabM:MovieClip = new  (this._BGObj.Tab as Class);
				_TabM.x = 45 + InputNum * 47;
				_TabM.y = 125;
				_TabM.scaleX = 0.75;
				_TabM.gotoAndStop(2);
				_TabM.buttonMode = true;
				_TabM.name = "TabM" + InputNum;
			_Panel.addChild(_TabM);
			var _TabElement:MovieClip = _InputSP;
				_TabElement.x = _TabM.x +5;
				_TabElement.y = _TabM.y - 15;
				_TabElement.scaleX = 0.7;
				_TabElement.scaleY = 0.7;
				_TabElement.buttonMode = true;
				_TabElement.gotoAndStop(3);
			_Panel.addChild(_TabElement);
			for (var i:int = 0; i < 4; i++)(i == this._CurrentTabM)?null:this.TabSFactory(this._onTabElement[i], i);
		}
		private function TabSFactory(_InputSP:MovieClip,InputNum:int):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _TabS:MovieClip = new  (this._BGObj.Tab as Class);
				_TabS.scaleX = 0.6;
				_TabS.scaleY = 0.6;
				(this._CurrentTabM < InputNum)?_TabS.x = _Panel.getChildByName("TabM" + this._CurrentTabM).x + (InputNum - this._CurrentTabM) * 50:_TabS.x = _Panel.getChildByName("TabM" + this._CurrentTabM).x - (this._CurrentTabM - InputNum) * 50;
				_TabS.y = 130;
				_TabS.name = "TabS" + InputNum;
			_Panel.addChild(_TabS);
			var _TabElement:MovieClip = _InputSP;
				_TabElement.x = _TabS.x +6;
				_TabElement.y = _TabS.y - 10;
				_TabElement.name = this._onTabElement[InputNum].name;
				_TabElement.scaleX = 0.8;
				_TabElement.scaleY = 0.8;
				_TabElement.gotoAndStop(1);
			_Panel.addChild(_TabElement);
			var _TabSBtn:Sprite = this._SharedEffect.DrawRect(0, 0, 45, 24);
				_TabSBtn.x = 44 + InputNum * 47;
				_TabSBtn.y = 125;
				_TabSBtn.alpha = 0;
				_TabSBtn.name = "" + InputNum;
				_TabSBtn.buttonMode = true;
				this.btnFactory(_TabSBtn);
			_Panel.addChild(_TabSBtn);
			this._TipsView.MouseEffect(_TabSBtn);
			this.move(_TabS,_TabElement, InputNum);
		}
		private function move(_InputSP:Sprite,_InputTab:Sprite,InputNum:int):void
		{
			if (InputNum == this._CurrentTabM ) {
				Sprite(this._viewConterBox.getChildByName("Panel")).removeChild(_InputSP);
				this.TabMFactory(this._onTabElement[InputNum], InputNum);
			}else if (InputNum != this._CurrentTabM&&this._CurrentTabM > -1 ){
				TweenLite.to(_InputSP, 0.2, { x:45 + InputNum * 62 * 0.75, y:125, scaleX:0.75, scaleY:1 } );
				TweenLite.to(_InputTab, 0.2, { x:55 + InputNum * 62 * 0.75, y:115 } );
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
			switch (e.type) 
			{
				case "click":
					var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
					Text(_Panel.getChildByName("SoulText")).ReSetString("0");
					Text(_Panel.getChildByName("TimerText")).ReSetString("0");
					if (_Panel.getChildByName("NeedSource") != null) _Panel.removeChild(_Panel.getChildByName("NeedSource"));
					this._SlidingControl.ClearStage(true);
					for (var i:int = 0; i < 4; i++) 
					{
						if (i != this._CurrentTabM) {
							this.removebtnFactory(_Panel.getChildByName("" + i));
							_Panel.removeChild(_Panel.getChildByName("" + i));
							_Panel.removeChild(_Panel.getChildByName("TabS" + i))
						}else {
							_Panel.removeChild(_Panel.getChildByName("TabM" + i))
						}
						_Panel.removeChild(this._onTabElement[i]);
					}
					this._CurrentTabM = int(e.currentTarget.name);
					this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
					this._CtrlPageNum = 0;
					var _CurrentTab:Object = new Object();
						_CurrentTab["TabName"] = this._onTabElement[int(e.currentTarget.name)].name;
					this.SendNotify( UICmdStrLib.CurrentTab,_CurrentTab);
					
				break;
				
				case "rollOver":
					MovieClip(this._onTabElement[int(e.currentTarget.name)]).gotoAndStop(2);
				break;
				
				case "rollOut":
					MovieClip(this._onTabElement[int(e.currentTarget.name)]).gotoAndStop(1);
				break;
				
			}
		}
		private function removebtnFactory(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, btnStatus);
			btn.removeEventListener(MouseEvent.ROLL_OUT, btnStatus);
			btn.removeEventListener(MouseEvent.CLICK, btnStatus);
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
							this._CtrlPageNum <= 0?this._CtrlPageNum = this._CtrlPageNum:(this._CtrlPageNum --) && (this.CtrlPage(this._CtrlPageNum, true));
						}
						break;
					case "btn1":
						if (this._CtrlPageNum != this._PageList.length - 1 && this._PageList.length > 1) {
							this._CtrlPageNum == 0?MovieClip(_Panel.getChildByName("btn0")).gotoAndStop(1):null;
							this._CtrlPageNum == this._PageList.length-2?MovieClip(e.currentTarget).gotoAndStop(1):null;
							this._CtrlPageNum ++;
							this._CtrlPageNum < this._PageList.length?this.CtrlPage(this._CtrlPageNum, true):this._CtrlPageNum --;
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
		
		//合成表
		public function ListBoard(_InputListBoardMenu:Vector.<ItemDisplay>):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
			this._PageList = _SplitPageMethod.SplitPage(_InputListBoardMenu, 6);
			
			var _Btn0:MovieClip = MovieClip(_Panel.getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(_Panel.getChildByName("btn1"));
			if (this._PageList.length != 0 && this._PageList.length != 1)  {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = true;
			}else {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = false;
			}
			
			this._PageList.length != 0?Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + 1 + " / " + this._PageList.length):Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + " / " + this._PageList.length);
			this._PageList.length != 0?this.CtrlPage(this._CtrlPageNum, false):null;
		}
		private function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + 1 + " / " + this._PageList.length);
			var _MyPage:Array = this._PageList[_InputPage];
			var _MyPageLength:uint = _MyPage.length;
			this._ListBoardMenuSP = new Vector.<Sprite>;
			var _ItemDisplay:ItemDisplay;
			
			for (var i:int = 0; i < _MyPageLength ; i++) {
				_ItemDisplay = _MyPage[i];
				_ItemDisplay.ShowContent();
				//trace(_ItemDisplay.ItemID, "123456789");
				this._ListBoardMenuSP .push(this.ListBoardMenu(_ItemDisplay.ItemIcon, _ItemDisplay.ItemData) );
				this._ListBoardMenuSP[i].addEventListener(MouseEvent.CLICK, ListBoardClickHandler);
				this._ListBoardMenuSP[i].addEventListener(MouseEvent.ROLL_OVER, ListBoardRollOver);
				this._ListBoardMenuSP[i].addEventListener(MouseEvent.ROLL_OUT, ListBoardRollOut);
			}
			
			var _ListBoardKey:Object = new Object();
				_ListBoardKey["guid"] = this._ListBoardMenuSP[0].name;
			this.SendNotify( UICmdStrLib.ListBoardKey, _ListBoardKey);
			TweenLite.to(this._ListBoardMenuSP[0], 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
			this._CurrentListBoard = this._ListBoardMenuSP[0];
			this._CurrentListBoard.name = this._ListBoardMenuSP[0].name;
			
			this._SlidingControl._Cols = 1;
			this._SlidingControl._Rows = 6;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 0;
			this._SlidingControl._VerticalInterval = 65;
			this._SlidingControl._RightInPosX = 0;
			this._SlidingControl._LeftInPosX = 0;
			this._SlidingControl.NextPage(this._ListBoardMenuSP , _CtrlBoolean);
			_Panel.setChildIndex(_Panel.getChildByName("SlidingContainer"), _Panel.numChildren - 1);
		}
		//物件清單底板
		private function ListBoardMenu(_InputIcon:Sprite,_InputData:Object):Sprite
		{
			var _ListBoardMenu:Sprite = new Sprite();
				_ListBoardMenu.buttonMode = true;
				_ListBoardMenu.name = _InputData._guid;
			var _TextBg:Sprite = new (this._BGObj.BgM as Class);
				_TextBg.width = 205;
				_TextBg.height = 67;
				_TextBg.x = 40;
				_TextBg.y = 147;
			_ListBoardMenu.addChild(_TextBg);
			
			if (_AssemblyListBoard == null) var _AssemblyListBoard:AssemblyListBoard = new AssemblyListBoard();
			_AssemblyListBoard.AssemblyListBoardMenu(_ListBoardMenu, _InputIcon, _InputData, this._BGObj);
			
			return _ListBoardMenu;
		}
		
		//點擊物件清單底板取得配方數量
		private function ListBoardClickHandler(e:MouseEvent):void
		{
			if (this._CurrentListBoard.name != e.currentTarget.name) {
				TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				var _ListBoardKey:Object = new Object();
					_ListBoardKey["guid"] = e.currentTarget.name;
				this.SendNotify( UICmdStrLib.ListBoardKey, _ListBoardKey);
				TweenLite.to( e.currentTarget, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				this._CurrentListBoard = Sprite(e.currentTarget);
				this._CurrentListBoard.name = e.currentTarget.name;
			}
		}
		private function ListBoardRollOver(e:MouseEvent):void
		{
			if (this._CurrentListBoard.name != e.currentTarget.name) TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
		}
		private function ListBoardRollOut(e:MouseEvent):void
		{
			if (this._CurrentListBoard.name != e.currentTarget.name) TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
		}
		
		//合成配方表素材拿取
		public function NeedSourceList(_InputObj:Object, _InputNeedSource:Vector.<ItemDisplay>, InputCurrentItemDisplay:ItemDisplay):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _CheckBtn:MovieClip = MovieClip(_Panel.getChildByName("CheckBtn"));
			var _TextObj:Object = { _str:"", _wid:20, _hei:15, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:15, _bold:true, _font:"Times New Roman", _leading:null };
			
			if (_Panel.getChildByName("NeedSource") != null) _Panel.removeChild(_Panel.getChildByName("NeedSource"));
			
			this._CurrentItemDisplay = InputCurrentItemDisplay;
			this._ItemDisplayID = new Vector.<ItemDisplay>;
			//確認素材是否足夠  開/關 按鈕
			(_InputObj["_useFlag"] == true)?_CheckBtn.visible = true:_CheckBtn.visible = false;
			
			var _NeedSource:Sprite = new Sprite();
				_NeedSource.name = "NeedSource";
			var _NumTxt:Text;
			for (var i:int = 0; i < _InputObj["_aryInfo"].length; i++) 
			{
				_InputNeedSource[i].ShowContent();
				var _NeedSourceIcon:Sprite = _InputNeedSource[i].ItemIcon;
					_NeedSourceIcon.x = 253 + ( i % 3 ) * (48 + 10);
					_NeedSourceIcon.y =  137 + ( int( i / 3 ) * (48 + 15));
					_NeedSourceIcon.name = "" + i;
					_NeedSourceIcon.width = 48;
					_NeedSourceIcon.height = 48;
				this._ItemDisplayID.push(_InputNeedSource[i]);
				_NeedSourceIcon.addEventListener(MouseEvent.ROLL_OVER, RollOver);
				_NeedSourceIcon.addEventListener(MouseEvent.ROLL_OUT, RollOut);
				_NeedSource.addChild(_NeedSourceIcon);
				
				(_InputObj["_aryInfo"][i]._player >= _InputObj["_aryInfo"][i]._need)?_TextObj._col = 0xF5C401:_TextObj._col = 0xFF0000;
				_TextObj._str = _InputObj["_aryInfo"][i]._player + " / " + _InputObj["_aryInfo"][i]._need;
				_NumTxt = new Text(_TextObj);
				_NumTxt.x = 260 + ( i % 3 ) * (48 + 10);
				_NumTxt.y = 182 + ( int( i / 3 ) * (48 + 15));
				_NeedSource.addChild(_NumTxt);
				
				Text(_Panel.getChildByName("SoulText")).ReSetString(this._CurrentItemDisplay.ItemData._needSoul);
				if (_TimeConversion == null) var _TimeConversion:TimeConversion = new TimeConversion();
				Text(_Panel.getChildByName("TimerText")).ReSetString(_TimeConversion.TimerConversion(this._CurrentItemDisplay.ItemData._needTimes));
			}
			
			_Panel.addChild(_NeedSource);
		}
		//確認製作按鈕
		private function MakeBtnClick(e:MouseEvent):void
		{
			var _CurrentAlchemy:Object = new Object();
				_CurrentAlchemy["guid"] = this._CurrentItemDisplay.ItemData._guid;
			this.SendNotify( UICmdStrLib.CurrentAlchemy,_CurrentAlchemy);
			this.RemovePanel();
		}
		//素材tip顯示
		private function RollOver(e:MouseEvent):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _CurrentItemDisplay:ItemDisplay = ItemDisplay(this._ItemDisplayID[e.currentTarget.name]);
		/*(_CurrentItemDisplay.ItemData._type == 3)?this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Alchemy", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MTL", ProxyPVEStrList.ALCHEMY_TIPS, { _rGuid:this._CurrentItemDisplay.ItemData._guid, _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type } , Sprite(e.target).x + _Panel.x - 7 , Sprite(e.target).y + _Panel.y + 28 )):
			this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Alchemy", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MTL", ProxyPVEStrList.ALCHEMY_TIPS, { _rGuid:this._CurrentItemDisplay.ItemData._guid, _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type } , Sprite(e.target).x + _Panel.x - 7 , Sprite(e.target).y + _Panel.y + 28 ));*/
			this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Alchemy", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MTL", ProxyPVEStrList.ALCHEMY_TIPS, { _rGuid:this._CurrentItemDisplay.ItemData._guid, _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type } , Sprite(e.target).x + _Panel.x - 7 , Sprite(e.target).y + _Panel.y + 28 ));
			TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
		}
		private function RollOut(e:MouseEvent):void
		{
			TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
			TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
		}
		//
		public function AddInform():void 
		{
			this._AskPanel.AddInform();
		}
		//商城
		public function GetPay(_Price:uint, _Name:int):void 
		{
			this._CurrentDiamond = _Name;
			//Sprite(this._viewConterBox.getChildByName("" + this._CurrentDiamond)).visible = false;
			//this._viewConterBox.removeChild(this._viewConterBox.getChildByName("" + _Name));
			this._AskPanel.AddMsgText(" 快速完成排程需要支付" + _Price + "晶鑽", 65);
			this._viewConterBox.addEventListener(MouseEvent.CLICK, PayClickHand);
		}
		
		private function PayClickHand(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "Make0"://yes
					Sprite(Sprite(this._SchedulePanelBg.getChildByName("CurrentListBoard" + this._CurrentDiamond)).getChildByName("" + this._CurrentDiamond)).visible = false;
					var _Num:Object = { _Num:this._CurrentDiamond };
					this.SendNotify(UICmdStrLib.Consumption,_Num);
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
		public function RemoveInform():void
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, PayClickHand);
			this._AskPanel.RemovePanel();
		}
		
		//滑鼠效果
		private function MouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			if (btn.name == "CloseBtn" )btn.addEventListener(MouseEvent.CLICK, BtnEffect);
		}
		private function BtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					if (e.target.name != "Make0" && e.target.name != "Make1") MovieClip(e.target).gotoAndStop(2);
					if (e.target.name == "Make0" || e.target.name == "Make1") TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				break;
				case "rollOut":
					if (e.target.name != "Make0" && e.target.name != "Make1")MovieClip(e.target).gotoAndStop(1);
					if (e.target.name == "Make0" || e.target.name == "Make1") TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				break;
				case "click":
					if (e.target.name == "CloseBtn" ) TweenLite.to(this._viewConterBox.getChildByName("Panel"), 0.3, { x:373, y:153, scaleX:0.5, scaleY:0.5 , onComplete:RemoveALL } );
				break;
			}
		}
		private function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.removeEventListener(MouseEvent.CLICK, BtnEffect);
		}
		
		private function RemoveALL():void
		{
			this.SendNotify( UICmdStrLib.RemoveALL);
			this.RemovePanel();
		}
		public function RemovePanel():void
		{
			if (this._viewConterBox.getChildByName("Panel") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Panel"));
			if (this._viewConterBox.getChildByName("AlphaBox") != null)this._viewConterBox.removeChild(this._viewConterBox.getChildByName("AlphaBox"));
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