package MVCprojectOL.ModelOL.MissionCenter.MissionData
{
	import flash.utils.getQualifiedClassName;
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MissionCalculateBase;
	import MVCprojectOL.ModelOL.Vo.MissionVO.Mission;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionBase;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MissionDataCenter 
	{
		//--任務計算中心
		private var _missionCalculateCenter:MissionCalculateCenter;
		//---任務列表
		private var _missionList:MissionList;
		//---任務條件中心
		private var _missionConditionCenter:MissionConditionCenter;
		//--準備建構的任務條件計算---
		private var _aryMissCondition:Array = [
		
		
		
		
		];
		
		//private var _funSend:Function;
		
		
		public function MissionDataCenter(_fun:Function,_call:Function)
		{
			//if (!_fun) this._funSend = _fun;
			this._missionConditionCenter = new MissionConditionCenter();
			this._missionList = new MissionList(_fun);
			//---要把條件列表的vector塞進去--
			this._missionCalculateCenter = new MissionCalculateCenter(this._missionConditionCenter.funGetAccordUnfunsh,this._missionList.funGetSameCondtion,_call);
		}
		
		public function AddInitMission(_ary:Array):void 
		{
			this._missionList.AddMission(_ary);
		}
		
		public function GetMissionCompleteWall():Array 
		{
			return this._missionList.completReady;
		}
		
		public function SetMissionCompleteWall(_ary:Array):void 
		{
			this._missionList.completReady = _ary;
		}
		
		public function AddMission(_ary:Array):void 
		{
			/*
			var _len:int = _ary.length;
			
			for (var i:int = 0; i < _len;i++ ) {
				
				if (_ary[i]._status==2) { 
					this._missionConditionCenter.RemoveCompleteMis(_ary[i]._guid,1);
					} else {
					var _classAry:Array = _ary[i]._endCondition;
					var _lenAry:int = _classAry.length;
					var _aryCalculate:Array = [];
					for (var j:int = 0; j < _lenAry;j++ ) {
					//---要在檢查裡面的class名稱是否正確
					var _className:String = getQualifiedClassName(_classAry[j]);
					var _missionCalculate:MissionConditionBase= this.getClassNameHandler(_className);
                    _missionCalculate._missionGuid = _ary[i]._guid;
                    _missionCalculate._status = _ary[i]._status = 1;
                    //---拿操作對象的mobID(原型)
					//_missionCalculate._targetGuid = ;
					_aryCalculate.push(_missionCalculate);
					}
					this._missionConditionCenter.CreatNewMissionCal(_aryCalculate);
					
				}
					
			}*/
			this._missionList.AddMission(_ary);
		}
		
		private function getClassNameHandler(_classNmae:String):MissionConditionBase 
		{
			var _class:MissionConditionBase;
			var _len:int = this._aryMissCondition.length;
			for (var i:int = 0; i < _len;i++ ) {
				if (_classNmae==getQualifiedClassName(this._aryMissCondition[i])) {
					_class = new (this._aryMissCondition[i]);
					break;
				}
			}
			return _class;
		}
		//---新增玩家未完成任務或是未接取任務的清單(初始狀態)
		public function AddUnfinishedMission(_ary:Array):void 
		{
			this._missionConditionCenter.AddUnfinishedMis(_ary);
		}
		
		//---計算任務
		public function Calculate(_target:MissionCalculateBase):void 
		{
			this._missionCalculateCenter.AddCalculateCenter(_target);
		}
		
		//---取得動做計算的清單--
		public function GetVoMotation():Array 
		{
			return this._missionCalculateCenter.GetVoMotation();
		}
		
		
		
		//---領取完獎勵遺除任務列表
		public function CompleteRemove(_missionID:String):void 
		{
			this._missionList.RemoveSingleMission(_missionID);
		}
		
		//----取得任務資料
		public function GetMissionList():Vector.<Mission>  
		{
			return this._missionList.GetMissionList();
		}
		
		public function CheckGetReward(_id:String):Boolean 
		{
			return this._missionList.GetMissionReward(_id);
		}
		
		//---取的單獨的任務-*---
		public function GetSingleMission(_guid:String):Mission 
		{
			return this._missionList.GetSingleMission(_guid);
		}
		
	}
	
}