package MVCprojectOL.ControllOL.MainViewCon
{
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MainView.TopUserInfoBar;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class SWitchOpenCom extends Commands 
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
		   var _motion:String = "OPEN";
		   var _btmView:MainSystemPanel = MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main));
		   //---上方區域----
		   var _showInfo:TopUserInfoBar = TopUserInfoBar(this._facaed.GetRegisterViewCtrl("userInfoView"));
		  _btmView.SwitchMotion(_motion);
		  _showInfo.SwitchMotion(_motion);
		}
	}
	
}