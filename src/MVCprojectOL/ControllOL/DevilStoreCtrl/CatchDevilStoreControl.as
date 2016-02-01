package MVCprojectOL.ControllOL.DevilStoreCtrl 
{
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.PvpShop.PvpShopProxy;
	import MVCprojectOL.ModelOL.ViewSharedModel.ViewSharedModel;
	import MVCprojectOL.ViewOL.DevilStoreView.DevilStoreViewCtrl;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.UICmdStrLib;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.vewStr.ViewNameLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchDevilStoreControl extends CatchCommands
	{
		private var _SourceProxy:SourceProxy;
		private var _ViewSharedModel:ViewSharedModel;
		private var _DevilStoreViewCtrl:DevilStoreViewCtrl;
		private var _PvpShopProxy:PvpShopProxy = PvpShopProxy.GetInstance();
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String >  [  "BgB" , "Title", "ExplainBtn", "EdgeBg", "CheckBtn", "CloseBtn","PageBtnS"
																				,"DemonAvatar","Paper"
																				,"Diamond", "Tab","WallBg"];
		private var _ComponentClasses:Object;
		
		public var _SharedKey:String = "GUI00017_ANI";// 素材包KEY碼
		public var _SharedClasses:Vector.<String> = new < String > ["Abnormal", "NormalBg", "Title", "Integral"];
		private var _SharedComponentClasses:Object;
		
		private var _CurrentGuid:String;
		
		public function CatchDevilStoreControl() 
		{
			
		}
		
		private function initDevilStoreCore():void 
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
				
				this._ViewSharedModel = ViewSharedModel.GetInstance();
				this._facaed.RegisterProxy( this._ViewSharedModel );
				this._ViewSharedModel._SharedKey = this._SharedKey;
				this._ViewSharedModel._SharedClasses = this._SharedClasses;
				this._ViewSharedModel.StartLoad( this._SharedKey );
				
				trace("素材OK !!");
			}else {
				trace("素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function TerminateThis():void 
		{
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_SharedUIproxy );
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_DevilStore );
			
			this._ViewSharedModel = null;
			this._DevilStoreViewCtrl = null;
			
			this.SendNotify( UICmdStrLib.Terminate_DevilStore );
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				case UICmdStrLib.Init_DevilStoreCatch:
					this.initDevilStoreCore();
				break;
				case this._SharedKey :
					this._SharedComponentClasses = _obj.GetClass();
					this.OnDevilStore();
				break;
				case UICmdStrLib.CtrlPage:
					this._DevilStoreViewCtrl.CtrlPage(_obj.GetClass().CtrlPageNum, _obj.GetClass().CtrlBoolean);
				break;
				
				case ArchivesStr.PVP_SHOP_READY :
					this._DevilStoreViewCtrl.AddStoreData(_obj.GetClass());
				break;
				//<<回傳檢查狀態  -2 = 查無此商品資料 ,  -1 = 格子位置不足 ,  0 = 可以順利購買 ,  1 = 晶鑽不足 , 2 = 積分不足
				case UICmdStrLib.CheckBuying:
					this._CurrentGuid = _obj.GetClass() as String;
					var _Status:int = this._PvpShopProxy.CheckBuying(this._CurrentGuid );
					this._DevilStoreViewCtrl.AddInform(_Status);
				break;
				case UICmdStrLib.CheckBuying:
					this._CurrentGuid = _obj.GetClass() as String;
					var _Status:int = this._PvpShopProxy.CheckBuying(this._CurrentGuid );
					this._DevilStoreViewCtrl.AddInform(_Status);
				break;
				case UICmdStrLib.DoBuying:
					this._PvpShopProxy.DoBuying(this._CurrentGuid );
				break;
				case ArchivesStr.PVP_SHOP_DEAL :
					this._DevilStoreViewCtrl.UpData(_obj.GetClass() as int, PlayerDataCenter.PlayerHonor);
					this.SendNotify(UICmdStrLib.UpDataPlayerHonor, PlayerDataCenter.PlayerHonor);
				break;
				
				case UICmdStrLib.RemoveDevilStore:
					this.TerminateThis();
				break;
			}
		}
		
		private function OnDevilStore():void 
		{
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._DevilStoreViewCtrl = new DevilStoreViewCtrl ( ViewNameLib.View_DevilStore , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._DevilStoreViewCtrl );//註冊溶解所ViewCtrl
			
			this._DevilStoreViewCtrl.AddElement(this._ComponentClasses, this._SharedComponentClasses, PlayerDataCenter.PlayerHonor);
			this._PvpShopProxy.GetGoods();
		}
		
		override public function GetListRegisterCommands():Array {
			return [UICmdStrLib.Init_DevilStoreCatch,
					this._SharedKey,
					ArchivesStr.PVP_SHOP_READY,
					UICmdStrLib.RemoveDevilStore,
					UICmdStrLib.CtrlPage,
					UICmdStrLib.CheckBuying,
					UICmdStrLib.DoBuying,
					ArchivesStr.PVP_SHOP_DEAL
					];
		}
		
	}
}