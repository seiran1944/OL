package Spark.MVCs.Models.SourceTools
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.utils.getQualifiedClassName;
	import Spark.MVCs.Models.SourceTools.Loader.DismantleClass;
	import Spark.MVCs.Models.SourceTools.Loader.LoaderTool;
	import Spark.MVCs.Models.SourceTools.Material.ImageProcessing;
	import Spark.MVCs.Models.SourceTools.Material.MaterialManager;
	import Spark.Utils.KeyCodeInfo.UrlKeeper;
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.10.30
	 * @Explain:SourceTool 資源工具===>對外窗口
	 * @playerVersion:11.0
	 * 
	 * 
	 * 
	 * @Modifier : K.J. Aris
	 * @version : 2013.01.02
	 * 
	 */
	
	 
	 
	
	public class SourceTool
	{
		
		private var _Material:MaterialManager;
		
		private var _ImageProces:ImageProcessing;
		
		private var _Loader:LoaderTool;
		
		private var _DismantleClass:DismantleClass;
		
		public function SourceTool() {
			//建立影像處理器
			this._ImageProces = ( this._ImageProces != null ) ? this._ImageProces : new ImageProcessing();
		}
		
		
		//==============================初始SourceTool工具=======================================
		public function InitSourceTool( _domain:String ):void 
		{
			//建立素材管理器
			this._Material =  ( this._Material != null ) ? this._Material : new MaterialManager( _domain );
			//建立連線下載器=====>( 連線位置 )
			this._Loader = ( this._Loader != null ) ? this._Loader : new LoaderTool( this._Material , _domain );
			//建構處理Swf外掛
			this._DismantleClass = new DismantleClass();
			//trace("SourceTool建構完成" , _domain );
		}
		
		//==============================素材載入系統==============================================
		
		//--------------直接預載素材方法----------------
		public function PreloadMaterial( _InputKey:* ):Boolean 
		{
			//取得URL位置
			var _url:String; 
			//利用URL截字串取得檔案類型進行分類
			var _fileType:String; 
			
			var _Type:String = String( getQualifiedClassName( _InputKey ) );
			//trace( _url = UrlKeeper.getUrl( _InputKey ) , "QQQQQQQQQQQQQQQQQQQQ" );
			
			var _check:Boolean = false;
			
			
			switch( _Type )
			{
				case"String":
					
					_url = UrlKeeper.getUrl( _InputKey );
					
					_fileType = _url.substr( ( _url.length - 3 ) , 3 ); 
					
					_check = this.CheckMaterialDepot( _InputKey );		//修改日期:20121113 ===>接出來一個檢查素材庫
					
					//( this._Material.CheckLibraryDepot( _InputKey , _fileType ) == false ) ? this._Loader.InputLoadData( _url ) : trace("素材已載過!");
					( _check == false ) ? this._Loader.InputLoadData( _url ) : trace("素材已載過!");
					break;
					
				case"Array":
					
					_check = this.LoadListHandler( _InputKey );
					break;
			}
			
			return _check;
		}
		
		private function LoadListHandler( _InputList:Array ):Boolean 		//修改日期:20121113
		{
			var _url:String;
			var _check:Boolean = false;
			
			
			for ( var i:uint = 0; i < _InputList.length; i++ )
			{
				_url = UrlKeeper.getUrl( _InputList[i] );
				
				_check = this.CheckMaterialDepot( _InputList[i] );
				
				( _check == false ) ? this._Loader.InputLoadData( _url ) : trace("素材已載過!");
				
				
			}
			return _check;
		}
		
		//--------------------中斷下載動作---------------------
		public function LoadInterrupt():void 
		{
			this._Loader.LoadInterrupt();
		}
		//--------------------移除素材人員---------------------
		public function RemoveMaterailComponent( _InputKey:String ):void 
		{
			this._Material.RemoveMaterailComponent( _InputKey );
		}
		
		//--------------------取得素材進度---------------------
		public function GetLoadProgress():uint 
		{
			return this._Loader.GetMaterialProgress();
		}
		//--------------------拆解SWP的class-------(回傳一個class)
		public function DismantleSwpClass( _className:String ):Class 
		{
			return this._DismantleClass.GetClass( _className );
		}
		
		//--------------------拆解SWP的class工具---(回傳整張清單)
		public function DismantleSwpList( _InputClassNameList:Vector.<String> ):Object 
		{
			return this._DismantleClass.GetListedClass( _InputClassNameList );
		}
		
		
		//==============================素材管理系統==============================================		
		//--------------檢查素材庫裡是否有元件存在---------------   修改日期:20121113 
		public function CheckMaterialDepot( _InputKeyCode:String ):Boolean 
		{
			//取得URL位置
			var _url:String = UrlKeeper.getUrl( _InputKeyCode ); 
			//利用URL截字串取得檔案類型進行分類
			var _fileType:String = _url.substr( ( _url.length - 3 ) , 3 );  
			
			return this._Material.CheckLibraryDepot( _InputKeyCode , _fileType );
		}
		
		
		//--------------取得靜態圖實體物件-----------------------
		public function GetImageSprite( _keyValue:String ):* 
		{
			var _Component:* = this._Material.GetMaterialComponent( this._Loader , _keyValue );
			
			if ( this.CheckDefaultComponent( _Component ) == false )
			{
				_Component = this.DrawSprite( this._Material.GetMaterialComponent( this._Loader , _keyValue ) );
			}
			
			return _Component;
		}
		//--------------取得靜態圖非實體物件---------------------
		public function GetImageBitmapData( _keyValue:String ):* 
		{
			var _Component:* = this._Material.GetMaterialComponent( this._Loader , _keyValue );
			
			if ( this.CheckDefaultComponent( _Component ) == false )
			{
				_Component = this._Material.GetMaterialComponent( this._Loader , _keyValue );
			}
			
			return _Component;
		}
		
		//--------------取得SWF素材物件--------------------------
		public function GetMaterialSWF( _keyValue:String ):MovieClip 
		{
			return this._Material.GetMaterialComponent( this._Loader , _keyValue );
		}
		
		public function GetMaterialSWP( _keyValue:String , _InputClass:* , _NewComponent:Boolean = false ):* 
		{
			var _Component:* = this._Material.GetMaterialComponent( this._Loader , _keyValue );
			var _classList:Object;
			var _class:Class;
			var _ContentList:Object;
			
			//trace( _InputClass , "===========================================================================================" );
			//因為第一次回傳的是顯示物件LoadingBar，所以需要做這一道鎖
			if ( this.CheckDefaultComponent( _Component ) == false )
			{
				this._DismantleClass.InputLoader( _Component ); //這裡的_Component會是一個loader物件
				
				if ( typeof(_InputClass) != "string" )
				{
					//回傳拆解好的class整包Object
					_classList = this.DismantleSwpList( _InputClass );
					
					if ( _NewComponent == true )
					{
						for ( var i:* in _classList )
						{
							_class = _classList[ i ];
							_classList[ i ] = new _class();
							trace("========================================>" , _classList[ i ] );
						}
					}
					
					_Component = _classList;
					
				}else {
					
					_class = this.DismantleSwpClass( _InputClass );
					
					if ( _NewComponent == true )
					{
						_Component = new _class();
					}else {
						_Component = _class;
					}
					
				}
			}
			
			return _Component;
			
		}
		
		//--------------取得Sound載體-----------------------------
		public function GetMaterialSound( _keyValue:String ):Sound 
		{
			return this._Material.GetMaterialComponent( this._Loader , _keyValue );
		}
		
		//檢查是否為Default素材元件
		private function CheckDefaultComponent( _InputComponent:* ):Boolean 
		{
			//篩選素材類型
			var _params:Array = String( getQualifiedClassName( _InputComponent ) ).split( "::" , 2 )
			var _type:String = _params[1];
			
			return ( _type == "LoadingBar" ) ? true : false;	
			
		}
		
		
		
		
		//==============================影像處理系統==============================================
		//動畫影像拆解處理(回傳Array)裝的是BitmapData
		public function GetMovieClipHandler( _InputMc:MovieClip , _InputHorizontalReverse:Boolean = false , _InputKey:String = null ):Array {
			var _Result:Array;//Vector.<BitmapData>;
			if ( _InputKey == null ) {
				_Result = this._ImageProces.GetMovieClipHandler( _InputMc , _InputHorizontalReverse ) as Array;
				//trace("要拆要拆");
			}else {
				
				_InputKey = _InputKey + _InputHorizontalReverse.toString();
				
				if ( this._Material.SerialBitmap.CheckExist( _InputKey ) == true ) {
					_Result = this._Material.SerialBitmap.GetSerialImage( _InputKey ) as Array;
					//trace( _InputKey , "有了有了" );
				}else {
					_Result = this._ImageProces.GetMovieClipHandler( _InputMc , _InputHorizontalReverse ) as Array;
					this._Material.SerialBitmap.AddSerialImage( _InputKey , _Result ); 
					//trace( _InputKey , "要拆要存" );
				}
				
			}
			return _Result;
		}
		
		
		
		//-----------靜態影像處理---------------
		//圖像截取功能(回傳BitMapData Array)
		public function CutImgaeHandler( _Bmd:BitmapData, _Width:uint, _Height:uint , _InputKey:String = null ):Array {
			//return this._ImageProces.CutImgaeHandler( _Bmd , _Width , _Height );
			
			
			//--------------------------------------------------Aris 20130102
			var _Result:Array;//Vector.<BitmapData>;
			if ( _InputKey == null ) {
				_Result = this._ImageProces.CutImgaeHandler( _Bmd , _Width , _Height ) as Array;
				//trace("要拆要拆");
			}else {
				if ( this._Material.SerialBitmap.CheckExist( _InputKey ) == true ) {
					_Result = this._ImageProces.CutImgaeHandler( _Bmd , _Width , _Height ) as Array;
					//trace( _InputKey , "有了有了" );
				}else {
					_Result = this._ImageProces.CutImgaeHandler( _Bmd , _Width , _Height ) as Array;
					this._Material.SerialBitmap.AddSerialImage( _InputKey , _Result ); 
					//trace( _InputKey , "要拆要存" );
				}
				
			}
			return _Result;
			//--------------------------------------------------Aris 20130102
		}
		
		
		//---2013/05/27---
		public function GetSerialImage(_InputKey:String):Array 
		{
			return this._Material.SerialBitmap.GetSerialImage( _InputKey ) as Array;
		}
		
		//取得截取的影像群組
		/*public function GetCutImageGroup( _Count:uint , _length:uint ):Array 
		{
			return this._ImageProces.GetCutImageGroup( _Count , _length );
		}*/
		
		
		//翻轉功能(回傳裝的是BitmapData)
		public function RotationImg( _InputBmp:Bitmap , _InBoolean:Boolean ):BitmapData 
		{
			return this._ImageProces.RotationImg( _InputBmp , _InBoolean );
		}
		
		//縮放功能(回傳裝的是BitmapData)
		public function ScaleImg( _target:DisplayObject , _tarW:int , _tarH:int ):BitmapData 
		{
			return this._ImageProces.ScaleImg( _target , _tarW , _tarH );
		}
		
		//畫圖功能(回傳Sprite)
		public function DrawSprite( _InputBmd:BitmapData ):Sprite 
		{
			return this._ImageProces.DrawSprite( _InputBmd );
		}
		
		
		
		
	}//end class
}//end package