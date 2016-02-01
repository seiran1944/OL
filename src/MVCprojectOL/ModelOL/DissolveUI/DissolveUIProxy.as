package MVCprojectOL.ModelOL.DissolveUI 
{
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.MVCs.Models.SourceTools.SourceTool;
	import Spark.SoarVision.single.BitmapVision;
	import Spark.SoarVision.single.SpriteVision;
	import Spark.SoarVision.VisionCenter;
	import Spark.Utils.GlobalEvent.EventExpress;
	import strLib.proxyStr.ProxyNameLib;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	/**
	 * ...
	 * @author brook
	 */
	public class DissolveUIProxy extends ProxY
	{
		private static var _DissolveProxy:DissolveUIProxy;
		private var _SourceProxy:SourceProxy;
		
		public var _DissolveKey:String = "GUI00006_ANI";//溶解所 素材包KEY碼
		private const _DissolveClasses:Vector.<String> = new < String > [ "bg2" , "BigFireBoiler", "FireBoiler" , "Boiler" , "olBoard", "DialogBox","DataErrorDialog","LowerDialog","NPC","TimeBar"];
		private var _ComponentClasses:Object;
		
		private var _TimeoutValue:uint = 30000;//若素材沒有回來 則30秒後逾時處理
		private var _TimeoutID:uint = 0;
		
		public static function GetInstance():DissolveUIProxy {
			return DissolveUIProxy._DissolveProxy = ( DissolveUIProxy._DissolveProxy == null ) ? new DissolveUIProxy() : DissolveUIProxy._DissolveProxy; //singleton pattern
		}
		
		public function DissolveUIProxy() 
		{
			DissolveUIProxy._DissolveProxy = this;
			super( ProxyNameLib.Proxy_DissolveProxy , this );
			this._SourceProxy = SourceProxy.GetInstance();
		}
		
		private function TerminateModule():void {
			clearTimeout( this._TimeoutID );
			EventExpress.RevokeAddressRequest( this.ComponentReturned );//終結連線事件接收
			DissolveUIProxy._DissolveProxy = null;
		}
		
		
		override public function onRemovedProxy():void {
			trace("Dissolve be kill");
			this.TerminateModule();
		}
		
		
		public function StartLoad( _InputDetailBoardPackKey:String ):void {
			this._DissolveKey = _InputDetailBoardPackKey;
			var _ComponentExist:Boolean = this._SourceProxy.PreloadMaterial( this._DissolveKey );
			trace( "55555555555555555555555555" , _ComponentExist );
			( _ComponentExist == true ) ? 
				this.SendPackAndClose() //當有素材時，直接將內容物抽出
				:
				this.WaitForComponentReturn();
		}
		
		private function WaitForComponentReturn():void {
			if ( EventExpress.CheckEventRequestStatus( CommandsStrLad.Source_Complete , this.ComponentReturned ) == false ) {
				EventExpress.AddEventRequest( CommandsStrLad.Source_Complete , this.ComponentReturned , this );
				this._TimeoutID = setTimeout( this.OverTimeError , _TimeoutValue , this._DissolveKey );
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
				case this._DissolveKey ://如果是溶解所元件的檔案回來了
						//trace( this._DissolveKey , "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<回來了" );
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
			this._ComponentClasses = this.ExtractClasses( this._DissolveKey , this._DissolveClasses );
			this.GetBigFireBoiler();
			this.SendNotify( this._DissolveKey , this._ComponentClasses );
			
			/*var _dic:Dictionary = ProjectOLFacade.GetFacadeOL().GetObserver();
				for (var i:String in _dic) {
				 trace("Dissolve>>>" + i);	
				}*/
			this.TerminateModule();
		}
		
		//=====================================火焰鍋爐播放器==============================
		
		private var _SourceTool:SourceTool;
		private var _fireContainer:BitmapVision;
		private var _aryFire:Array;
		
		private var _FireBoilerContainer:Vector.<SpriteVision>=new Vector.<SpriteVision>;
		private var _aryFireBoiler:Array;
		
		private var _NPCContainer:BitmapVision;
		private var _aryNPC:Array;
		
		public function GetBigFireBoiler():void
		{
			_SourceTool = new SourceTool();
			
			var _BigBoiler:MovieClip = new (this._ComponentClasses.BigFireBoiler as Class);
			var _BigBoilerAry:Array = _SourceTool.GetMovieClipHandler(_BigBoiler);
			this._fireContainer = new BitmapVision("fireShow");
			this._aryFire = [_BigBoilerAry[0], _BigBoilerAry[1], _BigBoilerAry[2]];
			VisionCenter.GetInstance().AddSinglePlay(this._fireContainer, this._aryFire, true, false, false, 100);
			
			
			var _FireBoiler:MovieClip = new (this._ComponentClasses.FireBoiler as Class);
			var _FireBoilerAry:Array = _SourceTool.GetMovieClipHandler(_FireBoiler);
			for (var i:int = 0; i <6 ; i++) 
			{
				this._FireBoilerContainer[i] = new SpriteVision("FireBoiler"+i);
				this._aryFireBoiler = [_FireBoilerAry[0], _FireBoilerAry[1], _FireBoilerAry[2]];
				VisionCenter.GetInstance().AddSinglePlay(this._FireBoilerContainer[i], this._aryFireBoiler, true, false, false, 100);
			}
			
			var _NPC:MovieClip = new (this._ComponentClasses.NPC as Class);
			var _NPCAry:Array = _SourceTool.GetMovieClipHandler(_NPC);
			this._NPCContainer = new BitmapVision("NPC");
			this._aryNPC = [_NPCAry[0], _NPCAry[1], _NPCAry[2]];
			VisionCenter.GetInstance().AddSinglePlay(this._NPCContainer, this._aryNPC, true, false, false, 120);
		}
		public function GetFireBigBoiler():BitmapVision
		{
			return this._fireContainer;
		}
		public function GetFireBoiler():Vector.<SpriteVision>
		{
			return this._FireBoilerContainer;
		}
		public function GetNPC():BitmapVision
		{
			return this._NPCContainer;
		}
		public function Destroy():void 
		{
			//關閉UI時清除掉容器與播放器的註冊
			VisionCenter.GetInstance().MovieRemove("fireShow", true);
			VisionCenter.GetInstance().MovieRemove("FireBoiler", true);
			VisionCenter.GetInstance().MovieRemove("NPC", true);
		}
	}

}