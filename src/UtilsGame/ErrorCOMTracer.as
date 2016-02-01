package UtilsGame
{
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	/**
	 * ...
	 * @author EricHuang
	 * 註冊名稱---"ERROR_TRACER_COM"
	 */
	public class ErrorCOMTracer extends Commands 
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			trace(_obj.GetClass());
			if (_obj.GetClass()=="") {
				ErrorViewTracer(this._facaed.GetRegisterViewCtrl("DEBUG_TRACER")).Open();
				
				} else {
				
				ErrorViewTracer(this._facaed.GetRegisterViewCtrl("DEBUG_TRACER")).AddTrace(_obj.GetClass() as String);
			}
			
		}
	}
	
}