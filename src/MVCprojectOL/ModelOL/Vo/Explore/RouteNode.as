package MVCprojectOL.ModelOL.Vo.Explore 
{
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldInit;
	import MVCprojectOL.ModelOL.Vo.ReturnMonster;
	import MVCprojectOL.ModelOL.Vo.ItemDrop;
	
	import MVCprojectOL.ModelOL.Vo.Buildschedule;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.11.09
	 */
	public class RouteNode {
		//public var _type:uint;//該節點的類型	//0.沒事, 1.惡魔, 2.寶箱, 3.安全, 4.魔王
		
		//public var _step:uint = 0;
		
		public var _newRouteList:Array = [ ];		//裡面包含3個RouteNode
		
		//public var _picKey:String;//該節點的背景圖片KEY
		
		public var _battleScript:BattlefieldInit;	//戰鬥資訊
		
		public var _oldValuePack:Object;	//怪物的原始資訊  //130520 _hp _lv _exp _nextExp
		public var _valuePack:Object;	//怪物的更新資訊  _hp _lv _exp _nextExp
		
		public var _itemDrop:ItemDrop;	//掉落表
		
		public var _buildSchedule:Buildschedule;	//130520
		
		//public var _oldValuePack:Object;	//130516
		
		public function RouteNode() {
			
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