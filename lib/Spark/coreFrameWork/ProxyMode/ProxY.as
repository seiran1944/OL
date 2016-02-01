package Spark.coreFrameWork.ProxyMode
{
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.observer.Notify;
	
	/**
	 * ...
	 * @author EricHuang
	 * ---proxy必須..也只能做的唯一一件事情--sendNotify	
	 * SendNotify>>用Notify來做---(proxy用來送SendNotify(_notifyName,body))
	 */
	
	public class ProxY extends Notify implements IfProxy,IfNotify 
	{
		
	    //---your proxyName & data--------
		protected var _proxyData:Object;
		protected var _proxyName:String;
		public function ProxY (_str:String,_data:Object=null) 
		{
		   this._proxyName =_str;
		   this._proxyData = _data;
		}
		//--GetData
		public function GetData():Object 
		{
			return  this._proxyData; 
		}
		//--SetData
		public function SetData(_obj:Object):void 
		{
			this._proxyData = _obj;
		}
		//--GetProxyName
		public function GetProxyName():String 
		{
			return  this._proxyName; 
		}
		//---SetProxyName
		public function SetProxyName(_str:String):void 
		{
		   this._proxyName =_str;
		}
		
		//----user can override this function(when "Registered" your proxy,you can do anything)----
		public function onRegisteredProxy():void 
		{
			
		}
		
		//----user can override this function(when "Removed" your proxy,you can do anything)----
		public function onRemovedProxy():void 
		{
			
		}
		
		
		
		
		
	}
	
}