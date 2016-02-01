package MVCprojectOL.ControllOL.AuctionCtrl 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.Exchange.ExchangeProxy;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplayProxy;
	import MVCprojectOL.ModelOL.ViewSharedModel.ViewSharedModel;
	import MVCprojectOL.ViewOL.AuctionView.AuctionViewCtrl;
	import MVCprojectOL.ViewOL.AuctionView.SellViewCtrl;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewNameLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchAuctionControl extends CatchCommands
	{
		private var _SourceProxy:SourceProxy;
		private var _ViewSharedModel:ViewSharedModel;
		private var _AuctionViewCtrl:AuctionViewCtrl;
		private var _ExchangeProxy:ExchangeProxy;
		private var _ItemDisplayProxy:ItemDisplayProxy;
		private var _SellViewCtrl:SellViewCtrl;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String >  [  "BgB" , "Title", "ExplainBtn", "EdgeBg", "CheckBtn", "CloseBtn","PageBtnS"
																					,"Fatigue", "Tab", "MonsterBox", "TitleBtn", "BgM", "SortBtn", "Box", "DemonAvatar", "Paper", "TitleBtn"];
		private var _ComponentClasses:Object;
		
		public var _SharedKey:String = "GUI00016_ANI";// 素材包KEY碼
		public var _SharedClasses:Vector.<String> = new < String > ["Hyphen", "SearchBox", "Entervalue", "Magic", "Weapon", "Armor", "Accessories", "SearchBox", "SaleBg", "Moster"];
		private var _SharedComponentClasses:Object;
		
		private var _CtrlPageNum:int = 0;
		private var _CurrentSellGoods:ItemDisplay;
		private var _PlayerSellStr:String;
		private var _CurrentTabM:int;
		private var _SellPage:int = 0;
		
		public function CatchAuctionControl() 
		{
			
		}
		
		private function initAuctionCore():void 
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
				
				var _equClass:MovieClip=(this._SourceProxy.GetMaterialSWP(this._GlobalComponentPackKey,"Property",true)) as MovieClip;
				var _aryProperty:Array = this._SourceProxy.GetMovieClipHandler(_equClass, false, "PropertyImages");
				this._ComponentClasses.PropertyImages = _aryProperty;
				
				this._ViewSharedModel = ViewSharedModel.GetInstance();
				this._facaed.RegisterProxy( this._ViewSharedModel );
				this._ViewSharedModel._SharedKey = this._SharedKey;
				this._ViewSharedModel._SharedClasses = this._SharedClasses;
				this._ViewSharedModel.StartLoad( this._SharedKey );
				
				trace("素材OK !!");
			}else {
				trace("素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function TerminateThis():void 
		{
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Auction );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_SharedUIproxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_ItemDisplayProxy );
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Sell );
			
			this._AuctionViewCtrl = null;
			this._ViewSharedModel = null;
			this._ItemDisplayProxy = null;
			this._SellViewCtrl = null;
			
			this.SendNotify( UICmdStrLib.Terminate_Auction );
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				case UICmdStrLib.Init_AuctionCatch:
					this.initAuctionCore();
				break;
				case this._SharedKey :
					this._SharedComponentClasses = _obj.GetClass();
					this.OnAuction();
				break;
				
				case UICmdStrLib.SetSearch:
					this._ExchangeProxy.SetSearch(_obj.GetClass().EXCHANGE, _obj.GetClass().NAMEONE,_obj.GetClass().NAMETOW);
				break;
				case UICmdStrLib.StartSearch:
					this._CurrentTabM = _obj.GetClass().CurrentTab as int;
					this._ExchangeProxy.StartSearch(this._CurrentTabM );
					this._SellPage = 0;
				break;
				case ProxyPVEStrList.EXCHANGE_SEARCH_READY:
					(_obj.GetClass() != null)?this.GetGoodsData(_obj.GetClass()._goods, _obj.GetClass()._max):this._AuctionViewCtrl.AddBuyMsg();
					if (_obj.GetClass() == null) this._CtrlPageNum = 0;
				break;
				case UICmdStrLib.ReSet:
					this._ExchangeProxy.ReSetCondition();
				break;
				case UICmdStrLib.GetPlayerSellList:
					this._ExchangeProxy.GetPlayerSellList();
					//this._CtrlPageNum = 0;
					this._SellPage = 1;
				break;
				case ProxyPVEStrList.EXCHANGE_SELL_LISTREDAY:
					this.GetGoodsData(_obj.GetClass() as Array, 0, "Sell");
				break;
				case UICmdStrLib.GetPlayerSellGoods:
					if (_obj.GetClass().CtrlBoolean == true) this._SellViewCtrl.AddSellPanel();
					this._PlayerSellStr = _obj.GetClass().PlayerSell;
					this.GetGoodsData(this._ExchangeProxy.GetPlayerSellGoods(this._PlayerSellStr), 0, "PlayerSell");
					this._CurrentSellGoods = null;
					//this._CtrlPageNum = 0;
					this._SellPage = 2;
				break;
				case UICmdStrLib.PlayerSellGoods:
					this._CurrentSellGoods = _obj.GetClass() as ItemDisplay;
					this._AuctionViewCtrl.AddSellGoods(this._CurrentSellGoods);
				break;
				case UICmdStrLib.SellGoods:
					var _groupGuid:String;
					(this._CurrentSellGoods.ItemData._type == null)?_groupGuid = "":_groupGuid = this._CurrentSellGoods.ItemData._type;
					this._ExchangeProxy.SellGoods(_obj.GetClass().Money, this._PlayerSellStr, this._CurrentSellGoods.ItemData._guid, _groupGuid);
					this._AuctionViewCtrl.RemoveSellGoods();
				break;
				
				case UICmdStrLib.BuyGoods:
					var _CtrlBoolean:Boolean = this._ExchangeProxy.BuyGoods(_obj.GetClass().guid, _obj.GetClass().sellMoney);
					if (_CtrlBoolean == false) this._AuctionViewCtrl.AddSuccessBuyMsg(_CtrlBoolean);
				break;
				case ProxyPVEStrList.EXCHANGE_BUY_SUCCESS:
					this._AuctionViewCtrl.AddSuccessBuyMsg();
					var _SetSearch:Object = { CurrentTab:this._CurrentTabM };
					this.SendNotify(UICmdStrLib.StartSearch, _SetSearch);
				break;
				case UICmdStrLib.Sort:
					this._ExchangeProxy.Sort(_obj.GetClass().type, _obj.GetClass().upDown);
				break;
				case ProxyPVEStrList.EXCHANGE_ERROR:
					this._AuctionViewCtrl.AddErrorMsg(_obj.GetClass() as String);
				break;
				
				case UICmdStrLib.CtrlPage:
					this._AuctionViewCtrl.RemoveListBoard();
					this._CtrlPageNum = _obj.GetClass().CtrlPageNum;
					//trace(this._CtrlPageNum,"@@@@@@@@");
					if (this._SellPage == 0) this._ExchangeProxy.ChangePage(this._CtrlPageNum + 1);
					if (this._SellPage == 1) this._AuctionViewCtrl.CtrlPage(this._CtrlPageNum);
					if (this._SellPage == 2) this._SellViewCtrl.SellCtrlPage(this._CtrlPageNum);
					//this._AuctionViewCtrl.CtrlPage(_obj.GetClass().CtrlPageNum, _obj.GetClass().CtrlBoolean);
				break;
				
				case UICmdStrLib.RemoveALL:
					this.TerminateThis();
					this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
				break;
				case UICmdStrLib.RemoveSell:
					this._SellViewCtrl.onRemoved();
				break;
				case ProxyPVEStrList.TIP_CLOSESYS :
					this.TerminateThis();
				break;
			}
		}
		
		private function OnAuction():void 
		{
			this._ItemDisplayProxy = ItemDisplayProxy.GetInstance();//Item顯示快取容器
			this._facaed.RegisterProxy( this._ItemDisplayProxy );//Item顯示快取容器
			
			this._ExchangeProxy = this._facaed.GetProxy(ProxyPVEStrList.EXCHANGE_PROXY) as ExchangeProxy;
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._AuctionViewCtrl = new AuctionViewCtrl ( ViewNameLib.View_Auction , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._AuctionViewCtrl );//註冊溶解所ViewCtrl
			
			this._SellViewCtrl = new SellViewCtrl ( ViewNameLib.View_Sell , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._SellViewCtrl );//註冊溶解所ViewCtrl
			
			this._AuctionViewCtrl.AddElement(this._ComponentClasses, this._SharedComponentClasses);
			
			this._SellViewCtrl.AddElement(this._ComponentClasses, this._SharedComponentClasses);
		}
		
		private function GetGoodsData(_GoodsData:Array, _ValueMax:int = 0, _CtrlStr:String = "Buy"):void 
		{
			var _GoodsDataLength:int = _GoodsData.length;
			var _ItemDisplay:Vector.<ItemDisplay> = new Vector.<ItemDisplay>;
			for (var i:int = 0; i < _GoodsDataLength; i++) 
			{
				_ItemDisplay.push(this._ItemDisplayProxy.GetItemDisplayExpress(_GoodsData[i]));
			}
			if (_CtrlStr == "Buy") this._AuctionViewCtrl.AddGoodsData(_ItemDisplay, _ValueMax, this._CtrlPageNum);
			if (_CtrlStr == "Sell") this._AuctionViewCtrl.CurrentSellData(_ItemDisplay);
			if (_CtrlStr == "PlayerSell") this._SellViewCtrl.AddSellGoodsData(_ItemDisplay);
		}
		
		override public function GetListRegisterCommands():Array {
			return [UICmdStrLib.Init_AuctionCatch,
					this._SharedKey,
					UICmdStrLib.SetSearch,
					UICmdStrLib.StartSearch,
					UICmdStrLib.ReSet,
					UICmdStrLib.CtrlPage,
					UICmdStrLib.GetPlayerSellList,
					UICmdStrLib.GetPlayerSellGoods,
					UICmdStrLib.PlayerSellGoods,
					UICmdStrLib.SellGoods,
					UICmdStrLib.BuyGoods,
					UICmdStrLib.Sort,
					UICmdStrLib.RemoveALL,
					UICmdStrLib.RemoveSell,
					ProxyPVEStrList.EXCHANGE_SEARCH_READY,
					ProxyPVEStrList.EXCHANGE_SELL_LISTREDAY,
					ProxyPVEStrList.EXCHANGE_BUY_SUCCESS,
					ProxyPVEStrList.EXCHANGE_ERROR,
					ProxyPVEStrList.TIP_CLOSESYS
					];
		}
		
	}
}