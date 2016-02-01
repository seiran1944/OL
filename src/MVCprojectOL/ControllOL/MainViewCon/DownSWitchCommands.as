package MVCprojectOL.ControllOL.MainViewCon
{
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MainView.TopUserInfoBar;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.GameSystemStrLib;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 * ---下降與更換時機----
	 */
	public class DownSWitchCommands extends Commands 
	{
		private var _aryStrSource:Array = ["Main_9","Main_10"];
		private var _arySource:Array;
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
		    var _objSend:Object = _obj.GetClass();
			this._arySource=PlayerDataCenter.GetInitUiKey(GameSystemStrLib.SysUI_City)
			this.checkSwitchHandler(_objSend);
		}
		
		private function checkSwitchHandler(objSend:Object):void 
		{
			//---底板----
			var _btmView:MainSystemPanel = MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main));
			//---上方區域----
			var _showInfo:TopUserInfoBar = TopUserInfoBar(this._facaed.GetRegisterViewCtrl("userInfoView"));
			var _frames:int = 1;
			var _class:Class;
			var _vector:Vector.<String>;
			var _objClass:Object;
			var _motion:String = "CLOSE";
			switch(objSend._btnName) {
			  
				case "EXIT":
				/*
				_vector = new	< String > [this._aryStrSource[1]];
				_objClass = Object(SourceProxy(this._facaed.GetProxy(CommandsStrLad.SourceSystem).GetData()).GetMaterialSWP(this._arySource[0], _vector));
				_class = _objClass[this._aryStrSource[1]];
				_frames = 1;
				*/
				break;
				
				
				case "btn1":
				
				break;
				
				
				case "btn2":
				break;
				//----熔解
			    case "btn3":
				/*
				_vector = new	< String > [this._aryStrSource[0]];
				_objClass = Object(SourceProxy(this._facaed.GetProxy(CommandsStrLad.SourceSystem).GetData()).GetMaterialSWP(this._arySource[0], _vector));
				_class = _objClass[this._aryStrSource[0]];
				_frames = 2;
				*/
				break;
				
			    case "btn4":
				//---儲藏室
				break;
				
			    case "btn5":
				break;
				//----獸欄
				case "btn6":
				break;
				//--組隊
				case "btn7":
				break;
				
				//---探索用的戰鬥
			    case"Explore":
				_class = null;
				_frames = -1;
				break;
				
				
				case "buildUP":
				break;
			}
			
			_btmView.SwitchMotion(_motion,_class);
			_showInfo.SwitchMotion(_motion,_frames);
			
		}
	}
	
}