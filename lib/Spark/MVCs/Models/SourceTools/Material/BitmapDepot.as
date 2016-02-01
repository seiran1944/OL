package Spark.MVCs.Models.SourceTools.Material
{
	
	import Spark.MVCs.Models.SourceTools.Material.MaterialComponent;
	import Spark.MVCs.Models.SourceTools.Material.ComponentBase;
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.08.08
	 * @Explain:BitmapDepot 素材庫圖像類別
	 * @playerVersion:11.0
	 */
	
	
	public class BitmapDepot extends MaterialComponent
	{
			
		
		//=========================加入新元件到素材庫裡=============================
		public function AddNewComponent( _InputURL:String , _InputKey:String , _InputContent:* = null ):void 
		{
			if ( this.CheckBitmapDepot( _InputKey ) == false )
			{
				this._Shelf[ _InputKey ] = new ComponentBase( _InputURL , _InputKey , this._Temp[ _InputKey ] );
				//trace("註冊新的成員!" + _InputKey );
			}else {
				this._Shelf[ _InputKey ] = null;
				this._Shelf[ _InputKey ] = new ComponentBase( _InputURL , _InputKey , _InputContent );
				//trace("已註冊過啦!" + _InputKey );
			}
			//_InputContent == null ? : ;
		}
		
		//=========================移除素材庫的元件=================================
		public function RemoveBitmapComponent( _InputKey:String ):void 
		{
			if ( this.CheckBitmapDepot( _InputKey ) == true ) {
				
				this.RemoveComponent( _InputKey );
			}
			
		}
		
		//=========================取得素材庫的元件=================================
		public function GetMaterialComponent( _InputURL:String , _InputKey:String ):* 
		{			
			if ( this.CheckBitmapDepot( _InputKey ) == false ){
				//trace("先註冊新的" + _InputKey );
				this.AddNewComponent( _InputURL , _InputKey );
			}
			
			return this._Shelf[ _InputKey ].Content;
		}
		
		//=========================檢查圖像素材庫是否有元件=========================
		public function CheckBitmapDepot( _InputKey:String ):Boolean 
		{
			return this.Search( _InputKey );
		}
		
		
		
	}//end class
}//end package