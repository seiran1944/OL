package  Spark.Utils.KeyCodeInfo
{
	/**
	 * ...
	 * @author K.J. Aris
	 */
	public class UrlData {
		private var _Key:String;
		private var _Type:String;
		private var _Url:String;
		
		public function UrlData( _InputKey:String , _InputType:String , _InputUrl:String ) {
			this._Key = _InputKey;
			this._Type = _InputType;
			this._Url = _InputUrl;
		}
		
		public function get Key():String {
			return _Key;
		}
		
		public function get Type():String {
			return _Type;
		}
		
		public function get Url():String {
			return _Url;
		}
		
	}//end class

}//end package