package MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class MissionCalculateBase 
	{
		public var _missionType:String="";
		
		public var _target:String = "";
		//---等級
		public var _lv:int = -1;
		//---需要被完成的任務GUID--
		public var _missionDone:String = "";
		
		//---數量
		public var _number:int = -1;
		
		//---學到的技能
		public var _skill:String = "";
		
		//---次數
		public var _times:int = -1;
		
		//---選擇難度--
		public var _difficulty:String = "";
		
	}
	
}