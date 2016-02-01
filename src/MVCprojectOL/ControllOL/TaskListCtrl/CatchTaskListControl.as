package MVCprojectOL.ControllOL.TaskListCtrl 
{
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplayProxy;
	import MVCprojectOL.ModelOL.MissionCenter.MissionProxy;
	import MVCprojectOL.ModelOL.Vo.MissionVO.Mission;
	import MVCprojectOL.ViewOL.TaskListView.TaskListViewCtrl;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewNameLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchTaskListControl extends CatchCommands
	{
		private var _SourceProxy:SourceProxy;
		private var _TaskListViewCtrl:TaskListViewCtrl;
		private var _ItemDisplayProxy:ItemDisplayProxy;
		private var _TaskListData:Vector.<Mission>;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClassList:Vector.<String> = new < String >  [ "BgB", "Title", "EdgeBg", "ExplainBtn", "CloseBtn", "CheckBtn", "PageBtnS", "TaskBg", "TaskTitleBg", "TaskRewardBg", "ReportBg", "DemonAvatar", "Paper", "EdgeBg" ];
		private var _GlobalClasses:Object;
		
		private var _NewGuid:String;
		
		private function initTaskListCore():void
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._GlobalClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClassList );
				trace("公用素材OK !!");
				this.StartTaskList();
			}else {
				trace("公用素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function TerminateThis():void 
		{
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_TaskList );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_ItemDisplayProxy );
			
			this._SourceProxy = null;
			this._GlobalClasses = null;
			this._ItemDisplayProxy = null;
			
			this.SendNotify( UICmdStrLib.Terminate_TaskList );
		}
		
		private function StartTaskList():void
		{
			this._ItemDisplayProxy = ItemDisplayProxy.GetInstance();//Item顯示快取容器
			this._facaed.RegisterProxy( this._ItemDisplayProxy );//Item顯示快取容器
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._TaskListViewCtrl = new TaskListViewCtrl ( ViewNameLib.View_TaskList , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._TaskListViewCtrl );//註冊溶解所ViewCtrl
			
			this._TaskListViewCtrl.AddElement(this._GlobalClasses, this._NewGuid);
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) {
				case UICmdStrLib.Init_TaskListCatch:
					(_obj.GetClass() == null)?this._NewGuid = "":this._NewGuid = String(_obj.GetClass());
				    this.initTaskListCore();
				break;
				case UICmdStrLib.CtrlPage:
					this._TaskListViewCtrl.CtrlPage(_obj.GetClass().CtrlPageNum, _obj.GetClass().CtrlBoolean);
				break;
				case UICmdStrLib.TaskListData:
					this._TaskListData = MissionProxy(this._facaed.GetProxy(ProxyPVEStrList.MISSION_PROXY)).GetMission();
				    this._TaskListViewCtrl.GetTaskListData(this._TaskListData);
				break;
				case UICmdStrLib.GetItem:
					var _Item:Vector.<ItemDisplay> = new Vector.<ItemDisplay>;
				   for (var i:int = 0; i <  _obj.GetClass().Item.length; i++) 
				   {
					   _Item.push(this._ItemDisplayProxy.GetItemDisplayExpress(_obj.GetClass().Item[i]));
				   }
				   this._TaskListViewCtrl.AddTaskContent(_Item);
				break;
				case UICmdStrLib.GetMissionReward:
				   MissionProxy(this._facaed.GetProxy(ProxyPVEStrList.MISSION_PROXY)).GetMissionReward(_obj.GetClass().Guid);
				break;
				case UICmdStrLib.UpDataTaskList:
				  this._TaskListData = _obj.GetClass().Data;
				  this._TaskListViewCtrl.GetTaskListData(this._TaskListData);
				break;
				case ProxyPVEStrList.MISSION_READY:
				   var _Complete:Array = _obj.GetClass()._aryComplete as Array;
				   var _NewMission:Array = _obj.GetClass()._aryNew as Array;
				   this.UpDataTaskList(_Complete, _NewMission);
				break;
				case UICmdStrLib.RemoveALL:
					this.TerminateThis();
					this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
				break;
				case ProxyPVEStrList.TIP_CLOSESYS :
					this.TerminateThis();
				break;
				case UICmdStrLib.NewData :
					this._TaskListViewCtrl.SelectTaskList(String(_obj.GetClass()));
				break;
			}
		}
		//更新任務列表
		private function UpDataTaskList(_Complete:Array, _NewMission:Array):void 
		{
			var _TaskListDataLength:int;
			var _CompleteLength:int = _Complete.length;
			var _NewMissionLength:int = _NewMission.length;
			for (var i:int = 0; i < _CompleteLength; i++) 
			{
				_TaskListDataLength = this._TaskListData.length;
				for (var k:int = 0; k < _TaskListDataLength; k++ ) { 
					if (this._TaskListData[k]._guid == _Complete[i]) {
						this._TaskListData.splice(k, 1);
						_TaskListDataLength = this._TaskListData.length;
					}
				}
			}
			for (var j:int = 0; j < _NewMissionLength; j++) 
			{
				this._TaskListData.push(_NewMission[j]);
			}
			this._TaskListViewCtrl.GetTaskListData(this._TaskListData);
		}

		
		override public function GetListRegisterCommands():Array {
			return [ UICmdStrLib.Init_TaskListCatch,
					UICmdStrLib.RemoveALL,
					UICmdStrLib.TaskListData,
					UICmdStrLib.GetItem,
					UICmdStrLib.CtrlPage,
					UICmdStrLib.GetMissionReward,
					UICmdStrLib.UpDataTaskList,
					ProxyPVEStrList.MISSION_READY,
					ProxyPVEStrList.TIP_CLOSESYS,
					UICmdStrLib.NewData
					];
		}
		
	}
}