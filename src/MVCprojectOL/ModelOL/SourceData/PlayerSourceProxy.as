package MVCprojectOL.ModelOL.SourceData
{
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerSource;
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
	public class  PlayerSourceProxy extends ProxY
	{
		
		
		private var _UserSourceCenter:UserSourceCenter;
			private var _netConnect:AmfConnector; 
		private var _aryVoClall:Array;
		public function PlayerSourceProxy() 
		{
			super(ProxyPVEStrList.SOURCE_PROXY,this);
		}
		
		//1.大廳（魔法陣）, 2.巢穴 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室;
		override public function onRegisteredProxy():void 
		{
			
			//---掛監聽EventExpress
			
			this._UserSourceCenter = UserSourceCenter.GetUserSourceCenter(this.SendNotifyHandler);
			//---取得建築物的GUID----
			//var _buildGuid:String=BuildingProxy.GetInstance().GetBuildingGuid(6);
			//this._AlchemyDataCenter.SetBuild(_buildGuid,6);
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler,this );
			this._netConnect = AmfConnector.GetInstance();
			//----需要再擴增
			this._aryVoClall = [Get_PlayerSource];
			this.ConnectVOCall(ProxyPVEStrList.SOURCE_Get);
			
			//this.SendNotifyHandler(ProxyPVEStrList.STONE_PROXYReady);
			
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
				case "PlayerSource":
				var _ary:Array = _netResultPack._result as Array;
				//if(_ary.length>0)
				this._UserSourceCenter.AddSource(_ary);   
				break;	
			}
		}
		
		//----連線(持續擴增)
		public function ConnectVOCall(_type:String):void 
		{
			var _class:Class;
			
			switch(_type) {
				
				//---取得玩家所有的素材
				case ProxyPVEStrList.SOURCE_Get:	
					
					_class = this._aryVoClall[0];
					this._netConnect.VoCall(new _class);
					//this._netConnect.ConnectMode = "Manual";
					//this._netConnect.VoCall(new Get_PlayerMonster());
					//this._netConnect.StartQueue();
				break;
				
				
				
			}
		}
		
		//---removeSingleAllSource---
		public function RemoveSingleAllSource(_id:String):void 
		{
			this._UserSourceCenter.RemoveSingleAllSource(_id);
		}
		
		public function GetSourceCall():void 
		{
			this.ConnectVOCall(ProxyPVEStrList.SOURCE_Get);
		}
		
	}
	
}