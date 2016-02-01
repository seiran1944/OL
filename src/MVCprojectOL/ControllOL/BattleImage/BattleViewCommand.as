package MVCprojectOL.ControllOL.BattleImage
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.BattleImaging.BattleManager;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.CombatMonsterDisplayProxy;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplayProxy;
	import MVCprojectOL.ModelOL.TipsCenter.TipsLab.TipsDataLab;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import MVCprojectOL.ViewOL.BattleView.BattleSpace;
	import MVCprojectOL.ViewOL.BattleView.BattleViewCtrl;
	import MVCprojectOL.ViewOL.BattleView.BloodZone;
	import MVCprojectOL.ViewOL.BattleView.EffectZone;
	import MVCprojectOL.ViewOL.BattleView.FighterArea;
	import MVCprojectOL.ViewOL.BattleView.IconZone;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.BarTool.BarProxy;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.MVCs.Models.TextDriftTool.TextDriftProxy;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ArchivesStr;
	import strLib.vewStr.ViewStrLib;
	import flash.utils.getQualifiedSuperclassName
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class BattleViewCommand extends Commands 
	{
		
		private var _sourceKey:String="GUI00010_ANI";//素材KEY
		private var _aryBasicSource:Vector.<String> = new < String > ["bg1", "triangleArea", "roundBoard", "bottomWall", "hpBar", "infoBoard", "play", "pause", "faster", "leave", "word_fight", "word_lose", "word_win", "word_miss"];//Class KEY
		//20130524 LOG用字串
		private var _aryLogTips:Array = [];//TEST 待後臺填寫後補足所需字串  <FIGHT_LOG_STR01~FIGHT_LOG_STR22>
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			
			var battleView:BattleViewCtrl ;
			
			switch (_obj.GetName()) 
			{
				case ArchivesStr.BATTLEIMAGING_VIEW_PREPARE://先處理好背景圖並顯示Loading狀態處理
					
					var sTool:SourceProxy = this._facaed.GetProxy(CommandsStrLad.SourceSystem) as SourceProxy;
					var objSource:Object = sTool.GetMaterialSWP(this._sourceKey, this._aryBasicSource);
					
					objSource.bloodMath = sTool.GetMaterialSWP(PlayerDataCenter.GetInitUiKey("SysUI_Number")[0], "bloodMath");
					objSource.cureMath = sTool.GetMaterialSWP(PlayerDataCenter.GetInitUiKey("SysUI_Number")[0], "cureMath");
					objSource.basicMath = sTool.GetMaterialSWP(PlayerDataCenter.GetInitUiKey("SysUI_Number")[0], "basicMath");
					
					//有圖檔的話可用objSource.background屬性指定bitmapdata
					var carpetKey:String = _obj.GetClass()._data._bgKey;
					if (carpetKey != "") objSource.background = sTool.GetImageBitmapData(carpetKey);
					
					//素材夾帶LOADING顯示
					objSource.loading = sTool.GetLoadingMark();//起始載入圖示
					//objSource.showOP = sTool.GetMovieClipHandler(new objSource[this._aryBasicSource["n"]]);//起始開戰過場
					
					//monsterProxy InitDataCreate
					//this._facaed.RegisterProxy(CombatMonsterDisplayProxy.GetInstance());
					//var vecD:Vector.<MonsterDisplay>=CombatMonsterDisplayProxy.GetInstance().GetMonsterDisplayList(_obj.GetClass()["_data"]["_monster"] as Vector.<BattleFighter>);//導入Vector<BattleFighter>
					//trace(vecD);
					//ViewCtrl Init
					var spFightUse:Sprite = new Sprite();
					spFightUse.name = "BattleViewArea";
					ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).addChild(spFightUse);
					battleView = new BattleViewCtrl(ArchivesStr.BATTLEIMAGING_VIEW,spFightUse);
					this._facaed.RegisterViewCtrl(battleView);
					
					
					//下方城牆區塊方式處理
					//var wallLayer:MainSystemPanel = this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main) as MainSystemPanel;
					//wallLayer.AddClass(IconZone);
					//導入BARGROUP處理(移除時也需由Bar系統中移除)
					//wallLayer.AddSingleSource("barGroup", BarProxy(this._facaed.GetProxy(CommandsStrLad.BAR_SYSTEM)).RegisterGroup("BattleFieldHp"));
					//wallLayer.AddSingleSource("", objSource);
					
					//下方自轉式處理
					var iconZone:IconZone = new IconZone();
					iconZone.AddSource("barGroup", BarProxy(this._facaed.GetProxy(CommandsStrLad.BAR_SYSTEM)).RegisterGroup("BattleFieldHp"));
					iconZone.AddSource("", objSource);
					
					battleView.LayACarpet(objSource,iconZone);//背景設置(同時會運作場景動態效果,須搭配下方城牆時間配合處理)
					
					var aryShowLayer:Array = [new FighterArea(), new FighterArea(), new EffectZone(), new BloodZone()];
					var dicLocate:Dictionary = new Dictionary(true);//由FighterArea對有用到的位置置作座標清單
					var leng:int = aryShowLayer.length;
					var area:BattleSpace;
					for (var i:int = 0; i < leng; i++) 
					{
						area = aryShowLayer[i];
						area.SetLocationInfo(dicLocate);
						area.InSource(objSource);
					}
					battleView.InFightArea(aryShowLayer);
					battleView.RunLoading();
				break;
				case ArchivesStr.BATTLEIMAGING_VIEW_START://取消Loading狀態處理並初始化顯示流程
					
					battleView = this._facaed.GetRegisterViewCtrl(ArchivesStr.BATTLEIMAGING_VIEW) as BattleViewCtrl;
					//領取skill效果庫 / 怪物動態庫
					
					//前置的資料導入
					var battlePool:BattleManager = _obj.GetClass()["_data"]["_manager"] as BattleManager;
					//battlePool.
					battleView.InDocumentary(battlePool,CombatMonsterDisplayProxy.GetInstance());//會帶播放資料manager /另外夾帶怪物顯示層的模組
					
					battleView.InSkill(CombatSkillDisplayProxy.GetInstance());//帶入技能的proxy (型別未知)
					
					//戰場LOG字串需要的索引字產生(目前是連續的)
					for (var j:int = 0; j < 22; j++) 
					{
						this._aryLogTips.push("FIGHT_LOG_STR" + (j < 9 ? "0" + String(j + 1) : String(j + 1)));
					}
					
					//20130524 導入LOG所需要的字串
					battleView.SetLogInfoTips(TipsDataLab.GetTipsData().GetTipsGroup(this._aryLogTips));
					
					battleView.ToStart(_obj.GetClass()["_data"]["_needPause"]);//確認開始運行(同時會停止LOADING運作)
				break;
			}
			
			
			
			
		}
		
		
	}
	
}