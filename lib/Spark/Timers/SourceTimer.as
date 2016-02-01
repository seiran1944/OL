package  Spark.Timers
{
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.MVC.FacadeCenter;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 時間驅動-物件管理
	 */
		
	public class SourceTimer {
		
		private static var _heart:Timer;
		private static var _speed:uint=0;
		internal static var _operate:TimeOperate = new TimeOperate();//可更換TimeCheckingOperate.as測試
		private static var _canUse:Boolean = false;
		
		//Timer Control;
		public static function SetSpeed(speed:uint=10):void {
			if(_heart!=null){
				_heart.stop();
				_heart.reset();
				_heart.removeEventListener(TimerEvent.TIMER, specialLink);
				//throw new Error ("You have  setting twice!!");//限制只可初始ㄧ次運行速度
			}
			_heart = new Timer(speed);//TimeCheckingOperate要改speed = 1;
			_speed = speed;
			//TimeCheckingOperate.as採用
			//_operate.Speed = speed;
			
			TimeDriver._manage.speed = speed;
			TimeDriver._transform.Speed = speed;
			
			if(!_heart.hasEventListener(TimerEvent.TIMER)){
				_heart.addEventListener(TimerEvent.TIMER,specialLink);
			}
			_canUse = true;
		}
		
		public static function FPSToSpeed(fps:uint):uint
		{
			var _speed:uint= 1000 / fps;
			return _speed;
		}
		
		//Timer Control
		public static function ToRun():void {
			if (_heart != null) {
				if (!Running) {
					_heart.start();
					FacadeCenter.GetFacadeCenter().SendNotify(CommandsStrLad.TIMER_RUNNING);
				}
				//TimeCheckingOperate.as採用
				//_operate.init();
			}
		}
		public static function ToStop():void {
			if (_heart != null) {
				if(Running) _heart.stop();
			}
		}
		public static function ToReset():void 
		{
			if (_heart != null) {
				_heart.reset();
			}
		}
		public static function get Running():Boolean{
			return _heart.running;
		}
		
		public static function get CurrentCount():int {
			return _heart.currentCount;
		}
		
		public static function get RepeatCount():int{
			return _heart.repeatCount;
		}
		
		public static function get InitReady():Boolean
		{
			return SourceTimer.Running && SourceTimer._canUse ? true : false;
		}
		
		public static function get Speed():int
		{
			return _speed;
		}
		//TimerWorking
		private static function specialLink(e:TimerEvent):void {
			//採用checkingOperate下
			//_operate.Counting();//經過二次確認基礎速率//要調整運行timer 速率為1
			//_operate.Running();//直接運行呼叫
			
			//採用timeOperate不經getTimer確認直接運行
			_operate.runClock();
			//trace("timer_running__>>>>>>>>>>"+ServerTimework.GetInstance().ServerTime);
		}
	}
	
}
