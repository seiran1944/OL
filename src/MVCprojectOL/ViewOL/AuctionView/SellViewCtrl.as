package MVCprojectOL.ViewOL.AuctionView 
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
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UICmdStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author Brook
	 */
	public class SellViewCtrl extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _AuctionObj:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel;
		private var _CurrentTabM:int;
		private var _onTabElement:Vector.<MovieClip>;
		private var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
		private var _SlidingControl:SlidingControl;
		private var _PageList:Array;
		private var _CtrlPageNum:int;
		private var _MyPage:Array;
		private var _SellListBoard:Vector.<Sprite>;
		
		public function SellViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this._viewConterBox.addEventListener(MouseEvent.CLICK, SellplayerClick);
		}
		
		public function AddElement(_InputObj:Object, _AuctionObj:Object):void 
		{
			this._BGObj = _InputObj;
			this._AuctionObj = _AuctionObj;
		}
		
		public function AddSellPanel():void 
		{
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "SellBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Panel = new Sprite();
			this._Panel.x = 373;
			this._Panel.y = 127;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "SellPanel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel, UICmdStrLib.RemoveSell);
			this._BasisPanel.AddBasisPanel("拍賣密室", 430, 510, 256);
			this._BasisPanel.AddPageBtn(195);
			
			var _BgM:Sprite = new (this._BGObj.BgM as Class);
				_BgM.width = 385;
				_BgM.height = 390;
				_BgM.x = 40;
				_BgM.y = 145;
			this._Panel.addChild(_BgM);
			
			//var _Lattice:int = 28 + 7 * _BuildingLV;
			var _Box:Bitmap;
			for (var i:int = 0; i < 49; i++) 
			{
				_Box = new Bitmap(BitmapData(new(this._BGObj.Box as Class)));
				_Box.x = 50 + ( i % 7 ) * (48 + 5);
				_Box.y = 157 + ( int( i / 7 ) * (48 + 5));
				//if (i >= _Lattice) TweenLite.to(_Box, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
				this._Panel.addChild(_Box);
			}
			
			this._SlidingControl = new SlidingControl( this._Panel );
			
			this.Tab();
		}
		
		private function Tab():void
		{
			var _Magic:MovieClip = new (this._AuctionObj.Magic as Class);
				//_Magic.name = PlaySystemStrLab.Package_Stone;
			//this._TipsView.MouseEffect(_Magic);
			var _Weapon:MovieClip = new (this._AuctionObj.Weapon as Class);
				//_Weapon.name = PlaySystemStrLab.Package_Weapon;
			//this._TipsView.MouseEffect(_Weapon);
			var _Armor:MovieClip = new (this._AuctionObj.Armor as Class);
				//_Armor.name = PlaySystemStrLab.Package_Shield;
			//this._TipsView.MouseEffect(_Armor);
			var _Accessories:MovieClip = new (this._AuctionObj.Accessories as Class);
				//_Accessories.name = PlaySystemStrLab.Package_Accessories;
			//this._TipsView.MouseEffect(_Accessories);
			var _Monster:MovieClip = new (this._AuctionObj.Moster as Class);
			
			this._onTabElement = new <MovieClip>[_Magic, _Weapon, _Armor, _Accessories, _Monster];
			this._CurrentTabM = 0;
			
			this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
			
			//if (this._CurrentTabM == 0) this.PropertyMove(this._CurrentTabM, false);
		}
		private function TabMFactory(_InputSP:MovieClip,InputNum:int):void
		{
			var _TabElement:MovieClip = _InputSP;
				_TabElement.x = 12;
				_TabElement.y = -15;
				_TabElement.scaleX = 0.8;
				_TabElement.scaleY = 0.8;
				_TabElement.gotoAndStop(3);
				this._SharedEffect.RemoveMovieClipMouseEffect(_TabElement);
			var _TabM:MovieClip = new  (this._BGObj.Tab as Class);
				_TabM.x = 50 + InputNum * 62;//160 + InputNum * 97;
				_TabM.y = 120;
				_TabM.gotoAndStop(2);
				_TabM.buttonMode = false;
				_TabM.name = "STam" + InputNum;
				_TabM.addChild(_TabElement);
			this._Panel.addChild(_TabM);
			for (var i:int = 0; i < 5; i++)(i == this._CurrentTabM)?null:this.TabSFactory(this._onTabElement[i], i);
		}
		private function TabSFactory(_InputSP:MovieClip,InputNum:int):void
		{
			var _TabElement:MovieClip = _InputSP;
				_TabElement.x = 12;
				_TabElement.y = -10;
				_TabElement.name = this._onTabElement[InputNum].name;
				_TabElement.scaleX = 0.8;
				_TabElement.scaleY = 0.8;
				_TabElement.gotoAndStop(1);
				_TabElement.name = "STab" + InputNum;
				this._SharedEffect.MovieClipMouseEffect(_TabElement);
			var _TabS:MovieClip = new  (this._BGObj.Tab as Class);
				_TabS.scaleX = 0.6;
				_TabS.scaleY = 0.6;
				(this._CurrentTabM < InputNum)?_TabS.x = this._Panel.getChildByName("STam" + this._CurrentTabM).x + (InputNum - this._CurrentTabM) * 50:_TabS.x = this._Panel.getChildByName("STam" + this._CurrentTabM).x - (this._CurrentTabM - InputNum) * 50;
				_TabS.y = 125;
				_TabS.buttonMode = true;
				_TabS.name = "STam" + InputNum;
				_TabS.addChild(_TabElement);
			this._Panel.addChild(_TabS);
			this.move(_TabS, InputNum);
		}
		private function move(_InputSP:Sprite,InputNum:int):void
		{
			if (InputNum == this._CurrentTabM ) {
				this._Panel.removeChild(_InputSP);
				this.TabMFactory(this._onTabElement[InputNum], InputNum);
			}else if (InputNum != this._CurrentTabM&&this._CurrentTabM > -1 ){
				TweenLite.to(_InputSP, 0.2, { x:50 + InputNum * 62, y:120, scaleX:1, scaleY:1 } );
			}
		}
		
		private function TabClick(_Num:String):void 
		{
			if (this._CurrentTabM != int(_Num)) { 
				this.RemoveListBoard();
				if (this._PageList != null) this._PageList.length = 0;
				this._BasisPanel.PageData(this._PageList, 0);
				var _Tab:MovieClip;
				var _TabS:MovieClip;
				this._CurrentTabM = int(_Num);
				this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
				for (var i:int = 0; i < 5; i++) 
				{
					_Tab = this._Panel.getChildByName("STam" + i) as MovieClip;
					_TabS = _Tab.getChildByName("STab" + i) as MovieClip;
					if (_TabS != null) this._SharedEffect.RemoveMovieClipMouseEffect(_TabS);
					this._Panel.removeChild(_Tab);
				}
				var _Str:String;
				if (_Num == "0") _Str = PlaySystemStrLab.Package_Stone;
				if (_Num == "1") _Str = PlaySystemStrLab.Package_Weapon;
				if (_Num == "2") _Str = PlaySystemStrLab.Package_Shield;
				if (_Num == "3") _Str = PlaySystemStrLab.Package_Accessories;
				if (_Num == "4") _Str = PlaySystemStrLab.Package_Monster;
				var _GetPlayerSellGoods:Object = { PlayerSell:_Str, CtrlBoolean:false };
				this.SendNotify(UICmdStrLib.GetPlayerSellGoods, _GetPlayerSellGoods);
			}
		}
		
		private function RemoveListBoard():void 
		{
			if (this._SellListBoard != null) { 
				var _ListBoardLength:int = this._SellListBoard.length;
				for (var i:int = 0; i < _ListBoardLength; i++) 
				{
					this._SellListBoard[i].removeChildren();
					this._Panel.removeChild(this._SellListBoard[i]);
				}
				this._SellListBoard = null;
			}
		}
		
		public function AddSellGoodsData(_SellGoods:Vector.<ItemDisplay>):void 
		{
			//this._SlidingControl.ClearStage(true);
			this._PageList = this._SplitPageMethod.SplitPage(_SellGoods, 49);
			this.SellCtrlPage(this._CtrlPageNum, true);
		}
		public function SellCtrlPage( _InputPage:int , _CtrlBoolean:Boolean = true ):void
		{
			if (this._SellListBoard != null) this.RemoveListBoard();
			this._CtrlPageNum = _InputPage;
			this._MyPage = this._PageList[_InputPage];
			var _MyPageLength:uint = (_MyPage == null)?0:_MyPage.length;
			this._SellListBoard = new Vector.<Sprite>;
			var _CurrentItem:ItemDisplay;
			
			for (var i:int = 0; i < _MyPageLength; i++) 
			{
				_CurrentItem = this._MyPage[i];
				_CurrentItem.ShowContent();
				_CurrentItem.ItemIcon.x = 0;
				_CurrentItem.ItemIcon.y = 0;
				this._SellListBoard.push(this.ListBoardMenu(_CurrentItem, i));
				this._SellListBoard[i].x = 50 + ( i % 7 ) * (53);
				this._SellListBoard[i].y = 157 + ( int( i / 7 ) * (53));
				this._SellListBoard[i].name = "Icon" + i;
				this._SellListBoard[i].addEventListener(MouseEvent.CLICK, SellListClick);
				this._SellListBoard[i].addEventListener(MouseEvent.ROLL_OVER, ItemRollOver);
				this._SellListBoard[i].addEventListener(MouseEvent.ROLL_OUT, ItemRollOut);
				this._Panel.addChild(this._SellListBoard[i]);
				//this._SharedEffect.MouseEffect(this._SellListBoard[i]);
			}
			this._BasisPanel.PageData(this._PageList, this._CtrlPageNum);
		}
		
		//物件清單底板
		private function ListBoardMenu(_CurrentGoods:ItemDisplay = null, _Num:int = 0):Sprite
		{
			var _ListBoardMenu:Sprite = new Sprite();
				_ListBoardMenu.name = "Icon" + _Num;
				_ListBoardMenu.buttonMode = true;
				
			var _Icon:Sprite = _CurrentGoods.ItemIcon;
				_Icon.width = 48;
				_Icon.height = 48;
				//_Icon.x = 50;
				//_Icon.y = 157;
			_ListBoardMenu.addChild(_Icon);
			
			return _ListBoardMenu;
		}
		
		/*public function RemoveSellListBoard():void 
		{
			if (this._SellListBoard != null) {  
				var _SellListBoardLen:int = this._SellListBoard.length;
				for (var i:int = 0; i < _SellListBoardLen; i++) 
				{
					this._Panel.removeChild(this._SellListBoard[i]);
				}
				this._SellListBoard = null;
			}
		}*/
		
		private function ItemRollOver(e:MouseEvent):void
		{
			//this.RemoveTip();
			var _Num:String = String(e.currentTarget.name).substr(4, 1);
			TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
			if (e.currentTarget.name is String) var _CurrentItemDisplay:ItemDisplay = ItemDisplay(this._MyPage[int(_Num)]);
			//var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("StoragePanel"));
			var _CurrentTarget:Sprite = Sprite(e.currentTarget);
			if (this._CurrentTabM == 0) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Sell", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MCS", PlaySystemStrLab.Package_Stone, { _guid:_CurrentItemDisplay.ItemData._guid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
			if (this._CurrentTabM == 1) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Sell", ProxyPVEStrList.TIP_STRBASIC, "SysTip_WPN", PlaySystemStrLab.Package_Weapon, { _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
			if (this._CurrentTabM == 2) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Sell", ProxyPVEStrList.TIP_STRBASIC, "SysTip_AMR", PlaySystemStrLab.Package_Shield, { _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
			if (this._CurrentTabM == 3) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Sell", ProxyPVEStrList.TIP_STRBASIC, "SysTip_ACY", PlaySystemStrLab.Package_Accessories, { _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
			if (this._CurrentTabM == 4) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips( "Sell", ProxyPVEStrList.TIP_STRBASIC,  "SysTip_AC_MOB", ProxyPVEStrList.EXCHANGE_MONSTER, { _guid:_CurrentItemDisplay.ItemData._guid },  _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
		}
		private function ItemRollOut(e:MouseEvent):void
		{
			TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
			TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
		}
		
		private function SellListClick(e:MouseEvent):void 
		{
			this.onRemoved();
			TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
			var _Num:String = String(e.currentTarget.name).substr(4, 1);
			this.SendNotify(UICmdStrLib.PlayerSellGoods, this._MyPage[int(_Num)]);
		}
		
		private function SellplayerClick(e:MouseEvent):void 
		{
			var _CurrentName:String = e.target.name;
			var _Num:String;
			if (_CurrentName.substr(0, 1) == "S")  _Num = _CurrentName.substr(4, 1);
			switch (_CurrentName) 
			{
				case "STab"+ _Num:
				case "STam"+ _Num:
					this.TabClick(_Num);
				break;
			}
		}
		
		override public function onRemoved():void 
		{
			this._SellListBoard = null;
			if (this._viewConterBox.getChildByName("SellBox") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("SellBox"));
			if (this._viewConterBox.getChildByName("SellPanel") != null) this._viewConterBox.removeChild(this._Panel);
		}
		
	}
}