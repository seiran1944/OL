package MVCprojectOL.ControllOL.Explore {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.02.18.14.29
	 */
	
	import MVCprojectOL.ControllOL.Explore.Majidan.CatchMajidanControl;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import strLib.commandStr.MajidanStrLib;
	
	import MVCprojectOL.ControllOL.Explore.InitExploreJourney;
	
	
	import MVCprojectOL.ModelOL.Explore.Majidan.MajidanProxy;
	
	public class InitExploreSys extends Commands {
		
		public function InitExploreSys() {
			
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void{
			
			//this._facaed.RegisterProxy( MajidanProxy.GetInstance() );//魔神殿的起手
			
			this._facaed.RegisterCommand( "InitExploreJourney" , InitExploreJourney );
			
			this._facaed.RegisterCommand( "" , CatchMajidanControl );//CatchMajidanControl proxy測試
			this._facaed.SendNotify( MajidanStrLib.Init_Majidan );
			
			
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