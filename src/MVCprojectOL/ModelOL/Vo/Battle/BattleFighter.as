package MVCprojectOL.ModelOL.Vo.Battle
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 初始戰鬥成員資料
	 */
	public class BattleFighter extends BattleBasic
	{
		//繼承的BattleBasic此處夾帶的屬性是當前怪物初始的狀態値(當前値)>> "不包含" 初始技能(靈氣類...)疊加的數值
		public var _name:String;//中文名稱(外文)
		public var _motionItem:String;//單位ANI 素材key ( npc /  怪物 )
		
		public var _scaleRate:Number;//該戰鬥單位的縮放比率來分辨BOSS與一般怪物的差異正常小怪為.6 BOSS 為1
		
		//測試顯示用↓
		public var _jobName:String;//職業的名稱
		public var _jobPic:String;//職業的圖示
		//測試顯示用↑
		
		//技能的BattleBasic夾帶的是技能的影響變更値
		public var _aryEffect:Array;//技能效果的key   (初始就掛載的靈氣之類技能)  [BattleBasic , BattleBasic , ....]
		
		
	}
	
}