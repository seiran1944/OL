package MVCprojectOL.ViewOL.SharedMethods 
{
	/**
	 * ...
	 * @author brook
	 */
	public class SplitPageMethod 
	{
		
		public function SplitPage( _InputMainList:* , _InputNumPerPage:uint ):Array {
			//切頁
			var _Result:Array = [];
			var _MaxPage:uint = Math.ceil( _InputMainList.length / _InputNumPerPage );
			var _CurrentFront:uint = 0;
			var _CurrentPage:Array;
			
			for (var i:uint = 0; i < _MaxPage; i++) {
				_CurrentPage = new Array();
				for (var j:uint = 0; j < _InputNumPerPage ; j++) {
					_CurrentFront = _InputNumPerPage * i + j;
					if ( _CurrentFront < _InputMainList.length ) {
						_CurrentPage.push( _InputMainList[ _CurrentFront ] );
					}else {
						break;
					}
				}//end for j
				_Result.push( _CurrentPage );
			}//end for i
			return _Result;
		}
		
	}
}