package Spark.MVCs.Models.SourceTools.Material
{
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import Spark.MVCs.Models.SourceTools.Loader.LoaderTool;
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	import Spark.Utils.KeyCodeInfo.UrlKeeper;

	
	
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.10.11
	 * @Explain:MaterialManager 素材庫管理者
	 * @playerVersion:11.0
	 * 
	 * @Modifier : K.J. Aris
	 * @version : 2013.01.02
	 */
	import Spark.MVCs.Models.SourceTools.Material.SerialBitmapDepot;
	
	public class MaterialManager
	{
		//載入器
		private var _Loader:LoaderTool;
		//LoadingBar元件
		private var _LoadingBar:Class;
		//Bitmap元件庫
		private var _BitmapDepot:BitmapDepot;	
		//MovieClip元件庫
		private var _MovieClipDepot:MovieClipDepot;
		//Sound元件庫
		private var _SoundDepot:SoundDepot;
		//SWF元件庫
		private var _SwfDepot:SwfDepot;
		
		//序列圖檔			
		private var _SerialBitmapDepot:SerialBitmapDepot;//K.J. Aris 20130102
		
		//------------------記錄KeyCodeInfo-----------------
		//記錄URL位置
		private	var _Url:String = "";
		//記錄檔案類型
		private	var _File:String = "";
		
		//------------------音效載入------------------------
		private var _Domain:String;
		private var _SoundLoader:Sound = new Sound();
		
		
		
		public function MaterialManager( _InputDomain:String )
		{
			//trace("素材系統建構");
			this._Domain = _InputDomain;
			
			this._LoadingBar = LoadingBar;
			
			this._BitmapDepot = new BitmapDepot();
			
			this._MovieClipDepot = new MovieClipDepot();
			
			this._SwfDepot = new SwfDepot();
			
			this._SoundDepot = new SoundDepot();
			
			this._SerialBitmapDepot = new SerialBitmapDepot();
		}
		
		//===============================加入預設Default元件================================
		public function AddDefaultComponent( _InputKey:String , _type:String , _component:* ):void 
		{
			switch( true )
			{
				//加入bitmap的default素材
				case( _type == "bmp" || _type == "jpg" || _type == "png" ):
					this._BitmapDepot.AddDefault( _InputKey , _component );
					break;
				
				//加入MoiveClip的default素材
				case( _type == "swf" ):
					this._MovieClipDepot.AddDefault( _InputKey , _component );
					break;
					
				//加入SWF元件庫的Default素材
				case( _type == "swp" ):
					//trace("加入SWP元件Default====>" , _component );
					this._SwfDepot.AddDefault( _InputKey , _component );
					break;
			}
			
		}
		
		
		//===============================檢查素材庫是否有元件===============================
		public function CheckLibraryDepot( _InputKey:String , _FileType:String ):Boolean 
		{
			var _check:Boolean = false;
			
			//trace("檢查元件檔案類型: " + _File );
			switch( true )
			{
				//Bitmap類型
				case ( _FileType == "bmp" || _FileType == "jpg" || _FileType == "png" ):
					_check = this._BitmapDepot.CheckBitmapDepot( _InputKey );
					break;
				
				//MovieClip類型
				case ( _FileType == "swf" ):
					_check = this._MovieClipDepot.CheckMovieClipDepot( _InputKey );
					break;
				
				//Swf元件庫類型
				case ( _FileType == "swp" ):
					_check = this._SwfDepot.CheckMovieClipDepot( _InputKey );
					break;	
				
				//Sonud類型
				case ( _FileType == "mp3" ):
					_check = this._SoundDepot.CheckSoundDepot( _InputKey );
					break;
			}
			return _check;
		}
		
		//===============================素材庫取元件========================================
		public function GetMaterialComponent( _InputLoad:LoaderTool , _InputKey:String ):* 
		{
			//傳進LoadTool使用
			this._Loader = _InputLoad;
			//取得URL位置
			this._Url = UrlKeeper.getUrl( _InputKey );
			//利用URL截字串取得檔案類型進行分類
			this._File = this._Url.substr( ( this._Url.length - 3 ) , 3 );
			//存放素材庫回傳元件
			var _ComponentFile:*;
			
			if ( this.CheckLibraryDepot( _InputKey , this._File ) == false && this._Url != "null" ) 
			{
				if ( this._File != "mp3" )
				{
					//---11/06修正-----
					//this._LoadingBar = new LoadingBar();
					
					//加入預設素材元件到倉庫
					this.AddDefaultComponent( _InputKey , this._File , this._LoadingBar );
					
					//trace("進入載入器開始下載!");
					//進入載入器開始下載
					this._Loader.InputLoadData( this._Url );
					
				}else {
					//trace("加入音效Default : " + _InputKey , this._Url );
					this.AddMaterailComponent( _InputKey , this.LoadSound( this._Url ) );
				}
			}
			
			switch( true )
			{
				//Bitmap類型
				case ( this._File == "bmp" || this._File == "jpg" || this._File == "png" ):
					//trace("取素材====>" + this._File );
					_ComponentFile = this._BitmapDepot.GetMaterialComponent( this._Url , _InputKey );
					break;
				
				//MovieClip類型
				case ( this._File == "swf" ):
					_ComponentFile = this._MovieClipDepot.GetMaterialComponent( this._Url , _InputKey );
					break;
				
				//Swf元件庫類型
				case ( this._File == "swp" ):
					_ComponentFile = this._SwfDepot.GetMaterialComponent( this._Url , _InputKey );
					//trace("取得素材資訊: " , _ComponentFile );
					break;
				
				//Sonud類型
				case ( this._File == "mp3" ):
					_ComponentFile = this._SoundDepot.GetMaterialComponent( this._Url , _InputKey );
					//trace("取得Sound元件: " + _ComponentFile );
					break; 
			}
			
			trace("debug0301___>>"+_ComponentFile);
			return _ComponentFile;
		}
			
		//===============================素材館加入新元件====================================
		public function AddMaterailComponent( _InputKey:String , _component:*=null ):void
		{
			//取得URL位置
			this._Url = UrlKeeper.getUrl( _InputKey );
			//利用URL截字串取得檔案類型進行分類
			this._File = this._Url.substr( ( this._Url.length - 3 ) , 3 );
			
			switch( true )
			{
				//Bitmap類型
				case ( this._File == "bmp" || this._File == "jpg" || this._File == "png" ):
					
					this._BitmapDepot.AddNewComponent( this._Url , _InputKey , _component );
					break;
				
				//MovieClip類型
				case ( this._File == "swf" ):
					this._MovieClipDepot.AddNewComponent( this._Url , _InputKey , _component );
					break;
				
				//Swf元件庫類型
				case ( this._File == "swp" ):
					//trace("加入素材庫====>" + _component );
					this._SwfDepot.AddNewComponent( this._Url , _InputKey , _component );
					
					break;
					
				//Sonud類型
				case ( this._File == "mp3" ):
					this._SoundDepot.AddNewComponent( this._Url , _InputKey , _component );
					break;
			}
		}
		
		//===============================素材館移除元件======================================
		public function RemoveMaterailComponent( _InputKey:String ):void
		{
			//取得URL位置
			this._Url = UrlKeeper.getUrl( _InputKey );
			//利用URL截字串取得檔案類型進行分類
			this._File = this._Url.substr( ( this._Url.length - 3 ) , 3 );
			
			switch( true )
			{
				//Bitmap類型
				case ( this._File == "bmp" || this._File == "jpg" || this._File == "png" ):
					
					this._BitmapDepot.RemoveBitmapComponent( _InputKey );
					break;
				
				//MovieClip類型
				case ( this._File == "swf" ):
					this._MovieClipDepot.RemoveMovieClipComponent( _InputKey );
					break;
				
				//Swf元件庫類型
				case ( this._File == "swp" ):
					//trace("加入素材庫====>" + _component );
					this._SwfDepot.RemoveSwpComponent( _InputKey );
					break;
			}
		}
		
		
		//===============================音效載入區==========================================
		private function LoadSound( _SoundURL:String ):Sound {
			//此函式用來新增聲音物件並載入 
			var LoadedSound:Sound=new Sound();//創建新聲音物件
				LoadedSound.load( new URLRequest( this._Domain + _SoundURL ) );//載入輸入的URL位址
				
			return LoadedSound;//將聲音物件回傳   (呼叫的上層會將其塞入關聯陣列)
		}
		
		public function get SerialBitmap():SerialBitmapDepot {
			return _SerialBitmapDepot;
		}
		
		
		
		
		
		
	}//end class
}//end package