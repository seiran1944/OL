package MVCprojectOL.ControllOL.UrlData {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	//import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.commands.SingleCompleteCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	
	import Spark.CommandsStrLad;
	
	import MVCprojectOL.ModelOL.UrlData.GetUrlDataProxy;
	import MVCprojectOL.ModelOL.UrlData.UrlDataEvent;
	
	import MVCprojectOL.ControllOL.UrlData.TerminateGetUrlDataCommand;
	
	public class GetUrlDataCommand extends SingleCompleteCommands {
		
		public function GetUrlDataCommand() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			//trace("getObject>"+_obj.GetClass());
			if (_obj.GetClass()==null ) {
			this._facaed.RemoveCommand( "on_GetUrlDataProxy",this);
			this.setComplete(ProjectOLFacade.GetFacadeOL().startUPCommands.GetCompleteFunction());
			this.onCompleteHandler();		
			} else {
			this._facaed.RegisterCommand("on_GetUrlDataProxy",GetUrlDataCommand);	
			this._facaed.RegisterProxy( GetUrlDataProxy.GetInstance());
			// 註冊終結commands
			this._facaed.RegisterCommand( UrlDataEvent.Terminate_GetUrlDataProxy , TerminateGetUrlDataCommand );
			
			}
			
			
		}
		
	}//end class
}//end package