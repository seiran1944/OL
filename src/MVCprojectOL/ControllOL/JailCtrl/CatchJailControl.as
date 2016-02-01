package MVCprojectOL.ControllOL.JailCtrl 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.JailModel.JailUIproxy;
	import MVCprojectOL.ViewOL.JailView.JailViewCtrl;
	import MVCprojectOL.ViewOL.JailView.JailWallExitBtn;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.UICmdStrLib;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.vewStr.ViewNameLib;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchJailControl extends CatchCommands
	{
		private var _SourceProxy:SourceProxy;
		private var _JailUIproxy:JailUIproxy;
		private var _JailViewCtrl:JailViewCtrl;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String > [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn","pageBtnN","exitBtn", "Property" ];
		private var _ComponentClasses:Object;
		
		private var _JailKey:String = "GUI00012_ANI";//牢房 素材包KEY碼
		private const _JailClasses:Vector.<String> = new < String > [ "Board", "CrossBar", "StopBtn", "MoveBar", "Fire", "JailNPC", "TortureNPC"];
		private var _JailComponentClasses:Object;
		
		private var _JailLayer:int;
		
		public function CatchJailControl() 
		{
			
		}
		
		private function initJailCore():void
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
				this._JailUIproxy = JailUIproxy.GetInstance();
				this._facaed.RegisterProxy( this._JailUIproxy );
				this._JailUIproxy.StartLoad( this._JailKey );
				trace("素材OK !!");
			}else {
				trace("素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function OnJail():void
		{
			//取得數字元件 切割
			var _aryNum:Array = PlayerDataCenter.GetInitUiKey("SysUI_Number");
			var _picNumber:BitmapData = BitmapData(SourceProxy.GetInstance().GetMaterialSWP(_aryNum[0],"timerBasic",true));
			var _numberAry:Array = SourceProxy.GetInstance().CutImgaeHandler(_picNumber, 32, 32, "timerBasic");
			_numberAry.splice(12, _numberAry.length - 12);
			this._ComponentClasses["timerBasic"] = _numberAry;
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._JailViewCtrl = new JailViewCtrl ( ViewNameLib.View_Jail , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._JailViewCtrl );//註冊ViewCtrl
			
			this._JailComponentClasses["Fire"] = this._JailUIproxy.GetFire();
			
			this._JailViewCtrl.BackGroundElement(this._JailComponentClasses, this._ComponentClasses);
			
			MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddClass(JailWallExitBtn);
			MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddSingleSource("JailWallExitBtn" , this._ComponentClasses);
		}
		
		private function TerminateThis():void {
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Jail );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_JailUIproxy );
			
			this._JailViewCtrl = null;
			this._JailUIproxy = null;
			
			this.SendNotify( UICmdStrLib.Terminate_Jail);
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				case UICmdStrLib.Init_JailCatch:
				   this.initJailCore();
				break;
				case this._JailKey :
					trace( "牢房回來了" );
					this._JailComponentClasses = _obj.GetClass();
					this.OnJail();
				break;
				case UICmdStrLib.JailLayer :
					this._JailLayer= _obj.GetClass().Layer;
					MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddVaule(this._JailLayer);
				break;
				case UICmdStrLib.JailRemoveALL :
					if (this._JailLayer == 1) {
						this.TerminateThis();
					}else if (this._JailLayer == 2) {
						
					}
				break;
			}
		}
		
		override public function GetListRegisterCommands():Array {
			return [ UICmdStrLib.Init_JailCatch,
					this._JailKey,
					UICmdStrLib.JailLayer,
					UICmdStrLib.JailRemoveALL,
					
					];
		}
		
	}

}