package UtilsGame
{
	import flash.display.Sprite;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.Utils.Text;
	import strLib.GameSystemStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  TimerTrace extends Commands
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			//trace(_obj.GetClass());
			var _sprite:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameMenuView);
			var _timeText:Text = Text(_sprite.getChildByName("TIMER_CHECK"));
			_timeText.ReSetString(String(_obj.GetClass()));
		}
	}
	
}