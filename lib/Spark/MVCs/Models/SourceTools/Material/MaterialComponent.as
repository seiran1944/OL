package Spark.MVCs.Models.SourceTools.Material
{
	import flash.utils.Dictionary;
	
	
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.07.24
	 * @Explain:MaterialComponent 素材庫基底元件==>抽象類別
	 * @playerVersion:11.0
	 */
	
	
	public class MaterialComponent
	{
		//實際元件清單
		public var _Shelf:Dictionary = new Dictionary(true);
		//預設元件清單
		public var _Temp:Dictionary = new Dictionary(true);
		
		
		//---------------------搜尋元件清單---------------------
		public function Search( _InputKey:String ):Boolean
		{
			return this._Shelf[ _InputKey ] == null ? false : true ;
		}
		
		//---------------------加入新增元件---------------------
		public function AddComponent( _InputKey:String , _Component:* ):void 
		{
			this._Shelf[ _InputKey ] = _Component;
		}
		
		//---------------------移除清單的元件-------------------
		public function RemoveComponent( _InputKey:String ):void 
		{
			this._Shelf[ _InputKey ] = null;
			delete this._Shelf[ _InputKey ];
		}
		
		//---------------------寫入預設元件清單-----------------
		public function AddDefault( _InputKey:String , _Component:* ):void 
		{
			this._Temp[ _InputKey ] = _Component;
		}
		
		//---------------------移除預設元件清單-----------------
		public function RemoveDefault( _InputKey:String ):void 
		{
			this._Temp[ _InputKey ] = null;
			delete this._Temp[ _InputKey ];
		}
		
		
		
	}//end class
}//end package