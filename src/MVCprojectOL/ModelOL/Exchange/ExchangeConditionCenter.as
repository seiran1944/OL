package MVCprojectOL.ModelOL.Exchange
{
	import MVCprojectOL.ModelOL.Vo.Get.Get_Exchange;
	//import mx.messaging.channels.StreamingConnectionHandler;
	
	/**
	 * ...
	 * @author ...ericHuang----
	 */
	public class  ExchangeConditionCenter
	{
		//--計算搜尋條件
		private var _get_Exchange:Get_Exchange;
		
		//---計算條件
		private var _objCondition:Object;
		
		public function ExchangeConditionCenter() 
		{
			this._objCondition = { };
			this._get_Exchange = new Get_Exchange();
		}
		
		
		public function get get_Exchange():Get_Exchange 
		{
			this._get_Exchange._objSearchCondition = this._objCondition;
			return _get_Exchange;
		}
		/*
		public function Init():void 
		{
			if (this._get_Exchange == null) this._get_Exchange = new Get_Exchange();
		}
		*/
		//---重新設定交易所的條件----
		public function ResetExchangeHandler():void 
		{
		    if (this._get_Exchange == null) {
				this._get_Exchange = new Get_Exchange();
				
				return;
				} else {
				this._get_Exchange._type = -1;
				this._get_Exchange._searchName = "";
				this._get_Exchange._moneyMax = -1;
				this._get_Exchange._sortType = "";
				this._get_Exchange._upDown = "";
				this._get_Exchange._rank = -1;
				this._get_Exchange._page = 1;
				this._get_Exchange._objSearchCondition = {};
				this._objCondition = { };
			} 
			
		}
		
		//---0=stone/1=武器/2=防具/3=飾品/4=monster5k42u03
		public function set type(_int:int):void 
		{
			
            this._get_Exchange._type = _int;
		}
		
		
		public function set searchName(_str:String):void 
		{
			this._get_Exchange._searchName = _str;
		}
		
		public function set moneyMax(_max:int):void 
		{
			this._get_Exchange._moneyMax = _max;
		}
		
		public function set sortType(_strSort:String):void 
		{
			this._get_Exchange._sortType = _strSort;
		}
		
		public function set upDown(_str:String):void 
		{
			this._get_Exchange._upDown = _str;
		}
		
		public function set quality(_int:int):void 
		{
			this._get_Exchange._rank = _int;
		}
		
		public function set page(_int:int):void 
		{
			this._get_Exchange._page = _int;
		}
		
		//----有在塞..沒有就不塞
		/*{
		LV:[min,max],
		HP:[min,max],
		Atk:[min,max],
		Def:[min,max],
		spd:[min,max],
		int:[min,max],
		mnd:[min,max]
		
	    }*/
		
		public function  AddCondition(_type:String,_min:int,_max:int):void 
		{
		    this._objCondition[_type] = [_min, _max];
		    //this._get_Exchange._objSearchCondition[_type] = [_min, _max];
			
		}
		
		//---清除條件範圍物件(刪除)
		public function set CleanCondition(_type:String):void 
		{
			for (var i:String in this._get_Exchange._objSearchCondition) {
			    if (i == _type && this._objCondition[i]!=undefined) {
					delete this._objCondition[i];
                    break;
				} 	
				
			}
		}
		
		
		
		/*
		public function set arySearchCondition(_obj:Object):void 
		{
			var _ary:Array = [];
			for each(var i:String in _obj) {
			    var _objCondition:Object = { i:_obj[i]};
				_ary.push(_objCondition);
				
			}
			this._get_Exchange._arySearchCondition = _ary;
		}
		*/
	}
	
}