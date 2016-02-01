package MVCprojectOL.ModelOL.AlchemyModel 
{
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
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
	public class AlchemyUIproxy extends ProxY
	{
		private static var _AlchemyUIproxy:AlchemyUIproxy;
		private var _SourceProxy:SourceProxy;
		
		private var _AlchemyKey:String = "GUI00008_ANI";//煉金所 素材包KEY碼
		private const _AlchemyClasses:Vector.<String> = new < String > [ "bg4" , "TabS" , "TabM" , "ListBoard", "Bins","Weapon","Armor","Accessories","Drug","MakeBtn","Bottle","BoneFire","Cabinet","NPC","DialogBox","BottleS","Workbench","Material"];
		private var _ComponentClasses:Object;
		
		private var _TimeoutValue:uint = 30000;//若素材沒有回來 則30秒後逾時處理
		private var _TimeoutID:uint = 0;
		
		public static function GetInstance():AlchemyUIproxy {
			return AlchemyUIproxy._AlchemyUIproxy = ( AlchemyUIproxy._AlchemyUIproxy == null ) ? new AlchemyUIproxy() : AlchemyUIproxy._AlchemyUIproxy; //singleton pattern
		}
		
		public function AlchemyUIproxy() 
		{
			AlchemyUIproxy._AlchemyUIproxy = this;
			super( ProxyNameLib.Proxy_AlchemyUIproxy , this );
			this._SourceProxy = SourceProxy.GetInstance();
		}
		
		private function TerminateModule():void {
			clearTimeout( this._TimeoutID );
			EventExpress.RevokeAddressRequest( this.ComponentReturned );//終結連線事件接收
			AlchemyUIproxy._AlchemyUIproxy  = null;
		}
		
		override public function onRemovedProxy():void {
			trace("Storage be kill");
			this.TerminateModule();
		}
		
		public function StartLoad( _InputDetailBoardPackKey:String ):void {
			this._AlchemyKey = _InputDetailBoardPackKey;
			var _ComponentExist:Boolean = this._SourceProxy.PreloadMaterial( this._AlchemyKey );
			trace( "55555555555555555555555555" , _ComponentExist );
			( _ComponentExist == true ) ? 
				this.SendPackAndClose() //當有素材時，直接將內容物抽出
				:
				this.WaitForComponentReturn();
		}
		
		private function WaitForComponentReturn():void {
			if ( EventExpress.CheckEventRequestStatus( CommandsStrLad.Source_Complete , this.ComponentReturned ) == false ) {
				EventExpress.AddEventRequest( CommandsStrLad.Source_Complete , this.ComponentReturned , this );
				this._TimeoutID = setTimeout( this.OverTimeError , _TimeoutValue , this._AlchemyKey );
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
				case this._AlchemyKey ://如果是煉金所元件的檔案回來了
						trace( this._AlchemyKey , "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<回來了" );
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
			this._ComponentClasses = this.ExtractClasses( this._AlchemyKey , this._AlchemyClasses );
			this.GetBoneFireBox();//骨頭火焰播放器
			this.SendNotify( this._AlchemyKey , this._ComponentClasses );
			this.TerminateModule();
		}
		
		//=====================================骨頭火焰播放器==============================
		
		private var _SourceTool:SourceTool;
		private var _fireContainer:BitmapVision;
		
		private var _BoneFireContainer:Vector.<BitmapVision> = new Vector.<BitmapVision>;
		private var _aryBoneFire:Array;
		
		private var _NPCContainer:SpriteVision;
		private var _aryNPC:Array;
		
		private function GetBoneFireBox():void
		{
			this._SourceTool = new SourceTool();
			
			var _BoneFire:MovieClip = new (this._ComponentClasses.BoneFire as Class);
			var _BoneFireAry:Array = _SourceTool.GetMovieClipHandler(_BoneFire);
			for (var i:int = 0; i <6 ; i++) 
			{
				this._BoneFireContainer[i] = new BitmapVision("BoneFire"+i);
				this._aryBoneFire = [_BoneFireAry[0], _BoneFireAry[1], _BoneFireAry[2]];
				VisionCenter.GetInstance().AddSinglePlay(this._BoneFireContainer[i], this._aryBoneFire, true, false, false, 100);
			}
			
			var _NPC:MovieClip = new (this._ComponentClasses.NPC as Class);
			var _NPCAry:Array = _SourceTool.GetMovieClipHandler(_NPC);
			this._NPCContainer = new SpriteVision("NPC");
			this._aryNPC = [_NPCAry[0], _NPCAry[1], _NPCAry[2]];
			VisionCenter.GetInstance().AddSinglePlay(this._NPCContainer, this._aryNPC, true, false, false, 150);
		}
		public function GetBoneFire():Vector.<BitmapVision>
		{
			return this._BoneFireContainer;
		}
		public function GetNPC():SpriteVision
		{
			return this._NPCContainer;
		}
		public function Destroy():void 
		{
			//關閉UI時清除掉容器與播放器的註冊
			VisionCenter.GetInstance().MovieRemove("BoneFire", true);
			VisionCenter.GetInstance().MovieRemove("NPC", true);
		}
		
	}
}