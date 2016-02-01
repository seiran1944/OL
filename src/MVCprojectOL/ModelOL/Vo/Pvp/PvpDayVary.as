package MVCprojectOL.ModelOL.Vo.Pvp
{
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Vo.Buildschedule;
	registerClassAlias("PvpDayVary", PvpDayVary);
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.04.18.11.42
		@documentation 每日(間隔)刷新的資料項目
	 */
	public class PvpDayVary
	{
		
		public var _fightTimes:int;//當前戰鬥次數變更為  (目前為刷滿)
		
		public var _buildschedule:Buildschedule = null;//循環排程用
		
	}
	
}