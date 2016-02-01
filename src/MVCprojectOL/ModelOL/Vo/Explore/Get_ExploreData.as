package MVCprojectOL.ModelOL.Vo.Get {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	 
	public class Get_ExploreData extends VoTemplate{
		public var _AreaGuid:String;
		//public var _ReplyDataType:String = "ExploreData";
		public function Get_ExploreData( _InputAreaGuid:String ) {
			this._AreaGuid = _InputAreaGuid;
			super( "ExploreData" );//_ReplyDataType
		}
		
	}//end class
}//end package