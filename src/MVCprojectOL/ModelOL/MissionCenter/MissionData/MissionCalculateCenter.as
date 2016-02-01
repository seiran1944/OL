package MVCprojectOL.ModelOL.MissionCenter.MissionData
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.IfMission.IfCalculate;
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MissionCalculateBase;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionBase;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionComplete;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author ...
	 */
	public class  MissionCalculateCenter
	{
		
		//---取得相同條件的計算清單
		private var _funConditionCal:Function;
		//---取得相同條件的任務條件清單
		private var _funTargetCondition:Function;
		
		private var _funVoGroup:Function;
		private const _maxMotation:int = 10;
		//---存取計算動作(佔代)---
		private var _aryMissionMotation:Array;
		public function MissionCalculateCenter(_cal:Function,_target:Function,_voGroup:Function) 
		{
			//---註冊class讓byteAryclone的時候有辦法完整複製出型別
			registerClassAlias ("ClassTest", MissionConditionComplete);
			this._funConditionCal = _cal;
			this._funVoGroup=_voGroup
			this._funTargetCondition = _target;
			this._aryMissionMotation = [];
		}
		
		
		public function AddCalculateCenter(_missionCalculate:MissionCalculateBase):void 
		{
			
			this.creatMotationTypeHandler(_missionCalculate._missionType, _missionCalculate._target);
			
			
			
			//---抽取同type的計算類群
			/*
			var _sameCondition:Array=this._funConditionCal(_missionCalculate._missionType,_missionCalculate._target);
			if (_sameCondition.length>0) {
				var _ifCalculate:IfCalculate = this.calculateHandler(_missionCalculate._missionType);
				if (_ifCalculate!=null) {
					//---將清單注射進去-
					_ifCalculate.injectionTarget(_missionCalculate,this._funTargetCondition);
					this.starCalculateHandler(_ifCalculate,_sameCondition);
				}
			}*/
			
		}
		
		private function creatMotationTypeHandler(_type:String,_target:String):void 
		{
			var _missionList:MissionConditionComplete = new MissionConditionComplete();
			_missionList._missionType = _type;
			_missionList._target = _target;
			this._aryMissionMotation.push(_missionList);
			if (this._aryMissionMotation.length >= this._maxMotation) {
				//-----送出動作請求
				var _ary:Array = [];
				var _newAry:Array=[];
				var _byte:ByteArray = new ByteArray(); 
				_byte.writeObject(this._aryMissionMotation); 
				_byte.position = 0; 
				_ary = _byte.readObject();
				this._aryMissionMotation = [];
				//---連線送到VOGROUP裡面-----
				this._funVoGroup(ProxyPVEStrList.MISSION_CALL_GET_MISSION,_ary);
			}
			
		}
		
		
		
		public function GetVoMotation():Array 
		{
			var _ary:Array = [];
			if (this._aryMissionMotation.length>0) {
				//var _ary:Array = [];
				var _newAry:Array=[];
				var _byte:ByteArray = new ByteArray(); 
				_byte.writeObject(this._aryMissionMotation); 
				_byte.position = 0; 
				_ary = _byte.readObject();
				this._aryMissionMotation = [];
				
				
			}
			
			return _ary;
		}
		
		
		private function calculateHandler(_type:String):IfCalculate 
		{
			
			var _calculateInterface:IfCalculate;
			//---以下就直接擷取出來.
			switch(_type) {
				
				case ProxyPVEStrList.MISSION_Cal_MISBUILD:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_MISDONE:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_MONSTER_EAT:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_MONSTER_HAVE:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_MONSTER_SKILL:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_MONSTER_TEAM:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_MONSTER_TRAN:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_MSP_EXPLORE:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_MSP_WAY:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_MTL_HAVE:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_MTL_MAKE:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_NPC_KO:
				break;
				
				case ProxyPVEStrList.MISSION_Cal_PVP_RANK:
				break;
				
			}
			
			return _calculateInterface;
		}
		
		//---放入計算機/同樣相同的計算群/單次計算
		private function starCalculateHandler(_ifFunction:IfCalculate,_sameAry:Array):void 
		{
			var _len:int = _sameAry.length;
			for (var i:int = 0; i < _len;i++ ) {
				_ifFunction.Calculate(_sameAry[i]);
				
			}
			//----計算完畢比對結果-----(MissionConditionComplete)
			var _aryMiss:Array = this._funTargetCondition(_ifFunction.GetCanCalculate());
			//--再掃需要某任務完成的條件---
			
			
			
		}
		
		private function checkCompleteMissionHandler():void 
		{
			
		}
		
	}
	
}