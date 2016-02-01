package MVCprojectOL.ModelOL.Vo {
	//import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldInit;
	//import MVCprojectOL.ModelOL.Vo.ReturnMonster;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.03.21.14.26
	 */
	public class ItemDrop {
		public var _monsters:Array;//掉落的惡魔
		public var _material:Object;//掉落的材料 以GUID為索引  以量計
		public var _items:Array;//掉落的道具
		
		public var _prisoners:Array;//掉落的英雄(俘虜)
		
		public function ItemDrop() {
			
		}
		
		/*public function Track():void {
			trace( "==========================<<<<<<<<<<<<<<<<<<<<<<-----------------------------------RouteNode" );
			trace( "_type :" , this._type );
			trace( "_step :" , this._step );
			trace( "_picKey :" , this._picKey );
			trace( "_newRouteList :" , this._newRouteList );
			trace( "==========================<<<<<<<<<<<<<<<<<<<<<<-----------------------------------RouteNode" );
		}*/
		
		
	}//end class

}//end package