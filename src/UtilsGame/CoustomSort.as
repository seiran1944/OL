package UtilsGame
{
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import Spark.Utils.SourceArray.Calculate;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class CoustomSort extends Calculate 
	{
		
		
		private static var _sortType:String = "";
		
		public static function set sortType(value:String):void{CoustomSort._sortType = value;}
		//----預設(小>大)
		private static var _sortVauleOne:int = 1;
		private static var _sortVauleTwo:int = -1;
		
		//-----改變排序法則
		public static function ChangeSortVaule(_flag:int):void 
		{
			if (_flag<1) {
				CoustomSort._sortVauleOne = -1;
				CoustomSort._sortVauleTwo = 1;
			}else {
				CoustomSort._sortVauleOne = 1;
				CoustomSort._sortVauleTwo = -1;
			}
			
		}
		
		
		private static function CheckVauleHandler(_obj:Object):Number 
	    {
		var _sortVaule:Number;
		switch(CoustomSort._sortType) {
			case PlaySystemStrLab.Sort_Atk:
			  //-----自定內容
			 _sortVaule= _obj._atk;
			break;	
			
		    case PlaySystemStrLab.Sort_Def:
			 _sortVaule=_obj._def;
			break;
			
		    case PlaySystemStrLab.Sort_HP:
			 _sortVaule=_obj._nowHp;
			break;
			
			
		    case PlaySystemStrLab.Sort_Int:
			  _sortVaule=_obj._Int;
			break;
			
		    case PlaySystemStrLab.Sort_LV:
			  _sortVaule=_obj._lv;
			break;
			
		    case PlaySystemStrLab.Sort_Mnd:
			  _sortVaule=_obj._mnd;
			break;
			
		    case PlaySystemStrLab.Sort_SoulAbility:
			 // _obj._soulAbility;
			break;
			
		    case PlaySystemStrLab.Sort_SoulHP:
			  //_obj._heroHP;
			break;
			
		    case PlaySystemStrLab.Sort_Speed:
			 _sortVaule= _obj._speed;
			break;
			
			//---裝備品質
		    case PlaySystemStrLab.Sort_EquQuality:
			  _sortVaule=_obj._quality;
			break;
			
			//---裝備GUID
			case PlaySystemStrLab.Sort_EquGuid:
			  _sortVaule=_obj._guid;
			break;
			
			//---依照流水編號來排序
			case PlaySystemStrLab.Sort_Index:
			  _sortVaule=_obj._sortIndex;
			break;
		}
		return _sortVaule;
		
	}
	
	
	
	public static function SortHandler(a:Object,b:Object):Number{
		//var _str:int= _args[0];
		var _aObj:Number = CoustomSort.CheckVauleHandler(a);
		var _bObj:Number = CoustomSort.CheckVauleHandler(b);
		if(_aObj > _bObj) {
                 //return 1---old(小>大);
                 return CoustomSort._sortVauleOne;
                  } else if(_aObj < _bObj) {
                  //return -1---(小>大);
                  return CoustomSort._sortVauleTwo;
               } else  {
                  //_aObj == _aObj
                 return 0;
            }
		
	}
	
		
		
	}
	
}