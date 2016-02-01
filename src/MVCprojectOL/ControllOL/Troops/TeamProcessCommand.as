package MVCprojectOL.ControllOL.Troops
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.Troop.TroopProxy;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.TeamUI.TeamViewCtrl;
	import MVCprojectOL.ViewOL.TeamUI.TeamWallPlugin;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceTool;
	import strLib.commandStr.TeamCmdStr;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.proxyStr.ProxyMonsterStr;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.TroopStr;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.01.25.13.45
		@documentation to use this Class....
	 */
	public class TeamProcessCommand extends Commands 
	{
		
		
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			var info:Object = _obj.GetClass();
			switch (info._Status) 
			{
				//case TeamViewCtrl.TEAM_NOTIFY:
					
				//break;
				case TeamViewCtrl.TEAM_MEMBER_NEW:
					TroopProxy(this._facaed.GetProxy(TroopStr.TROOP_SYSTEM)).SetNewTroop(info._Content._symbol,info._Content._member);
				break;
				case TeamViewCtrl.TEAM_MEMBER_EDIT:
					//新隊伍再次編輯的狀態下會造成查無GUID 故發送前都先做取得動作 ( 暫時不做緩衝 ) >> 若編輯速度快速造成SERVER正確資料也還沒回來時的問題
					
					var tp:TroopProxy = this._facaed.GetProxy(TroopStr.TROOP_SYSTEM) as TroopProxy;
					//trace("SYMBOL  <><><><><><><><> GUID ",tp.GetSymbolToGuid(info._Content._symbol));
					tp.SetTroopMember(tp.GetSymbolToGuid(info._Content._symbol), info._Content._member);
					
				break;
				case TeamViewCtrl.TEAM_GROUP_CHANGE://按下確認組隊後發送 >> 先累積在TroopProxy關閉UI時再統一發送避免新隊伍的快速操作沒有隊伍ID狀態
					TroopProxy(this._facaed.GetProxy(TroopStr.TROOP_SYSTEM)).SaveTeamChange(info._Content);
					
				break;
				case TeamViewCtrl.TEAM_EDIT_FLAGNUM://編輯新隊伍>>VIEWCtrl新旗幟編號的需求導入
					TeamViewCtrl(this._facaed.GetRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL)).InputTeamFlagNum = TroopProxy(this._facaed.GetProxy(TroopStr.TROOP_SYSTEM)).GetNextTeamFlag();
				break;
				case TeamViewCtrl.TEAM_SORT_UPDATE://發送取得排序後的怪物資料//***************************************************須補加排序的種類
					//導入VIEW FlashSortMonster()
					TeamViewCtrl(this._facaed.GetRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL)).FlashSortMonster(MonsterDisplayProxy(this._facaed.GetProxy(ProxyNameLib.Proxy_MonsterDisplayProxy)).GetMonsterDisplayList(PlaySystemStrLab.Sort_Atk));
				break;
				
				//case TeamViewCtrl.TEAM_CHECK_SALLY:
					//var tpProxy:TroopProxy = this._facaed.GetProxy(TroopStr.TROOP_SYSTEM) as TroopProxy;
					//if (tpProxy.SallyCheck(String(info._Content)) == 0) {
						//this._facaed.RemoveProxy(ProxyNameLib.Proxy_MonsterDisplayProxy);
						//this._facaed.RemoveRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL);//回到VIEW去執行onRemove
						//this.SendNotify(TeamViewCtrl.TEAM_CHECK_SALLY, { _teamID : String(info._Content) , _teamMember : tpProxy.GetTroopMember(String(info._Content))});//可出征的隊伍發送成員陣列
						//
					//}else {//隊伍處於無法出征的狀態下 待確認需要何種顯示方式去通知VIEW顯示
						//
						//
						//
					//}
					//
					//
				//break;
				case "TeamViewCtrl.TEAM_PAGE_NEXT"://收到一串素材KEY / {target : "tea'm"/"monster"  , page : n }
					//var objBack:Object = this.catchMonsterWork(info.aryMonster);
					//if (info.target == "monster") {
						//this.catchMonsterWork(info.aryHead, objBack);
					//}
					//
					//if (objBack != null) {
						//this.ForeignComing(info.Status, objBack);
					//}
					
				break;
				case "TeamViewCtrl.TEAM_PAGE_PREV"://收到一串素材KEY
					//var objCome:Object = this.catchMonsterWork(info.aryMonster);
					//if (info.target == "monster") {
						//this.catchMonsterWork(info.aryHead, objCome);
					//}
					//
					//if (objCome != null) {
						//this.ForeignComing(info.Status, objCome);
					//}
					
				break;
			case TeamViewCtrl.TEAM_DESTROY:
					trace("test for the wall" , info._Content);
					
					this._facaed.RemoveProxy(ProxyNameLib.Proxy_MonsterDisplayProxy);
					
					if (info._Content["_status"] == "Sally") {
						this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"EXIT"});
						TeamWallPlugin(MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).GetConterClass()).BreakTheWall(true);
						this.SendNotify(TeamViewCtrl(this._facaed.GetRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL)).FightTeamNotify, info._Content["_send"]);
					}
					//寫回MonsterProxy所有變更過的怪物隊伍資料
					TroopProxy(this._facaed.GetProxy(TroopStr.TROOP_SYSTEM)).ReleaseToMonsterProxy();//快速編輯後關閉可能會有SERVER未回GUID的寫入FAKE值狀況//改group方式處理的話會先回寫假的組隊ID標記
					//清除掉UI開啟狀態下記錄的所有暫存SYMBOL值,下次重開撈取資料清單時已經會有新的資料了
					//TroopProxy(this._facaed.GetProxy(TroopStr.TROOP_SYSTEM)).WashAllSymbol();//改group方式處理則要等組隊真實ID回來時才能清除****************************************************************************************************
					
					
					//this._facaed.RemoveCommand(TeamCmdStr.TEAM_CMD_PROCESS,this);//start
					//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).onRemoved();//*********************system  no run self run !! ( should in exit recall )
					
					if (TeamViewCtrl(this._facaed.GetRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL)).FightTeamNotify != ""  && info._Content["_status"] == "Click") this.SendNotify(TeamViewCtrl.TEAM_DESTROY);//順帶通知探索系統
					
					this._facaed.RemoveRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL);//回到VIEW去執行onRemove
					
					//this.ForeignComing(info._Status);
				break;
			}
			
			
			
		}
		
		private function ForeignComing(status:String,data:Object=null):void 
		{
			TeamViewCtrl(this._facaed.GetRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL)).ForeignProcess(status, data);
		}
		
		//private function catchMonsterWork(aryKey:Array,combineObj:Object=null):Object 
		//{
			//var leng:int = aryKey.length;
			//var sourceTool:SourceTool = this._facaed.GetProxy(CommandsStrLad.SourceSystem) as SourceTool;
			//var sourcePackage:Object = combineObj == null ? { } : combineObj;
			//var curKey:String;
			//for (var i:int = leng-1 ; i >=0 ; i--)
			//{
				//curKey = aryKey[i];
				//if (sourceTool.PreloadMaterial(curKey)) {
					//sourcePackage[curKey] = combineObj==null ? sourceTool.GetMovieClipHandler(sourceTool.GetMaterialSWF(curKey)) : sourceTool.GetImageBitmapData(curKey);
					//aryKey.splice(i, 1);
				//}
			//}
			//return leng != aryKey.length ? sourcePackage : null;
		//}
		
		
		
	}
	
}