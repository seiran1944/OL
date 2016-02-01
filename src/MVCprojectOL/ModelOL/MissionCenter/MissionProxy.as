package MVCprojectOL.ModelOL.MissionCenter
{
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MissionCalculateBase;
	import MVCprojectOL.ModelOL.MissionCenter.MissionData.MissionDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ModelOL.Stone.StoneDataCenter;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.Vo.Get.Get_MissionReward;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionComplete;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionRewardResponder;
	import MVCprojectOL.ModelOL.Vo.PlayerEquipment;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	import MVCprojectOL.ModelOL.Vo.PlayerSource;
	import MVCprojectOL.ModelOL.Vo.PlayerStone;
	//import MVCprojectOL.ModelOL.MissionCenter.MissionData.MissionList;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Mission;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Mission_Init;
	import MVCprojectOL.ModelOL.Vo.MissionVO.Mission;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MissionProxy extends ProxY 
	{
		
		private var _netConnect:AmfConnector;
		private var _missionData:MissionDataCenter;
		
		//private var _missionCalculate:
		
		public function MissionProxy()
		{
			super(ProxyPVEStrList.MISSION_PROXY);
		}
		
		
		override public function onRegisteredProxy():void 
		{
		    //this._Evolution = EvolutionDataCenter.GetInstance(this.SendNotify,this.ConnectVOCall);
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler, this );
			
			this._missionData = new MissionDataCenter(this.SendNotify,this.CallServer);
			
			this._netConnect = AmfConnector.GetInstance();
			this.CallServer(ProxyPVEStrList.MISSION_CALL_INIT);
			TimeLineProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.TIMELINE_PROXY)).missionCalculateFunction=this.CalculateMisison;
			
			//this.SendNotify(ProxyPVEStrList.MonsterEvolution_ProxyReady);
			
		}
		
		private function CallServer(_str:String,...args):void 
		{
			switch(_str) {
				//--init遊戲任務系統(只會做一次)
			case ProxyPVEStrList.MISSION_CALL_INIT:
				this._netConnect.VoCall(new Get_Mission_Init());
			break;
			
			//----取得任務
		    case ProxyPVEStrList.MISSION_CALL_GET_MISSION:
			this._netConnect.VoCall(new Get_Mission(args[0]));
			break;
			//---領取獎勵
			
		    case ProxyPVEStrList.MISSION_CALL_REWARD:
			 this._netConnect.VoCall(new Get_MissionReward(args[0]));  
			break;
			
			
			
			
			}
			
			
		}
		
		//---serverResponder
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			switch(_Result.Status) {
			   
				case "Get_Mission_Init":
					//---沒有任務的注況之下回[]
					//var _ary:Array = _netResultPack._result as Array;
					//if (_ary.length > 0) this._missionData.AddMission(_ary);
					var _ary:Array = _netResultPack._result as Array; 
					if (_ary.length > 0) this._missionData.AddInitMission(_ary);
				break;	
				
			   case "Get_Mission":
				var _aryA:Array = _netResultPack._result as Array; 
				if (_aryA.length > 0) this._missionData.AddMission(_aryA);
				break;
				
				//---取得任務獎勵品
			    case "Get_MissionReward":
				//var _aryB:Array= _netResultPack._result as Array;
				var _rewardResponder:MissionRewardResponder=_netResultPack._result as MissionRewardResponder;
				if (_rewardResponder._aryMissionBackReward.length > 0) {
				    var _len:int = _rewardResponder._aryMissionBackReward.length;
					for (var i:int = 0; i < _len;i++ ) {
						//---這邊要重新定義一下(金鑽的type)
						//---PS--soul..尚未定義
						//--wood---
						if (_rewardResponder._aryMissionBackReward[i]._type <=4)UserSourceCenter.GetUserSourceCenter().AddSource([_rewardResponder._aryMissionBackReward[i]._reward as PlayerSource]);
						//---equ--
						if (_rewardResponder._aryMissionBackReward[i]._type == 5) EquipmentDataCenter.GetEquipment().AddEquipment([_rewardResponder._aryMissionBackReward[i]._reward as PlayerEquipment]);
						//---道具--
						//if (_ary[i]._type == 6)
						//--monster--
						if (_rewardResponder._aryMissionBackReward[i]._type == 7) MonsterServerWrite.GetMonsterServerWrite().AddVoMonster([_rewardResponder._aryMissionBackReward[i]._reward as PlayerMonster]);
						//---帳號幣
						//if (_rewardResponder._aryMissionBackReward[i]._type == 8) MonsterServerWrite.GetMonsterServerWrite().AddVoMonster([_rewardResponder._aryMissionBackReward[i]._reward as PlayerMonster]);
						//---魔晶石
						if (_rewardResponder._aryMissionBackReward[i]._type == 9) StoneDataCenter.GetStoneDataControl().AddVoStone([_rewardResponder._aryMissionBackReward[i]._reward as PlayerStone]);
						
					}
					
					
					
				}
				this._missionData.AddMission(_rewardResponder._aryMissionStatus);
				
				break;
			}
			
			
			
			
		}
		
		//---取得任務列表---
		
		public function GetMission():Vector.<Mission> 
		{
			return this._missionData.GetMissionList();   
		}
		
		//---取得獎勵品
		public function GetMissionReward(_missionID:String):void 
		{
			if (this._missionData.CheckGetReward(_missionID)) {
			   	
				this.CallServer(ProxyPVEStrList.MISSION_CALL_REWARD,_missionID);	
			}else {
			  //---條件錯誤(查詢不到此任務~或是任務不在可領取的狀態下)	
				
			}
			
		}
		
		public function AddMission(_ary:Array):void 
		{
			this._missionData.AddMission(_ary);
		}
		
		/*
	    public function GetSingleMission(_guid:String):Mission 
		{
			return this._missionData.GetSingleMission(_guid);
		}*/
		
		//---計算任務條件/見算前製條件
		/*
		public function CalculateMisison(_typeStr:String):void 
		{
			
		}*/
		//---計算任務條件/見算前製條件
		public function CalculateMisison(_target:MissionCalculateBase):void 
		{
			this._missionData.Calculate(_target);
		}
		
		//---取得任務的計算動做清單-*-
		public function GetVoMotation():Array 
		{
			return this._missionData.GetVoMotation();
		}
		
		public function GetMissionCompleteWall():Array 
		{
			return this._missionData.GetMissionCompleteWall();
		}
		
		public function SetMissionCompleteWall(_ary:Array):void 
		{
			this._missionData.SetMissionCompleteWall(_ary);
		}
		
		
	}
	
}