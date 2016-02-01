package MVCprojectOL.ControllOL.MainViewCon
{
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.MainView.TopUserInfoBar;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class RemoveMViewCommands extends Commands 
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			//MianViewCenter(this._facaed.GetRegisterViewCtrl("main_viewCenter"));
			//---底板----
			//var _btmView:MainSystemPanel = MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main));
			//---上方區域----
			//var _showInfo:TopUserInfoBar = TopUserInfoBar(this._facaed.GetRegisterViewCtrl("userInfoView"));
			
			this._facaed.RemoveRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER);
			TipsCenterView(this._facaed.GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
			this._facaed.RemoveCommand(ViewSystem_BuildCommands.MAINVIEW_REMOVE,this);
			//----要下達移除指令
			this._facaed.RegisterCommand(ViewSystem_BuildCommands.MAINVIEW_COMPLETE,MainViewConCenter);
			//---馬上註冊創造的commands--
			this._facaed.RegisterCommand(ViewSystem_BuildCommands.MAINVIEW_CREAT,CreatMainView);
		}
		
	}
	
}