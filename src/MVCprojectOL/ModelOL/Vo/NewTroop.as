package MVCprojectOL.ModelOL.Vo
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.01.15.00
		@documentation Set_Troop 新創建隊伍(無GUID狀態) SERVER回傳GUID使用VO型態
	 */
	public class NewTroop 
	{
		public var _guid:String;			//SERVER新編GUID
		public var _symbol:String;	//CLIENT對應代號
		public var _error:int;				//若新增隊伍失敗時回傳的錯誤碼 / 若新增隊伍成功則為0
		
	}
	
}