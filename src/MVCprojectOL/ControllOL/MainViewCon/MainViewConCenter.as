package MVCprojectOL.ControllOL.MainViewCon
{
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.GameSystemStrLib;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class MainViewConCenter extends Commands 
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			
			MianViewCenter(this._facaed.GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).initOpenView();
			//var _check:int = this._facaed.GetLayerNum(GameSystemStrLib.GameSystemView);
			//trace("hello");
			//var _check:String = MianViewCenter(this._facaed.GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).setSwitch;
			//var _test:String=MianViewCenter(this._facaed.GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).setSwitch
		    if ( MianViewCenter(this._facaed.GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).setSwitch == "") this._facaed.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);	
		}
	}
	
}