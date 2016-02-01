package MVCprojectOL.ControllOL.DataCenter.Commands {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	
	import Spark.CommandsStrLad;
	
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataProxy;
	import MVCprojectOL.ModelOL.DataCenter.DataCenterEvent;
	
	import strLib.proxyStr.ProxyNameLib;
	
	public class TerminateGetPlayerDataCommand extends Commands {
		
		public function TerminateGetPlayerDataCommand() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void {
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_PlayerDataProxy );//移除PlayerDataProxy
			this._facaed.RemoveCommand( DataCenterEvent.Terminate_PlayerDataProxy , TerminateGetPlayerDataCommand );// 移除終結commands
			this._facaed.SendNotify("on_PlayerDataProxy");
		}
		
	}//end class
}//end package