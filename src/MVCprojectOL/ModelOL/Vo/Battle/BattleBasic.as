package MVCprojectOL.ModelOL.Vo.Battle
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 需顯示的戰鬥單位屬性 or  技能 影響的變更屬性値
	 */
	public class BattleBasic 
	{
		
		public var _guid:String;
		
		//---攻擊
	    public var _atk:int;
		//---防禦
	    public var _def:int;
		//--敏捷
	    public var _agi:int;
		//----智力
	    public var _int:int;
		//---精神
	    public var _mnd:int;
		//---生命值
		public var _hp:int;
		//---最大生命値
		public var _maxHp:int;
		
	}
	
}