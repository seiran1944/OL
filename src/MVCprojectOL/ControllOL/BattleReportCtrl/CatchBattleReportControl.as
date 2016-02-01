package MVCprojectOL.ControllOL.BattleReportCtrl 
{
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.BattleImaging.BattleImagingProxy;
	import MVCprojectOL.ViewOL.BattleReportView.BattleReportViewCtrl;
	import MVCprojectOL.ViewOL.BattleView.BattleViewCtrl;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewNameLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchBattleReportControl  extends CatchCommands
	{
		private var _SourceProxy:SourceProxy;
		private var _BattleReportViewCtrl:BattleReportViewCtrl;
		private var _BattleImagingProxy:BattleImagingProxy = BattleImagingProxy.GetInstance();
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String >  [  "BgB" , "Title", "ExplainBtn", "EdgeBg", "CheckBtn", "CloseBtn","PageBtnS"
																				,"ReportBg"
																				,"BgM", "Property", "TitleBtn"];
		private var _ComponentClasses:Object;
		
		public function CatchBattleReportControl() 
		{
			
		}
		
		private function initBattleReportCore():void 
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
				this.OnBattleReport();
				trace("素材OK !!");
			}else {
				trace("素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function TerminateThis():void 
		{
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_BattleReport );
			
			this._BattleReportViewCtrl = null;
			
			this.SendNotify( UICmdStrLib.Terminate_BattleReport );
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				case UICmdStrLib.Init_BattleReport:
					this.initBattleReportCore();
				break;
				case ArchivesStr.BATTLEIMAGING_DATA_READY:
					this._BattleReportViewCtrl.AddData(_obj.GetClass());
				break;
				case UICmdStrLib.GetBattleData:
					this._BattleReportViewCtrl.AddReport(this._BattleImagingProxy.GetInfoContentWithID(_obj.GetClass() as String));
				break;
				case UICmdStrLib.Recall:
				    this._BattleImagingProxy.ReadyToImaging(_obj.GetClass() as String);
				break;
				case UICmdStrLib.CtrlPage:
					this._BattleReportViewCtrl.CtrlPage(_obj.GetClass().CtrlPageNum, _obj.GetClass().CtrlBoolean);
				break;
				case UICmdStrLib.onRemoveALL:
					this._BattleReportViewCtrl.RemoveReport();
				break;
				case UICmdStrLib.RemoveALL:
					this.TerminateThis();
					this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
				break;
				case ProxyPVEStrList.TIP_CLOSESYS :
					this._BattleReportViewCtrl.RemoveReport();
					this.TerminateThis();
					if (this._facaed.GetRegisterViewCtrl(ArchivesStr.BATTLEIMAGING_VIEW) != null) BattleViewCtrl(this._facaed.GetRegisterViewCtrl(ArchivesStr.BATTLEIMAGING_VIEW)).ShutDownImmediately();
				break;
			}
		}
		
		private function OnBattleReport():void 
		{
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._BattleReportViewCtrl = new BattleReportViewCtrl ( ViewNameLib.View_BattleReport , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._BattleReportViewCtrl );//註冊溶解所ViewCtrl
			
			this._BattleReportViewCtrl.AddElement(this._ComponentClasses);
			
			this._BattleImagingProxy.GetHistoricalFilm();
		}
		
		override public function GetListRegisterCommands():Array {
			return [UICmdStrLib.Init_BattleReport,
					ArchivesStr.BATTLEIMAGING_DATA_READY,
					UICmdStrLib.GetBattleData,
					UICmdStrLib.Recall,
					UICmdStrLib.CtrlPage,
					UICmdStrLib.onRemoveALL,
					UICmdStrLib.RemoveALL,
					ProxyPVEStrList.TIP_CLOSESYS
					];
		}
		
	}
}