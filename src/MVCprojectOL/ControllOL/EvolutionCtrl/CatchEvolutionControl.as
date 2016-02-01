package MVCprojectOL.ControllOL.EvolutionCtrl 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplayProxy;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.MonsterEvolution.EvolutionProxy;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplayProxy;
	import MVCprojectOL.ViewOL.EvolutionView.EvolutionViewCtrl;
	import MVCprojectOL.ViewOL.MonsterView.MonsterPanel;
	import MVCprojectOL.ViewOL.MonsterView.MoonsterViewCtrl;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewNameLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchEvolutionControl  extends CatchCommands 
	{
		
		private var _SourceProxy:SourceProxy;
		private var _EvolutionViewCtrl:EvolutionViewCtrl;
		private var _MonsterDisplayProxy:MonsterDisplayProxy;
		private var _ItemDisplayProxy:ItemDisplayProxy;
		private var _MonsterPanel:MonsterPanel;
		private var _MoonsterViewCtrl:MoonsterViewCtrl;
		private var _SkillDisplayProxy:SkillDisplayProxy;
		private var _EvolutionProxy:EvolutionProxy;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClassList:Vector.<String> = new < String >  [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn", "pageBtnN", "exitBtn", "TipBtn", "TipBox", "olBoard", 
		"Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg", "DetailBoard", "SkilletBg", "Inform", "MakeBtn", "Fatigue", "Hourglass", "CheckBtn", "BgD", "ReportBg", "EdgeBg", "ContentBg", "BgL", "Wood", "Ore", "Fur", "Diamond",
		"DemonAvatar","Paper","EvolutionBg","Job"];
		private var _GlobalClasses:Object;
		
		private var _CurrentNumerical:String = PlaySystemStrLab.Sort_LV;
		private var _CruuentEvolution:String;
		private var _OtherGuid:String;
		private var _GetEvolutionList:Array;
		private var _evoSkill:String;
		private var _CtrlTurntable:Boolean = false;
		
		private function EvolutionCore():void
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._GlobalClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClassList );
				
				var _equClass:MovieClip=(this._SourceProxy.GetMaterialSWP(this._GlobalComponentPackKey,"Property",true)) as MovieClip;
				var _aryProperty:Array = this._SourceProxy.GetMovieClipHandler(_equClass, false, "PropertyImages");
				this._GlobalClasses.PropertyImages = _aryProperty;
				
				trace("公用素材OK !!");
				this.StartEvolution();
			}else {
				//若公用素材還沒有準備好 代表主程序未初始完畢  則發出終結指令終結這個command
				trace("公用素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function TerminateThis():void 
		{
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Evolution );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_MonsterDisplayProxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_ItemDisplayProxy );
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_MonsterMenu );
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_MonsterCage );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_SkillDisplayProxy );
			
			this._SourceProxy = null;
			this._GlobalClasses = null;
			this._EvolutionViewCtrl = null;
			this._MonsterDisplayProxy = null;
			this._ItemDisplayProxy = null;
			this._MonsterPanel = null;
			this._MoonsterViewCtrl = null;
			this._SkillDisplayProxy = null;
			
			this.SendNotify( UICmdStrLib.Terminate_Evolution );
		}
		
		private function StartEvolution():void 
		{
			this._ItemDisplayProxy = ItemDisplayProxy.GetInstance();//Item顯示快取容器
			this._facaed.RegisterProxy( this._ItemDisplayProxy );//Item顯示快取容器
			
			this._MonsterDisplayProxy = MonsterDisplayProxy.GetInstance();//怪物顯示快取容器
			this._facaed.RegisterProxy( this._MonsterDisplayProxy );//怪物顯示快取容器
			
			this._SkillDisplayProxy = SkillDisplayProxy.GetInstance();
			this._facaed.RegisterProxy( this._SkillDisplayProxy );
			
			this._EvolutionProxy = this._facaed.GetProxy(ProxyPVEStrList.MonsterEvolution_Proxy) as EvolutionProxy;
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._EvolutionViewCtrl = new EvolutionViewCtrl ( ViewNameLib.View_Evolution , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._EvolutionViewCtrl );//註冊ViewCtrl
			
			this._MoonsterViewCtrl = new MoonsterViewCtrl( ViewNameLib.View_MonsterCage , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._MoonsterViewCtrl );//註冊ViewCtrl
			this._MoonsterViewCtrl.AddElement(this._GlobalClasses);
			
			this._MonsterPanel = new MonsterPanel( ViewNameLib.View_MonsterMenu , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._MonsterPanel );//註冊惡魔選單ViewCtrl
			
			this._EvolutionViewCtrl.AddElement(this._GlobalClasses);
			
			this._EvolutionProxy.UpdateList();
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) {
				case UICmdStrLib.Init_EvolutionCatch:
				    this.EvolutionCore();
				break;
				case ProxyPVEStrList.MonsterEvolution_EvoListReady:
					this._evoSkill = "";
					if (_obj.GetClass()._type == 0) {
						this._GetEvolutionList = EvolutionProxy(this._facaed.GetProxy(ProxyPVEStrList.MonsterEvolution_Proxy)).GetEvolutionList();
						this.GetMonsterElement(this._GetEvolutionList, false);
					}else if (_obj.GetClass()._type == 1) { 
						this._evoSkill = _obj.GetClass()._evoSkill;
						this.FilterMonster(1, null, _obj.GetClass()._evoID, _obj.GetClass()._monster);
					}else if (_obj.GetClass()._type == 2) { 
						this._evoSkill = _obj.GetClass()._evoSkill;
						this.FilterMonster(2, _obj.GetClass().evoObj);
					}else if (_obj.GetClass()._type == 3) {
						this._evoSkill = _obj.GetClass()._evoSkill;
						this.FilterMonster(3);
					}
				break;
				case UICmdStrLib.GetItem:
					var _ItemA:Vector.<ItemDisplay> = new Vector.<ItemDisplay>;
					var _ItemB:Vector.<ItemDisplay> = new Vector.<ItemDisplay>;
					for (var i:int = 0; i < _obj.GetClass().NeedSourceList_A.length; i++) 
					{
						_ItemA.push(this._ItemDisplayProxy.GetItemDisplayExpress(_obj.GetClass().NeedSourceList_A[i]));
					}
					for (var j:int = 0; j < _obj.GetClass().NeedSourceList_B.length; j++) 
					{
						_ItemB.push(this._ItemDisplayProxy.GetItemDisplayExpress(_obj.GetClass().NeedSourceList_B[j]));
					}
					this._EvolutionViewCtrl.AddRecipeSource(_ItemA, _ItemB);
				break;
				case UICmdStrLib.GetMonster:
					var _MonsterItem:MonsterDisplay = new MonsterDisplay(_obj.GetClass().GetMonster);
					this._EvolutionViewCtrl.AddMonsterMenu(_MonsterItem, _obj.GetClass()._Boolean);
				break;
				case UICmdStrLib.CheckEvolution:
					(_obj.GetClass().OtherGuid == null)?this._OtherGuid = "":this._OtherGuid = String(_obj.GetClass().OtherGuid);
					var _CheckNum:int = this._EvolutionProxy.checkEvolution(String(_obj.GetClass().Guid), String(_obj.GetClass().EvoGuid), _OtherGuid);
					this._EvolutionViewCtrl.DisplayButton(_CheckNum);
				break;
				case UICmdStrLib.GoEvolution:
					(_obj.GetClass().OtherGuid == null)?this._OtherGuid = "":this._OtherGuid = String(_obj.GetClass().OtherGuid);
					this._CruuentEvolution = String(_obj.GetClass().Guid);
					var _Num:int = this._EvolutionProxy.GetEvolution(String(_obj.GetClass().Guid), String(_obj.GetClass().EvoGuid), _OtherGuid);
				break;
				case UICmdStrLib.AddMonsterMenu:
					var _MonsterMenu:Vector.<MonsterDisplay> = this._MonsterDisplayProxy.GetMonsterDisplayList();
					this._MonsterPanel.AddElement("Evolution", _MonsterMenu, _obj.GetClass().BGObj, -1, null, int(_obj.GetClass().Rank), String(_obj.GetClass().MonsterName),String(_obj.GetClass().Guid));
					this._MonsterPanel.AssemblyPanel(240, 127, 960, 510, 400, "惡魔巢穴", 460);
				break;
				case UICmdStrLib.CtrlPage:
					this._EvolutionViewCtrl.CtrlPage(_obj.GetClass().CtrlPageNum, _obj.GetClass().CtrlBoolean);
				break;
				case UICmdStrLib.RemoveALL:
					this.SendNotify(UICmdStrLib.RemoveTurntable);
					this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
					this.TerminateThis();
				break;
				
				case UICmdStrLib.CurrentMonsterData :
						this._EvolutionViewCtrl.AddMonsterMenuB(this._MonsterDisplayProxy.GetMonsterDisplay(String(_obj.GetClass().guid)));
				break;
				case MonsterCageStrLib.SortNumerical :
					if (this._CurrentNumerical != String( _obj.GetClass()._sort)) { 
						this._MonsterPanel.UpdateMonster(this._MonsterDisplayProxy.GetMonsterDisplayList( String( _obj.GetClass()._sort ), _obj.GetClass().CtrlNum), String( _obj.GetClass()._sort ));
						this._CurrentNumerical = String( _obj.GetClass()._sort);
					}
				break;
				case MonsterCageStrLib.MonsterInformation :
					(String( _obj.GetClass()._guid) == null)?null:this._MoonsterViewCtrl.AssemblyMonsterInformation(this._MonsterDisplayProxy.GetMonsterDisplayClone( String( _obj.GetClass()._guid ) ));
				break;
				case MonsterCageStrLib.Equ :
					if (_obj.GetClass().Weapon != null) var _Weapon:ItemDisplay = this._ItemDisplayProxy.GetItemDisplayExpress(_obj.GetClass().Weapon);
					if (_obj.GetClass().Armor != null) var _Armor:ItemDisplay =this._ItemDisplayProxy.GetItemDisplayExpress(_obj.GetClass().Armor);
					if (_obj.GetClass().Accessories != null) var _Accessories:ItemDisplay = this._ItemDisplayProxy.GetItemDisplayExpress(_obj.GetClass().Accessories);
					
					if (_obj.GetClass().Monster.MonsterData._Skill != null) {
						var _Skill:Vector.<SkillDisplay> = new Vector.<SkillDisplay>; 
						for (var m:String in _obj.GetClass().Monster.MonsterData._Skill) {
							_Skill.push(this._SkillDisplayProxy.GetSkillDisplay(String(_obj.GetClass().Monster.MonsterData._Skill[m])));
						}
					}
					this._MoonsterViewCtrl.AddMonsterInformation(_obj.GetClass().Monster, _Weapon, _Armor, _Accessories, _Skill);
				break;
				case ProxyPVEStrList.TIP_CLOSESYS :
					this.SendNotify(UICmdStrLib.RemoveTurntable);
					this.TerminateThis();
				break;
			}
		}
		
		private function FilterMonster(_type:int, _evoObj:Object = null, _evoID:String = "", _monster:Object = null):void 
		{
			for (var k:String in this._GetEvolutionList) {
				for (var l:String in this._GetEvolutionList[k]._aryMonster) {
					if (this._GetEvolutionList[k]._aryMonster[l]._guid == this._CruuentEvolution) {
						this._GetEvolutionList[k]._aryMonster.splice(l, 1);
						if (this._GetEvolutionList[k]._aryMonster.length == 0) this._GetEvolutionList.splice(k, 1);
					}
				}
			}
			
			for (var i:String in this._GetEvolutionList) {
				for (var j:String in this._GetEvolutionList[i]._aryMonster) {
					if (this._GetEvolutionList[i]._needColorRank == 4 || this._GetEvolutionList[i]._needColorRank == 5 || this._GetEvolutionList[i]._needColorRank == 6 ) if ( this._GetEvolutionList[i]._aryMonster[j]._guid == this._OtherGuid) { 
						this._GetEvolutionList[i]._aryMonster.splice(j, 1);
						if (this._GetEvolutionList[i]._aryMonster.length == 0) this._GetEvolutionList.splice(i, 1);
					}
				}
				
			}
			
			for (var m:String in this._GetEvolutionList) {
				if (_type == 1 && this._GetEvolutionList[m]._recipeID == _evoID) this._GetEvolutionList[m]._aryMonster.push(_monster);
			}
			if (_type == 2) this._GetEvolutionList.push(_evoObj);
			(this._GetEvolutionList != null)?this.GetMonsterElement(this._GetEvolutionList, true):this.GetMonsterElement(new Array(), true);
		}
		
		private function GetMonsterElement(_Ary:Array, _CtrlBoolean:Boolean):void 
		{
			if (_CtrlBoolean == false) this._MonsterDisplayProxy.GetMonsterDisplayList();
			var _MonsterList:Vector.<MonsterDisplay> = new Vector.<MonsterDisplay>;
			this._MonsterDisplayProxy.GetMonsterDisplayList();
			for (var i:int = 0; i < _Ary.length; i++) 
			{
				for (var j:String in _Ary[i]._aryMonster) {
					if (_Ary[i]._aryMonster.lenget != 0) if(_Ary[i]._aryMonster[j]._useing != 2)_MonsterList.push(this._MonsterDisplayProxy.GetMonsterDisplay(_Ary[i]._aryMonster[j]._guid));
				}
			}
			this._EvolutionViewCtrl.MonsterElement(_MonsterList, _Ary, _CtrlBoolean);
			if (this._evoSkill != "") {
				var _evoSkillObj:Object = { _Guid:this._evoSkill };
				(this._CtrlTurntable == false)?this.SendNotify(UICmdStrLib.Init_Turntable, _evoSkillObj):this.SendNotify(UICmdStrLib.StartTurntable, _evoSkillObj);
				this._CtrlTurntable = true;
			}
		}
		
		override public function GetListRegisterCommands():Array {
			return [ UICmdStrLib.Init_EvolutionCatch,
					UICmdStrLib.RemoveALL,
					ProxyPVEStrList.MonsterEvolution_EvoListReady,
					UICmdStrLib.CtrlPage,
					UICmdStrLib.GetItem,
					UICmdStrLib.GetMonster,
					UICmdStrLib.GoEvolution,
					UICmdStrLib.AddMonsterMenu,
					UICmdStrLib.CheckEvolution,
					MonsterCageStrLib.SortNumerical,
					UICmdStrLib.CurrentMonsterData,
					MonsterCageStrLib.MonsterInformation,
					MonsterCageStrLib.Equ,
					ProxyPVEStrList.TIP_CLOSESYS
					];
		}
		
	}
}