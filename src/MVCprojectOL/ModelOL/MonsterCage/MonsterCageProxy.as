package MVCprojectOL.ModelOL.MonsterCage {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	

	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	 
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
		
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	//import MVCprojectOL.ModelOL.Explore.ExploreEvent;
		
	//----------------------------------------------------------------------VOs


	
	//-------------------------------------------------------------END------VOs
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	
	import strLib.proxyStr.ProxyNameLib;
		
	public class MonsterCageProxy extends ProxY {//extends ProxY
		
		private static var _MonsterCageProxy:MonsterCageProxy;
		
		//private var _Net:AmfConnector = AmfConnector.GetInstance();
		private var _SourceProxy:SourceProxy;
		
		
		private var _DetailBoardPackKey:String = "GUI00005_ANI";//怪物詳細資訊底板 素材包KEY碼
		private const _DetailBoardClassName:String = "DetailBoard";
		private var _ComponentClasses:Class;
		
		private var _TimeoutValue:uint = 30000;//若素材沒有回來 則30秒後逾時處理
		private var _TimeoutID:uint = 0;
		
		public static function GetInstance():MonsterCageProxy {
			return MonsterCageProxy._MonsterCageProxy = ( MonsterCageProxy._MonsterCageProxy == null ) ? new MonsterCageProxy() : MonsterCageProxy._MonsterCageProxy; //singleton pattern
		}
		
		public function MonsterCageProxy() {
			//constructor
			MonsterCageProxy._MonsterCageProxy = this;
			super( ProxyNameLib.Proxy_MonsterCageProxy , this );
			//EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			this._SourceProxy = SourceProxy.GetInstance();
			trace( "MonsterCageProxy constructed !!" );
		}
		
		
		
		private function TerminateModule():void {
			clearTimeout( this._TimeoutID );
			EventExpress.RevokeAddressRequest( this.ComponentReturned );//終結連線事件接收
			MonsterCageProxy._MonsterCageProxy = null;
		}
		
		
		override public function onRemovedProxy():void {
			trace("monster be kill");
			this.TerminateModule();
		}
		//=====================================================================Net message transport router
		/*private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );
			switch ( _Result.Status ) {
				
				case "" ://
						
					break;
					
					
				default :
					break;
				
			}
		}*/
		//=============================================================END=====Net message transport router
		
		
		//=========================================================================Actions
		public function StartLoad( _InputDetailBoardPackKey:String ):void {
			this._DetailBoardPackKey = _InputDetailBoardPackKey;
			var _ComponentExist:Boolean = this._SourceProxy.PreloadMaterial( this._DetailBoardPackKey );
			
			( _ComponentExist == true ) ? 
				this.SendPackAndClose() //當有素材時，直接將內容物抽出
				:
				this.WaitForComponentReturn();
		}
		
		private function WaitForComponentReturn():void {
			
			if ( EventExpress.CheckEventRequestStatus( CommandsStrLad.Source_Complete , this.ComponentReturned ) == false ) {
				EventExpress.AddEventRequest( CommandsStrLad.Source_Complete , this.ComponentReturned , this );
				this._TimeoutID = setTimeout( this.OverTimeError , _TimeoutValue , this._DetailBoardPackKey );
			}
			
		}//end WaitForComponentReturn
		
		private function OverTimeError( _InputInvalidKey:String ):void {
			clearTimeout( this._TimeoutID );
			EventExpress.RevokeAddressRequest( this.ComponentReturned );
			trace( "'" , _InputInvalidKey , "' respond Timeout !! From MonsterDisplay" );
			this.SendNotify( _InputInvalidKey + "Invaild" );
		}
		
		private function ComponentReturned( _Result:EventExpressPackage ):void {
			switch( _Result.Status ) {
				case this._DetailBoardPackKey ://如果是怪物詳細資訊底板的檔案回來了
						trace( this._DetailBoardPackKey , "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<回來了" );
						clearTimeout( this._TimeoutID );//移除連線逾時服務
						EventExpress.RevokeAddressRequest( this.ComponentReturned );//移除素材回應服務
						this.SendPackAndClose();
					break;
				
				default :
					break;
				
			}
		}//end ComponentReturned
		
		private function ExtractClasses( _InputKey:String , _InputClass:String ):Class {
			return this._SourceProxy.GetMaterialSWP( _InputKey , _InputClass );
		}
		
		
		private function SendPackAndClose():void {
			this._ComponentClasses = this.ExtractClasses( this._DetailBoardPackKey , this._DetailBoardClassName );
			var _SendingPack:Object = new Object();
				_SendingPack[ this._DetailBoardClassName ] = this._ComponentClasses;
			this.SendNotify( this._DetailBoardPackKey , _SendingPack );
			var _dic:Dictionary = ProjectOLFacade.GetFacadeOL().GetObserver();
			   //var _Boolean:Boolean=Observer(_dic[CommandsStrLad.Source_Complete][0]).CehckObserver(CatchSystemCore)
			    //var _Boolean:int = _dic[CommandsStrLad.Source_Complete].length;
			
			    //var _obj:Object = Observer(_dic["Source_Complete"][0]).GetCheckName();
				for (var i:String in _dic) {
				 trace("monster>>>" + i);	
					
				}
			TerminateModule();
		}
		//================================================================END======Actions
		
		
		
		
		
		
		
		//======================================================================Condition judges
		
	
		
		
		//=============================================================END======Condition judges
		
		
		
		
		
		
		//====================================================================================Send message
		
	
		//==========================================================================END=======Send message
		
		
		
		
		
		
		
		
		
		
	}//end class

}//end package