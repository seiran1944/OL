package MVCprojectOL.ModelOL.Explore.Vo {
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.04.01.10.51
	 */
	 
	 
	public class ExploreReport {
		
		public var _exploreArea:ExploreArea;
		
		public var _success:Boolean;
		
		public var _teamMonsterDisplays:Object;	//己方惡魔 MonsterDisplay
		public var _acquiredMonsterDisplays:Array;	//掉落的惡魔	MonsterDisplay
		public var _acquiredMaterialDisplays:Array;	//掉落的材料	ItemDisplay
		public var _acquiredItemsDisplays:Array;	//掉落的道具	ItemDisplay
		
		public var _acquiredPrisonersDisplays:Array;	//掉落的英雄(俘虜)	MonsterDisplay
		
		public var _LvUpList:Array;
		
		public function ExploreReport() {
			
		}
		

		
		
	}//end class

}//end package