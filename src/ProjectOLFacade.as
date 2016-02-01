package 
{
	//import Spark.CommandStr.CommandsStrLad;
	import adobe.utils.CustomActions;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.ScriptTimeoutError;
	import flash.geom.Point;
	import MVCprojectOL.ControllOL.GameSystemInit;
	import MVCprojectOL.ControllOL.StartUpInitTools;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.MVC.FacadeCenter;
	import Spark.coreFrameWork.MVC.MeditorGuiCenter;
	import Spark.MVCs.COMMANDS.StarSpark;
	import strLib.GameSystemStrLib;
	//import Spark.MVCs.COMMANDS.StartUp.StarSpark;
	
	/**
	 * ...
	 * @author EricHuang
	 *  * //--Engine SparkEngine V1.07
	 * 
	 * //---Overlord_V20121224_1423
	 */
	public class ProjectOLFacade extends FacadeCenter
	{
		
		private static var _Facade:ProjectOLFacade;
		private var _main:Main;
		private var _stage:Stage;
		private var _disMenuView:Sprite;
		private var _disSystemView:Sprite;
		private var _disUiView:Sprite;
		private var _startUPCommands:GameSystemInit;
		//---圖層選單控制器-----
		private var _meditorGuiCenter:ViewUIMeditor;
		//---check layerFlag----
		private var _flagLayer:int = 0;
		
		public var _SparkVision:String = "SparkEngine V1.18";
		public var _OLVision:String = "Overlord_V20130618_1630";
		
		public function ProjectOLFacade() 
		{
			if (ProjectOLFacade._Facade!=null) throw Error("[ProjectOLFacade] build illegal!!!please,use [Singleton]");
		    this._meditorGuiCenter = new ViewUIMeditor();
			ProjectOLFacade._Facade = this;
			
		}
		
		public static function GetFacadeOL():ProjectOLFacade 
		{
			if (ProjectOLFacade._Facade == null) new ProjectOLFacade();
		    return ProjectOLFacade._Facade	
		}
		
		
		public function get startUPCommands():GameSystemInit 
		{
			return _startUPCommands;
		}
		
		public function set startUPCommands(value:GameSystemInit):void 
		{
			_startUPCommands = value;
		}
		
		public function KillCommands():void 
		{
			this._startUPCommands = null;
		}
		
		
		//---------init registercommands-------
		override protected function initGetCtrlCenter():void 
		{
			super.initGetCtrlCenter();
			//----11/19測試---
			//this.RegisterCommand(CommandsStrLad.StarUP_Spark,StarSpark);
			//---正式----
			this.RegisterCommand(CommandsStrLad.StarUP_Spark, GameSystemInit);
			
		}
		/*
		public function TestNetConnect():void 
		{
			this.SendNotify(CommandsStrLad.StarUP_Spark);
		}	ˇ
		*/
		//------啟動引擎&&遊戲第一階段的系統初始(連線建立)
		public function StartUpSparkEngine(_initObj:Object,_layAry:Array):void 
		{
	        this.SetDisplayConter(_layAry);
			this.SendNotify(CommandsStrLad.StarUP_Spark,_initObj);	
			
		}
		
		
		private function SetDisplayConter(_ary:Array):void 
		{
			/*
			this.addChild(this._disSystemView);
			this.addChild(this._disUiView);
			this.addChild(this._disMenuView);
			var _aryLayer:Array = [this,this._disSystemView,this._disUiView,this._disMenuView];
			*/
			if (_ary[0] is DisplayObjectContainer  && this._stage == null)this._stage = _ary[0];	
			
			//---最外層Main---
			if (_ary[1] is DisplayObjectContainer  && this._main == null)this._main = _ary[1];
			
			//--各系統所使用的畫面
			if (_ary[2] is DisplayObjectContainer && this._disSystemView == null)this._disSystemView = _ary[2];
			
			//---UI/TIP面板使用的---
			if (_ary[3] is DisplayObjectContainer && this._disMenuView == null)this._disMenuView = _ary[3];
			 
			//----由細資訊系統專用---(上下資訊列)
			if (_ary[4] is DisplayObjectContainer && this._disUiView == null)this._disUiView = _ary[4];
			
			trace("viewINIT");
		}
		
		
		private function creatVisionHandler():void 
		{
			
		}
		
		
		public function GetStageInfo():Point 
		{
			
			//var _width:Number = stage.stageWidth;
			//var _height:Number = stage.stageHeight;
			var _point:Point=new Point(this._stage.stageWidth,this._stage.stageHeight)
			return _point;
		}
		
		//----供其他物件取得應該添加的顯示物件容器----
		public function GetDisplayConter(_type:String):Sprite 
		{
			var _returnConter:Sprite;
			switch(_type) {
			   //TIP面板使用的---
			   case GameSystemStrLib.GameMenuView:
			   _returnConter = this._disMenuView;   
			   break;	   
			   //--各系統取用的
		       case GameSystemStrLib.GameSystemView:
			    _returnConter = this._disSystemView; 
			   break;
			   //----由細資訊系統專用---(上下資訊列)
		       case GameSystemStrLib.GameUiView:
			   trace("getSpr");
			    _returnConter = this._disUiView; 
			   break; 
			}
			return _returnConter;
		}
		
		
	}
	
}