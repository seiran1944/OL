package MVCprojectOL.ModelOL.Vo.Pvp
{
	import MVCprojectOL.ModelOL.Vo.Battle.BattleReport;
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Vo.Buildschedule;
	registerClassAlias("PvpFightingReport", PvpFightingReport);
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation PVP戰鬥結束後取得的資料
	 */
	public class PvpFightingReport 
	{
		public var _fightAvailable:Boolean;//是(true) / 否(false) 成功進行戰鬥處理 (資料與當前不符合會回false)
		public var _rankUpdate:PvpRankingUpdate;//當前最新清單資料
		
		//(以下有戰鬥才有值) _fightAvailable == true
		public var _battleReport:BattleReport;//戰鬥結果報表
		public var _schedule:Buildschedule;//戰敗的狀態下夾帶的系統冷卻排程
		
		//public var _honorPoint:int;//增加的積分點數 (積分當作素材做進ItemDrop內)
		//public var _prePlace:int;//上次的名次(出戰時只有檢查對手資料異同,玩家看到的當前排名可能是舊的)
		//public var _nowPlace:int;//現在的名次
		
	}
	
}