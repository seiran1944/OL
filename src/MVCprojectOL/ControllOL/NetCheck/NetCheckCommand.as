package MVCprojectOL.ControllOL.NetCheck {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	
	import Spark.CommandsStrLad;
	
	import MVCprojectOL.ModelOL.NetCheck.NetCheckProxy;
	
	import MVCprojectOL.ControllOL.DataCenter.Commands.TerminateGetPlayerDataCommand;
	
	public class NetCheckCommand extends Commands {
		
		public function NetCheckCommand() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			this._facaed.RegisterProxy( NetCheckProxy.GetInstance() );
			
			
		}
		
	}//end class
}//end package