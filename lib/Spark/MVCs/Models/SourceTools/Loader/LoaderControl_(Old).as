package Spark.MVCs.Models.SourceTools.Loader
{
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import Spark.MVCs.Models.SourceTools.*;
	import Spark.MVCs.Models.SourceTools.Material.MaterialManager;

	
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.08.07
	 * @Explain:LoaderControl 載入器控制中心
	 * @playerVersion:11.0
	 */
	
	
	public class LoaderControl
	{
		private var _LoaderMaterial:LoaderMaterial;
		
		
		//記錄連線位置
		private var _Domain:String = "";
		//存放序列資料
		private var _QueueArr:Array = [];
		//執行序列開關
		private var _Active:Boolean = false;
		//記錄資料總數
		private var _Tatal:uint = 0;
		//記錄資料處理完剩下的數量
		private var _nowValue:uint = 0;
		
		
		public function LoaderControl( _MaterialClass:MaterialManager , _InputDomain:String )
		{
			this._LoaderMaterial = ( this._LoaderMaterial != null ) ? this._LoaderMaterial : new LoaderMaterial( _MaterialClass , _InputDomain );
			//初始時就啟動序列器
			this.QueueProcessing( this._QueueArr );
		}
		
		//====================================中斷載入處理======================================
		internal function LoadInterrupt():void 
		{
			//中斷載入處理的Loader
			this._LoaderMaterial.LoadInterrupt();
			//打開堆疊啟動鎖
			this._Active = false;
			//清空堆疊處理的陣列清單
			this._QueueArr = [];
		}
		
		
		//====================================載入資料處理======================================
		internal function LoadDataHandler( _InputURL:* ):void 
		{
			var _params:Array = String( getQualifiedClassName( _InputURL ) ).split( "::" , 2 );
			var _type:String = ( _params.length > 1 ) ? _params[1] : _params[0];			
			
			switch( _type )
			{
				case"String":
					this._QueueArr.push( _InputURL );
					break;
					
				case"Array":	
					this._QueueArr = this._QueueArr.concat( _InputURL );		
					break;					
			}
			//記錄需要處理資料的總數
			this._Tatal = this._QueueArr.length;
			//trace("處理序列: " + _QueueArr.length );
			this._Active == false ? this.QueueProcessing( this._QueueArr ) : null ;
		}
		
		//====================================資料序列處理======================================
		private function QueueProcessing( _InputQueue:Array ):void 
		{			
			if ( _InputQueue.length > 0 ) 
			{
				this._Active = true;
				//trace("取出對象:" + _InputQueue[0] );
				//開始載入素材
				this._LoaderMaterial.Load( _InputQueue[0] );
				//移除序列第一個位置
				_InputQueue.shift();
				//記錄目前剩餘資料數量
				this._nowValue = _InputQueue.length;
				//trace( "移除後剩下的人:" + this._nowValue );
				this._LoaderMaterial.addEventListener( "DataComplete" , this.DataCompleteHandler );
				
			}else {
				//停止queue執行
				this._Active = false;
				//將資料總數歸零
				this._Tatal = 0;
				return;
			}
		}
		//--------------------接收資料載入完成處理--------------------------
		private function DataCompleteHandler( Evt:Event ):void 
		{
			this.QueueProcessing( this._QueueArr );
		}
		
		internal function DataProgressHandler():uint 
		{
			var _progressNum:uint = 0;
				_progressNum = 100 - Math.floor( this._nowValue / this._Tatal  * 100 );
			return _progressNum;
		}
		
	}//end class
}//end package
