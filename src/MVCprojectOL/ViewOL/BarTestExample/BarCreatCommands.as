package MVCprojectOL.ViewOL.BarTestExample
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	//import flash.display.DisplayObjectContainer;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.MVCs.Models.BarBasic;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  BarCreatCommands extends Commands
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			trace("OH~barTest[commands]");
			var _barproxy:BarBasic = BarBasic(this._facaed.GetProxy(CommandsStrLad.SorceBar_Proxy).GetData());
			var _barPic:DisplayObject = _barproxy.GetBar(100, 0, 200, 20,true,0x89FF19,"","",null,0x000000);
			//var _barPic:Bitmap = _barproxy.GetBar(100, 0, 200, 20,0x89FF19,"","",Blood_bmp);
			var _view:ShowViewBar = ShowViewBar(this._facaed.GetRegisterViewCtrl("testBarProxy"));
			_view.AddBar(_barPic);
		}
	}
	
}