package MVCprojectOL.ControllOL.CrewCtrl
{
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.CrewView.DefaultBoard.CrewDefaultView;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 預設隊伍設定
	 */
	public class CatchCrewDefault extends CatchCommands
	{
		
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			switch (_obj.GetName()) 
			{
				case ArchivesStr.CREW_DEFAULT_REMOVE://關閉按鈕
					//Object { _notifyString , _type : (0 = PVP , 1 = PVE) }
					var objNotify:Object = CrewDefaultView(this._facaed.GetRegisterViewCtrl(ArchivesStr.CREW_DEFAULT_VIEW)).NotifyInfo;
					if (objNotify != null) { // 有訊號需求 則會發送 Object { _objMember : Object , _teamGroup : String , _sallyCheck : int }
						var crewProxy:CrewProxy = this._facaed.GetProxy(ArchivesStr.CREW_SYSTEM) as CrewProxy;
						var objTest:Object =  { _objMember : crewProxy.GetDefaultCrewMember(objNotify._type) , _teamGroup : crewProxy.GetDefaultCrewID(objNotify._type) , _sallyCheck : crewProxy.CrewSallyCheck(objNotify._type) };
						trace("預設隊伍ID", objTest._teamGroup);
						trace("預設隊伍TYPE", objNotify._type);
						for each (var item:String in objTest._objMember) 
						{
							trace("預設隊伍成員ID為",item);
						}
						this.SendNotify(objNotify._notifyString,objTest );
					}
					
					this.Destroy(objNotify==null ? true : false);
				break;
				
				case ArchivesStr.CREW_DEFAULT_CHANGE://點選預設按鈕 { _num : 0-3 , _name : "PVE"/"PVP" , _troopID }
					//資料更新並與SERVER同步
					var choose:Boolean = _obj.GetClass()._name == "PVP" ? true : false;
					CrewProxy.GetInstance().SetDefaultCrew(_obj.GetClass()._num, choose , !choose );
					//顯示按鈕變換
					CrewDefaultView(this._facaed.GetRegisterViewCtrl(ArchivesStr.CREW_DEFAULT_VIEW)).ChangeDefaultBtn(_obj.GetClass()._num, _obj.GetClass()._name);
				break;
				
				case ArchivesStr.CREW_TIPS_NOTIFY:
					
					var objClass:Object = _obj.GetClass();
					 //_type : e.type , _key : this._objBtnTips.e.target.name , _x :  e.stageX, _y :e.stageY
					switch (objClass._type) 
					{
						case MouseEvent.ROLL_OVER:
							this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("CrewSystem", ProxyPVEStrList.TIP_STRBASIC, objClass._key, "", null, objClass._x, objClass._y));
						break;
						case MouseEvent.ROLL_OUT:
							TipsCenterView(this._facaed.GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
						break;
						case MouseEvent.MOUSE_MOVE:
							TipsCenterView(this._facaed.GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).TipsMove(objClass._x,objClass._y);
						break;
					}
					
					
				break;
			}
			
			
		}
		
		override public function GetListRegisterCommands():Array 
		{
			return [
				ArchivesStr.CREW_DEFAULT_REMOVE,
				ArchivesStr.CREW_DEFAULT_CHANGE,
				ArchivesStr.CREW_TIPS_NOTIFY
			];
		}
		
		private function Destroy(needWall:Boolean):void 
		{
			if(needWall) this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);//關閉通知城牆回復
			
			//CrewDefaultView(this._facaed.GetRegisterViewCtrl(ArchivesStr.CREW_DEFAULT_VIEW)).Destroy();
			this._facaed.RemoveRegisterViewCtrl(ArchivesStr.CREW_DEFAULT_VIEW);
			this._facaed.RemoveProxy(ProxyNameLib.Proxy_MonsterDisplayProxy);//MonsterDisplayProxy
			this._facaed.RemoveCommand(ArchivesStr.CREW_EDIT_SHOW, CrewEditCommand);//show editStart notify command
			this._facaed.RemoveCommand(ArchivesStr.CREW_INFO_NOTIFY, InfoNotifyCmd);//show infoView notify command
			this._facaed.RemoveALLCatchCommands(CatchCrewDefault);
		}
		
	}
	
}