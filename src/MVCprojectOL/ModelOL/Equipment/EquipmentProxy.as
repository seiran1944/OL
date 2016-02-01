package MVCprojectOL.ModelOL.Equipment
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerEquipment;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ProxyPVEStrList;

	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class EquipmentProxy extends ProxY
	{
		
		private var _EquipmentDataCenter:EquipmentDataCenter;
		private var _netConnect:AmfConnector; 
		private var _aryVoClall:Array;
		public function EquipmentProxy() 
		{
			super(ProxyPVEStrList.EQUIPMENT_PROXY,this);
		}
		
		
		override public function onRegisteredProxy():void 
		{
			
			//---掛監聽EventExpress
			this._EquipmentDataCenter = EquipmentDataCenter.GetEquipment(this.SendNotifyHandler);
			
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler ,this );
			this._netConnect = AmfConnector.GetInstance();
			//----需要再擴增
			this._aryVoClall = [Get_PlayerEquipment];
			this.ConnectVOCall(ProxyPVEStrList.EQUIPMENT_Get);
			
			//this.SendNotifyHandler(ProxyPVEStrList.STONE_PROXYReady);
			
		}
		
		//----連線(持續擴增)
		public function ConnectVOCall(_type:String):void 
		{
			var _class:Class;
			
			switch(_type) {
				
				//---取得配方表
				case ProxyPVEStrList.EQUIPMENT_Get:	
					
					_class = this._aryVoClall[0];
					this._netConnect.VoCall(new _class);
					//this._netConnect.ConnectMode = "Manual";
					//this._netConnect.VoCall(new Get_PlayerMonster());
					//this._netConnect.StartQueue();
				break;
			}
		}
		
		
		//----sendNotify
		private function SendNotifyHandler(_str:String,_obj:Object=null):void 
		{
			this.SendNotify(_str,_obj);
		}
		
		
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//---switch case-------
			switch(_Result.Status) {
				case "PlayerEquipment":
				// this.AddStone(_netResultPack._result as Array);	
				var _ary:Array = _netResultPack._result as Array;
				//if (_ary.length > 0)
				this._EquipmentDataCenter.AddEquipment(_netResultPack._result as Array);   
				break;	
			}
		}
		
		
		public function AddEquipment(_ary:Array):void 
		{
		   if (_ary != null && _ary.length > 0) this._EquipmentDataCenter.AddEquipment(_ary);	
		}
		
		//------Alchemy(扣除鍊金)
		public function UseAlchemy(_type:int,_groupID:String):String 
		{
			return this._EquipmentDataCenter.UseAlchemy(_type,_groupID);
		}
		
		//-check使用者在初始狀態是否有足夠的鍊金素材類
		public function CheckSourceReady(_groupID:String,_type:int,_number:int):Boolean 
		{
			return this._EquipmentDataCenter.CheckSourceReady(_groupID,_type,_number);
		}
		
		
		//--取得該品項裝備數量
		public function GetSingleEquSource(_group:String,_type:int):int 
		{
		  return this._EquipmentDataCenter.GetSingleEquSource(_group,_type);
		}
		
		
		//---刪除裝備
		public function RemoveEquipment(_group:String,_guid:String,_dictype:int):void 
		{
		  this._EquipmentDataCenter.RemoveEquipment(_group,_guid,_dictype);
		}
		
		//---改變狀態---//----使用狀態-0:刪除, 1:閒置, 2:溶解 3出戰 4掛賣---
		public function ChangeUseing(_group:String,_guid:String,_type:int,_status:int):void 
		{
			this._EquipmentDataCenter.ChangeUseing(_group,_guid,_type,_status);	
		}
		
		
		//----取得所有的裝備(儲藏室專用)---
		public function GetEquAllPackage():Dictionary 
		{
			return this._EquipmentDataCenter.GetEquAllPackage();
		}
		
		//---------鑲嵌靈魂石(預覽)----
		/*
		public function GetPreViewEqu(_index:String,_type:int,_soulindex:String):Object 
		{
			return this._EquipmentDataCenter.GetPreViewEqu(_index,_type,_soulindex);
		}
		*/
		//---改變禁錮力(增加/衰減)-----
		public function SetDetention(_group:String,_index:String,_type:int,_vaule:int):void 
		{
			this._EquipmentDataCenter.SetDetention(_group,_index,_type,_vaule);
		}
		
		//------鑲嵌靈魂
		public function AddSoul(_guild:String,_index:String,_type:int,_soulKey:String):void 
		{
			//this._EquipmentDataCenter.AddSoul(_guild,_index,_type,_soulKey);
		}
		
		//-----------商成道具使用--回復禁錮力---<_vaule=-99--立即回滿>
		public function UseStore(_group:String,_type:int,_guid:String,_vaule:int):void 
		{
			this._EquipmentDataCenter.UseStore(_group,_type,_guid,_vaule);
		}
		
		
	}
	
}