package MVCprojectOL.ControllOL.Mail {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.02.18.14.29
	 */
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;

	
	import MVCprojectOL.ControllOL.Mail.CatchMailControl;
	
	public class InitMailSys extends Commands {
		
		
		public function InitMailSys() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			if ( this._facaed.GetCatchCommand( CatchMailControl ) == null ) {
				this._facaed.RegisterCommand( "" , CatchMailControl );//CatchMailControl
			}else {
				trace( "控制器衝突" , CatchMailControl , "from" , this );
			}
			
		}
		
	}//end class
}//end package