package MVCprojectOL.ModelOL.Vo.Set 
{
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	 
	public class Set_GuideReadRecord extends VoTemplate{
		public var _Guid:String;
		public var _Read:Boolean;
		//public var _ReplyDataType:String = "null";
		
		public function Set_GuideReadRecord( _InputGuid:String , _InputRead:Boolean ) {
			this._Guid = _InputGuid;
			this._Read = _InputRead;
			super( "Set_GuideReadRecord_NoReply" );
		}
		
	}//end class
}//end package