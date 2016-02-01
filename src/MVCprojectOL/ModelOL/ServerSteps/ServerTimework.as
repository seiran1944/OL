package MVCprojectOL.ModelOL.ServerSteps
{
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.Timers.TimeDriver;
	import strLib.commandStr.PVECommands;
	import strLib.proxyStr.ServerStepsStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.26.11.50
		@documentation server time follows
	 */
	public class ServerTimework extends ProxY
	{
		
		private static var _timeWork:ServerTimework;
		private var _currentSteps:uint;//模擬當前SERVER時間
		private var _prevRevise:int;//前次校正值
		private var _currentPeriod:int;//發送通知當前遞減値
		private var _period:uint;//發送通知所需期間秒數
		
		public function ServerTimework(name:String,key:STKey):void 
		{
			super(name, this);
			if (ServerTimework._timeWork != null || key == null) throw new Error("this class can't be constructed");
			ServerTimework._timeWork = this;
		}
		
		public static function GetInstance():ServerTimework
		{
			if (ServerTimework._timeWork == null ) ServerTimework._timeWork = new ServerTimework(ServerStepsStr.TIMEWORK_SYSTEM, new STKey());
			return ServerTimework._timeWork ;
		}
		
		//預設起始値五分鐘,後續也可調整
		override public function onRegisteredProxy():void
		{
			this.SetNotifyPeriod(300);
		}
		
		/**
		 * 設定經過期間秒數會發送通知
		 * @param	period 需要發送通知的秒數 (期間)
		 */
		public function SetNotifyPeriod(period:uint):void
		{
			this._period = period;
			this._currentPeriod = period;
		}
		
		/**
		 * 寫入SERVER當前時間
		 * @param	serverTime 當前SERVER時間(秒數)
		 */
		public function SetServerTime(serverTime:uint):void
		{
			if (this._currentSteps != 0) {
				this._prevRevise = serverTime-this._currentSteps;
				//首次外才有校正值
				this.reviseValueNotify();
			}
			
			this._currentSteps = serverTime;
			this._currentPeriod = this._period;
		}
		private function reviseValueNotify():void 
		{
			
			var _TimeLineObject:TimeLineObject = TimeLineObject.GetTimeLineObject();
			trace("reviseValueNotify>>" + this._prevRevise);
			trace("TimeLineObject>>" + _TimeLineObject);
			//---2013/05/09
			if(_TimeLineObject!=null)_TimeLineObject.ReSetCheckTime(this._prevRevise);
		}
		
		/**
		 * TimeLine專用回寫SERVER時間
		 * @param	serverTime 當前SERVER時間(秒數)
		 */
		public function SetTimeLineTime(serverTime:uint):void
		{
			this.SetServerTime(serverTime);
		}
		
		
		/**
		 * 開始運作計時
		 * @param	reviseTimes 可校正誤差値秒數(正負數)
		 */
		public function ToRun(reviseTimes:int=0):void 
		{
			this._currentSteps += reviseTimes;
			if(!TimeDriver.CheckRegister(this.serverStepsWalking)) TimeDriver.AddDrive(1010, 0, this.serverStepsWalking);
		}
		
		private function serverStepsWalking():void
		{
			this._currentSteps++;
			//trace(this._currentSteps);
			this._currentPeriod--;
			if (this._currentPeriod < 0) {
				this.SendNotify(ServerStepsStr.TIMEWORK_PERIOD);
			}
			
			this.SendNotify(PVECommands.CHANGE_TIMETRACECMD, String(this._currentSteps) + "_" + String(TimeDriver.CheckRunning(TimeLineObject.GetTimeLineObject().UpdateTimerLine)));
		}
		
		/**
		 * 取得當前CLIENT計算的SERVER 時間
		 */
		public function get ServerTime():uint
		{
			return this._currentSteps;
		}
		
		/**
		 * 取得前次設定時間時的校正值 負數為CLIENT時間快於SERVER  ;  正數為CLIENT時間慢於SERVER  ;
		 */
		public function get PrevRevise():int
		{
			return this._prevRevise;
		}
		
		public function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.serverStepsWalking)) TimeDriver.RemoveDrive(this.serverStepsWalking);
		}
		
	}
	
}

class STKey 
{
	
}