package MVCprojectOL.ModelOL.MissionCenter.MissionData
{
	//import MVCprojectOL.ModelOL.Vo.Mission;
	import flash.utils.getQualifiedClassName;
	import flashx.textLayout.property.ArrayProperty;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.Vo.MissionVO.Mission;
	import MVCprojectOL.ModelOL.Vo.PlayerData;
	import strLib.commandStr.PVECommands;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 * PS要再增加判斷[強制秀出類型--要另外送事件]
	 */
	public class  MissionList
	{
		private var _vecMission:Vector.<Mission>;
		private var _initFlag:Boolean = false;
		private var _sendNotify:Function;
		private var _bolGameInit:Boolean = false;
		//---完成代碼(僅用於遊戲初始提供一次,即丟棄)
		private var _aryInitComplete:Array;
		//---玩家顯示過的完成任務.接取即刪掉
		private var _aryComplete:Array;
		//---完成的字串代碼----
		private const _COMPLETESTR_KEY:String = "";
		//---抽取比對的任務----
		private var _funGetSameCondtion:Function;
		
		private const missionITEM:String = PlayerDataCenter.missionItem;
		//---完成當下不在該系統中(MainWall)----
		private var _completReady:Array = [];
		//---要再寫防止重覆建構---
		public function MissionList(_fun:Function=null) 
		{
		    //if (this._initFlag == true && this._sendNotify=null) return;
			//this._initFlag = true;
			this._sendNotify = _fun;
			this._vecMission = new Vector.<Mission>();
			this._aryInitComplete = [];
			this._aryComplete = [];
			this._funGetSameCondtion = this.getSameCondtionHandler;
		}
		//---抽取比對的任務----
		public function get funGetSameCondtion():Function 
		{
			return _funGetSameCondtion;
		}
		
		public function get completReady():Array { return _completReady};
		
		public function set completReady(value:Array):void { _completReady = value };
		
		
		
		//---已經完成且領完獎勵的任務就不要塞進來了
		/*
		public function AddMission(_ary:Array):void 
		{
		    var _len:int = _ary.length;
			//---檢查任務是否完成
			//var _missionComplete:Boolean = false;
			//---任務完成通知字串-----
			//var _sendStr:String;
			var _nowComplete:Array = [];
			for (var i:int = 0; i < _len;i++ ) {
				
				if (_ary[i] is Mission) {
					var _index:int=this.checkMissionIndexHandler(_ary[i]._guid)
					_index == -1?this._vecMission.push(_ary[i]):this._vecMission[_index] = _ary[i];
					if (_ary[i]._statu == 2) {
					  //_missionComplete = true;	
					  if (this._aryInitComplete!=null && !this._initFlag) { 
						  //---遊戲初始狀態---
						  this._aryInitComplete.push(_ary[i]._title);
						  this._aryComplete.push(_ary[i]._guid);
						}else if(!this.checkCompleteHandler(_ary[i]._guid)){
						   //---遊戲完成尚未提示過
						   //---準備送出提示清單---
						   _nowComplete.push(_ary[i]._title);
						   //---推入提示完成清單(此清單完成[領取動作]要刪掉)
						   this._aryComplete.push(_ary[i]._guid);
						   
						}
					  
					}
					
				}
			}
			
			var _sendStr:String = ProxyPVEStrList.MISSION_READY;
			if (!this._initFlag) {
			  this._initFlag = true;
			  _sendStr = ProxyPVEStrList.MISSION_PROXYREADY;
			 // if(_missionComplete)
			}
			
			
			this._sendNotify(_sendStr);
			//---送完成事件-----
			if(_nowComplete.length>0)this._sendNotify(ProxyPVEStrList.MISSION_COMPLETE)
			
			
		}
		*/
		
		//---complete--
		//new SendTips("TimeLineProxy", ProxyPVEStrList.TIP_COMPLETE, _aryStone[0]._picItem, _aryStone[0]._guid, 3, 4, _deleteIndex, 5);
		//---已經完成且領完獎勵的任務就不要塞進來了
		public function AddMission(_ary:Array):void 
		{
		    var _len:int = _ary.length;
			//---檢查任務是否完成
			var _missionComplete:Boolean = false;
			//---任務完成通知字串-----
			//var _sendStr:String;
			var _aryRewardComplete:Array = [];
			var _sendStr:String;
			var _aryNewMission:Array = [];
			var _returnObj:Object;
			var _nowComplet:Array = [];
			for (var i:int = 0; i < _len;i++ ) {
				
				if (_ary[i] is Mission) {
					//---發亮提示----
					if (_ary[i]._status == 2)_missionComplete = true;
					if (this._initFlag==false) {
						this._vecMission.push(_ary[i]);
						
						} else {
						var _index:int=this.checkMissionIndexHandler(_ary[i]._guid)
						//_index == -1?this._vecMission.push(_ary[i]):this._vecMission[_index] = _ary[i];
						if (_index == -1) {
							this._vecMission.push(_ary[i]);
							_aryNewMission.push(_ary[i]);
							} else {
							this._vecMission[_index] = _ary[i];
						}
						if (_ary[i]._status == 2)_nowComplet.push(
						new SendTips(
						  "MissionList",
						   ProxyPVEStrList.TIP_COMPLETE,
						   this.missionITEM,
						   _ary[i]._guid,
						  -10,
						  -1,
						  "",
						  -10,
						   {_key:"GLOBAL_TIP_COMPLETETIP04",_targetName:"",_produceName:_ary[i]._title}
						  
						  
						)
						
						);
						if (_ary[i]._status == 3)_aryRewardComplete.push(_ary[i]._guid);
					}
					
				}
			}
			
			if (!this._initFlag) {
			  this._initFlag = true;
			  _sendStr = ProxyPVEStrList.MISSION_PROXYREADY;
			}else {
			  _sendStr = ProxyPVEStrList.MISSION_READY;
			  //----_aryComplete=[]>無領取任務(不需要刪除)>_aryNewMission=[]>無新曾任務(不需要新增)
			  _returnObj = {_aryComplete:_aryRewardComplete,_aryNew:_aryNewMission};	
			}
			
			this._sendNotify(_sendStr, _returnObj);
			//---發送當下完成的事件---
			if (_nowComplet.length > 0) this.sendNowCompleteHandler(_nowComplet);
			
			
			//---送完成事件(完成未領取的提示(發亮))-----
			//if (_missionComplete)
			this._sendNotify(PVECommands.MISSION_COM_COMPLETE,_missionComplete);
			
			//---已成功領取>準備刪除---
			if (_aryRewardComplete.length > 0) this.RemoveAryMission(_aryRewardComplete);
			
			
		}
		
		
		public function  RemoveInitComplete():void 
		{
			if (this._aryInitComplete != null) {
				this._aryInitComplete = [];
				this._aryInitComplete = null;
			}else {
			  return;	
			}
		}
		
		private function sendNowCompleteHandler(_ary:Array):void 
		{
			var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
			   this._sendNotify(PVECommands.TimeLineCOmelete_TipCMD,_ary[i]);		
			}
			
		}
		
		//---建構完畫面再進來拿----
		public function  InitCompleteMission():void 
		{
			//--要再補commands----
			var _sendStr:String = (this._aryInitComplete)?ProxyPVEStrList.MISSION_COM_INITCOMPLETE:ProxyPVEStrList.MISSION_COM_REMOVEINITCOMPLETE; 
		    this._sendNotify(_sendStr,this._aryInitComplete);
			
		}
		
		//---檢察任務是否提示過玩家已經完成了
		private function checkCompleteHandler(_guid:String):Boolean 
		{
			var _len:int = this._aryComplete.length;
			var _return:Boolean =false;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._aryComplete[i]==_guid) {
					_return = true;
					break;
				}
			}
			return _return;
		}
		
		
		
		
		
		//---搜尋是否有相同條件-*----
		private function checkMissionIndexHandler(_checkID:String):int 
		{
			var _len:int = this._vecMission.length;
			var _return:int = -1;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecMission[i]._guid==_checkID) {
					_return = i;
					break;
				}
			}
			
			return _return;
		}
		
		//---抽取比對的任務----
		private function getSameCondtionHandler(_ary:Array):Array 
		{
			
			var _len:int = _ary.length;
			var _lenTarget:int = this._vecMission.length;
			var _aryReturn:Array = [];
			for (var i:int = 0; i < _len; i++ ) {
				for (var j:int = 0; j < _lenTarget;j++ ) {
					if (this._vecMission[j]._guid==_ary[i]) {
						_aryReturn.push(this._vecMission[j]._endCondition[0]);
						break;
					}
					
				}
			}
			return _aryReturn;
			
		}
		
		/*
		private function getSameCondtionHandler(_condtionID:String):Array 
		{
			var _len:int = this._vecMission.length;
			var _aryback:Array = [];
			for (var i:int = 0; i < _len;i++ ) {
				//var _aryUnCondition:Array = this.checkSameConditionHandler(this._vecMission[i]._endCondition,_condtionID);
				var _aryUnCondition:Array = (getQualifiedClassName(this._vecMission[i]._endCondition[0])==_condtionID)?this._vecMission[i]._endCondition[0]:null;
				_aryback
				
				
			}
			
			
			
		}
		*/
		/*
		private function checkSameConditionHandler(_ary:Array,_target:String):void 
		{
			
			var _len:int = _ary.length;
			var _aryReturn:Array = [];
			for (var i:int = 0; i < _len; i++ ) {
				//---要在割除路徑名稱
				var _str:String = getQualifiedClassName(_ary[i]);
				if (_target==_str) {
					_aryReturn.push(_ary[i]);
				}
			}
			
			return _aryReturn;
		}
		*/
		
		
		public function MissionStar():void 
		{
			
			
			
		}
		
		public function MissionComplete():void 
		{
			
		}
		
		/*
		private function removeMissionCompleteReward(_ary:Array):void 
		{
			var _len:int = this._vecMission.length;
			var _backLen:int=_ary
			var _return:int = -1;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecMission[i]._guid==_guid) {
					_return = i;
					this._vecMission.splice(i,1);
					break;
				}
			}
			//---查無任務索引+---
			//if(_return==-1)return
			return _return
			
			
		}*/
		
		//---移除掉完成已領取的
		public function RemoveAryMission(_aryMission:Array):void 
		{
			var _len:int = _aryMission.length;
			for (var i:int = 0; i < _len;i++ ) {
				var _targetLen:int = this._vecMission.length;
				for (var j:int = 0;j <_targetLen;j++ ) {
					if (this._vecMission[j]._guid==_aryMission[i]) {
				        this._vecMission.splice(j, 1);
						break;
					}
				}
			}
			trace("HELLOREMOVE");
		}
		
		public function RemoveSingleMission(_guid:String):int 
		{
			
			var _len:int = this._vecMission.length;
			var _return:int = -1;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecMission[i]._guid==_guid) {
					_return = i;
					this._vecMission.splice(i,1);
					break;
				}
			}
			//---查無任務索引+---
			//if(_return==-1)return
			return _return
			
		}
		
		//---取得任務列表---
		public function GetMissionList():Vector.<Mission>
		{
			var _clone:Vector.<Mission> = this._vecMission.concat();
			return _clone;
		}
		/*
		public function GetSingleMission(_id:String):Mission 
		{
			
		}*/
		//----領取任務獎勵(領取前檢查)
		public function GetMissionReward(_id:String):Boolean 
		{
			var _len:int = this._vecMission.length;
			//var _flag:Boolean = false;
			//--測試用讓他過(2013/05/14)
			var _flag:Boolean = true;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecMission[i]._guid==_id && this._vecMission[i]._status==2) {
					_flag == true;
					break;
				}
			}
			
			return _flag;
			
		}
		
		//---重置任務
		public function ResetMission(_ary:Array):void 
		{
			
		}
		
		//---檢查任務獎勵是否領取
		private function checkMissionComplete():void 
		{
			
		}
		
		//---取的單獨的任務-*---
		
		public function GetSingleMission(_id:String):Mission 
		{
			var _len:int = this._vecMission.length;
			var _mission:Mission;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecMission[i]._guid) {
					_mission =this._vecMission[i];
					break;
				}
			}
			return _mission;
		}
		
		
	}
	
}

//---任務提示完成計次
/*
class MissionCompleteFlag {
	
	public var _guid:String;
	
   	
}*/ 