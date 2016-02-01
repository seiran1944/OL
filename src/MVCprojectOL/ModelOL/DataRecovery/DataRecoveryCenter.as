package MVCprojectOL.ModelOL.DataRecovery
{
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.MissionCenter.MissionProxy;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Mission;
	import MVCprojectOL.ModelOL.Vo.Get.Get_MonsterRecovery;
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerBasicValue;
	//import MVCprojectOL.ModelOL.Vo.Get.Get_PalyerBasicVaule;
	import MVCprojectOL.ModelOL.Vo.PlayerBasicValue;
	//import MVCprojectOL.ModelOL.Vo.PlayerBasicVaule;
	import MVCprojectOL.ModelOL.Vo.ReturnMonster;
	import MVCprojectOL.ModelOL.VoGroupCallCenter;
	import MVCprojectOL.ViewOL.MainView.MainViewSpr;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Timers.TimeDriver;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 * 2013/03/21----
	 */
	public class DataRecoveryCenter extends ProxY
	{
		
		private static var _DataRecoveryCenter:DataRecoveryCenter;
		
		private var _netConnect:AmfConnector;
		private var _monsterServerWrite:MonsterServerWrite;
		private var _checkGlobalTimes:uint = 0;
		//---5分鐘更新一次----
		private const _serverReSetTimes:uint = 300;
		private var _nextResetTimes:uint = 0;
		
		private var _aryVoGroupCall:Array;
		private var _voCallLen:int = 0;
		
		
		public function DataRecoveryCenter() 
		{
			super(ProxyPVEStrList.Data_RecoveryProxy,this);
		}
		
		public static function GetDataRecoveryCenter():DataRecoveryCenter 
	    {
		  //var _return:MonsterRecoveryProxy=
		  return DataRecoveryCenter._DataRecoveryCenter = (DataRecoveryCenter._DataRecoveryCenter ==null)?new DataRecoveryCenter():DataRecoveryCenter._DataRecoveryCenter;  
	    }
		
		override public function onRegisteredProxy():void 
	    {
	    
		//----setMonster------
		this._monsterServerWrite = MonsterServerWrite.GetMonsterServerWrite();  
		EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler,this );
		this._netConnect = AmfConnector.GetInstance();
		TimeDriver.AddDrive(this._serverReSetTimes*1000,0,this.checkRecoveryHandler);
		//---init serverTimes-----
		this.ResetGlobalTimes();
	    
		
	    }
		
		//---增加要送出的VO(非更新不可的)--需要可以擴增下去
		private function CreatVoGroupHandler():void 
		{
			this._aryVoGroupCall = [
			Get_MonsterRecovery,
			//Get_PalyerBasicVaule
			Get_PlayerBasicValue
			];
			this._voCallLen = this._aryVoGroupCall.length;
		}
		
		
		
		public function ResetGlobalTimes():void 
		{
			this._checkGlobalTimes = ServerTimework.GetInstance().ServerTime;
			this._nextResetTimes = this._checkGlobalTimes + this._serverReSetTimes;
		}
		
		private function checkRecoveryHandler():void 
		{
			
			var _checkTime:uint=ServerTimework.GetInstance().ServerTime;
			if (this._checkGlobalTimes-_checkTime>=this._nextResetTimes) { 
				 //this._netConnect.VoCallGroup(new Get_MonsterRecovery());
				 var _class:Class;
				 for (var i:int = 0; i < this._voCallLen;i++ ) {
					_class = this._aryVoGroupCall[i]; 
					this._netConnect.VoCallGroup(new _class);
				   }
				 //---重設下次自動更新時間  
				 TimeDriver.ChangeDrive(this.checkRecoveryHandler,this._serverReSetTimes*1000);  
				 VoGroupCallCenter.GetVoGroupCallCenter().VoGroupCall();
				  } else {
				
				return;
			}
			
		}
		
		
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			
			switch(_Result.Status) {
			  case "MonsterRecovery":
				var _ary:Array = (_Result.Content as NetResultPack)._result as Array;
				if (_ary!=null && _ary.length>0) {
					var _len:int = _ary.length;
					for (var i:int = 0; i < _len;i++ ) {
						this._monsterServerWrite.WriteBack(ReturnMonster(_ary[i]));
						
					}	
				}
			   break;
		       //---更新玩家的基本資料>金鑽 魂 木 皮 石
			   case "Get_PalyerBasicVaule":
			    var _playerData:PlayerBasicVaule =  (_Result.Content as NetResultPack)._result as PlayerBasicValue;
				if (_playerData!=null) {
				  PlayerDataCenter.SetPlayerDataVaule(_playerData);	
				  //----04/11---要再補重刷數值的動畫驅動	
					
				}
				
				
			   
			   break;
				
			}
			
			this.ResetGlobalTimes();
		}
		
		public function AddVoGroup(_class:Object):void 
		{
			if (_class is MainViewSpr) {
				this._netConnect.VoCallGroup(new Get_MonsterRecovery());
				var _aryMission:Array=MissionProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.MISSION_PROXY)).GetVoMotation();
				//if(_aryMission.length>0)this._netConnect.VoCallGroup(new Get_Mission(_aryMission));
				//this._netConnect.VoCall(new Get_MonsterRecovery());
			}
		 
		}
		
		
		
		
		
		
		
	}
	
}