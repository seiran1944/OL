package MVCprojectOL.ModelOL.Vo.Template {
	/**
	 * ...
	 * @author K.J. Aris
	 * this class defines basic variables for "Get" & "Set" VOs
	 * 12.11.08
	 */
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	 
	public class VoTemplate {
		public var _playerID:String = PlayerDataCenter.PlayerID;
		public var _replyDataType:String = "Error : Null";
		public var _token:String = PlayerDataCenter.Token;
		
		public function VoTemplate( _InputReplyDataType:String ) {
			this._replyDataType = _InputReplyDataType;
		}
		
	}//end class
}//end package