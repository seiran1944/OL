package MVCprojectOL.ControllOL.MainViewCon
{
	import flash.display.BitmapData;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MainView.MainWall;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.GameSystemStrLib;
	import strLib.vewStr.ViewNameLib;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class CreatMainView extends Commands  
	{
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			//MianViewCenter(this._facaed.GetRegisterViewCtrl("main_viewCenter"));
			//this._facaed.RemoveRegisterViewCtrl("main_viewCenter");
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).RemoveClassAry();
			//var _flag:Object = _obj.GetClass();
			this._facaed.RegisterViewCtrl(new MianViewCenter(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView)));
			if (_obj.GetClass() != null) MianViewCenter(this._facaed.GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).setSwitch = "1";
			
			
			
			TipsCenterView(this._facaed.GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).SetTipsConter(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView),ViewStrLib.MAIN_VIEWCENTER);
			var _ary:Array = PlayerDataCenter.GetInitUiKey(GameSystemStrLib.SysUI_City)
			var _vector:Vector.<String> = new < String > ["Main_0", "Main_1", "Main_2", "Main_3", "Main_4", "Main_5", "Main_6", "Main_7", "Main_8","Main_9"]; 
			var _MainViewSouce:Object= Object(SourceProxy(this._facaed.GetProxy(CommandsStrLad.SourceSystem).GetData()).GetMaterialSWP(_ary[0], _vector));
			var _arySourceClass:Array = this.creatArrayHandler(_vector,_MainViewSouce);
			MianViewCenter(this._facaed.GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).AddSource(_arySourceClass);
			
			
			
			if (MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).getClassLen()<=0) {
			var _btnBitmap:BitmapData=BitmapData(SourceProxy(this._facaed.GetProxy(CommandsStrLad.SourceSystem).GetData()).GetMaterialSWP(_ary[0],"wallPIC",true));
			var _numberAry:Array = SourceProxy.GetInstance().CutImgaeHandler(_btnBitmap, 52, 52, "wallPIC");
			MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddClass(MainWall);
			MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddSingleSource("", _numberAry);	
			}
			
			
			
			//---馬上註冊創造的commands--MAINVIEW_CREAT
			this._facaed.RemoveCommand(ViewSystem_BuildCommands.MAINVIEW_CREAT,this);
		   	this._facaed.RemoveCommand(ViewSystem_BuildCommands.MAINVIEW_COMPLETE,MainViewConCenter);
			this._facaed.RegisterCommand(ViewSystem_BuildCommands.MAINVIEW_REMOVE,RemoveMViewCommands);
		}
		
		private function creatArrayHandler(_vector:Vector.<String>,_class:Object):Array 
		{
			var _len:int = _vector.length;
	        var _ary:Array = [];
			for (var i:int = 0; i < _len;i++ ) {
				_ary.push(_vector[i]);
				
			}
			
			var _returnAry:Array = [];
			var _lensource:int = _ary.length;
			for (var j:int = 0; j < _lensource;j++ ) {
				
				for (var k:String in _class) {
				    if (_ary[j]==k) {
						_returnAry.push(_class[k]);
						trace("[CLASS====]"+k);
						break;
					}	
			    }
			}
			
			return _returnAry;
		
		}
		
	
	}
	
	
	
}