package Spark.Timers
{
	import Spark.Timers.TimeOperate;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.07.23.14.10
		@documentation 多一層經過getTimer時間調整(差異不大)
	 */
	public class TimeCheckingOperate 
	{
		
		private var _accumulate:int;
		private var _changes:int;
		private var _speed:int;
		private var _operate:TimeOperate = new TimeOperate();
		
		public function init():void 
		{
			this._changes = getTimer();
		}
		
		public function Counting():void 
		{
			this._accumulate += getTimer() - this._changes;
			this._changes = getTimer();
			
			if (this._accumulate >= this._speed) {
				this._accumulate = 0;
				this.Running();
			}
			
		}
		
		public function Running():void 
		{
			this._operate.runClock();
		}
		
		public function set Speed(value:int):void 
		{
			_speed = value;
		}
		
		
	}
	
}