package MVCprojectOL.ControllOL.BattleImage
{
	import MVCprojectOL.ModelOL.BattleImaging.BattleImagingProxy;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.CombatMonsterDisplayProxy;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MotionSettings.MotionValue;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplayProxy;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.BarTool.BarProxy;
	import Spark.SoarVision.VisionCenter;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyNameLib;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation battleProxy<>View
	 */
	public class BattleBridgeCommand extends Commands
	{
		
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			var info:Object = _obj.GetClass();
			
			switch (info["_status"]) 
			{
				case ArchivesStr.BATTLEIMAGING_VIEW_PREPARE:
					
					if ((_obj.GetClass()["_needPause"])=="") {
						var viewCommand:Commands = new BattleViewCommand();
						_obj.SetName(ArchivesStr.BATTLEIMAGING_VIEW_PREPARE);
						viewCommand.ExcuteCommand(_obj);
					}
					
					//註冊須要接到的技能完成訊號
					this._facaed.RegisterCommand("", CatchBattleReady);//fakeSkillComplete
					
					//monsterProxy InitDataCreate 要先撈怪物資料避免技能過快撈完的問題
					this._facaed.RegisterProxy(CombatMonsterDisplayProxy.GetInstance());
					var vecD:Vector.<MonsterDisplay>=CombatMonsterDisplayProxy.GetInstance().GetMonsterDisplayList(info["_data"]["_monster"] as Vector.<BattleFighter>);//導入Vector<BattleFighter>
					//trace("VECD", vecD);
					
					//技能PROXY註冊處理//info["_data"]["_skill"]
					this._facaed.RegisterProxy(CombatSkillDisplayProxy.GetInstance());
					CombatSkillDisplayProxy.GetInstance().GetCombatSkillDisplayList(Vector.<String>(info["_data"]["_skill"]));//導入清單
					
				break;
				case ArchivesStr.BATTLEIMAGING_VIEW_END://UI view control 清除完畢發送通知
					switch (String(info)) 
					{
						case ""://無需要發送的訊號來源 代表一般的戰報觀看
							
							this._facaed.RemoveProxy(ProxyNameLib.Proxy_CombatSkillDisplayProxy);
							this._facaed.RemoveProxy(ProxyNameLib.Proxy_CombatMonsterDisplayProxy);
							
							this.Destroy();
						break;
						default ://有特定訊號發送處 代表嵌入探索中處理 
							//共用到的怪物PROXY處理方式 先不移除註冊讓探索處理
							//發送特定通知訊息探索已經關閉戰鬥模式
							//或許需夾帶戰鬥結束的方式分辨出觀看好才關閉或是中途關閉 作為後續關閉後是否顯示勝負的依據 XXNONE OF THIS
							
							//若探索END有移除Combat Monster / Skill 
							
							this.Destroy();
							//trace("收到的探索系統需求訊號字串為>>>      " + String(info._info));
							this.SendNotify(String(info._info),{_status : "CLOSE" , _content : null });//通知戰鬥關閉
							/*
								_status : "LEAVING" , _content : {...}
								_status : "CLOSE"    , _content : null
								_status : "READY"    , _content : null
								會收到的三種可能性 
							 */
							 
							
						break;
					}
					
				break;
				case ArchivesStr.BATTLEIMAGING_VIEW_START://有外部資料匯入需要前置瀏覽動作
					
					var viewBtCommand:Commands = new BattleViewCommand();
					
					if ((_obj.GetClass()["_needPause"])!="") {
						_obj.SetName(ArchivesStr.BATTLEIMAGING_VIEW_PREPARE);
						viewBtCommand.ExcuteCommand(_obj);
					}
					
					_obj.SetName(ArchivesStr.BATTLEIMAGING_VIEW_START);
					viewBtCommand.ExcuteCommand(_obj);//會帶播放資料manager
					
					
					//技能效果庫(需要的效果KEY)  , 怪物素材庫(BattleFighterVO)
					//info["_data"]["_skill"] >> 所有技能KEY(供技能效果PROXY先載入)
					//info["_data"]["_monster"] >> 所有用到的戰鬥怪物素材資料(供動態區塊PROXY先載入)
					
				break;
			}
		}
		
		private function Destroy():void 
		{
			
			this._facaed.RemoveRegisterViewCtrl(ArchivesStr.BATTLEIMAGING_VIEW);
			//移除註冊的BARGroup系統
			BarProxy(this._facaed.GetProxy(CommandsStrLad.BAR_SYSTEM)).RemoveGroup("BattleFieldHp");
			BattleImagingProxy(this._facaed.GetProxy(ArchivesStr.BATTLEIMAGING_SYSTEM)).EndOfShow();
			MotionValue.GetInstance().Reset();//重置動態控制的速率
			trace(VisionCenter.GetInstance().CheckAllRegister());
			//測試重置用
			//BattleImagingProxy.GetInstance().GetHistoricalFilm();
		}
		
		
	}
	
}