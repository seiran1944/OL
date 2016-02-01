package MVCprojectOL.ControllOL.OpenLoading
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import MVCprojectOL.ControllOL.BattleImage.BattleBridgeCommand;
	import MVCprojectOL.ControllOL.CrewCtrl.CrewDefaultCommand;
	import MVCprojectOL.ControllOL.Explore.InitExploreSys;
	import MVCprojectOL.ControllOL.Explore.InitWorldJourneySys;
	import MVCprojectOL.ControllOL.Mail.InitMailSys;
	import MVCprojectOL.ControllOL.Mail.MailStrLib;
	import MVCprojectOL.ControllOL.MissionCompleteCom.MissionCom;
	import MVCprojectOL.ControllOL.MonsterCoM.MonsterChangeCom;
	import MVCprojectOL.ControllOL.SoundControlCenter.CatchSoundControlCenter;
	import MVCprojectOL.ControllOL.SoundControlCenter.SoundEventStrLib;
	import MVCprojectOL.ControllOL.SysError.Error503;
	//import MVCprojectOL.ControllOL.TestCom.EvoTestCommands;
	import MVCprojectOL.ControllOL.TipsCom.TipsOPENCommands;
	import MVCprojectOL.ModelOL.BattleImaging.BattleImagingProxy;
	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;
	import MVCprojectOL.ModelOL.DataRecovery.DataRecoveryCenter;
	import MVCprojectOL.ModelOL.Exchange.ExchangeProxy;
	import MVCprojectOL.ModelOL.MissionCenter.MissionProxy;
	import MVCprojectOL.ModelOL.PvpShop.PvpShopProxy;
	import MVCprojectOL.ModelOL.PvpSystem.PvpSystemProxy;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	import strLib.commandStr.WorldJourneyStrLib;
	//import MVCprojectOL.ModelOL.MonsterEvolution.EvolutionDataCenter;
	import MVCprojectOL.ModelOL.MonsterEvolution.EvolutionProxy;
	import MVCprojectOL.ModelOL.PayBill.PayBillDataCenter;
	import MVCprojectOL.ModelOL.ShopMall.ShopMallProxy;
	//import MVCprojectOL.ModelOL.MonsterRecovery.MonsterRecoveryProxy;
	import MVCprojectOL.ModelOL.VoGroupCallCenter;
	import MVCprojectOL.ViewOL.MainView.MainWall;
	import strLib.commandStr.MajidanStrLib;
	import strLib.proxyStr.ArchivesStr;
	//import MVCprojectOL.ControllOL.AlchemyCtrl.initAlchemy;
	//import MVCprojectOL.ControllOL.DissolveUI.initDissolve;
	//import MVCprojectOL.ControllOL.LibraryCtrl.InitLibrary;
	import MVCprojectOL.ControllOL.MainViewCon.DownSWitchCommands;
	import MVCprojectOL.ControllOL.MainViewCon.MainViewConCenter;
	import MVCprojectOL.ControllOL.MainViewCon.RemoveMViewCommands;
	import MVCprojectOL.ControllOL.MainViewCon.SWitchOpenCom;
	import MVCprojectOL.ControllOL.SharedMethods.InitCatch;
	//import MVCprojectOL.ControllOL.StorageUI.initStorage;
	import MVCprojectOL.ControllOL.TipsCom.TipsCommadns;
	import MVCprojectOL.ModelOL.Alchemy.AlchemyProxy;
	import MVCprojectOL.ModelOL.Equipment.EquipmentProxy;
	//import MVCprojectOL.ModelOL.Equipment.EquipmentTestCommands;
	import MVCprojectOL.ModelOL.Library.LibraryProxy;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	//import MVCprojectOL.ModelOL.ShowSideSys.ShowTipsInfoProxy;
	import MVCprojectOL.ModelOL.SkillData.SkillDataProxy;
	import MVCprojectOL.ModelOL.SourceData.PlayerSourceProxy;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.SoarVision.VisionCenter;
	import Spark.Utils.Text;
	import strLib.commandStr.DissolveStrLib;
	import strLib.commandStr.StorageStrLib;
	import MVCprojectOL.ControllOL.MonsterCage.InitMonsterCage;
	import MVCprojectOL.ControllOL.Troops.TeamUICommand;
	import MVCprojectOL.ControllOL.UserInfo.UserInfoCommands;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Dissolve.DissolveProxy;
	import MVCprojectOL.ModelOL.NetCheck.NetCheckProxy;
	import MVCprojectOL.ModelOL.PackageSys.PackageProxy;
	import MVCprojectOL.ModelOL.Stone.StoneProxy;
	import Spark.Timers.SourceTimer;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UICmdStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.Troop.TroopProxy;
	import MVCprojectOL.ModelOL.UserInfo.UserInfoProxy;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.MainView.TopUserInfoBar;
	import MVCprojectOL.ViewOL.OpenLoading.LoadingBarShow;
	import MVCprojectOL.ViewOL.OpenLoading.OpenLoadingSystem;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfObserver;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.observer.Observer;
	import Spark.MVCs.Models.BarTool.BarGroup;
	import Spark.MVCs.Models.BarTool.BarProxy;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.commandStr.OpenCommands;
	import strLib.commandStr.TeamCmdStr;
	import strLib.commandStr.UserInfoStr;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.BuildingStr;
	import strLib.proxyStr.ProxyMonsterStr;
	import strLib.vewStr.ViewStrLib;
	import UtilsGame.ErrorCOMTracer;
	import UtilsGame.ErrorViewTracer;
	import UtilsGame.TimerTrace;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class CatchSystemCore extends CatchCommands 
	{
		
		
		private var _checkFlag:int = 0;
		private var _checkPrleoader:Array = [];
		//---每次遞增的單位
		private var _unitDeform:int = 0;
		private var _flag:Boolean = false;
		private var _aryStart:Array=[
			OpenCommands.OPEN_INIT,
			CommandsStrLad.Source_Complete,
			//FontStr.FONT_READY,
			ProxyMonsterStr.MosterSystem_Ready,
			BuildingStr.BUILDING_READY,
			ViewSystem_BuildCommands.USERINFO_COMPLETE,
			ViewSystem_BuildCommands.MAINVIEW_COMPLETE,
			ProxyPVEStrList.STONE_PROXYReady,
			ProxyPVEStrList.TIMELINE_PROXYReady,
			ProxyPVEStrList.SOURCE_PROXYReady,
			ProxyPVEStrList.EQUIPMENT_PROXYReady,
			ProxyPVEStrList.ALCHEMY_PROXYReady,
			//----技能列表回來------
			ProxyPVEStrList.Skill_SkillListReady,
			ProxyPVEStrList.LIBRARY_PROXYReady,
			ProxyPVEStrList.TIP_PROXYReady
			];
		//private var 
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
		 // trace("getCatchSystemCore");	
		 //trace(_obj.GetName());
		  this.CheckCommandHandler(_obj);	
			
		}
		
		public function set checkPrleoader(value:Array):void 
		{
			_checkPrleoader = value;
		}
		
		
		override protected function onResCommandsHandler(_obj:IfNotifyInfo):void 
		{
		   	
		}
		
		
		
		
	    override public function GetListRegisterCommands():Array 
		{
			trace("getReturnAry");
			//----後續新增------
			return this._aryStart;
		}
		
		
		/*(-----playerDataCenter---)
		    GUI00001_ICO 魔王城背景圖片 
            GUI00004_ANI 字型檔案 
            GUI00003_ANI 組隊UI 
            //---魔王城要改再建築物裡面拿----
			GUI00001_ANI 魔王城(UI=上方的資訊顯示列表/BG----) 
            GUI00002_ANI 公用元件
		*/
		//---以下為11/16---需要新增的
		//---新增---PlayerData_buildUI
		//---新增---PlayerData_MonsterdUI
		//------需要新增
		//---新增---PlayerData_UI
		//---新增---PlayerData_buildUI
		//---新增---PlayerData_buildUI
		//---新增---PlayerData_buildUI
	    private var _checkStart:int = 1;
		private function getDeformHandler():void 
		{
			this._checkStart++;
			if (this._flag==false) {
				this._unitDeform = Math.floor(100 / this._aryStart.length);
				this._flag = true;
			}
			BarProxy.GetInstance().GetBarGroup("OpenLoading").BarTotalValue("Preloader",(this._unitDeform*this._checkStart)+5);
			var _showStr:String = (this._checkStart>=this._aryStart.length)?"Complete":"Loading......"+this._unitDeform*this._checkStart+"   %";
			LoadingBarShow(this._facaed.GetRegisterViewCtrl(GameSystemStrLib.Game_LoadingShow)).ReSetStr(_showStr);
		}
		
		
		
		//private var _vector:Vector.<String> = new <String>["Main_0","Main_1","Main_2","Main_3","Main_4","Main_5","Main_6","Main_7","Main_8","Main_info","wallPIC"]; 	
		//--2013/05/21---
		private var _vector:Vector.<String> = new <String>["Main_0","Main_1","Main_2","Main_3","Main_4","Main_5","Main_6","Main_7","Main_8","Main_9","Main_10","Main_11","Main_info","wallPIC"]; 	
		private var _MainViewSouce:Object;	
		//---check_proxy是否被建構完成,一完成就拿key要圖片了
		private function CheckCommandHandler(_obj:IfNotifyInfo):void 
		{
			
			//var _showProgress:int = 0;
			//var _showBarText:String = "";
			
			switch(_obj.GetName()) {
				
				case CommandsStrLad.Source_Complete:
				   //-----素材包建構完成回來 
				  //trace("SourceBack---撈圖");
				  this.getDeformHandler();
				  if (this._checkFlag<this._checkPrleoader.length) {//--"OpenLoading","Preloader"
					 //_showProgress = _obj.GetClass()._Progress;
					 //_showBarText =  _obj.GetClass()._KeyCode + "    " + _obj.GetClass()._Progress + "   %";
					  //trace("Preloader[Name]>"+_obj.GetClass()._KeyCode);
					  //trace("Preloader[Progress]>"+_obj.GetClass()._Progress);
					 
					  this._checkFlag++; 
					  if (this._checkFlag==this._checkPrleoader.length) {
						//_showProgress = 0;
						//_showBarText = "Data star Loading.......";
						 trace("SourceBack---撈圖");
						 this._facaed.RegisterProxy(BuildingProxy.GetInstance());
				         //---連線啟動建築物資訊---
				         //BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).ConnectData();  
						
						//---清空loadingbar------
						//---啟動字形---------
					  }
					//trace("check>>>>>>>>>>>>>"+this._checkFlag+">>>>>>[_checkPrleoader]>>>>"+this._checkPrleoader.length);
					  
				   }
				  //trace("prleoader back");	
				  //---source回來
				  
				  
				  
				  
				  //-----Sound----130603
				   this._facaed.RegisterCommand( "" , CatchSoundControlCenter );//系統出使LOADING時可能就匯有背景音樂  因此在這裡先初始播放控制器
				   this.SendNotify( SoundEventStrLib.PlayBGM , "GUI00002_SND" );//測試用
				   this.SendNotify( SoundEventStrLib.PlayBGM , "GUI00001_SND" );//測試用
				   this.SendNotify( SoundEventStrLib.PlayBGM , "GUI00003_SND" );//測試用
				   
				   
				break;
				
				
				
				case ProxyMonsterStr.MosterSystem_Ready:
				  //-----monster回來
				    //---註冊SERVER時間改變控制---
					 trace("-----MonsterCallBack----");
				   this.getDeformHandler();
				    this._facaed.RegisterProxy(NetCheckProxy.GetInstance());
				    this._facaed.RegisterProxy(new TimeLineProxy());
				break;
				
				case BuildingStr.BUILDING_READY:
				  //----build建構完成回來
				  trace("======build is back && build init finish========");
				 // _showProgress = 100;
				 // _showBarText = "buildVO star Loading.......";
				  
				   this.getDeformHandler();
				  this._facaed.RegisterProxy(TroopProxy.GetInstance());
				  this._facaed.RegisterCommand(TeamCmdStr.TEAM_CMD_SYSTEM,TeamUICommand);
				  //K.J. Aris 121126------------
				  this._facaed.RegisterCommand( MonsterCageStrLib.init_MonsterCatchCore ,InitMonsterCage );
				  
				  this._facaed.RegisterProxy(new MonsterProxy());
				  //this._facaed.RegisterCommand(PVECommands.MONSTER_VauleCANGE,MonsterChangeCom);
				  //this._checkFlag++;
				break;
				
				
				//--排程寫回
			    case ProxyPVEStrList.TIMELINE_PROXYReady:
				   trace("======Buildschedule Ready========");  
				    this.getDeformHandler();
				   //------註冊所有系統的proxy
				   //---溶解所
				   this._facaed.RegisterProxy(new DissolveProxy());
				   //---包包
				   this._facaed.RegisterProxy(new PackageProxy());
				   this._facaed.RegisterProxy(new StoneProxy());
				break;
				
				
				//--stone 資訊寫入完畢
			    case ProxyPVEStrList.STONE_PROXYReady:
				 
				  trace("=============STONE_PROXYReady==============");
				  this.getDeformHandler();
				  var _ary:Array = PlayerDataCenter.GetInitUiKey(GameSystemStrLib.SysUI_City);
				  //---魔王城-----
				  this._MainViewSouce= Object(SourceProxy(this._facaed.GetProxy(CommandsStrLad.SourceSystem).GetData()).GetMaterialSWP(_ary[0], this._vector));
			      var _aryClass:Array=this.getClassObjHandler(this._MainViewSouce,[this._vector[this._vector.length-2]]);
				  //var _ifProxy:IfProxy = this._facaed.GetProxy(CommandsStrLad.TEXTDRIFT_SYSTEM);
				  this._facaed.RegisterProxy(new UserInfoProxy(this._facaed.GetProxy(CommandsStrLad.TEXTDRIFT_SYSTEM)));
				  var _funProxy:Function = UserInfoProxy(this._facaed.GetProxy("userInfo_proxy").GetData()).GetFunction();
				  
				  this._facaed.RegisterViewCtrl(new TopUserInfoBar((ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameUiView)),_funProxy));
				  
				  TopUserInfoBar(this._facaed.GetRegisterViewCtrl("userInfoView")).AddSource(_aryClass[0]);
				    
				  //----建築物素材清單要再回寫回去,這樣才有辦法在這邊拿........
				
				
				break;
				
				/*
			    case FontStr.FONT_READY:
				  //---字型回來
				  trace("FontStr.FONT_READY is back");
				  //---清空loadingbar------
				  //--準備啟動各VO-------
				  _showProgress = 0;
				  _showBarText = "MonsterData star Loading.......";
				  this._facaed.RegisterProxy(new MonsterProxy());
				  //this._facaed
				  
				  
				  
				break;
			    */
				//----技能庫回來
			    case ProxyPVEStrList.Skill_SkillListReady :
				    //----玩家source(背包需求)
					 this.getDeformHandler();
					trace("back---->"+"技能庫回來回來_PlayerSource(init)");
					this._facaed.RegisterProxy(new PlayerSourceProxy());
				break;
				
				
				
				//-----view顯示玩家狀態建夠完成
				case ViewSystem_BuildCommands.USERINFO_COMPLETE:
					 this.getDeformHandler();
				   //---12/13 PlayerSource_test---
				   
				   //this._facaed.RegisterCommand( ProxyPVEStrList.SOURCE_PROXYReady,SourceTestCommands);
				  trace("back---->"+"建築物回來_skill(init)");
				   this._facaed.RegisterProxy(SkillDataProxy.GetInstance());
					
				break;	
				
				//----玩家素材建購回來
			    case ProxyPVEStrList.SOURCE_PROXYReady:
				   this.getDeformHandler();
				  //---12-17---player_equ----------
				   //this._facaed.RegisterCommand(ProxyPVEStrList.EQUIPMENT_PROXYReady,EquipmentTestCommands);
				  trace("back---->"+"玩家素材回來_Library(init)");
				   this._facaed.RegisterProxy(new LibraryProxy());
				
				break;
				
				//----玩家裝備回來
				case ProxyPVEStrList.EQUIPMENT_PROXYReady:
				    this.getDeformHandler();
				   //----12/12AlchemySYStem_test
				   //this._facaed.RegisterCommand( ProxyPVEStrList.ALCHEMY_PROXYReady,AlchemyTestCommands);
				   trace("back---->"+"玩家裝備回來_Alchemy(init)");
				   this._facaed.RegisterProxy(new AlchemyProxy());
				   
				break;
				
				//-----圖書館回來
				case  ProxyPVEStrList.LIBRARY_PROXYReady:
				   this.getDeformHandler();
				   trace("back---->"+"玩家圖書館回來_Equipment(init)");
				   this._facaed.RegisterProxy(new EquipmentProxy());
				break;
				
				
				
				
				
				//---配方表回來
			    case ProxyPVEStrList.ALCHEMY_PROXYReady:
				     this.getDeformHandler();
				    trace("back---->"+"配方表回來_Main view(init)");
					this._facaed.RegisterProxy(new TipsInfoProxy());
				break;
				
			    case ProxyPVEStrList.TIP_PROXYReady:
				       
				   TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipData();
				 
				    this.getDeformHandler();
				    trace("TIP素材回來");
					//-----tips system-----
					this._facaed.RegisterCommand(PVECommands.TimeLineCOmelete_TipCMD, TipsCommadns);
					this._facaed.RegisterViewCtrl(new TipsCenterView(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameUiView)));
					//---註冊tipsview
					TipsCenterView(this._facaed.GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).SetTipsConter(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView),ViewStrLib.MAIN_VIEWCENTER);
					
				    //TopUserInfoBar(this._facaed.GetRegisterViewCtrl("userInfoView")).ChangeDic();
					//---註冊(改變玩家狀態)---
					this._facaed.RegisterCommand(UserInfoStr.CHANGE_USERINFO, UserInfoCommands);
					//---註冊(主場景系統)---
					this._facaed.RegisterViewCtrl(new MianViewCenter(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView)));
					
					
					
					
					var _VectorClone:Vector.<String> = this._vector.slice(0);
					//_VectorClone.pop();
					_VectorClone.splice(_VectorClone.length - 4, 4);
					//_VectorClone.pop();
					var _arySourceClass:Array = this.creatArrayHandler(_VectorClone);
					MianViewCenter(this._facaed.GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).AddSource(_arySourceClass);
				
				break;
				
				//----view魔王城建夠完成
			    case ViewSystem_BuildCommands.MAINVIEW_COMPLETE:
				   //-----魔王城建構完成----
				   this.getDeformHandler();
				   //----停止monster動畫----
				   //var _monsterLoaderMC:monsterLoader= monsterLoader(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).getChildByName("monsterLOADER"));
				   var _monsterLoaderMC:dogLoading= dogLoading(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).getChildByName("dogLoading"));
				   _monsterLoaderMC.stop();
				   ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).removeChild(_monsterLoaderMC);
				   
				   //monsterLoader(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).getChildByName("monsterLOADER")).stop();
				   
				   trace("ViewSystem_BuildCommands.MAINVIEW_COMPLETE");
				   //----以下為測試用---
				   //OpenLoadingSystem(this._facaed.GetRegisterViewCtrl(GameSystemStrLib.Game_System_Open)).CloseTest();
				   //OpenLoadingSystem(this._facaed.GetRegisterViewCtrl(GameSystemStrLib.Game_System_Open));
				   //this._facaed.RemoveRegisterViewCtrl(GameSystemStrLib.Game_System_Open);
				   //MianViewCenter(this._facaed.GetRegisterViewCtrl("main_viewCenter")).initOpenView();
				   //----以上為測試用---
				   
				   
				  
				   //-----12/7---kai----
				   //---熔解所
				   this._facaed.RegisterCommand(DissolveStrLib.Init_DissolveCatch,InitCatch);
				    //----背包
				   this._facaed.RegisterCommand(StorageStrLib.Init_StorageCatch,InitCatch);
				   
				   //-----鍊金
				   this._facaed.RegisterCommand( UICmdStrLib.Init_Alchemy , InitCatch );
                   //----library
				   this._facaed.RegisterCommand( UICmdStrLib.Init_Library  , InitCatch );
				   
				   //---timerTrace--面板記時器的註冊
				   //this._facaed.RegisterCommand(PVECommands.CHANGE_TIMETRACECMD,TimerTrace);
				   
				   
				   //---戰鬥系統--
				   this._facaed.RegisterProxy(BattleImagingProxy.GetInstance());
			       this._facaed.RegisterCommand(ArchivesStr.BATTLEIMAGING_BRIDGE,BattleBridgeCommand);
				   
				   //---探索系統--
				   this._facaed.RegisterCommand( MajidanStrLib.InitExploreSystemCommand , InitExploreSys );
				   //-*----建築物升級---
				   this._facaed.RegisterCommand( UICmdStrLib.Init_BuildingUp  , InitCatch );

				   //-----隊伍(新版)---0503要增加proxyReady的監聽(ArchivesStr.CREW_READY)
				   this._facaed.RegisterProxy(CrewProxy.GetInstance());
				   //----
				   this._facaed.RegisterCommand(ArchivesStr.CREW_DEFAULT_SHOW,CrewDefaultCommand);
				   CrewProxy.GetInstance().ConnectData();

				   
				   //-----建構下方資訊共用面板------ 
				   this._facaed.RegisterViewCtrl(new MainSystemPanel(ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameUiView)));
				   var _aryBG:Array = this.getClassObjHandler(this._MainViewSouce, [this._vector[11]]);
				   MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddBG(_aryBG[0]);
				   //var _classAry:Array = this.getClassObjHandler(this._MainViewSouce,["wallPIC"]);
				   var _btnBitmap:BitmapData = BitmapData(new (this.getClassObjHandler(this._MainViewSouce,["wallPIC"]))[0]);
				   var _numberAry:Array = SourceProxy.GetInstance().CutImgaeHandler(_btnBitmap, 52, 52, "wallPIC");
				   MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddClass(MainWall);
				   MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddSingleSource("",_numberAry);
				   
				   
				   //--------------------------移除主畫面---
				   this._facaed.RegisterCommand(ViewSystem_BuildCommands.MAINVIEW_REMOVE,RemoveMViewCommands);
				   //----完成所有的啟動程序----移除loading畫面-----
				   BarProxy(this._facaed.GetProxy(CommandsStrLad.BAR_SYSTEM)).RemoveGroup("OpenLoading");
				   this._facaed.RemoveRegisterViewCtrl(GameSystemStrLib.Game_System_Open);
				   this._facaed.RemoveRegisterViewCtrl(GameSystemStrLib.Game_LoadingShow);
				   //--開啟主畫面
				   MianViewCenter(this._facaed.GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).initOpenView();
				   TopUserInfoBar(this._facaed.GetRegisterViewCtrl("userInfoView")).ChangeDic();
				   MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).StarShow();
				   //---註冊面板控制字串----
				   //this._facaed.RegisterCommand(PVECommands.CHANGE_MOTIONCMD, SwitchPanelCommands);
				   this._facaed.RegisterCommand(ViewSystem_BuildCommands.MAINVIEW_SwitchReady,SWitchOpenCom);
				   this._facaed.RegisterCommand(ViewSystem_BuildCommands.MAINVIEW_SWICH,DownSWitchCommands);
				   
				  
				   
				   //* 12/12測試關閉
				   //---移除commands---
				   
				   this._facaed.RemoveALLCatchCommands(this);
				   //----啟動計時器---
				   SourceTimer.ToRun();
				   VisionCenter.GetInstance().Start();
				   ServerTimework.GetInstance().ToRun(-1);
				   TimeLineProxy(this._facaed.GetProxy(ProxyPVEStrList.TIMELINE_PROXY)).ToRun();
				   //---啟動vogroup連線註冊(2013/2/20)---
				   VoGroupCallCenter.GetVoGroupCallCenter().ToRun();
				  
				    //------註冊怪獸的回復係數數值HP/ENG----2013/3/06-eric
				   //var _testproxy:IfProxy =;
				   //this._facaed.RegisterProxy( MonsterRecoveryProxy.GetMonsterRecovery());
				   this._facaed.RegisterProxy( DataRecoveryCenter.GetDataRecoveryCenter());
				  
				   //---商城明細
				   this._facaed.RegisterProxy(PayBillDataCenter.GetInstance()); 
				   //------註冊商城功能--0412(測式檔案)---
				   this._facaed.RegisterProxy(new ShopMallProxy()); 
				   //---04/24進化---
				   this._facaed.RegisterProxy(new EvolutionProxy());  
				   //----0430 進化
				   this._facaed.RegisterCommand( UICmdStrLib.Init_Evolution ,InitCatch );

				   //-----04/25進化測試---
				   //this._facaed.RegisterCommand(ProxyPVEStrList.MonsterEvolution_EvoListReady,EvoTestCommands);
				   //---04/26王國
				   this._facaed.RegisterCommand( WorldJourneyStrLib.InitWorldJourneyCommand , InitWorldJourneySys );
				   //--0508--資料錯誤重整訊息--
				   this._facaed.RegisterCommand( Error503.Error503Event , Error503 );
				   //----0510---pvp(建築物註冊之後)
				   this._facaed.RegisterProxy(PvpSystemProxy.GetInstance());
				   //---任務----0515
				   this._facaed.RegisterProxy(new MissionProxy());
				   
				   this._facaed.RegisterCommand(PVECommands.MISSION_COM_COMPLETE, MissionCom);
				   
				   
				   //-----0515view---
				   
				   //-----任務列表----
				   this._facaed.RegisterCommand( UICmdStrLib.Init_TaskList  , InitCatch );
				   //-----PVP----
				   this._facaed.RegisterCommand( UICmdStrLib.Init_PVP  , InitCatch );
				   
				   //-----交易所
				   this._facaed.RegisterProxy(new ExchangeProxy());

				   //-----轉盤----
				   this._facaed.RegisterCommand( UICmdStrLib.Init_Turntable  , InitCatch );

				   //0606-----PVP商店----
				   this._facaed.RegisterProxy(PvpShopProxy.GetInstance());
				   
				   //-----拍賣----
				   this._facaed.RegisterCommand( UICmdStrLib.Init_Auction , InitCatch );
				   //-----魔鬥商城----
				   this._facaed.RegisterCommand( UICmdStrLib.Init_DevilStore , InitCatch );  
				   
				   //---信件-*-
				   this._facaed.RegisterCommand( MailStrLib.OpenMailSys  , InitMailSys );
				   //---戰報--
				   this._facaed.RegisterCommand( UICmdStrLib.Init_BattleReport , InitCatch );
				   
				   //---轉跳系統--
				   this._facaed.RegisterCommand( ProxyPVEStrList.TIP_CompleteOpen,TipsOPENCommands);
				   //---註冊除錯工程板(測試用~擺最後)----
				   this.creatVisionHandler();
				   //this._facaed.
				   
				break;
				
				
				
			   
				
			}
			
			//LoadingBarShow(this._facaed.GetRegisterViewCtrl(GameSystemStrLib.Game_LoadingShow)).ReSetStr(_showBarText);
			//BarGroup(BarProxy(this._facaed.GetProxy(CommandsStrLad.BAR_SYSTEM)).GetBarGroup("OpenLoading")).BarTotalValue("Preloader",_showProgress);
		}
		
		private function creatVisionHandler():void 
		{
			this._facaed.RegisterViewCtrl(new ErrorViewTracer());
			this._facaed.RegisterCommand("ERROR_TRACER_COM",ErrorCOMTracer);
			var _sprite:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameMenuView);
			var _strVision:String = ProjectOLFacade.GetFacadeOL()._SparkVision + "____" + ProjectOLFacade.GetFacadeOL()._OLVision;
			var _starTime:String = String(ServerTimework.GetInstance().ServerTime);
			
			var _text:Text = new Text({_str:_strVision,_wid:100,_hei:20,_wap:false,_AutoSize:"LEFT",_col:0xffffff,_Size:12,_bold:true});
			//var _textTimer:Text = new Text({_str:_starTime,_wid:100,_hei:20,_wap:false,_AutoSize:"LEFT",_col:0xffffff,_Size:12,_bold:true});
			_text.name = "VISION_TXT";
			//_textTimer.name = "TIMER_CHECK";
			_sprite.addChild(_text);
			//_sprite.addChild(_textTimer);
			//var _moneyBack:String="use:N__back:N_"
			var _textMoney:Text= new Text({_str:"usePay : N",_wid:100,_hei:20,_wap:false,_AutoSize:"LEFT",_col:0xffffff,_Size:12,_bold:true});
			_textMoney.name = "PAY_TXT";
			_sprite.addChild(_textMoney);
			var _point:Point=ProjectOLFacade.GetFacadeOL().GetStageInfo();
			
			
			_text.x = _point.x - (_text.width+20);
			_text.y = 0;
			_textMoney.y  = 70;
			_textMoney.x = 0;
			
			//_textTimer.x = _text.x;
			//_textTimer.y = _text.y + 20;
			
		}
		
		private function creatArrayHandler(_vector:Vector.<String>):Array 
		{
			var _len:int = _vector.length;
	        var _ary:Array = [];
			for (var i:int = 0; i < _len;i++ ) {
				_ary.push(_vector[i]);
				
			}
			
			var _return:Array = this.getClassObjHandler(this._MainViewSouce, _ary);
			return _return;
		}
		
		
		private function getClassObjHandler(_class:Object,_ary:Array):Array 
		{
			var _returnAry:Array = [];
			var _len:int = _ary.length;
			for (var j:int = 0; j < _len;j++ ) {
				
				for (var i:String in _class) {
				    if (_ary[j]==i) {
						_returnAry.push(_class[i]);
						trace("[CLASS====]"+i);
						break;
					}	
			    }
			}
			
			return _returnAry;
			
		}
		
	}
	
}