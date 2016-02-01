package Spark.MVCs.Models.NetWork.GroupCall {
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 * @version 12.11.23.11.52
	 */
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	 
	public class Get_ResultGroup extends VoTemplate{
		
		/*public var _PlayerID:String = PlayerDataCenter.PlayerID;
		public var _ReplyDataType:String = "Error : Null";
		public var _Token:String = PlayerDataCenter.Token;*/
		
		public var _requestQueue:Array = [];//存放動作Vo
		
		public function Get_ResultGroup() {
			super( "NetResultPackGroup" );
		}
		
		public function AddRequest( _InputRequestVo:* ):void {
			this._requestQueue.push( _InputRequestVo );
			//trace( _InputRequestVo , "------------------------------------------" );
		}
		
	}//end class

}//end package