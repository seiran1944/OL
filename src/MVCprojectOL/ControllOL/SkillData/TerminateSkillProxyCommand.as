package MVCprojectOL.ControllOL.SkillData {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 12.12.07.14.12
	 */
	
	
	
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	
	import MVCprojectOL.ModelOL.Explore.ExploreAdventure;
	import MVCprojectOL.ModelOL.Explore.ExploreEvent;
	
	import MVCprojectOL.ModelOL.SkillData.SkillDataProxy;
	import MVCprojectOL.ModelOL.SkillData.SkillDataEvent;
	import strLib.proxyStr.ProxyNameLib;
	
	import strLib.proxyStr.ProxyNameLib;
	
	public class TerminateSkillProxyCommand extends Commands {
		
		public function TerminateSkillProxyCommand() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void {
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_SkillDataProxy );
			this._facaed.RemoveCommand( SkillDataEvent.Terminate_GetSkillDataProxy , TerminateSkillProxyCommand );
		}
		
	}//end class
}//end package