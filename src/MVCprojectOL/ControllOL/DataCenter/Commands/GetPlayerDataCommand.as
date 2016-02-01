package MVCprojectOL.ControllOL.DataCenter.Commands {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	//import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.commands.SingleCompleteCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	
	import Spark.CommandsStrLad;
	
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataProxy;
	import MVCprojectOL.ModelOL.DataCenter.DataCenterEvent;
	
	import MVCprojectOL.ControllOL.DataCenter.Commands.TerminateGetPlayerDataCommand;
	
	public class GetPlayerDataCommand extends SingleCompleteCommands {
		
		public function GetPlayerDataCommand() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			//trace("GetPlayerDataCommand_GO");
			if (_obj.GetClass()==null ) {
				
				this._facaed.RemoveCommand( "on_PlayerDataProxy",this );
				this.setComplete(ProjectOLFacade.GetFacadeOL().startUPCommands.GetCompleteFunction());
			    this.onCompleteHandler();	
			    //this.onCompleteHandler();	
			}else {
			  
				this._facaed.RegisterCommand("on_PlayerDataProxy",GetPlayerDataCommand);
				this._facaed.RegisterProxy( PlayerDataProxy.GetInstance() );
			     // 註冊終結commands
			    this._facaed.RegisterCommand( DataCenterEvent.Terminate_PlayerDataProxy , TerminateGetPlayerDataCommand );
				
			}
			
			
			
			//this.onCompleteHandler();
		}
		
	}//end class
}//end package