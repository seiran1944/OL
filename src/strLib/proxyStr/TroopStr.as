package strLib.proxyStr
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.16.14.10
		@documentation to use this Class....
	 */
	public class TroopStr 
	{
		
		public static const TROOP_SYSTEM:String = "TroopProxy";//系統Proxy註冊用
		public static const TROOP_READY:String = "TroopReady";//讀取初始資料完成
		public static const TROOP_IDLE:String = "TroopIdle";//SendNotify  隊伍CD時間到達時發送通知
		public static const TROOP_SHIFT:String = "TroopShift";//SendNotify  隊伍位置有變更位移狀態時發送通知 ( 若須更新頁面顯示GetTroopByPage )
		
	}
	
}