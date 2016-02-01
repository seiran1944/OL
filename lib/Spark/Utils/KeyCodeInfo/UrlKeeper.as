package Spark.Utils.KeyCodeInfo{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import Spark.Utils.KeyCodeInfo.UrlData;
	 
	public class UrlKeeper {
		
		private static const _UrlList:Dictionary = new Dictionary();
		
		public static function init():void {
			
			/*var _KeyCodeBase:uint = 100000;
			var _KeyCode:String;
			var _KeyCodeBaseString:String;
			for ( var i:* in _BitmapUrl ) {
				_KeyCode = _BitmapTypeCode + String( _KeyCodeBase + (i+1) ).slice( 1, 6);
				_UrlList[ _KeyCode ] = new UrlData( _KeyCode , _BitmapTypeCode , _BitmapUrl[ i ] );
				//trace( _KeyCode );
			}
			
			_KeyCodeBase = 100000;
			for ( var j:* in _SwfUrl ) {
				_KeyCode = _SwfTypeCode + String( _KeyCodeBase + (j+1) ).slice( 1, 6);
				_UrlList[ _KeyCode ] = new UrlData( _KeyCode , _SwfTypeCode , _SwfUrl[ j ] );
				//trace( _KeyCode );
			}
			
			for ( var k:* in _UrlList ) {
				//trace( k , _UrlList[ k ].Url );
			}*/
			
			
		}
		
		public static function addUrlCode( _InputKey:String , _InputType:String , _InputUrl:String ):void {
			//Note : 重複的Key code會被後者覆蓋掉
			UrlKeeper._UrlList[ _InputKey ] = new UrlData( _InputKey , _InputType , _InputUrl );
		}
		
		
		
		public static function getType( _InputKey:String ):String {
			return ( _UrlList[ _InputKey ] != null ) ? _UrlList[ _InputKey ].Type : "0";
		}
		
		public static function getUrl( _InputKey:String ):String {
			return ( _UrlList[ _InputKey ] != null ) ? _UrlList[ _InputKey ].Url : "null";
		}
		
		public static function getCodeData( _InputKey:String ):UrlData {
			return ( _UrlList[ _InputKey ] != null ) ? _UrlList[ _InputKey ] : null ;
		}
		
		public static function getKeyByUrl( _InputUrl:String ):String {
			var _ReturnKey:String = "0";
			for (var i:* in _UrlList ) {
				if ( _UrlList[ i ].Url == _InputUrl ) {
					_ReturnKey = i;
					break;
				}
			}
			return _ReturnKey;
		}
		
		public static function getTypeByUrl( _InputUrl:String ):String {
			var _ReturnType:String = "0";
			for (var i:* in _UrlList ) {
				if ( _UrlList[ i ].Url == _InputUrl ) {
					_ReturnType = _UrlList[ i ].Type;
					break;
				}
			}
			return _ReturnType;
		}
		
		
	}//end class

}//end package