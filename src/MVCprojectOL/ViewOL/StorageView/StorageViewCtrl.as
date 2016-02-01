package MVCprojectOL.ViewOL.StorageView 
{
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.GlowFilterPlugin;
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
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.StorageStrLib;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class StorageViewCtrl extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _StorageBGObj:Object;
		private var _onTabElement:Vector.<MovieClip>;
		private var _CurrentTabM:int;
		private var _PageList:Array = null;
		private var _CtrlPageNum:int = 0;
		private var _TipCtrlBoolean:Boolean = true;
		private var _CurrentTipName:Sprite;
		private var _ItemDisplayID:Vector.<ItemDisplay>;
		private var _CurrentItemID:ItemDisplay;
		private var _CurrentMonsterID:String;
		private var _ShowTip:Sprite;
		private var _ItemDisplayMenu:Vector.<Sprite>;
		private var _Num:int;
		private var _TipsView:TipsView = new TipsView("Storage");//---tip---
		private var _NewGuid:String = "";
		
		public function StorageViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			TweenPlugin.activate([GlowFilterPlugin]);
			super( _InputViewName , _InputConter );
		}
		
		public function AddElement(_GlobalObj:Object, _StorageObj:Object, _BuildingLV:int, _NewGuid:String):void
		{
			this._BGObj = _GlobalObj;
			this._StorageBGObj = _StorageObj;
			this._NewGuid = _NewGuid;
			
			this.AssemblyPanel(_BuildingLV);
		}
		
		private function AssemblyPanel(_BuildingLV:int):void
		{
			var _AlphaBox:Sprite; 
			_AlphaBox = this.DrawRect(0, 0, 1000, 700);
			_AlphaBox.name = "AlphaBoxBG";
			_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			var _Panel:Sprite = new Sprite();
				_Panel.x = 373;//265 + 215-107;
				_Panel.y = 153;//25 + 255-127;
				_Panel.scaleX = 0.5;
				_Panel.scaleY = 0.5;
				_Panel.name = "StoragePanel";
			this._viewConterBox.addChild(_Panel);
			
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
				_TextObj._str = "儲藏秘室";
			var _TitleText:Text = new Text(_TextObj);
				_TitleText.x = 200;
				_TitleText.y = 92;
				_TitleText.mouseEnabled = false;
			_Panel.addChild(_TitleText);
			
			var _EdgeBg:Sprite;
			for (var k:int = 0; k < 2; k++) 
			{
				_EdgeBg = new (this._BGObj.EdgeBg as Class);
				(k == 0)?_EdgeBg.scaleY = -1:_EdgeBg.scaleY = 1;
				(k == 0)?_EdgeBg.y =  90:_EdgeBg.y = _BgB.height + 40;
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
			
			var _PageSP:Sprite = this.DrawRect(0, 0, _PageText.width, _PageText.height);
				_PageSP.x = _PageText.x;
				_PageSP.y = _PageText.y;
				_PageSP.name = "PageSP";
				_PageSP.alpha = 0;
			_Panel.addChild(_PageSP);
			this._TipsView.MouseEffect(_PageSP);
			 
			var _BgM:Sprite = new (this._BGObj.BgM as Class);
				_BgM.width = 385;
				_BgM.height = 390;
				_BgM.x = 40;
				_BgM.y = 145;
			_Panel.addChild(_BgM);
			
			var _Lattice:int = 28 + 7 * _BuildingLV;
			var _Box:Bitmap;
			for (var i:int = 0; i < 49; i++) 
			{
				_Box = new Bitmap(BitmapData(new(this._BGObj.Box as Class)));
				_Box.x = 50 + ( i % 7 ) * (48 + 5);
				_Box.y = 157 + ( int( i / 7 ) * (48 + 5));
				if (i >= _Lattice) TweenLite.to(_Box, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
				_Panel.addChild(_Box);
			}
			this.Tab();
			
			this.ZoomIn(_Panel, 430, 510, 0.5);
		}
		private function ZoomIn(_InputSp:Sprite,_OriginalWidth:int,_OriginalHeight:int,_Proportion:Number):void
		{
			var _NewX:int = _InputSp.x - ((_OriginalWidth * _Proportion)) * _Proportion;
			var _NewY:int = _InputSp.y - ((_OriginalHeight * _Proportion)) * _Proportion;
			TweenLite.to(_InputSp, 1, { x:_NewX, y:_NewY, scaleX:1, scaleY:1 , ease:Elastic.easeOut } );
		}
		
		private function Tab():void
		{
			var _Magic:MovieClip = new (this._StorageBGObj.Magic as Class);
				_Magic.name = PlaySystemStrLab.Package_Stone;
			this._TipsView.MouseEffect(_Magic);
			var _Weapon:MovieClip = new (this._StorageBGObj.Weapon as Class);
				_Weapon.name = PlaySystemStrLab.Package_Weapon;
			this._TipsView.MouseEffect(_Weapon);
			var _Armor:MovieClip = new (this._StorageBGObj.Armor as Class);
				_Armor.name = PlaySystemStrLab.Package_Shield;
			this._TipsView.MouseEffect(_Armor);
			var _Accessories:MovieClip = new (this._StorageBGObj.Accessories as Class);
				_Accessories.name = PlaySystemStrLab.Package_Accessories;
			this._TipsView.MouseEffect(_Accessories);
			var _Material:MovieClip = new (this._StorageBGObj.Material as Class);
				_Material.name = PlaySystemStrLab.Package_Source;
			this._TipsView.MouseEffect(_Material);
			this._onTabElement = new <MovieClip>[_Magic, _Weapon, _Armor, _Accessories, _Material];
			
			
			this._CurrentTabM = 0;
			this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
			
			if (this._NewGuid == "") { 
				var _CurrentTab:Object = new Object();
					_CurrentTab["TabName"] = this._onTabElement[0].name;
				this.SendNotify( StorageStrLib.CurrentTab,_CurrentTab);
			}else {
				this.SendNotify( UICmdStrLib.NewData, this._NewGuid);
				//this._NewGuid = "";
			}
			
		}
		private function TabMFactory(_InputSP:MovieClip,InputNum:int):void
		{
			var _TabElement:MovieClip = _InputSP;
				_TabElement.x = 12;
				_TabElement.y = -15;
				_TabElement.scaleX = 0.8;
				_TabElement.scaleY = 0.8;
				_TabElement.gotoAndStop(3);
			var _TabM:MovieClip = new  (this._BGObj.Tab as Class);
				_TabM.x = 50 + InputNum * 62;//160 + InputNum * 97;
				_TabM.y = 120;
				_TabM.gotoAndStop(2);
				_TabM.buttonMode = true;
				_TabM.name = "" + InputNum;
				_TabM.addChild(_TabElement);
			Sprite(this._viewConterBox.getChildByName("StoragePanel")).addChild(_TabM);
			for (var i:int = 0; i < 5; i++)(i == this._CurrentTabM)?null:this.TabSFactory(this._onTabElement[i], i);
		}
		private function TabSFactory(_InputSP:MovieClip,InputNum:int):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			var _TabElement:MovieClip = _InputSP;
				_TabElement.x = 12;
				_TabElement.y = -10;
				_TabElement.name = this._onTabElement[InputNum].name;
				_TabElement.scaleX = 0.8;
				_TabElement.scaleY = 0.8;
				_TabElement.gotoAndStop(1);
			var _TabS:MovieClip = new  (this._BGObj.Tab as Class);
				_TabS.scaleX = 0.6;
				_TabS.scaleY = 0.6;
				(this._CurrentTabM < InputNum)?_TabS.x = _Panel.getChildByName("" + this._CurrentTabM).x + (InputNum - this._CurrentTabM) * 50:_TabS.x = _Panel.getChildByName("" + this._CurrentTabM).x - (this._CurrentTabM - InputNum) * 50;
				_TabS.y = 125;
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
				Sprite(this._viewConterBox.getChildByName("StoragePanel")).removeChild(_InputSP);
				this.TabMFactory(this._onTabElement[InputNum], InputNum);
			}else if (InputNum != this._CurrentTabM&&this._CurrentTabM > -1 ){
				TweenLite.to(_InputSP, 0.2, { x:50 + InputNum * 62, y:120, scaleX:1, scaleY:1,onComplete:btnFactoryHandler,onCompleteParams:[_InputSP] } );
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
					this.ChangeTab(int(e.currentTarget.name));
				break;
				
				case "rollOver":
					MovieClip(e.currentTarget.getChildByName(this._onTabElement[int(e.currentTarget.name)].name)).gotoAndStop(2);
				break;
				
				case "rollOut":
					MovieClip(e.currentTarget.getChildByName(this._onTabElement[int(e.currentTarget.name)].name)).gotoAndStop(1);
				break;
				
			}
		}
		private function removebtnFactory(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, btnStatus);
			btn.removeEventListener(MouseEvent.ROLL_OUT, btnStatus);
			btn.removeEventListener(MouseEvent.CLICK, btnStatus);
		}
		
		public function ChangeTab(_CurrentTabNum:int, _NewGuid:String = ""):void 
		{
			this._NewGuid = _NewGuid;
			this._CurrentTabM = _CurrentTabNum;
			this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			for (var i:int = 0; i < 5; i++) 
			{
				this.removebtnFactory(_Panel.getChildByName(""+i));
				_Panel.removeChild(_Panel.getChildByName(""+i));
			}
					
			this.RemoveTip();
			if (this._PageList != null) { 
				if (this._PageList.length!=0) {
					for (var j:int = 0; j < this._PageList[this._CtrlPageNum].length ; j++) {
					_Panel.getChildByName("" + j).removeEventListener(MouseEvent.CLICK, ItemClickHandler);
					_Panel.getChildByName("" + j).removeEventListener(MouseEvent.ROLL_OVER, ItemRollOver);
					_Panel.getChildByName("" + j).removeEventListener(MouseEvent.ROLL_OUT, ItemRollOut);
					Sprite(_Panel.getChildByName("" + j)).buttonMode = false;
					_Panel.removeChild(_Panel.getChildByName(""+j));
					}
				}
			}
			
			var _CurrentTab:Object = new Object();
				_CurrentTab["TabName"] = this._onTabElement[this._CurrentTabM].name;
			this.SendNotify( StorageStrLib.CurrentTab, _CurrentTab);
		}
		
		//背包物品
		public function BackpackElement(_InputItemDisplay:Vector.<ItemDisplay>, _InputName:String):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			for (var k:String in _ItemDisplayMenu) if (_Panel.getChildByName("EquText" + k) != null) _Panel.removeChild(_Panel.getChildByName("EquText" + k));
			//刪除非閒置物品    /*|| _InputItemDisplay[j].ItemData._useing == 1*/
			var _ItemDisplay:Vector.<ItemDisplay> = new Vector.<ItemDisplay>;
			for (var j:int = 0; j < _InputItemDisplay.length; j++) 
			{
				if (_InputName == PlaySystemStrLab.Package_Stone) {
					if (_InputItemDisplay[j].ItemData._type == 1 ) _ItemDisplay.push(_InputItemDisplay[j]);
				}else {
					_ItemDisplay.push(_InputItemDisplay[j]);
				}
			}
			
			this._CtrlPageNum = 0;
			var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
			this._PageList = _SplitPageMethod.SplitPage(_ItemDisplay, 49);
			
			var _Btn0:MovieClip = MovieClip(_Panel.getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(_Panel.getChildByName("btn1"));
			if (this._PageList.length != 0 && this._PageList.length != 1)  {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = true;
			}else {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = false;
			}
			
			if (this._NewGuid != "") { 
				var _len:int = _ItemDisplay.length;
				for (var i:int = 0; i < _len; i++) { 
					if (_ItemDisplay[i].ItemData._guid == this._NewGuid) {
						this._CtrlPageNum = int(i / 49);
						//this._Pages = int(i % 49);
						this.CtrlPage(this._CtrlPageNum, false);
					}
				}
			}else {
				this._PageList.length != 0?this.CtrlPage(this._CtrlPageNum):null;
			}
			
			this._PageList.length != 0?Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + 1 + " / " + this._PageList.length):Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + " / " + this._PageList.length);
		}
		private function CtrlPage( _InputPage:int, _InputBoolean:Boolean = false ):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			
			for (var k:String in _ItemDisplayMenu) if (this._viewConterBox.getChildByName("EquText" + k) != null) _Panel.removeChild(_Panel.getChildByName("EquText" + k));
			
			if (_InputBoolean) { 
				for (var j:String in _ItemDisplayMenu) {
					this._ItemDisplayMenu[j].removeEventListener(MouseEvent.CLICK, ItemClickHandler);
					this._ItemDisplayMenu[j].removeEventListener(MouseEvent.ROLL_OVER, ItemRollOver);
					this._ItemDisplayMenu[j].removeEventListener(MouseEvent.ROLL_OUT, ItemRollOut);
					_Panel.removeChild(this._ItemDisplayMenu[j]);
				}
			}
			Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + 1 + " / " + this._PageList.length);
			
			var _TextObj:Object = { _str:"E", _wid:20, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
			var _MyPage:Array = this._PageList[_InputPage];
			var _MyPageLength:uint = _MyPage.length;
			this._ItemDisplayMenu = new Vector.<Sprite>;
			this._ItemDisplayID = new Vector.<ItemDisplay>;
			var _CurrentItemDisplay:ItemDisplay;
			for (var i:int = 0; i < _MyPageLength ; i++) {
				_CurrentItemDisplay = _MyPage[i];
				//trace(_CurrentItemDisplay.ItemData._useing,"@@@@@@@@@@@");
				_CurrentItemDisplay.ShowContent();
				_CurrentItemDisplay.ItemIcon.x = 50 + ( i % 7 ) * (48 + 5);
				_CurrentItemDisplay.ItemIcon.y = 157 + ( int( i / 7 ) * (48 + 5));
				_CurrentItemDisplay.ItemIcon.width = 48;
				_CurrentItemDisplay.ItemIcon.height = 48;
				_CurrentItemDisplay.ItemIcon.buttonMode = true;
				this._ItemDisplayMenu.push(_CurrentItemDisplay.ItemIcon);
				this._ItemDisplayID.push(_CurrentItemDisplay);
				this._ItemDisplayMenu[i].name = "" + i;
				if (this._CurrentTabM != 4) this._ItemDisplayMenu[i].addEventListener(MouseEvent.CLICK, ItemClickHandler);
				//this._ItemDisplayMenu[i].addEventListener(MouseEvent.CLICK, ItemRollOver);
				this._ItemDisplayMenu[i].addEventListener(MouseEvent.ROLL_OVER, ItemRollOver);
				this._ItemDisplayMenu[i].addEventListener(MouseEvent.ROLL_OUT, ItemRollOut);
				_Panel.addChild(this._ItemDisplayMenu[i]);
				
				if (_CurrentItemDisplay.ItemData._useing == 3 || this._CurrentTabM == 4) { 
					(this._CurrentTabM != 4)?_TextObj._str = "E":_TextObj._str = "" + _CurrentItemDisplay.ItemData._number;
					var _EquText:Text = new Text(_TextObj);
						(this._CurrentTabM != 4)?_EquText.x = _CurrentItemDisplay.ItemIcon.x:_EquText.x = _CurrentItemDisplay.ItemIcon.x + 30;
						_EquText.y = _CurrentItemDisplay.ItemIcon.y + 27;
						_EquText.name = "EquText" + i;
					_Panel.addChild(_EquText);
				}
				
				if (_CurrentItemDisplay.ItemData._guid == this._NewGuid) {
					this._SharedEffect.TimesGlowFilterBrilliant(this._ItemDisplayMenu[i], false, 5);
				}
			}
		}
		//頁數控制按鈕
		private function _onClickHandler(e:MouseEvent):void
		{
			this.RemoveTip();
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
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
		//裝備按鈕
		private function ItemClickHandler(e:MouseEvent):void
		{
			TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
			this._ItemDisplayMenu[e.currentTarget.name].removeEventListener(MouseEvent.CLICK, ItemClickHandler);
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, ViewClickHandler);
			this.TipHandler(Sprite(e.currentTarget));
		}
		private function ItemRollOver(e:MouseEvent):void
		{
			this.RemoveTip();
			TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
			if (e.currentTarget.name is String) var _CurrentItemDisplay:ItemDisplay = ItemDisplay(this._ItemDisplayID[e.currentTarget.name]);
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			var _CurrentTarget:Sprite = Sprite(e.currentTarget);
			if (this._CurrentTabM == 0) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MCS", PlaySystemStrLab.Package_Stone, { _guid:_CurrentItemDisplay.ItemData._guid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
			if (this._CurrentTabM == 1) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_WPN", PlaySystemStrLab.Package_Weapon, { _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
			if (this._CurrentTabM == 2) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_AMR", PlaySystemStrLab.Package_Shield, { _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
			if (this._CurrentTabM == 3) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_ACY", PlaySystemStrLab.Package_Accessories, { _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
			if (this._CurrentTabM == 4) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MTL", PlaySystemStrLab.Package_Source, { _groupGuid:_CurrentItemDisplay.ItemData._guid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
		}
		private function ItemRollOut(e:MouseEvent):void
		{
			TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
			TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
		}
		private function TipHandler(_InputItem:Sprite=null):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			if (this._TipCtrlBoolean == true) {
				this._CurrentTipName = _InputItem;
				this._CurrentTipName.name = _InputItem.name;
				this._CurrentItemID = this._ItemDisplayID[this._CurrentTipName.name];
				var _TipBox:MovieClip = new (this._BGObj.TipBox as Class);
					_TipBox.x = _InputItem.x + 24;
					_TipBox.y = _InputItem.y + 24;
					_TipBox.scaleX = 0.1;
					_TipBox.scaleY = 0.1;
					_TipBox.name = "TipBox";
					_Panel.addChild(_TipBox);
				TweenLite.to(_TipBox, 0.2, { y:_InputItem.y + 24, scaleX:1.3, scaleY:0.5, onComplete:TipBoxHandler, onCompleteParams:[_TipBox, _InputItem] } );
			}else {
				//trace(this._CurrentTipName.name,_InputItem.name,"=====");
				this._CurrentTipName.name != _InputItem.name?this.RemoveTip(_InputItem):this.RemoveTip();
			}
		}
		private function RemoveTip(_InputItem:Sprite=null):void 
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			if (this._TipCtrlBoolean == false) {
				_Panel.removeChild(_Panel.getChildByName("TipBox"));
				for (var i:int = 0; i < this._Num; i++) 
				{
					_Panel.removeChild(_Panel.getChildByName("TipBtn" + i));
				}
				this._CurrentTipName.addEventListener(MouseEvent.CLICK, ItemClickHandler);
				//this._viewConterBox.removeEventListener(MouseEvent.CLICK, ViewClickHandler);
				this._TipCtrlBoolean = true;
				if (_InputItem != null) this.TipHandler(_InputItem);
			}
		}
		private function TipBoxHandler(_InputTipBox:Sprite,_InputItem:Sprite):void 
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			var _TipBtn:MovieClip;
			var _TextObj:Object = { _str:"", _wid:40, _hei:10, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
			var _TipBtnText:Text;
			
			var _scaleNum:Number;
			(this._CurrentTabM == 1 || this._CurrentTabM == 2 || this._CurrentTabM == 3)?this._Num = 2:(this._CurrentTabM == 4)?this._Num = 0:this._Num = 1;
			(this._Num == 3)?_scaleNum = 2:(this._Num == 1)?_scaleNum = 0.8:_scaleNum = 1.4;
			TweenLite.to(_InputTipBox, 0.5, {  y:_InputItem.y + 24, scaleY:_scaleNum , onComplete:AddClickHandler, onCompleteParams:[_InputItem] } );
			
			for (var i:int = 0; i < this._Num; i++) 
			{
				_TipBtn = new (this._BGObj.TipBtn as Class);
				_TipBtn.x = _InputTipBox.x + 9;
				_TipBtn.y = _InputTipBox.y + 8;
				_TipBtn.name = "TipBtn" + i;
				_TipBtn.buttonMode = true;
				this.MouseEffect(_TipBtn);
				
				if (i == 0)(this._CurrentTabM == 1||this._CurrentTabM == 2||this._CurrentTabM == 3)?(this._ItemDisplayID[_InputItem.name].ItemData._useing != 3)?_TextObj._str = "裝備":_TextObj._str = "卸下":(this._CurrentTabM == 4)?_TextObj._str ="丟棄":_TextObj._str ="使用";
				if (i == 1)(this._CurrentTabM == 1||this._CurrentTabM == 2||this._CurrentTabM == 3)?_TextObj._str = "恢復":(this._CurrentTabM == 4)?_TextObj._str ="":_TextObj._str ="丟棄";
				if (i == 2)(this._CurrentTabM == 1 || this._CurrentTabM == 2 || this._CurrentTabM == 3)?_TextObj._str = "丟棄":_TextObj._str = "";
				_TipBtnText = new Text(_TextObj);
				_TipBtnText.x = 15;
				_TipBtnText.y = 5;
				_TipBtn.addChild(_TipBtnText);
				
				_Panel.addChild(_TipBtn);
				TweenLite.to(_TipBtn, 0.5, {  y:_TipBtn.y + (40 * i) } );
			}
			this._TipCtrlBoolean = false;
		}
		private function AddClickHandler(_InputItem:Sprite):void
		{
			_InputItem.addEventListener(MouseEvent.CLICK, ItemClickHandler);
			(this._ItemDisplayID[_InputItem.name].ItemData._useing != 3)?this._viewConterBox.addEventListener(MouseEvent.CLICK, ViewClickHandler):this._viewConterBox.addEventListener(MouseEvent.CLICK, ReViewClickHandler);
		}
		
		private function ViewClickHandler(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "TipBtn0":
					(this._CurrentTabM != 4)?this.SendNotify( StorageStrLib.GetMonsterMenu):null;
					this.RemoveTip();
				break;
				case "TipBtn1":
					(this._CurrentTabM == 0)?this.RemoveTip():null;//魔晶石丟棄:
				break;
				case "TipBtn2":
					this.RemoveTip();
				break;
				
				case "Make0":
					for (var k:String in _ItemDisplayMenu) if (this._viewConterBox.getChildByName("EquText" + k) != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("EquText" + k));
					var _SureUse:Object = new Object();
						_SureUse["MonsterName"] =	this._CurrentMonsterID;
						_SureUse["IconName"] = this._CurrentItemID.ItemData._guid;
						_SureUse["CurrentTabM"] = this._CurrentTabM;
						if (this._CurrentTabM == 1 || this._CurrentTabM == 2 || this._CurrentTabM == 3)_SureUse["equGroupID"] = this._CurrentItemID.ItemData._gruopGuid;
					this.SendNotify( StorageStrLib.SureUse, _SureUse);
					this._viewConterBox.removeChild(this._viewConterBox.getChildByName("InformBox"));
					this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Inform"));
					this._viewConterBox.removeEventListener(MouseEvent.CLICK, ViewClickHandler);	
				break;
				case "Make1":
					TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:385, y:195, scaleX:0.5, scaleY:0.5 ,onComplete:RemoveInform } );
				break;
			}
		}
		private function ReViewClickHandler(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "TipBtn0":
					//for (var j:String in _ItemDisplayMenu) if (this._ItemDisplayMenu[j].getChildByName("EquText") != null) this._ItemDisplayMenu[j].removeChild(this._ItemDisplayMenu[j].getChildByName("EquText"));
					var _Unload:Object = new Object();
						_Unload["monsterID"] = this._CurrentItemID.ItemData._monsterID;
						_Unload["IconName"] = this._CurrentItemID.ItemData._guid;
						_Unload["CurrentTabM"] = this._CurrentTabM;
					this.SendNotify( StorageStrLib.Unload, _Unload);
					this.RemoveTip();
					this._viewConterBox.removeEventListener(MouseEvent.CLICK, ReViewClickHandler);
				break;
			}
		}
		
		private function Discard():void
		{
			var _Discard:Object = new Object();
				_Discard["IconName"] = this._CurrentItemID.ItemData._guid;
				_Discard["equGroupID"] = this._CurrentItemID.ItemData._gruopGuid;
			//this.SendNotify( StorageStrLib.Discard, _Discard);
		}
		
		public function ReBackpack(_CurrentTabM:int):void
		{
			if (this._viewConterBox.getChildByName("AlphaBox") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("AlphaBox"));
			if (this._viewConterBox.getChildByName("Panel") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Panel"));
			for (var k:String in _ItemDisplayMenu) if (this._viewConterBox.getChildByName("EquText" + k) != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("EquText" + k));
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			//for (var i:int = 0; i < this._ItemDisplayMenu.length; i++) _Panel.removeChild(this._ItemDisplayMenu[i]);
			//this._ItemDisplayMenu = null;
			
			var _CurrentTab:Object = new Object();
				_CurrentTab["TabName"] = this._onTabElement[_CurrentTabM].name;
			this.SendNotify( StorageStrLib.CurrentTab,_CurrentTab);
		}
		
		//儲藏室第三層 惡魔列表
		public function GetMonsterMenu(_InputMonster:Vector.<MonsterDisplay>):void
		{
			var _AddMonsterMenu:Object = new Object();
				_AddMonsterMenu["Monster"] = _InputMonster;
				_AddMonsterMenu["BGObj"] = this._BGObj;
				_AddMonsterMenu["IconName"] = this._CurrentItemID.ItemData._guid;
				_AddMonsterMenu["lvEquipment"] = this._CurrentItemID.ItemData._lvEquipment;
				_AddMonsterMenu["CurrentTabM"] = this._CurrentTabM;
			this.SendNotify( UICmdStrLib.AddMonsterMenu, _AddMonsterMenu);
			
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			for (var j:String in _ItemDisplayMenu)
			{
				this._ItemDisplayMenu[j].removeEventListener(MouseEvent.CLICK, ItemClickHandler);
				this._ItemDisplayMenu[j].removeEventListener(MouseEvent.ROLL_OVER, ItemRollOver);
				this._ItemDisplayMenu[j].removeEventListener(MouseEvent.ROLL_OUT, ItemRollOut);
				this._ItemDisplayMenu[j].buttonMode=false;
				_Panel.removeChild(this._ItemDisplayMenu[j]);
			}
			//for (var k:String in _ItemDisplayMenu) if (this._viewConterBox.getChildByName("EquText" + k) != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("EquText" + k));
		}
		
		public function AddTip(_InputSpr:Sprite):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			var _TextBg:Sprite = Sprite(_Panel.getChildByName("TextBg"));
			if (this._ShowTip == null) {
				this._ShowTip = _InputSpr;
				this._ShowTip.name = "ShowTip";
				this._viewConterBox.addChild(this._ShowTip );
			}
			this._viewConterBox.setChildIndex(this._ShowTip, this._viewConterBox.numChildren - 1);
			this._ShowTip.x = 530;
			this._ShowTip.y = 450;
		}
		
		// 惡魔列表點擊效果
		public function UseHandler( _InputMonsterDisplay:MonsterDisplay, _InputItemDisplay:ItemDisplay):void
		{
			this._CurrentMonsterID = _InputMonsterDisplay.MonsterID;
			for (var k:String in _ItemDisplayMenu) if (this._viewConterBox.getChildByName("EquText" + k) != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("EquText" + k));
					var _SureUse:Object = new Object();
						_SureUse["MonsterName"] =	this._CurrentMonsterID;
						_SureUse["IconName"] = this._CurrentItemID.ItemData._guid;
						_SureUse["CurrentTabM"] = this._CurrentTabM;
						if (this._CurrentTabM == 1 || this._CurrentTabM == 2 || this._CurrentTabM == 3) _SureUse["equGroupID"] = this._CurrentItemID.ItemData._gruopGuid;
					this.SendNotify( StorageStrLib.SureUse, _SureUse);
					//this._viewConterBox.removeChild(this._viewConterBox.getChildByName("InformBox"));
					//this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Inform"));
					//this._viewConterBox.removeEventListener(MouseEvent.CLICK, ViewClickHandler);	
			
			/*var _AlphaBox:Sprite; 
				_AlphaBox = this.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "InformBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:20, _bold:true, _font:"Times New Roman", _leading:null };
			
			var _Inform:Sprite = new (this._BGObj.Inform as Class);
				_Inform.x = 385;
				_Inform.y = 195;
				_Inform.scaleX = 0.5;
				_Inform.scaleY = 0.5;
				_Inform.name = "Inform";
			this._viewConterBox.addChild(_Inform); 
				this._CurrentMonsterID = _InputMonsterDisplay.MonsterID;
			var _Head:Sprite = _InputMonsterDisplay.MonsterHead;
				_Head.x = 150;
				_Head.y = 130;
				_Inform.addChild(_Head);
			var _ItemIcon:Sprite = _InputItemDisplay.ItemIcon;
				_ItemIcon.x = 230;
				_ItemIcon.y = 130;
				_Inform.addChild(_ItemIcon);
			_InputItemDisplay.ShowContent();
			
			for (var k:int = 0; k < 2; k++) {
					var _MakeBtn:Sprite = new (this._BGObj.MakeBtn as Class);
						_MakeBtn.x = 95+k * 150;
						_MakeBtn.y = 270;
						_MakeBtn.name = "Make" + k;
						_MakeBtn.buttonMode = true;
						this.MouseEffect(_MakeBtn);
					var _MakeText:Text;
					if (_MakeBtn.name == "Make0" ) {
						_TextObj._col = 0x33FF33;//0x33FF33
						_TextObj._str = "YES";
						_MakeText = new Text(_TextObj);
						_MakeText.x = 30;
						_MakeBtn.addChild(_MakeText);
					}else {
						_TextObj._col = 0xFF0000;
						_TextObj._str = "NO";
						_MakeText = new Text(_TextObj);
						_MakeText.x = 35;
						_MakeBtn.addChild(_MakeText);
					}
				_Inform.addChild(_MakeBtn);
			}
			this.ZoomIn(_Inform, 452, 351, 0.5);*/
		}
		
		//滑鼠效果
		private function MouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.addEventListener(MouseEvent.CLICK, BtnEffect);
		}
		private function BtnEffect(e:MouseEvent):void 
		{
			//var _Inform:Sprite = Sprite(this._viewConterBox.getChildByName("Inform"));
			switch (e.type) 
			{
				case "rollOver":
					if (e.target.name != "Make0" && e.target.name != "Make1") MovieClip(e.target).gotoAndStop(2);
					if (e.target.name == "Make0" || e.target.name == "Make1")TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				break;
				case "rollOut":
					if (e.target.name != "Make0" && e.target.name != "Make1")MovieClip(e.target).gotoAndStop(1);
					if (e.target.name == "Make0" || e.target.name == "Make1")TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				break;
				case "click":
					if (e.target.name == "CloseBtn" ) TweenLite.to(this._viewConterBox.getChildByName("StoragePanel"), 0.3, { x:373, y:153, scaleX:0.5, scaleY:0.5 , onComplete:RemovePanel } );
				break;
			}
		}
		private function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.removeEventListener(MouseEvent.CLICK, BtnEffect);
		}
		
		private function RemovePanel():void
		{
			this.SendNotify( StorageStrLib.RemoveALL);
		}
		
		private function RemoveInform():void
		{
			this.SendNotify( UICmdStrLib.RecoverBtn);
			//if (this._viewConterBox.getChildByName("InformBox") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("InformBox"));
			//if (this._viewConterBox.getChildByName("Inform") != null)this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Inform"));
		}
		
		private function DrawRect(_LocationX:int, _LocationY:int, _Width:int, _Height:int):Sprite 
		{
			var _sp:Sprite = new Sprite ();
				_sp.graphics.beginFill(0x000000);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}
		
		override public function onRemoved():void 
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, ViewClickHandler);	
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, ReViewClickHandler);
			//while (this._viewConterBox.numChildren > 0) this._viewConterBox.removeChildAt(0);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("AlphaBoxBG"));
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("StoragePanel"));
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_CREAT);
			//---2013/06/12-ericHuang-
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
	}
}