package MVCprojectOL.ModelOL.Vo.MailVo {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.28.17.06
	 */
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import MVCprojectOL.ModelOL.Vo.MailVo.Mail;
	import MVCprojectOL.ModelOL.Vo.MailVo.MailPack;
	
	registerClassAlias( "Set_Mail" , Set_Mail );
	registerClassAlias( "MailPack" , MailPack );
	
	public class Set_Mail extends VoTemplate{
		//回傳信件所取得的內容物VO
		
		public var _guid:String;//信件GUID
		
		public function Set_Mail( _InputMail:Mail , _InputAction:String = "MailRead" ) {
			super( _InputAction );//"MailRead" = 讀信  "MailGet" = 收物
			this._guid = _InputMail._guid;
		}
		
	}//end class
}//end package