package MVCprojectOL.ControllOL.MissionCompleteCom 
{
	import MVCprojectOL.ModelOL.MissionCenter.MissionProxy;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MainView.MainWall;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author EricHuang
	 */
	public class MissionCom extends Commands
	{
	    
		//----registerNmae>PVECommands.MONSTER_VauleCANGE;
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			//---在一個flag來關閉閃爍---
			//_class = false
			//var _testName:String = String(_obj.GetClass());
			
		    var _view:MainSystemPanel=MainSystemPanel(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.Panel_Main))
			var Panel:*= _view.GetConterClass();
			
			//var Panel:MainWall = MainWall(_view.GetConterClass());
			if (Panel is MainWall  && Panel != null) { 
				Panel.ShineTheTarget(_obj.GetClass());	
				} else {	
			  //---不在當前系統			
			  MissionProxy(this._facaed.GetProxy(ProxyPVEStrList.MISSION_PROXY)).SetMissionCompleteWall([_obj.GetClass()]);	
			}
			
			//GameSystemStrLib.GameUiView
			//----接續完成
			
		}
		
		
		
	}

}