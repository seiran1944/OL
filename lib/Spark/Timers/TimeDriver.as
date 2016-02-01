package Spark.Timers
{
	import Spark.Timers.TimeTransform;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 時間管理器USER操作系統
	 */
	public class TimeDriver 
	{
		internal static  var _manage:TimeManage = new TimeManage();
		internal static var _transform:TimeTransform = new TimeTransform();
		
		//TimeDrive Use;
		public static function AddDrive(delay:uint,times:uint=0,runFunction:Function=null,runArgs:Array=null,endFunction:Function=null,endArgs:Array=null):void {
			
			//if (delay  <  SourceTimer.GetSpeed) { throw new Error ("Time is too quick ,can't receive"); return; }
			if (!SourceTimer.InitReady) throw new Error("SourceTimer setting is not Ready");
			
			var revise:int = _transform.TransTime(delay);
			
			var tBox:TimeBox = new TimeBox([revise, times, runFunction, runArgs, endFunction, endArgs ,delay]);
			_manage.AddMember(runFunction,tBox,revise);
		}
		
		/**
		 * 快速變更已註冊Function的運行速度
		 * @param	runFunction 運行Function
		 * @param	delay 變更速度
		 */
		public static function ChangeDrive(runFunction:Function,delay:uint):void 
		{
			var revise:int = _transform.TransTime(delay);
			var box:TimeBox = _manage.DelMember(runFunction, true);
			box.NeedCount = 0;
			box.DefaultDelay = delay;
			_manage.AddMember(runFunction, box, revise);
		}
		
		//Clean
		public static function RemoveDrive(delFunction:Function):void {
			
			_manage.DelMember(delFunction);
		}
		
		public static function RemoveAll():void 
		{
			_manage.DelAll();
		}
		
		public static function AddEnterFrame(FPS:uint,times:uint=0,runFunction:Function=null,runArgs:Array=null,endFunction:Function=null,endArgs:Array =null):void 
		{
			if (!SourceTimer.InitReady) throw new Error("SourceTimer setting is not Ready");
			
			AddDrive(SourceTimer.FPSToSpeed(FPS),times,runFunction,runArgs,endFunction,endArgs);
		}
		//Active
		public static function Pause(runFunction:Function):void 
		{
			_manage.AddPause(runFunction);
		}
		
		public static function Resume(runFunction:Function):void 
		{
			_manage.Resume(runFunction);
		}
		//UserCheck
		public static function CheckRunning(useFunction:Function):Boolean
		{
			var timeBox:TimeBox = _manage._dicMember[useFunction];
			return timeBox != null ? timeBox.IsRunning : false;
		}
		public static function CheckEnd(useFunction:Function):Boolean
		{
			var timeBox:TimeBox = _manage._dicMember[useFunction];
			return timeBox != null ? timeBox.EndRun : true;
		}
		public static function CheckCount(useFunction:Function):int 
		{
			var timeBox:TimeBox = _manage._dicMember[useFunction];
			return timeBox != null ? timeBox.RunTimes : -1;
		}
		public static function CheckEndlessRun(useFunction:Function):Boolean 
		{
			var timeBox:TimeBox = _manage._dicMember[useFunction];
			return timeBox != null ? timeBox.Cycle : false;
		}
		public static function CheckSettingDelay(useFunction:Function):int 
		{
			var timeBox:TimeBox = _manage._dicMember[useFunction];
			return timeBox != null ? timeBox.DefaultDelay : -1;
		}
		public static function CheckRegister(useFunction:Function):Boolean
		{
			return _manage.CheckRegister(useFunction);
		}
		
		
		
		
		
		
		
	}
	
}