package Spark.coreFrameWork.View
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.Interface.IfView;
	import Spark.coreFrameWork.observer.Notify;
	//import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author EricHuang
	 * 託管UI 操控傳遞命令-----
	 * 該物件須透過繼承才能夠使用
	 * 所有的VIEW都必須繼承ViewCtrl
	 * VIEW的製作人員需繼承此class才可以使用!!!!!
	 */
	public class  ViewCtrl extends Notify implements IfNotify,IfView
	{
		
		private var _viewName:String = "";
		//-----承接顯示物件容器進來
		protected var _viewConterBox:DisplayObjectContainer;
		protected var _viewConterName:String="";
		//---是否在轉換系統的時候要掠過不刪除--
		private var _bolLuck:Boolean;
		public function ViewCtrl(_viewName:String,_conter:DisplayObjectContainer=null,_lock:Boolean=false) 
		{
			this._bolLuck = _lock;
			this.SetViewConter(_conter);
			this.SetViewName(_viewName);
			
		}
		
		                   
		public function SetViewConter(_conter:DisplayObjectContainer):void 
		{
			if (_conter != null) {
			  this._viewConterBox = _conter;	
			  this._viewConterName =_conter.name;
			}
		}
		
		public function GetLock():Boolean 
		{
		  return this._bolLuck;	
		}
		
		//---override this----(//----關閉顯示(關閉viewctrl裡面的容器顯示& mouseChildren=false))
		public function DisplayClose():void 
		{
			
		}
		
		//--取得圖層名稱---
		public function GetViewConterName():String 
		{
			return this._viewConterName;
		}
		
		
		public function GetViewConter():DisplayObjectContainer 
		{
			return this._viewConterBox ;
		}
		
		public function SetViewName(_str:String):void 
		{
			this._viewName = _str;
		}
		
		public function GetViewName():String 
		{
			return this._viewName;
		}
		
		
		public function onRemoved():void { };
		
		public function onRegisted():void { };
		
	}
	
}