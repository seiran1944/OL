package Spark.coreFrameWork.ProxyMode
{
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.observer.Notify;
	
	/**
	 * ...
	 * @author EricHuang
	 * 特殊情況使用的proxy---
	 */
	public class ProxyMarco extends Notify implements IfProxy,IfNotify 
	{
		
		private var _aryProxy:Array;
		protected var _proxyName:String;
		public function ProxyMarco(_str:String) 
		{
			this._proxyName = _str;
		}
		
		//---proxy群放進來,用陣列的方式放進來----
		public function AddProxy(_ary:Array):void 
		{
			this._aryProxy = _ary;
		}
		
		
		
		public function SetAllProxy(_obj:Object):void 
		{
			for (var i:* in this._aryProxy) {
				this._aryProxy[i].SetData();
			}
		}
		
		/*
		public function ():void 
		{
			
		}*/
		
		public function GetProxy(_index:String):Object 
		{
			
			for (var i:* in this._aryProxy) {
				
				if (this._aryProxy[i].GetProxyName()==_index) {
					return this._aryProxy[i].GetData();
					break;
				}
			}
		}
		
		
		
	}
	
}