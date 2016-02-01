package  MVCprojectOL.ControllOL.OpenLoading
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ViewOL.OpenLoading.LoadingBarShow;
	import MVCprojectOL.ViewOL.OpenLoading.OpenLoadingSystem;
	//import MVCprojectOL.ViewOL.OpenLoadingSystem;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.MVCs.Models.BarBasic;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.OpenCommands;
	import strLib.GameSystemStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  Openinit extends Commands  
	{
		
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			//----移除啟動撈背景的動作----
			trace("----background is back---" + _obj.GetClass()._KeyCode );
			this._facaed.RemoveCommand(CommandsStrLad.Source_Complete,this);
			//---註冊OpenSystemCore-----[CatchCommands]----
			//var _ary:Array = [OpenSystemCore];
			this._facaed.RegisterCommand("",CatchSystemCore);
		    var _sourceProxy:IfProxy = (this._facaed.GetProxy(CommandsStrLad.SourceSystem));
			var _bitmapData:BitmapData = SourceProxy(_sourceProxy).GetImageBitmapData(_obj.GetClass()._KeyCode);//"OpenLoading"
			
			//var _loadingBar:DisplayObject = BarBasic(this._facaed.GetProxy(CommandsStrLad.SorceBar_Proxy).GetData()).GetBar(100,0,554,10,true,0xfa0300,"OpenLoading","Preloader", loadingBar,0xB6C8DA,bgloading);
			var _loadingBar:DisplayObject = BarBasic(this._facaed.GetProxy(CommandsStrLad.SorceBar_Proxy).GetData()).CreatSpBar(100, 0, loadingBar, bgloading, "OpenLoading", "Preloader",66.8,45);
			//----loadingBarSystem---------
			this._facaed.RegisterViewCtrl(new LoadingBarShow(_loadingBar));
			//this._facaed.RegisterViewCtrl(new LoadingBarShow());
		    var _spr:DisplayObjectContainer = this._facaed.GetRegisterViewCtrl(GameSystemStrLib.Game_LoadingShow).GetViewConter();
			//----加入進度條------
			OpenLoadingSystem(this._facaed.GetRegisterViewCtrl(GameSystemStrLib.Game_System_Open)).AddRealBaR(_spr);
			OpenLoadingSystem(this._facaed.GetRegisterViewCtrl(GameSystemStrLib.Game_System_Open)).SetBackGround(_bitmapData);
			LoadingBarShow(this._facaed.GetRegisterViewCtrl(GameSystemStrLib.Game_LoadingShow)).ReSetStr("Loading......");
				
			//---一口氣取
			var _ary:Array = PlayerDataCenter.GetInitUiKey();
			//var _frontKey:String = PlayerDataCenter.FontKey;
			//if (PlayerDataCenter.FontKey != "Error")_ary.push(PlayerDataCenter.FontKey);
			CatchSystemCore(this._facaed.GetCatchCommand(CatchSystemCore)).checkPrleoader=_ary;
			//--Preloadsource-----
			SourceProxy(this._facaed.GetProxy(CommandsStrLad.SourceSystem)).PreloadMaterial(_ary);
			
			
		}
		
		
	}
	
}