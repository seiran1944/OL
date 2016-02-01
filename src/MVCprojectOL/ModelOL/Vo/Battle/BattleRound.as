package MVCprojectOL.ModelOL.Vo.Battle
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 每次回合結束夾帶的區間VO
	 */
	public class BattleRound 
	{
		
		public var _battleEnd:Boolean;//是(true)  /  否(false)已經終止戰鬥(已無後續動作)
		public var _roundEffect:Array;//該回合終了時全場怪物的狀態影響變化 (BattleRoundEffect VO )陣列
		
		
	}
	
}