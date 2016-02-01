package MVCprojectOL.ControllOL.MonsterCage {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplayProxy;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterEvolution.EvolutionProxy;
	import MVCprojectOL.ModelOL.ShopMall.ShopMallProxy;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplayProxy;
	import MVCprojectOL.ModelOL.Vo.ReturnMonster;
	import MVCprojectOL.ViewOL.MonsterCage.WallBtn;
	import MVCprojectOL.ViewOL.MonsterView.MonsterPanel;
	import MVCprojectOL.ViewOL.MonsterView.MoonsterViewCtrl;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.proxyStr.ProxyMonsterStr;
	import strLib.proxyStr.ProxyPVEStrList;
	//import MonsterCage.Model.MonsterCageProxy;
	import MVCprojectOL.ModelOL.MonsterCage.MonsterCageProxy;
	//import MonsterCage.View.MonsterCageView;
	import MVCprojectOL.ViewOL.MonsterCage.MonsterCageView;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MainView.MainViewBGSystem;
	import strLib.vewStr.ViewStrLib;
	//import MVCprojectOL.ViewOL.ExampleAllPanel.BasicBgPanelAAA;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.GameSystemStrLib;
	import strLib.vewStr.ViewNameLib;
	//import strLib.proxyStr.PlaySystemStrLab;
	//import strLib.viewStr.ViewNameLib;
	//import strLib.viewStr.ViewStrLib;
	
	import strLib.proxyStr.ProxyNameLib;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	//import MonsterCage.Command.TerminateMonsterCage;
	
	
	import ProjectOLFacade;
	/**
	 * ...
	 * @author K.J. Aris
	 */
	public class CatchMonsterCageControl extends CatchCommands {
		
		private var _MonsterDisplayProxy:MonsterDisplayProxy;
		private var _MonsterCageProxy:MonsterCageProxy;
		private var _MonsterCageView:MonsterCageView;
		private var _SourceProxy:SourceProxy;
		private var _ItemDisplayProxy:ItemDisplayProxy;
		private var _SkillDisplayProxy:SkillDisplayProxy;
		private var _ShopMallProxy:ShopMallProxy;
		private var _EvolutionProxy:EvolutionProxy;
		
		private var _PageNum:Vector.<int> = new Vector.<int>;
		
		private var _MoonsterViewCtrl:MoonsterViewCtrl;
		private var _MonsterPanel:MonsterPanel;
		private var _evoSkill:String;
		private var _CtrlTurntable:Boolean = false;
		private var _NewGuid:String;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String > [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn", "pageBtnN", "exitBtn", "TipBtn", "TipBox", "olBoard", 
		"Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg", "DetailBoard", "SkilletBg", "Inform", "MakeBtn", "Fatigue", "Hourglass", "CheckBtn", "BgD", "ReportBg", "EdgeBg", "Job"
		, "Diamond","DemonAvatar","Paper",];
		private var _ComponentClasses:Object;
		/*
		public function CatchMonsterCageControl() {
			trace( "StartCatchMonsterCageControl" );
			
			//GUI00002_ANI 
			
				/*
					"bg1" 底圖 Bitmap
					"pageBtnS" 小型翻頁按鈕
					"pageBtnM" 大型翻業按鈕
					"sortBtn" 下(上)拉清單按鈕
					"changeBtn" 升降冪切換按鈕
					"bgBtn" 基本按紐元件 (怪物LV)*/

			
		//}
		private var _CurrentNumerical:String = PlaySystemStrLab.Sort_LV;//121127 Kai Brook
		private var _CurrentMonsterGuid:String;
		
		
		private function initMonsterCore():void {
			
			//this._facaed.RegisterCommand( MonsterCageStrLib.Terminate_MonsterCage , TerminateMonsterCage );//註冊終結事件

			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			//trace("helloMonster");
			if ( _ComponentExist == true ) {
				this._MonsterCageProxy = MonsterCageProxy.GetInstance();
				this._facaed.RegisterProxy( _MonsterCageProxy );
				//---11/24調整流程-----
				this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
				//this._MonsterCageProxy.StartLoad( this._DetailBoardPackKey );
				var _equClass:MovieClip=(this._SourceProxy.GetMaterialSWP(this._GlobalComponentPackKey,"Property",true)) as MovieClip;
				var _aryProperty:Array = this._SourceProxy.GetMovieClipHandler(_equClass, false, "PropertyImages");
				this._ComponentClasses.PropertyImages = _aryProperty;
				
				trace("公用素材OK !!");
				this.initMonsterCage();
			}else {
				//若公用素材還沒有準備好 代表主程序未初始完畢  則發出終結指令終結這個command
				trace("公用素材不OK !!");
				this.TerminateThis();
			}
		}
		
		
		private function initMonsterCage():void {
			trace( "開始起始獸欄" );
			
			//for (var i:String in this._ComponentClasses ) {
				//trace( i , this._ComponentClasses[i] );
			//}
			
			this._ItemDisplayProxy = ItemDisplayProxy.GetInstance();//Item顯示快取容器
			this._facaed.RegisterProxy( this._ItemDisplayProxy );//Item顯示快取容器
			
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_MonsterCageProxy );//移除已不需要的Proxy (MonsterCageProxy)
			this._MonsterCageProxy = null;//釋放MonsterCageProxy指標
			
			this._MonsterDisplayProxy = MonsterDisplayProxy.GetInstance();//怪物顯示快取容器
			this._facaed.RegisterProxy( this._MonsterDisplayProxy );//怪物顯示快取容器
			
			this._SkillDisplayProxy = SkillDisplayProxy.GetInstance();
			this._facaed.RegisterProxy( this._SkillDisplayProxy );
			
			this._ShopMallProxy = ShopMallProxy(this._facaed.GetProxy(ProxyPVEStrList.ShopMall_Proxy));
			this._EvolutionProxy = this._facaed.GetProxy(ProxyPVEStrList.MonsterEvolution_Proxy) as EvolutionProxy;
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );//取得系統顯示層 Note: 還要加入主介面底板顯示層級 121122
			//新介面
			this._MoonsterViewCtrl = new MoonsterViewCtrl( ViewNameLib.View_MonsterCage , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._MoonsterViewCtrl );//註冊ViewCtrl
			
			this._MonsterPanel = new MonsterPanel( ViewNameLib.View_MonsterMenu , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._MonsterPanel );//註冊惡魔選單ViewCtrl
			
			this._MoonsterViewCtrl.AddElement( this._ComponentClasses );
			this._MoonsterViewCtrl.MonsterElement( this._MonsterDisplayProxy.GetMonsterDisplayList( PlaySystemStrLab.Sort_LV , -1));
			
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddClass(WallBtn);
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddSingleSource("WallSortBtn" , this._ComponentClasses);
		}
		
		private function TerminateThis():void {
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_MonsterCageProxy );
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_MonsterCage );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_MonsterDisplayProxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_ItemDisplayProxy );
			
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_SkillDisplayProxy );
			//新介面
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_MonsterMenu );
			this._MonsterPanel = null;
			this._MoonsterViewCtrl = null;
			
			this._MonsterCageProxy = null;
			this._MonsterCageView = null;
			this._MonsterDisplayProxy = null;
			this._ItemDisplayProxy = null;
			this._SkillDisplayProxy = null;
			
			this.SendNotify( MonsterCageStrLib.Terminate_MonsterCage );
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void {
			
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) {
				
				case MonsterCageStrLib.Init_MonsterCage:
				     (_obj.GetClass() == null)?this._NewGuid = "":this._NewGuid = String(_obj.GetClass());
					this.initMonsterCore();
				break;	
				
				/*case this._DetailBoardPackKey :
						trace( "板板回來了" , _obj.GetClass()[ "DetailBoard" ]  );
						this._ComponentClasses[ "DetailBoard" ] = _obj.GetClass()[ "DetailBoard" ];
						this.initMonsterCage();
					break;
					
				case (this._DetailBoardPackKey + "Invaild") :
						trace( this._DetailBoardPackKey , "載入錯誤   終結MonsterCage" );
						this.TerminateThis();
					break;*/
				case MonsterCageStrLib.AscendingOrDescending:
						//this._MonsterCageView.MonsterElement( this._MonsterDisplayProxy.GetMonsterDisplayList( String( _obj.GetClass()._sort ), _obj.GetClass().CtrlNum ));
				break;
					
				case MonsterCageStrLib.MonsterInformation :
						//trace( " I Got " , _Signal , _obj.GetClass()._guid );
						//this._MonsterCageView.AssemblyMonsterInformation( this._MonsterDisplayProxy.GetMonsterDisplayClone( String( _obj.GetClass()._guid ) ) );
						this._CurrentMonsterGuid = String( _obj.GetClass()._guid );
						this._MoonsterViewCtrl.AssemblyMonsterInformation(this._MonsterDisplayProxy.GetMonsterDisplayClone( this._CurrentMonsterGuid ));
					break;
					
				case MonsterCageStrLib.PageTextComplete :
					MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddVaule(this._PageNum);
					break;
				case MonsterCageStrLib.PageListLength :
					this._PageNum[0] = int( _obj.GetClass().PageListLength );
					this._PageNum[1] = int( _obj.GetClass().CtrlPageNum );
					//this._WallBtn.PageText(String( _obj.GetClass().PageListLength ));
					break;
				case MonsterCageStrLib.MouseHandler :
					this._MonsterCageView.onClickHandler(String( _obj.GetClass().BtnName ));
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
							//trace(i,String(_obj.GetClass().Monster.MonsterData._Skill[i]),_Skill[i]);
						}
					}
					this._MoonsterViewCtrl.AddMonsterInformation(_obj.GetClass().Monster, _Weapon, _Armor, _Accessories, _Skill);
				break;
				case MonsterCageStrLib.RemoveALL :
						this.SendNotify(UICmdStrLib.RemoveTurntable);
						this.TerminateThis();
						this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
					break;
					
				case UICmdStrLib.AddMonsterMenu :
					this._MonsterPanel.AddNewGuid(this._NewGuid);
					this._MonsterPanel.AddElement("Monster", _obj.GetClass().Monster, _obj.GetClass().BGObj);
					this._MonsterPanel.AssemblyPanel(240, 127, 960, 510, 400, "惡魔巢穴", 460);
				break;
				case MonsterCageStrLib.SortNumerical :
					//trace(String( _obj.GetClass()._sort)); 
					if (this._CurrentNumerical != String( _obj.GetClass()._sort)) { 
						this._MonsterPanel.UpdateMonster(this._MonsterDisplayProxy.GetMonsterDisplayList( String( _obj.GetClass()._sort ), _obj.GetClass().CtrlNum), String( _obj.GetClass()._sort ));
						this._CurrentNumerical = String( _obj.GetClass()._sort);
					}
				break;
				
				case UICmdStrLib.ShopMaill :
					this._MoonsterViewCtrl.AddInform();
					var _DataObj:Object = _obj.GetClass();
					(_obj.GetClass().Name == "Skill")?this.GetSkillShopData(_DataObj):this.GetValueShopData(_DataObj);
				break;
				case UICmdStrLib.Consumption :
					(_obj.GetClass().Diamond == "Skill")?this._EvolutionProxy.ChangeSkill():this._ShopMallProxy.Pay();
				break;
				case ProxyMonsterStr.MONSTER_CHANGE:
					var _ReturnMonster:ReturnMonster = _obj.GetClass() as ReturnMonster;
					var _NewMonster:MonsterDisplay = this._MonsterDisplayProxy.GetMonsterDisplayUpdated(this._CurrentMonsterGuid);
					//trace(_ReturnMonster._guid,"@@@@@",this._CurrentMonsterGuid);
					this._MoonsterViewCtrl.AssemblyMonsterInformation(this._MonsterDisplayProxy.GetMonsterDisplayClone( this._CurrentMonsterGuid ));
					//(_ReturnMonster._type == 2)?this._MoonsterViewCtrl.UpdataMonster(_ReturnMonster._HP, 2, this._CurrentMonsterGuid):this._MoonsterViewCtrl.UpdataMonster(_ReturnMonster._ENG, 3, this._CurrentMonsterGuid);
					(_ReturnMonster._type == 2)?this._MonsterPanel.UpdataMonster(_ReturnMonster._HP, this._CurrentMonsterGuid):null;
				break;
				case ProxyPVEStrList.MonsterEvolution_EvoListReady:
					this._evoSkill = _obj.GetClass()._evoSkill;
					var _evoSkillObj:Object = { _Guid:this._evoSkill };
					(this._CtrlTurntable == false)?this.SendNotify(UICmdStrLib.Init_Turntable, _evoSkillObj):this.SendNotify(UICmdStrLib.StartTurntable, _evoSkillObj);
					this._CtrlTurntable = true;
				break;
				case UICmdStrLib.ChangeSkill :
					this._MoonsterViewCtrl.UpdataSkill(_obj.GetClass().Skill);
				break;
				case ProxyPVEStrList.TIP_CLOSESYS :
					if (int(_obj.GetClass()) != 4) {
						this.SendNotify(UICmdStrLib.RemoveTurntable);
						this.TerminateThis();
					}
				break;
				case UICmdStrLib.NewData :
					this._NewGuid = String(_obj.GetClass());
					this._MonsterPanel.AddNewGuid(this._NewGuid);
					this._MonsterPanel.SelectMonster();
				break;
					
				default:
					break;
			}
		}
		
		private function GetValueShopData(_DataObj:Object):void 
		{
			var _setting:Object = { 
				_tagretID:_DataObj.Guid, 
				_type:1, 
				_valType:_DataObj.Name
			};
			var _setPay:Object = { _key:(_DataObj.Name == "hp")?"SysCost_LIFE_COST":"SysCost_FATIGUE_COST", _value:(_DataObj.Name == "hp")?_DataObj.Hp:_DataObj.Eng };
			var _boolean:Boolean = this._ShopMallProxy.CheckPay("MonsterFactory", _setting, _setPay);
			var _Price:uint = this._ShopMallProxy.GetPayTotal();
			this._MoonsterViewCtrl.GetPay(_Price, _DataObj.Name);
		}
		
		private function GetSkillShopData(_DataObj:Object):void 
		{
			var _MonsterGuid:String = _DataObj.Guid;
			//--[-1]>該怪獸查詢資料錯誤>  [ -2] > 該怪獸不是進化怪獸不能刷技能 >[ -3] > 該怪獸不在閒置中 [1] > 可以執行刷技能
			var _MonsterStatus:int = this._EvolutionProxy.CheckMonsterStatus(_MonsterGuid);
			if (_MonsterStatus == 1) {
				var _ShopData:Object = this._EvolutionProxy.CheckAndShowMoney(_MonsterGuid);
				//if (_ShopData._flag == true) 
				_ShopData._showMoney = 0;
				this._MoonsterViewCtrl.GetPay(_ShopData._showMoney, _DataObj.Name);
			}
		}
		
		override public function GetListRegisterCommands():Array {
			return [ //this._DetailBoardPackKey , //MonsterCage場景所需的素材都準備完畢
					//(this._DetailBoardPackKey + "Invaild") , //MonsterCage場景所需的素材載入失敗
					MonsterCageStrLib.SortNumerical , //重新Sort
					MonsterCageStrLib.MonsterInformation ,//顯示怪物詳細資訊
					MonsterCageStrLib.RemoveALL,//
					//MonsterCageStrLib.init_MonsterCatchCore
					MonsterCageStrLib.Init_MonsterCage,
					MonsterCageStrLib.MouseHandler,
					MonsterCageStrLib.PageListLength,
					MonsterCageStrLib.PageTextComplete,
					MonsterCageStrLib.Equ,
					MonsterCageStrLib.AscendingOrDescending,
					UICmdStrLib.AddMonsterMenu,
					UICmdStrLib.ShopMaill,
					UICmdStrLib.Consumption,
					ProxyMonsterStr.MONSTER_CHANGE,
					ProxyPVEStrList.MonsterEvolution_EvoListReady,
					UICmdStrLib.ChangeSkill,
					ProxyPVEStrList.TIP_CLOSESYS,
					UICmdStrLib.NewData
					];
		}
		
	}//end class
}//end package