package Spark.coreFrameWork.MVC
{
	import flash.display.DisplayObject;
	import Spark.coreFrameWork.Interface.IFMeditorGUI;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author EricHuang
	 * ----抽像類別----
	 * PS主程式工程師專用class繼承才能使用-------
	 */
	public class MeditorGuiCenter implements IFMeditorGUI
	{
		
		
		//private static var _MeditorGui:IFMeditorGUI;
		
		protected var _stage:DisplayObject;
		//----要在塞入變型的工具------
		public function MeditorGuiCenter() 
		{
			
		}
		
		public function AddStage(_obj:DisplayObject):void 
		{
			this._stage = _obj;
		}
		
		/*
		public static function GetMeditorGui():IFMeditorGUI 
		{
			if (MeditorGuiCenter._MeditorGui == null) MeditorGuiCenter._MeditorGui = new MeditorGuiCenter();
			return MeditorGuiCenter._MeditorGui;
		}
		*/
		
		public function ExcuteGUI(_Nmae:String,Gui:Object):void 
		{
			
		}
		
		
		
		
	}
	
}