package MVCprojectOL.ControllOL.Mail {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import MVCprojectOL.ModelOL.Vo.MailVo.Mail;
	import MVCprojectOL.ViewOL.MailView.MailViewCtrl;

	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;

	import MVCprojectOL.ModelOL.Mail.MailProxy;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	//import strLib.commandStr.MailStrLib;

	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.Vo.Buildschedule;

	import strLib.commandStr.UICmdStrLib;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyPVEStrList;

	import strLib.commandStr.TeamCmdStr;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.vewStr.ViewNameLib;
	
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;

	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.GameSystemStrLib;

	import strLib.proxyStr.ProxyNameLib;
	import MVCprojectOL.ControllOL.Mail.MailStrLib;
	
	/*import strLib.vewStr.ViewStrLib;
	import strLib.vewStr.ViewNameLib;
	
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MainView.MainViewBGSystem;
	import MVCprojectOL.ViewOL.MonsterCage.WallBtn;*/
	
	import ProjectOLFacade;
	
	import strLib.commandStr.WorldJourneyStrLib;

	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.11.09
	 */
	public class CatchMailControl extends CatchCommands {
		
		
		private var _SourceProxy:SourceProxy;
		private var _MailProxy:MailProxy;
		private var _MailViewCtrl:MailViewCtrl;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClassList:Vector.<String> = new < String > [ "BgB" , "Title", "ExplainBtn", "EdgeBg", "CheckBtn", "CloseBtn", "PageBtnS"
																					,"DemonAvatar","EdgeBg","Paper"
																					,"ReportBg"];
		private var _GlobalClasses:Object;
		
		
		public function CatchMailControl() {
			trace( "MailSys Controller is on duty !! Waiting for command.------信件系統已開啟" );
			this.Ignite();
		}
		
		
		private function Ignite():void {
			
			//this._facaed.RegisterCommand( WorldJourneyStrLib.Terminate_WorldJourney , Terminate_WorldJourney );//註冊終結事件
			
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				trace("公用素材OK !!");
				this._MailProxy = MailProxy.GetInstance();
				
				this._facaed.RegisterProxy( this._MailProxy );
				
				this._GlobalClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClassList );
				
				this._MailProxy.GetNewMailList();//發送取得請求
			}else {
				//若公用素材還沒有準備好 代表主程序未初始完畢  則發出終結指令終結這個command
				trace("公用素材不OK !!");
				this.TerminateThis();
			}
			
			
			
		}
		
		private function TerminateThis():void {
			this._facaed.RemoveProxy( MailProxy._MailProxyName );
			
			this._SourceProxy = null;
			this._facaed.RemoveALLCatchCommands( CatchMailControl );//移除這個控制中心
			
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Mail );
			this._MailViewCtrl = null;
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void {
			
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) {
				case MailStrLib.MailListReturned : 
						//已取得信件清單 ( 1.資料已回來 2.素材已OK )
						//刷新(或啟始)交易記錄清單 VIEW
						this.OnMail(_obj.GetClass());
					break;
					
				case MailStrLib.MailContentReturned : 
						//已取得信件內容物
						//將物件回寫資訊中心
						//開啟已取得物件的訊息面板
					break;
					
				case MailStrLib.OpenMail : //打開信件	(View發送所選取的Mail物件過來)
						//"MailRead" = 讀信  "MailGet" = 收物
						this._MailProxy.MailRead( _obj.GetClass() as Mail );
					break;
					
				case MailStrLib.MailGet : //領取信件附件 (View發送所選取的Mail物件過來)
						//"MailRead" = 讀信  "MailGet" = 收物
						this._MailProxy.MailGet( _obj.GetClass() as Mail );
					break;
					
				case MailStrLib.GetMailMessage : 
						var _CurrentList:Mail = Mail(_obj.GetClass());
						this._MailViewCtrl.AddMsgPanel(_CurrentList, this._MailProxy.GetMailMessage(_CurrentList._guid), this._MailProxy.GetMailAttachment(_CurrentList._guid));
					break;
					
				case UICmdStrLib.CtrlPage:
						this._MailViewCtrl.CtrlPage(_obj.GetClass().CtrlPageNum, _obj.GetClass().CtrlBoolean);
					break;
					
				case UICmdStrLib.RemoveALL:
						this.TerminateThis();
						this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
					break;
				case ProxyPVEStrList.TIP_CLOSESYS :
					this.TerminateThis();
				break;
					
				default : 
					break;
			}
		}
		
		private function OnMail(_MailAry:Object):void 
		{
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._MailViewCtrl = new MailViewCtrl ( ViewNameLib.View_Mail , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._MailViewCtrl );//註冊溶解所ViewCtrl
			
			this._MailViewCtrl.AddElement(this._GlobalClasses, _MailAry);
		}
		
		override public function GetListRegisterCommands():Array {
			return [ MailStrLib.MailListReturned , 
					 MailStrLib.MailContentReturned ,
					 MailStrLib.OpenMail ,
					 MailStrLib.MailGet,
					 MailStrLib.GetMailMessage,
					 UICmdStrLib.CtrlPage,
					 UICmdStrLib.RemoveALL,
					 ProxyPVEStrList.TIP_CLOSESYS
					];
		}
		
	}//end class
}//end package