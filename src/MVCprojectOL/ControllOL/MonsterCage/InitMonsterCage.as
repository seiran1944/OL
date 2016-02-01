package MVCprojectOL.ControllOL.MonsterCage {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	
	import flash.utils.Dictionary;
	import MVCprojectOL.ControllOL.SharedMethods.TerminateMethod;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import strLib.commandStr.MonsterCageStrLib;
	
	import strLib.proxyStr.ProxyNameLib;
	
	import MVCprojectOL.ControllOL.MonsterCage.CatchMonsterCageControl;
	
	public class InitMonsterCage extends Commands {
		
		public function InitMonsterCage() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void {
			
			//if ( this._facaed.GetCatchCommand( CatchMonsterCageControl ) == null  ) {
			 var _dic:Dictionary=ProjectOLFacade.GetFacadeOL().GetObserver();	
			this._facaed.RegisterCommand( "" , CatchMonsterCageControl );
				this._facaed.RegisterCommand( MonsterCageStrLib.Terminate_MonsterCage , TerminateMethod );//註冊終結事件
				//trace( "獸欄起始" );
			//}
			this._facaed.SendNotify( MonsterCageStrLib.Init_MonsterCage, _obj.GetClass());
			 //trace( "獸欄起始2" );
		}
		
	}//end class
}//end package