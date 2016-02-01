package MVCprojectOL.ModelOL.LibraryModel 
{
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.MVCs.Models.SourceTools.SourceTool;
	import Spark.SoarVision.single.SpriteVision;
	import Spark.SoarVision.VisionCenter;
	import Spark.Utils.GlobalEvent.EventExpress;
	import strLib.proxyStr.ProxyNameLib;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	/**
	 * ...
	 * @author brook
	 */
	public class LibraryUIproxy extends ProxY
	{
		private static var _LibraryUIproxy:LibraryUIproxy;
		private var _SourceProxy:SourceProxy;
		
		private var _LibraryKey:String = "GUI00009_ANI";//圖書館 素材包KEY碼
		private const _LibraryClasses:Vector.<String> = new < String > [ "bg5","NPC","Inform","olBoard","Bookcase","Bins","Workbench","bg51","SkillsBackplane","MakeBtn","CandleR","CandleL","Fire","Light","SkillList","Attack","Guard","Gain","Debuff","Dot","Recovery","Control"];
		private var _ComponentClasses:Object;
		
		private var _TimeoutValue:uint = 30000;//若素材沒有回來 則30秒後逾時處理
		private var _TimeoutID:uint = 0;
		
		public static function GetInstance():LibraryUIproxy {
			return LibraryUIproxy._LibraryUIproxy = ( LibraryUIproxy._LibraryUIproxy == null ) ? new LibraryUIproxy() : LibraryUIproxy._LibraryUIproxy; //singleton pattern
		}
		
		public function LibraryUIproxy() 
		{
			LibraryUIproxy._LibraryUIproxy = this;
			super( ProxyNameLib.Proxy_LibraryUIproxy , this );
			this._SourceProxy = SourceProxy.GetInstance();
		}
		
		private function TerminateModule():void {
			clearTimeout( this._TimeoutID );
			EventExpress.RevokeAddressRequest( this.ComponentReturned );//終結連線事件接收
			LibraryUIproxy._LibraryUIproxy  = null;
		}
		
		override public function onRemovedProxy():void {
			trace("Storage be kill");
			this.TerminateModule();
		}
		
		public function StartLoad( _InputDetailBoardPackKey:String ):void {
			this._LibraryKey = _InputDetailBoardPackKey;
			var _ComponentExist:Boolean = this._SourceProxy.PreloadMaterial( this._LibraryKey );
			//trace( "55555555555555555555555555" , _ComponentExist );
			( _ComponentExist == true ) ? 
				this.SendPackAndClose() //當有素材時，直接將內容物抽出
				:
				this.WaitForComponentReturn();
		}
		
		private function WaitForComponentReturn():void {
			if ( EventExpress.CheckEventRequestStatus( CommandsStrLad.Source_Complete , this.ComponentReturned ) == false ) {
				EventExpress.AddEventRequest( CommandsStrLad.Source_Complete , this.ComponentReturned , this );
				this._TimeoutID = setTimeout( this.OverTimeError , _TimeoutValue , this._LibraryKey );
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
				case this._LibraryKey ://如果是煉金所元件的檔案回來了
						trace( this._LibraryKey , "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<回來了" );
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
			this._ComponentClasses = this.ExtractClasses( this._LibraryKey , this._LibraryClasses );
			this.GetPlayer();//播放器
			this.SendNotify( this._LibraryKey , this._ComponentClasses );
			this.TerminateModule();
		}
		
		//=====================================播放器==============================
		private var _SourceTool:SourceTool;
		
		private var _NPCContainer:SpriteVision;
		private var _aryNPC:Array;
		private function GetPlayer():void
		{
			this._SourceTool = new SourceTool();
			
			var _NPC:MovieClip = new (this._ComponentClasses.NPC as Class);
			var _NPCAry:Array = _SourceTool.GetMovieClipHandler(_NPC);
			this._NPCContainer = new SpriteVision("NPC");
			this._aryNPC = [_NPCAry[0], _NPCAry[1], _NPCAry[2]];
			VisionCenter.GetInstance().AddSinglePlay(this._NPCContainer, this._aryNPC, true, false, false, 150);
		}
		public function GetNPC():SpriteVision
		{
			return this._NPCContainer;
		}
		public function Destroy():void 
		{
			//關閉UI時清除掉容器與播放器的註冊
			VisionCenter.GetInstance().MovieRemove("NPC", true);
		}
	}
}