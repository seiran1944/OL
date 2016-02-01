package MVCprojectOL.ControllOL.StorageUI 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplayProxy;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.PackageSys.PackageProxy;
	import strLib.commandStr.ViewSystem_BuildCommands;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	//import MVCprojectOL.ModelOL.ShowSideSys.ShowTipsInfoProxy;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplayProxy;
	import MVCprojectOL.ModelOL.StorageUI.StorageUIProxy;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	import MVCprojectOL.ViewOL.MonsterView.MonsterPanel;
	import MVCprojectOL.ViewOL.MonsterView.MoonsterViewCtrl;
	import MVCprojectOL.ViewOL.StorageView.StorageViewCtrl;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.commandStr.UICmdStrLib;
	import strLib.proxyStr.BuildingStr;
	import strLib.proxyStr.ProxyMonsterStr;
	import strLib.proxyStr.ProxyNameLib;
	
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.StorageStrLib;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewNameLib;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchStorageControl extends CatchCommands
	{
		private var _SourceProxy:SourceProxy;
		private var _StorageUIProxy:StorageUIProxy;
		private var _ItemDisplayProxy:ItemDisplayProxy;
		private var _MonsterDisplayProxy:MonsterDisplayProxy;
		
		private var _StorageViewCtrl:StorageViewCtrl;//新介面
		private var _MoonsterViewCtrl:MoonsterViewCtrl;
		private var _MonsterPanel:MonsterPanel;
		private var _SkillDisplayProxy:SkillDisplayProxy;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String > [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn", "pageBtnN", "exitBtn", "TipBtn", "TipBox", "olBoard", 
		"Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg", "DetailBoard", "SkilletBg", "Inform", "MakeBtn", "Fatigue", "Hourglass", "CheckBtn", "BgD", "ReportBg", "EdgeBg", "ContentBg","Job","Diamond"];
		private var _ComponentClasses:Object;
		
		private const _StorageKey:String = "GUI00007_ANI";//儲藏室 素材包KEY碼
		private const _StorageClasses:Vector.<String> = new < String > [ "NPC" , "TabS" , "TabM" , "IconBox", "DialogBox","Bins","Box1","Box2","bg3","Magic","Weapon","Armor","Accessories","Drug","Material","Inform","MakeBtn"];
		private var _StorageComponentClasses:Object;
		
		private var _StorageLayer:int = 1;
		private var _CurrentNumerical:String = PlaySystemStrLab.Sort_LV;
		private var _CurrentTabM:int;
		private var _NewGuid:String;
		
		public function CatchStorageControl() 
		{
			
		}
		
		private function initStorageCore():void
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
				this._StorageUIProxy = StorageUIProxy.GetInstance();
				this._facaed.RegisterProxy( this._StorageUIProxy );
				this._StorageUIProxy.StartLoad( this._StorageKey );
				
				var _equClass:MovieClip=(this._SourceProxy.GetMaterialSWP(this._GlobalComponentPackKey,"Property",true)) as MovieClip;
				var _aryProperty:Array = this._SourceProxy.GetMovieClipHandler(_equClass, false, "PropertyImages");
				this._ComponentClasses.PropertyImages = _aryProperty;
				
				trace("素材OK !!");
			}else {
				trace("素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function OnStorage():void
		{
			this._ItemDisplayProxy = ItemDisplayProxy.GetInstance();//Item顯示快取容器
			this._facaed.RegisterProxy( this._ItemDisplayProxy );//Item顯示快取容器
			
			this._SkillDisplayProxy = SkillDisplayProxy.GetInstance();
			this._facaed.RegisterProxy( this._SkillDisplayProxy );
			
			this._MonsterDisplayProxy = MonsterDisplayProxy.GetInstance();//怪物顯示快取容器
			this._facaed.RegisterProxy( this._MonsterDisplayProxy );//怪物顯示快取容器
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			
			//新介面
			this._StorageViewCtrl = new StorageViewCtrl( ViewNameLib.View_Storage , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._StorageViewCtrl );//註冊溶解所ViewCtrl
			var _BuildingLV:int = BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).GetBuildLV(BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).GetBuildingGuid(5));
			this._StorageViewCtrl.AddElement(this._ComponentClasses, this._StorageComponentClasses, _BuildingLV, this._NewGuid);
			
			this._MoonsterViewCtrl = new MoonsterViewCtrl( ViewNameLib.View_MonsterCage , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._MoonsterViewCtrl );//註冊ViewCtrl
			this._MoonsterViewCtrl.AddElement(this._ComponentClasses);
			
			this._MonsterPanel = new MonsterPanel( ViewNameLib.View_MonsterMenu , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._MonsterPanel );//註冊惡魔選單ViewCtrl
			
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddClass(WallExitBtn);
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddSingleSource("WallExitBtn" , this._ComponentClasses);
		}
		
		private function TerminateThis():void {
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Storage );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_StorageUIProxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_ItemDisplayProxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_MonsterDisplayProxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_SkillDisplayProxy );
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_MonsterMenu );
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_MonsterCage );
			
			this._MoonsterViewCtrl = null;
			this._MonsterPanel = null;
			this._StorageViewCtrl = null;
			this._StorageUIProxy = null;
			this._ItemDisplayProxy = null;
			this._MonsterDisplayProxy = null;
			this._SkillDisplayProxy = null;
			
			this.SendNotify( StorageStrLib.Terminate_Storage );
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				case StorageStrLib.Init_Storage:
					(_obj.GetClass() == null)?this._NewGuid = "":this._NewGuid = String(_obj.GetClass());
				   this.initStorageCore();
				break;
				case this._StorageKey :
					trace( "儲藏室回來了" );
					this._StorageComponentClasses = _obj.GetClass();
					this.OnStorage();
				break;
				case StorageStrLib.StorageLayer :
					this._StorageLayer = _obj.GetClass().Layer;
					MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddVaule(this._StorageLayer);
				break;
				case StorageStrLib.GetMonsterMenu :
					this._StorageViewCtrl.GetMonsterMenu(this._MonsterDisplayProxy.GetMonsterDisplayList());
				break;
				case StorageStrLib.SureUse :
					if (_obj.GetClass().CurrentTabM == 0) MonsterProxy(this._facaed.GetProxy(ProxyMonsterStr.MONSTER_PROXY)).EatStoneChange(_obj.GetClass().MonsterName, _obj.GetClass().IconName);
					if (_obj.GetClass().CurrentTabM == 1 || _obj.GetClass().CurrentTabM == 2 || _obj.GetClass().CurrentTabM == 3) MonsterProxy(this._facaed.GetProxy(ProxyMonsterStr.MONSTER_PROXY)).AddEqu(_obj.GetClass().equGroupID, _obj.GetClass().IconName, _obj.GetClass().MonsterName);
					this._StorageViewCtrl.ReBackpack(_obj.GetClass().CurrentTabM);
					TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false,ProxyPVEStrList.TIP_MonsterEqu);
				break;
				case StorageStrLib.Unload :
					//trace(_obj.GetClass().IconName,"@@@@@");
					MonsterProxy(this._facaed.GetProxy(ProxyMonsterStr.MONSTER_PROXY)).RemoveMonsterEquSingle(_obj.GetClass().monsterID, _obj.GetClass().IconName);
					this._StorageViewCtrl.ReBackpack(_obj.GetClass().CurrentTabM);
				break;
				case UICmdStrLib.AddMonsterMenu :
					this._CurrentTabM = _obj.GetClass().CurrentTabM;
					this._MonsterPanel.AddElement("Storage", _obj.GetClass().Monster, _obj.GetClass().BGObj, _obj.GetClass().CurrentTabM, this._ItemDisplayProxy.GetItemDisplay(_obj.GetClass().IconName));
					this._MonsterPanel.StorageData(_obj.GetClass().lvEquipment);
					this._MonsterPanel.AssemblyPanel(240, 127, 960, 510, 400, "惡魔巢穴", 460);
				break;
				case UICmdStrLib.UseMonsterMenu :
					this._StorageViewCtrl.UseHandler( this._MonsterDisplayProxy.GetMonsterDisplay(_obj.GetClass().guid), this._ItemDisplayProxy.GetItemDisplayClone(_obj.GetClass().IconName));
                   // ShowTipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false,ProxyPVEStrList.TIP_MonsterEqu);	
				break;
				case UICmdStrLib.RecoverBtn :
					this._MonsterPanel.RecoverBtn();
				break;
				
				case UICmdStrLib.MonsterTip :
					var _SendTips:SendTips;
					if (_obj.GetClass().CurrentTabM == 1 || _obj.GetClass().CurrentTabM == 2 || _obj.GetClass().CurrentTabM == 3)
					{
						_SendTips = new SendTips(
							"Storage", 
							ProxyPVEStrList.TIP_MonsterEqu, 
							_obj.GetClass().IconName,
							_obj.GetClass().gruopGuid,
							_obj.GetClass().guid,
							_obj.GetClass().showName,
							_obj.GetClass().picItem
							);
						this._StorageViewCtrl.AddTip(TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_MonsterEqu, _SendTips));
						this._MonsterPanel.JudgeClick(TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_MonsterEqu, _SendTips));
						TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(true, ProxyPVEStrList.TIP_MonsterEqu);
					}
					if (_obj.GetClass().CurrentTabM == 0)
					{
						_SendTips = new SendTips(
							"Storage", 
							ProxyPVEStrList.TIP_MonsterEatStone,
							_obj.GetClass().IconName,
							_obj.GetClass().guid,
							_obj.GetClass().showName,
							_obj.GetClass().picItem
							);
						this._StorageViewCtrl.AddTip(TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_MonsterEatStone, _SendTips));	
						this._MonsterPanel.JudgeClick(TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_MonsterEatStone, _SendTips));
						TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(true, ProxyPVEStrList.TIP_MonsterEatStone);
					}
				break;
				case UICmdStrLib.RemoveMonsterTip :
					if (_obj.GetClass().CurrentTabM == 1 || _obj.GetClass().CurrentTabM == 2 || _obj.GetClass().CurrentTabM == 3)TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false,ProxyPVEStrList.TIP_MonsterEqu);
					if (_obj.GetClass().CurrentTabM == 0)TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false,ProxyPVEStrList.TIP_MonsterEatStone);
				break;
				case StorageStrLib.RemoveALL :
					if (this._StorageLayer == 1) {
						this.TerminateThis();
						this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
					}else if (this._StorageLayer == 2) {
						this.TerminateThis();
						this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
					}else if (this._StorageLayer == 3) {
						//this._StorageView.SecondLayer();
					}else if (this._StorageLayer == 4) {
						//this._StorageView.RemoveFourthLayer();
					}
				break;
				case StorageStrLib.CurrentTab :
						var _dic:Array = PackageProxy(this._facaed.GetProxy(ProxyPVEStrList.PACKAGE_PROXY)).GetSingleGoods(String(_obj.GetClass().TabName));
						var _ItemDisplay:Vector.<ItemDisplay> = this._ItemDisplayProxy.GetItemDisplayList(_dic);
						(String(_obj.GetClass().TabName) == PlaySystemStrLab.Package_Source)?this.SourceQuantity(_ItemDisplay, String(_obj.GetClass().TabName)):this._StorageViewCtrl.BackpackElement(_ItemDisplay, _obj.GetClass().TabName);//新介面
				break;
				
				case MonsterCageStrLib.MonsterInformation :
					(String( _obj.GetClass()._guid) == null)?null:this._MoonsterViewCtrl.AssemblyMonsterInformation(this._MonsterDisplayProxy.GetMonsterDisplayClone( String( _obj.GetClass()._guid ) ));
				break;
				case MonsterCageStrLib.Equ :
					//trace(_obj.GetClass().Weapon, "@@@@@");
					if (_obj.GetClass().Weapon != null) var _Weapon:ItemDisplay = this._ItemDisplayProxy.GetItemDisplayExpress(_obj.GetClass().Weapon);
					if (_obj.GetClass().Armor != null) var _Armor:ItemDisplay =this._ItemDisplayProxy.GetItemDisplayExpress(_obj.GetClass().Armor);
					if (_obj.GetClass().Accessories != null) var _Accessories:ItemDisplay = this._ItemDisplayProxy.GetItemDisplayExpress(_obj.GetClass().Accessories);
					
					if (_obj.GetClass().Monster.MonsterData._Skill != null) {
						var _Skill:Vector.<SkillDisplay> = new Vector.<SkillDisplay>; 
						for (var i:String in _obj.GetClass().Monster.MonsterData._Skill) {
							_Skill.push(this._SkillDisplayProxy.GetSkillDisplay(String(_obj.GetClass().Monster.MonsterData._Skill[i])));
						}
					}
					this._MoonsterViewCtrl.AddMonsterInformation(_obj.GetClass().Monster, _Weapon, _Armor, _Accessories, _Skill);
				break;
				case MonsterCageStrLib.SortNumerical :
					if (this._CurrentNumerical != String( _obj.GetClass()._sort)) { 
						this._MonsterPanel.UpdateMonster(this._MonsterDisplayProxy.GetMonsterDisplayList( String( _obj.GetClass()._sort ), _obj.GetClass().CtrlNum), String( _obj.GetClass()._sort ));
						this._CurrentNumerical = String( _obj.GetClass()._sort);
					}
				break;
				case UICmdStrLib.onRemoveALL :
					TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false, ProxyPVEStrList.TIP_MonsterEqu);	
					this._StorageViewCtrl.ReBackpack(this._CurrentTabM);
				break;
				case ProxyPVEStrList.TIP_CLOSESYS :
					if (int(_obj.GetClass()) != 3 && int(_obj.GetClass()) != 6) { 
						this.TerminateThis();
					}
				break;
				case UICmdStrLib.NewData :
					this.ChangeTab(String(_obj.GetClass()));
				break;
			}
		}
		//判斷素材數量
		private function SourceQuantity(_ItemDisplay:Vector.<ItemDisplay>, _TabName:String):void 
		{
			var _ItemDisplayLlength:int = _ItemDisplay.length;
			var _CurrentItem:ItemDisplay;
			var _CurrentNum:int;
			var _CloneItemDisplay:ItemDisplay;
			for (var i:int = 0; i < _ItemDisplayLlength; i++) 
			{
				_CurrentItem = _ItemDisplay[i];
				if (_CurrentItem.ItemData._number > _CurrentItem.ItemData._stackMax) {
					_CurrentNum = _CurrentItem.ItemData._number / _CurrentItem.ItemData._stackMax;
					for (var j:int = 1; j < _CurrentNum + 1; j++) 
					{
						_CloneItemDisplay = this._ItemDisplayProxy.GetItemDisplayFullyClone(_CurrentItem.ItemData._guid);
						_CloneItemDisplay.ItemData._number = _CurrentItem.ItemData._number - j * _CurrentItem.ItemData._stackMax;
						if (_CloneItemDisplay.ItemData._number > _CurrentItem.ItemData._stackMax) _CloneItemDisplay.ItemData._number = _CurrentItem.ItemData._stackMax;
						_ItemDisplay.push(_CloneItemDisplay);
					}
					_CurrentItem.ItemData._number = _CurrentItem.ItemData._stackMax;
				}
			}
			this._StorageViewCtrl.BackpackElement(_ItemDisplay, _TabName);
		}
		
		private function ChangeTab(_ChangeValue:String):void 
		{
			var _CurrentTab:int;
			var _Str:String = _ChangeValue.substr(0, 3);
			if ( _Str == "MSC") _CurrentTab = 0;
			if (_Str == "WPN") _CurrentTab = 1;
			if (_Str == "AMR") _CurrentTab = 2;
			if (_Str == "ACY") _CurrentTab = 3;
			if (_Str == "MTL") _CurrentTab = 4;
			this._StorageViewCtrl.ChangeTab(_CurrentTab, _ChangeValue);
		}
		
		override public function GetListRegisterCommands():Array {
			return [ StorageStrLib.Init_Storage,
					this._StorageKey,
					StorageStrLib.CurrentTab,
					StorageStrLib.StorageLayer,
					StorageStrLib.RemoveALL,
					StorageStrLib.GetMonsterMenu,
					UICmdStrLib.AddMonsterMenu,
					UICmdStrLib.UseMonsterMenu,
					UICmdStrLib.RecoverBtn,
					UICmdStrLib.MonsterTip,
					UICmdStrLib.RemoveMonsterTip,
					StorageStrLib.SureUse,
					StorageStrLib.Unload,
					MonsterCageStrLib.MonsterInformation,
					MonsterCageStrLib.Equ,
					MonsterCageStrLib.SortNumerical,
					UICmdStrLib.onRemoveALL,
					ProxyPVEStrList.TIP_CLOSESYS,
					UICmdStrLib.NewData
					];
		}
	}

}