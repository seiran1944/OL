package MVCprojectOL.ViewOL.DevilStoreView 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpGoods;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.UICmdStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class DevilStoreViewCtrl extends ViewCtrl
	{
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"LEFT", _col:0xFFFFFF, _Size:12, _bold:true, _font:"Times New Roman", _leading:null };
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _DevilStoreObj:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel;
		private var _StoreData:Object;
		private var _SlidingControl:SlidingControl;
		private var _PageList:Array;
		private var _CtrlPageNum:int;
		private var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
		private var _MyPage:Array;
		private var _ListBoardMenu:Vector.<Sprite>;
		private var _AskPanel:AskPanel = new AskPanel();
		private var _CurrentTabPanel:int;
		
		public function DevilStoreViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClick);
		}
		
		public function AddElement(_InputObj:Object, _DevilStoreObj:Object, _PlayerHonor:int):void 
		{
			this._BGObj = _InputObj;
			this._DevilStoreObj = _DevilStoreObj;
			
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "DevilStoreBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Panel = new Sprite();
			this._Panel.x = 293;
			this._Panel.y = 127;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "DevilStorePanel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel, UICmdStrLib.RemoveDevilStore);
			this._BasisPanel.AddBasisPanel("魔鬥商店", 750, 510, 400);
			
			this._BasisPanel.AddPageBtn(355);
			
			this._SlidingControl = new SlidingControl( this._Panel );
			
			var _WallBg:Bitmap = new Bitmap(BitmapData(new (this._BGObj.WallBg)));
				_WallBg.x = 50;
				_WallBg.y = 100;
			this._Panel.addChild(_WallBg);
			
			var _Integral:Bitmap = new Bitmap(BitmapData(new (this._DevilStoreObj.Integral)));
				_Integral.scaleX = 0.5;
				_Integral.scaleY = 0.5;
				_Integral.x = 638;
				_Integral.y = 132;
			this._Panel.addChild(_Integral);
			this._TextObj._col = 0xF4F0C1;
			this._TextObj._Size = 14;
			this._TextObj._str = "魔鬥積分        "+_PlayerHonor;
			var _CountText:Text = new Text(this._TextObj);
				_CountText.x = 570;
				_CountText.y = 130;
				_CountText.name = "Count";
			this._Panel.addChild(_CountText);
			
			this.Tab();
		}
		
		private function Tab():void
		{
			var _TabPanel:Sprite;
			var _Integral:Bitmap;
			var _Diamond:Bitmap;
			var _Tab:MovieClip;
			for (var i:int = 0; i < 3; i++) 
			{
				_TabPanel = this._SharedEffect.DrawRect(0, 0, 60, 30);
				_Tab = new (this._BGObj.Tab as Class);
				if (i == 0) { 
					_Integral = new Bitmap(BitmapData(new (this._DevilStoreObj.Integral)));
					_Integral.x = 5;
					_Integral.y = -7;
					_Integral.name = "Integral";
					_Tab.addChild(_Integral);
					_Diamond = new  Bitmap(BitmapData(new (this._BGObj.Diamond)));
					_Diamond.scaleX = 0.8;
					_Diamond.scaleY = 0.8;
					_Diamond.x = 17;
					_Diamond.y = -15;
					_Diamond.name = "Diamond";
					_Tab.addChild(_Diamond);
					_Tab.gotoAndStop(2);
				}
				if (i == 1) { 
					_TabPanel.buttonMode = true;
					_Integral = new Bitmap(BitmapData(new (this._DevilStoreObj.Integral)));
					_Integral.x = 13;
					_Integral.y = -7;
					_Integral.name = "Integral";
					_Tab.addChild(_Integral);
					TweenLite.to(_Integral, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
				}
				if (i == 2) { 
					_TabPanel.buttonMode = true;
					_Diamond = new  Bitmap(BitmapData(new (this._BGObj.Diamond)));
					_Diamond.scaleX = 0.8;
					_Diamond.scaleY = 0.8;
					_Diamond.x = 6;
					_Diamond.y = -15;
					_Diamond.name = "Diamond";
					_Tab.addChild(_Diamond);
					TweenLite.to(_Diamond, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
				}
				_Tab.x = 300 + i * 65;
				_Tab.y = 130;
				_Tab.name = "TabS" + i;
				this._Panel.addChild(_Tab);
				_TabPanel.x = _Tab.x + 2;
				_TabPanel.y = _Tab.y - 5;
				_TabPanel.alpha = 0;
				//_TabPanel.buttonMode = true;
				_TabPanel.name = "Tab" + i;
				this.AddMouseEffect(_TabPanel);
				this._Panel.addChild(_TabPanel);
			}
			this._CurrentTabPanel = 0;
		}
		private function AddMouseEffect(_Btn:Sprite):void 
		{
			_Btn.addEventListener(MouseEvent.ROLL_OVER, BtnHandler);
			_Btn.addEventListener(MouseEvent.ROLL_OUT, BtnHandler);
		}
		private function BtnHandler(e:MouseEvent):void 
		{
			var _Str:String = String(e.currentTarget.name).substr(3, 1);
			var _Tab:MovieClip = MovieClip(this._Panel.getChildByName("TabS" + _Str));
			if (_Tab.getChildByName("Integral") != null) var _Integral:Bitmap = Bitmap(_Tab.getChildByName("Integral"));
			if (_Tab.getChildByName("Diamond") != null) var _Diamond:Bitmap =Bitmap( _Tab.getChildByName("Diamond"));
			switch (e.type) 
			{
				case "rollOver":
					if (this._CurrentTabPanel != int(_Str)) { 
						if (_Integral != null) _Integral.filters = [];
						if (_Diamond != null) _Diamond.filters = [];
					}
				break;
				case "rollOut":
					if (this._CurrentTabPanel != int(_Str)) { 
						if (_Integral != null) TweenLite.to(_Integral, 0, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
						if (_Diamond != null) TweenLite.to(_Diamond, 0, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
					}
				break;
			}
		}
		
		public function AddStoreData(_StoreData:Object):void 
		{
			this._StoreData = _StoreData;
			this.CurrentStoreData(this._StoreData._aryAll);
		}
		
		private function CurrentStoreData(_CurrentStoreData:Array):void 
		{
			this._SlidingControl.ClearStage(true);
			this._PageList = this._SplitPageMethod.SplitPage(_CurrentStoreData, 9);
			this.CtrlPage(this._CtrlPageNum, true);
		}
		public function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ):void
		{
			this._CtrlPageNum = _InputPage;
			this._MyPage = this._PageList[_InputPage];
			var _MyPageLength:uint = (this._MyPage == null)?0:this._MyPage.length;
			this._ListBoardMenu = new Vector.<Sprite>;
			
			for (var i:int = 0; i < 9; i++) 
			{
				if (i < _MyPageLength) { 
					this._ListBoardMenu.push(this.ListBoardMenu(_MyPage[i], i));
					this._SharedEffect.MouseEffect(this._ListBoardMenu[i]);
				}else {
					this._ListBoardMenu.push(this.ListBoardMenu());
				}
			}
			
			this._SlidingControl._Cols = 3;
			this._SlidingControl._Rows = 3;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 235;
			this._SlidingControl._VerticalInterval = 120;
			this._SlidingControl._RightInPosX = 0;
			this._SlidingControl._LeftInPosX = 470;
			this._SlidingControl.NextPage(this._ListBoardMenu , _CtrlBoolean);
			
			this._BasisPanel.PageData(this._PageList, this._CtrlPageNum);
		}
		
		//物件清單底板
		private function ListBoardMenu(_CurrentGoods:PvpGoods = null, _Num:int = 0):Sprite
		{
			var _ListBoardMenu:Sprite = new Sprite();
			var _GoodsPanel:Sprite;
			
			if (_CurrentGoods != null) { 
				(_CurrentGoods._moneyType == 0)?_GoodsPanel = new (this._DevilStoreObj.Abnormal):_GoodsPanel = new (this._DevilStoreObj.NormalBg);
				_GoodsPanel.width = 230;
				_GoodsPanel.height = 115;
				_GoodsPanel.x = 42;
				_GoodsPanel.y = 160;
				_ListBoardMenu.addChild(_GoodsPanel);
				
				var _Title:Sprite = new (this._DevilStoreObj.Title);
					_Title.x = 101;
					_Title.y = 165;
				_ListBoardMenu.addChild(_Title);
				
				this._TextObj._Size = 12;
				this._TextObj._col = 0xFFFFFF;
				this._TextObj._str = _CurrentGoods._title;
				var _TitleText:Text = new Text(this._TextObj);
					_TitleText.x = 2;
					_TitleText.y = 2;
				_Title.addChild(_TitleText);
				
				this._TextObj._str = _CurrentGoods._info;
				var _InfoText:Text = new Text(this._TextObj);
					_InfoText.x = 50;
					_InfoText.y = 220;
				_ListBoardMenu.addChild(_InfoText);
				
				var _CurrentItem:ItemDisplay = _CurrentGoods._goods as ItemDisplay;
					_CurrentItem.ShowContent();
				var _Icon:Sprite = _CurrentItem.ItemIcon;
					_Icon.width = 48;
					_Icon.height = 48;
					_Icon.x = 50;
					_Icon.y = 167;
				_ListBoardMenu.addChild(_Icon);
				
				//_CurrentGoods._locking = false;
				var _CheckBtn:Sprite = new (_BGObj.CheckBtn as Class);
					_CheckBtn.width = 85;
					_CheckBtn.x = 180;
					_CheckBtn.y = 185;
					if (_CurrentGoods._locking == false) {
						_CheckBtn.buttonMode = true;
						_CheckBtn.name = "CheckBtn" + _Num;
						this._SharedEffect.MovieClipMouseEffect(_CheckBtn);
					}else {
						TweenLite.to(_CheckBtn, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
					}
				_ListBoardMenu.addChild(_CheckBtn);
				this._TextObj._Size = 14;
				this._TextObj._str = "購買";
				var _CheckBtnText:Text = new Text(this._TextObj);
					_CheckBtnText.x = 47;
					_CheckBtnText.y = 10;
				_CheckBtn.addChild(_CheckBtnText);
				
				var _PricePic:Bitmap;
				(_CurrentGoods._moneyType == 0)?_PricePic = new Bitmap(BitmapData(new (this._DevilStoreObj.Integral))):_PricePic = new  Bitmap(BitmapData(new (this._BGObj.Diamond)));
				_PricePic.scaleX = 0.5;
				_PricePic.scaleY = 0.5;
				(_CurrentGoods._moneyType == 0)?_PricePic.x = 105:_PricePic.x = 100;
				(_CurrentGoods._moneyType == 0)?_PricePic.y = 192:_PricePic.y = 185;
				_ListBoardMenu.addChild(_PricePic);
				this._TextObj._Size = 14;
				this._TextObj._str = "" + _CurrentGoods._price;
				var _PriceText:Text = new Text(this._TextObj);
					_PriceText.x = 125;
					_PriceText.y = 190;
				_ListBoardMenu.addChild(_PriceText);
				
			}else {
				(this._CurrentTabPanel == 1)?_GoodsPanel = new (this._DevilStoreObj.Abnormal):_GoodsPanel = new (this._DevilStoreObj.NormalBg);
				_GoodsPanel.width = 230;
				_GoodsPanel.height = 115;
				_GoodsPanel.x = 42;
				_GoodsPanel.y = 160;
				_ListBoardMenu.addChild(_GoodsPanel);
			}
			
			return _ListBoardMenu;
		}
		//<<回傳檢查狀態  -2 = 查無此商品資料 ,  -1 = 格子位置不足 ,  0 = 可以順利購買 ,  1 = 晶鑽不足 , 2 = 積分不足
		public function AddInform(_Status:int):void 
		{
			var _Str:String;
			switch (_Status) 
			{
				case -2:
					_Str = "查無此商品資料";
					this._AskPanel.AddInform(0);
				break;
				case -1:
					_Str = "儲藏室位置不足";
					this._AskPanel.AddInform(0);
				break;
				case 0:
					_Str = "確認購買!?";
					this._AskPanel.AddInform();
				break;
				case 1:
					_Str = "晶鑽不足";
					this._AskPanel.AddInform(0);
				break;
				case 2:
					_Str = "積分不足";
					this._AskPanel.AddInform(0);
				break;
			}
			this._AskPanel.AddMsgText(_Str, 0);
			
		}
		
		public function UpData(_Status:int, _PlayerHonor:int):void 
		{
			if (_Status == 1) {
				Text(this._Panel.getChildByName("Count")).ReSetString("魔鬥積分        "+_PlayerHonor);
			}else {
				this.SendNotify(UICmdStrLib.RemoveDevilStore);
			}
		}
		
		private function playerClick(e:MouseEvent):void 
		{
			var _CurrentName:String = e.target.name;
			var _Num:String;
			if (_CurrentName.substr(0, 1) == "C") _Num = _CurrentName.substr(8, 1);
			if (_CurrentName.substr(0, 1) == "T") _Num = _CurrentName.substr(3, 1);
			switch (_CurrentName) 
			{
				case "CheckBtn" + _Num:
					this.SendNotify(UICmdStrLib.CheckBuying, this._MyPage[int(_Num)]._guid);
				break;
				case "Tab" + _Num:
					if (this._CurrentTabPanel != int(_Num)) { 
						Sprite(this._Panel.getChildByName("Tab" + this._CurrentTabPanel)).buttonMode = true;
						var _Tab:MovieClip = MovieClip(this._Panel.getChildByName("TabS" + this._CurrentTabPanel));
						_Tab.gotoAndStop(1);
						if (_Tab.getChildByName("Integral") != null) TweenLite.to(_Tab.getChildByName("Integral"), 0, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
						if (_Tab.getChildByName("Diamond") != null) TweenLite.to(_Tab.getChildByName("Diamond"), 0, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
						
						this._CurrentTabPanel = int(_Num);
						if (_Num == "0") this.CurrentStoreData(this._StoreData._aryAll);
						if (_Num == "1") this.CurrentStoreData(this._StoreData._aryHonor);
						if (_Num == "2") this.CurrentStoreData(this._StoreData._aryDiamond);
						Sprite(this._Panel.getChildByName("Tab" + this._CurrentTabPanel)).buttonMode = false;
						_Tab = MovieClip(this._Panel.getChildByName("TabS" + this._CurrentTabPanel));
						_Tab.gotoAndStop(2);
						if (_Tab.getChildByName("Integral") != null) _Tab.getChildByName("Integral").filters = [];
						if (_Tab.getChildByName("Diamond") != null) _Tab.getChildByName("Diamond").filters = [];
					}
				break;
				
				case "Make0"://yes
					this.SendNotify(UICmdStrLib.DoBuying);
					this._AskPanel.RemovePanel();
				break;
				case "Make1"://no
					this._AskPanel.RemovePanel();
				break;
				
			}
		}
		
		override public function onRemoved():void 
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClick);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("DevilStoreBox"));
			this._viewConterBox.removeChild(this._Panel);
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
		}
		
	}
}