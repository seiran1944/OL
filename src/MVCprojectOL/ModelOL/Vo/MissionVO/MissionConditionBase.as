package MVCprojectOL.ModelOL.Vo.MissionVO
{
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  MissionConditionBase
	{
		//----條件類型---
		//public var _missType:String = "";
		//--0>任務條件/1>以接取/2>未接取/
		public var _status:int = 0;
		//--0>未完成/1>完成
		public var _missionDone:int = 0;
		//---對像guid/原型ID----
		public var _targetGuid:String = "";
		
		public var _missionGuid:String = "";
		
		//public var _picItem:String = "";
		
	}
	
}