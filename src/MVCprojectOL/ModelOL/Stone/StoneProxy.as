package MVCprojectOL.ModelOL.Stone
{
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerStone;
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
	public class  StoneProxy extends ProxY
	{
		private var _stoneDataCenter:StoneDataCenter
		private var _netConnect:AmfConnector; 
		private var _aryVoClall:Array;
		public function StoneProxy() 
		{
			super(ProxyPVEStrList.STONE_PROXY,this);
		}
		
		
		
		override public function onRegisteredProxy():void 
		{
			//trace("Monster_RegisteredProxy");
			//this._monsterdataCenter = PlayerMonsterDataCenter.GetMonsterData(this.SendNotifyHandler);
			//---掛監聽EventExpress
			
			this._stoneDataCenter = StoneDataCenter.GetStoneDataControl(this.SendNotifyHandler);
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler ,this );
			this._netConnect = AmfConnector.GetInstance();
			//----需要再擴增
			this._aryVoClall = [Get_PlayerStone];
			this.ConnectVOCall(ProxyPVEStrList.STONE_GETCALL);
			
			//this.SendNotifyHandler(ProxyPVEStrList.STONE_PROXYReady);
			
		}
		
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//---switch case-------
			switch(_Result.Status) {
				case "PlayerStone":
				 this.AddStone(_netResultPack._result as Array);	
				break;	
			}
		}
		
		//----連線(持續擴增)
		public function ConnectVOCall(_type:String):void 
		{
			var _class:Class;
			
			switch(_type) {
				
				case ProxyPVEStrList.STONE_GETCALL:	
					
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
		
		//---添加VO_____以ary包住的stone VO---
		public function AddStone(_ary:Array):void 
		{
			this._stoneDataCenter.AddVoStone(_ary);
		}
		
		//---取得全部的stone---
		public function GetStoneList():Array 
		{
			return this._stoneDataCenter.GetAllStone();
		}
		
		//---取單一的stone值---
		public function GetSingleStone(_index:String):Object 
		{
			return this._stoneDataCenter.GetStone(_index);
		}
		
		public function RemoveStone(_index:String):void 
		{
			this._stoneDataCenter.RemoveStone(_index);
		}
		
		public function ChangeType(_key:String,_status:int):void 
		{
			this._stoneDataCenter.ChangeStoneType(_key,_status);
		}
		
		
	}
	
}