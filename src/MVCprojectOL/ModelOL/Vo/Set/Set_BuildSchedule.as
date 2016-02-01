package MVCprojectOL.ModelOL.Vo.Set
{
	
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class Set_BuildSchedule extends VoTemplate
	{
		public var _buildID:String = "";
		public var _fackID:String = "";
		public var _startTime:int = 0;
		public var _targetID:String = "";
		public var _buildType:int = 0;
		public var _chageSkill:String = "";
		public var _groupSkill:int = -1;
		
		public function Set_BuildSchedule(_statusType:String, _build:String = "", _target:String = "", _fack:String = "", _starTime:uint = 0, _buildType:uint = 0, _changSK:String = "",_groupSkill:int=-1):void 
		{  
		   
		   super(_statusType);
		   this._buildID = _build;
		   this._buildType = _buildType;
		   this._fackID = _fack;
		   this._startTime = _starTime;
		   this._targetID = _target; 
		   this._chageSkill = _changSK;
		   this._groupSkill = _groupSkill;
		   
		   
		}
		
		
	}
	
}