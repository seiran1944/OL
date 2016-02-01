package MVCprojectOL.ViewOL.SharedMethods 
{
	/**
	 * ...
	 * @author brook
	 */
	public class TimeConversion 
	{
		
		public function TimerConversion(_InputSeconds:int):String
		{
			var _Minute:int = _InputSeconds / 60;
			var _MinuteStr:String;
			var _TimerStr:String;
			var _Second:int;
			var _SecondStr:String;
			var _Day:int; 
			
			if (_Minute >= 60) {
				var _Hour:int = _Minute / 60;
				if (_Hour >= 24) {
					_Day = _Hour / 24;
					_Hour = _Hour % 24;
				}
				var _HourStr:String;
				_Minute = _Minute % 60;
				_Second = _InputSeconds % 60;
				(_Hour < 10)?_HourStr = "0" + String(_Hour):_HourStr = String(_Hour);
				(_Minute < 10)?_MinuteStr = "0" + String(_Minute):_MinuteStr = String(_Minute);
				(_Second < 10)?_SecondStr = "0" + String(_Second):_SecondStr = String(_Second);
				(_Day < 1)?_TimerStr = _HourStr + ":" + _MinuteStr + ":" + _SecondStr:_TimerStr = String(_Day) + "d" + ":" + _HourStr + ":" + _MinuteStr + ":" + _SecondStr;
			}else if (_Minute < 60 && _Minute != 0) {
				_Second = _InputSeconds % 60;
				(_Minute < 10)?_MinuteStr = "0" + String(_Minute):_MinuteStr = String(_Minute);
				(_Second < 10)?_SecondStr = "0" + String(_Second):_SecondStr = String(_Second);
				_TimerStr = "00" + ":" + _MinuteStr + ":" + _SecondStr;
			}else if (_Minute == 0) {
				_Second = _InputSeconds;
				(_Second < 10)?_SecondStr = "0" + String(_Second):_SecondStr = String(_Second);
				_TimerStr = "00" + ":" + "00" + ":" + _SecondStr;
			}
			return _TimerStr;
		}
		
	}
}