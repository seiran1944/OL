package MVCprojectOL.ModelOL.Mail {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.06.06.17.06
	 */
	
	import adobe.utils.CustomActions;
	import flash.utils.Dictionary;
	import MVCprojectOL.ControllOL.Mail.MailStrLib;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Equipment.EquipmentProxy;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ModelOL.TipsCenter.TipsLab.TipsDataLab;
	import MVCprojectOL.ModelOL.Vo.MailVo.MailPack;
	import MVCprojectOL.ModelOL.Vo.PlayerEquipment;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	import MVCprojectOL.ModelOL.Vo.PlayerSource;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.MVC.FacadeCenter;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import strLib.proxyStr.ProxyMonsterStr;
	import strLib.proxyStr.ProxyPVEStrList;
		
	//import strLib.commandStr.MailStrLib;
	 
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
		
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	//import MVCprojectOL.ModelOL.Explore.ExploreEvent;
		
	//----------------------------------------------------------------------VOs
	import MVCprojectOL.ModelOL.Vo.MailVo.Mail;
	import MVCprojectOL.ModelOL.Vo.MailVo.Get_Mail;
	import MVCprojectOL.ModelOL.Vo.MailVo.Set_Mail;
	//-------------------------------------------------------------END------VOs
	
	import MVCprojectOL.ModelOL.GameInfomation.PlayerNotifyCenter;
	
	import strLib.proxyStr.ProxyNameLib;
	
	import MVCprojectOL.ControllOL.Mail.MailStrLib;
		
	public class MailProxy extends ProxY {//extends ProxY
		public static const _MailProxyName:String = "Proxy_MailProxy";
		private static var _MailProxy:MailProxy;
		
		private var _Net:AmfConnector = AmfConnector.GetInstance();
		
		private var _Get_Mail:Get_Mail = new Get_Mail();
		
		private var _currentMailList:Array;//Mail
		private var _currentMailListIDIndex:Dictionary;
		
		private var _TipsDataLab:TipsDataLab;
		
		public static function GetInstance():MailProxy {
			return MailProxy._MailProxy ||= new MailProxy(); //singleton pattern
		}
		
		public function MailProxy() {
			//constructor
			super( MailProxy._MailProxyName , this );
			MailProxy._MailProxy = this;
			this._TipsDataLab = TipsDataLab.GetTipsData();
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			trace( "MailProxy constructed !!" );
		}
		
		private function Terminate():void {
			EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			MailProxy._MailProxy = null;
			this._TipsDataLab = null;
		}
		
		public override function onRemovedProxy():void {
			this.Terminate();
		}
		
		//=========================================================================Actions
		
		public function GetNewMailList( ):void {
			this._Net.VoCall( this._Get_Mail );	//取得信件清單
		}
		
		public function SetMail( _InputMail:Mail , _InputAction:String ):void {	//取得信件物件
			this._Net.VoCall( new Set_Mail( _InputMail , _InputAction ) );//"MailRead" = 讀信  "MailGet" = 收物
		}
		
		public function MailRead( _InputMail:Mail ):void {		//將信件設定為已讀
			if ( _InputMail._isRead == false ) {//還未讀過信件才設為已讀
				_InputMail._isRead = true;
				this.SetMail( _InputMail , "MailRead" );	//"MailRead" = 讀信
			}
			
		}
		
		public function MailGet( _InputMail:Mail ):void {		//將信件設定為已領取
			if ( _InputMail._isReceived == false ) {//沒有領過的才給領
				_InputMail._isReceived = true;
				this.SetMail( _InputMail , "MailGet" );	//"MailGet" = 收物
				
				
				/*if ( _InputMail._mailType == 0 ) {// 0 = 交易賣出(收錢)	1 = 交易逾期(收物品)	 2= 系統信件	
					this.AddMoney( _InputMail.realPrice );
				}*/
				
			}
			
		}
		
		private function AddMoney( _InputNumber:uint ):void {
			PlayerDataCenter.addMoney( _InputNumber );
		}
		//================================================================END======Actions
		
		
		
		//=====================================================================Net message transport router
		private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			switch ( _Result.Status ) {
				
				case "MailList" :		//取得信件資料 (資料將會是有效信件)
						this.DeserializeMailList( _NetResultPack._result as Array );//Mail
						this.SendNotify( MailStrLib.MailListReturned , this._currentMailList );
					break;
					
				case "MailGet" :	//領取的獎勵資料回來時
						//_NetResultPack._result 內會是所獲得的物品ID 或 VO 	// 0 = 交易賣出(收錢)VO		1 = 交易逾期(收物品)ID	 	2= 系統信件	VO
						this.DeserializeAttachment( _NetResultPack._result as MailPack );//拆包裹
						this.SendNotify( MailStrLib.MailContentReturned );
					break;
					
				case "MailRead" :	//讀信
						//會給BOOLEAN
					break;
					
				default :
						
					break;
				
			}
		}
		//=============================================================END=====Net message transport router
		
		
		
		//======================================================================Condition judges
		private function DeserializeMailList( _InputMailList:Array ):void {
			this._currentMailList = _InputMailList;
			
			this._currentMailListIDIndex ||= new Dictionary();
			var _Length:uint = _InputMailList.length;
			var _currentTarget:Mail;
			for (var i:int = 0; i < _Length; i++) {
				_currentTarget = _InputMailList[ i ];
				this._currentMailListIDIndex[ _currentTarget._guid ] = _currentTarget; // 以Mail Guid為索引建立快尋清單
			}
			trace( "Mail Deserialize Completed" );
			
			//this.MailRead( _InputMailList[ 0 ] );
			//this.MailGet( _InputMailList[ 0 ] );
		}
		
		public function GetMailMessage( _InputMailGuid:String ):String {
			var _MessageContent:String;
			var _currentTarget:Mail = this._currentMailListIDIndex[ _InputMailGuid ];
				switch ( _currentTarget._mailType ) {// 0 = 交易賣出(收錢)	1 = 交易逾期(收物品)	 2= 系統信件	
					case 0 :	// 0 = 交易賣出(收錢)
							//MSG00114_TIP	SHOP_TIP_SOLDOUT
							/*恭喜，您在交易黑市所掛賣的 [PRODUCT] 已經賣出！
							商品訂價為 [PRICE] ，酌收 [TAX]% 手續費為 [SERVICE_CHARGE]
							實得金額為 [MONEY]*/
							
							_MessageContent = this._TipsDataLab.GetTipsDate( "SHOP_TIP_SOLDOUT" );
							_MessageContent = _MessageContent.replace( "[PRODUCT]" , _currentTarget._content._showName );//VO ExchangeGoods
							_MessageContent = _MessageContent.replace( "[PRICE]" , _currentTarget._oriPrice );
							_MessageContent = _MessageContent.replace( "[TAX]" , _currentTarget.taxPercentage );
							_MessageContent = _MessageContent.replace( "[SERVICE_CHARGE]" , _currentTarget.taxPrice );
							_MessageContent = _MessageContent.replace( "[MONEY]" , _currentTarget.realPrice );
						break;
						
					case 1 :  // 1 = 交易逾期(收物品)
							//MSG00115_TIP	SHOP_TIP_REJECT	
							
							/*真遺憾，您在交易黑市所掛賣的 [PRODUCT]
							看來似乎沒有需要的人…請先把它收回去吧！*/
							_MessageContent = this._TipsDataLab.GetTipsDate( "SHOP_TIP_REJECT" );
							_MessageContent = _MessageContent.replace( "[PRODUCT]" , _currentTarget._content._showName );//VO ExchangeGoods
						break;
						
					default : 
						break;
				}
			
			return _MessageContent;
		}
	
		public function GetMailAttachment( _InputMailGuid:String ):ItemDisplay {
			var _Attachment:ItemDisplay;
			var _currentTarget:Mail = this._currentMailListIDIndex[ _InputMailGuid ];
			if ( _currentTarget._content != null ) {
				_Attachment = new ItemDisplay( _currentTarget._content );
				_Attachment.ShowContent();
			}
			
			return _Attachment;
		}
		
		//=============================================================END======Condition judges
		
		private function DeserializeAttachment( _InputMailPack:MailPack ):void {
			//_InputMailPack._MailPackType// 0 = 交易賣出(收錢)VO		1 = 交易逾期(收物品)ID	 	2= 系統信件	VO+
						if ( _InputMailPack._content is PlayerMonster ) {
							var _MonsterProxy:MonsterProxy = FacadeCenter.GetFacadeCenter().GetProxy( ProxyMonsterStr.MONSTER_PROXY ) as MonsterProxy;
								_MonsterProxy.AddMonster( [ _InputMailPack._content as PlayerMonster ] );//回寫新獲得的怪物至資訊中心
						}
						
						if ( _InputMailPack._content is PlayerSource ) {
							UserSourceCenter.GetUserSourceCenter().AddSource( [ _InputMailPack._content as PlayerSource ] );//回寫新獲得的素材至資料中心
						}
						
						if ( _InputMailPack._content is PlayerEquipment ) {
							//UserSourceCenter.GetUserSourceCenter().AddSource( [ _InputMailPack._content as PlayerSource ] );//回寫新獲得的素材至資料中心
							var _EquipmentProxy:EquipmentProxy = FacadeCenter.GetFacadeCenter().GetProxy( ProxyPVEStrList.EQUIPMENT_PROXY ) as EquipmentProxy;
								_EquipmentProxy.AddEquipment( [ _InputMailPack._content as PlayerEquipment ] );
						}
						
		}
		
		
		
		
		//====================================================================================Send message    這些應該要在控制器中聽 並做出對應動作 130205
		
	
		//==========================================================================END=======Send message
		
		
		
		
		
		
		
		
		
		
	}//end class

}//end package