package MVCprojectOL.ViewOL.ExampleAllPanel
{
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.GameSystemStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class CreatBasicPanel extends Commands 
	{
		
		private var _timer:Timer;
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			trace("creatBasicPanel");
			//var _AllinOnePanel:AllinOnePanel = AllinOnePanel(this._facaed.GetRegisterViewCtrl("AllinOnePanel_test"));
			var _DisplayObjectContainer:DisplayObjectContainer = DisplayObjectContainer(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameUiView));
			this._facaed.RegisterCommand("Example",TestCommands);
			this._facaed.RegisterViewCtrl(new BasicBgPanelAAA(_DisplayObjectContainer, "AllinOnePanel_test"));
			
			var _panel:BasicBgPanelAAA = BasicBgPanelAAA(this._facaed.GetRegisterViewCtrl("AllinOnePanel_test"));
			_panel.AddBG(new bg());
			this._timer = new Timer(3000, 1);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,onReadyHandler);
			this._timer.start();
			
			/*
			_AllinOnePanel.AddClass(ShowBtn);
			var _ary:Array = [];
			for (var i:int = 0; i < 2;i++ ) {
				var _sp:Shape = this.CreatShape();
				_ary.push(_sp);
			}
			_AllinOnePanel.AddSourceList(_ary);
			this._facaed.RemoveCommand("Example");
			*/
		}
		
		private function onReadyHandler(e:TimerEvent):void 
		{
			trace("time is complete");
			this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onReadyHandler);
			this._timer = null;
			this._facaed.SendNotify("Example");
			this._facaed.RemoveCommand("CreatBP");
			
			
		}
		
	}
	
}