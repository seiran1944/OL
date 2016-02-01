package MVCprojectOL.ControllOL.UrlData {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	
	import Spark.CommandsStrLad;
	
	import MVCprojectOL.ModelOL.UrlData.GetUrlDataProxy;
	import MVCprojectOL.ModelOL.UrlData.UrlDataEvent;
	
	import strLib.proxyStr.ProxyNameLib;
	
	public class TerminateGetUrlDataCommand extends Commands {
		
		public function TerminateGetUrlDataCommand() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_GetUrlDataProxy );
			this._facaed.RemoveCommand( UrlDataEvent.Terminate_GetUrlDataProxy , TerminateGetUrlDataCommand );
			this._facaed.SendNotify("on_GetUrlDataProxy");
		}
		
	}//end class
}//end package