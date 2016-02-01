package {
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleBasic;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleEffect;
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldInit;
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldSteps;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleReport;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleRound;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleRoundEffect;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	import MVCprojectOL.ModelOL.Vo.MissionVO.Mission;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionBackReward;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionEveryDay;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionReward;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionRewardResponder;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpCompetition;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpDayVary;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpFightingReport;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpGoods;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpGoodsInvoice;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpInitData;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpRankingUpdate;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpReward;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpShopInit;
	import Spark.MVCs.Models.NetWork.ConnectionVariableDefinition;
	
	
	
	/**
	 * ...
	 * @author K.J. Aris
	 */
	
	 
	//---------------------------------------------------------------------VOs
	
	
	
	//..................................basic
	import Spark.MVCs.Models.NetWork.NetResultPack;
		
	import MVCprojectOL.ModelOL.Vo.*;
	import MVCprojectOL.ModelOL.Vo.Get.*;
	import MVCprojectOL.ModelOL.Vo.Set.*;
	
	//----------------------------------------------------------END--------VOs
	
	
	public class NetSetting extends ConnectionVariableDefinition {
		
		public function NetSetting( _InputGateWay:String = null ) {
			//this.InitVoMapping();
			//trace("NetSetting constructed");
			//trace( this._GateWay );
			super( _InputGateWay );
		}
		
		public override function InitVoMapping():void {
			//trace( "OutsideSetting" );
			this.GetVoClassesMappingList();
			this.SetVoClassesMappingList();
			this.PropertiesVoClassesMappingList();
		}
		
		private function GetVoClassesMappingList():void {
			registerClassAlias( "Get_UrlData" , Get_UrlData );//取得Url資訊
			registerClassAlias( "Get_PlayerData" , Get_PlayerData );//取得玩家初始資訊
			
			//-------------------怪物
			registerClassAlias( "Get_PlayerMonster" , Get_PlayerMonster );//取得Monster資訊
			
			//-------------------導引
			registerClassAlias( "Get_GuideList" , Get_GuideList );//取得Guide資訊
			
			//-------------------探索
			//registerClassAlias( "Get_ExploreData" , Get_ExploreData );//取得Explore資訊
			//registerClassAlias( "Get_NewRoute" , Get_NewRoute );//取得NewRoute資訊
			
			//-------------------建築
			registerClassAlias( "Get_Building" , Get_Building );//
			registerClassAlias( "Get_BuildUpgrade" , Get_BuildUpgrade );//
			
			//-------------------組隊
			registerClassAlias( "Get_Troop" , Get_Troop );//
			//----timeLine
			registerClassAlias( "Get_Buildschedule" , Get_Buildschedule );//
			//----stone
			registerClassAlias( "Get_PlayerStone" ,Get_PlayerStone);//
			//----排程所有會回來的
			//registerClassAlias( "Get_Buildscheduleres" ,Get_Buildscheduleres);//
			registerClassAlias( "Get_PlayerBuildschedule" ,Get_PlayerBuildschedule);//
			//----Recipe
			registerClassAlias( "Get_Recipe" , Get_Recipe);
			//---PlayerSource--Get_PlayerSource
			registerClassAlias( "Get_PlayerSource" , Get_PlayerSource);
			//----PlayerEquipment---Get_PlayerEquipment
			registerClassAlias( "Get_PlayerEquipment" , Get_PlayerEquipment);
			//-----playerLibrary----
			registerClassAlias( "Get_PlayerLibrary" , Get_PlayerLibrary);
			//-----skill-----
			registerClassAlias( "Get_Skills" , Get_Skills);
			//-----怪獸更新
			registerClassAlias( "Get_MonsterRecovery" , Get_MonsterRecovery);
			//----tips---
			registerClassAlias( "Get_TipsData" , Get_TipsData);
			//----Get_PlayerBasicValue
			registerClassAlias( "Get_PlayerBasicValue" , Get_PlayerBasicValue);
			//---Get_PayBillData
			registerClassAlias( "Get_PayBillData" , Get_PayBillData);
			//----Get_Evolution---
			registerClassAlias( "Get_Evolution" , Get_Evolution);
			//----get MISSION
			registerClassAlias( "Get_Mission" , Get_Mission);
			registerClassAlias( "Get_Mission_Init" , Get_Mission_Init);
			registerClassAlias( "Get_MissionReward" , Get_MissionReward);
			//-----交易所
			registerClassAlias( "Get_Exchange" , Get_Exchange);
			registerClassAlias( "Get_ExchangeSellList" , Get_ExchangeSellList);
			
		}
		
		private function SetVoClassesMappingList():void {
			//-------------------導引
			registerClassAlias( "Set_GuideReadRecord" , Set_GuideReadRecord );
			
			//-------------------探索
			registerClassAlias( "Set_RouteChoice" , Set_RouteChoice );
			
			//-------------------建築
			registerClassAlias( "Set_BuildUpgrade" , Set_BuildUpgrade );
			
			//-------------------組隊
			registerClassAlias( "Set_Troop" , Set_Troop );
			//---加入建築物時間排程
			registerClassAlias( "Set_BuildSchedule" , Set_BuildSchedule );
			//----寫怪獸異動的資訊
			registerClassAlias( "Set_PlayerMonster" , Set_PlayerMonster );
			//---消費---
			registerClassAlias( "Set_usemall" , Set_usemall );
			//----取得進化---
			registerClassAlias( "Set_Evolution",Set_Evolution);
			//--交易所
			registerClassAlias( "Set_ExchangeGoods",Set_ExchangeGoods);
			
			
		}
		
		private function PropertiesVoClassesMappingList():void {
			//registerClassAlias( "NetResultPack" , NetResultPack );//連線資訊
				
			registerClassAlias( "PlayerData" , PlayerData );//玩家初始資訊
			
			//-------------------探索
			//registerClassAlias( "ExploreData" , ExploreData );//
			//registerClassAlias( "ExploreFightResult" , ExploreFightResult );//
			//registerClassAlias( "RouteNode" , RouteNode );//
			
			//-------------------導引
			registerClassAlias( "Guide" , Guide );//
			
			//-------------------怪物
			registerClassAlias( "PlayerMonster" , PlayerMonster );//
			
			//-------------------建築
			registerClassAlias( "Building" , Building );//
			//registerClassAlias( "BuildingUpgrade" , BuildingUpgrade );//
			//registerClassAlias( "CheckBuildUpgrade" , CheckBuildUpgrade );//
			
			//-------------------組隊
			registerClassAlias( "EditTroop" , EditTroop );//
			registerClassAlias( "NewTroop" , NewTroop );//
			registerClassAlias( "Troop" , Troop );//
			//------stone--
			registerClassAlias( "PlayerStone",PlayerStone );//
			//----排程
			registerClassAlias( "Buildschedule" , Buildschedule );//
			//----製作表
			registerClassAlias( "Recipe" , Recipe );//
			//----playerSource
			registerClassAlias( "PlayerSource" , PlayerSource );//
			//---裝備
			registerClassAlias( "PlayerEquipment" , PlayerEquipment );//
			//---圖書館
			registerClassAlias( "PlayerLibrary" , PlayerLibrary );//
			//----skill
			registerClassAlias( "Skill" , Skill );//
			//---skilleffects---
			registerClassAlias( "SkillEffect" , SkillEffect );//
			
			//-ReturnMonster
			registerClassAlias( "ReturnMonster" , ReturnMonster );//
			
			
			//Battle
			registerClassAlias( "BattleBasic" , BattleBasic );//
			registerClassAlias( "BattleEffect" , BattleEffect );//
			registerClassAlias( "BattlefieldInit" , BattlefieldInit );//
			registerClassAlias( "BattlefieldSteps" , BattlefieldSteps );//
			registerClassAlias( "BattleFighter" , BattleFighter );//
			registerClassAlias( "BattleRound" , BattleRound );//
			registerClassAlias( "BattleRoundEffect" , BattleRoundEffect );//
			
			//ExploreArea
			//registerClassAlias( "ExploreArea" , ExploreArea );//
			registerClassAlias( "ItemDrop" , ItemDrop );//
			//----Tips---
			registerClassAlias( "Tip" , Tip );//
			registerClassAlias( "PlayerBasicValue" , PlayerBasicValue );//
			
			//----排成錯誤---
			registerClassAlias( "BuildSchedule_Error" , BuildSchedule_Error);//
			//---帳單明細
			registerClassAlias( "PayBill" , PayBill);//
			registerClassAlias( "ShopMall" , ShopMall);//
			
			//---進化配方表
			registerClassAlias( "Evolution" , Evolution);//
			//---進化配方表外層
			registerClassAlias( "EvolutionBox" , EvolutionBox);//
			//---任務
			registerClassAlias( "Mission" , Mission);//
			//---條件獎勵品
			registerClassAlias( "MissionReward" , MissionReward);//
			//---獎勵回傳
			registerClassAlias( "MissionRewardResponder" , MissionRewardResponder);//
			//---獎勵包裝容
			registerClassAlias( "MissionBackReward" , MissionBackReward);//
			registerClassAlias( "MissionEveryDay" , MissionEveryDay);//
			
			
			//----PVP--
			registerClassAlias("PvpInitData", PvpInitData);
			registerClassAlias("PvpCompetition", PvpCompetition);
			registerClassAlias("PvpRankingUpdate", PvpRankingUpdate);
			registerClassAlias("PvpFightingReport", PvpFightingReport);
			registerClassAlias("BattleReport", BattleReport);
			registerClassAlias("PvpDayVary", PvpDayVary);
			registerClassAlias("PvpReward", PvpReward);
			//----PVP商店--
			registerClassAlias("PvpGoods", PvpGoods);
			registerClassAlias("PvpShopInit", PvpShopInit);
			registerClassAlias("PvpGoodsInvoice", PvpGoodsInvoice);
			//----交易所
			registerClassAlias("ExchangeGoods", ExchangeGoods);
			registerClassAlias("ExchangeData", ExchangeData);
			registerClassAlias("ExchangeSellBuy", ExchangeSellBuy);
			registerClassAlias("Exchange_Error", Exchange_Error);

		}
		
		
	}//end class

}//end package