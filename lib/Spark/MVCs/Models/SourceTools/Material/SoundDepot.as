package Spark.MVCs.Models.SourceTools.Material
{
	
	import Spark.MVCs.Models.SourceTools.Material.MaterialComponent;
	import Spark.MVCs.Models.SourceTools.Material.ComponentBase;
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.09.05
	 * @Explain:SoundDepot 音效類別
	 * @playerVersion:11.0
	 */
	
	
	public class SoundDepot extends MaterialComponent
	{
			
		
		//=========================加入新元件到素材庫裡=============================
		public function AddNewComponent( _InputURL:String , _InputKey:String , _InputContent:* = null ):void 
		{
			if ( this.CheckSoundDepot( _InputKey ) == false )
			{
				this._Shelf[ _InputKey ] = new ComponentBase( _InputURL , _InputKey , _InputContent );
			}
		}
		
		//=========================取得素材庫的元件=================================
		public function GetMaterialComponent( _InputURL:String , _InputKey:String ):* 
		{			
			if ( this.CheckSoundDepot( _InputKey ) == false ){
				this.AddNewComponent( _InputURL , _InputKey );
			}
			return this._Shelf[ _InputKey ].Content;
		}
		
		//=========================檢查音效素材庫是否有元件=========================
		public function CheckSoundDepot( _InputKey:String ):Boolean 
		{
			return this.Search( _InputKey );
		}
		
		
		
	}//end class
}//end package