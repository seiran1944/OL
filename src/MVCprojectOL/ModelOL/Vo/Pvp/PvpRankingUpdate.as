package MVCprojectOL.ModelOL.Vo.Pvp
{
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	registerClassAlias("PvpRankingUpdate", PvpRankingUpdate);
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 榜單資料內容(預留為每次需要刷新的資料項目包裝)
	 */
	public class  PvpRankingUpdate
	{
		public var _aryRankBoard:Array;//排行榜名次清單列[ PvpCompetition ,... ] 順序<前...玩家...後> 
		
		
		//取得玩家本身資料
		public function GetUserData():PvpCompetition
		{
			if (this._aryRankBoard != null) {
				var leng:int = this._aryRankBoard.length;
				var place:int = 10;
				if (leng < 21) {//正常狀態下 前十後十
					for (var i:int = 0; i < leng; i++) 
					{
						if (this._aryRankBoard[i]._playerId == PlayerDataCenter.PlayerID) {
							place = i;
							break;
						}
					}
				}
				return this._aryRankBoard[place];
			}
			return null;
		}
		
		
	}
	
}