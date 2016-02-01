package MVCprojectOL.ModelOL.DataCenter {
	/**
	 * ...
	 * @author K.J. Aris
	 * 本段用來集中儲存原始資訊 並發送初始訊息
	 * Note : 該項需為初始化的第一環，須早於其他模組建構
	 * wasted  121102 
	 */
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	 
	import strLib.proxyStr.ProxyNameLib;
	 
	public class PrimitiveDataCenter extends proXy{//extends proXy
		
		private static var _PrimitiveDataCenter:PrimitiveDataCenter;
		private static var _PrimitiveInfoReady:Boolean = false;
		
		private var _PlayerID:String = "Initialization uncompleted !!";
		
		private var _ServGateWay:String = "Initialization uncompleted !!";
		private var _ServDomain:String = "Initialization uncompleted !!";
		
		public static function GetInstance():PrimitiveDataCenter {
			//必須確保該類別不會被重複起始
			return PrimitiveDataCenter._PrimitiveDataCenter = ( PrimitiveDataCenter._PrimitiveDataCenter == null && PrimitiveDataCenter._PrimitiveInfoReady == false ) ? new PlayerDataCenter() : PrimitiveDataCenter._PrimitiveDataCenter; //singleton pattern
		}
		
		public function PrimitiveDataCenter() {
			super( ProxyNameLib.Proxy_PrimitiveDataCenter , this );
			PrimitiveDataCenter._PrimitiveDataCenter = this;
		}
		
		public function InitModule( _InputPlayerID:String , _InputServGateWay:String , _InputServDomain:String ):void {
			
			if ( this._PrimitiveInfoReady == false ) {//必須確保該類別不會被重複起始
				this._PlayerID = _InputPlayerID;
				this._ServGateWay = _InputServGateWay;
				this._ServDomain = _InputServDomain;
				//必要的初始資訊須集中處理
				
				//this.StartInitProcedure();
				PlayerDataCenter.PlayerID = this._PlayerID;//將PlayerID 寫給PlayerDataCenter做紀錄
				PrimitiveDataCenter._PrimitiveInfoReady = true;
			}
			
		}
		
		public static function get PrimitiveInfoReady():Boolean {
			return PrimitiveDataCenter._PrimitiveInfoReady;
		}
		
		public function get PlayerID():String {
			return _PlayerID;
		}
		
		public function get ServGateWay():String {
			return _ServGateWay;
		}
		
		public function get ServDomain():String {
			return _ServDomain;
		}
		
		
		
		
	}//end class
}//end package