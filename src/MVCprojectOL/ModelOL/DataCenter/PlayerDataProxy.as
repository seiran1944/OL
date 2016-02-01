package MVCprojectOL.ModelOL.DataCenter {
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 * 這個ProxY在撈取玩家數值後即拋棄  所有數值將儲存在 PlayerDataCenter.as
	 * 
	 * 121106
	 */
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import strLib.proxyStr.ProxyNameLib;
	 
	 
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	 
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	 
	//-----------------------------VOs
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerData;
	import MVCprojectOL.ModelOL.Vo.PlayerData;
	//-----------------------------VOs
	import strLib.proxyStr.ProxyNameLib;
	//import Spark.CommandsStrLad;
	 
	import MVCprojectOL.ModelOL.DataCenter.DataCenterEvent;
	 
	public class PlayerDataProxy extends ProxY{
		private static var _PlayerDataProxy:PlayerDataProxy;
		
		private var _CurrentPlayerData:PlayerData;
		
		private var _Net:AmfConnector = AmfConnector.GetInstance();
		
		public static function GetInstance():PlayerDataProxy {
			return PlayerDataProxy._PlayerDataProxy = ( PlayerDataProxy._PlayerDataProxy == null ) ? new PlayerDataProxy() : PlayerDataProxy._PlayerDataProxy; //singleton pattern
		}
		
		public function PlayerDataProxy() {
			super( ProxyNameLib.Proxy_PlayerDataProxy , this );
			PlayerDataProxy._PlayerDataProxy = this;
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			this.GetPlayerData();
		}
		
		private function TerminateModule():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			this.SendNotify( DataCenterEvent.Terminate_PlayerDataProxy );
			//PlayerDataProxy._PlayerDataProxy = null;
		}
		
		public function GetPlayerData():void {
			this._Net.VoCall( new Get_PlayerData() );
			//this._Net.Call( "new Get_PlayerData()" );//取得玩家資料
			trace("new Get_PlayerData()--------------------------------------------------------------");
		}
		
		//=====================================================================Net message transport router
		private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );
			
			switch ( _Result.Status ) {
				
				case "PlayerData" ://
					trace("_result0301_________"+_NetResultPack._result);	
					this._CurrentPlayerData = _NetResultPack._result as PlayerData;
						
						
						this.DeserializePlayerData( this._CurrentPlayerData  );
						this.TerminateModule();
					break;
					
				default :
					break;
				
			}
		}
		//=============================================================END=====Net message transport router
		
		private function DeserializePlayerData( _InputPlayerData:PlayerData ):void {
			//該function將VO數值回寫資訊中心
			/*PlayerDataCenter.PlayerName = _InputPlayerData._PlayerName;
			
			PlayerDataCenter.addSoul( _InputPlayerData._PlayerSoul );//保護機制  無法直接設定值 見PlayerDataCenter
			PlayerDataCenter.addMoney( _InputPlayerData._PlayerMony );//保護機制  無法直接設定值 見PlayerDataCenter
			
			PlayerDataCenter.addFur( _InputPlayerData._PlayerFur );
			PlayerDataCenter.addStone( _InputPlayerData._PlayerStone ); 
			PlayerDataCenter.addWood( _InputPlayerData._PlayerWood );
			
			PlayerDataCenter.SoundEffectSetting = _InputPlayerData._SoundEffectSetting;
			PlayerDataCenter.SoundEffectValue = _InputPlayerData._SoundEffectValue;
			
			PlayerDataCenter.BGMusicSetting = _InputPlayerData._BGMusicSetting;
			PlayerDataCenter.BGMusicValue = _InputPlayerData._BGMusicValue;
			
			PlayerDataCenter._FontKey = _InputPlayerData._FontKey;
			PlayerDataCenter._MonsterExhaustLimit = _InputPlayerData._MonsterExhaustLimit;
			PlayerDataCenter._LoadingBgKey = _InputPlayerData._LoadingBgKey;*/
			//----playerData connect call backc--------
			trace("serverBack0301____" + _InputPlayerData);
			trace("serverBack0301____playData0301>>"+_InputPlayerData._loadingBgKey);
			PlayerDataCenter.WritePlayerData( _InputPlayerData );
			//trace( _InputPlayerData , "<---------------------------------------------" );
		}
		
		
	}//end class
}//end package