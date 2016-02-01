package strLib.proxyStr
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.02.14.31
		@documentation 建築物字串組
	 */
	public class BuildingStr 
	{
		
		public static const BUILDING_SYSTEM:String = "BuildingProxy";//Proxy系統註冊
		public static const BUILDING_TIMER:String = "BuildingTimer";//SendNotify有倒數計時時每秒發送
		public static const BUILDING_FIN_WORK:String = "BuildingFinWork";//SendNotify建築排程單位完成計時  *發送為此常數+建築物GUID*
		public static const BUILDING_FIN_UPGRADE:String = "BuildingFinUpgrade";//SendNotify建築升級完成計時  *發送為此常數+建築物GUID*
		public static const BUILDING_ERROR_UPGRADE:String = "BuildingErrorUpgrade";//SendNotify建築升級SERVER判定失敗的通知  *發送為此常數+建築物GUID*
		//---build init finish send----2012/11/19---eric
		public static const BUILDING_READY:String = "BuildingInitReady";
		
	}
	
}