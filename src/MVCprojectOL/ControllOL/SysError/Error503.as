package MVCprojectOL.ControllOL.SysError {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import flash.display.Sprite;
	import MVCprojectOL.ViewOL.ErrorInforView.ErrorInforView;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.GameSystemStrLib;
	import strLib.vewStr.ViewNameLib;
	
	import Spark.CommandsStrLad;
	
	import MVCprojectOL.ModelOL.NetCheck.NetCheckProxy;
	
	public class Error503 extends Commands {
		public static const Error503Event:String = "Error503Event";
		
		private var _SourceProxy:SourceProxy;
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String >  [  "Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg", "DetailBoard", "SkilletBg", "Inform", "MakeBtn", "Fatigue", "Hourglass", "CheckBtn", "BgD", "ReportBg", "EdgeBg", "ContentBg", "Diamond",
		"DemonAvatar","Paper","Job"];
		private var _ComponentClasses:Object;
		
		private var _ErrorInforView:ErrorInforView;
		
		public function Error503() {
			this._SourceProxy = SourceProxy.GetInstance();
			this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameUiView );
			this._ErrorInforView = new ErrorInforView ( ViewNameLib.View_ErrorInfor , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._ErrorInforView );//註冊ViewCtrl
			this._ErrorInforView.AddElement(this._ComponentClasses);
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			var _receivedMessage:NetResultPack = _obj.GetClass() as NetResultPack;
			//( _receivedMessage._serverStatus , _receivedMessage._result , _receivedMessage._replyDataType );
			this._ErrorInforView.AddMsg(_receivedMessage._serverStatus , _receivedMessage._result , _receivedMessage._replyDataType);
		}
		
	}//end class
}//end package