package Spark.MVCs.Models.SourceTools.Loader
{
	import Spark.MVCs.Models.SourceTools.*;
	import Spark.MVCs.Models.SourceTools.Material.MaterialManager;
	
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.07.11
	 * @Explain:LoaderTool 載入工具對外
	 * @playerVersion:11.0
	 */
	 
	
	public class LoaderTool
	{
		
		private var _LoaderControl:LoaderControl;
		
		
		
		public function LoaderTool( _MaterialClass:MaterialManager , _InputDomain:String ):void 
		{
			this._LoaderControl = ( this._LoaderControl != null ) ? this._LoaderControl : new LoaderControl( _MaterialClass , _InputDomain );
		}
		
		//==============================中斷載入處理==================================
		public function LoadInterrupt():void 
		{
			this._LoaderControl.LoadInterrupt();
		}
		
		
		//==============================寫入載入素材位置==============================
		public function InputLoadData( _InputURL:* ):void 
		{
			this._LoaderControl.LoadDataHandler( _InputURL );
		}
		
		//==============================取得素材處理百分比============================
		public function GetMaterialProgress():uint 
		{
			return this._LoaderControl.DataProgressHandler();
		}
		
		
		
	}//end class
}//end package