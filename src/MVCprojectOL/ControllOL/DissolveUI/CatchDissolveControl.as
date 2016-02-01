package MVCprojectOL.ControllOL.DissolveUI 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.Dissolve.DissolveProxy;
	import MVCprojectOL.ModelOL.DissolveUI.DissolveUIProxy;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.ShopMall.ShopMallProxy;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	import strLib.commandStr.ViewSystem_BuildCommands;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	//import MVCprojectOL.ModelOL.ShowSideSys.ShowTipsInfoProxy;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.DissolveUI.DissolveView;
	import MVCprojectOL.ViewOL.DissolveUI.WallExitBtn;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MonsterView.MonsterPanel;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.DissolveStrLib;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.commandStr.UICmdStrLib;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.BuildingStr;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewNameLib;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchDissolveControl extends CatchCommands
	{
		
		private var _DissolveView:DissolveView;
		private var _SourceProxy:SourceProxy;
		private var _DissolveUIProxy:DissolveUIProxy;
		private var _MonsterDisplayProxy:MonsterDisplayProxy;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String > [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn", "pageBtnN", "exitBtn", "TipBtn", "TipBox", "olBoard", 
		"Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg", "DetailBoard", "SkilletBg", "Inform", "MakeBtn", "Fatigue", "Hourglass", "CheckBtn", "BgD", "ReportBg", "EdgeBg", "ContentBg", "Diamond",
		"DemonAvatar","Paper","Job", "Lock", "TableBg", "EvolutionBg"];
		private var _ComponentClasses:Object;
		
		private const _DissolveKey:String = "GUI00006_ANI";//溶解所 素材包KEY碼
		private const _DissolveClasses:Vector.<String> = new < String > [ "bg2" , "BigFireBoiler", "FireBoiler" , "Boiler" , "olBoard", "DialogBox","DataErrorDialog","LowerDialog","NPC","TimeBar"];
		private var _DissolveComponentClasses:Object;
		
		private var _DissolveLayer:int;
		private var _ScheduledNum:Array;
		
		private var _MonsterPanel:MonsterPanel;
		private var _CurrentNumerical:String = PlaySystemStrLab.Sort_LV;
		private var _BuildingLV:uint;
		
		private const _ShopMail:String = "SysCost_DISSOLVE_COST";
		private var _BuildingGuid:String;
		
		private var _CurrentListBoard:int = -1;
		private var _CurrentNum:int = -1;
		
		public function CatchDissolveControl()
		{
			
		}
		
		private function initDissolveCore():void
		{
			
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
				this._DissolveUIProxy = DissolveUIProxy.GetInstance();
				this._facaed.RegisterProxy( this._DissolveUIProxy );
				this._DissolveUIProxy.StartLoad( this._DissolveKey );
				
				var _equClass:MovieClip=(this._SourceProxy.GetMaterialSWP(this._GlobalComponentPackKey,"Property",true)) as MovieClip;
				var _aryProperty:Array = this._SourceProxy.GetMovieClipHandler(_equClass, false, "PropertyImages");
				this._ComponentClasses.PropertyImages = _aryProperty;
				
				trace("素材OK !!");
			}else {
				trace("素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function OninitDissolve():void
		{
			//this._facaed.RemoveProxy( ProxyNameLib.Proxy_DissolveProxy );//移除已不需要的Proxy (_DissolveProxy)
			//this._DissolveProxy = null;
			
			//----------註冊所需的VIEW & PROXY
			this._MonsterDisplayProxy = MonsterDisplayProxy.GetInstance();//怪物顯示快取容器
			this._facaed.RegisterProxy( this._MonsterDisplayProxy );//怪物顯示快取容器
			//TimeLineObject.GetTimeLineObject().CallTestRemoveALL();//測試用刪除排程
			this._ScheduledNum = DissolveProxy(this._facaed.GetProxy(ProxyPVEStrList.DISSOLVE_PROXY)).GetLine();//溶解所判斷 取得排程
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			
			this._DissolveView = new DissolveView( ViewNameLib.View_Dissolve , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._DissolveView );//註冊溶解所ViewCtrl
			
			this._MonsterPanel = new MonsterPanel( ViewNameLib.View_MonsterMenu , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._MonsterPanel );//註冊惡魔選單ViewCtrl
			
			this._DissolveView.BackGroundElement(this._DissolveComponentClasses, this._DissolveUIProxy.GetFireBoiler(), this._ComponentClasses, BuildingProxy.GetInstance().GetBuildLineMax(BuildingProxy.GetInstance().GetBuildingGuid(3)));//溶解所元件
			this._DissolveView.BoilerElement(this._ScheduledNum);
			this._DissolveView.LockBoiler();
			
			if (this._CurrentListBoard != this._ScheduledNum.length - 1) {
				for (var i:int = 0; i < this._ScheduledNum.length; i++) 
				{
					this._CurrentListBoard = i;
					this.AddListBoard(this._CurrentListBoard);
				}
			}
			
			this._BuildingGuid = BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).GetBuildingGuid(3);
			
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddClass(WallExitBtn);
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddSingleSource("WallExitBtn" , this._ComponentClasses);
			
		}
		
		private function TerminateThis():void {
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Dissolve );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_DissolveProxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_MonsterDisplayProxy );
			
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_MonsterMenu );
			this._MonsterPanel = null;
			
			this._DissolveView = null;
			this._DissolveUIProxy = null;
			this._MonsterDisplayProxy = null;
			
			this.SendNotify( DissolveStrLib.Terminate_Dissolve );
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				case DissolveStrLib.Init_Dissolve:
				   this.initDissolveCore();
				break;
				case this._DissolveKey :
						trace( "溶解所回來了" );
						this._DissolveComponentClasses = _obj.GetClass();
						this.OninitDissolve();
					break;
				case DissolveStrLib.MonsterMenu :
						//trace( " I Got " , _Signal  );
						//trace("-----",DissolveProxy(this._facaed.GetProxy(ProxyPVEStrList.DISSOLVE_PROXY)).CheckLineIllegal());
						if (DissolveProxy(this._facaed.GetProxy(ProxyPVEStrList.DISSOLVE_PROXY)).CheckLineIllegal() == true) {
							this._BuildingLV = BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).GetBuildLV(String(BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).GetBuildingGuid(3)));
							this._DissolveView.MonsterMenuElement( this._MonsterDisplayProxy.GetMonsterDisplayList(), this._BuildingLV);//提供怪物(顯示快取)清單給View作SHOW出動作
							//this._DissolveView.DissolveMonsterMenu(this._DissolveUIProxy.GetFireBigBoiler(), this._DissolveUIProxy.GetNPC());//大火焰鍋爐,NPC
						}
					break;
				case DissolveStrLib.GetMonsterHead :
						//trace( " I Got " , _Signal , _obj.GetClass()._guid );
						DissolveProxy(this._facaed.GetProxy(ProxyPVEStrList.DISSOLVE_PROXY)).DissolveMonster(String( _obj.GetClass()._guid ));//溶解惡魔guid
						this._DissolveView.GetMonsterHead( this._MonsterDisplayProxy.GetMonsterDisplayClone( String( _obj.GetClass()._guid ) ) );//取得點擊的惡魔頭像
					break;
				case DissolveStrLib.DissolveLayer :
						//trace( " I Got " , _Signal , _obj.GetClass().Layer );
						this._DissolveLayer= _obj.GetClass().Layer;
						MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddVaule(this._DissolveLayer);
					break;
				case DissolveStrLib.ShowTip :
						//trace( _obj.GetClass().Tip, ProxyPVEStrList.TIP_SCHER, "++++++++++++++++++++++++++++++++");
						var _starTime:uint = ServerTimework.GetInstance().ServerTime;
						//trace(_obj.GetClass().finishTime);
						var _SendTips:SendTips = new SendTips(
						"Dissolve", 
						ProxyPVEStrList.TIP_SCHER, 
						_obj.GetClass().Tip._picItem,
						_obj.GetClass().Tip, 
						_starTime,
						_obj.GetClass().finishTime,
						_obj.GetClass().needTime,
						3
						);
						//this._DissolveView.AddTip(TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_SCHER, _SendTips),_obj.GetClass().BoilerName);
						//TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(true);
					break;
				case DissolveStrLib.RemoveTip :
					//TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false);
					break;
				case ProxyPVEStrList.TIMELINE_SCHID_COMPLETE :
					//_obj.GetClass()._build = 3;
					if (_obj.GetClass()._build == 3) { //_obj.GetClass()._build == 3 
						this._ScheduledNum = DissolveProxy(this._facaed.GetProxy(ProxyPVEStrList.DISSOLVE_PROXY)).GetLine();//溶解所判斷 取得排程
						this._DissolveView.RemoveListBoard(this._ScheduledNum.length, this._CurrentNum);
						this._CurrentListBoard = this._ScheduledNum.length - 1;
						this._CurrentNum = -1;
						if (this._DissolveLayer == 1) {
							this._DissolveView.RemoveBoiler();
							this._DissolveView.BoilerElement(this._ScheduledNum);
						}
						//TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false);
					}
					break;
				case DissolveStrLib.RemoveALL :
						//trace( " I Got " , _Signal );
						if (this._DissolveLayer == 1) {
							this.TerminateThis();
							this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
						}else if (this._DissolveLayer == 2) {
							this._DissolveView.RemoveBoiler();
							this._MonsterPanel.onRemoved();
							this._ScheduledNum = DissolveProxy(this._facaed.GetProxy(ProxyPVEStrList.DISSOLVE_PROXY)).GetLine();//溶解所判斷 取得排程
							this._DissolveView.BoilerElement(this._ScheduledNum);
							if (this._CurrentListBoard != this._ScheduledNum.length - 1) {
								this._CurrentListBoard = this._ScheduledNum.length - 1;
								this.AddListBoard(this._CurrentListBoard);
							}
						}
					break;
				case UICmdStrLib.RecoverBtn :
					this._MonsterPanel.RecoverBtn();
				break;
				case UICmdStrLib.AddMonsterMenu :
					this._MonsterPanel.AddElement("Dissolve", _obj.GetClass().Monster, _obj.GetClass().BGObj);
					this._MonsterPanel.GetBuildingLV(_obj.GetClass().BuildingLV);
					this._MonsterPanel.AssemblyPanel(293, 127, 750, 510, 400, "熔解大殿", 240);
				break;
				case MonsterCageStrLib.SortNumerical :
					if (this._CurrentNumerical != String( _obj.GetClass()._sort)) { 
						this._MonsterPanel.UpdateMonster(this._MonsterDisplayProxy.GetMonsterDisplayList( String( _obj.GetClass()._sort ), _obj.GetClass().CtrlNum), String( _obj.GetClass()._sort ));
						this._CurrentNumerical = String( _obj.GetClass()._sort);
					}
				break;
				case MonsterCageStrLib.MonsterInformation :
					var _CurrentMonster:Sprite = Sprite( _obj.GetClass().Monster );
					var _MonsterData:MonsterDisplay = this._MonsterDisplayProxy.GetMonsterDisplayClone( String(_CurrentMonster.name));
					this._DissolveView.JudgeDissolve(DissolveProxy(this._facaed.GetProxy(ProxyPVEStrList.DISSOLVE_PROXY)).CheckDissolve(String(_CurrentMonster.name), int(_MonsterData.MonsterData._dissoLv)), _CurrentMonster);
				break;
				case UICmdStrLib.ShopMaill :
					this._DissolveView.AddInform();
					var _TimeLine:Object = this._ScheduledNum[int(_obj.GetClass().Name)];
					/*
					var _setting:Object = { 
						_tagretID:_TimeLine._target, 
						_type:1,
						_valType:"hp"(如果是生命值需要改變的話)or"fatigue"(疲勞值需要改變)
						//_build:3,
					    //_schID:_TimeLine._schID,
						//_mission:ProxyPVEStrList.MISSION_Cal_MONSTER_TRAN
					};
					*/
					var _setting:Object = { 
						_tagretID:_TimeLine._target, 
						_type:0, 
						_build:3,
					    _schID:_TimeLine._schID,
						_mission:ProxyPVEStrList.MISSION_Cal_MONSTER_TRAN
					};
					/*
					 * var _setPay:Object = { 
					  _key:帳單金額,
					 _value:如果是生命值改變~就帶入(生命值最大減去當前的值)~如果是疲勞度改變~就給現在的疲勞度
					 
					 };
					 * 
					 * SysCost_FATIGUE_COST		怪物疲勞值回復1元幾滴
					 * SysCost_LIFE_COST	怪物生命回復1元幾滴
					 * 
					 * 完成消費就聽[ProxyMonsterStr.MONSTER_CHANGE]
					 * 回傳的obj他的行別是[ReturnMonster] 裡面的_type>>是(2.HP改變3.ENG改變)
					 * type==2>取ReturnMonster._HP;
					 * type==3>取ReturnMonster._ENG;
					 * 
					 * 
					*/
					var _setPay:Object = { _key:_ShopMail, _build:this._BuildingGuid, _target:_TimeLine._schID };
					var _boolean:Boolean = ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).CheckPay("PayDynamicFactory", _setting, _setPay);
					var _Price:uint = ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).GetPayTotal();
					this._DissolveView.GetPay(_Price, int(_obj.GetClass().Name));
				break;
				case UICmdStrLib.Consumption :
					this._CurrentNum = int(_obj.GetClass()._Num);
					ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).Pay();
				break;
				
				case ProxyPVEStrList.TIP_CLOSESYS :
					this.TerminateThis();
				break;
			}
		}
		
		private function AddListBoard(_ListBoardNum:int):void 
		{
			this._MonsterDisplayProxy.GetMonsterDisplayList();
			var _CurrentObj:Object = this._ScheduledNum[_ListBoardNum];
			var _starTime:uint = ServerTimework.GetInstance().ServerTime;
			
			var _SendTips:SendTips;
				_SendTips = new SendTips(
				"Dissolve", 
				ProxyPVEStrList.TIP_TIMERBAR,
				_starTime,
				_CurrentObj._finishTime,
				_CurrentObj._needTime,
				3,
				110,
				100
				);
			this._DissolveView.AddListBoard(_ListBoardNum, this._MonsterDisplayProxy.GetMonsterDisplay(_CurrentObj._target), TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_TIMERBAR, _SendTips));
		}
		
		override public function GetListRegisterCommands():Array {
			return [ DissolveStrLib.Init_Dissolve,
					this._DissolveKey,
					DissolveStrLib.MonsterMenu,//進入溶解所第二層惡魔選單
					DissolveStrLib.GetMonsterHead,//取得點擊的惡魔頭像
					DissolveStrLib.DissolveLayer,//溶解所樓層
					DissolveStrLib.RemoveALL,
					DissolveStrLib.ShowTip,
					DissolveStrLib.RemoveTip,
					//ProxyPVEStrList.TIMELINE_COMPLETE,
					UICmdStrLib.AddMonsterMenu,
					MonsterCageStrLib.SortNumerical,
					MonsterCageStrLib.MonsterInformation,
					UICmdStrLib.RecoverBtn,
					UICmdStrLib.ShopMaill,
					UICmdStrLib.Consumption,
					ProxyPVEStrList.TIMELINE_SCHID_COMPLETE,
					ProxyPVEStrList.TIP_CLOSESYS
					];
		}
	}//end class
}//end package