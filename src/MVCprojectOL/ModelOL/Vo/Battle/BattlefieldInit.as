package MVCprojectOL.ModelOL.Vo.Battle
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.30.10.35
		@documentation 戰場環境設定VO
	 */
	public class BattlefieldInit
	{
		
		//會多加一個編號屬性來當做每一比戰場資料的識別碼
		public var _battleId:String;
		
		public var _objArmy:Object;//玩家隊伍成員資訊 { 位置 : BattleFighter(VO) } >> { 0~8   :   BattleFighterVO   }		//初始資料
		public var _objEnemy:Object;//敵方隊伍成員資訊 { 位置 : BattleFighter(VO) } >> { 0~8   :   BattleFighterVO   }		//初始資料
		public var _areaPic:String;//戰場背景底圖key
		public var _bgMusic:String;//背景音樂
		public var _isWin:Boolean;//我方是(true)  /  否(false)  勝利 
		public var _battleType:int;//戰鬥的種類 ( 1.探索, 2.巡邏隊, 3.PVP, 4.GVG ) // 130227調整過 去掉0
		public var _arySkill:Array;//戰鬥中會用到的所有 技能/效果  key 清單 ( 提前載入避免過程空白) >>> (視狀況調整)
		public var _arySteps:Array;//戰鬥過程的單位動作與回合動作順序VO內容
		//後續移到外層清單
		//public var _aryTeamResult:Array;//我方成員戰鬥結束狀態		//終了資料 (戰報部分會顯示到的資料) [BattleFighter.BattleFighter....]
		//public var _aryEnemyResult:Array;//敵方成員戰鬥結束狀態		//終了資料 (戰報部分會顯示到的資料) [BattleFighter.BattleFighter....]
		
		
		// _arySteps >> 預計取得單一資訊排列方式
		//[BattlefieldSteps,BattlefieldSteps,BattlefieldSteps,BattleRound,BattlefieldSteps,BattlefieldSteps,BattlefieldSteps,BattleRound]
		
	}
	
}