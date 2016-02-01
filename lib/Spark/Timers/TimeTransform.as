package Spark.Timers
{
	import Spark.ErrorsInfo.MessageTool;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.07.11.16.55
		@documentation 時間校正器(加快運行速率達到運行準確度)
	 */
	public class TimeTransform 
	{
		
		private var _speed:int;
		
		
		public function set Speed(value:int):void
		{
			this._speed = value;
		}
		
		public function TransTime(delay:int):int
		{
			if (this._speed == 0) {
				//throw new Error("'TimeDriver'    need setting the 'SourceTimer' speed ");
				MessageTool.InputMessageKey(603);
				return delay;
			}
			
			var turnDelay:int;
			var revise:Number = 1;
			//校正區塊(簡易處理版)
			switch (this._speed)
			{
				case 1:
					revise = .06;
				break;
				case 10:
					revise = .61;//原.56
				break;
				case 20:
					revise = .65;
				break;
			default:
				
				if(this._speed<100 && this._speed>=40){//100ms以下初始再處理 // 以上準確度較高
					switch (this._speed)
					{
					case 40:
						revise = .74;
					break;
					case 60:
						revise = .9;
					break;
					case 90:
						revise = .9;
					break;
					default:
						revise = .8;
					}
				}
			}
			
			turnDelay = delay * revise;
			
			/*
			 if (delay >= 3000) {
				revise = .85;
			}else {
				revise = 1;
			}
			
			turnDelay = turnDelay * revise;
			*/
			turnDelay = turnDelay >= this._speed ?  turnDelay : this._speed;
			//trace("簡茶轉換植", turnDelay);
			return turnDelay;
		}
		
		
		
		
		
	}
	
}