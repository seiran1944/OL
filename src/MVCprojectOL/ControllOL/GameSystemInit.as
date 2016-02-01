package  MVCprojectOL.ControllOL
{
	import flash.display.MovieClip;
	import MVCprojectOL.ControllOL.DataCenter.Commands.GetPlayerDataCommand;
	//import MVCprojectOL.ControllOL.OpenLoading.LoadSysSourceCommands;
	import MVCprojectOL.ControllOL.OpenLoading.Openinit;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ViewOL.AllinOnePanel;
	import MVCprojectOL.ViewOL.OpenLoading.OpenLoadingSystem;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.Interface.IfView;
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.MVCs.Models.SourceTools.SourceTool;
	import strLib.commandStr.OpenCommands;
	//import MVCprojectOL.ControllOL.OpenLoading.OpenCommands;
	import MVCprojectOL.ControllOL.UrlData.GetUrlDataCommand;
	//import MVCprojectOL.ViewOL.OpenLoadingSystem;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.MacroCompleteCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.observer.NotifyInfo;
	import Spark.MVCs.COMMANDS.StarSpark_Complete;
	import strLib.GameSystemStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class GameSystemInit extends MacroCompleteCommands 
	{
		
		//private var _checkFlag:int = 0;
		//private var _notify:NotifyInfo;
		//private var _noteUser:IfNotifyInfo;
		//----source 虛要在把domain餵進去啟動-*-----
	    private var _hello:String = "";
		override protected function initMacroCompleteCommands():void 
		{
			var _ary:Array = [StarSpark_Complete,ServerStepsCommand,StartUpInitTools,GetUrlDataCommand,GetPlayerDataCommand];
		   	var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
				this.AddCommands(_ary[i]);
			}
			//this._hello = "hi,my name is GameSystemInit";
			ProjectOLFacade.GetFacadeOL().startUPCommands = this;
			//this._notify = new NotifyInfo("GameSystem_Init");
			this.SetComplete(this.onCompleteMacroHadler);
		}
		
		
		public function TestHandler():String 
		{
			//this.nextCommandsHandler();
			return this._hello;
		}
		
		public function GetCompleteFunction():Function 
		{
			return nextCommandsHandler;
		}
		
		
		private function onCompleteMacroHadler():void 
		{
		    //----移除this+註冊openLoading的相關commands的事情
			trace("ALL GAME_init final");
			
			//----正式使用-----
			//-----註冊loading畫面
			
			this._facaed.RegisterViewCtrl(new OpenLoadingSystem(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView)));
			this._facaed.RegisterCommand(CommandsStrLad.Source_Complete,Openinit);
			
			//---key塞bg的key--11/24----//--"GUI00001_ICO"
			//trace("getSourceProcxy>>>" + SourceProxy(this._facaed.GetProxy("testAAAA").GetData()));
			var _strKeyTest:String = PlayerDataCenter.LoadingBgKey;
			trace("_strKeyTest__"+_strKeyTest);
			var _loading:Class=Class(SourceProxy(this._facaed.GetProxy(CommandsStrLad.SourceSystem).GetData()).GetImageBitmapData(_strKeyTest));
			trace("getLoadingPic>>"+_loading);
			//OpenLoadingSystem(this._facaed.GetRegisterViewCtrl(GameSystemStrLib.Game_System_Open)).SetLoadingBar(_loading);
			//---removeCommands----
			this._facaed.RemoveCommand(CommandsStrLad.StarUP_Spark,this);
		    ProjectOLFacade.GetFacadeOL().KillCommands();
			
		}
		
		
		
	}
	
}