package MVCprojectOL.ModelOL.Vo.MailVo {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.28.17.06
	 */
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import MVCprojectOL.ModelOL.Vo.MailVo.Mail;
	
	
	registerClassAlias( "Get_Mail" , Get_Mail );
	registerClassAlias( "Mail" , Mail );
	
	public class Get_Mail extends VoTemplate{
		//取得新的路徑節點
		
		public function Get_Mail( ) {
			super( "MailList" );
		}
		
	}//end class
}//end package