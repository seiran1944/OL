package Spark.MVCs.Models.SourceTools.Loader
{
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.ContentDisplay;
	import SourceTools.*;
	import GlobalEvent.EventExpress;
	
	
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.08.06
	 * @Explain:LoaderPlugin 載入器外掛(使用loaderMax)
	 * @playerVersion:11.0
	 */
	
	
	public class LoaderPlugin
	{
		
		private var _queue:LoaderMax = new LoaderMax( { name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler } );
		
		
		
		public function LoaderPlugin( _InputDomain:String )
		{
			
		}
		
		internal function StartLoaderMax( _InputArr:Array , _w:int , _h:int ):void 
		{
			var _URL:String = "";
			
			for ( var i:* in _InputArr )
			{	
				_URL = this._Domain + _InputArr[i];
				//this._urlArr.push( _URL );
				//trace(_URL);
				
				switch( true )
				{
					case _URL.indexOf(".swf")!= -1 :
						this._queue.append( new SWFLoader(_URL, {name:"Dynamic"+i , estimatedBytes:3000, container:this , autoPlay:false}) );
						break;
						
					case _URL.indexOf(".bmp")!= -1 || _URL.indexOf(".jpg")!= -1 || _URL.indexOf(".png")!= -1:
						this._queue.append( new ImageLoader( _URL, { name:"Static"+i , estimatedBytes:3000, container:this , width:_w , height:_h } ) );
						break;
						
					case _URL.indexOf(".mp3")!= -1 :
						//this._queue.append( new ImageLoader(_URL, {name:"sound"+K}) );
						break;
				}
			}
			
			this._LoadNum = this._queue.numChildren;
			
			//trace( "物件總數量 : "+ this._LoadNum);
			
			this._queue.load(); 
		}
		//---------------載入過程處理---------------------------
		private function progressHandler( Evt:LoaderEvent ):void 
		{
			//trace("處理程序!");
		}
		//---------------載入完成處理---------------------------
		private function completeHandler( Evt:LoaderEvent ):void 
		{
			
			var _CacheImg:Vector.<Sprite> = new Vector.<Sprite>;
			
			for ( var i:int = 0; i < this._LoadNum; i++ )
			{
				var _StaticImg:ContentDisplay = LoaderMax.getContent( "Static" + i );
					
				var _DynamicSwf:ContentDisplay = LoaderMax.getContent( "Dynamic" + i );
				
				if ( _StaticImg != null )
				{
					//trace("靜態圖下載完成!" + this._urlArr[i] );
					//SourceTool.AddComponentLibrary( this._urlArr[i] , _StaticImg );
					//_CacheImg.push( Sprite( _StaticImg ) );
				}	
				
				if ( _DynamicSwf != null )
				{
					//_CacheImg.push( Sprite( _DynamicSwf ) );
				}
				
			}
			
			
			
			//EventExpress.DispatchGlobalEvent( SourceEvent.LoadToolEvt , SourceStatus.StaticImg , _CacheImg , "LoaderMaterial" );
		}
		//---------------載入錯誤處理---------------------------
		private function errorHandler( Evt:LoaderEvent ):void 
		{
			trace("載入回傳錯誤!");
		}
		
		
	}//end class
}//end package
