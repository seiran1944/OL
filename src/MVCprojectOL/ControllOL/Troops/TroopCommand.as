package MVCprojectOL.ControllOL.Troops
{
	import MVCprojectOL.ModelOL.Troop.TroopProxy;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.08.11.56
		@documentation 註冊troop proxy
	 */
	public class TroopCommand extends Commands 
	{
		
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			this._facaed.RegisterProxy(TroopProxy.GetInstance());
			
		}
		
		
	}
	
}