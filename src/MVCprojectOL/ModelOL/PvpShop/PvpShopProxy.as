package MVCprojectOL.ModelOL.PvpShop
{
	import MVCprojectOL.ModelOL.Vo.Get.Get_PvpGoods;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpGoodsInvoice;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpShopInit;
	import MVCprojectOL.ModelOL.Vo.Set.Set_PvpBuyingGoods;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class PvpShopProxy extends ProxY
	{
		
		private static var _pvpShop:PvpShopProxy;
		private var _cashier:PvpShopCashier;
		
		public function PvpShopProxy(name:String):void 
		{
			super(name, this);
			if (PvpShopProxy._pvpShop != null) throw new Error("PvpShop can't be constructed");
			
			PvpShopProxy._pvpShop = this;
			this._cashier = new PvpShopCashier();
			EventExpress.AddEventRequest(NetEvent.NetResult, this.ConnectBack, this);
		}
		
		public static function GetInstance():PvpShopProxy
		{
			if (PvpShopProxy._pvpShop == null) PvpShopProxy._pvpShop = new PvpShopProxy(ArchivesStr.PVP_SHOP_SYSTEM);
			return PvpShopProxy._pvpShop;
		}
		
		//每次開啟UI都會取得最新名次資料 首次才會領取商品資料
		public function GetGoods():void 
		{
			this.callServer(new Get_PvpGoods(this._cashier.DataReady ? false : true));
		}
		
		private function dataReadyNotify():void 
		{
			this.callClient(ArchivesStr.PVP_SHOP_READY, this._cashier.GetAllGoods() );
		}
		
		private function callClient(type:String,thing:Object=null):void 
		{
			this.SendNotify(type, thing);
		}
		
		private function callServer(VO:Object):void
		{
			AmfConnector.GetInstance().VoCallGroup(VO, true);
		}
		
		private function ConnectBack(e:EventExpressPackage):void
		{
			
			var content:Object = NetResultPack(e.Content)._result;
			if (content == null ) {
				MessageTool.InputMessageKey(001);//SERVER回傳資料為空
				return;
			}
			
			switch (e.Status)
			{
				case "PvpShopInit" ://初始取得商品VO資料 ( Get_PvpGoods )
					this._cashier.CheckOverGoods(content as PvpShopInit);
					this.dataReadyNotify();
					//PvpShopProxy.GetInstance().CheckBuying("MAL00003");
				  //PvpShopProxy.GetInstance().DoBuying("MAL00003");
					//this.GetGoods();
				break;
				case "PvpGoodsInvoice" ://確認購買 SERVER回傳交易資料 ( Set_PvpBuyingGoods )
					this._cashier.DoneBuying(content as PvpGoodsInvoice);
					this.callClient(ArchivesStr.PVP_SHOP_DEAL , PvpGoodsInvoice(content)._dealResult);//通知交易完成已扣款 可以更新積分值顯示
				break;
			}
			
		}
		
		//點選時先檢查是否達可購買條件
		public function CheckBuying(goodsGuid:String):int
		{
			return this._cashier.CheckBuying(goodsGuid);
		}
		
		//確認購買(UI點選後要鎖按鈕 , 快速操作購買下不可擋購買回資料後才開)
		public function DoBuying(goodsGuid:String):void 
		{
			//this._cashier.DoBuying(goodsGuid);
			this.callServer(new Set_PvpBuyingGoods(goodsGuid));
		}
		
		
		
		
		
	}
	
}