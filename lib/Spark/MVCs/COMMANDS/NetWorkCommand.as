package Spark.MVCs.COMMANDS
{
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	//import Spark.MVCs.Models.NetWork.AmfConnection.AmfConnector;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	
	public class NetWorkCommand extends Commands {
		
		public function NetWorkCommand() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			this._facaed.RegisterProxy( AmfConnector.GetInstance());
		}
		
	}

}