package MVCprojectOL.ControllOL.LibraryCtrl 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.Library.LibraryProxy;
	import MVCprojectOL.ModelOL.LibraryModel.LibraryUIproxy;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.ShopMall.ShopMallProxy;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplayProxy;
	import MVCprojectOL.ModelOL.TipsCenter.TipsLab.TipsDataLab;
	import MVCprojectOL.ModelOL.ViewSharedModel.ViewSharedModel;
	import MVCprojectOL.ModelOL.Vo.Tip;
	import MVCprojectOL.ViewOL.LibraryView.LibraryViewCtrl;
	import MVCprojectOL.ViewOL.LibraryView.LibraryWallExitBtn;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MonsterView.MonsterPanel;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
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
	public class CatchLibraryControl extends CatchCommands
	{
		private var _SourceProxy:SourceProxy;
		private var _LibraryViewCtrl:LibraryViewCtrl;
		private var _LibraryUIproxy:LibraryUIproxy;
		private var _MonsterDisplayProxy:MonsterDisplayProxy;
		private var _SkillDisplayProxy:SkillDisplayProxy;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String >  [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn", "pageBtnN", "exitBtn", "TipBtn", "TipBox", "olBoard", 
		"Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg", "DetailBoard", "SkilletBg", "Inform", "MakeBtn", "Fatigue", "Hourglass", "CheckBtn", "BgD", "ReportBg", "EdgeBg", "ContentBg", "Diamond",
		"DemonAvatar", "Paper", "Job", "Lock", "TableBg", "EvolutionBg"];
		private var _ComponentClasses:Object;
		
		private var _LibraryKey:String = "GUI00009_ANI";//圖書館 素材包KEY碼
		private const _LibraryClasses:Vector.<String> = new < String > [ "bg5","NPC","Inform","olBoard","Bookcase","Bins","Workbench","bg51","SkillsBackplane","MakeBtn","CandleR","CandleL","Fire","Light","SkillList","Attack","Guard","Gain","Debuff","Dot","Recovery","Control"];
		private var _LibraryComponentClasses:Object;
		
		private var _LibraryLayer:int;
		private var _SkillGroup:uint;
		private var _GetLineAry:Array;
		
		private var _MonsterPanel:MonsterPanel;
		private var _CurrentNumerical:String = PlaySystemStrLab.Sort_LV;
		private var _CurrentMonsterData:String;
		
		private const _ShopMail:String = "SysCost_LEARN_COST";
		private var _BuildingGuid:String;
		
		private var _ArySkillPic:Array;
		private var _CurrentListBoard:int = -1;
		private var _CurrentNum:int = -1;
		
		//private var _ViewSharedModel:ViewSharedModel;
		private var _dicUiStr:Dictionary = new Dictionary(true);
		private var _aryUiStr:Array = ["LIB_TIP_INTRO1"];
		
		public function CatchLibraryControl() 
		{
			
		}
		
		private function initLibraryCore():void
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
				this._LibraryUIproxy = LibraryUIproxy.GetInstance();
				this._facaed.RegisterProxy( this._LibraryUIproxy );
				this._LibraryUIproxy.StartLoad( this._LibraryKey );
				/*this._ViewSharedModel = ViewSharedModel.GetInstance();
				this._facaed.RegisterProxy( this._ViewSharedModel );
				this._ViewSharedModel._SharedKey = this._LibraryKey;
				this._ViewSharedModel._SharedClasses = this._LibraryClasses;
				this._ViewSharedModel.StartLoad( this._LibraryKey );*/
				
				var _equClass:MovieClip=(this._SourceProxy.GetMaterialSWP(this._GlobalComponentPackKey,"Property",true)) as MovieClip;
				var _aryProperty:Array = this._SourceProxy.GetMovieClipHandler(_equClass, false, "PropertyImages");
				this._ComponentClasses.PropertyImages = _aryProperty;
				
				var vecUiStr:Vector.<Tip> = TipsDataLab.GetTipsData().GetTipsGroup(this._aryUiStr);
				var leng:int = vecUiStr.length;
				for (var i:int = 0; i < leng; i++) 
				{
					this._dicUiStr[vecUiStr[i]._keyVaule] = vecUiStr[i]._tips;
				}
				
				trace("素材OK !!");
			}else {
				trace("素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function OnLibrary():void
		{
			this._ArySkillPic = this._SourceProxy.GetCutImageGroup("skillPIC");
			
			this._MonsterDisplayProxy = MonsterDisplayProxy.GetInstance();//怪物顯示快取容器
			this._facaed.RegisterProxy( this._MonsterDisplayProxy );//怪物顯示快取容器
			
			this._SkillDisplayProxy = SkillDisplayProxy.GetInstance();//Skill顯示快取容器
			this._facaed.RegisterProxy( this._SkillDisplayProxy );//Skill顯示快取容器
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._LibraryViewCtrl = new LibraryViewCtrl ( ViewNameLib.View_Library , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._LibraryViewCtrl );//註冊溶解所ViewCtrl
			
			this._MonsterPanel = new MonsterPanel( ViewNameLib.View_MonsterMenu , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._MonsterPanel );//註冊惡魔選單ViewCtrl
			
			this._GetLineAry = LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).GetLine();
			
			this._LibraryViewCtrl.BackGroundElement(this._LibraryComponentClasses, this._ComponentClasses, BuildingProxy.GetInstance().GetBuildLineMax(BuildingProxy.GetInstance().GetBuildingGuid(4)), this._dicUiStr);
			this._LibraryViewCtrl.OneLayer(this._GetLineAry);
			this._LibraryViewCtrl.LockBoiler();
			
			if (this._CurrentListBoard != this._GetLineAry.length - 1) {
				for (var i:int = 0; i < this._GetLineAry.length; i++) 
				{
					this._CurrentListBoard = i;
					this.AddListBoard(this._CurrentListBoard);
				}
			}
			
			this._BuildingGuid = BuildingProxy(this._facaed.GetProxy(BuildingStr.BUILDING_SYSTEM)).GetBuildingGuid(4);
			
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddClass(LibraryWallExitBtn);
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddSingleSource("LibraryWallExitBtn" , this._ComponentClasses);
		
			//MonsterProxy(this._facaed.GetProxy(ProxyMonsterStr.MONSTER_PROXY)).GetMonsterLearning();
		}
		
		private function TerminateThis():void {
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Library );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_MonsterDisplayProxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_LibraryUIproxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_SkillDisplayProxy );
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_MonsterMenu );
			
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_MonsterMenu );
			this._MonsterPanel = null;
			
			this._LibraryViewCtrl = null;
			this._LibraryUIproxy = null;
			this._MonsterDisplayProxy = null;
			this._SkillDisplayProxy = null;
			
			this.SendNotify( UICmdStrLib.Terminate_Library );
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				case UICmdStrLib.Init_LibraryCatch:
				   this.initLibraryCore();
				break;
				case this._LibraryKey :
					trace( "圖書館回來了" );
					this._LibraryComponentClasses = _obj.GetClass();
					this.OnLibrary();
				break;
				
				case ProxyPVEStrList.LIBRARY_SetSKILLReady:
				   this.openLibraryDataHandler(LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).GetSLibrarykill(),1);	
				break;
				
				case UICmdStrLib.CurrentSkills :
					//trace(String(_obj.GetClass().guid));
					var _dic:Dictionary = LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).GetSLibrarykill();
					if (_dic != null) {
					   this.openLibraryDataHandler(_dic,uint(_obj.GetClass().guid)+1);	
						} else {
						return;
					}
				break;
				case UICmdStrLib.CurrentLearningSkills :
					//trace(String(_obj.GetClass().guid));
					//this._LibraryViewCtrl.MonsterMenuElement(this._MonsterDisplayProxy.GetMonsterDisplayList(), this._SkillGroup - 1);
				break;
				case UICmdStrLib.LearningSkills :
					LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).StarLearning(String(this._SkillGroup), String(_obj.GetClass().guid));
					this._GetLineAry = LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).GetLine();
					this._LibraryViewCtrl.OneLayer(this._GetLineAry);
					if (this._CurrentListBoard != this._GetLineAry.length - 1) {
						this._CurrentListBoard = this._GetLineAry.length - 1;
						this.AddListBoard(this._CurrentListBoard);
					}
					this._MonsterPanel.onRemoved();
				break;
				case UICmdStrLib.ChangeSkills :
					this._MonsterDisplayProxy.GetMonsterDisplay(String(_obj.GetClass().guid));
					var _CurrentMonster:MonsterDisplay = this._MonsterDisplayProxy.GetMonsterDisplay(String(_obj.GetClass().guid));
					var _Skill:SkillDisplay = this._SkillDisplayProxy.GetSkillDisplayClone(String(_CurrentMonster.MonsterData._Skill[0]));
					this._LibraryViewCtrl.ChangeSkill(_Skill, _obj.GetClass().SkillGroup, _obj.GetClass().guid);
				break;
				case UICmdStrLib.LearningChangeSkills :
					//trace(_obj.GetClass().SkillName, "@@@@@");
					LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).StarLearning(String(this._SkillGroup), String(_obj.GetClass().guid), String(_obj.GetClass().SkillName));
					this._LibraryViewCtrl.RemoveInform();
					this._MonsterPanel.onRemoved();
					this._GetLineAry = LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).GetLine();
					this._LibraryViewCtrl.OneLayer(this._GetLineAry);
					if (this._CurrentListBoard != this._GetLineAry.length - 1) {
						this._CurrentListBoard = this._GetLineAry.length - 1;
						this.AddListBoard(this._CurrentListBoard);
					}
				break;
				case UICmdStrLib.LibraryLayer :
					this._LibraryLayer = _obj.GetClass().Layer;
					MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddVaule(this._LibraryLayer);
				break;
				case UICmdStrLib.ShowTip :
					var _starTime:uint = ServerTimework.GetInstance().ServerTime;
					var _SendTips:SendTips = new SendTips(
						"Library", 
						ProxyPVEStrList.TIP_SCHER, 
						_obj.GetClass().Tip._picItem,
			            {_index:_obj.GetClass()._learning},
						_starTime,
						_obj.GetClass().finishTime,
						_obj.GetClass().needTime,
						4
						);
					this._LibraryViewCtrl.AddTip(TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_SCHER, _SendTips),_obj.GetClass().BoilerName);
					//TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(true);
				break;
				case UICmdStrLib.RemoveTip :
					//TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false);
				break;
				case ProxyPVEStrList.TIMELINE_SCHID_COMPLETE :
					//_obj.GetClass()._build = 4;
					if (_obj.GetClass()._build == 4) { //_obj.GetClass()._build == 4
						this._GetLineAry = LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).GetLine();
						this._LibraryViewCtrl.RemoveListBoard(this._GetLineAry.length, this._CurrentNum);
						this._CurrentListBoard = this._GetLineAry.length - 1;
						this._CurrentNum = -1;
						if (this._LibraryLayer == 1) {
							this._LibraryViewCtrl.RemoveBoiler();
							this._LibraryViewCtrl.OneLayer(this._GetLineAry);
							this._LibraryViewCtrl.RemoveInform(true);
						}
						//TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).SetTipsTimeLineVisible(false);
					}
				break;
				case UICmdStrLib.AddMonsterMenu :
					this._MonsterPanel.AddElement("Library", _obj.GetClass().Monster, _obj.GetClass().BGObj);
					this._MonsterPanel.AssemblyPanel(240, 127, 960, 510, 400, "魔書大館", 450, 75, 515, 460);
					this._LibraryViewCtrl.AddPanel();
				break;
				case UICmdStrLib.UseMonsterMenu :
					var _Num:int = LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).CheckLearnStates(this._CurrentMonsterData);
					this._LibraryViewCtrl.CheckMonsterStatus(_Num, this._CurrentMonsterData, this._SkillGroup);
				break;
				case UICmdStrLib.RecoverBtn :
					
				break;
				case UICmdStrLib.LibraryRemoveALL :
					if (this._LibraryLayer == 1) {
						this.TerminateThis();
						this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
					}else if (this._LibraryLayer == 2) {
						this._MonsterPanel.onRemoved();
						this._GetLineAry = LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).GetLine();
						this._LibraryViewCtrl.OneLayer(this._GetLineAry);
					}
				break;
				case UICmdStrLib.MonsterMenu :
					this._LibraryViewCtrl.MonsterMenuElement(this._MonsterDisplayProxy.GetMonsterDisplayList());
				break;
				case MonsterCageStrLib.SortNumerical :
					if (this._CurrentNumerical != String( _obj.GetClass()._sort)) { 
						this._LibraryViewCtrl.UpdateMonsterMenu(this._SkillGroup - 1, this._MonsterDisplayProxy.GetMonsterDisplayList( String( _obj.GetClass()._sort ), _obj.GetClass().CtrlNum));
						this._CurrentNumerical = String( _obj.GetClass()._sort);
					}
				break;
				case UICmdStrLib.UpdateMonsterMenu :
					this._MonsterPanel.UpdateMonster(_obj.GetClass().Monster, this._CurrentNumerical);
				break;
				case UICmdStrLib.CurrentMonsterData :
					this._CurrentMonsterData = String(_obj.GetClass().guid);
					this._LibraryViewCtrl.StartButton();
				break;
				case UICmdStrLib.CheckBtnHandler :
					this._LibraryViewCtrl.CloseCheckBtn();
				break;
				
				case UICmdStrLib.ShopMaill :
					this._LibraryViewCtrl.AddInform();
					var _TimeLine:Object = this._GetLineAry[int(_obj.GetClass().Name)];
					var _setting:Object = { 
						_tagretID:_TimeLine._target, 
						_type:0, 
						_build:4,
						_schID:_TimeLine._schID,
						_mission:ProxyPVEStrList.MISSION_Cal_MONSTER_SKILL
						};
					var _setPay:Object = { _key:_ShopMail, _build:this._BuildingGuid, _target:_TimeLine._schID };
					var _boolean:Boolean = ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).CheckPay("PayDynamicFactory", _setting, _setPay);
					var _Price:uint = ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).GetPayTotal();
					this._LibraryViewCtrl.GetPay(_Price, int(_obj.GetClass().Name));
				break;
				case UICmdStrLib.Consumption :
					this._CurrentNum = int(_obj.GetClass()._Num);
					ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy)).Pay();
				break;
				case ProxyPVEStrList.TIMELINE_SCHIDReady :
					this._GetLineAry = LibraryProxy(this._facaed.GetProxy(ProxyPVEStrList.LIBRARY_PROXY)).GetLine();
				break;
				case ProxyPVEStrList.TIP_CLOSESYS :
					this.TerminateThis();
				break;
				
			}
		}
		
		//----ericHuang--0529--
		private function openLibraryDataHandler(_dic:Dictionary,index:uint):void 
		{
			this._SkillGroup = index;
			var _SkillKey:Array = _dic[this._SkillGroup]._arySkill;
			var _SkillDisplay:Vector.<SkillDisplay> = new Vector.<SkillDisplay>;
			var _LearnSoul:int = _dic[this._SkillGroup]._learnSoul;
			var _LearnTime:int = _dic[this._SkillGroup]._learnTime;
			for (var i:String in _SkillKey) {
				_SkillDisplay.push(this._SkillDisplayProxy.GetSkillDisplay(_SkillKey[i]));
			}
			this._LibraryViewCtrl.SkillsList(_SkillDisplay, _LearnSoul, _LearnTime);
			this._LibraryViewCtrl.UpdateMonsterMenu(this._SkillGroup - 1);
		}
		
		private function AddListBoard(_ListBoardNum:int):void 
		{
			this._MonsterDisplayProxy.GetMonsterDisplayList();
			var _CurrentObj:Object = this._GetLineAry[_ListBoardNum];
			var _CurrentSkillPic:BitmapData = this._ArySkillPic[_CurrentObj._learning];
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
			this._LibraryViewCtrl.AddListBoard(_ListBoardNum, this._MonsterDisplayProxy.GetMonsterDisplay(_CurrentObj._target), _CurrentSkillPic, TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_TIMERBAR, _SendTips));
		}
		
		override public function GetListRegisterCommands():Array {
			return [ UICmdStrLib.Init_LibraryCatch,
					this._LibraryKey,
					UICmdStrLib.LibraryLayer,
					UICmdStrLib.LibraryRemoveALL,
					UICmdStrLib.LearningSkills,
					UICmdStrLib.CurrentSkills,
					UICmdStrLib.CurrentLearningSkills,
					UICmdStrLib.ShowTip,
					UICmdStrLib.RemoveTip,
					UICmdStrLib.AddMonsterMenu,
					UICmdStrLib.UseMonsterMenu,
					UICmdStrLib.ChangeSkills,
					UICmdStrLib.RecoverBtn,
					UICmdStrLib.LearningChangeSkills,
					UICmdStrLib.MonsterMenu,
					MonsterCageStrLib.SortNumerical,
					UICmdStrLib.UpdateMonsterMenu,
					UICmdStrLib.CurrentMonsterData,
					UICmdStrLib.CheckBtnHandler,
					UICmdStrLib.ShopMaill,
					UICmdStrLib.Consumption,
					ProxyPVEStrList.TIMELINE_SCHIDReady,
					ProxyPVEStrList.TIMELINE_SCHID_COMPLETE,
					ProxyPVEStrList.LIBRARY_SetSKILLReady,
					ProxyPVEStrList.TIP_CLOSESYS
					];
		}
	}
}