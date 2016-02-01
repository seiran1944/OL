package MVCprojectOL.ModelOL.ViewSharedModel 
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
	public class ViewSharedModel extends ProxY
	{
		private var _SourceProxy:SourceProxy;
		private static var _ViewSharedModel:ViewSharedModel;
		
		private var _TimeoutValue:uint = 30000;//若素材沒有回來 則30秒後逾時處理
		private var _TimeoutID:uint = 0;
		
		public var _SharedKey:String;// 素材包KEY碼
		public var _SharedClasses:Vector.<String>;
		private var _ComponentClasses:Object;
		
		public static function GetInstance():ViewSharedModel {
			return ViewSharedModel._ViewSharedModel = ( ViewSharedModel._ViewSharedModel == null ) ? new ViewSharedModel() : ViewSharedModel._ViewSharedModel; //singleton pattern
		}
		
		public function ViewSharedModel() 
		{
			ViewSharedModel._ViewSharedModel = this;
			super( ProxyNameLib.Proxy_SharedUIproxy, this);
			this._SourceProxy = SourceProxy.GetInstance();
		}
		
		private function TerminateModule():void {
			clearTimeout( this._TimeoutID );
			EventExpress.RevokeAddressRequest( this.ComponentReturned );//終結連線事件接收
			ViewSharedModel._ViewSharedModel  = null;
		}
		
		override public function onRemovedProxy():void {
			this.TerminateModule();
		}
		
		public function StartLoad( _InputDetailBoardPackKey:String ):void {
			this._SharedKey = _InputDetailBoardPackKey;
			var _ComponentExist:Boolean = this._SourceProxy.PreloadMaterial( this._SharedKey );
			( _ComponentExist == true ) ? 
				this.SendPackAndClose() //當有素材時，直接將內容物抽出
				:
				this.WaitForComponentReturn();
		}
		
		private function WaitForComponentReturn():void {
			if ( EventExpress.CheckEventRequestStatus( CommandsStrLad.Source_Complete , this.ComponentReturned ) == false ) {
				EventExpress.AddEventRequest( CommandsStrLad.Source_Complete , this.ComponentReturned , this );
				this._TimeoutID = setTimeout( this.OverTimeError , _TimeoutValue , this._SharedKey );
			}
		}
		
		private function OverTimeError( _InputInvalidKey:String ):void {
			clearTimeout( this._TimeoutID );
			EventExpress.RevokeAddressRequest( this.ComponentReturned );
			//trace( "'" , _InputInvalidKey , "' respond Timeout !! From MonsterDisplay" );
			this.SendNotify( _InputInvalidKey + "Invaild" );
		}
		
		private function ComponentReturned( _Result:EventExpressPackage ):void {
			switch( _Result.Status ) {
				case this._SharedKey ://如果是煉金所元件的檔案回來了
						clearTimeout( this._TimeoutID );//移除連線逾時服務
						EventExpress.RevokeAddressRequest( this.ComponentReturned );//移除素材回應服務
						this.SendPackAndClose();
					break;
				default :
					break;
			}
		}
		
		private function ExtractClasses( _InputKey:String , _InputClass:Vector.<String> ):Object {
			return this._SourceProxy.GetMaterialSWP( _InputKey , _InputClass );
		}
		
		private function SendPackAndClose():void {
			this._ComponentClasses = this.ExtractClasses( this._SharedKey , this._SharedClasses );
			//this.GetPlayer();//播放器
			this.SendNotify( this._SharedKey , this._ComponentClasses );
			this.TerminateModule();
		}
		
	}
}