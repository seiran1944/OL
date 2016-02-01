package MVCprojectOL.ModelOL.GameInfomation {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import MVCprojectOL.ModelOL.GameInfomation.PlayerNotification;
		
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	 
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
	
	public class PlayerNotifyCenter {//extends ProxY
		private static var _PlayerNotifyCenter:PlayerNotifyCenter;
		private var _PlayerNotificationQueue:Vector.<PlayerNotification> = new Vector.<PlayerNotification>();
		private var _Instant:Boolean = true;
		
		public static function GetInstance():PlayerNotifyCenter {
			return PlayerNotifyCenter._PlayerNotifyCenter = ( PlayerNotifyCenter._PlayerNotifyCenter == null ) ? new PlayerNotifyCenter() : PlayerNotifyCenter._PlayerNotifyCenter; //singleton pattern
		}
		
		public function PlayerNotifyCenter() {
			PlayerNotifyCenter._PlayerNotifyCenter = this;
		}
		
		public function NewNotify( _InputPlayerNotification:PlayerNotification ):void {
			this._PlayerNotificationQueue.push( _InputPlayerNotification );
		}
		
		
		public function CheckNotify():void {
			this.SendSingleNotifucation();//這個function必須在訊息介面被關閉後重複被呼叫
		}
		
		private function SendSingleNotifucation():void {
			if ( this._PlayerNotificationQueue.length > 0 ) {
				//this.SendNotify( "OpenPlayerNotify" , this._PlayerNotificationQueue[ 0 ] );
				EventExpress.DispatchGlobalEvent( "OpenPlayerNotify" , null , this._PlayerNotificationQueue[ 0 ] , this );
				this._PlayerNotificationQueue.shift();
			}else {
				return;
			}
		}
		
		
		
		
		
		
		
		//=========================================getter & setter
		public function get Instant():Boolean {
			return _Instant;
		}
		
		public function set Instant( value:Boolean ):void {
			this._Instant = value;
		}
		//=================================END=====getter & setter
		
	}//end class

}//end package