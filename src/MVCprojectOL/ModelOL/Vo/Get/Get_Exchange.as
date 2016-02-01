package MVCprojectOL.ModelOL.Vo.Get{
   import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author ...ericHuang----
	 * 搜尋條件---
	 */
	public class Get_Exchange extends VoTemplate
	{
		//---0=stone/1=武器/2=防具/3=飾品/4=monster
		public var _type:int = -1;
		
		public var _searchName:String = "";
		
		public var _moneyMax:int = -1;
		
		//----level/health/attack/defence/speed/intelligence/spirit/money
		public var _sortType:String="";
		
		//---大>>小[desc]/小>>大[asc]
		public var _upDown:String = "";
		
		public var _rank:int = -1;
		
		//---頁數
		public var _page:int = 1;
		
		//---搜尋條件(物件陣列)
		public var _objSearchCondition:Object ={};
		
		public function Get_Exchange() 
		{
			super("Get_Exchange");
		}
		
		//---搜尋初始
		/*
		public var _beginLv:int = -1;
		public var _beginHp:int = -1;
		public var _beginAtk:int = -1;
		public var _beginDef:int = -1;
		public var _beginMnd:int = -1;
		public var _beginInt:int = -1;
		public var _beginSpd:int = -1;
		
		//---搜尋上限
		public var _maxLv:int = -1;
		public var _maxinHp:int = -1;
		public var _maxinAtk:int = -1;
		public var _maxinDef:int = -1;
		public var _maxinMnd:int = -1;
		public var _maxinInt:int = -1;
		public var _maxinSpd:int = -1;
		*/
	}
	
}