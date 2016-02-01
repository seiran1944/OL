package MVCprojectOL.ViewOL.MonsterView 
{
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import strLib.vewStr.ViewStrLib;
	//import MVCprojectOL.ModelOL.ShowSideSys.EquAndEatStone;
	//import MVCprojectOL.ModelOL.ShowSideSys.PreviewBox;
	//import MVCprojectOL.ModelOL.ShowSideSys.SystemStrTIPS;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.PreviewBox;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.SystemStrTIPS;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.DissolveStrLib;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	/**
	 * ...
	 * @author brook
	 */
	public class MonsterPanel extends ViewCtrl
	{
		protected var _Name:String;
		protected var _BGObj:Object;
		protected var _MonsterDisplay:Vector.<MonsterDisplay>;
		protected var _CurrentTabM:int;
		protected var _CurrentItemDisplay:ItemDisplay;
		protected var _PageList:Array = null;
		protected var _CtrlPageNum:int;
		protected var _SlidingControl:SlidingControl;
		protected var _MonsterMenuSP:Vector.<Sprite>;
		protected var _CurrentNum:int = 0;
		protected var _SortBoolean:Boolean = true;
		protected var _CurrentNumerical:String = PlaySystemStrLab.Sort_LV;
		protected var _CurrentListBoard:Sprite;
		protected var _ClickBoolean:Boolean;
		protected var _MyPageLength:int;
		protected var _MonsterMenu:Vector.<MonsterDisplay>;
		protected var _BuildingLV:uint;
		protected var _MonsterRank:int;
		protected var _CurrentMonsterName:String;
		protected var _CurrentGuid:String;
		protected var _lvEquipment:int;
		protected var _AssemblyMonsterMenu:AssemblyMonsterMenu = new AssemblyMonsterMenu();
		private var _TipsView:TipsView = new TipsView("MonsterPanel");//---tip---
		private var _vecStampStr:Vector.<String> = new < String > ["Group"];
		private var _NewGuid:String = "";
		private var _MonsterPages:int = 0;
		
		
		public function MonsterPanel(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			TweenPlugin.activate([BlurFilterPlugin]);
			super( _InputViewName , _InputConter );
		}
		public function AddElement(_InputName:String, _InputMonster:Vector.<MonsterDisplay>, _GlobalObj:Object, _CurrentTabM:int = -1 , _CurrentItemDisplay:ItemDisplay = null, _MonsterRank:int = -1, _CurrentMonster:String = "", _CurrentGuid:String = ""):void
		{
			this._Name = _InputName;
			this._BGObj = _GlobalObj
			this._MonsterDisplay = _InputMonster;
			this._CurrentTabM = _CurrentTabM;
			this._CurrentItemDisplay = _CurrentItemDisplay;
			this._MonsterRank = _MonsterRank;
			this._CurrentMonsterName = _CurrentMonster;
			this._CurrentGuid = _CurrentGuid;
		}
		//
		public function StorageData(_lvEquipment:int):void 
		{
			this._lvEquipment = _lvEquipment;
		}
		public function AddNewGuid(_NewGuid:String):void
		{
			this._NewGuid = _NewGuid;
		}
		
		public function AssemblyPanel(_PanelX:int = 312, _PanelY:int = 127, _BgBW:int = 750, BgBH:int = 510, _TitleW:int = 400, _TitleName:String = "出征大廳", _TextBgW:int = 240, _TextBgH:int = 90, _TextBgX:int = 505, _TextBgY:int = 470 ):void
		{
			var _AlphaBox:Sprite; 
			_AlphaBox = this.DrawRect(0, 0, 1000, 700);
			_AlphaBox.name = "AlphaBox";
			_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			var _Panel:Sprite = new Sprite();
				_Panel.x = _PanelX;//265 + 215-107;240
				_Panel.y = _PanelY;//25 + 255-127;127
				_Panel.scaleX = 0.5;
				_Panel.scaleY = 0.5;
				_Panel.name = "Panel";
			this._viewConterBox.addChild(_Panel);
			
			var _BgB:Sprite = new (this._BGObj.BgB as Class);
				_BgB.width = _BgBW;//960
				_BgB.height = BgBH;//510
				_BgB.x = 20;
				_BgB.y = 70;
			_Panel.addChild(_BgB);
			
			var _ExplainBtn:MovieClip = new (this._BGObj.ExplainBtn as Class);
				_ExplainBtn.x = _BgB.x + 10;
				_ExplainBtn.y = _BgB.y + 10;
				_ExplainBtn.name = "ExplainBtn";
				_ExplainBtn.buttonMode = true;
			_Panel.addChild(_ExplainBtn);
			this.MouseEffect(_ExplainBtn);
			this._TipsView.MouseEffect(_ExplainBtn);
			
			var _CloseBtn:MovieClip = new (this._BGObj.CloseBtn as Class);
				_CloseBtn.x = _BgB.width - 15;
				_CloseBtn.y = _BgB.y + 10;
				_CloseBtn.name = "CloseBtn";
				_CloseBtn.buttonMode = true;
			_Panel.addChild(_CloseBtn);
			this.MouseEffect(_CloseBtn);
			this._TipsView.MouseEffect(_CloseBtn);
			
			var _Title:Sprite = new (this._BGObj.Title as Class);
				_Title.width = _TitleW;//845
				_Title.x = (_BgB.width / 2) - (_Title.width / 2) + _BgB.x;
				_Title.y = -500;
			_Panel.addChild(_Title);
			var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xf4f0c1, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
				_TextObj._str = _TitleName;//"惡魔巢穴"
			var _TitleText:Text = new Text(_TextObj);
				_TitleText.x = 95;
				_TitleText.y = 7;
				_TitleText.mouseEnabled = false;
			_Title.addChild(_TitleText);
			TweenLite.to(_Title, 1, { y:85 } );
			
			var _EdgeBg:Sprite;
			for (var k:int = 0; k < 2; k++) 
			{
				_EdgeBg = new (this._BGObj.EdgeBg as Class);
				(k == 0)?_EdgeBg.scaleY = -1:_EdgeBg.scaleY = 1;
				(k == 0)?_EdgeBg.y =  90:_EdgeBg.y = _BgB.height + 40;
				_EdgeBg.x = _BgB.width / 2 + _BgB.x;
				_Panel.addChild(_EdgeBg);
			}
			
			this.AddPanelBtn();
			this.AddTitleBtn();
			
			this.ZoomIn(_Panel, _BgB.width, _BgB.height, 0.5);
		}
		protected function ZoomIn(_InputSp:Sprite,_OriginalWidth:int,_OriginalHeight:int,_Proportion:Number):void
		{
			var _NewX:int = _InputSp.x - ((_OriginalWidth * _Proportion)) * _Proportion;
			var _NewY:int = _InputSp.y - ((_OriginalHeight * _Proportion)) * _Proportion;
			TweenLite.to(_InputSp, 1, { x:_NewX, y:_NewY, scaleX:1, scaleY:1 , ease:Elastic.easeOut } );
			//trace(_NewX,_NewY,"@@@@@@@@@");
		}
		
		protected function AddTitleBtn():void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _TitleBtn:Sprite;
			var _AryProperty:Array = this._BGObj.PropertyImages;
			var _PropertyBit:Bitmap;
			var _Property:Sprite;
			var _TextObj:Object = { _str:"", _wid:30, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
			var _PropertyText:Text;
			for (var i:int = 0; i < 7; i++) 
			{
				_TitleBtn = new (this._BGObj.TitleBtn as Class);
				_TitleBtn.x = 50;
				_TitleBtn.y = 100;
				_TitleBtn.name = "TitleBtn" + i;
				_TitleBtn.buttonMode = true;
				_TitleBtn.alpha = 0;
				_TitleBtn.addEventListener(MouseEvent.CLICK, TitleBtnHandler);
				_Panel.addChild(_TitleBtn);
				TweenLite.to(_TitleBtn, 2, { alpha:(i == 0)?1:null } );
				this.MouseEffect(_TitleBtn);
				
				_Property = new Sprite();
				(i == 0 )?_PropertyBit = new Bitmap(_AryProperty[6]):_PropertyBit = new Bitmap(_AryProperty[i - 1]);
				_Property.addChild(_PropertyBit);
				if (i == 0) _TextObj._str = "LV";
				if (i == 1) _TextObj._str = "HP";
				if (i == 2) _TextObj._str = "ATK";
				if (i == 3) _TextObj._str = "DEF";
				if (i == 4) _TextObj._str = "INT";
				if (i == 5) _TextObj._str = "WIS";
				if (i == 6)_TextObj._str = "SPD";
				_Property.x = 5;
				_Property.y = 2;
				_Property.width = 18;
				_Property.height = 18;
				_TitleBtn.addChild(_Property);
				
				_PropertyText = new Text(_TextObj);
				_PropertyText.x = 25;
				_PropertyText.y = 0;
				_TitleBtn.addChild(_PropertyText);
			}
			_Panel.setChildIndex(_Panel.getChildByName("TitleBtn0"), _Panel.numChildren - 1);
			
			var _SortBtn:MovieClip = new (this._BGObj.SortBtn as Class);
				_SortBtn.x = 130;
				_SortBtn.y = 105;
				_SortBtn.alpha = 0;
				_SortBtn.name = "SortBtn";
				_SortBtn.buttonMode = true;
			_Panel.addChild(_SortBtn);
			TweenLite.to(_SortBtn, 1, { alpha:1 } );
			this.MouseEffect(_SortBtn);
		}
		
		protected function AddPanelBtn():void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _SlidingContainer:Sprite = new Sprite();
				_SlidingContainer.name = "SlidingContainer";
			this._SlidingControl = new SlidingControl( _SlidingContainer );
			_Panel.addChild( _SlidingContainer );
			//this._viewConterBox.setChildIndex( this._viewConterBox.getChildByName("SlidingContainer"), this._viewConterBox.numChildren - 1 );
			
			var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
			/*var _Tab:Sprite = new (this._BGObj.Tab as Class);
				_Tab.x = 235;
				_Tab.y = 540;
			_Panel.addChild(_Tab);*/
			var _PageBtnS:MovieClip;
			for (var j:int = 0; j < 2; j++) 
			{
				_PageBtnS = new (this._BGObj.PageBtnS as Class);
				_PageBtnS.x = 225 + j * 80;
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
				_PageText.x = 249;
				_PageText.y = 530;
				_PageText.name = "PageText";
				_PageText.mouseEnabled = false;
			_Panel.addChild(_PageText);
			
			var _PageSP:Sprite = this.DrawRect(0, 0, _PageText.width, _PageText.height);
				_PageSP.x = _PageText.x;
				_PageSP.y = _PageText.y;
				_PageSP.name = "PageSP";
				_PageSP.alpha = 0;
			_Panel.addChild(_PageSP);
			this._TipsView.MouseEffect(_PageSP);
			
			this.FilterMonster();
		}
		//
		public function GetBuildingLV(_BuildingLV:uint):void
		{
			this._BuildingLV = _BuildingLV;
		}
		//更新怪物資訊
		public function UpdateMonster(_InputMonster:Vector.<MonsterDisplay>, _InputSortString:String):void
		{
			this._MonsterDisplay = _InputMonster;
			this._CurrentNumerical = _InputSortString;
			this.FilterMonster();
		}
		//篩選顯示惡魔
		protected function FilterMonster():void
		{
			this._MonsterMenu = new Vector.<MonsterDisplay>;
			var i:int;
			switch (this._Name) 
			{
				case "Monster":
					for (i = 0; i < this._MonsterDisplay.length; i++) {
						(this._MonsterDisplay[i].MonsterData._useing == 2 )?null:this._MonsterMenu.push(this._MonsterDisplay[i]);
					}	
				break;
				case "Storage":
					for (i = 0; i < this._MonsterDisplay.length; i++) {
						if (this._CurrentTabM == 0) (this._MonsterDisplay[i].MonsterData._useing == 2 || this._MonsterDisplay[i].MonsterData._lv <= this._MonsterDisplay[i].MonsterData._eatStoneRange)?null:this._MonsterMenu.push(this._MonsterDisplay[i]);
						if (this._CurrentTabM == 1 || this._CurrentTabM == 2 || this._CurrentTabM == 3) (this._MonsterDisplay[i].MonsterData._useing == 2 || this._MonsterDisplay[i].MonsterData._lv < this._lvEquipment)?null:this._MonsterMenu.push(this._MonsterDisplay[i]);
					}
				break;
				case "Dissolve":
					for (i = 0; i < this._MonsterDisplay.length; i++) {
						(this._MonsterDisplay[i].MonsterData._useing != 1 || this._MonsterDisplay[i].MonsterData._teamGroup != "" || this._MonsterDisplay[i].MonsterData._dissoLv > this._BuildingLV )?null:this._MonsterMenu.push(this._MonsterDisplay[i]);
					}
				break;
				case "Library":
					for (i = 0; i < this._MonsterDisplay.length; i++) {
						(this._MonsterDisplay[i].MonsterData._useing == 2 )?null:this._MonsterMenu.push(this._MonsterDisplay[i]);
					}
				break;
				case "Evolution":
					for (i = 0; i < this._MonsterDisplay.length; i++) {
						if (this._MonsterDisplay[i].MonsterData._showName == this._CurrentMonsterName && this._MonsterDisplay[i].MonsterData._rank == this._MonsterRank - 1) {
							if (this._MonsterDisplay[i].MonsterData._guid != this._CurrentGuid) this._MonsterMenu.push(this._MonsterDisplay[i]);
						}
					}
				break;
				
			}
			this.AddMonsterMenu();
		}
		
		protected function AddMonsterMenu():void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			
			this._CtrlPageNum = 0;
			var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
			this._PageList = _SplitPageMethod.SplitPage(this._MonsterMenu, 6);
			
			var _Btn0:MovieClip = MovieClip(_Panel.getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(_Panel.getChildByName("btn1"));
			if (this._PageList.length != 0 && this._PageList.length != 1)  {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = true;
			}else {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = false;
			}
			
			if (this._Name == "Monster" && this._NewGuid != "")
			{
				var _len:int = this._MonsterMenu.length;
				for (var i:int = 0; i < _len; i++) 
				{
					if (this._MonsterMenu[i].MonsterData._guid == this._NewGuid) {
						this._CtrlPageNum = int(i / 6);
						this._MonsterPages = int(i % 6);
					}
				}
			}
			
			this._PageList.length != 0?Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + 1 + " / " + this._PageList.length):Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + " / " + this._PageList.length);
			this.CtrlPage(this._CtrlPageNum , false );
		}
		
		public function SelectMonster():void 
		{
			var _len:int = this._MonsterMenu.length;
			for (var i:int = 0; i < _len; i++) 
			{
				if (this._MonsterMenu[i].MonsterData._guid == this._NewGuid) {
					this._CtrlPageNum = int(i / 6);
					this._MonsterPages = int(i % 6);
					this.CtrlPage(this._CtrlPageNum , false );
				}
			}
		}
		
		protected function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			
			var _MyPage:Array = this._PageList[_InputPage];
			(_MyPage == null)? this._MyPageLength = 0:this._MyPageLength = _MyPage.length;
			(_MyPage == null)?Text(_Panel.getChildByName("PageText")).ReSetString(0 + " / " + this._PageList.length):Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + 1 + " / " + this._PageList.length);
			this._MonsterMenuSP = new Vector.<Sprite>;
			var _CurrentMonster:MonsterDisplay;
			
			for (var i:int = 0; i < 6 ; i++) {
				if (i < this._MyPageLength) {
					_CurrentMonster = _MyPage[i];
					_CurrentMonster.ShowContent();
					_CurrentMonster.setStampSetting(_vecStampStr);
					_CurrentMonster.AddStamp = true;//惡魔蓋章
					_CurrentMonster.Alive = true;//惡魔動畫
					this._MonsterMenuSP.push(this._AssemblyMonsterMenu.AddMonsterMenu( this._BGObj, _CurrentMonster.MonsterBody, _CurrentMonster.MonsterData, ""));
					//----使用狀態-0.刪除, 1.閒置（在巢穴）, 2.溶解中, 3.學習中, 4.戰鬥中, 5.掛賣中-----
					(this._Name == "Library")?(_CurrentMonster.MonsterData._useing == 3)?this._AssemblyMonsterMenu.ButtonMode():this._MonsterMenuSP[i].addEventListener(MouseEvent.CLICK, MonsterClickHandler):this._MonsterMenuSP[i].addEventListener(MouseEvent.CLICK, MonsterClickHandler);
					this.MouseEffect(this._MonsterMenuSP[i]);
				}else {
					this._MonsterMenuSP.push(this._AssemblyMonsterMenu.AddMonsterMenu( this._BGObj) );
				}
				
			}
			
			this._SlidingControl._Cols = 3;
			this._SlidingControl._Rows = 2;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 155;
			this._SlidingControl._VerticalInterval = 205;
			this._SlidingControl._RightInPosX = 315;
			this._SlidingControl._LeftInPosX = 0;
			this._SlidingControl.NextPage(this._MonsterMenuSP, _CtrlBoolean);
			
			if (this._Name == "Monster") { 
				var _Wrap:Object = new Object();
					_Wrap["_guid"] = this._MonsterMenuSP[this._MonsterPages].name;
				this.SendNotify( MonsterCageStrLib.MonsterInformation, _Wrap );
					
				this._CurrentListBoard = this._MonsterMenuSP[this._MonsterPages];
				TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				this.RemoveMouseEffect(this._CurrentListBoard);
				this._CurrentListBoard.removeEventListener(MouseEvent.CLICK, MonsterClickHandler);
			}
			
			if (this._Name == "Storage" || this._Name == "Evolution") { 
				var _Storage:Object = new Object();
					_Storage["_guid"] = null;
				this.SendNotify( MonsterCageStrLib.MonsterInformation, _Storage );
			}
			
			if (this._Name == "Library") this.CheckBtnHandler();
		}
		
		//翻頁
		protected function _onClickHandler(e:MouseEvent):void
		{
			this._MonsterPages = 0;
			if(this._SortBoolean == false)this.SortBtnMove(this._CurrentNum);
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _Btn0:MovieClip = MovieClip(_Panel.getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(_Panel.getChildByName("btn1"));
				switch(e.currentTarget.name)
				{
					case "btn0":
						if (this._CtrlPageNum != 0) {
							this._CtrlPageNum == this._PageList.length-1?_Btn1.gotoAndStop(1):null;
							this._CtrlPageNum == 1?MovieClip(e.currentTarget).gotoAndStop(1):null;
							this._CtrlPageNum <= 0?this._CtrlPageNum = this._CtrlPageNum:(this._CtrlPageNum --) && (this.CtrlPage(this._CtrlPageNum, false));
						}
					break;
					case "btn1":
						if (this._CtrlPageNum != this._PageList.length - 1 && this._PageList.length > 1) {
							this._CtrlPageNum == 0?_Btn0.gotoAndStop(1):null;
							this._CtrlPageNum == this._PageList.length-2?MovieClip(e.currentTarget).gotoAndStop(1):null;
							this._CtrlPageNum ++;
							this._CtrlPageNum < this._PageList.length?this.CtrlPage(this._CtrlPageNum, true):this._CtrlPageNum --;
						}
					break;
				}
			this._CtrlPageNum == 0?_Btn0.buttonMode = false:_Btn0.buttonMode = true;
			(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1) ?_Btn1.buttonMode = false:_Btn1.buttonMode = true;
		}
		protected function _onRollOverBtnHandler(e:MouseEvent):void
		{
			var _Btn:MovieClip = MovieClip(e.currentTarget);
			switch(e.currentTarget.name)
			{
				case "btn0":
					this._CtrlPageNum == 0?_Btn.gotoAndStop(1):_Btn.gotoAndStop(2);
				break;
				case "btn1":
					(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1)?_Btn.gotoAndStop(1):_Btn.gotoAndStop(2);
				break;
			}
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _Btn0:MovieClip = MovieClip(_Panel.getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(_Panel.getChildByName("btn1"));
			this._CtrlPageNum == 0?_Btn0.buttonMode = false:_Btn0.buttonMode = true;
			(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1) ?_Btn1.buttonMode = false:_Btn1.buttonMode = true;
		}
		protected function _onRollOutBtnHandler(e:MouseEvent):void
		{
			var _Btn:MovieClip = MovieClip(e.currentTarget);
			switch(e.currentTarget.name)
			{
				case "btn0":
					this._CtrlPageNum == 0?_Btn.gotoAndStop(1):_Btn.gotoAndStop(1);
				break;
				case "btn1":
					(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1)?_Btn.gotoAndStop(1):_Btn.gotoAndStop(1);
				break;
			}
		}
		
		protected function SortBtnMove(_InputName:int):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
				_Panel.getChildByName("SortBtn").removeEventListener(MouseEvent.CLICK, BtnEffect);
			for (var j:int = 0; j < 7; j++) _Panel.getChildByName("TitleBtn" + j).removeEventListener(MouseEvent.CLICK, TitleBtnHandler);
			for (var i:int = 6; i >= 0; i-- ) (this._SortBoolean == true)?TweenLite.to(Sprite(_Panel.getChildByName("TitleBtn" + i)), 0.3, { y:Sprite(_Panel.getChildByName("TitleBtn" + i)).y + (i * 25), alpha:1, delay: i * 0.05, onComplete:(i == 6)?CtrlSortBoolean:null, onCompleteParams:[this._SortBoolean] } ):TweenLite.to(Sprite(_Panel.getChildByName("TitleBtn" + i)), 0.3, { y:Sprite(_Panel.getChildByName("TitleBtn" + i)).y - (i * 25), alpha:(_InputName == i)?1:0, delay: i * 0.05, onComplete:(i == 6)?CtrlSortBoolean:null, onCompleteParams:[this._SortBoolean] } );
		}
		protected function CtrlSortBoolean(_InputBoolean:Boolean):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _SortBtn:Sprite = Sprite(_Panel.getChildByName("SortBtn"));
				_SortBtn.addEventListener(MouseEvent.CLICK, BtnEffect);
			for (var j:int = 0; j < 7; j++) _Panel.getChildByName("TitleBtn" + j).addEventListener(MouseEvent.CLICK, TitleBtnHandler);
			if (_InputBoolean == true) {
				this._SortBoolean = false;
				_SortBtn.scaleY = -1;
				_SortBtn.y = 120;
			}else {
				this._SortBoolean = true;
				_SortBtn.scaleY = 1;
				_SortBtn.y = 105;
			}
		}
		//屬性按鈕
		protected function TitleBtnHandler(e:MouseEvent):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			_Panel.setChildIndex(_Panel.getChildByName(e.currentTarget.name), _Panel.numChildren - 1);
			_Panel.setChildIndex(_Panel.getChildByName("SortBtn"), _Panel.numChildren - 1);
			switch(e.currentTarget.name) 
			{
				case "TitleBtn0":
					this._CurrentNumerical = PlaySystemStrLab.Sort_LV;
					this._CurrentNum = 0;
				break;
				case "TitleBtn1":
					this._CurrentNumerical = PlaySystemStrLab.Sort_HP;
					this._CurrentNum = 1;
				break;
				case "TitleBtn2":
					this._CurrentNumerical = PlaySystemStrLab.Sort_Atk;
					this._CurrentNum = 2;
				break;
				case "TitleBtn3":
					this._CurrentNumerical = PlaySystemStrLab.Sort_Def;
					this._CurrentNum = 3;
				break;
				case "TitleBtn4":
					this._CurrentNumerical = PlaySystemStrLab.Sort_Int;
					this._CurrentNum = 4;
				break;
				case "TitleBtn5":
					this._CurrentNumerical = PlaySystemStrLab.Sort_Mnd;
					this._CurrentNum = 5;
				break;
				case "TitleBtn6":
					this._CurrentNumerical = PlaySystemStrLab.Sort_Speed;
					this._CurrentNum = 6;
				break;
			}
			this.SortBtnMove(this._CurrentNum);
			var _Wrap:Object = new Object();
				_Wrap["_sort"] = this._CurrentNumerical ;
				_Wrap["CtrlNum"] = -1;
				//(this._CtrlNum == 1)?_Wrap["CtrlNum"] = 1:_Wrap["CtrlNum"] = -1;
			this.SendNotify( MonsterCageStrLib.SortNumerical , _Wrap );
		}
		
		protected function RemovePanel():void
		{
			this.SendNotify( MonsterCageStrLib.RemoveALL);
		}
		
		//滑鼠滑入滑出效果
		protected function MouseEffect(btn:*):void
		{
			var _Btn:Sprite = Sprite(btn);
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			if (_Btn.name == "SortBtn" || _Btn.name == "CloseBtn") btn.addEventListener(MouseEvent.CLICK, BtnEffect);
		}
		protected function BtnEffect(e:MouseEvent):void 
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			switch (e.type) 
			{
				case "rollOver":
					if (e.target.name != "SortBtn" && e.target.name != "CloseBtn" && e.target.name != "ExplainBtn") this.AddTip(Sprite(e.currentTarget));
					if (e.target.name == "SortBtn" || e.target.name == "CloseBtn" || e.target.name == "ExplainBtn") MovieClip(e.target).gotoAndStop(2);
					if (e.target.name != "SortBtn" && e.target.name != "CloseBtn" && e.target.name != "ExplainBtn") TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				break;
				case "rollOut":
					if (e.target.name != "SortBtn" && e.target.name != "CloseBtn"&& e.target.name != "ExplainBtn") this.RemoveTip();
					if (e.target.name == "SortBtn" || e.target.name == "CloseBtn" || e.target.name == "ExplainBtn") MovieClip(e.target).gotoAndStop(1);
					if (e.target.name != "SortBtn" && e.target.name != "CloseBtn"&& e.target.name != "ExplainBtn") TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				break;
				case "click":
					this.ClickHandler(e.target.name);
				break;
			}
		}
		//移除滑入滑出效果
		protected function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.removeEventListener(MouseEvent.CLICK, BtnEffect);
		}
		
		protected function RemoveClickHandler():void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			for (var i:int = 0; i <this._MyPageLength ; i++) 
			{
				this._MonsterMenu[i].Alive = false;
				this._SlidingControl.CurrentGuests[i].removeEventListener(MouseEvent.CLICK, MonsterClickHandler);
				this.RemoveMouseEffect(this._SlidingControl.CurrentGuests[i]);
				//TweenLite.to(this._SlidingControl.CurrentGuests[i], 1, { blurFilter: { blurX:20, blurY:20 }} );
				TweenLite.to(this._SlidingControl.CurrentGuests[i], 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
			}
			for (var j:int = 0; j < 2; j++) 
			{
				Sprite(_Panel.getChildByName("btn" + j)).removeEventListener(MouseEvent.CLICK, _onClickHandler);
				Sprite(_Panel.getChildByName("btn" + j)).removeEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler );
				Sprite(_Panel.getChildByName("btn" + j)).removeEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler );
			}
		}
		
		public function RecoverBtn():void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			for (var i:int = 0; i <this._MyPageLength ; i++) 
			{
				this._MonsterMenu[i].Alive = true;
				this._SlidingControl.CurrentGuests[i].addEventListener(MouseEvent.CLICK, MonsterClickHandler);
				this.MouseEffect(this._SlidingControl.CurrentGuests[i]);
				//TweenLite.to(this._SlidingControl.CurrentGuests[i], 1, { blurFilter: { blurX:0, blurY:0 }} );
			}
			if (_Panel != null) { 
				for (var j:int = 0; j < 2; j++) 
				{
					Sprite(_Panel.getChildByName("btn" + j)).addEventListener(MouseEvent.CLICK, _onClickHandler);
					Sprite(_Panel.getChildByName("btn" + j)).addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler );
					Sprite(_Panel.getChildByName("btn" + j)).addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler );
				}
			}
		}
		
		protected function AddTip(_Monster:Sprite):void
		{
			var _CurrentMonster:Object = new Object();
			switch(this._Name)
			{
				case "Storage":
					if (this._CurrentTabM == 1 || this._CurrentTabM == 2 || this._CurrentTabM == 3) {
						_CurrentMonster["CurrentTabM"] = this._CurrentTabM;
						_CurrentMonster["IconName"] = this._CurrentItemDisplay.ItemData._guid;
						_CurrentMonster["gruopGuid"] = this._CurrentItemDisplay.ItemData._gruopGuid;
						_CurrentMonster["guid"] = _Monster.name;
						_CurrentMonster["showName"] = this._CurrentItemDisplay.ItemData._showName;
						_CurrentMonster["picItem"] = this._CurrentItemDisplay.ItemData._picItem;
						this.SendNotify( UICmdStrLib.MonsterTip, _CurrentMonster);
					}
					if (this._CurrentTabM == 0) {
						_CurrentMonster["CurrentTabM"] = this._CurrentTabM;
						_CurrentMonster["IconName"] = this._CurrentItemDisplay.ItemData._guid;
						_CurrentMonster["guid"] = _Monster.name;
						_CurrentMonster["showName"] = this._CurrentItemDisplay.ItemData._showName;
						_CurrentMonster["picItem"] = this._CurrentItemDisplay.ItemData._picItem;
						this.SendNotify( UICmdStrLib.MonsterTip, _CurrentMonster);
					}
					this.Storage(_Monster);
				break;
				case "Evolution" :
					this.Storage(_Monster);
				break;
			}
		}
		protected function RemoveTip():void
		{
			var _CurrentMonster:Object = new Object();
			switch(this._Name)
			{
				case "Storage":
					_CurrentMonster["CurrentTabM"] = this._CurrentTabM;
					this.SendNotify( UICmdStrLib.RemoveMonsterTip, _CurrentMonster);
					
					var _Storage:Object = new Object();
						_Storage["_guid"] = null;
					this.SendNotify( MonsterCageStrLib.MonsterInformation,_Storage );
				break;
			}
		}
		public function JudgeClick(_InputAny:*):void 
		{
			switch ( true ) 
			{
				case _InputAny is PreviewBox:
					this._ClickBoolean = true;
				break;
				case _InputAny is SystemStrTIPS:
					this._ClickBoolean = false;
				break;
			}
		}
		
		//點擊按鈕判斷
		protected function ClickHandler(_TargetName:String):void
		{
			switch (this._Name) 
			{
				case "Monster":
					(_TargetName == "SortBtn")?this.SortBtnMove(this._CurrentNum):TweenLite.to(this._viewConterBox.getChildByName("Panel"), 0.3, { x:240, y:127, scaleX:0.5, scaleY:0.5 , onComplete:RemovePanel } );
				break;
				case "Storage":
					(_TargetName == "CloseBtn")?this.RemoveStorag():this.SortBtnMove(this._CurrentNum);
				break;
				case "Dissolve":
					(_TargetName == "CloseBtn")?this.RemoveDissolve():this.SortBtnMove(this._CurrentNum);
				break;
				case "Library":
					(_TargetName == "CloseBtn")?this.RemoveLibrary():this.SortBtnMove(this._CurrentNum);
				break;
				case "Evolution":
					(_TargetName == "CloseBtn")?this.RemoveEvolution():this.SortBtnMove(this._CurrentNum);
				break;
			}
		}
		
		//點擊怪獸
		protected function MonsterClickHandler(e:MouseEvent):void
		{
			var _CurrentMonster:Sprite = Sprite(e.currentTarget);
			switch (this._Name) 
			{
				case "Monster":
					this.Monster(_CurrentMonster);
				break;
				case "Storage":
					this.ClickStorage(_CurrentMonster);
				break;
				case "Dissolve":
					this.Dissolve(_CurrentMonster);
					this.RemoveClickHandler();
				break;
				case "Library":
					this.Library(_CurrentMonster);
				break;
				case "Evolution":
					this.Evolution(_CurrentMonster);
				break;
			}
		}
		
		protected function Monster(_CurrentMonster:Sprite):void
		{
			var _Wrap:Object = new Object();
				_Wrap["_guid"] = _CurrentMonster.name;
			this.SendNotify( MonsterCageStrLib.MonsterInformation, _Wrap );
			
			if(this._CurrentListBoard != null){
				TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				this._CurrentListBoard.addEventListener(MouseEvent.CLICK, MonsterClickHandler);
				this.MouseEffect(this._CurrentListBoard);
			}
			
			this._CurrentListBoard = _CurrentMonster;
			TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
			this._CurrentListBoard.removeEventListener(MouseEvent.CLICK, MonsterClickHandler);
			this.RemoveMouseEffect(this._CurrentListBoard);
		}
		
		protected function Storage(_CurrentMonster:Sprite):void
		{
			var _Wrap:Object = new Object();
				_Wrap["_guid"] = _CurrentMonster.name;
			this.SendNotify( MonsterCageStrLib.MonsterInformation, _Wrap );
			
			if(this._CurrentListBoard != null)TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
			
			this._CurrentListBoard = _CurrentMonster;
			TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
		}
		protected function ClickStorage(_CurrentMonster:Sprite):void
		{
			if (this._ClickBoolean == true) {
				var _MonsterObj:Object = new Object();
					_MonsterObj["guid"] = _CurrentMonster.name;
					_MonsterObj["IconName"] = this._CurrentItemDisplay.ItemData._guid;
				this.RemoveClickHandler();
				this.SendNotify( UICmdStrLib.UseMonsterMenu, _MonsterObj);
			}
		}
		protected function RemoveStorag():void
		{
			this.onRemoved();
			this.SendNotify(  UICmdStrLib.onRemoveALL );
		}
		
		protected function Dissolve(_CurrentMonster:Sprite):void
		{
			var _Wrap:Object = new Object();
				_Wrap["Monster"] = _CurrentMonster;
			this.SendNotify( MonsterCageStrLib.MonsterInformation, _Wrap );//傳送點擊惡魔資訊
		}
		protected function RemoveDissolve():void
		{
			this.onRemoved();
			this.SendNotify(  DissolveStrLib.RemoveALL );
		}
		
		protected function Library(_CurrentMonster:Sprite):void
		{
			var _Wrap:Object = new Object();
				_Wrap["guid"] = _CurrentMonster.name;
			this.SendNotify( UICmdStrLib.CurrentMonsterData, _Wrap);
			
			if(this._CurrentListBoard != null){
			TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
			this._CurrentListBoard.addEventListener(MouseEvent.CLICK, MonsterClickHandler);
			this.MouseEffect(this._CurrentListBoard);
			}
			this._CurrentListBoard = _CurrentMonster;
			TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
			this._CurrentListBoard.removeEventListener(MouseEvent.CLICK, MonsterClickHandler);
			this.RemoveMouseEffect(this._CurrentListBoard);
		}
		protected function CheckBtnHandler():void
		{
			this.SendNotify(UICmdStrLib.CheckBtnHandler);
		}
		protected function RemoveLibrary():void
		{
			this.onRemoved();
			this.SendNotify(UICmdStrLib.LibraryRemoveALL);
		}
		
		protected function Evolution(_CurrentMonster:Sprite):void 
		{
			var _Wrap:Object = new Object();
				_Wrap["guid"] = _CurrentMonster.name;
			this.SendNotify( UICmdStrLib.CurrentMonsterData, _Wrap);
			this.RemoveEvolution();
		}
		protected function RemoveEvolution():void
		{
			this.onRemoved();
			this.SendNotify(UICmdStrLib.onRemoveALL);
		}
		
		//更新血量
		public function UpdataMonster(_Value:int, MonsterGuid:String):void 
		{
			var _MonsterMenu:Sprite;
			for (var i:int = 0; i < this._MonsterMenuSP.length; i++) 
			{
				_MonsterMenu = this._MonsterMenuSP[i];
				if (_MonsterMenu.name == MonsterGuid) this._AssemblyMonsterMenu.UpdataMonster(_Value, _MonsterMenu);
			}
			
		}
		
		protected function DrawRect(_LocationX:int, _LocationY:int, _Width:int, _Height:int):Sprite 
		{
			var _sp:Sprite = new Sprite ();
				_sp.graphics.beginFill(0x000000);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}
		
		override public function onRemoved():void 
		{
			if (this._viewConterBox.getChildByName("AlphaBox") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("AlphaBox"));
			if (this._viewConterBox.getChildByName("Panel") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Panel"));
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
	}
}