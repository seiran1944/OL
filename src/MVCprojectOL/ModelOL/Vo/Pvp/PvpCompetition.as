package MVCprojectOL.ModelOL.Vo.Pvp
{
	import flash.net.registerClassAlias;
	registerClassAlias("PvpCompetition", PvpCompetition);
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 點選清單需要顯示的資料
	 */
	public class PvpCompetition
	{
		
		public var _playerId:String//玩家ID
		public var _name:String;//玩家暱稱
		public var _place:int;//玩家名次
		public var _countPoint:int//計算排名的累計點數(暫無-後續應該會加入UI顯示)
		public var _objMember:Object//隊伍成員
		/*=
		{
			"站位(0 - 8)" : {_guid : "String" , _picItem : "String" ,_showName :" String" }
		}*/
		//會加工成IitemDisplay 可調用圖像與DATA
		
		public var _objFaction:Object//陣營
		/*=
		{
			_name : "String", //陣營名稱
			_picItem : "String" //陣營圖示
		}*/
		//會加工成IitemDisplay 可調用圖像與DATA
	}
	
}