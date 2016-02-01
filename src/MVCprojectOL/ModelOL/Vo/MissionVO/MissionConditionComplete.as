package MVCprojectOL.ModelOL.Vo.MissionVO
{
	
	/**
	 * ...
	 * @author ...EricHuang
	 * 回傳動作/條件完成/任務完成的VO
	 */
	public class  MissionConditionComplete 
	{
		//---條件動作字串
		public var _missionType:String = "";
		
		public var _missionGuid:String = "";
		
		public var _target:String = "";
		
		//---0>條件動做傳遞/1>其中一個條件完成/2>任務完成
		//--PS-條件請求錯誤~就回傳一份SERVER準確的條件清單
		public var _status:int = -1;
	}
	
}