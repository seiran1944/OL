package MVCprojectOL.ModelOL.Vo
{
	
	/**
	 * ...
	 * @author EricHuang
	 */           
	public class  Buildschedule
	{
		
		//排成唯一id
		public var _guid:String = "";
		//---建築物ID---
		public var _buildID:String = "";
		//----暫時計算的ID---
		public var _fackID:String = "";
		//開始時間
		public var _startTime:int = 0;//10碼數字 unixtime 秒
		//需要時間
		public var _needTime:int = 0;//秒
		//結束時間
		public var _finishTime:int = 0;//10碼數字 unixtime 秒
		//目標id
		public var _targetID:String = "";
		//--1.大廳（魔法陣）, 2.巢穴 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室
		public var _buildType:int = 0;
		//----------
		//----計時器-----
	    public var _timeCheck:int = 0;
		//-----完成被處理過會=1
		public var _flagTime:int = 0;
		
		
	}
	
}