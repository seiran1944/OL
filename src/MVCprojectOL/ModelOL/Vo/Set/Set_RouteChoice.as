package MVCprojectOL.ModelOL.Vo.Set {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	 
	public class Set_RouteChoice extends VoTemplate{
		//回寫玩家對路徑的選擇
		public var _SelectedNodeID:String;
		public var _TeamID:String;
		//public var _ReplyDataType:String = "ExploreFightResult";
		
		public function Set_RouteChoice( _InputSelectedNodeID:String , _InputTeamID:String ) {
			this._SelectedNodeID = _InputSelectedNodeID;
			this._TeamID = _InputTeamID;
			super( "ExploreFightResult" );
		}
		
		
	}//end class
}//end package