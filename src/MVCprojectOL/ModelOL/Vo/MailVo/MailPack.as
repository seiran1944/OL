package MVCprojectOL.ModelOL.Vo.MailVo 
{
	import MVCprojectOL.ModelOL.Vo.ExchangeGoods;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.06.07.14.04
	 */
	public class MailPack {
		public var _guid:String;//來源信件的ID
		
		public var _MailPackType:uint;	//來源信件的類型 0 = 交易賣出(收錢)	1 = 交易逾期(收物品)	 2= 系統信件	
		
		public var _content:*;//所夾帶的附加檔 VO  PlayerMonster 魔晶石 道具 或 ID String(當_MailPackType == 1)
		
		public function MailPack() {
			
		}
		
		
		
		
	}//end class
}//end package