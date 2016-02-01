package MVCprojectOL.ModelOL.Exchange.sellCenter
{
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.PackageSys.Package;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.Stone.StoneDataCenter;
	import MVCprojectOL.ModelOL.Vo.ExchangeGoods;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author ...eric huang--
	 * 
	 */
	public class ExchangeSell  
	{
		private var _playerSellListe:Array;
		
		private var _notifyFunction:Function;
		public function ExchangeSell(_sendFun:Function) 
		{
			this._notifyFunction = _sendFun;
			//this._playerSellListe = [];
		}
		
		
		//--取得玩家可以掛賣的商品----
		public function GetPlayerCanSellGoods(_type:String=PlaySystemStrLab.Package_Monster):Array 
		{
			//GetSingleSell
			var _returnAry:Array;
			if (_type==PlaySystemStrLab.Package_Monster) {
				_returnAry = PlayerMonsterDataCenter.GetMonsterData().GetSellMonste();
				} else {
				_returnAry=Package.GetPackag().GetSingleSell(_type);
			}
			
			return _returnAry;
		}
		
		//---取得該玩家的掛賣清單
		public function get playerSellListe():Array 
		{
			return _playerSellListe;
		}
		//---設定玩家的掛賣清單
		public function set playerSellListe(value:Array):void 
		{
			_playerSellListe = value;
			this._notifyFunction(ProxyPVEStrList.EXCHANGE_SELL_LISTREDAY,this._playerSellListe);
		}
		
		
		public function SellSuccess(_vo:ExchangeGoods):void 
		{
			if (this._playerSellListe != null) this._playerSellListe.push(_vo);
			if (_vo._type==4) {
				//---刪除怪獸
				MonsterServerWrite.GetMonsterServerWrite().RemoveMonster(_vo._originGuid);
			  }else{
				//---刪除裝被-
				if (_vo._type>0) {
					//RemoveEquipment
					EquipmentDataCenter.GetEquipment().RemoveEquipment(_vo._originGruopGuid,_vo._originGuid,_vo._type-1);
				}else{
				 //--刪除石頭
					StoneDataCenter.GetStoneDataControl().RemoveStone(_vo._originGuid);
				}
				
			}
			//---送出事件(更新掛賣清單)
			this._notifyFunction(ProxyPVEStrList.EXCHANGE_SELL_LISTREDAY,this._playerSellListe);
			
		}
		
		//---掛賣商品(先暫時改變商品狀態)
		public function ChangeSellGoodsStatus(_type:String,_guid:String,_groupGuid:String=""):void 
		{
		    //---monster>RegisterUseMonster(改變商品狀態<怪獸>(脫裝))
			if (_type==PlaySystemStrLab.Package_Monster) {
				MonsterServerWrite.GetMonsterServerWrite().RegisterUseMonster(_guid, ServerTimework.GetInstance().ServerTime,5);	
				} else {
				var _goodsType:int = this.getsingleType(_type);
				if (_goodsType>=0) {
					//---裝備類
					EquipmentDataCenter.GetEquipment().ChangeUseing(_groupGuid, _guid, _goodsType, 4);
					} else {
					//-----stone---
					StoneDataCenter.GetStoneDataControl().ChangeStoneType(_guid,2);
				}	
				
			}
			
		}
		
		
		
		private function getsingleType(_str:String):int 
		{
			var _type:int = -1;
			if (_str == PlaySystemStrLab.Package_Weapon)_type = 0;
			if (_str == PlaySystemStrLab.Package_Shield)_type = 1;
			if (_str == PlaySystemStrLab.Package_Accessories)_type = 2;
			//if (_str == PlaySystemStrLab.Package_Source)_type = -1;
			if (_str == PlaySystemStrLab.Package_Stone)_type = -2;
			return _type;
		}
		
		
		
	}
	
}