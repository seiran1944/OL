package Spark.MVCs.Models.SourceTools.Loader
{
	
	
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	//import Spark.ErrorsInfo.ErrorMessage.MessageTool;
	import Spark.MVCs.Models.SourceTools.*;
	import Spark.MVCs.Models.SourceTools.Material.MaterialManager;
	import Spark.MVCs.Models.SourceTools.SourceEvt.*;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.KeyCodeInfo.UrlKeeper;

	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.11.20	
	 * @Explain:LoaderClass 載入素材器
	 * @playerVersion:11.0
	 * 
	 * 
	 * @Modifier : K.J. Aris
	 * @version : 2012.11.28
	 */
	
	
	public class LoaderMaterial extends EventDispatcher
	{
		//素材管理者
		private var _MaterialManager:MaterialManager;
		//記錄連線位置
		private var _Domain:String = "";
		//圖像載入方法
		private var _Loader:Loader;
		//記錄元件key碼
		//private var _KeyValue:String = "";
		//記錄檔案類型
		//private var _File:String = "";
		
		
		
		public function LoaderMaterial( _MaterialClass:MaterialManager , _InputDomain:String ):void 
		{
			//素材管理器指標
			this._MaterialManager = _MaterialClass;
			//記錄連線位置
			this._Domain = _InputDomain;
			
			//this._urlLoader.addEventListener ( Event.COMPLETE, this.BinaryLoadComplete );//121120 K.J. Aris
		}
		
		//-----------------------------------------------BinaryLoader	121120
		/*public function BinaryLoad(url:String):void {
			var urlLoader:URLLoader = new URLLoader ();
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.addEventListener ( Event.COMPLETE, this.BinaryLoadComplete );
				urlLoader.load (new URLRequest (url));
		}
		
		private function BinaryLoadComplete( EVT:Event ):void {	
			EVT.currentTarget.removeEventListener ( Event.COMPLETE , this.BinaryLoad );
			var byteArray:ByteArray = new ByteArray();
				byteArray = EVT.currentTarget.data;
			this._Loader = new Loader();
			this._Loader.contentLoaderInfo.addEventListener( Event.COMPLETE, getFont );
			this._Loader.loadBytes(byteArray);
		}*/
		
		//private var _urlLoader:URLLoader = new URLLoader ();
		
		internal function Load( _InputURL:String ):void{	//121120 K.J. Aris
			//取得目前元件KeyValue
			var _KeyValue:String = UrlKeeper.getKeyByUrl( _InputURL );
			//先到素材庫去註冊(不用給實際物件沒關係)
			this._MaterialManager.AddMaterailComponent( _KeyValue );
			
			var _URL:String = this._Domain + _InputURL + "?" + ( Math.random() );	//修改日期:2012.11.22 新增"?"
			//this._Loader = new Loader();				//修改日期:20121113 , 多加了new Loader。
			
			//this.AddListener( this._Loader.contentLoaderInfo );
			var _File:String = _InputURL.substr( ( _InputURL.length - 3 ) , 3 );
			
			var _urlLoader:URLLoader = new URLLoader ();
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_urlLoader.addEventListener ( Event.COMPLETE , onBinaryLoaderComplete );
						function onBinaryLoaderComplete( EVT:Event ):void {
							RemoveBinaryLoaderListeners( EVT );
							BinaryLoadComplete( EVT , _File , _KeyValue );
						}
				_urlLoader.addEventListener( IOErrorEvent.IO_ERROR , onBinaryLoaderIoError );
						function onBinaryLoaderIoError( EVT:Event ):void {
							trace( _KeyValue + "Invaild" , "=============================From" , this );
							EventExpress.DispatchGlobalEvent( _KeyValue + "Invaild" , "InvaildKey" , _KeyValue , "LoaderMaterial" , false );
							RemoveBinaryLoaderListeners( EVT );
						}
						function RemoveBinaryLoaderListeners( EVT:Event ):void {
							EVT.currentTarget.removeEventListener ( Event.COMPLETE , onBinaryLoaderComplete );
							EVT.currentTarget.removeEventListener ( IOErrorEvent.IO_ERROR , onBinaryLoaderIoError );
						}
				_urlLoader.load ( new URLRequest ( _URL ) );
			
			
			
			//this._Loader.load( new URLRequest( _URL ) );
			
			//利用URL截字串取得檔案類型進行分類
			//this._File = _InputURL.substr( ( _InputURL.length - 3 ) , 3 );
		}
		
		private function BinaryLoadComplete( EVT:Event , _InputFileType:String , _InputFileKey:String ):void {	
			//EVT.currentTarget.removeEventListener ( Event.COMPLETE , this.BinaryLoad );
			trace( "QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQq" , _InputFileKey );
			var byteArray:ByteArray = new ByteArray();
				byteArray = EVT.currentTarget.data;
			var _currentLoader:Loader = new Loader();
				_currentLoader.contentLoaderInfo.addEventListener( Event.COMPLETE , onLoaderComplete );
						function onLoaderComplete( EVT:Event ):void {
							//EVT.currentTarget.removeEventListener ( Event.COMPLETE , onLoaderComplete );
							RemoveLoaderListeners( EVT );
							LoaderCompleteHandler( EVT , _currentLoader , _InputFileType , _InputFileKey );
						}
						
				_currentLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR , onLoaderIoError );
						function onLoaderIoError( EVT:Event ):void {
							trace( _InputFileKey + "  Invaild" , "=============================From" , EVT );
							EventExpress.DispatchGlobalEvent( _InputFileKey + "Invaild" , "InvaildKey" , _InputFileKey , "LoaderMaterial" , false );
							RemoveLoaderListeners( EVT );
						}
						function RemoveLoaderListeners( EVT:Event ):void {
							EVT.currentTarget.removeEventListener ( Event.COMPLETE , onLoaderComplete );
							EVT.currentTarget.removeEventListener ( IOErrorEvent.IO_ERROR , onLoaderIoError );
						}
				
				
				
				_currentLoader.loadBytes(byteArray);
		}
		
		
		//----------------------------------END----------BinaryLoader	121120
		
		
		//====================================啟動載入素材器=============================================
		/*internal function Load( _InputURL:String ):void
		{	
			//取得目前元件KeyValue
			this._KeyValue = UrlKeeper.getKeyByUrl( _InputURL );
			//先到素材庫去註冊(不用給實際物件沒關係)
			this._MaterialManager.AddMaterailComponent( this._KeyValue );
			
			var _URL:String = this._Domain + _InputURL;	
			
			this._Loader = new Loader();				//修改日期:20121113 , 多加了new Loader。
			
			this.AddListener( this._Loader.contentLoaderInfo );
			
			this._Loader.load( new URLRequest( _URL ) );
			
			//利用URL截字串取得檔案類型進行分類
			this._File = _InputURL.substr( ( _InputURL.length - 3 ) , 3 );
		}*/
		
		//---------------中斷下載區-----------------------------
		internal function LoadInterrupt():void 
		{
			try {
				//trace("執行載入關閉!");
				this._Loader.close();
				//EventExpress.DispatchGlobalEvent( SourceEvent.LoadToolEvt , SourceStatus.MaterialInterrupt , this._KeyValue , "LoaderMaterial_MaterialComplete" );
				
			}catch ( _Error:Error ) {
				trace( "素材中斷錯誤: " , _Error );
				
			}
		}
		
		
		
		
		//---------------加入監聽器-----------------------------
		/*private function AddListener( _InputTarget:* ):void 
		{
			//_InputTarget.addEventListener( Event.COMPLETE , LoaderCompleteHandler );			
			_InputTarget.addEventListener(IOErrorEvent.IO_ERROR, LoaderErrorHandler);
		}*/
		
		
		//---------------移除監聽器-----------------------------
		/*private function RemoveListener( _InputTarget:* ):void 
		{
			//_InputTarget.removeEventListener( Event.COMPLETE , LoaderCompleteHandler );
			_InputTarget.removeEventListener(IOErrorEvent.IO_ERROR, LoaderErrorHandler);
		}*/
		
		//---------------載入完成處理---------------------------
		private function LoaderCompleteHandler( Evt:Event , _InputLoader:Loader , _InputFileType:String , _InputFileKey:String  ):void{
			//Evt.currentTarget.removeEventListener( Event.COMPLETE , LoaderCompleteHandler );
			//Evt.currentTarget.removeEventListener( IOErrorEvent.IO_ERROR , LoaderErrorHandler );

			//trace("下載完成!" + this._Loader.content );
			this.SelectDataCtrl( _InputLoader , _InputFileType , _InputFileKey );
		} 
		
		//---------------載入錯誤處理---------------------------
		/*private function LoaderErrorHandler( Evt:IOErrorEvent ):void 
		{
			//Evt.currentTarget.removeEventListener( Event.COMPLETE , LoaderCompleteHandler );
			Evt.currentTarget.removeEventListener( IOErrorEvent.IO_ERROR , LoaderErrorHandler );
			//this.RemoveListener( Evt.currentTarget );
			//MessageTool.InputMessageKey( 404 );
		}*/
		
		//====================================素材載入後分類儲存===========================================
		private function SelectDataCtrl( _InputTarget:Loader , _InputFileType:String , _InputFileKey:String ):void 
		{			
			//篩選素材類型
			var _params:Array = String( getQualifiedClassName( _InputTarget.content ) ).split( "::" , 2 );
			var _type:String = _params[1];
			//存放元件
			var _component:*;			
			
			switch(_type)
			{
				//加工過變成BitmapData實體化
				case "Bitmap":
					var _bmp:Bitmap = Bitmap( _InputTarget.content );
					var picd:BitmapData = new BitmapData( _bmp.width , _bmp.height , true , 0x000000 );
					picd.draw(_bmp);
					_component = picd;
					break;
				
				//swf元件例外處理分為有swf單一動態元件、swp動態元件庫
				case "MovieClip":
					if ( _InputFileType == "swf" )
					{
						_component = MovieClip( _InputTarget.content );
						//trace("載好的SWF: " , _component );
					}else {
						_component = _InputTarget;
						//trace("載好的SWP: " , _component );
					}
					break;
			}
			
			//trace("載入完成加入素材庫: " + this._KeyValue );
			
			//加入到素材庫做管理
			this._MaterialManager.AddMaterailComponent( _InputFileKey , _component );
			
			//完成素材庫存取發事件
			EventExpress.DispatchGlobalEvent( SourceEvent.LoadToolEvt , SourceStatus.MaterialComplete , _InputFileKey , "LoaderMaterial_MaterialComplete" );//to SourceProxy
			
			this.dispatchEvent( new Event("DataComplete") );
		}
		
		
		
		
		
	}//end class
}//end package