package MVCprojectOL.ModelOL.Vo.Battle
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 回合運行下單位的影響變化
	 */
	public class BattleEffect extends BattleBasic
	{
		//繼承的BattleBasic此處夾帶的屬性是當前怪物受到攻擊的該單位狀態變更値 (GUID 為怪物GUID)
		
		public var _place:int;//所在陣型位置
		public var _ourSide:Boolean;//所在的陣營 >>    我方 > true    /    敵方 > false
		public var _atkHit:Boolean;//被攻擊 ( 施放 ) 的結果( false > 攻擊失敗 , true > 攻擊命中 )
		//技能的BattleBasic為該技能的影響增減數值
		public var _aryEffect:Array;//此次動作增加的技能效果 (成功命中)  [BattleBasic , BattleBasic , ....]>>(要播放)
		public var _aryDeEffect:Array;//此次動作減少的技能效果(加成類去除之類的可能性)[BattleBasic , BattleBasic , ....]>>(不播放)
		
		
	}
	
}