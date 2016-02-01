package MVCprojectOL.ModelOL.JailModel 
{
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.MVCs.Models.SourceTools.SourceTool;
	import Spark.SoarVision.single.BitmapVision;
	import Spark.SoarVision.VisionCenter;
	import Spark.Utils.GlobalEvent.EventExpress;
	import strLib.proxyStr.ProxyNameLib;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	/**
	 * ...
	 * @author brook
	 */
	public class JailUIproxy extends ProxY
	{
		private static var _JailUIproxy:JailUIproxy;
		private var _SourceProxy:SourceProxy;
		
		private var _JailKey:String = "GUI00012_ANI";//牢房 素材包KEY碼
		private const _JailClasses:Vector.<String> = new < String > [ "Board", "CrossBar", "StopBtn", "MoveBar", "Fire", "JailNPC", "TortureNPC"];
		private var _ComponentClasses:Object;
		
		private var _TimeoutValue:uint = 30000;//若素材沒有回來 則30秒後逾時處理
		private var _TimeoutID:uint = 0;
		
		public static function GetInstance():JailUIproxy {
			return JailUIproxy._JailUIproxy = ( JailUIproxy._JailUIproxy == null ) ? new JailUIproxy() : JailUIproxy._JailUIproxy; //singleton pattern
		}
		
		public function JailUIproxy() 
		{
			JailUIproxy._JailUIproxy = this;
			super( ProxyNameLib.Proxy_AlchemyUIproxy , this );
			this._SourceProxy = SourceProxy.GetInstance();
		}
		
		private function TerminateModule():void {
			clearTimeout( this._TimeoutID );
			EventExpress.RevokeAddressRequest( this.ComponentReturned );//終結連線事件接收
			JailUIproxy._JailUIproxy  = null;
		}
		
		override public function onRemovedProxy():void {
			this.TerminateModule();
		}
		
		public function StartLoad( _InputDetailBoardPackKey:String ):void {
			this._JailKey = _InputDetailBoardPackKey;
			var _ComponentExist:Boolean = this._SourceProxy.PreloadMaterial( this._JailKey );
			( _ComponentExist == true ) ? 
				this.SendPackAndClose() //當有素材時，直接將內容物抽出
				:
				this.WaitForComponentReturn();
		}
		
		private function WaitForComponentReturn():void {
			if ( EventExpress.CheckEventRequestStatus( CommandsStrLad.Source_Complete , this.ComponentReturned ) == false ) {
				EventExpress.AddEventRequest( CommandsStrLad.Source_Complete , this.ComponentReturned , this );
				this._TimeoutID = setTimeout( this.OverTimeError , _TimeoutValue , this._JailKey );
			}
			
		}//end WaitForComponentReturn
		
		private function OverTimeError( _InputInvalidKey:String ):void {
			clearTimeout( this._TimeoutID );
			EventExpress.RevokeAddressRequest( this.ComponentReturned );
			this.SendNotify( _InputInvalidKey + "Invaild" );
		}
		
		private function ComponentReturned( _Result:EventExpressPackage ):void {
			switch( _Result.Status ) {
				case this._JailKey ://如果是煉金所元件的檔案回來了
						trace( this._JailKey , "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<回來了" );
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
			this._ComponentClasses = this.ExtractClasses( this._JailKey , this._JailClasses );
			this.GetPlayer();//播放器
			this.SendNotify( this._JailKey , this._ComponentClasses );
			this.TerminateModule();
		}
		
		//=====================================播放器==============================
		
		private var _SourceTool:SourceTool;
		
		private var _FireContainer:BitmapVision;
		private var _aryFire:Array;
		
		private function GetPlayer():void
		{
			this._SourceTool = new SourceTool();
			
			var _Fire:MovieClip = new (this._ComponentClasses.Fire as Class);
			var _FireAry:Array = _SourceTool.GetMovieClipHandler(_Fire);
			this._FireContainer = new BitmapVision("Fire");
			this._aryFire = [_FireAry[0], _FireAry[1], _FireAry[2]];
			VisionCenter.GetInstance().AddSinglePlay(this._FireContainer, this._aryFire, true, false, false, 100);
		}
		
		public function GetFire():BitmapVision
		{
			return this._FireContainer;
		}
		
		public function Destroy():void 
		{
			//關閉UI時清除掉容器與播放器的註冊
			VisionCenter.GetInstance().MovieRemove("Fire", true);
		}
		
	}

}