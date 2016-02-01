package MVCprojectOL.ModelOL.MonsterRecovery 
{
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.Vo.Get.Get_MonsterRecovery;
	import MVCprojectOL.ModelOL.Vo.ReturnMonster;
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
	 */
	public class MonsterRecoveryProxy extends ProxY
	{
	  
	  private var _netConnect:AmfConnector;
	  private var _aryVoClall:Array;	
	  private var _monsterServerWrite:MonsterServerWrite;
	  
	  private static var _MonsterRecoveryProxy:MonsterRecoveryProxy;
	  
	  
	  
      public function MonsterRecoveryProxy() 
	  {
	    
		  //if (PlayerMonsterDataCenter._MonsterRecoveryProxy != null)throw Error("[_MonsterRecoveryProxy] build illegal!!!please,use [Singleton]");
		  super(ProxyPVEStrList.Monster_RecoveryProxy,this);
	  }
	  
	  
	  public static function GetMonsterRecovery():MonsterRecoveryProxy 
	  {
		  //var _return:MonsterRecoveryProxy=
		  return MonsterRecoveryProxy._MonsterRecoveryProxy = (MonsterRecoveryProxy._MonsterRecoveryProxy==null)?new MonsterRecoveryProxy():MonsterRecoveryProxy._MonsterRecoveryProxy;  
	  }
	  
	  
	  override public function onRegisteredProxy():void 
	  {
	    
		//----setMonster------
		//this._monsterServerWrite = MonsterServerWrite.GetMonsterServerWrite();  
		EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler,this );
		this._netConnect = AmfConnector.GetInstance();
		//var _hpFunction:Function = MonsterServerWrite.GetMonsterServerWrite().GetRegistTimeFun("HP");
		//var _EngFunction:Function = MonsterServerWrite.GetMonsterServerWrite().GetRegistTimeFun("ENG");
		//TimeDriver.AddDrive(PlayerDataCenter.GetMonsterHPTimes() * 1000,0,_hpFunction);
		//TimeDriver.AddDrive(PlayerDataCenter.GetMonsterFatigueTimes() * 1000,0, _EngFunction);
	  }
	  
	  
	  
	  private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			if (_Result.Status=="MonsterRecovery") {
				var _ary:Array = _netResultPack._result as Array;
				if (_ary!=null && _ary.length>0) {
					var _len:int = _ary.length;
					for (var i:int = 0; i < _len;i++ ) {
						this._monsterServerWrite.WriteBack(ReturnMonster(_ary[i]));
						
					}	
				}
				
			}
			
		}
	  
	    
		public function AddVoGroup(_class:Object):void 
		{
			if (_class is MainViewSpr) {
				this._netConnect.VoCallGroup(new Get_MonsterRecovery());
				//this._netConnect.VoCall(new Get_MonsterRecovery());
			}
		 
		}
		
		
		
	}
	
}