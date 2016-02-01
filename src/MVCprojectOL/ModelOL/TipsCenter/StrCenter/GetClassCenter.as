package MVCprojectOL.ModelOL.TipsCenter.StrCenter
{
	import MVCprojectOL.ModelOL.Alchemy.AlchemyDataCenter;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterEvolution.EvolutionDataCenter;
	import MVCprojectOL.ModelOL.SkillData.SkillDataCenter;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ModelOL.Stone.StoneDataCenter;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import strLib.proxyStr.ProxyMonsterStr;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class GetClassCenter 
	{
		//private var _facde:ProjectOLFacade;
		//private var _TipCreatCenterl:PreViewSystem;
		public function GetClassCenter() 
		{
			
			//this._facde = ProjectOLFacade.GetFacadeOL();
		}
		
		public function GetFunction(_str:String):Function 
		{
			//---(setProxyName)----
			var _function:Function;
			switch(_str) {
				
				//---monsterData
				case ProxyMonsterStr.MONSTER_PROXY:
					//var _monsterClass:PlayerMonsterDataCenter = PlayerMonsterDataCenter.GetMonsterData();
					//_function = _monsterClass.TipsCenterHandler;
				break;
				//---交易所怪獸掛賣---
			    case ProxyPVEStrList.EXCHANGE_MONSTER:
				   _function = PlayerMonsterDataCenter.GetMonsterData().TipsCenterHandler;
				break;
				
			    case "buildTips":
				    var _build:BuildingProxy = BuildingProxy.GetInstance();
					_function = _build.GetTipsFunction;
				break;
				
			    case "PlayerData":
				    _function = PlayerDataCenter.GetPlayerInfoTips;
				break;
				
				//---進化用的素材TIPS
				case ProxyPVEStrList.MonsterEvolution_SOURCE_TIPS:
				    _function = EvolutionDataCenter.GetInstance().GetTipsVO;
				break;
				
				//---package---
			    case PlaySystemStrLab.Package_Weapon:
				//--0(type)
				  _function =EquipmentDataCenter.GetEquipment().GetSingleVOTips;
				break;
				
			    case PlaySystemStrLab.Package_Shield:
				 _function =EquipmentDataCenter.GetEquipment().GetSingleVOTips;
				//--1
				break;
				
			    case PlaySystemStrLab.Package_Accessories:
				  _function =EquipmentDataCenter.GetEquipment().GetSingleVOTips;
				 //--2
				break;
				
			    case PlaySystemStrLab.Package_Source:
				  _function =UserSourceCenter.GetUserSourceCenter().GetSourceTips;
				break;
				
			    case PlaySystemStrLab.Package_Stone:
				 _function = StoneDataCenter.GetStoneDataControl().GetTipsVO;
				break;
				
				
			    case ProxyPVEStrList.ALCHEMY_TIPS: 
				 _function = AlchemyDataCenter.GetAlchemy().GetTipsVO;
				break;
				
				case ProxyPVEStrList.LIBRARY_SKILLTips:
				_function = SkillDataCenter.GetInstance().GetSkill;
				break;
				/*
			    case ProxyPVEStrList.TIP_PreViewTest:
				_function =TipCreatCenter.GetTipsData()._preViewSystem.GetTipsVO;
				break;
				*/
			    case ProxyPVEStrList.STONE_EATPREVIEW:
				_function=PlayerMonsterDataCenter.GetMonsterData().GetPreMonstereatStone;
				break;
				
				//--排成完成提示類
				/*
				case ProxyPVEStrList.TIMELINE_SCHID_COMPLETE:
				_function = TimeLineObject.GetTimeLineObject().GetCompleteTips;
				break;
				*/
				
			}
			
			/*
			if (_str!="palyerData") {
				
				
			}else {
				
				
				
			}*/
			
			return _function;
		}
		
		
		
		
		
		
		
		
		
	}
	
}