package Spark.coreFrameWork.MVC
{
	import Spark.coreFrameWork.Interface.IfProxy;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author EricHuang
	 * mvc pattern--Model----
	 * 控管所有的可以操控的資料命令指令------
	 */
	public class Model  
	{
		
		private static var _model:Model;
		private var _dicProxy:Dictionary;
		
		public function Model() 
		{
			if (Model._model != null) throw Error("[Model] build illegal!!!please,use [Singleton]");
			Model._model = this;
			this._dicProxy = new Dictionary(true);
		}
		
		
		public static function GetModle():Model 
		{
			if (Model._model == null) Model._model = new Model();
			return Model._model;
		}
		
		
		public function RegisterProxy(_proxy:IfProxy):void 
		{
			trace("RegisterProxy>" + _proxy.GetProxyName());
			if ( this._dicProxy[_proxy.GetProxyName()]==null ||  this._dicProxy[_proxy.GetProxyName()]==undefined) {
			  this._dicProxy[_proxy.GetProxyName()] = _proxy;
			  _proxy.onRegisteredProxy();
				
			}else {
				
			 trace("Error use the same proxy Name");	
			}
			
		}
		
		public function RemoveProxy(_index:String):void 
		{
			if (this._dicProxy[_index]!=null && this._dicProxy[_index]!=undefined) {
				
			this._dicProxy[_index].onRemovedProxy();
			this._dicProxy[_index] = null;
			
			delete this._dicProxy[_index];
			}
			
		}
		
		public function GetProxy(_index:String):IfProxy 
		{
			var _returnProxy:IfProxy = (this.checkProxyHandler(_index))?null:this._dicProxy[_index];
			trace("getProxy0301____"+_returnProxy);
			return _returnProxy;
		}
		
		public function checkProxyHandler(_index:String):Boolean 
		{
			var _flag:Boolean = (this._dicProxy[_index]==null || this._dicProxy[_index]==undefined)?true:false;
			return _flag;
		}
		
		
	}
	
}