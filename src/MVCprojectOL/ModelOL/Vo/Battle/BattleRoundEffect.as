package MVCprojectOL.ModelOL.Vo.Battle
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 該回合終了階段狀態影響"單位"的變化
	 */
	public class BattleRoundEffect
	{
		
		public var _guid:String;
		public var _place:int;//所在陣型位置
		public var _ourSide:Boolean;//所在的陣營 >>    我方 > true    /    敵方 > false
		public var _aryEffect:Array;//此次回合既有的技能效果影響  [BattleBasic , BattleBasic , ....]>>(要播放)
		public var _aryDeEffect:Array;//此次回合移除的技能效果   [BattleBasic , BattleBasic , ....]>>(不播放)
		
		
		//若有幾回合後增加BUFF的技能則需再增加屬性
	}
	
}