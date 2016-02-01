package MVCprojectOL.ModelOL.Vo.MissionVO
{
	import MVCprojectOL.ModelOL.Vo.Buildschedule;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  MissionEveryDay
	{
		//----裡面放Buildschedule
		public var _buildschedule:Buildschedule=null;
		//---裡面放Mission(沒有就是空陣列啦)
		public var _mission:Array = [];
		
	}
	
}