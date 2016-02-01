package MVCprojectOL.ControllOL.Troops
{
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.Troop.TroopProxy;
	import MVCprojectOL.ModelOL.Vo.Troop;
	import MVCprojectOL.ViewOL.TeamUI.TeamViewCtrl;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.TroopStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 等待資料佈署
	 */
	public class CatchTeamReady extends CatchCommands 
	{
		
		//private var _countReady:int;
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			var TVCtrl:TeamViewCtrl = this._facaed.GetRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL) as TeamViewCtrl;
			
			//trace("抓取命令完成收到發送通知處理後續運作步驟" , _obj.GetName());
			
			switch (_obj.GetName()) 
			{
				case TroopStr.TROOP_READY:
					//TVCtrl.InitData(_obj.GetName(), TroopProxy(this._facaed.GetProxy(TroopStr.TROOP_SYSTEM)).GetAllTroop());
					//做假測試
					TVCtrl.InitData(_obj.GetName(),TroopProxy(this._facaed.GetProxy(TroopStr.TROOP_SYSTEM)).GetAllTroop());
					TVCtrl.InitData("monsterProxySourceReady", MonsterDisplayProxy(this._facaed.GetProxy(ProxyNameLib.Proxy_MonsterDisplayProxy)).GetMonsterDisplayList());
					
					this.ToStart();
				break;
				case "MonsterCombine.COMBINE_READY"://遊戲初始已經先撈了
					//TVCtrl.InitData(_obj.GetName(), this._facaed.GetProxy("monsterDataproxy"));
				break;
			}
			
			//this._countReady++;
			//if (this._countReady == 2) this.ToStart();
		}
	    
		//尚需要怪物素材資料模組的完成佈署通知
	    override public function GetListRegisterCommands():Array 
		{
			return [];
		}
		
		private function ToStart():void
		{
			TeamViewCtrl(this._facaed.GetRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL)).StartCover();
			this.Destroy();
		}
		
		public function Destroy():void 
		{
			//trace("我的抓取COMMAND 已經被呼叫移除asdfasdfasdfasdfasdf程序");
			this._facaed.RemoveCommand(TroopStr.TROOP_READY, CatchTeamReady);
		}
		
		
		
	}
	
}