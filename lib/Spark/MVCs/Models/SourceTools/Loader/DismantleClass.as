package Spark.MVCs.Models.SourceTools.Loader
{
	import flash.display.Loader;
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.10.04
	 * @Explain:DismantleClass 資源工具===>拆解Swf的class工具
	 * @playerVersion:11.0
	 */
	
	
	public class DismantleClass {
		
		private var _Loader:Loader;
		
		
		
		public function InputLoader( _InputTarget:Loader ):void 
		{
			this._Loader = _InputTarget;
		}
		
		//取得類別
		public function GetClass( className:String ):Class {
				return Class( this._Loader.contentLoaderInfo.applicationDomain.getDefinition(className) ) ;
		}
		
		//檢查是否含有該類別
		private function HasClass(className:String):Boolean {
			return this._Loader.contentLoaderInfo.applicationDomain.hasDefinition(className);
		}
		
		//檢查需求清單內的類別   並將 可用類別 編為清單回傳
		public function GetListedClass( _InputClassNameList:Vector.<String> ):Object
		{
			var _OutputClassList:Object = new Object();
			
			for( var i:int = 0 ; i < _InputClassNameList.length ; i++ ){
				if( this.HasClass( _InputClassNameList[i] ) == true ){
					_OutputClassList[ _InputClassNameList[i] ] = this.GetClass( _InputClassNameList[i] );
				}
			}
			return _OutputClassList;
		}
		
	}//end class
}//end package