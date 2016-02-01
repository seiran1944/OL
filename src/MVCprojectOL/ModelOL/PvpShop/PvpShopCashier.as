package MVCprojectOL.ModelOL.PvpShop
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ModelOL.Vo.PlayerEquipment;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpGoods;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpGoodsInvoice;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpShopInit;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class PvpShopCashier 
	{
		
		private var _dataReady:Boolean = false;		//是否已經有資料
		private var _currentUserPlace:int;				//當前玩家PVP名次
		private var _dicGoods:Dictionary;
		private var _aryGoods:Array;
		
		public function PvpShopCashier():void 
		{
			this._dicGoods = new Dictionary(true);
		}
		
		//儲存 製表 排序
		public function CheckOverGoods(shopInit:PvpShopInit):void 
		{
			this._currentUserPlace = shopInit._pvpLevel;
			
			var aryGoods:Array = shopInit._aryGoods;
			if (aryGoods == null) return ;
			this._aryGoods = aryGoods;
			var leng:int = aryGoods.length;
			for (var i:int = 0; i < leng; i++) 
			{
				this._dicGoods[aryGoods[i]._guid] = aryGoods[i];
			}
			this._aryGoods.sortOn("_sortPriority", Array.NUMERIC);
			
			this._dataReady = true;
		}
		
		public function GetAllGoods():Object 
		{
			var objReturn:Object = { _aryAll : [] , _aryHonor : [] , _aryDiamond : [] };
			var leng:int = this._aryGoods.length;
			var cloneGoods:PvpGoods;
			
			for (var i:int = 0; i < leng; i++) 
			{
				cloneGoods = this.cloneGoods(this._aryGoods[i]);
				objReturn._aryAll.push(cloneGoods);
				objReturn[cloneGoods._moneyType == 1 ? "_aryDiamond" : "_aryHonor" ].push(cloneGoods);
			}
			
			
			return objReturn;
		}
		
		private function cloneGoods(source:PvpGoods):PvpGoods
		{
			var goods:PvpGoods = new PvpGoods();
			goods._amount = source._amount;
			goods._guid = source._guid;
			goods._info = source._info;
			goods._moneyType = source._moneyType;
			goods._price = source._price;
			goods._levelLimit = source._levelLimit;
			goods._sortPriority = source._sortPriority;
			goods._title = source._title;
			goods._goods = this.getItemDisplay(source._goods);//沒有Clone商品的VO 
			goods.CheckLocking(this._currentUserPlace);//寫入判斷是否可以點選
			return goods;
		}
		
		private function getItemDisplay(data:Object):ItemDisplay
		{
			return new ItemDisplay(data);
		}
		
		public function get DataReady():Boolean 
		{
			return this._dataReady;
		}
		
		
		//串接共同的貨幣消費檢查機制
		//RETURN >> -2 = 查無此商品資料 ,  -1 = 格子位置不足 ,  0 = 可以順利購買 ,  1 = 晶鑽不足 , 2 = 積分不足
		public function CheckBuying(guid:String):int
		{
			var goods:PvpGoods = guid in this._dicGoods ? this._dicGoods[guid] : null;
			var check:int = -2;
			if (goods) {
				check = this.CheckBuyingConditions(goods._goods, goods._moneyType, goods._price);
			}
			return check;
		}
		
		//購買完成 做CLIENT端資料更新
		//UI部分需要對錯誤碼做處理 (關閉UI效果)
		public function DoneBuying(invoice:PvpGoodsInvoice):void 
		{
			if (invoice._dealResult == 1) {
				var className:String = this.getSimpleClassName(invoice._dealGoods._goods);
				//20130610 扣款
				//0 = 積分 , 1 = 晶鑽 
				invoice._dealGoods._moneyType == 0 ? PlayerDataCenter.addHonor( -invoice._dealGoods._price) : PlayerDataCenter.addMoney( -invoice._dealGoods._price);
				
				switch (className)
				{
					case "PlayerEquipment":
						EquipmentDataCenter.GetEquipment().AddEquipment([invoice._dealGoods._goods]);
					break;
					case "PlayerSource":
						UserSourceCenter.GetUserSourceCenter().AddSource([invoice._dealGoods._goods]);
					break;
				}
			}
			
		}
		
		private function getSimpleClassName(voTarget:Object):String
		{
			var voName:String = getQualifiedClassName(voTarget);
			var index:int = voName.lastIndexOf(":") +1;
			voName = voName.substr(index , voName.length - index);
			return voName;
		}
		
		//stockType <<  Equipment =1 , Item = 2 , Source = 3 
		//moneyType <<  0 = 積分, 1 = 晶鑽
		//RETURN >> -1 = 格子位置不足 ,  0 = 可以順利購買 ,  1 = 晶鑽不足 , 2 = 積分不足
		public function CheckBuyingConditions(voTarget:Object,moneyType:int,price:int):int
		{
			var check:int = 0;
			var checkGridType:int = 0;
			var voName:String = this.getSimpleClassName(voTarget);
			
			//檢查格子數量//type 1=Source , 2=stone , 3=weapon , 4=shield , 5=accessories , 6=monster
			switch (voName) 
			{
				case "PlayerEquipment":
					//0=武器/1=防具/2=飾品
					checkGridType = PlayerEquipment(voTarget)._type + 3;
				break;
				case "PlayerSource":
					checkGridType = 1;
				break;
				case "PlayerStone":
					checkGridType = 2;
				break;
			}
			if (!BuildingProxy.GetInstance().CheckStockpile(checkGridType)) check = -1;
			
			//檢查貨幣數量
			switch (moneyType) 
			{
				case 0:
					if (PlayerDataCenter.PlayerHonor < price) check = 2;
				break;
				case 1:
					if (PlayerDataCenter.PlayerMony < price) check = 1;
				break;
			}
			
			return check;
		}
		
		
		
	}
	
}