package MVCprojectOL.ModelOL.Vo.Explore {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.11.09
	 */
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	//import MVCprojectOL.ModelOL.Vo.RouteNode;
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import MVCprojectOL.ModelOL.Explore.Data.WorldJourneyDataCenter; 
	import MVCprojectOL.ModelOL.Vo.Explore.RouteNode;
	
	
	registerClassAlias( "Get_NewRoute" , Get_NewRoute );
	registerClassAlias( "RouteNode" , RouteNode );
	
	public class Get_NewRoute extends VoTemplate{
		//取得新的路徑節點
		
		/*public var _playerID:String = PlayerDataCenter.PlayerID;
		public var _replyDataType:String = "Error : Null";
		public var _token:String = PlayerDataCenter.Token;*/
		
		//public var _ReplyDataType:String = "RouteNode";//RouteNode Array
		
		
		public var _areaID:String = ExploreDataCenter.GetInstance()._currentSelectedAreaKey;
		public var _teamID:String = ExploreDataCenter.GetInstance()._currentSelectedTeamKey;
		
		public var _type:int = 0; //-1.結束探索 0.沒事, 1.惡魔, 2.寶箱, 3.安全, 4.魔王
		public var _step:uint = 0;
		
		//public var _stepHistory:Array;
		
		public var _difficulty:uint = WorldJourneyDataCenter.GetInstance()._currentSelectedDifficulty;//所選擇的難易度
		//玩家所選的節點TYPE
		//目前是第幾個節點
		public function Get_NewRoute( _InputStepHistory:Array = null , _InputRouteNode:RouteNode = null ) {
			super( "RouteNode" );
			//this._stepHistory = _InputStepHistory;

			/*if ( _InputRouteNode != null ) {
				this._type = _InputRouteNode._type;
				this._step = _InputRouteNode._step;
			}*/
			
		}
		
	}//end class

}//end package