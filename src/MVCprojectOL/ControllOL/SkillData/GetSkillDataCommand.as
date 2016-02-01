package MVCprojectOL.ControllOL.SkillData {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 12.12.07.14.12
	 */
	
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	
	import MVCprojectOL.ModelOL.SkillData.SkillDataProxy;
	import MVCprojectOL.ModelOL.SkillData.SkillDataEvent;
	import MVCprojectOL.ControllOL.SkillData.TerminateSkillProxyCommand;

	
	public class GetSkillDataCommand extends Commands {
		
		public function GetSkillDataCommand() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			this._facaed.RegisterProxy( SkillDataProxy.GetInstance() );
			this._facaed.RegisterCommand( SkillDataEvent.Terminate_GetSkillDataProxy , TerminateSkillProxyCommand );
		}
		
	}//end class
}//end package