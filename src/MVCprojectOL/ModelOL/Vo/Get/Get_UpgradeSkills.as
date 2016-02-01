package MVCprojectOL.ModelOL.Vo.Get {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.06.14.14.14
	 */
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	 
	registerClassAlias( "Get_UpgradeSkills" , Get_UpgradeSkills );
	public final class Get_UpgradeSkills extends VoTemplate{
		/*public var _playerID:String = PlayerDataCenter.PlayerID;
		public var _replyDataType:String = "UpgradeSkills";
		public var _token:String = PlayerDataCenter.Token;*/
		
		public function Get_UpgradeSkills() {
			super( "UpgradeSkills" );
		}
		
	}//end class
}//end package