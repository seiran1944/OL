package MVCprojectOL.ControllOL
{
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import Spark.CommandsStrLad;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.proxyStr.ServerStepsStr;
	//import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.commands.SingleCompleteCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.SoarVision.VisionCenter;
	import Spark.Timers.SourceTimer;
	import strLib.GameSystemStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class StartUpInitTools extends SingleCompleteCommands
	{
		
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void 
		{
			//----object>玩家基本資訊與timer啟動程序
			var _sendObj:Object = _obj.GetClass()._obj;
			//----netconnect tools init-----
			AmfConnector(this._facaed.GetProxy(CommandsStrLad.Proxy_NetWork).GetData()).Connect(new NetSetting(_sendObj._getWay));
			PlayerDataCenter.Init(_sendObj.uid,_sendObj._getWay,_sendObj._doMain,_sendObj._token,_sendObj._serverTime);
			//-----sourceTools_init----------
			SourceProxy(this._facaed.GetProxy(CommandsStrLad.SourceSystem).GetData()).InitSourceTool(_sendObj._doMain);
			
			//-----註冊初始時間---
			ServerTimework(this._facaed.GetProxy(ServerStepsStr.TIMEWORK_SYSTEM)).SetServerTime(_sendObj._serverTime);
			
			//-----計時器初始設定(尚未啟動)/遊戲播放器初始設定
			SourceTimer.SetSpeed();
			
			
			trace("system_init");
			
			this.onCompleteHandler();
			//this.onRemoveThisHandler();
		}
		
		
		
	}
	
}