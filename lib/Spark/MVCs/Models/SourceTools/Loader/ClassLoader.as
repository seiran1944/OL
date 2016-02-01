package Spark.MVCs.Models.SourceTools.Loader{

	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;
	
	//import flash.utils.getQualifiedClassName;
	
	import flash.net.LocalConnection;
	import flash.system.System;
	
	
	internal class ClassLoader extends EventDispatcher {
		//本元件用來抓取檔案中  擁有Linkage Name的元件   提供作為 Class  使用
		
		//Package Info for debug
		//private const _PackageInf:String = " * From Package Activities.ClassLoader.as ";
		//private const _ActionMessage:String = "#ver 12.04.27.15.26 : ";//@ K.J. Aris
		
		private var _CurrentURL:String;
		private var _Loader:Loader = new Loader();

		//建構函式
		public function ClassLoader( _InputEntityOrURL:Object = null , _InputLoaderContext:LoaderContext = null ) {
			if ( _InputEntityOrURL != null ) {
				switch( true ) {
					case  (_InputEntityOrURL is ByteArray) :
							this.LoadBytesClass( _InputEntityOrURL as ByteArray , _InputLoaderContext );
						break;
						
				 	case ( _InputEntityOrURL is String ) :
							this.LoadUrlClass( _InputEntityOrURL as String , _InputLoaderContext );
						break;
						
					default:
						throw new Error("參數錯誤，建構函式第一參數只接受ByteArray或String");
					break;
				}//end switch
			}//end if
		}

		//載入URL所指向的元件   並抓取擁有Linkage Name的元件作為 Class
		public function LoadUrlClass( _InputURL:String , _InputLoaderContext:LoaderContext = null ):void {
			this._CurrentURL = _InputURL;
			//this._Loader = new Loader();
			this._Loader.load( new URLRequest( _InputURL ) , _InputLoaderContext );
			this.AddListener( this._Loader.contentLoaderInfo );
		}

		//載入已轉為ByteArray元件   並抓取擁有Linkage Name的元件作為 Class
		public function LoadBytesClass( _InputBytesEntity:ByteArray,_InputLoaderContext:LoaderContext = null ):void {
			this._Loader = new Loader();
			//this._Loader.loadBytes( _InputBytesEntity , _InputLoaderContext );
			this.AddListener( this._Loader.contentLoaderInfo );
		}
		
		//加入監聽器
		private function AddListener( _InputTarget:* ):void {
			_InputTarget.addEventListener( ProgressEvent.PROGRESS , LoadingProgress );
			_InputTarget.addEventListener( Event.COMPLETE , LoadingComplete );
		}

		//移除監聽器
		private function RemoveListener( _InputTarget:* ):void {
			_InputTarget.removeEventListener( ProgressEvent.PROGRESS , LoadingProgress );
			_InputTarget.removeEventListener( Event.COMPLETE , LoadingComplete );
		}

		//完成載入
		private function LoadingComplete( EVT:Event ):void {
			this.RemoveListener( EVT.currentTarget );//移除監聽器
			this.dispatchEvent( EVT );//發送完成事件
			//this.ClearUp();
		}

		//載入
		private function LoadingProgress( EVT:ProgressEvent ):void {
			this.dispatchEvent( EVT );//發送加載事件
		}
		
		
		
		//取得類別
		public function GetClass(className:String):Class {
				return Class( this._Loader.contentLoaderInfo.applicationDomain.getDefinition(className) ) ;
		}

		//檢查是否含有該類別
		public function HasClass(className:String):Boolean {
			return this._Loader.contentLoaderInfo.applicationDomain.hasDefinition(className);
		}

		//清除
		public function ClearUp():void {
			this._Loader.unload();
			this._Loader = null;
			try{
				new LocalConnection().connect("foo");
				new LocalConnection().connect("foo");
			}catch(error : Error){
				System.gc();
			}
			System.gc();//強制執行記憶體回收程序
			
			
		}
		
		//檢查需求清單內的類別   並將 可用類別 編為清單回傳
		public function GetListedClass( _InputClassNameList:Vector.<String> ):Vector.<Class>{
			var _OutputClassList:Vector.<Class> = new Vector.<Class>();
			
			for( var i:int = 0 ; i < _InputClassNameList.length ; i++ ){
				if( this.HasClass( _InputClassNameList[i] ) == true ){
					_OutputClassList.push( this.GetClass( _InputClassNameList[i] ) );
				}
			}
			
			return _OutputClassList;
		}
		
		
		
		
	}//end class
}//end package