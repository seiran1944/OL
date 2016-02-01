package MVCprojectOL.ModelOL.Vo.Battle
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation  一隻怪物的一次動作
	 */
	public class BattlefieldSteps extends BattleBasic
	{
		//此處繼承的Battlebasic為攻擊者本身的數值變化 >> 其GUID為狀態變化時需要播放的效果KEY
		
		public var _userSide:Boolean;//此次運作方 是(true)  /  否(false)  為玩家方
		public var _attacker:int;//攻擊者位置
		public var _spellSkill:String;//施放的技能key (空字串為普通攻擊)
		public var _defender:Array;//被攻擊者影響變更 [BattleEffect , BattleEffect , BattleEffect , BattleEffect...] //對像1則[BattleEffect]
		
		
		
		//public var _spellSide:int;//施放技能的區塊 ( 0 >> 我方 , 1 >> 敵方 ,  2 >> 雙方 )   //可能會去技能庫內撈
		//public var _aryAnnex:Array;//攻擊後所附加的技能影響key  ( 混亂 , 睡眠 , 麻痺 , 流血... )
		//public var _atkResult:int;//攻擊的結果( 0 攻擊失敗 , 1 攻擊命中 )
		
		
	}
	
}