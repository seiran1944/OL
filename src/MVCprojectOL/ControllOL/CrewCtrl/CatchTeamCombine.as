package MVCprojectOL.ControllOL.CrewCtrl
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ViewOL.CrewView.DefaultBoard.CrewDefaultView;
	import MVCprojectOL.ViewOL.CrewView.EditBoard.TeamEditorView;
	import MVCprojectOL.ViewOL.CrewView.MonsterMixed.TeamMonsterView;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.TroopStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class CatchTeamCombine extends CatchCommands
	{
		
		private var _currentNumerical:String = PlaySystemStrLab.Sort_LV;
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			
			switch (_obj.GetName()) 
			{
				case MonsterCageStrLib.SortNumerical ://monsterPanel內部的SORT刷新處理
						//trace( " I Got " , _Signal , _obj.GetClass()._sort );
						if (this._currentNumerical != String( _obj.GetClass()._sort)) { 
							var vecMonDsplay:Vector.<MonsterDisplay> = MonsterDisplayProxy(this._facaed.GetProxy(ProxyNameLib.Proxy_MonsterDisplayProxy)).GetMonsterDisplayList( String( _obj.GetClass()._sort ), _obj.GetClass().CtrlNum);
							//先篩選掉不能選取的怪物清單 20130606
							CrewProxy(this._facaed.GetProxy(ArchivesStr.CREW_SYSTEM)).PureCrewSorting(TeamEditorView(this._facaed.GetRegisterViewCtrl(ArchivesStr.TEAM_EDIT_VIEW)).TroopID, vecMonDsplay);
							//先做SORT新資料的更新
							TeamMonsterView(this._facaed.GetRegisterViewCtrl(ArchivesStr.TEAM_MONSTER_VIEW)).SortRecover(vecMonDsplay);
							//在做顯示層的更新
							TeamMonsterView(this._facaed.GetRegisterViewCtrl(ArchivesStr.TEAM_MONSTER_VIEW)).UpdateMonster(vecMonDsplay, String( _obj.GetClass()._sort ));
							
							this._currentNumerical = String( _obj.GetClass()._sort);
						}
				break;
				case ArchivesStr.CREW_EDIT_REMOVE ://點擊XX的動作
						this.Destroy();
				break;
					
				case ArchivesStr.TEAM_EDIT_CHANGE://做拖曳變更成員後的旗幟印章編輯狀態處理
					TeamMonsterView(this._facaed.GetRegisterViewCtrl(ArchivesStr.TEAM_MONSTER_VIEW)).EditProcess(_obj.GetClass());
				break;
				
				case ArchivesStr.CREW_EDIT_CONFIRM://{ _loading , _objChange : , _objMember : this.GetAllMember() , _troopID : this._currentTroop._guid , _num : this._num}
					var crew:CrewProxy = CrewProxy.GetInstance();
					var objData:Object = _obj.GetClass();
					//_objChange = { _name : this._currentTroop._guid , _add: aryAdd , remove : aryRemove }
					
					crew.UpdateToMonsterProxy(objData._objChange, objData._num);//MonsterProxy改變資料
					
					var symbol:String = crew.SetCrewMember(objData._num, objData._objMember);//CrewProxy & SERVER 改變資料
					if (symbol == "delete") CrewDefaultView(this._facaed.GetRegisterViewCtrl(ArchivesStr.CREW_DEFAULT_VIEW)).CancelTroopByNum(objData._num);//清空隊伍洗掉原先顯示的資料
					
					if(!objData._loading || symbol=="") this.Destroy();//確認後資料處理完成時
				break;
				
				case ArchivesStr.CREW_NEW_BACK://新隊伍GUID資料回來時
					this.Destroy();
				break;
			}
		}
		
		private function draggingNotify(type:String, note:Object):void 
		{
			//編輯拖曳的圖示與數值紀錄處理
			TeamEditorView(this._facaed.GetRegisterViewCtrl(ArchivesStr.TEAM_EDIT_VIEW)).DraggingProcess(type, note);
		}
		
		override public function GetListRegisterCommands():Array 
		{
			return [
				MonsterCageStrLib.SortNumerical,
				ArchivesStr.CREW_EDIT_REMOVE,
				ArchivesStr.TEAM_EDIT_CHANGE,
				ArchivesStr.CREW_EDIT_CONFIRM,
				ArchivesStr.CREW_NEW_BACK
			];
		}
		
		private function Destroy():void 
		{
			//重置預設面板頭像成員
			var aryTroop:Array = CrewProxy.GetInstance().GetAllTroop();
			CrewDefaultView(this._facaed.GetRegisterViewCtrl(ArchivesStr.CREW_DEFAULT_VIEW)).SetTroopData(aryTroop);
			
			//this._facaed.RemoveProxy(ProxyNameLib.Proxy_MonsterDisplayProxy);//MonsterDisplayProxy // remove by CrewDefaultView
			this._facaed.RemoveRegisterViewCtrl(ArchivesStr.TEAM_MONSTER_VIEW);//monsterPanel extends > TeamMonsterView
			this._facaed.RemoveRegisterViewCtrl(ArchivesStr.TEAM_EDIT_VIEW);//team edit board area
			this._facaed.RemoveALLCatchCommands(CatchTeamCombine);//current command
		}
		
		
	}
	
}