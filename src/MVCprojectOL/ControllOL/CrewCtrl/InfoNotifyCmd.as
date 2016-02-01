package MVCprojectOL.ControllOL.CrewCtrl
{
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ViewOL.CrewView.InfoNotify.InfoNotifyView;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class InfoNotifyCmd  extends Commands
	{
		
		private const COMMON_KEY:String = "SysUI_All";//GUI00002_ANI
		private var _vecCommon:Vector.<String> = new < String > ["BgB","DemonAvatar","EdgeBg","Paper","CheckBtn"];
		
		
		//NOTIFY >>開啟要自行註冊Command
		//this.SendNotify(ArchivesStr.CREW_INFO_NOTIFY, { _active : "OPEN" ,_info : "錯誤提示" , _x : 0 , _y : 0 , _btnNum : 1 / 2 } );
		//NOTIFY >>點選後 _active 會為 "CONFIRM" / "CANCEL"
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			var objClass:Object = _obj.GetClass();
			if (objClass._active != "OPEN") return ;
			
			//UI基本素材已經確認preload complete 的狀態下
			var sTool:SourceProxy = this._facaed.GetProxy(CommandsStrLad.SourceSystem) as SourceProxy;
			var objCommon:Object = sTool.GetMaterialSWP(PlayerDataCenter.GetInitUiKey(this.COMMON_KEY)[0], this._vecCommon);
			
			//統一層
			var spContainer:Sprite = new Sprite();
			spContainer.graphics.beginFill(0, 0.2);
			spContainer.graphics.drawRect(0, 0, 1000, 700);
			spContainer.graphics.endFill();
			ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).addChild(spContainer);
			var infoView:InfoNotifyView = new InfoNotifyView(objClass._info, spContainer);
			infoView.ShowInfo(objCommon, objClass);
			
		}
		
		
	}
	
}