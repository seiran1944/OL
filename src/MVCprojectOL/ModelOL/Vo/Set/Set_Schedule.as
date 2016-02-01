package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class Set_Schedule extends VoTemplate
	{
		public var _buildID:String = "";
		public var _fackID:String = "";
		public var _startTime:int = 0;
		public var _targetID:String = "";
		public var _buildType:int = 0;
		
		
		public function Set_Schedule(_build:String,_target:String,_fack:String,_starTime:int,_buildType:int):void 
		{
		   super("Buildschedule");
		   this._buildID = _build;
		   this._buildType = _buildType;
		   this._fackID = _fack;
		   this._startTime = _starTime;
		   this._targetID = _target; 
		}
		
		
	}
	
}