package Spark.coreFrameWork.Interface
{
	
	/**
	 * ...
	 * @author EricHuang
	 * 調度畫面上所有的GUI----
	 */
	public interface  IFMeditorGUI
	{
		
		//function RegisterGui(_name:String, _class:Class):void 
		//function RemoveGui(_name:String):void 
		//function GetRegisterGui(_index:String):Class 
		function ExcuteGUI(_Nmae:String,Gui:Object):void 
		
	}
	
}