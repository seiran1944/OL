package MVCprojectOL.ControllOL.TipsCom
{
	import MVCprojectOL.ControllOL.MonsterCage.CatchMonsterCageControl;
	import MVCprojectOL.ControllOL.StorageUI.CatchStorageControl;
	import MVCprojectOL.ControllOL.TaskListCtrl.CatchTaskListControl;
	import MVCprojectOL.ModelOL.MonsterEvolution.EvolutionProxy;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.MainView.TopUserInfoBar;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfView;
	import Spark.coreFrameWork.observer.NotifyInfo;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.commandStr.StorageStrLib;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewNameLib;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class TipsOPENCommands  extends Commands  
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
		   
			var _class:Object = _obj.GetClass();
			//----準備移除還在續列中的
			var _TipsCenterView:TipsCenterView = TipsCenterView(this._facaed.GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL));
			_TipsCenterView.StopHandler();
			
			//var _sprTest:int = (ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView)).numChildren;
			var MAIN_VIEWCENTER:IfView = this._facaed.GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER);
			
			if ((ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView)).numChildren==2 && MAIN_VIEWCENTER!=null) {
				var _btmView:MainSystemPanel = MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main));
			    //---上方區域----
			    var _showInfo:TopUserInfoBar = TopUserInfoBar(this._facaed.GetRegisterViewCtrl("userInfoView"));
				_btmView.SwitchMotion("CLOSE");
			    _showInfo.SwitchMotion("CLOSE");
				
			}
			
			
			
			//var _worldJourney:IfView = this._facaed.GetRegisterViewCtrl(ViewNameLib.View_WorldJourney);
			//var _pvpview:IfView=this._facaed.GetRegisterViewCtrl(ViewNameLib.View_PVP);
			//---關閉下層(visible=false)
			this._facaed.SendNotify(ProxyPVEStrList.TIP_CLOSESYS, _class._build);
			if (!this._facaed.GetHasCommand(ViewSystem_BuildCommands.MAINVIEW_CREAT))this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_CREAT,false);	
			  
			  //var _mainView:IfView = this._facaed.GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER);
			  //trace("hello");	
			
			
			//if (_worldJourney != null || _pvpview != null) this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_CREAT);
			//---開啟系統---
			this.onCompleteHandler(_class);
			
			
			
		}
		
		
		private function onCompleteHandler(_obj:Object):void 
		{
			 //--{_build:this._buildType,_guid:this._guid}
			//--建築種類：0.建築物升級 1.大廳（魔法陣）, 2.巢穴, 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室9.進化室 10.PVP 11.探索
			var _ifView:IfView;
			var _catch:*;
			switch(_obj._build) {
				//--練金/熔解完成---(進儲藏室)
				case 6:
				case 3:
					_ifView=this._facaed.GetRegisterViewCtrl(ViewNameLib.View_Storage);
					if (_ifView==null) {
						this._facaed.SendNotify(StorageStrLib.Init_StorageCatch,_obj._guid);
						} else {
						_catch = CatchStorageControl(this._facaed.GetCatchCommand(CatchStorageControl));
						_catch.ExcuteCommand(new NotifyInfo(UICmdStrLib.NewData,_obj._guid));	
					}
					
				break;	
				
				//---學習技能回來(進惡魔列表)
			   case 4:
				   _ifView = this._facaed.GetRegisterViewCtrl(ViewNameLib.View_MonsterCage);
				   
				    if (_ifView==null) {
						this._facaed.SendNotify(MonsterCageStrLib.init_MonsterCatchCore,_obj._guid);
						
					   } else {
						_catch = CatchMonsterCageControl(this._facaed.GetCatchCommand(CatchMonsterCageControl));
						_catch.ExcuteCommand(new NotifyInfo(UICmdStrLib.NewData,_obj._guid));
					} 
				  
				  
				break;
				
				
				//-----開啟任務列表--
			   case -10:
				    
				   _ifView = this._facaed.GetRegisterViewCtrl(ViewNameLib.View_TaskList);
				   
				    if (_ifView==null) {
						this._facaed.SendNotify(UICmdStrLib.Init_TaskList,_obj._guid);
						
					   } else {
						_catch = CatchTaskListControl(this._facaed.GetCatchCommand(CatchTaskListControl));
						_catch.ExcuteCommand(new NotifyInfo(UICmdStrLib.NewData,_obj._guid));
					} 
				
				
				break;
				
				
			}
		}
		
	}
	
}