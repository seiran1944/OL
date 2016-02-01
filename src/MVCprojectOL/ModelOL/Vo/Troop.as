package MVCprojectOL.ModelOL.Vo
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.04.26.10.42
		@documentation 初始撈取隊伍資訊時SERVER回傳的VO型態 ( 基本隊伍資料)
	 */
	public class Troop
	{
		
		public var _guid:String;
		public var _status:int;//隊伍狀態 ( 閒置中0 / 回程中 1 /  疲勞中 2 /  忙碌中(有單位在排程) 3)  *出征不具CD時間 且無佔領中狀態
		public var _objMember:Object;// "位置" 對應 "惡魔key"
				public var _backCD:uint;//狀態閒置前CD時間   // 沒有CD時間 20130426 remove
				public var _flagNum:int;//做旗幟圖示分配對應的編號值 >> <(CLIENT寫入的值)>remove

		//20130426 new default team 
		public var _teamNum:int;//隊伍紀錄的編號(位置) 從0起編 取代先前FLAGnumber用法
		public var _isPvpTeam:Boolean;//是(true)  /  否(false)為PVP預設隊伍
		public var _isPveTeam:Boolean;//是(true)  /  否(false) 為PVE預設隊伍
		
		
	}
	
}