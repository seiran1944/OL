package MVCprojectOL.ControllOL.AlchemyCtrl 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Alchemy.AlchemyProxy;
	import MVCprojectOL.ModelOL.AlchemyModel.AlchemyUIproxy;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplayProxyAll;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.ShopMall.ShopMallProxy;
	import strLib.commandStr.ViewSystem_BuildCommands;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	//import MVCprojectOL.ModelOL.ShowSideSys.ShowTipsInfoProxy;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	import MVCprojectOL.ViewOL.AlchemyView.AlchemyViewCtrl;
	import MVCprojectOL.ViewOL.AlchemyView.AlchemyWallExitBtn;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
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
	public class CatchAlchemyControl extends CatchCommands
	{
		private var _SourceProxy:SourceProxy;
		private var _AlchemyViewCtrl:AlchemyViewCtrl;
		private var _AlchemyUIproxy:AlchemyUIproxy;
		private var _ItemDisplayProxyAll:ItemDisplayProxyAll;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String > [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn", "pageBtnN", "exitBtn", "TipBtn", "TipBox", "olBoard", 
		"Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg", "DetailBoard", "SkilletBg", "Inform", "MakeBtn", "Fatigue", "Hourglass", "CheckBtn", "BgD", "ReportBg", "EdgeBg", "ContentBg", "Diamond",
		"DemonAvatar", "Paper", "Lock", "TableBg", "EvolutionBg"];
		private var _ComponentClasses:Object;
		
		private const _AlchemyKey:String = "GUI00008_ANI";//煉金所 素材包KEY碼
		private const _AlchemyClasses:Vector.<String> = new < String >[ "bg4" , "TabS" , "TabM" , "ListBoard", "Bins","Weapon","Armor","Accessories","Drug","MakeBtn","Bottle","BoneFire","Cabinet","NPC","DialogBox","BottleS","Workbench","Material"];
		private var _AlchemyComponentClasses:Object;
		
		private var _AlchemyLayer:int;
		private var _GetLineAry:Array;
		
		private const _ShopMail:String = "SysCost_DISSOLVE_COST";
		private var _BuildingGuid:String;
		
		private var _CurrentListBoard:int = -1;
		private var _CurrentNum:int = -1;
		private var _ItemDisplayAll:Object = { };
		
		public function CatchAlchemyControl() 
		{
			
		}
		
		private function initAlchemyCore():void
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
				this._AlchemyUIproxy = AlchemyUIproxy.GetInstance();
				this._facaed.RegisterProxy( this._AlchemyUIproxy );
				this._AlchemyUIproxy.StartLoad( this._AlchemyKey );
				
				var _equClass:MovieClip=(this._SourceProxy.GetMaterialSWP(this._GlobalComponentPackKey,"Property",true)) as MovieClip;
				var _aryProperty:Array = this._SourceProxy.GetMovieClipHandler(_equClass, false, "PropertyImages");
				this._ComponentClasses.PropertyImages = _aryProperty;
				
				trace("素材OK !!");
			}else {
				trace("素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function OnAlchemy():void
		{
			
			if (AlchemyProxy(this._facaed.GetProxy(ProxyPVEStrList.ALCHEMY_PROXY)).CheckAlchemyList()==true) { 
				//this.GetItemDisplay();
			this._ItemDisplayProxyAll = ItemDisplayProxyAll.GetInstance();//Item顯示快取容器
			this._facaed.RegisterProxy( this._ItemDisplayProxyAll );//Item顯示快取容器
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._AlchemyViewCtrl = new AlchemyViewCtrl ( ViewNameLib.View_Alchemy , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._AlchemyViewCtrl );//註冊溶解所ViewCtrl
			
			this._GetLineAry = AlchemyProxy(this._facaed.GetProxy(ProxyPVEStrList.ALCHEMY_PROXY)).GetLine();
			
			this._AlchemyViewCtrl.BackGroundElement(this._AlchemyComponentClasses, this._ComponentClasses, this._AlchemyUIproxy.GetBoneFire(), BuildingProxy.GetInstance().GetBuildLineMax(BuildingProxy.GetInstance().GetBuildingGuid(6)));
			this._AlchemyViewCtrl.OneLayer(this._GetLineAry );
			this._AlchemyViewCtrl.LockBoiler();
			
			this.GetItemDisplay();
			
			if (this._CurrentListBoard != this._GetLineAry.length - 1) {
				for (var i:int = 0; i < this._GetLineAry.length; i++) 
				{
					this._CurrentListBoard = i;
					this.AddListBoard(this._CurrentListBoard);
				}
			}
			
			this._BuildingGuid = BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).GetBuildingGuid(6);
				
				
				} else {
			AlchemyProxy(this._facaed.GetProxy(ProxyPVEStrList.ALCHEMY_PROXY)).GetNewRecipeList();	
			return;
			}
			
			
			
			
			
		
			//var test:Dictionary = AlchemyProxy(this._facaed.GetProxy(ProxyPVEStrList.ALCHEMY_PROXY)).GetRecipeList();
			//trace(test["wep"],"=============================================");
			
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddClass(AlchemyWallExitBtn);
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddSingleSource("AlchemyWallExitBtn" , this._ComponentClasses);
		}
		
		private function TerminateThis():void {
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Alchemy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_AlchemyUIproxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_ItemDisplayProxyAll );
			
			this._AlchemyViewCtrl = null;
			this._AlchemyUIproxy = null;
			this._ItemDisplayProxyAll = null;
			
			this.SendNotify( UICmdStrLib.Terminate_Alchemy );
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				case UICmdStrLib.Init_AlchemyCatch:
				   this.initAlchemyCore();
				break;
				case this._AlchemyKey :
					trace( "煉金所回來了" );
					this._AlchemyComponentClasses = _obj.GetClass();
					
					this.OnAlchemy();
				break;
				
				//---2013/06/12-erichuang----
			    case ProxyPVEStrList.ALCHEMY_RecipeReady:
				//this.GetItemDisplay();
				this.OnAlchemy();
				break;
				
				
				case UICmdStrLib.AlchemyLayer :
					this._AlchemyLayer = _obj.GetClass().Layer;
					MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddVaule(this._AlchemyLayer);
				break;
				//------
				case UICmdStrLib.CurrentTab :
					//var _ItemDisplay:Vector.<ItemDisplay> = this._ItemDisplayAll[String(_obj.GetClass().TabName)];
					this._AlchemyViewCtrl.ListBoard(this._ItemDisplayAll[String(_obj.GetClass().TabName)]);
				break;
				case UICmdStrLib.ListBoardKey :
					//trace(_obj.GetClass().guid, "<================================");
					var _Obj:Object = AlchemyProxy(this._facaed.GetProxy(ProxyPVEStrList.ALCHEMY_PROXY)).GetCheckRecipe(String(_obj.GetClass().guid));
					var _CurrentSourceItemDisplay:Vector.<ItemDisplay> = this._ItemDisplayProxyAll.GetRecipeRequireContentDisplay(String(_obj.GetClass().guid));
					var _CurrentItemDisplay:ItemDisplay = this._ItemDisplayProxyAll.GetItemDisplay(String(_obj.GetClass().guid));
					this._AlchemyViewCtrl.NeedSourceList(_Obj, _CurrentSourceItemDisplay,_CurrentItemDisplay);
				break;
				case UICmdStrLib.CurrentAlchemy :
					AlchemyProxy(this._facaed.GetProxy(ProxyPVEStrList.ALCHEMY_PROXY)).StarForging(String(_obj.GetClass().guid));
					this._GetLineAry = AlchemyProxy(this._facaed.GetProxy(ProxyPVEStrList.ALCHEMY_PROXY)).GetLine();
					this._AlchemyViewCtrl.OneLayer(this._GetLineAry);
					if (this._CurrentListBoard != this._GetLineAry.length - 1) {
						this._CurrentListBoard = this._GetLineAry.length - 1;
						this.AddListBoard(this._CurrentListBoard);
					}
				break;
				case UICmdStrLib.ShowTip :
					var _starTime:uint = ServerTimework.GetInstance().ServerTime;
					var _SendTips:SendTips = new SendTips(
						"Alchemy", 
						ProxyPVEStrList.TIP_SCHER, 
						_obj.GetClass().Tip._picItem,
			            _obj.GetClass().Tip,
						_starTime,
						_obj.GetClass().finishTime,
						_obj.GetClass().needTime,
						6
						);
					//this._AlchemyViewCtrl.AddTip(TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_SCHER, _SendTips),_obj.GetClass().BoilerName);
					//TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(true);
				break;
				case UICmdStrLib.RemoveTip :
					//TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false);
				break;
				case ProxyPVEStrList.TIMELINE_SCHID_COMPLETE :
					if (_obj.GetClass()._build == 6) { //_obj.GetClass()._build == 6
						this._GetLineAry = AlchemyProxy(this._facaed.GetProxy(ProxyPVEStrList.ALCHEMY_PROXY)).GetLine();
						this._AlchemyViewCtrl.RemoveListBoard(this._GetLineAry.length, this._CurrentNum);
						this._CurrentListBoard = this._GetLineAry.length - 1;
						this._CurrentNum = -1;
						if (this._AlchemyLayer == 1) { 
							this._AlchemyViewCtrl.RemoveBoiler();
							this._AlchemyViewCtrl.OneLayer(this._GetLineAry);
						}
						//TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false);
					}
				break;
				case UICmdStrLib.RemoveALL :
					if (this._AlchemyLayer == 1) {
						this.TerminateThis();
						this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
					}else if (this._AlchemyLayer == 2) {
						this._GetLineAry = AlchemyProxy(this._facaed.GetProxy(ProxyPVEStrList.ALCHEMY_PROXY)).GetLine();
						this._AlchemyViewCtrl.OneLayer(this._GetLineAry);
						this._AlchemyViewCtrl.RemovePanel();
					}else if (this._AlchemyLayer == 3) {
						
					}
				break;
				
				case UICmdStrLib.ShopMaill :
					this._AlchemyViewCtrl.AddInform();
					var _TimeLine:Object = this._GetLineAry[int(_obj.GetClass().Name)];
					var _setting:Object = { 
						_tagretID:_TimeLine._target,
						_type:0, 
						_build:6,
					    _schID:_TimeLine._schID,
						_mission:ProxyPVEStrList.MISSION_Cal_MTL_MAKE	
					};
					var _setPay:Object = { _key:_ShopMail, _build:this._BuildingGuid, _target:_TimeLine._schID };
					var _boolean:Boolean = ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).CheckPay("PayDynamicFactory", _setting, _setPay);
					var _Price:uint = ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).GetPayTotal();
					this._AlchemyViewCtrl.GetPay(_Price, int(_obj.GetClass().Name));
				break;
				case UICmdStrLib.Consumption :
					this._CurrentNum = int(_obj.GetClass()._Num);
					ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).Pay();
				break;
				case ProxyPVEStrList.TIMELINE_SCHIDReady :
					this._GetLineAry = AlchemyProxy(this._facaed.GetProxy(ProxyPVEStrList.ALCHEMY_PROXY)).GetLine();
				break;
				
				case ProxyPVEStrList.TIP_CLOSESYS :
					this.TerminateThis();
				break;
			}
		}
		
		private function AddListBoard(_ListBoardNum:int):void 
		{
			var _CurrentObj:Object = this._GetLineAry[_ListBoardNum];
			var _starTime:uint = ServerTimework.GetInstance().ServerTime;
			
			var _SendTips:SendTips;
				_SendTips = new SendTips(
				"Library", 
				ProxyPVEStrList.TIP_TIMERBAR,
				_starTime,
				_CurrentObj._finishTime,
				_CurrentObj._needTime,
				4,
				110,
				100
				);
			this._AlchemyViewCtrl.AddListBoard(_ListBoardNum, this._ItemDisplayProxyAll.GetItemDisplayClone(_CurrentObj._target), TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_TIMERBAR, _SendTips));
		}
		
		private function GetItemDisplay():void 
		{
			var _Str:Vector.<String> = new < String > ["wep", "Shield", "Accessories", "Basic"];
			var _StrLength:int = _Str.length;
			for (var i:int = 0; i < _StrLength; i++) 
			{
				this._ItemDisplayAll[_Str[i]] = this._ItemDisplayProxyAll.GetItemDisplayList(_Str[i]);
			}
		}
		
		override public function GetListRegisterCommands():Array {
			return [ UICmdStrLib.Init_AlchemyCatch,
					this._AlchemyKey,
					UICmdStrLib.CurrentTab,
					UICmdStrLib.AlchemyLayer,
					UICmdStrLib.RemoveALL,
					UICmdStrLib.ListBoardKey,
					UICmdStrLib.CurrentAlchemy,
					UICmdStrLib.ShowTip,
					UICmdStrLib.RemoveTip,
					UICmdStrLib.ShopMaill,
					UICmdStrLib.Consumption,
					ProxyPVEStrList.TIMELINE_SCHIDReady,
					ProxyPVEStrList.TIMELINE_SCHID_COMPLETE,
					ProxyPVEStrList.ALCHEMY_RecipeReady,
					ProxyPVEStrList.TIP_CLOSESYS
					];
		}
		
	}
}