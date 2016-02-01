package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import flash.net.registerClassAlias;
	registerClassAlias("Set_PvpFighting", Set_PvpFighting);
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 回寫通知點選的對手
	 */
	public class Set_PvpFighting extends VoTemplate
	{
		public var _teamGroup:String;//玩家出征隊伍
		
		public var _competitionId:String;//玩家挑選對手的ID
		public var _place:int;//對手名次
		public var _objMember:Object;//對手隊伍成員提供檢查異動使用
		/*{
			(0 - 8)位置 : 惡魔GUID 
		}*/
		
		
		public function Set_PvpFighting(teamGroup:String,competitionId:String,place:int,member:Object):void 
		{
			super("PvpFightingReport");
			this._teamGroup = teamGroup;
			this._competitionId = competitionId;
			this._place = place;
			this._objMember = member;
		}
		
	}
	
}