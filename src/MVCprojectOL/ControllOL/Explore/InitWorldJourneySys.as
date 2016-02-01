package MVCprojectOL.ControllOL.Explore {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.02.18.14.29
	 */
	
	import MVCprojectOL.ControllOL.Explore.Majidan.CatchMajidanControl;
	import MVCprojectOL.ControllOL.Explore.WorldJourney.CatchWorldJourneyControl;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import strLib.commandStr.UICmdStrLib;

	import strLib.commandStr.WorldJourneyStrLib;
	
	import MVCprojectOL.ControllOL.Explore.InitExploreJourney;
	
	
	import MVCprojectOL.ModelOL.Explore.Majidan.MajidanProxy;
	
	public class InitWorldJourneySys extends Commands {
		
		public function InitWorldJourneySys() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			
			//this._facaed.RegisterProxy( MajidanProxy.GetInstance() );//世界地圖的起手
			
			//this._facaed.RegisterCommand( "InitExploreJourney" , InitExploreJourney );
			if ( this._facaed.GetCatchCommand( CatchWorldJourneyControl ) == null ) {
				trace( "啟動王國系統" );
				
				this._facaed.RegisterCommand( "InitExploreJourney" , InitExploreJourney );
				
				this._facaed.RegisterCommand( "" , CatchWorldJourneyControl );//CatchMajidanControl proxy測試
				this._facaed.SendNotify( WorldJourneyStrLib.Init_WorldJourney );
			}else {
				trace( "控制器衝突" , CatchWorldJourneyControl , "from" , this );
				this._facaed.RemoveALLCatchCommands( CatchWorldJourneyControl );
				
				this._facaed.RegisterCommand( "InitExploreJourney" , InitExploreJourney );
				this._facaed.RegisterCommand( "" , CatchWorldJourneyControl );//CatchMajidanControl proxy測試
				this._facaed.SendNotify( WorldJourneyStrLib.Init_WorldJourney );
				//this._facaed.SendNotify( UICmdStrLib.MapData );
			}
			
			
			
			//流程========
			//註冊控制器
			//執行初始方法
			
			
			//地圖選擇完畢後=====
			//連結組隊模組
			//傳遞所選組隊資訊 id key     monster members
			//起始探索
			
			 //this._facaed.RegisterCommand
			 
		}
		
	}//end class
}//end package