package MVCprojectOL.ViewOL.ExampleAllPanel
{
	import flash.display.Shape;
	import MVCprojectOL.ViewOL.AllinOnePanel;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class TestCommands extends Commands 
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			
			trace("creatSHOW--------");
			var _AllinOnePanel:AllinOnePanel = AllinOnePanel(this._facaed.GetRegisterViewCtrl("AllinOnePanel_test"));
			this._facaed.RegisterCommand("classBtn",ShowBtnCommands);
			_AllinOnePanel.AddClass(ShowBtn);
			var _ary:Array = [];
			for (var i:int = 0; i < 2;i++ ) {
				var _objSource:Object = { };
				var _sp:Shape = this.CreatShape();
				_objSource._key = "btn" + i;
				_objSource._source = _sp;
				_ary.push(_objSource);
			}
			_AllinOnePanel.AddSourceList(_ary);
			this._facaed.RemoveCommand("Example");
		}
		
		
		private function CreatShape():Shape 
		{
			var _shape:Shape = new Shape();
			//var _color:uint =;
			_shape.graphics.beginFill( Math.floor(Math.random() * 0xffffff));
			_shape.graphics.drawRect(0, 0, 30, 30);
			return _shape 
		}
	}
	
}