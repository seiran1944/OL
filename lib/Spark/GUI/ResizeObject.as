package Spark.GUI
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 ...
	 * @Engine SparkEngine beta 1
	 * @author EricHuag
	 * @version 2012.08.13
	 * @param 本class用於Resize全體控制使用-----
	 * 
	 */
	public class ResizeObject
	{
		
		protected var _stage:Stage;
		protected var _stageWidth:Number=0;
		protected var _stageHeight:Number=0;
		
		//---------變型的倍率--------
		protected var _scaleX:Number = 1;
		protected var _scaleY:Number = 1;
	    
		//---預設stage的尺寸------
		protected var _indStageWidth:Number;
		protected var _indStageHeigth:Number;
		
		//protected  var _vectorDisplayObj:Vector.<DisplayObject>= new Vector.<DisplayObject>();
		protected  var _dicDisplayObj:Dictionary;
		
		public function ResizeObject(_stage:Stage,_width:Number,_height:Number) 
		{
		  this._stage = _stage;
		  this._stageWidth =this._stage.stageWidth;
		  this._stageHeight = this._stage.stageHeight;
		  this._indStageWidth = _width;
		  this._indStageHeigth = _height;
		  this._stage.addEventListener(Event.RESIZE,onResizeHandler);
		  	
		}
		
	    
		//----Resize tools---
		public function onResizeHandler(e:Event=null):void 
		{
			if (this._dicDisplayObj == null) this.GetDicGuiHandler();
			this._stageWidt = this._stage.stageWidth;
			this._stageHeight = this._stage.stageHeight;
			this._scaleX = this._stageWidt / this._indStageWidth;
			this._scaleY = this._stageHeight / this._indStageHeigth;
			
			for (var i:DisplayObject in this._dicDisplayObj) {
				i.scaleX = this._scaleX;
				i.scaleY = this._scaleY;
			    this.transFromHandler(i._guiIDName,i);	
			}
			
		}
		
		//-------(跟facade拿GUI的清單)-------
		protected function GetDicGuiHandler():void 
		{
			
			
		}
		
		//-----處理重設GUI-------
		public function SetDisPlayGUI(_dic:Dictionary):void 
		{
			
		}
		
	    
		//-----you can override it(自訂微調狀況 )----------
		protected function transFromHandler(ID:String, i:DisplayObject):void 
		{
			
	
			
		}
		
	

		
	}
	
}