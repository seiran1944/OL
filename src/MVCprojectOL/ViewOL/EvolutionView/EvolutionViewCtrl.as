package MVCprojectOL.ViewOL.EvolutionView 
{
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
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	import MVCprojectOL.ViewOL.MonsterView.AssemblyMonsterMenu;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UICmdStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class EvolutionViewCtrl extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel;
		private var _SlidingControl:SlidingControl;
		private var _PageList:Array;
		private var _CtrlPageNum:int = 0;
		private var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
		private var _EvolutionData:Vector.<MonsterDisplay>;
		private var _ListBoardMenuSP:Vector.<Sprite>;
		private var _Recipe:Array;
		private var _CruuentRecipe:int;
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"CENTER", _col:0xF4F0C1, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
		private var _CurrentListBoard:Sprite;
		private var _OtherMonster:String;
		private var _CurrentSourceList:Object = [];
		private var _TipsView:TipsView = new TipsView("Evolution");//---tip---
		
		public function EvolutionViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		
		public function AddElement(_InputObj:Object):void
		{
			this._BGObj = _InputObj;
			
			this._CurrentSourceList["A"] = new Vector.<ItemDisplay>;
			this._CurrentSourceList["B"] = new Vector.<ItemDisplay>;
			
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "EvolutionAlphaBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Panel = new Sprite();
			this._Panel.x = 312;
			this._Panel.y = 127;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "EvolutionPanel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel);
			this._BasisPanel.AddBasisPanel("進化魔殿", 750, 510, 400);
			this._BasisPanel.AddPageBtn(100);
			this._BasisPanel.AddCheckBtn("進化", 660, 520, 85);
			this._Panel.getChildByName("CheckBtn").visible = false;
			
			//
			//this._BasisPanel.AddCheckBtn("轉盤", 660, 480, 85, "Turntable");
			//
			
			this._SlidingControl = new SlidingControl( this._Panel );
			
			var _EvolutionBg:Bitmap = new Bitmap(BitmapData(new (this._BGObj.EvolutionBg as Class)));
				_EvolutionBg.x = 240;
				_EvolutionBg.y = 95;
			this._Panel.addChild(_EvolutionBg);
			
			var _Property:MovieClip = new (this._BGObj.Property as Class);
				_Property.x = 450;
				_Property.y = 150;
				_Property.gotoAndStop(7);
			this._Panel.addChild(_Property);
			this._TextObj._str = "0";
			var _PropertyNum:Text = new Text(_TextObj);
				_PropertyNum.x = 490;
				_PropertyNum.y = 152;
				_PropertyNum.name = "PropertyNum";
			this._Panel.addChild(_PropertyNum);	
			var _PropertyBox:Sprite = this._SharedEffect.DrawRect(0, 0, 55, 15);
				_PropertyBox.x = 450;
				_PropertyBox.y = 155;
				_PropertyBox.name = "PropertyBox";
				_PropertyBox.alpha = 0;
			this._Panel.addChild(_PropertyBox);
			this._TipsView.MouseEffect(_PropertyBox);
			
			this._TextObj._str = "0";
			this._BasisPanel.AddFatigue(0.5, 0.5, 450, 180);
			var _FatigueNum:Text = new Text(_TextObj);
				_FatigueNum.x = 490;
				_FatigueNum.y = 182;
				_FatigueNum.name = "FatigueNum";
			this._Panel.addChild(_FatigueNum);
			var _FatigueBox:Sprite = this._SharedEffect.DrawRect(0, 0, 60, 25);
				_FatigueBox.x = 450;
				_FatigueBox.y = 180;
				_FatigueBox.name = "FatigueBox";
				_FatigueBox.alpha = 0;
			this._Panel.addChild(_FatigueBox);
			this._TipsView.MouseEffect(_FatigueBox);
			
			var _DemonAvatar:Bitmap = new Bitmap(BitmapData(new(this._BGObj.DemonAvatar as Class)));
				_DemonAvatar.x = 420;
				_DemonAvatar.y = 250;
				_DemonAvatar.name = "DemonAvatar";
				_DemonAvatar.visible = false;
			this._Panel.addChild(_DemonAvatar);	
			
			var _Box:Bitmap;
			var _SourceNum:Text;
			for (var i:int = 0; i < 5; i++) 
			{
				_Box = new Bitmap(BitmapData(new(this._BGObj.Box as Class)));
				(i < 3)?_Box.x = 270:_Box.x = 325;
				(i < 3)?_Box.y = 300 + i * 70:_Box.y = 340 + (i % 3) * 70;
				_Box.name = "BoxA" + i;
				//_Box.visible = false;
				this._Panel.addChild(_Box);
				_SourceNum = new Text(_TextObj);
				(i < 3)?_SourceNum.x = 290:_SourceNum.x = 345;
				(i < 3)?_SourceNum.y = 345 + i * 70:_SourceNum.y = 385 + (i % 3) * 70;
				_SourceNum.name = "A" + i;
				this._Panel.addChild(_SourceNum);
			}
			for (var j:int = 0; j < 5; j++) 
			{
				_Box = new Bitmap(BitmapData(new(this._BGObj.Box as Class)));
				(j < 2)?_Box.x = 620:_Box.x = 675;
				(j < 2)?_Box.y = 340 + j * 70:_Box.y = 300 + (j % 3) * 70;
				_Box.name = "BoxB" + j;
				//_Box.visible = false;
				this._Panel.addChild(_Box);
				_SourceNum = new Text(_TextObj);
				(j < 3)?_SourceNum.x = 640:_SourceNum.x = 695;
				(j < 3)?_SourceNum.y = 385 + j * 70:_SourceNum.y = 345 + (j % 3) * 70;
				_SourceNum.name = "B" + j;
				this._Panel.addChild(_SourceNum);
			}
		}
		
		//進化惡魔
		public function MonsterElement(_InputMonsterDisplayList:Vector.<MonsterDisplay>, _Recipe:Array, _CtrlBoolean:Boolean = false):void
		{
			if (_CtrlBoolean == true) this.RemoveList();
			this._CtrlPageNum = 0;
			this._SlidingControl.ClearStage();
			this._Recipe = _Recipe;
			this._EvolutionData = _InputMonsterDisplayList;
			
			this._PageList = this._SplitPageMethod.SplitPage(this._EvolutionData, 6);
			this.CtrlPage(this._CtrlPageNum, true);
		}
		public function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ):void
		{
			if (this._CtrlPageNum != _InputPage) {
				this.RemoveList();
				this._CtrlPageNum = _InputPage;
			}
			var _MyPage:Array = this._PageList[_InputPage];
			var _MyPageLength:uint = (_MyPage == null)?0:_MyPage.length;
			var _CurrentMonster:MonsterDisplay;
			this._ListBoardMenuSP = new Vector.<Sprite>;
			
			for (var i:int = 0; i < 6 ; i++) 
			{
				if (i < _MyPageLength) { 
					_CurrentMonster = _MyPage[i];
					_CurrentMonster.ShowContent();
					this._ListBoardMenuSP.push(this.ListBoardMenu(_CurrentMonster.MonsterHead, _CurrentMonster.MonsterData));
					this._SharedEffect.MouseEffect(this._ListBoardMenuSP[i]);
					this._ListBoardMenuSP[i].addEventListener(MouseEvent.CLICK, ListBoardClickHandler);
				}else {
					this._ListBoardMenuSP.push(this.ListBoardMenu());
				}
			}
			
			this._CurrentListBoard = this._ListBoardMenuSP[0];
			this._CurrentListBoard.name = this._ListBoardMenuSP[0].name;
			this._CurrentListBoard.buttonMode = false;
			this.GetRecipeNum(this._CurrentListBoard.name);
			this._SharedEffect.RemoveMouseEffect(this._CurrentListBoard);
			TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
			
			this._SlidingControl._Cols = 1;
			this._SlidingControl._Rows = 6;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 0;
			this._SlidingControl._VerticalInterval = 65;
			this._SlidingControl._RightInPosX = 0;
			this._SlidingControl._LeftInPosX = 0;
			this._SlidingControl.NextPage(this._ListBoardMenuSP , _CtrlBoolean);
			
			this._BasisPanel.PageData(this._PageList, this._CtrlPageNum);
			
		}
		//物件清單底板
		private function ListBoardMenu(_InputIcon:Sprite = null, _InputData:Object = null):Sprite
		{
			var _ListBoardMenu:Sprite = new Sprite();
			var _TextBg:Sprite = new (this._BGObj.BgM as Class);
				_TextBg.width = 205;
				_TextBg.height = 67;
				_TextBg.x = 40;
				_TextBg.y = 140;
			_ListBoardMenu.addChild(_TextBg);
			
			if (_InputIcon != null) { 
				_ListBoardMenu.buttonMode = true;
				_ListBoardMenu.name = _InputData._guid;
				if (_AssemblyMonsterHead == null) var _AssemblyMonsterHead:AssemblyMonsterHead = new AssemblyMonsterHead();
				_AssemblyMonsterHead.AddData(_ListBoardMenu, _InputIcon, _InputData, this._BGObj, _TextBg.y);
			}
			return _ListBoardMenu;
		}
		
		private function ListBoardClickHandler(e:MouseEvent):void
		{
			if (this._CurrentListBoard.name != e.currentTarget.name) {
				this.RemoveList();
				this._Panel.getChildByName("CheckBtn").visible = false;
				TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				this._SharedEffect.MouseEffect(this._CurrentListBoard);
				this._CurrentListBoard.buttonMode = true;
				
				TweenLite.to( e.currentTarget, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				this._CurrentListBoard = Sprite(e.currentTarget);
				this._CurrentListBoard.name = e.currentTarget.name;
				this._CurrentListBoard.buttonMode = false;
				this._SharedEffect.RemoveMouseEffect(this._CurrentListBoard);
				
				this.GetRecipeNum(e.currentTarget.name);
			}
		}
		private function RemoveList():void 
		{
			for (var i:int = 0; i < 5; i++) 
			{
				if (this._Panel.getChildByName("ListA" + i) != null) this._Panel.removeChild(this._Panel.getChildByName("ListA" + i));
				Text(this._Panel.getChildByName("A" + i)).ReSetString("");
				if (this._Panel.getChildByName("ListB" + i) != null) this._Panel.removeChild(this._Panel.getChildByName("ListB" + i));
				Text(this._Panel.getChildByName("B" + i)).ReSetString("");
			}
		}
		//
		private function GetRecipeNum(_RecipeNmae:String):void 
		{
			for (var j:int = 0; j < this._Recipe.length; j++) 
			{
				for (var k:String in this._Recipe[j]._aryMonster) {
					if (this._Recipe[j]._aryMonster[k]._guid == _RecipeNmae) this._CruuentRecipe = j;
				}	
			}
			//this.AbnormalView();
			(this._Recipe.length != 0)?(this._Recipe[this._CruuentRecipe]._needColorRank == 4 || this._Recipe[this._CruuentRecipe]._needColorRank == 5 || this._Recipe[this._CruuentRecipe]._needColorRank == 6)?this.AbnormalView():this.NormalView():this.AddMonsterMenu();
			
		}
		//是否顯示按鈕
		public function DisplayButton(_CheckNum:int):void 
		{
			(_CheckNum == 1)?this._Panel.getChildByName("CheckBtn").visible = true:this._Panel.getChildByName("CheckBtn").visible = false;
		}
		//
		private function NormalView():void 
		{
			var _CurrentRecipe:Object = this._Recipe[this._CruuentRecipe];
			Text(this._Panel.getChildByName("PropertyNum")).ReSetString(_CurrentRecipe._needLv + " ");
			Text(this._Panel.getChildByName("FatigueNum")).ReSetString(_CurrentRecipe._needMoney + " ");
			if (_CurrentRecipe._sourceFlag == true) {
				var _EvolutionData:Object = [];
					_EvolutionData["Guid"] = this._CurrentListBoard.name;
					_EvolutionData["EvoGuid"] = _CurrentRecipe._recipeID;
				this.SendNotify(UICmdStrLib.CheckEvolution, _EvolutionData);
			}
			for (var i:int = 0; i < 5; i++) 
			{
				Bitmap(this._Panel.getChildByName("BoxA" + i)).visible = true;
				Bitmap(this._Panel.getChildByName("BoxB" + i)).visible = true;
				Text(this._Panel.getChildByName("A" + i)).ReSetString("");
				Text(this._Panel.getChildByName("B" + i)).ReSetString("");
			}
			this.CurrentRecipe();
			this.GetMonster();
		}
		//
		private function AbnormalView():void 
		{
			for (var i:int = 0; i < 5; i++) 
			{
				Bitmap(this._Panel.getChildByName("BoxA" + i)).visible = false;
				Bitmap(this._Panel.getChildByName("BoxB" + i)).visible = false;
			}
			this.GetMonster(false);
			Bitmap(this._Panel.getChildByName("DemonAvatar")).visible = true;
			this._Panel.setChildIndex(Bitmap(this._Panel.getChildByName("DemonAvatar")), this._Panel.numChildren - 1);
		}
		//預覽進化惡魔
		private function GetMonster( _CtrlBoolean:Boolean = true):void 
		{
			var _CurrentRecipe:Object = this._Recipe[this._CruuentRecipe];
			var _GetMonster:Object = [];
			var _CurrentMonster:Object = [];
				_CurrentMonster._guid = _CurrentRecipe._motionItem;
				_CurrentMonster._motionItem = _CurrentRecipe._motionItem;
				_CurrentMonster._lv = 1;
				_CurrentMonster._maxHP = _CurrentRecipe._preHp;
				_CurrentMonster._atk = _CurrentRecipe._preAtk;
				_CurrentMonster._def = _CurrentRecipe._preDef;
				_CurrentMonster._Int = _CurrentRecipe._preInt;
				_CurrentMonster._mnd = _CurrentRecipe._preMnd;
				_CurrentMonster._speed = _CurrentRecipe._preSp;
				_CurrentMonster._showName = _CurrentRecipe._showName;
				_CurrentMonster._rank = _CurrentRecipe._needColorRank;
				_CurrentMonster._jobPic = _CurrentRecipe._jobPic;
			_GetMonster["GetMonster"] = _CurrentMonster;
			_GetMonster["_Boolean"] = _CtrlBoolean;
			this.SendNotify(UICmdStrLib.GetMonster, _GetMonster);
		}
		public function AddMonsterMenu(_CurrentMonster:MonsterDisplay = null, _CtrlBoolean:Boolean = true):void 
		{
			if (_AssemblyMonsterMenu == null) var _AssemblyMonsterMenu:AssemblyMonsterMenu = new AssemblyMonsterMenu();
			if (this._Panel.getChildByName("MonsterMenuA") != null) this._Panel.removeChild(this._Panel.getChildByName("MonsterMenuA"));
			if (this._Panel.getChildByName("MonsterMenuB") != null) this._Panel.removeChild(this._Panel.getChildByName("MonsterMenuB"));
			if (_CurrentMonster != null) _CurrentMonster.ShowContent();
			//_CurrentMonster.AddStamp = true;//惡魔蓋章
			//_CurrentMonster.Alive = true;//惡魔動畫
			var _MonsterMenu:Sprite = _AssemblyMonsterMenu.AddMonsterMenu(this._BGObj, (_CurrentMonster != null)?_CurrentMonster.MonsterBody:null , (_CurrentMonster != null)?_CurrentMonster.MonsterData:null , "Evolution");
				(_CtrlBoolean == true)?_MonsterMenu.x = 370:_MonsterMenu.x = 475;
				(_CtrlBoolean == true)?_MonsterMenu.y = 110:_MonsterMenu.y = 170;
				_MonsterMenu.name = "MonsterMenuA";
				_MonsterMenu.buttonMode = false;
			this._Panel.addChild(_MonsterMenu);
			
			if (_CtrlBoolean == false) {
				_MonsterMenu = _AssemblyMonsterMenu.AddMonsterMenu(this._BGObj);
				_MonsterMenu.x = 270;
				_MonsterMenu.y = 170;
				_MonsterMenu.buttonMode = true;
				_MonsterMenu.name = "MonsterMenuB";
				_MonsterMenu.addEventListener(MouseEvent.CLICK, GetMonsterMenu);
				this._Panel.addChild(_MonsterMenu);
				this._SharedEffect.MouseEffect(_MonsterMenu);
				this._TextObj._str = "點擊選擇惡魔";
				this._TextObj._col = 0xFFFFFF;
				var _MenuText:Text = new Text(this._TextObj);
					_MenuText.x = _MonsterMenu.width / 2 - _MenuText.width / 2 + 50;
					_MenuText.y = _MonsterMenu.height / 2 - _MenuText.height / 2 + 120;
				_MonsterMenu.addChild(_MenuText);
				this._SharedEffect.Brilliant(_MenuText, true );
			}
		}
		public function AddMonsterMenuB(_CurrentMonster:MonsterDisplay):void 
		{
			this._OtherMonster = _CurrentMonster.MonsterData._guid;
			if (_AssemblyMonsterMenu == null) var _AssemblyMonsterMenu:AssemblyMonsterMenu = new AssemblyMonsterMenu();
			if (this._Panel.getChildByName("MonsterMenuB") != null) this._Panel.removeChild(this._Panel.getChildByName("MonsterMenuB"));
			_CurrentMonster.ShowContent();
			//_CurrentMonster.AddStamp = true;//惡魔蓋章
			//_CurrentMonster.Alive = true;//惡魔動畫
			var _MonsterMenu:Sprite = _AssemblyMonsterMenu.AddMonsterMenu(this._BGObj, _CurrentMonster.MonsterBody, _CurrentMonster.MonsterData, "Evolution");
				_MonsterMenu.x = 270;
				_MonsterMenu.y = 170;
				_MonsterMenu.name = "MonsterMenuB";
				_MonsterMenu.buttonMode = false;
			this._Panel.addChild(_MonsterMenu);
			
			var _EvolutionData:Object = [];
				_EvolutionData["Guid"] = this._CurrentListBoard.name;
				_EvolutionData["EvoGuid"] = this._Recipe[this._CruuentRecipe]._recipeID;
				_EvolutionData["OtherGuid"] = this._OtherMonster;
			this.SendNotify(UICmdStrLib.CheckEvolution, _EvolutionData);
		}
		//拿取素材
		private function CurrentRecipe():void 
		{
			var _CurrentRecipe:Object = this._Recipe[this._CruuentRecipe];
			var _NeedSource:Object = [];
			var _NeedSourceList_A:Object = [];
			var _NeedSourceList_B:Object = [];
			if (_CurrentRecipe._needSource_A != null) {
				for (var i:String in _CurrentRecipe._needSource_A) {
					_NeedSourceList_A.push(_CurrentRecipe._needSource_A[i]);
				}
			}
			if (_CurrentRecipe._needSource_B != null) {
				for (var j:String in _CurrentRecipe._needSource_B) {
					_NeedSourceList_B.push(_CurrentRecipe._needSource_B[j]);
				}
			}
			_NeedSource["NeedSourceList_A"] = _NeedSourceList_A;
			_NeedSource["NeedSourceList_B"] = _NeedSourceList_B;
			this.SendNotify(UICmdStrLib.GetItem, _NeedSource);
		}
		//得到素材表
		public function AddRecipeSource(_ListA:Vector.<ItemDisplay>, _ListB:Vector.<ItemDisplay>):void 
		{
			var _CurrentItem:ItemDisplay;
			var _SourceIcon:Sprite;
			this.AddSource(_ListA, true);
			this.AddSource(_ListB, false);
		}
		//放置素材
		private function AddSource(_CurrentList:Vector.<ItemDisplay>, _CtrlBoolean:Boolean):void 
		{
			var _CurrentItem:ItemDisplay;
			var _SourceIcon:Sprite;
			var _SourceNum:String;
			for (var i:int = 0; i < _CurrentList.length; i++) 
			{
				_CurrentItem = _CurrentList[i];
				_CurrentItem.ShowContent();
				_SourceNum = _CurrentItem.ItemData._playerNum + " / " + _CurrentItem.ItemData._need;
				_SourceIcon = _CurrentItem.ItemIcon;
				_SourceIcon.width = 48;
				_SourceIcon.height = 48;
				this.AddMouseEffect(_SourceIcon);
				
				if (_CtrlBoolean == true) {
					_SourceIcon.name = "ListA" + i;
					(i < 3)?_SourceIcon.x = 270:_SourceIcon.x = 325;
					(i < 3)?_SourceIcon.y = 300 + i * 70:_SourceIcon.y = 340 + (i % 3) * 70;
					Text(this._Panel.getChildByName("A" + i)).ReSetString(_SourceNum);
					this._CurrentSourceList["A"].push(_CurrentItem);
				}else {
					_SourceIcon.name = "ListB" + i;
					(i < 3)?_SourceIcon.x = 620:_SourceIcon.x = 675;
					(i < 3)?_SourceIcon.y = 340 + i * 70:_SourceIcon.y = 300 + (i % 3) * 70;
					Text(this._Panel.getChildByName("B" + i)).ReSetString(_SourceNum);
					this._CurrentSourceList["B"].push(_CurrentItem);
				}
				this._Panel.addChild(_SourceIcon);
			}
		}
		
		private function AddMouseEffect(_Btn:Sprite):void 
		{
			_Btn.addEventListener(MouseEvent.ROLL_OVER, BtnHandler);
			_Btn.addEventListener(MouseEvent.ROLL_OUT, BtnHandler);
		}
		private function BtnHandler(e:MouseEvent):void 
		{
			var _Str:String = String(e.currentTarget.name).substr(4, 1);
			var _Num:String = String(e.currentTarget.name).substr(5, 1);
			var _CurrentTarget:Sprite = Sprite(e.currentTarget);
			var _CurrentItemDisplay:ItemDisplay;
			if (_Str == "A") _CurrentItemDisplay = this._CurrentSourceList["A"][int(_Num)];
			if (_Str == "B") _CurrentItemDisplay = this._CurrentSourceList["B"][int(_Num)];
			switch (e.type) 
			{
				case "rollOver":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Evolution", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MTL", ProxyPVEStrList.MonsterEvolution_SOURCE_TIPS, { _guid:this._Recipe[this._CruuentRecipe]._recipeID, _list:_Str, _groupGuid:_CurrentItemDisplay.ItemData._guid }, _CurrentTarget.x + this._Panel.x - 7 , _CurrentTarget.y + this._Panel.y + 27 ));
					//this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Evolution", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MTL", ProxyPVEStrList.ALCHEMY_TIPS, { _rGuid:_CurrentItemDisplay.ItemData._guid, _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type } , _CurrentTarget.x + this._Panel.x - 7 , _CurrentTarget.y + this._Panel.y + 28 ));
					break;
				case "rollOut":
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
					break;
			}
			
		}
		private function RemoveMouseEffect(_Btn:Sprite):void 
		{
			_Btn.removeEventListener(MouseEvent.ROLL_OVER, BtnHandler);
			_Btn.removeEventListener(MouseEvent.ROLL_OUT, BtnHandler);
		}
		
		private function playerClickProcess(e:MouseEvent):void 
		{
			var _CurrentName:String = e.target.name;
			switch (_CurrentName) 
			{
				case "CheckBtn":
					var _EvolutionData:Object = [];
						_EvolutionData["Guid"] = this._CurrentListBoard.name;
						_EvolutionData["EvoGuid"] = this._Recipe[this._CruuentRecipe]._recipeID;
						_EvolutionData["OtherGuid"] = this._OtherMonster;
					this.SendNotify(UICmdStrLib.GoEvolution, _EvolutionData);
				break;
				/*case "Turntable":
					this.SendNotify(UICmdStrLib.Init_Turntable);
				break;*/
			}
		}
		
		private function GetMonsterMenu(e:MouseEvent):void 
		{
			var _AddMonsterMenu:Object = new Object();
				_AddMonsterMenu["Rank"] = this._Recipe[this._CruuentRecipe]._needColorRank;
				for (var i:int = 0; i < this._EvolutionData.length; i++) 
				{
					if (this._EvolutionData[i].MonsterData._guid == this._CurrentListBoard.name) {
						_AddMonsterMenu["MonsterName"]  = this._EvolutionData[i].MonsterData._showName;
						_AddMonsterMenu["Guid"] = this._EvolutionData[i].MonsterData._guid;
					}
				}
				_AddMonsterMenu["BGObj"] = this._BGObj;
			this.SendNotify(UICmdStrLib.AddMonsterMenu, _AddMonsterMenu);
		}
		
		override public function onRemoved():void 
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClickProcess);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("EvolutionAlphaBox"));
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("EvolutionPanel"));
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
	}
}