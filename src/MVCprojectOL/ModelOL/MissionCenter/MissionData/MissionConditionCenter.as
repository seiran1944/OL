package MVCprojectOL.ModelOL.MissionCenter.MissionData
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionBase;
	
	/**
	 * ...
	 * @author ...EricHuang
	 * 任務條件處理產生
	 */
	public class  MissionConditionCenter
	{
		//---未完成任務計算清單
		private var _vecUnfinishedMis:Vector.<MissionConditionBase>;
		//---未接取任務計算清單
		//private var _vecWillMis:Vector.<MissionConditionBase>;
		
		//private var _dicUnfinishedMis:Dictionary;
		//private var _dicWillMis:Dictionary;
		
		//--抽取符合該條件的計算清單(回傳計算本體)
		private var _funGetAccordUnfunsh:Function;
		public function MissionConditionCenter():void 
		{
			//this._dicUnfinishedMis = new Dictionary(true);
			//this._dicWillMis = new Dictionary(true);
			this._vecUnfinishedMis = new Vector.<MissionConditionBase>();
			//this._vecWillMis = new Vector.<MissionConditionBase>();
			this._funGetAccordUnfunsh = this.GetAccordUnfinishedMis;
		}
		
		public function get funGetAccordUnfunsh():Function 
		{
			return _funGetAccordUnfunsh;
		}
		
		/*
		public function get vecUnfinishedMis():Vector.<MissionConditionBase> 
		{
			return _vecUnfinishedMis;
		}*/
		
		
		//---新增接取未完成的計算清單(遊戲初始server給回來的)
		public function AddUnfinishedMis(_ary:Array):void 
		{
			this.CreatNewMissionCal(_ary);
		}
		
		//---新增任務時,創造計算清單
		public function CreatNewMissionCal(_ary:Array):void 
		{
			var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
				
				if (_ary[i]._status>0) {
					var _index:int = this.checkHasMissionHandler(_ary[i]._missionGuid);
				
					if (_index!=-1) {
						
						this._vecUnfinishedMis[_index]=_ary[i];
						} else {
						
						this._vecUnfinishedMis.push(_ary[i]);
					}
					
					
				}
				
				
			}
			
		}
		
		private function checkHasMissionHandler(_guid:String):int 
		{
		    //---0=以接取未完成/1=未接取
			//var _vec:Vector.<MissionConditionBase> = (_type==0)?this._vecUnfinishedMis:this._vecWillMis;
			var _len:int = this._vecUnfinishedMis.length;
			var _index:int = -1;
			for (var i:int = 0; i < _len;i++ ) {
				if (_guid==this._vecUnfinishedMis[i]._missionGuid) {
					_index = i;
					break;
				}
			}
			
			return _index;
		}
		
		
		//---新增尚未接取的任務,創造計算清單
		/*
		public function CratWillMissionCal(_ary:Array):void 
		{
			var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
				this._vecWillMis.push(_ary[i]);
				
				//var _str:String = getQualifiedClassName(_ary[i]);	
				
			}
		}*/
		//---抽取符合該條件的計算清單(回傳計算本體)
		private function  GetAccordUnfinishedMis(_missType:String,_target:String="",_status:int=1):Array 
		{
			
			var _len:int = this._vecUnfinishedMis.length;
			var _aryReturn:Array = [];
			for (var i:int = 0; i < _len;i++ ) {
				if (getQualifiedClassName(this._vecUnfinishedMis[i])=="Mission_"+_missType && this._vecUnfinishedMis[i]._status==_status) {
					if (_target!="") {
						if(this._vecUnfinishedMis[i]._targetGuid==_target)_aryReturn.push(this._vecUnfinishedMis[i]);
						} else {
						_aryReturn.push(this._vecUnfinishedMis[i]);
					}
					
				}
				
			}
			
			return _aryReturn;
			
		}
		
		//---抽取(未接取)的計算清單(回傳計算本體)
		/*
		public function GetAccordWillMis(_missType:String):Array 
		{
			var _len:int = this._vecWillMis.length;
			var _aryReturn:Array = [];
			for (var i:int = 0; i < _len;i++ ) {
				if (getQualifiedClassName(this._vecWillMis[i])=="Mission_"+_missType) {
					_aryReturn.push(this._vecWillMis[i]);
					
				}
				
			}
			
			return _aryReturn;
		}*/
		
		//---移除以接取的任務計算清單(判定完成)
		public function RemoveCompleteMis(_missionId:String,_status:int):void 
		{
			var _len:int = this._vecUnfinishedMis.length;
			
			for (var i:int = 0; i < _len;i++ ) {
				if (_missionId==this._vecUnfinishedMis[i]._missionGuid && this._vecUnfinishedMis[i]._status==_status) {
					this._vecUnfinishedMis.splice(i,1);	
			        break;
				}
			}
			
		}
		
		//---移除接取的條件清單(以接取未完成)
		/*
		public function RemoveGetMission(_missionId:String):void 
		{
			var _len:int = this._vecWillMis.length;
			
			for (var i:int = 0; i < _len;i++ ) {
				if (_missionId==this._vecWillMis[i]._missionGuid) {
					this._vecWillMis.splice(i,1);	
			        break;
				}
			}
			
		}*/
		
		//---取得單筆任務計算條件
		public function GetSingleUnfinishedMis(_missionId:String,_status:int):MissionConditionBase 
		{
			var _len:int = this._vecUnfinishedMis.length;
			var _MissionConditionBase:MissionConditionBase;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecUnfinishedMis[i]._missionGuid==_missionId && this._vecUnfinishedMis[i]._status==_status) {
					_MissionConditionBase = this._vecUnfinishedMis[i] as MissionConditionBase;
					break;
				}
				
			}
			
			return _MissionConditionBase;
			
		}
		
		
		
		
		//---取得單筆未接取任務計算條件
		/*
		public function GetSingleWillMis(_missionId:String):void 
		{
			
		}*/
		
		
	}
	
}