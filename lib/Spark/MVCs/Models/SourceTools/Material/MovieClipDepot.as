package Spark.MVCs.Models.SourceTools.Material
{
	
	import flash.display.MovieClip;
	import Spark.MVCs.Models.SourceTools.Material.MaterialComponent;
	import Spark.MVCs.Models.SourceTools.Material.ComponentBase;
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.09.06
	 * @Explain:MovieClipDepot 素材庫動畫類別
	 * @playerVersion:11.0
	 */
	
	
	public class MovieClipDepot extends MaterialComponent
	{
		
		//=========================加入新元件到素材庫裡=============================
		public function AddNewComponent( _InputURL:String , _InputKey:String , _InputContent:* = null ):void 
		{
			if ( this.CheckMovieClipDepot( _InputKey ) == false )
			{
				//註冊時先給予default素材
				this._Shelf[ _InputKey ] = new ComponentBase( _InputURL , _InputKey , this._Temp[ _InputKey ] );
			}else {
				this._Shelf[ _InputKey ] = null;
				this._Shelf[ _InputKey ] = new ComponentBase( _InputURL , _InputKey , _InputContent );
			}
		}
		
		//=========================移除素材庫的元件=================================
		public function RemoveMovieClipComponent( _InputKey:String ):void 
		{
			if ( this.CheckMovieClipDepot( _InputKey ) == true ) {
				
				this.RemoveComponent( _InputKey );
			}
			
		}
		
		//=========================取得素材庫的元件=================================
		public function GetMaterialComponent( _InputURL:String , _InputKey:String ):* 
		{			
			//安全檢查是否已註冊過
			if ( this.CheckMovieClipDepot( _InputKey ) == false )
			{
				this.AddNewComponent( _InputURL , _InputKey );
			}
			return this._Shelf[ _InputKey ].Content;
		}
		
		//=========================檢查動畫素材庫是否有元件=========================
		public function CheckMovieClipDepot( _InputKey:String ):Boolean 
		{
			return this.Search( _InputKey );
		}
		
		
		
	}//end class
}//end package