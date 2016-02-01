package Spark.coreFrameWork.observer
{
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfObserver;
	//import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author EricHuang
	 * observer patterns [core observer]
	 * use this class can [subscribe]
	 * [observer patterns] replace flash`s [Event model]
	 * 
	 */
	public class  Observer implements IfObserver
	{
		
		//---訂閱者需要變更的function----
		private var _function:Function;
		
		//----訂閱者的來源[class/object]----
		private var _observerObject:Object;
		
		private var _observerName:String = "";
		private var _classNmae:String = "";
		
		public function Observer (notifyBody:Object,notifyFun:Function,_obname:String,_classname:String) {
			
			this.SetNotifyBodyHandler(notifyBody);
			this.SetNotifyFunctionHandler(notifyFun);
			this._observerName = _obname;
			this._classNmae = _classname;
			
		}
		
		
		public function GetCheckName():Object 
		{
			var _obj:Object = {_observerName:this._observerName,_classNmae:this._classNmae};
			return _obj;
		}
		
		
		public function SetNotifyBodyHandler(_obj:Object):void 
		{
			this._observerObject = _obj;
		}
		
		
		public function SetNotifyFunctionHandler(_obj:Function):void 
		{
			this._function = _obj;
		}
		
		
		public function GetConterClass():Object 
		{
			return this._observerObject;
		}
		
		
		//---SendNotify---------
		public function SendNotifyObserver(observerName:IfNotifyInfo):void 
		{
			this._function.apply(null,[observerName]);	
		}
		
		//----檢查註冊的本體是否為同一個
		//---修改11/24----
		
		public function CehckObserver(_key:String):Boolean 
		{
			var _flag:Boolean = (_key==this._classNmae)?true:false;
			
			return _flag;
			//return _target === this._observerObject;
		}
		
		
		/*
		public function CehckObserver(_target:Object):Boolean 
		{
			
			
			
			return _target === this._observerObject;
		}
		*/
		
		
	}
	
}