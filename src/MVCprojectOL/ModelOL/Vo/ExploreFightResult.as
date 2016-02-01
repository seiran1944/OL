package MVCprojectOL.ModelOL.Vo {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	public class ExploreFightResult {
		public var _CurrentStep:uint;
		public var _AcquiredExp:uint;//獲得的總經驗值 ( 需被記錄下來、戰報 )
		public var _AcquiredItems:Array;//掉落物品清單
		public var _AcquiredMonster:Array;//掉落怪物清單 ( 怪物視作掉落物 隨後台機率發配 )
		public var _TeamStatus:Object;//Object
			/*
			 * Object[ 怪物GUID ]._BloodLost = 怪物損血量;
			 * Object[ 怪物GUID ]._AquiredExp = 怪物獲得的經驗值;
			 * 
			 * */
		
		public function ExploreFightResult() {
			
		}
		
	}//end class
}//end package