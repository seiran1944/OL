package MVCprojectOL.ModelOL.Vo.MailVo 
{
	import MVCprojectOL.ModelOL.Vo.ExchangeGoods;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.06.07.14.35
	 */
	public class Mail {
		public var _guid:String;//信件ID
		
		public var _title:String;//信件標題
		public var _info:String;//信件內文 的 Key
		
		public var _isRead:Boolean;//是否已讀
		public var _isReceived:Boolean;//有沒有領取
		public var _mailType:uint;	// 0 = 交易賣出(收錢)	1 = 交易逾期(收物品)	 2= 系統信件	
		//public var _isSold:Boolean; //是否賣出 true = 賣出(通知掛賣所得)		false = 未賣出(通知掛賣超過期限) 會影響TITLE 與 內文
		public var _date:String;//寄送日期  年月日時分
		
		public var _content:ExchangeGoods;//所夾帶的附加檔 Monster 魔晶石 道具
		
		public var _oriPrice:uint;//商品原定價
		public var _taxRate:Number;//成交時的稅率
		
		
		//由Client DataCenter計算過後再塞回
		/*public var _taxPercentage:String;
		public var _taxPrice:uint;
		public var _realPrice:uint;*/
		
		//public var _itemName:String;
		
		
		public function Mail() {
			
		}
		
		public function get taxPercentage():uint {
			return uint( this._taxRate * 100 );
		}
		
		public function get taxPrice():uint {
			return uint( Math.ceil( this._oriPrice * this._taxRate ) );
		}
		
		public function get realPrice():uint {
			return uint( this._oriPrice - this.taxPrice );
		}
		
		
		
	}//end class
}//end package