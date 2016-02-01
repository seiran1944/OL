package Spark.Utils.SourceArray
{
	//import SourceArray.Calculate;
	
	/**
	 * ...
	 * @author Jerry
	 */
	
	public class ArrayTool
	{
		//底層運算
		private static var _Calculate:Calculate = new Calculate();
		
		//產生隨機陣列(初始,結束,總數,開關)true = 重複 flase = 不重複
		public static function CreateRandom( _Init:uint , _End:uint , _InputNum:int , _InputLock:Boolean ):Array
		{
			return _InputLock == true ? _Calculate.Select_Repeat( _Init , _End , _InputNum ) : _Calculate.Select_NoRepeat( _Init , _End , _InputNum) ;
		}
		
		//取陣列交集
		public static function InterSect( _InputArr1:Array , _InputArr2:Array ):Array {
			return _Calculate.InterSect( _InputArr1 , _InputArr2 );
		}
		
		//氣泡排序演算法
		public static function BubbleSort( _InputArr:Array ):Array
		{
			return _Calculate.BubbleSort(_InputArr);
		}
		
		//插入排序演算法
		public static function InsertionSort( _InputArr:Array ):Array
		{
			return _Calculate.InsertionSort(_InputArr);
		}
		
		//選擇排序演算法
		public static function SelectionSort( _InputArr:Array ):Array {
			return _Calculate.SelectionSort(_InputArr);
		}
		
		//---物件concat實作
		public static function ObjConcat( _InputArr:Array,_other:Array ):Array {
			return _Calculate.ObjConcat(_InputArr,_other);
		}

	}//end class
}//end package