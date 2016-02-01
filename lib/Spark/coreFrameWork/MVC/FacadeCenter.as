package Spark.coreFrameWork.MVC
{
	import flash.utils.Dictionary;
	import Spark.coreFrameWork.Interface.IfCatchCommands;
	import Spark.coreFrameWork.Interface.IfFacade;
	import Spark.coreFrameWork.Interface.IFMeditorGUI;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.Interface.IfView;
	import Spark.coreFrameWork.observer.NotifyInfo;
	//import Spark.GUI.BasicGUI.BasicPanel;
	import Spark.GUI.BasicPanel;
	
	/**
	 * ...
	 * @Engine SparkEngine V1.06
	 * @author EricHuang
	 * @version 2012.11.20
	 * @player 11.4
	 * 
	 * this class only [extens] use it!
	 * 
	 */
	public class FacadeCenter implements IfFacade
	{
		
		
		protected static var _facadeCenter:IfFacade;
		
		protected var _viewCenter:View;
		
		protected var _ctrlCenter:Controller;
		
		protected var _modelCenter:Model;
		
		
		
		public function FacadeCenter() 
		{
			if (FacadeCenter._facadeCenter != null) throw Error("[FacadeCenter] build illegal!!!please,use [Singleton]");
			FacadeCenter._facadeCenter = this;
			initFacadeHandler();
			trace("initFrameWork[FacadeCenter]");
		}
		
		
		public static function GetFacadeCenter():IfFacade 
		{
			if (FacadeCenter._facadeCenter == null) FacadeCenter._facadeCenter = new FacadeCenter();
			return FacadeCenter._facadeCenter;
		}
		
		
		//----init[views,model,controller]--------
		protected function initFacadeHandler():void 
		{
			this.initViewsCenter();
			this.initGetModleCenter();
			this.initGetCtrlCenter();
		}
		
		protected function initViewsCenter():void { if (this._viewCenter == null) this._viewCenter = View.GetView(); }
		
		protected function initGetModleCenter():void {if (this._modelCenter == null) this._modelCenter = Model.GetModle();}
		
		protected function initGetCtrlCenter():void{if (this._ctrlCenter == null) this._ctrlCenter =Controller.GetController();}
		
		
		
		public function RegisterCommand(_ObserverName:String,_commandClass:Class):void 
		{
			this._ctrlCenter.RegisterCommand(_ObserverName,_commandClass);
		}
		
		//---11/25----
		public function RemoveCommand(_index:String,_class:Object):void 
		{
		    this._ctrlCenter.RemoveCommand(_index,_class);	
		}
		
		
		
		public function GetHasCommand(_index:String):Boolean 
		{
		   return this._ctrlCenter.CheckCommandIng(_index);	
		}
		
		public function RegisterProxy(_proxy:IfProxy):void 
		{
			this._modelCenter.RegisterProxy(_proxy);
		}
	
		
		
		public function RemoveProxy(_index:String):void 
		{
			this._modelCenter.RemoveProxy(_index);
		}
		
		
		public function GetProxy(_index:String):IfProxy 
		{
			return this._modelCenter.GetProxy(_index);
		}
		
		
		public function checkProxyHandler(_index:String):Boolean 
		{
			return this._modelCenter.checkProxyHandler(_index);
		}
		
		/*
		public function GetCatchCommands(_index:String,_class:Class):IfCatchCommands 
		{
			return this._ctrlCenter.GetCatchCommands(_index,_class);
		}*/
		
		//---原生的方法-------
		//---派送訂閱的事件(啟動)
		public function SendNotify(notifyName:String, body:Object=null ):void 
		{
			//----把丟出去的派送包裝成[NotifyInfo]-----
			this.SendNotifyObserver(new NotifyInfo(notifyName,body));
		}
		
		
		//----11/23測試抓取observer--
		public function GetObserver():Dictionary 
		{
			return this._viewCenter.GETTestObserverList();
			
		}
		
		//---11/25---remove ALL catchCommands---
		public function RemoveALLCatchCommands(_class:Object):void 
		{
			this._ctrlCenter.RemoveCatchCommands(_class);
		}
		
		//----11/25----get the same catchCommands----
		public function GetCatchCommand(_class:Object):IfCatchCommands 
		{
			return this._ctrlCenter.GetCatchCommand(_class);
		}
		
		
		//----11/25----remove single CatchCommands-----
		public function RemoveSingleCatch(_index:String,_class:Object):void 
		{
			this._ctrlCenter.RemoveSingleCatch(_index,_class);
		}
		
		
		
		public function SendNotifyObserver(_inforName:IfNotifyInfo):void 
		{
			this._viewCenter.SendObservers(_inforName);
		}
		
		
		public function RegisterViewCtrl(_target:IfView):void 
		{
			this._viewCenter.RegisterViewCtrl(_target);
		}
		
		public function GetRegisterViewCtrl(_index:String):IfView 
		{
			return this._viewCenter.GetRegisterViewCtrl(_index);
		}
		
		public function RemoveRegisterViewCtrl(_index:String):void 
		{
			this._viewCenter.RemoveRegisterViewCtrl(_index);
		}
		
		/*
		public function CheckCompleteJump(_name:String):String 
		{
		    return this._viewCenter.CheckCompleteJump(_name);	
		}
		*/
		//---託管Meditor控制class(只能被註冊一次)---
		/*
		public function RegisterMeditorGUI(_obj:IFMeditorGUI):void {
			
			//this._viewCenter.RegisterMeditorGUI(_obj);
		}
		*/
		
		/*
		public function RegisterGui(_name:String,_class:BasicPanel):void 
		{
			//this._viewCenter.RegisterGui(_name,_class);
		}
		
		
		public function RemoveGui(_name:String):void 
		{
			//this._viewCenter.RemoveGui(_name);
		}
	     
		public function GetRegisterGui(_name:String):BasicPanel 
		{
			return this._viewCenter.GetRegisterGui(_name);
		}
		*/
		
		/*
		public function GetAllRegisterGui():void 
		{
			
		}
		*/
		
	}
	
}