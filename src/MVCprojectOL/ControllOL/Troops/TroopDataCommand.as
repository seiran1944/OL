package MVCprojectOL.ControllOL.Troops
{
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.Troop.TroopProxy;
	import MVCprojectOL.ViewOL.TeamUI.TeamViewCtrl;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.TroopStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TroopDataCommand extends Commands 
	{
		
		
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			var TVCtrl:TeamViewCtrl = this._facaed.GetRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL) as TeamViewCtrl;
			
			//trace("抓取命令完成收到發送通知處理後續運作步驟" , _obj.GetName());
			
			switch (_obj.GetName()) 
			{
				case TroopStr.TROOP_READY://確認隊伍資訊完善後才會啟動 >> 初始會GET / 關閉後的Set VOGroup 也會做等待處理
					//TVCtrl.InitData(_obj.GetName(), TroopProxy(this._facaed.GetProxy(TroopStr.TROOP_SYSTEM)).GetAllTroop());
					//做假測試
					TVCtrl.InitData(_obj.GetName(),TroopProxy(this._facaed.GetProxy(TroopStr.TROOP_SYSTEM)).GetAllTroop());
					TVCtrl.InitData("monsterProxySourceReady", MonsterDisplayProxy(this._facaed.GetProxy(ProxyNameLib.Proxy_MonsterDisplayProxy)).GetMonsterDisplayList());//displayproxy預設等級
					
					this.ToStart();
				break;
				case "MonsterCombine.COMBINE_READY"://遊戲初始已經先撈了
					//TVCtrl.InitData(_obj.GetName(), this._facaed.GetProxy("monsterDataproxy"));
				break;
			}
			
			//this._countReady++;
			//if (this._countReady == 2) this.ToStart();
			
		}
		
		
		private function ToStart():void
		{
			TeamViewCtrl(this._facaed.GetRegisterViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL)).StartCover();
			this.Destroy();
		}
		
		public function Destroy():void 
		{
			
			this._facaed.RemoveCommand(TroopStr.TROOP_READY, TroopDataCommand);
			//trace("test for team command remove succeed>>>><<<<", this._facaed.GetHasCommand(TroopStr.TROOP_READY));
		}
		
		
		
		
	}
	
}