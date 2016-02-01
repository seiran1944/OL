package MVCprojectOL.ControllOL.BuildingUpgradeCtrl 
{
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.ShopMall.ShopMallProxy;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	import MVCprojectOL.ModelOL.Vo.Building;
	import MVCprojectOL.ViewOL.BuildingUpgradeView.BuildingUpViewCtrl;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.BuildingStr;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewNameLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchBuildingUpgradeContril  extends CatchCommands 
	{
		private var _SourceProxy:SourceProxy;
		private var _BuildingUpViewCtrl:BuildingUpViewCtrl;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClassList:Vector.<String> = new < String >  [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn", "pageBtnN", "exitBtn", "TipBtn", "TipBox", "olBoard", 
		"Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg", "DetailBoard", "SkilletBg", "Inform", "MakeBtn", "Fatigue", "Hourglass", "CheckBtn", "BgD", "ReportBg", "EdgeBg", "ContentBg", "BgL", "Wood", "Ore", "Fur", "Diamond",
		"DemonAvatar","Paper"];
		private var _GlobalClasses:Object;
		
		private var _BuildingKey:String = "GUI00001_ANI";
		private var _BuildingClassList:Vector.<String> = new < String > ["Main_1", "Main_2", "Main_3", "Main_4", "Main_5", "Main_6", "Main_7","Main_8","Main_9"];
		private var _BuildingClasses:Object;
		private var _GetLineAry:Array;
		private const _ShopMail:String = "SysCost_BULID_COST";
		
		private function initBuildingUpCore():void
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._GlobalClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClassList );
				trace("公用素材OK !!");
				this.StartBuildingUp();
			}else {
				//若公用素材還沒有準備好 代表主程序未初始完畢  則發出終結指令終結這個command
				trace("公用素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function TerminateThis():void 
		{
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_BuildingUp );
			
			this._SourceProxy = null;
			this._GlobalClasses = null;
			this._BuildingUpViewCtrl = null;
			
			this.SendNotify( UICmdStrLib.Terminate_BuildingUp );
		}
		
		private function StartBuildingUp():void
		{
			this._BuildingClasses= this._SourceProxy.GetMaterialSWP( this._BuildingKey , this._BuildingClassList );
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._BuildingUpViewCtrl = new BuildingUpViewCtrl ( ViewNameLib.View_BuildingUp , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._BuildingUpViewCtrl );//註冊溶解所ViewCtrl
			
			this._BuildingUpViewCtrl.AddElement(this._GlobalClasses, this._BuildingClasses);
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) {
				case UICmdStrLib.Init_BuildingUpCatch:
				    this.initBuildingUpCore();
				break;
				case UICmdStrLib.BuildingData:
					this._BuildingUpViewCtrl.GetBuildingData(BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).GetAllWithUpgrade());
				break;
				case UICmdStrLib.CtrlPage:
					this._BuildingUpViewCtrl.CtrlPage(_obj.GetClass().CtrlPageNum, _obj.GetClass().CtrlBoolean);
				break;
				case UICmdStrLib.CheckUpgradable:
					var _Num:int = BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).CheckUpgradable( _obj.GetClass().Guid, true);
					this._BuildingUpViewCtrl.CheckGetTimeLine();
					this._BuildingUpViewCtrl.RecordCheck(_Num, _obj.GetClass().Guid);
					this._BuildingUpViewCtrl.UpDataBuilding(BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).GetAllWithUpgrade());
				break;
				case UICmdStrLib.GetTimeLine:
					this._GetLineAry = TimeLineProxy(this._facaed.GetProxy(ProxyPVEStrList.TIMELINE_PROXY)).GetAllLine("buildingTimeline");
					this._BuildingUpViewCtrl.AddTimeLine(this._GetLineAry);
				break;
				case UICmdStrLib.SetTimeBar:
					var _starTime:uint = ServerTimework.GetInstance().ServerTime;
					var _SendTips:SendTips;
						_SendTips = new SendTips(
						"Building", 
						ProxyPVEStrList.TIP_TIMERBAR,
						_starTime,
						_obj.GetClass()._finishTime,
						_obj.GetClass()._needTime,
						_obj.GetClass()._buildType,
						110,
						100
						);
					this._BuildingUpViewCtrl.AddTimeBar(TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_TIMERBAR, _SendTips), _obj.GetClass()._target, _obj.GetClass()._buildType);
				break;
				case BuildingStr.BUILDING_FIN_UPGRADE:
					var _NewBuildingData:Building = _obj.GetClass() as Building;
					this._BuildingUpViewCtrl.UpData(_NewBuildingData, BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).CheckUpgradable( _NewBuildingData._guid, false));
				break;
				case UICmdStrLib.RemoveALL:
					this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
					this.TerminateThis();
				break;
				case UICmdStrLib.ShopMaill :
					this._BuildingUpViewCtrl.AddInform();
					var _TimeLine:Object;
					for (var i:int = 0; i < this._GetLineAry.length; i++) 
					{
						if (this._GetLineAry[i]._buildType == int(_obj.GetClass().Name)) _TimeLine = this._GetLineAry[i];
					}
					var _setting:Object = { 
					_tagretID:"",
					_type:0,
					_build:0,
					_schID:_TimeLine._schID,
					_mission:ProxyPVEStrList.MISSION_Cal_MISBUILD
					};
					var _setPay:Object = { _key:_ShopMail, _build:"buildingTimeline", _target:_TimeLine._schID };
					var _boolean:Boolean = ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).CheckPay("PayDynamicFactory", _setting, _setPay);
					var _Price:uint = ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).GetPayTotal();
					this._BuildingUpViewCtrl.GetPay(_Price);
				break;
				case UICmdStrLib.Consumption :
					ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).Pay();
				break;
				case ProxyPVEStrList.TIMELINE_SCHIDReady :
					this._GetLineAry = TimeLineProxy(this._facaed.GetProxy(ProxyPVEStrList.TIMELINE_PROXY)).GetAllLine("buildingTimeline");
				break;
				case ProxyPVEStrList.TIP_CLOSESYS :
					this.TerminateThis();
				break;
			}
		}
		
		override public function GetListRegisterCommands():Array {
			return [ UICmdStrLib.Init_BuildingUpCatch,
					UICmdStrLib.BuildingData,
					UICmdStrLib.CtrlPage,
					UICmdStrLib.RemoveALL,
					UICmdStrLib.CheckUpgradable,
					UICmdStrLib.GetTimeLine,
					BuildingStr.BUILDING_FIN_UPGRADE,
					UICmdStrLib.SetTimeBar,
					UICmdStrLib.ShopMaill,
					UICmdStrLib.Consumption,
					ProxyPVEStrList.TIMELINE_SCHIDReady,
					ProxyPVEStrList.TIP_CLOSESYS
					];
		}
		
	}
}