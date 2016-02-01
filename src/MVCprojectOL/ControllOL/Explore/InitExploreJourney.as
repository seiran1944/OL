package MVCprojectOL.ControllOL.Explore {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.02.18.14.29
	 */
	
	import MVCprojectOL.ControllOL.BattleImage.BattleImagingCommand;
	import MVCprojectOL.ControllOL.Explore.Journey.CatchJourneyControl;
	import MVCprojectOL.ControllOL.Explore.Majidan.CatchMajidanControl;
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	import MVCprojectOL.ModelOL.Explore.Journey.ExploreAdventure;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import strLib.commandStr.ExploreAdventureStrLib;
	import strLib.commandStr.MajidanStrLib;
	
	
	import MVCprojectOL.ModelOL.Explore.Majidan.MajidanProxy;
	
	public class InitExploreJourney extends Commands {
		
		private var _ExploreDataCenter:ExploreDataCenter = ExploreDataCenter.GetInstance();
		
		public function InitExploreJourney() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			if ( this._facaed.GetCatchCommand( CatchJourneyControl ) == null ) {
				this._facaed.RegisterCommand( "" , CatchJourneyControl );//CatchJourneyControl
				this.SendNotify( ExploreAdventureStrLib.Init_ExploreAdventureSys );
			}else {
				trace( "控制器衝突" , CatchJourneyControl , "from" , this );
			}
			
			
			//this._facaed.SendNotify( MajidanStrLib.Init_Majidan );
			
			
			
			
			/*var _ExploreAdventure:ExploreAdventure = ExploreAdventure.GetInstance();
				this._facaed.RegisterProxy( _ExploreAdventure );
				_ExploreAdventure.InitModule( this._ExploreDataCenter._currentSelectedAreaKey , this._ExploreDataCenter._currentSelectedTeamKey );*/
				
			 
		}
		
	}//end class
}//end package