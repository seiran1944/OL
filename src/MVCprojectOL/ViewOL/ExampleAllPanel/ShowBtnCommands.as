package  MVCprojectOL.ViewOL.ExampleAllPanel
{
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class ShowBtnCommands extends Commands 
	{
		//----<PS>也可以共用一個commands-----由IfNotifyInfo.getName()---switch/case來作判斷區隔開
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			trace("OH~I am back!!!!");
		}
	}
	
}