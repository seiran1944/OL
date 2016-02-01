package 
{
	import com.ticore.time.utils.FPSUnthrottler;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.SampleDataEvent;
	import flash.external.ExternalInterface;
	import flash.media.Sound;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	//import MVCprojectOL.ModelOL.Monster.MonsterProxyKJ;
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerMonster;
	import MVCprojectOL.ModelOL.Vo.Get.Get_UrlData;
	import MVCprojectOL.ViewOL.BarTestExample.BarCreatCommands;
	import MVCprojectOL.ViewOL.BarTestExample.ShowViewBar;
	import MVCprojectOL.ViewOL.ExampleAllPanel.CreatBasicPanel;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	//import MVCprojectOL.ControllOL.SimpleCompleteTEST;
	//import MVCprojectOL.ControllOL.TestMacroCompleteCommands;
	//import MVCprojectOL.ControllOL.TimerInitCommands;
	import strLib.GameSystemStrLib;
	//import MVCprojectOL.ControllOL.StartUpInitTools;
	//import MVCprojectOL.ControllOL.TestCommands;
	import Spark.CommandsStrLad;

	/**
	 * ...
	 * @author EricHuang
	 * //--Engine SparkEngine V1.07
	 * //---Overlord_V20121224_1423
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
        private var _initVars:Object;
		private var _disMenuView:Sprite;
		private var _disSystemView:Sprite;
		private var _disUiView:Sprite;
		//private var _loadingBar:monsterLoader;
		private var _loadingBar:dogLoading;
		public function Main(_vars:Object):void 
		{
			this._initVars = _vars;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			trace("init");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			this.initEngineHandler();
		}
    
		private function initEngineHandler():void 
		{
			//var _sound:Sound = new Sound();
			//var _FPSUnthrottler:FPSUnthrottler = new FPSUnthrottler();
			//this.addChild(_FPSUnthrottler);
			//_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataHandler, false, 0, true);
			//_sound.play();
			
			this._disMenuView = new Sprite();
			this._disMenuView.name = "_disMenuView";
			this._disSystemView = new Sprite();
			this._disSystemView.name = "_disSystemView";
			this._disUiView =new Sprite();
			this._disUiView.name = "_disUiView";
			this.addChild(this._disSystemView);
			this.addChild(this._disUiView);
			this.addChild(this._disMenuView);
			//this._disMenuView.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
			if(ExternalInterface.available)ExternalInterface.addCallback("JSCallBackTime",JSCallBackTime);
			
			if (this._initVars==null) {
				//----ERROR---玩家資訊空值狀態(秀出錯誤資訊)------
				
				} else {
				//---直接塞
				
				var _shape:Shape = new Shape();
				_shape.graphics.beginFill(0x000000);
				_shape.graphics.drawRect(0, 0, 1000, 700);
				_shape.name = "fackBG";
				_shape.visible = false;
				this._disSystemView.addChild(_shape);	
				this._loadingBar = new dogLoading();
				//this._loadingBar.name = "monsterLOADER";
				this._loadingBar.name = "dogLoading";
				this._disSystemView.addChild(this._loadingBar);
				//this._loadingBar.play();
				this._loadingBar.x = (this.width-this._loadingBar .width)/2;
				this._loadingBar.y = (this.height-this._loadingBar .height)/2;
				var _sendObj:Object = {_name:GameSystemStrLib.GameSysFirstInit,_obj:this._initVars};	
				var _aryLayer:Array = [stage, this, this._disSystemView, this._disUiView, this._disMenuView];
				
				
				ProjectOLFacade.GetFacadeOL().StartUpSparkEngine(_sendObj,_aryLayer);
			    
			
			}
			
			
			
			
		}
		/*
		private function onSampleDataHandler(e:SampleDataEvent):void 
		{
			 e.data.position = e.data.length = 4096 * 4;
		}
		*/
		/*
		private function onKeyDownHandler(e:KeyboardEvent):void 
		{
			
			trace("keyBoard__"+e.keyCode);
			trace("hello_keyboard")
			
			if (e.keyCode==192) {
				//---開啟工程面板----
			    //ProjectOLFacade.GetFacadeOL().SendNotify("ERROR_TRACER_COM","");
			}
			
			
		}
		*/
		/*
		public static function GAMEINITREADY():void 
		{
			
		}
		*/
		
		public function JSCallBackTime(_timer:uint):void 
		{
			//ServerTime
			if (ServerTimework.GetInstance().ServerTime>0) {
				ServerTimework.GetInstance().SetTimeLineTime(_timer);
				} else {
				return;
			}
			
		}
		
		
		/*
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//---switch/case---
			trace( "QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQq" );
			
			switch(_Result.Status) {
				
				case "PlayerMonster":
					trace("<----------------------------------------getMonsterList");
					//this.AddMonster(_netResultPack._Result as Array );
					
				break;
			}
		}*/
		
		
		
		
	}

}