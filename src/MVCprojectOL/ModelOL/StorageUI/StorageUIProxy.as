package MVCprojectOL.ModelOL.StorageUI 
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.Utils.GlobalEvent.EventExpress;
	import strLib.proxyStr.ProxyNameLib;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	/**
	 * ...
	 * @author brook
	 */
	public class StorageUIProxy extends ProxY
	{
		private static var _StorageUIProxy:StorageUIProxy;
		private var _SourceProxy:SourceProxy;
		
		private var _StorageKey:String = "GUI00007_ANI";//儲藏室 素材包KEY碼
		private const _StorageClasses:Vector.<String> = new < String > [ "NPC" , "TabS" , "TabM" , "IconBox", "DialogBox","Bins","Box1","Box2","bg3","Magic","Weapon","Armor","Accessories","Drug","Material","Inform","MakeBtn"];
		private var _ComponentClasses:Object;
		
		private var _TimeoutValue:uint = 30000;//若素材沒有回來 則30秒後逾時處理
		private var _TimeoutID:uint = 0;
		
		public static function GetInstance():StorageUIProxy {
			return StorageUIProxy._StorageUIProxy = ( StorageUIProxy._StorageUIProxy == null ) ? new StorageUIProxy() : StorageUIProxy._StorageUIProxy; //singleton pattern
		}
		
		public function StorageUIProxy() 
		{
			StorageUIProxy._StorageUIProxy = this;
			super( ProxyNameLib.Proxy_StorageUIProxy , this );
			this._SourceProxy = SourceProxy.GetInstance();
		}
		
		private function TerminateModule():void {
			clearTimeout( this._TimeoutID );
			EventExpress.RevokeAddressRequest( this.ComponentReturned );//終結連線事件接收
			StorageUIProxy._StorageUIProxy = null;
		}
		
		override public function onRemovedProxy():void {
			trace("Storage be kill");
			this.TerminateModule();
		}
		
		public function StartLoad( _InputDetailBoardPackKey:String ):void {
			this._StorageKey = _InputDetailBoardPackKey;
			var _ComponentExist:Boolean = this._SourceProxy.PreloadMaterial( this._StorageKey );
			trace( "55555555555555555555555555" , _ComponentExist );
			( _ComponentExist == true ) ? 
				this.SendPackAndClose() //當有素材時，直接將內容物抽出
				:
				this.WaitForComponentReturn();
		}
		
		private function WaitForComponentReturn():void {
			if ( EventExpress.CheckEventRequestStatus( CommandsStrLad.Source_Complete , this.ComponentReturned ) == false ) {
				EventExpress.AddEventRequest( CommandsStrLad.Source_Complete , this.ComponentReturned , this );
				this._TimeoutID = setTimeout( this.OverTimeError , _TimeoutValue , this._StorageKey );
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
				case this._StorageKey ://如果是儲藏室元件的檔案回來了
						trace( this._StorageKey , "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<回來了" );
						clearTimeout( this._TimeoutID );//移除連線逾時服務
						EventExpress.RevokeAddressRequest( this.ComponentReturned );//移除素材回應服務
						this.SendPackAndClose();
					break;
				
				default :
					break;
				
			}
		}//end ComponentReturned
		
		private function ExtractClasses( _InputKey:String , _InputClass:Vector.<String> ):Object {
			return this._SourceProxy.GetMaterialSWP( _InputKey , _InputClass );
		}
		
		private function SendPackAndClose():void {
			this._ComponentClasses = this.ExtractClasses( this._StorageKey , this._StorageClasses );
			this.SendNotify( this._StorageKey , this._ComponentClasses );
			/*var _dic:Dictionary = ProjectOLFacade.GetFacadeOL().GetObserver();
				for (var i:String in _dic) {
				 trace("Dissolve>>>" + i);	
				}*/
			this.TerminateModule();
		}
	}

}