package Spark.Utils.SourceArray
{
	
	/**
	 * ...
	 * @author Jerry
	 */
	
	public dynamic class Calculate
	{
		//產生重複亂數陣列
		public function Select_Repeat( _Init:uint , _End:uint , _InputNum:int ):Array {
			var _Result:int;
			var _RandomArr:Array = [];
			var _SameLock:Boolean = false;
			var _Step:int = _End - _Init;
			
			for (var i:int = 1; i <= _InputNum; i++ ) {
				_Result = Math.floor(Math.random() * _Step + _Init );
				_RandomArr.push(_Result);
			}
			return _RandomArr;
		}
		//產生不重複亂數陣列
		public function Select_NoRepeat( _Init:uint , _End:uint , _InputLimit:int ):Array 
		{
			var _Result:int;
			var _RandomArr:Array = [];
			var _ResultArray:Array = new Array();
			
			for (var i:int = _Init; i <= _End ; i++ ) {
					_RandomArr.push(i);
			}
			Shuffle( _RandomArr );
			for ( var _K:uint = 0 ; _K < _InputLimit ; _K++ ) {
				if ( _K < _RandomArr.length ) {
					_ResultArray.push( _RandomArr[_K] );
				}else {
					break;
				}
			}
			return _ResultArray;
		}
		
		//陣列洗牌(可獨立給外部調用)
		public function Shuffle(  _InputArray:Array  ):Array {
			var _RandIndex:int = 0;
			var _len:int = _InputArray.length - 1;
			for (var a:int = 0; a < _len; a++) {
				_RandIndex = Math.round( Math.random()*( _InputArray.length -1 ) );
				Swap( _InputArray , a , _RandIndex );
			}
			return _InputArray;
		}
		//兩兩交換
		private function Swap( _InputArray:Array , i:int , j:int ):void {
			var _Temp:int = _InputArray[i];
			_InputArray[i] = _InputArray[j];
			_InputArray[j] = _Temp;
		}
		
		//氣泡排序運算
		public function BubbleSort( _InputArr:Array ):Array
		{
			var ResultArr:Array = _InputArr;
			
			for (var i:int = 1; i < ResultArr.length;i++ ) {
				for (var j:int = 0; j < (ResultArr.length - i); j++ ) {
					//trace("11", ResultArr[j], ResultArr[j+1]);
					if (ResultArr[j] > ResultArr[j+1]) {
						var temp:Number = ResultArr[j];
							ResultArr[j] = ResultArr[j + 1];
							ResultArr[j + 1] = temp;
					}
				}
			}
			return ResultArr;
		}
		
		//插入排序運算
		public function InsertionSort( _InputArr:Array ):Array
		{
			var ResultArr:Array = _InputArr;
			for(var i:int = 1; i < ResultArr.length; i++) {   
            var temp:Number = ResultArr[i];   
            var j:int = i - 1;   
			
            while((j>=0) && (ResultArr[j] > temp)) {   
               ResultArr[j+1] = ResultArr[j];           
               j--;   
            }   
				ResultArr[j+1] = temp;   
			}
			return ResultArr;
		}
		
		//選擇排序運算
		public function SelectionSort( _InputArr:Array ):Array {
			//trace("SelectionSort");
			var ResultArr:Array = _InputArr;
			for (var i:int = 0; i < ResultArr.length - 1; i++) {
				for (var j:int = i + 1; j < ResultArr.length; j++) {
					if (ResultArr[j] < ResultArr[i]) {
						Swap(ResultArr, i, j);
					}
				}
			}
			return ResultArr;
		}
		
		//陣列交集運算
		public function InterSect( _InputArr1:Array , _InputArr2:Array ):Array {
			var ResultArr:Array = [];// _InputArr1.concat(_InputArr2);
			
			for (var i:int = 0; i < _InputArr1.length; i++ ) {
				for (var j:int = 0; j < _InputArr2.length; j++ ) {
					
					if (_InputArr1[i] == _InputArr2[j]) {
						//trace("=====>",_InputArr1[i]);
						ResultArr.push( _InputArr1[i] );
						_InputArr1.splice(i,1);
						
					}
				}
			}
			return ResultArr;
		}
		
		
		
		public function ObjConcat(_target:Array,_otherAry:Array):Array 
		{
			//var _return:Array;
			var _targetA:Array = (_target!=null)?null:_target.slice(0);
			var _len:int = (_otherAry!=null)?_otherAry.length:-1;
			if (_len>0 && _targetA!=null) {
				for (var i:int = 0; i < _len;i++ ) {
					_targetA.push(_otherAry[i]);
					
				}
				
			}
			return _otherAry;
			
		}
	
	
	
	

   
	}
	
	
	
	
	
	//end class
}//end package