package MVCprojectOL.ModelOL.TimeLine
{
	import flash.utils.getQualifiedClassName;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MissionCalculateBase;
	import MVCprojectOL.ModelOL.MissionCenter.MissionProxy;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.PvpSystem.PvpSystemProxy;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	//import MVCprojectOL.ModelOL.ShowSideSys.TipCreatCenter;
	import MVCprojectOL.ModelOL.SkillData.SkillDataCenter;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ModelOL.Stone.StoneDataCenter;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.Troop.TroopProxy;
	import MVCprojectOL.ModelOL.Vo.Building;
	import MVCprojectOL.ModelOL.Vo.BuildSchedule_Error;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerBuildschedule;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionEveryDay;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpDayVary;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpReward;
	import strLib.commandStr.WorldJourneyStrLib;
	//import MVCprojectOL.ModelOL.Vo.Get.Get_Buildschedule;
	//import MVCprojectOL.ModelOL.Vo.Get.Get_Buildscheduleres;
	import MVCprojectOL.ModelOL.Vo.ReturnMonster;
	import strLib.commandStr.PVECommands;
	//import MVCprojectOL.ModelOL.Vo.Get.Get_TimeLine;
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
	 * 統一時間排程控制
	 */
	public class  TimeLineProxy extends ProxY
	{
		private var _TimeLineObject:TimeLineObject;
		private var _netConnect:AmfConnector;
		private var _aryVoClal:Array;
		//private var _voGroupFunctio:Function;(建築物升級的[虛擬建築物]);
		private const BUILDING_TIMELINE:String = "buildingTimeline";
		//---探索CD----
		private const BUILDING_EXLORE:String = "explore";
		//---PVP用的建築物
		private const BUILDING_PVP:String = "pvp";
		//----任務用的建築物
		private const BUILDING_MISSION:String = "build_mission";
	    
		
		//---任務計算條件
		private var _missionCalculateFunction:Function;
		private var _missionCalculateBase:MissionCalculateBase;
		public function TimeLineProxy() 
		{
			
			super(ProxyPVEStrList.TIMELINE_PROXY,this);
			
		}
		
		public function set missionCalculateFunction(value:Function):void { _missionCalculateFunction = value };
		
		override public function onRegisteredProxy():void {
			this._TimeLineObject = TimeLineObject.GetTimeLineObject(this.SendNotifyHandler);
			EventExpress.AddEventRequest( NetEvent.NetResult ,this.SetNetResultHandler,this );
			this._netConnect = AmfConnector.GetInstance();
			//this._TimeLineObject.funVoGroup = this._netConnect.VoCallGroup;
			//----測試用---
			//this._TimeLineObject.funVoGroup = this._netConnect.VoCallGroup;
			this._TimeLineObject.amfConnect=AmfConnector.GetInstance();
			
			
			//----填入class---
			this._aryVoClal = [Get_PlayerBuildschedule];
			this.CallConnect(ProxyPVEStrList.TIMELINE_CALL);
		}
		
		override public function onRemovedProxy():void 
		{
			EventExpress.RevokeAddressRequest(this.SetNetResultHandler);
			this._TimeLineObject.Remove();
			this._TimeLineObject = null;
		}
		
         //--建築種類：1.大廳（魔法陣）, 2.巢穴, 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室9.進化室 10.PVP
		//---
		public function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack = _Result.Content as NetResultPack;
			//---switch/case---
			//--建築物類型1.大廳（魔法陣）, 2.巢穴 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室
			var _arySplice:Array = _Result.Status.split(":");
			var _checkStr:String = _arySplice[0].substr(0,_arySplice[0].length);
			var _deleteIndex:String = (_arySplice[1] != null)?_arySplice[1].substr(0, _arySplice[1].length):"null";
			var _strTarget:String;
			var _strProduce:String;
			/*
			if (_netResultPack._serverStatus=="503" || _netResultPack._serverStatus=="504") {
				//---錯誤--依照TYPE回去更改已經送初的狀態,並改回時間與 flag--- 
				trace("playerData_Error");
				var _strError:String = "";
				if (_netResultPack._serverStatus=="504") {
					var _schID:String = _netResultPack._replyDataType;
					_strError = "504_____" + _schID;
					this.SendNotify("ERROR_TRACER_COM", _strError);
				  }else if(_netResultPack._serverStatus=="503"){
					trace("serverback503___"+_netResultPack._result);
				}
				
			} else {
			*/	
					
			switch(_checkStr) {
				
				case "BuildSchedule_Error":
					//---排成錯誤(時間未完成)
					trace("BuildSchedule_Error>>");
					this._TimeLineObject.ReSetschedule(_netResultPack._result as BuildSchedule_Error);
					
				break;
				
				case "Buildschedule":
					trace("<----------------------------------------getTimeLineList");
 					var _ary:Array = _netResultPack._result as Array;
				
					if (_ary!=null) {
					  this._TimeLineObject.AddVoTimeLine(_ary);
					}
				   	
				break;
				
				//----排程回來的物品
			    case "3":
				 //---stone
				 //---delete 排程---build的guid......
				 var _buildStr:String = BuildingProxy.GetInstance().GetBuildingGuid(3);
				 //---把石頭塞回去----
				 var _aryStone:Array = _netResultPack._result as Array;
				 //---加入stone---
				 
				  _strTarget=PlayerMonsterDataCenter.GetMonsterData().GetMonsterName(_aryStone[0]._monsterID);
			      _strProduce=_aryStone[0]._showName;
				  
				 TimeLineObject.GetTimeLineObject().RemoveRealLine(_buildStr,_deleteIndex,3);
				 
				 StoneDataCenter.GetStoneDataControl().AddVoStone(_aryStone);
				
				
				 this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD,
				 new SendTips("TimeLineProxy", ProxyPVEStrList.TIP_COMPLETE,
				 _aryStone[0]._picItem,
				 _aryStone[0]._guid, 
				 3, 
				 4, 
				 _deleteIndex,
				 5,
				 {_key:"GLOBAL_TIP_COMPLETETIP01",_targetName:_strTarget,_produceName:_strProduce}
				 )
				 );
				 
				break;
				
			    case "4":
				  //--skill
				  var _buildSkill:String = BuildingProxy.GetInstance().GetBuildingGuid(4);
				 
				  var _monsterSkill:Array=_netResultPack._result as Array
				  if (_monsterSkill[0]._type==6) {
					   //--ReturnMonster
					   MonsterServerWrite.GetMonsterServerWrite().WriteBack(_monsterSkill[0] as ReturnMonster);
					   _strTarget=PlayerMonsterDataCenter.GetMonsterData().GetMonsterName(_monsterSkill[0]._guid);
			           _strProduce=SkillDataCenter.GetInstance().GetSingleNmae(_monsterSkill[0]._skillId);
					   
					   var _skillPic:String = SkillDataCenter.GetInstance().GetSingleIconKey(_monsterSkill[0]._skillId);
					   
					   //TimeLineObject.GetTimeLineObject().AddCompleteTips(new TimeCompleteInfo(_deleteIndex,_monsterSkill[0]._guid,_monsterSkill[0]._skillId));
					   
					   this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD,
				       new SendTips("TimeLineProxy", ProxyPVEStrList.TIP_COMPLETE,
					   _skillPic, 
					   _monsterSkill[0]._guid,
					   4,
					   2, 
					   _deleteIndex,
					   2,
					   {_key:"GLOBAL_TIP_COMPLETETIP03",_targetName:_strTarget,_produceName:_strProduce}
					   )
				       );
				   }
				    TimeLineObject.GetTimeLineObject().RemoveRealLine(_buildSkill,_deleteIndex,4);
				  
				//--AddSkill
				break;
				
			    case "6":
				 //----EQU
				    var _aryEqu:Array = _netResultPack._result as Array;
					var _buildEqu:String= BuildingProxy.GetInstance().GetBuildingGuid(6);
					var _equLen:int = _aryEqu.length;	
				    if (_equLen>0) {
						//for (var i:int = 0; i < _equLen;i++ ) {
					     var _alchemyAry:Array;
						 var _strEqu:String = (String(getQualifiedClassName(_aryEqu[0])).split("::")[1]).substr(6, 1);
						 
					     if (_strEqu=="E") {
							//----裝備---- 
							 EquipmentDataCenter.GetEquipment().AddEquipment([_aryEqu[0]]);
							 //TimeLineObject.GetTimeLineObject().RemoveRealLine(_buildEqu, _deleteIndex);
							 _alchemyAry = EquipmentDataCenter.GetEquipment().GetCompleteinfo(_aryEqu[0]._type, _aryEqu[0]._gruopGuid, _aryEqu[0]._guid);
							 //this._missionCalculateBase._target = _gruopGuid;
							 } else {
							 //--素材
							 UserSourceCenter.GetUserSourceCenter().AddSource([_aryEqu[0]]);
							 _alchemyAry = UserSourceCenter.GetUserSourceCenter().GetCompleteInfo(_aryEqu[0]._groupGuid);
							
						}
					    //_strTarget=PlayerMonsterDataCenter.GetMonsterData().GetMonsterName(_monsterSkill[0]._guid);
			            _strProduce=_aryEqu[0]._showName;
						
						TimeLineObject.GetTimeLineObject().RemoveRealLine(_buildEqu, _deleteIndex,6);
						
						this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD,
				         new SendTips("TimeLineProxy", ProxyPVEStrList.TIP_COMPLETE, 
						 _alchemyAry[0],
						 _alchemyAry[1],
						 _alchemyAry[2],
						 _alchemyAry[3], 
						 _deleteIndex,
						 _alchemyAry[4],
						 {_key:"GLOBAL_TIP_COMPLETETIP02",_targetName:"",_produceName:_strProduce}
						 )
				       );
						
					   // }
						
					}
					
				 
				break;
				
				//----建築物升級------
			    case "0":
				    var _build:Building = _netResultPack._result[0] as Building;
					//---直接把build塞回阿翔的資料串裡面
					//----PS---要自訂一個[建築物升級]的專屬guid(因為排程表是用建築物的guid來記錄的)
					TimeLineObject.GetTimeLineObject().RemoveRealLine(this.BUILDING_TIMELINE,_deleteIndex,0);
				    BuildingProxy.GetInstance().TimeLineUpgradeBack(_build);
					
					
				break;
				
				
			    case "7":
				 //---SOUL
				break;
				
				//---探索CD結束
			    case "-1":
				   var _explore:ExploreArea = _netResultPack._result as ExploreArea;
				   TimeLineObject.GetTimeLineObject().RemoveRealLine(this.BUILDING_EXLORE, _deleteIndex,-1);
				   if(_explore!=null)this.SendNotify(WorldJourneyStrLib.CoolDownReady,_explore);
				break;
				
				//----PVP_打輸CD
			    case "10":
				 //----server回甚麼?
				 TimeLineObject.GetTimeLineObject().RemoveRealLine(this.BUILDING_PVP, _deleteIndex,10); 
				 PvpSystemProxy.GetInstance().SetPvpFightable();
				 
				break;
				
				//---PVP每日獎勵CD
			    case "-2":
				
				var _pvpReward:PvpReward = _netResultPack._result as PvpReward;
				 if (_pvpReward!=null) {
					TimeLineObject.GetTimeLineObject().RemoveRealLine(this.BUILDING_PVP, _deleteIndex,10); 
					if (_pvpReward._buildschedule != null) {
					TimeLineObject.GetTimeLineObject().AddVoTimeLine([_pvpReward._buildschedule]);	
					_pvpReward._buildschedule = null;	
					}
					PvpSystemProxy.GetInstance().SetPvpReward(_pvpReward); 
				 }
				break;
				
				//---PVP戰鬥歸0(次數)
			    case "-3":
				
				var _pvpDayVary:PvpDayVary = _netResultPack._result as PvpDayVary;
				 if (_pvpDayVary!=null) {
					TimeLineObject.GetTimeLineObject().RemoveRealLine(this.BUILDING_PVP, _deleteIndex,10); 
					if (_pvpDayVary._buildschedule != null) {
					TimeLineObject.GetTimeLineObject().AddVoTimeLine([_pvpDayVary._buildschedule]);	
					_pvpDayVary._buildschedule = null;	
					}
					PvpSystemProxy.GetInstance().SetPvpDayVary(_pvpDayVary); 
				 }
				 
				break;
				
				
				//----每日任務CD
			    case "-4":
				
				var _mission:MissionEveryDay = _netResultPack._result as MissionEveryDay;
				TimeLineObject.GetTimeLineObject().RemoveRealLine(this.BUILDING_MISSION, _deleteIndex,-4);
				if(_mission._buildschedule!=null)TimeLineObject.GetTimeLineObject().AddVoTimeLine([_mission._buildschedule]);
				if (_mission._mission.length > 0) MissionProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.MISSION_PROXY)).AddMission(_mission._mission);	
				
				break;
				
			}
				
				
			//}
			
			
		}
		
		//----01/31暫時的
		/*
		private function creatReturnMonster(_obj:Object):ReturnMonster 
		{
			
			var _return:ReturnMonster;
			
			if (_obj!=null) {
				_return = new ReturnMonster();
				if(_obj._type!=null)_return._type=
				if(_obj._stoneId!=null)_return._type=
				if(_obj._skillId!=null)_return._type=
				if(_obj._aryEqu!=null)_return._type=
				if(_obj._EXP!=null)_return._type=
				if(_obj._ENG!=null)_return._type=
				if(_obj._useing!=null)_return._type=
				
				
				
			}
			
			
		}*/
		
		public function CallConnect(_type:String):void 
		{
			switch(_type) {
				case ProxyPVEStrList.TIMELINE_CALL:
					var _class:Class = this._aryVoClal[0];
					this._netConnect.VoCall(new _class);
				break;
				
				
				/*
			   case "testStone":
				//var _str:String = this._dicRealLine[i]._buildType + ":"+this._dicRealLine[i]._guid;
				//var _Get_Buildscheduleres:Get_Buildscheduleres = new Get_Buildscheduleres(this._dicRealLine[i]._guid, _str);
				this._netConnect.VoCall(new Get_Buildscheduleres("SCH135417619384147","3:BLD135400192937888",3));
			   break;
			   */
			}
			
		}
		
		
		private function SendNotifyHandler(_str:String,_obj:Object=null):void 
		{
			this.SendNotify(_str,_obj);
		}
		
		
		//----要再增加建築物識別碼
		//---(_buildType)0.建築物升級1.大廳（魔法陣）, 2.巢穴, 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室
		public function AddTimeLine(_build:String,_target:String,_starTime:int,_finishTime:int,_buildType:int,_type:String=""):void 
		{
			this._TimeLineObject.AddTimeLine(_build,_target,_starTime,_finishTime,_buildType,_type);
		}
		
		//----取得單一排程
		public function GetSingleLine(_build:String,_key:String):Object 
		{
			return this._TimeLineObject.GetSingleLine(_build,_key);
		}
		
		//---取得該棟建築物所有的排程
		public function GetAllLine(_build:String):Array 
		{
			return this._TimeLineObject.GetAllLine(_build);
			
		}
		
		//---快速完成-移除排程
		public function CleanLine(_build:String,_key:String):void 
		{
			this._TimeLineObject.CleanLine(_build,_key);
		}
		
		//---檢查該升級排程是否進行---
		public function CheckUpdataLine(_buildTarget:String):Boolean 
		{
			return this._TimeLineObject.CheckUpdataLine(this.BUILDING_TIMELINE,_buildTarget);
		}
		
		//----PVP改變排程
		public function PVPChaneLine():void 
		{
			
		}
		
		//---移除排程
		public function RemoveRealLine(_build:String,_key:String,_buildType:int):void 
		{
			this._TimeLineObject.RemoveRealLine(_build,_key,_buildType);
		}
		
		//---0510--探索---
		public function GetExproleSingleLine(_build:String,_targedID:String):Object 
		{
			return this._TimeLineObject.GetExproleSingleLine(_build,_targedID);
		}
		
		public function ToRun():void 
		{
			this._TimeLineObject.ToRun();
		}
		
		
		
		
		
		
		
		
	}
	
}