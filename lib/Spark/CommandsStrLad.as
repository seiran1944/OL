package Spark
{
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class CommandsStrLad  
	{
		
		//==============starUP===================
		public static const StarUP_Spark:String = "StarUPEngine";
		
		//==============Net Work===============
		public static const Proxy_NetWork:String = "AmfConnector";//Net Work Proxy Name
		
		public static const Notification_onNetResult:String = "onNetResult";//Net Work Notification	
		public static const Notification_onNetError:String = "onNetError";//Net Work Notification	
		//=======END===Net Work=============
		
		//===================BAR_SYSTEM
		public static const BAR_SYSTEM:String = "BarProxy";	//Bar調用Proxy
		
		
		//==================GUI layer===========================
		public static const SEQUENCE_SYSTEM:String = "MenuWork";//GUI排序調用Proxy
		public static const SEQUENCE_NOTIFY:String = "MenuNotify";//GUI排序通知Notify>>GetClass() 有夾Object { _name : 須操作的字串代號 , _action : "OPEN" / "CLOSE" }
	   
		//===================================//註冊啟動SourceProxy
		public static const SourceSystem:String = "SourceSystem";
		public static const Source_Complete:String = "Source_Complete";
		//-----sourceBar(commands)----
		public static const Source_Bar:String = "Source_Bar";
		//-----sourceBar(proxy)----
		public static const SorceBar_Proxy:String = "SourceBar_PRoxyName";
		//Text註冊Proxy名稱
		public static const TEXTDRIFT_SYSTEM:String = "TextDriftSystem";
		public static const PayBillDataReady:String = "PayBillDataReady";
		
		
		//==============TimerRunning===================20130509 -Paladin
		public static const TIMER_RUNNING:String = "SourceTimerRunning";
	}
	
}