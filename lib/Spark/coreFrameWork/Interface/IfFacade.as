package Spark.coreFrameWork.Interface
{
	//import Spark.GUI.BasicGUI.BasicPanel;
	import flash.utils.Dictionary;
	import Spark.GUI.BasicPanel;
	
	/**
	 * ...
	 * @author EricHuang
	 * 2012/08/13新增guiMeditor
	 */
	public interface IfFacade extends IfNotify
	{
		//----commands
		function RegisterCommand(_ObserverName:String,_commandClass:Class):void
		//----11/25----
		function RemoveCommand(_index:String, _class:Object):void
		function GetHasCommand(_index:String):Boolean
		//---11/25----
		function GetCatchCommand(_class:Object):IfCatchCommands
		//---11/25-----
		function RemoveALLCatchCommands(_class:Object):void
		//--11/25-----
		function RemoveSingleCatch(_index:String,_class:Object):void
		
		
		//----proxy----
		function RegisterProxy(_proxy:IfProxy):void
		function RemoveProxy(_index:String):void
		function GetProxy(_index:String):IfProxy
		function checkProxyHandler(_index:String):Boolean
		//---observer----
		function SendNotifyObserver(_inforName:IfNotifyInfo):void;
		//----views---
		function RegisterViewCtrl(_target:IfView):void;
		function GetRegisterViewCtrl(_index:String):IfView;
		function RemoveRegisterViewCtrl(_index:String):void;
		//---guiMeditor----
		//function RegisterGui(_name:String,_class:BasicPanel):void;
		//function RemoveGui(_name:String):void;
		//function GetRegisterGui(_name:String):BasicPanel;
		//----check11/23---
		function GetObserver():Dictionary;
		//---0613----
		//function CheckCompleteJump(_name:String):String;
		
	}
	
}