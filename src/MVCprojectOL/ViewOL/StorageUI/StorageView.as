package MVCprojectOL.ViewOL.StorageUI 
{
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.easing.*;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
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
	public class StorageView extends ViewCtrl
	{
		private var _DisplayBox:DisplayObjectContainer;
		private var _BGObj:Object;
		private var _StorageBGObj:Object;
		private var _onTabElement:Vector.<MovieClip>;
		private var _CurrentTabM:int;
		private var _PageList:Array = null;
		private var _CtrlPageNum:int = 0;
		private var _TxtFormat:TextFormat = new TextFormat();
		private var _TipCtrlBoolean:Boolean = true;
		private var _CurrentTipName:Sprite;
		private var _ItemDisplayID:Vector.<ItemDisplay>;
		private var _CurrentItemID:ItemDisplay;
		private var _CurrentMonsterID:String;
		private var _ShowTip:Sprite;
		private var _ItemDisplayMenu:Vector.<Sprite>;
		private var _Num:int;
		private var _aryQuaPic:Array ;
		
		public function StorageView(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			TweenPlugin.activate([GlowFilterPlugin]);
			
			this._DisplayBox = _InputConter;
			super( _InputViewName , _InputConter );
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE); 
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		
		public function BackGroundElement(_InputStorageObj:Object,_InputObj:Object):void
		{
			trace("儲藏室第一層");
			var _StorageLayer:Object = new Object();
				_StorageLayer["Layer"] = 1;
			this.SendNotify( StorageStrLib.StorageLayer,_StorageLayer);
			
			this._BGObj = _InputObj;
			
			this._StorageBGObj = _InputStorageObj;
			var _BackGround:Sprite = new (this._StorageBGObj.bg3 as Class);
				_BackGround.name = "BackGround";
				this._viewConterBox.addChild( _BackGround );
			var _BoxOne:Sprite = new (this._StorageBGObj.Box1 as Class);
				_BoxOne.x = 657;
				_BoxOne.y = -150;
				_BoxOne.name = "BoxOne";
				this._viewConterBox.addChild(_BoxOne);
				TweenLite.to(_BoxOne, 0.5, { y:160 } );
			var _BoxTwo:Sprite = new (this._StorageBGObj.Box2 as Class);
				_BoxTwo.x = 0;
				_BoxTwo.y = -150;
				_BoxTwo.name = "BoxTwo";
				this._viewConterBox.addChild(_BoxTwo);
				TweenLite.to(_BoxTwo, 0.8, { y:110 } );
			var _NPC:Sprite = new  (this._StorageBGObj.NPC as Class);
				_NPC.x = 330;
				_NPC.y = 1500;
				_NPC.name = "NPC";
				_NPC.buttonMode = true;
				this.AddbtnFactory(_NPC);
				this._viewConterBox.addChild(_NPC);
				TweenLite.to(_NPC, 0.5, { y:225 , onComplete:DialogBoxHandler } );
			this._aryQuaPic = _InputObj._quaPIC;	
		   	
		}
		private function DialogBoxHandler():void
		{
			var _DialogBox:Sprite = new(this._StorageBGObj.DialogBox as Class);
				_DialogBox.x = 670;
				_DialogBox.y = 240;
				_DialogBox.name = "DialogBox";
				this._viewConterBox.addChild(_DialogBox);
		}
		
		private function AddbtnFactory(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, btnChange);
			btn.addEventListener(MouseEvent.ROLL_OUT, btnChange);
			btn.addEventListener(MouseEvent.CLICK, btnChange);
		}
		private function btnChange(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "click":
					this._viewConterBox.removeChild(this._viewConterBox.getChildByName("BoxOne"));
					this._viewConterBox.removeChild(this._viewConterBox.getChildByName("BoxTwo"));
					this.RemovebtnFactory(Sprite(this._viewConterBox.getChildByName("NPC")));
					this._viewConterBox.removeChild(this._viewConterBox.getChildByName("NPC"));
					this._viewConterBox.removeChild(this._viewConterBox.getChildByName("DialogBox"));
					
				break;
				case "rollOver":
					TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				break;
				case "rollOut":
					TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				break;
			}
		}
		
		private function RemovebtnFactory(btn:Sprite):void 
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, btnChange);
			btn.removeEventListener(MouseEvent.ROLL_OUT, btnChange);
			btn.removeEventListener(MouseEvent.CLICK, btnChange);
			this.EnterBackpack();//進入儲藏室第二層
		}
		
		public function SecondLayer():void
		{
			trace("儲藏室第二層");
			var _StorageLayer:Object = new Object();
				_StorageLayer["Layer"] = 2;
			this.SendNotify( StorageStrLib.StorageLayer,_StorageLayer);
			this._viewConterBox.setChildIndex(this._viewConterBox.getChildByName("BackGround"), 0 );
		}
		
		public function ReBackpack(_CurrentTabM:int):void
		{
			trace("儲藏室第二層");
			var _StorageLayer:Object = new Object();
				_StorageLayer["Layer"] = 2;
			this.SendNotify( StorageStrLib.StorageLayer, _StorageLayer);
			this._viewConterBox.setChildIndex(this._viewConterBox.getChildByName("BackGround"), 0 );
			
			for (var i:int = 0; i < this._ItemDisplayMenu.length; i++) 
			{
				this._viewConterBox.removeChild(this._ItemDisplayMenu[i]);
			}
			
			var _CurrentTab:Object = new Object();
				_CurrentTab["TabName"] = this._onTabElement[_CurrentTabM].name;
			this.SendNotify( StorageStrLib.CurrentTab,_CurrentTab);
		}
		
		private function EnterBackpack():void
		{
			trace("儲藏室第二層");
			var _StorageLayer:Object = new Object();
				_StorageLayer["Layer"] = 2;
			this.SendNotify( StorageStrLib.StorageLayer,_StorageLayer);
			
			var _Bins:Sprite = new  (this._StorageBGObj.Bins as Class);
				_Bins.x = 55;
				_Bins.y = 95;
				_Bins.name = "Bins";
			this._viewConterBox.addChild(_Bins);
				
			var _PageText:TextField = new TextField();
				this._TxtFormat.color = 0xF5C401;
				this._TxtFormat.size = 20;
				this._TxtFormat.bold = true;
				_PageText.defaultTextFormat = this._TxtFormat;
				_PageText.x = 490;
				_PageText.y = 553;
				_PageText.width = 100;
				_PageText.height = 40;
				_PageText.name = "PageText";
				_PageText.mouseEnabled = false;
			this._viewConterBox.addChild(_PageText);
			
			for (var i:int = 0; i < 2; i++) {
				var _pageBtnS:MovieClip = new (this._BGObj .pageBtnS as Class);
					_pageBtnS.x = 370 + 160 * i;
					_pageBtnS.y = 455;
					_pageBtnS.name = "btn" + i;
					_pageBtnS.buttonMode = true;
					
					_pageBtnS.addEventListener(MouseEvent.CLICK, _onClickHandler , false , 0 , true );
					_pageBtnS.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler , false , 0 , true );
					_pageBtnS.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler , false , 0 , true );
					if (_pageBtnS.name =="btn0") {
						_pageBtnS.scaleX = -1;
						_pageBtnS.gotoAndStop(3);
					}
					Sprite(this._viewConterBox.getChildByName("Bins")).addChild(_pageBtnS);
			}
			
			
			var _Magic:MovieClip = new (this._StorageBGObj.Magic as Class);
				_Magic.name = PlaySystemStrLab.Package_Stone;
			var _Weapon:MovieClip = new (this._StorageBGObj.Weapon as Class);
				_Weapon.name = PlaySystemStrLab.Package_Weapon;
			var _Armor:MovieClip = new (this._StorageBGObj.Armor as Class);
				_Armor.name = PlaySystemStrLab.Package_Shield;
			var _Accessories:MovieClip = new (this._StorageBGObj.Accessories as Class);
				_Accessories.name = PlaySystemStrLab.Package_Accessories;
			var _Drug:MovieClip = new (this._StorageBGObj.Drug as Class);
				_Drug.name = "Drug";
			var _Material:MovieClip = new (this._StorageBGObj.Material as Class);
				_Material.name = PlaySystemStrLab.Package_Source;
			this._onTabElement = new <MovieClip>[_Magic, _Weapon, _Armor, _Accessories, _Drug, _Material];
			
			this._CurrentTabM = 0;
			this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
			
			var _CurrentTab:Object = new Object();
				_CurrentTab["TabName"] = this._onTabElement[0].name;
			this.SendNotify( StorageStrLib.CurrentTab,_CurrentTab);
		}
		
		public function BackpackElement(_InputItemDisplay:Vector.<ItemDisplay>, _InputName:String):void
		{
			//trace(_InputItemDisplay.length,"@@@@");
			for (var k:String in _ItemDisplayMenu) if (this._viewConterBox.getChildByName("EquText" + k) != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("EquText" + k));
			
			//刪除非閒置物品    /*|| _InputItemDisplay[j].ItemData._useing == 1*/
			var _ItemDisplay:Vector.<ItemDisplay> = new Vector.<ItemDisplay>;
			
			
			for (var j:int = 0; j < _InputItemDisplay.length; j++) 
			{
				if (_InputName == PlaySystemStrLab.Package_Stone) {
					if (_InputItemDisplay[j].ItemData._type == 1 ) _ItemDisplay.push(_InputItemDisplay[j]);
					
				}else {
					_InputItemDisplay[j].quaBitmapData=this._aryQuaPic[(_InputItemDisplay[j].ItemData._quality)-1]
					_ItemDisplay.push(_InputItemDisplay[j]);
					
					
					//trace(_InputItemDisplay[j].ItemData._useing,"@@@@@");
				}
			}
			
			
			
			
			this._CtrlPageNum = 0;
			var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
			this._PageList = _SplitPageMethod.SplitPage(_ItemDisplay, 50);
			
			var _Btn0:MovieClip = MovieClip(Sprite(this._viewConterBox.getChildByName("Bins")).getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(Sprite(this._viewConterBox.getChildByName("Bins")).getChildByName("btn1"));
			if (this._PageList.length != 0 && this._PageList.length != 1)  {
				_Btn0.buttonMode = false;
				_Btn0.gotoAndStop(3);
				_Btn1.buttonMode = true;
				_Btn1.gotoAndStop(1);
			}else {
				_Btn0.buttonMode = false;
				_Btn0.gotoAndStop(3);
				_Btn1.buttonMode = false;
				_Btn1.gotoAndStop(3);
			}
			
			this._PageList.length!=0?TextField(this._viewConterBox.getChildByName("PageText")).text = this._CtrlPageNum+1 + "/" + this._PageList.length:TextField(this._viewConterBox.getChildByName("PageText")).text = this._CtrlPageNum + "/" + this._PageList.length;
			this._PageList.length!=0?this.CtrlPage(this._CtrlPageNum):null;
			
		}
		private function CtrlPage( _InputPage:int, _InputBoolean:Boolean = false ):void
		{
			for (var k:String in _ItemDisplayMenu) if (this._viewConterBox.getChildByName("EquText" + k) != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("EquText" + k));
			
			if (_InputBoolean) { 
				for (var j:String in _ItemDisplayMenu) {
					this._ItemDisplayMenu[j].removeEventListener(MouseEvent.CLICK, ItemClickHandler);
					this._ItemDisplayMenu[j].removeEventListener(MouseEvent.ROLL_OVER, ItemRollOver);
					this._ItemDisplayMenu[j].removeEventListener(MouseEvent.ROLL_OUT, ItemRollOut);
					this._viewConterBox.removeChild(this._ItemDisplayMenu[j]);
				}
			}
			TextField(this._viewConterBox.getChildByName("PageText")).text = this._CtrlPageNum + 1 + "/" + this._PageList.length;
			
			var _TextObj:Object = { _str:"E", _wid:20, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
			
			var _MyPage:Array = this._PageList[_InputPage];
			var _MyPageLength:uint = _MyPage.length;
			this._ItemDisplayMenu = new Vector.<Sprite>;
			this._ItemDisplayID = new Vector.<ItemDisplay>;
			
			var _CurrentItemDisplay:ItemDisplay;
			for (var i:int = 0; i < _MyPageLength ; i++) {
				_CurrentItemDisplay = _MyPage[i];
				//trace(_CurrentItemDisplay.ItemData._useing,"@@@@@@@@@@@");
				_CurrentItemDisplay.ShowContent();
				_CurrentItemDisplay.ItemIcon.x = 162 + ( i % 10 ) * ( _CurrentItemDisplay.IconSize + 5 );
				_CurrentItemDisplay.ItemIcon.y = 195 + ( int( i / 10 ) * ( _CurrentItemDisplay.IconSize + 5 ) );
				_CurrentItemDisplay.ItemIcon.buttonMode = true;
				this._ItemDisplayMenu.push(_CurrentItemDisplay.ItemIcon);
				this._ItemDisplayID.push(_CurrentItemDisplay);
				this._ItemDisplayMenu[i].name = "" + i;
				this._ItemDisplayMenu[i].addEventListener(MouseEvent.CLICK, ItemClickHandler);
				this._ItemDisplayMenu[i].addEventListener(MouseEvent.ROLL_OVER, ItemRollOver);
				this._ItemDisplayMenu[i].addEventListener(MouseEvent.ROLL_OUT, ItemRollOut);
				this._viewConterBox.addChild(this._ItemDisplayMenu[i]);
				
				if (_CurrentItemDisplay.ItemData._useing == 3) {
					var _EquText:Text = new Text(_TextObj);
						_EquText.x = _CurrentItemDisplay.ItemIcon.x;
						_EquText.y = _CurrentItemDisplay.ItemIcon.y + 40;
						_EquText.name = "EquText" + i;
					this._viewConterBox.addChild(_EquText);
				}
				
			}
		}
		//裝備按鈕
		private function ItemClickHandler(e:MouseEvent):void
		{
			TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
			//var _CurrentItemDisplay:ItemDisplay = ItemDisplay(this._ItemDisplayID[e.currentTarget.name]);
			//if (this._CurrentTabM == 1) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_WPN", PlaySystemStrLab.Package_Weapon, { _guid:_CurrentItemDisplay.ItemID, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, Sprite(e.currentTarget).x - 7, Sprite(e.currentTarget).y + 45));
			
			
			
			this._ItemDisplayMenu[e.currentTarget.name].removeEventListener(MouseEvent.CLICK, ItemClickHandler);
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, ViewClickHandler);
			this.TipHandler(Sprite(e.currentTarget));
		}
		private function TipHandler(_InputItem:Sprite=null):void
		{
			if (this._TipCtrlBoolean == true) {
				this._CurrentTipName = _InputItem;
				this._CurrentTipName.name = _InputItem.name;
				this._CurrentItemID = this._ItemDisplayID[this._CurrentTipName.name];
				var _TipBox:MovieClip = new (this._BGObj.TipBox as Class);
					_TipBox.x = _InputItem.x + 32;
					_TipBox.y = _InputItem.y + 32;
					_TipBox.scaleX = 0.1;
					_TipBox.scaleY = 0.1;
					_TipBox.name = "TipBox";
					this._viewConterBox.addChild(_TipBox);
				TweenLite.to(_TipBox, 0.2, { y:(int(_InputItem.name) < 40)?_InputItem.y + 32:_InputItem.y - 16,scaleX:1.3, scaleY:0.5, onComplete:TipBoxHandler, onCompleteParams:[_TipBox,_InputItem] } );
			}else {
				//trace(this._CurrentTipName.name,_InputItem.name,"=====");
				this._CurrentTipName.name != _InputItem.name?this.RemoveTip(_InputItem):this.RemoveTip();
			}
		}
		private function RemoveTip(_InputItem:Sprite=null):void 
		{
			if (this._TipCtrlBoolean == false) {
				this._viewConterBox.removeChild(this._viewConterBox.getChildByName("TipBox"));
				for (var i:int = 0; i < this._Num; i++) 
				{
					this._viewConterBox.removeChild(this._viewConterBox.getChildByName("TipBtn" + i));
				}
				this._CurrentTipName.addEventListener(MouseEvent.CLICK, ItemClickHandler);
				//this._viewConterBox.removeEventListener(MouseEvent.CLICK, ViewClickHandler);
				this._TipCtrlBoolean = true;
				if (_InputItem != null) this.TipHandler(_InputItem);
			}
		}
		private function TipBoxHandler(_InputTipBox:Sprite,_InputItem:Sprite):void 
		{
			var _TipBtn:MovieClip;
			var _TextObj:Object = { _str:"", _wid:40, _hei:10, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
			var _TipBtnText:Text;
			
			var _scaleNum:Number;
			(this._CurrentTabM == 1 || this._CurrentTabM == 2 || this._CurrentTabM == 3)?this._Num = 3:(this._CurrentTabM == 5)?this._Num = 1:this._Num = 2;
			(this._Num == 3)?_scaleNum = 2:(this._Num == 1)?_scaleNum = 0.8:_scaleNum = 1.4;
			TweenLite.to(_InputTipBox, 0.5, {  y:(int(_InputItem.name) < 40)?_InputItem.y + 32:_InputItem.y - 88, scaleY:_scaleNum , onComplete:AddClickHandler, onCompleteParams:[_InputItem] } );
			
			for (var i:int = 0; i < this._Num; i++) 
			{
				_TipBtn = new (this._BGObj.TipBtn as Class);
				_TipBtn.x = _InputTipBox.x + 9;
				(int(_InputItem.name) < 40)?_TipBtn.y = _InputTipBox.y + 8:_TipBtn.y = _InputTipBox.y + 16;
				_TipBtn.name = "TipBtn" + i;
				_TipBtn.buttonMode = true;
				this.MouseEffect(_TipBtn);
				
				if (i == 0)(this._CurrentTabM == 1||this._CurrentTabM == 2||this._CurrentTabM == 3)?(this._ItemDisplayID[_InputItem.name].ItemData._useing != 3)?_TextObj._str = "裝備":_TextObj._str = "卸下":(this._CurrentTabM == 5)?_TextObj._str ="丟棄":_TextObj._str ="使用";
				if (i == 1)(this._CurrentTabM == 1||this._CurrentTabM == 2||this._CurrentTabM == 3)?_TextObj._str = "恢復":(this._CurrentTabM == 5)?_TextObj._str ="":_TextObj._str ="丟棄";
				if (i == 2)(this._CurrentTabM == 1 || this._CurrentTabM == 2 || this._CurrentTabM == 3)?_TextObj._str = "丟棄":_TextObj._str = "";
				_TipBtnText = new Text(_TextObj);
				_TipBtnText.x = 15;
				_TipBtnText.y = 5;
				_TipBtn.addChild(_TipBtnText);
				
				this._viewConterBox.addChild(_TipBtn);
				TweenLite.to(_TipBtn, 0.5, {  y: (int(_InputItem.name) < 40)?_TipBtn.y + (40 * i):_TipBtn.y - (40 * i) } );
			}
			this._TipCtrlBoolean = false;
		}
		private function AddClickHandler(_InputItem:Sprite):void
		{
			_InputItem.addEventListener(MouseEvent.CLICK, ItemClickHandler);
			(this._ItemDisplayID[_InputItem.name].ItemData._useing != 3)?this._viewConterBox.addEventListener(MouseEvent.CLICK, ViewClickHandler):this._viewConterBox.addEventListener(MouseEvent.CLICK, ReViewClickHandler);
		}
		private function ItemRollOver(e:MouseEvent):void
		{
			this.RemoveTip();
			var _CurrentItemDisplay:ItemDisplay = ItemDisplay(this._ItemDisplayID[e.currentTarget.name]);
			
			if (this._CurrentTabM == 0) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MCS", PlaySystemStrLab.Package_Stone, { _guid:_CurrentItemDisplay.ItemID }, Sprite(e.currentTarget).x - 7, Sprite(e.currentTarget).y + 45));
			if (this._CurrentTabM == 1) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_WPN", PlaySystemStrLab.Package_Weapon, { _guid:_CurrentItemDisplay.ItemID, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, Sprite(e.currentTarget).x - 7, Sprite(e.currentTarget).y + 45,_CurrentItemDisplay.ItemData._quality));
			if (this._CurrentTabM == 2) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_AMR", PlaySystemStrLab.Package_Shield, { _guid:_CurrentItemDisplay.ItemID, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, Sprite(e.currentTarget).x - 7, Sprite(e.currentTarget).y + 45,_CurrentItemDisplay.ItemData._quality));
			if (this._CurrentTabM == 3) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_ACY", PlaySystemStrLab.Package_Accessories, { _guid:_CurrentItemDisplay.ItemID, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, Sprite(e.currentTarget).x - 7, Sprite(e.currentTarget).y + 45,_CurrentItemDisplay.ItemData._quality));
			if (this._CurrentTabM == 5) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MTL", PlaySystemStrLab.Package_Source, { _groupGuid:_CurrentItemDisplay.ItemID }, Sprite(e.currentTarget).x - 7, Sprite(e.currentTarget).y + 45));
			TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
		}
		private function ItemRollOut(e:MouseEvent):void
		{
			TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
			TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
		}
		
		private function ViewClickHandler(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "TipBtn0":
					(this._CurrentTabM != 5)?this.SendNotify( StorageStrLib.GetMonsterMenu):null;
					this.RemoveTip();
				break;
				case "TipBtn1":
					(this._CurrentTabM == 0)?this.RemoveTip():null;
				break;
				case "TipBtn2":
					this.RemoveTip();
				break;
				
				case "Make0":
					for (var k:String in _ItemDisplayMenu) if (this._viewConterBox.getChildByName("EquText" + k) != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("EquText" + k));
					var _SureUse:Object = new Object();
						_SureUse["MonsterName"] =	this._CurrentMonsterID;
						_SureUse["IconName"] = this._CurrentItemID.ItemID;
						_SureUse["CurrentTabM"] = this._CurrentTabM;
						if (this._CurrentTabM == 1 || this._CurrentTabM == 2 || this._CurrentTabM == 3)_SureUse["equGroupID"] = this._CurrentItemID.ItemData._gruopGuid;
					this.SendNotify( StorageStrLib.SureUse, _SureUse);
					this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Inform"));
					this._viewConterBox.removeEventListener(MouseEvent.CLICK, ViewClickHandler);	
				break;
				case "Make1":
					TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:385, y:195, scaleX:0.5, scaleY:0.5 ,onComplete:RemoveFourthLayer } );
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
						_Unload["IconName"] = this._CurrentItemID.ItemID;
						_Unload["CurrentTabM"] = this._CurrentTabM;
					this.SendNotify( StorageStrLib.Unload, _Unload);
					this.RemoveTip();
					this._viewConterBox.removeEventListener(MouseEvent.CLICK, ReViewClickHandler);
				break;
			}
		}
		//儲藏室第三層 惡魔列表
		public function GetMonsterMenu(_InputMonster:Vector.<MonsterDisplay>):void
		{
			trace("儲藏室第三層");
			var _StorageLayer:Object = new Object();
				_StorageLayer["Layer"] = 3;
			this.SendNotify( StorageStrLib.StorageLayer,_StorageLayer);
			
			this._viewConterBox.setChildIndex(this._viewConterBox.getChildByName("BackGround"), this._viewConterBox.numChildren - 1 );
			
			var _AddMonsterMenu:Object = new Object();
				_AddMonsterMenu["Monster"] = _InputMonster;
				_AddMonsterMenu["BGObj"] = this._BGObj;
				_AddMonsterMenu["IconName"] = this._CurrentItemID.ItemID;
				_AddMonsterMenu["CurrentTabM"] = this._CurrentTabM;
			this.SendNotify( UICmdStrLib.AddMonsterMenu, _AddMonsterMenu);
		}
		public function AddTip(_InputSpr:Sprite):void
		{
			if (this._ShowTip == null) {
				this._ShowTip = _InputSpr;
				//this._ShowTip.mouseEnabled = false;
				this._ShowTip.name = "ShowTip";
				this._viewConterBox.addChild(this._ShowTip );
			}
			this._viewConterBox.setChildIndex(this._viewConterBox.getChildByName("ShowTip"), this._viewConterBox.numChildren - 1);
			if (this._viewConterBox.mouseX < 690) {
				this._ShowTip.x = this._viewConterBox.mouseX;
				this._ShowTip.y = this._viewConterBox.mouseY;
			}else {
				this._ShowTip.x = this._viewConterBox.mouseX-this._ShowTip.width;
				this._ShowTip.y = this._viewConterBox.mouseY;
			}
			
		}
		//儲藏室第四層 惡魔列表點擊效果
		public function UseHandler(/*_InputName:String,*/ _InputMonsterDisplay:MonsterDisplay, _InputItemDisplay:ItemDisplay):void
		{
			trace("儲藏室第四層");
			var _StorageLayer:Object = new Object();
				_StorageLayer["Layer"] = 4;
			this.SendNotify( StorageStrLib.StorageLayer,_StorageLayer);
			
			var _Inform:Sprite = new (this._StorageBGObj.Inform as Class);
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
			for (var i:int = 0; i < 2; i++) 
			{
				var _MakeBtn:Sprite = new (this._StorageBGObj.MakeBtn as Class);
					_MakeBtn.x = 100+i * 150;
					_MakeBtn.y = 250;
					_MakeBtn.name = "Make" + i;
					_MakeBtn.buttonMode = true;
					this.MouseEffect(_MakeBtn);
				var _MakeText:TextField = TextField(_MakeBtn.getChildByName("Make_txt"));
					if (_MakeBtn.name == "Make0" ) {
						_MakeText.text = "YES"
					}else {
						this._TxtFormat.color = 0xFF0000;
						_MakeText.defaultTextFormat = this._TxtFormat;
						_MakeText.text = "NO";
					}
					_MakeText.mouseEnabled = false;
				_Inform.addChild(_MakeBtn);
			}
			this.ZoomIn(_Inform, 452, 351, 0.5);
		}
		private function ZoomIn(_InputSp:Sprite,_OriginalWidth:int,_OriginalHeight:int,_Proportion:Number):void
		{
			var _NewX:int = _InputSp.x - ((_OriginalWidth * _Proportion)) * _Proportion;
			var _NewY:int = _InputSp.y - ((_OriginalHeight * _Proportion)) * _Proportion;
			TweenLite.to(_InputSp, 1, { x:_NewX, y:_NewY, scaleX:1, scaleY:1 , ease:Elastic.easeOut } );//x:300-((400*0.5)*0.5)
		}
		
		public function RemoveFourthLayer():void
		{
			var _StorageLayer:Object = new Object();
				_StorageLayer["Layer"] = 3;
			this.SendNotify( StorageStrLib.StorageLayer,_StorageLayer);
			this.SendNotify( UICmdStrLib.RecoverBtn);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Inform"));
			//this._viewConterBox.removeEventListener(MouseEvent.CLICK, ViewClickHandler);
		}
		
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
		
		private function TabSFactory(_InputSP:MovieClip,InputNum:int):void
		{
			var _TabElement:MovieClip = _InputSP;
				_TabElement.x = 27;
				_TabElement.y = -15;
				_TabElement.name = this._onTabElement[InputNum].name;
				_TabElement.gotoAndStop(1);
			var _TabS:Sprite = new  (this._StorageBGObj.TabS as Class);
				_TabS.scaleX = 0.8;
				_TabS.scaleY = 0.8;
				(this._CurrentTabM<InputNum)?_TabS.x =this._viewConterBox.getChildByName(""+this._CurrentTabM).x+(InputNum-this._CurrentTabM)*77:_TabS.x =this._viewConterBox.getChildByName(""+this._CurrentTabM).x-(this._CurrentTabM-InputNum)*77;
				_TabS.y = 165;
				_TabS.buttonMode = true;
				_TabS.name = "" + InputNum;
				_TabS.addChild(_TabElement);
			this._viewConterBox.addChild(_TabS);
			//this.btnFactory(_TabS);
			this.move(_TabS, InputNum);
		}
		private function move(_InputSP:Sprite,InputNum:int):void
		{
			if (InputNum == this._CurrentTabM ) {
				this.removebtnFactory(_InputSP);
				this._viewConterBox.removeChild(_InputSP);
				this.TabMFactory(this._onTabElement[InputNum], InputNum);
			}else if (InputNum != this._CurrentTabM&&this._CurrentTabM > -1 ){
				TweenLite.to(_InputSP, 0.2, { x:160 + InputNum * 97, y:160, scaleX:1, scaleY:1,onComplete:btnFactoryHandler,onCompleteParams:[_InputSP] } );
			}
		}
		private function btnFactoryHandler(_InputSP:Sprite):void
		{
			this.btnFactory(_InputSP);
		}
		private function TabMFactory(_InputSP:MovieClip,InputNum:int):void
		{
			var _TabElement:MovieClip = _InputSP;
				_TabElement.x = 27;
				_TabElement.y = -15;
				_TabElement.gotoAndStop(3);
			var _TabM:Sprite = new  (this._StorageBGObj.TabM as Class);
				_TabM.x =160+InputNum*97;
				_TabM.y = 150;
				_TabM.buttonMode = true;
				_TabM.name = "" + InputNum;
				_TabM.addChild(_TabElement);
			this._viewConterBox.addChild(_TabM);
			for (var i:int = 0; i < 6; i++) 
			{
				(i==this._CurrentTabM)?null:this.TabSFactory(this._onTabElement[i], i);
			}
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
					this._CurrentTabM = int(e.currentTarget.name);
					this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
					
					this.RemoveTip();
					if (this._PageList.length!=0) {
						for (var j:int = 0; j < this._PageList[this._CtrlPageNum].length ; j++) {
						this._viewConterBox.getChildByName("" + j).removeEventListener(MouseEvent.CLICK, ItemClickHandler);
					    this._viewConterBox.removeChild(this._viewConterBox.getChildByName(""+j));
						}
					}
					
					for (var i:int = 0; i < 6; i++) 
					{
						this.removebtnFactory(this._viewConterBox.getChildByName(""+i));
						this._viewConterBox.removeChild(this._viewConterBox.getChildByName(""+i));
					}		
					
					var _CurrentTab:Object = new Object();
						_CurrentTab["TabName"] = this._onTabElement[int(e.currentTarget.name)].name;
					this.SendNotify( StorageStrLib.CurrentTab,_CurrentTab);
				break;
				
				case "rollOver":
					e.currentTarget.scaleY = 1.2;
					e.currentTarget.y = e.currentTarget.y - 5;
					for (i = 0; i < 6; i++) 
					{
						(i != int(e.currentTarget.name) && i != this._CurrentTabM)?this._viewConterBox.getChildByName("" + i).scaleY = 0.8:null;
						(i != int(e.currentTarget.name) && i != this._CurrentTabM)?this._viewConterBox.getChildByName("" + i).y = this._viewConterBox.getChildByName("" + i).y + 5:null;
					}
					//MovieClip(e.currentTarget.getChildByName(this._onTabElement[int(e.currentTarget.name)].name)).gotoAndStop(2);
				break;
				
				case "rollOut":
				if (e.currentTarget.scaleY !=1) {
					
					for ( i = 0; i < 6; i++) 
					{
						this._viewConterBox.getChildByName("" + i).scaleY = 1;
						if (i != int(e.currentTarget.name) && i != this._CurrentTabM) {
							this._viewConterBox.getChildByName("" + i).y = this._viewConterBox.getChildByName("" + i).y - 5;
						}else if (i == int(e.currentTarget.name) && i != this._CurrentTabM) {
							this._viewConterBox.getChildByName("" + i).y = this._viewConterBox.getChildByName("" + i).y + 5;
						}
					}
					//MovieClip(e.currentTarget.getChildByName(this._onTabElement[int(e.currentTarget.name)].name)).gotoAndStop(1);
				}
				break;
				
			}
		}
		private function removebtnFactory(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, btnStatus);
			btn.removeEventListener(MouseEvent.ROLL_OUT, btnStatus);
			btn.removeEventListener(MouseEvent.CLICK, btnStatus);
		}
		
		//文字Tip
		private function playerClickProcess(e:MouseEvent):void
		{
			switch (e.type) 
			{
				case "rollOver":
					trace(e.currentTarget.name,"@@@@@");
					//this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD,new SendTips("Storage",ProxyPVEStrList.TIP_STRBASIC,"SysTip_PI5","PlaySystemStrLab.Package_Stone",{_guid:e.currentTarget._guid},this.mouseX,this.mouseY));
					break;
				case "rollOut":
					
					break;
			}
		}
		
		//頁數控制按鈕
		private function _onClickHandler(e:MouseEvent):void
		{
			this.RemoveTip();
				switch(e.currentTarget.name)
				{
					case "btn0":
						if (this._CtrlPageNum != 0) {
							this._CtrlPageNum == this._PageList.length-1?MovieClip(Sprite(this._viewConterBox.getChildByName("Bins")).getChildByName("btn1")).gotoAndStop(1):null;
							this._CtrlPageNum == 1?MovieClip(e.currentTarget).gotoAndStop(3):null;
							this._CtrlPageNum <= 0?this._CtrlPageNum = this._CtrlPageNum:(this._CtrlPageNum --) && (this.CtrlPage(this._CtrlPageNum, true));
						}
						break;
					case "btn1":
						if (this._CtrlPageNum != this._PageList.length - 1 && this._PageList.length > 1) {
							this._CtrlPageNum == 0?MovieClip(Sprite(this._viewConterBox.getChildByName("Bins")).getChildByName("btn0")).gotoAndStop(1):null;
							this._CtrlPageNum == this._PageList.length-2?MovieClip(e.currentTarget).gotoAndStop(3):null;
							this._CtrlPageNum ++;
							this._CtrlPageNum < this._PageList.length?this.CtrlPage(this._CtrlPageNum, true):this._CtrlPageNum --;
						}
						break;
				}
			this._CtrlPageNum == 0?Sprite(Sprite(this._viewConterBox.getChildByName("Bins")).getChildByName("btn0")).buttonMode = false:Sprite(Sprite(this._viewConterBox.getChildByName("Bins")).getChildByName("btn0")).buttonMode = true;
			(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1) ?Sprite(Sprite(this._viewConterBox.getChildByName("Bins")).getChildByName("btn1")).buttonMode = false:Sprite(Sprite(this._viewConterBox.getChildByName("Bins")).getChildByName("btn1")).buttonMode = true;
		}
		private function _onRollOverBtnHandler(e:MouseEvent):void
		{
			switch(e.currentTarget.name)
				{
					case "btn0":
						this._CtrlPageNum == 0?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(2);
						break;
					case "btn1":
						(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1)?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(2);
						break;
				}
		}
		private function _onRollOutBtnHandler(e:MouseEvent):void
		{
			switch(e.currentTarget.name)
				{
					case "btn0":
						this._CtrlPageNum == 0?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(1);
						break;
					case "btn1":
						(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1)?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(1);
						break;
				}
		}
		
		private function DrawRect(_LocationX:int, _LocationY:int, _Width:int, _Height:int):Sprite 
		{
			var _sp:Sprite = new Sprite ();
				_sp.graphics.beginFill(0x666cc);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}
		
		
		override public function onRemoved():void 
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClickProcess);
			if (this._PageList != null && this._PageList.length != 0 ) {
				for (var i:int = 0; i < this._PageList[this._CtrlPageNum].length; i++) 
				{
					this._viewConterBox.getChildByName("" + i).removeEventListener(MouseEvent.CLICK, ItemClickHandler);
				}
			}
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, ViewClickHandler);
			//this._TipCtrlBoolean = true;
			while (this._DisplayBox.numChildren>0) 
			{
				this._DisplayBox.removeChildAt(0);
			}
			while (this._viewConterBox.numChildren>0) 
			{
				this._viewConterBox.removeChildAt(0);
			}
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_CREAT);
		}
		
	}
}