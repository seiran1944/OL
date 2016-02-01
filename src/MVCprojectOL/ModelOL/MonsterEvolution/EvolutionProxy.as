package MVCprojectOL.ModelOL.MonsterEvolution
{
	import flashx.textLayout.compose.IFlowComposer;
	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.PayBill.PayBillDataCenter;
	import MVCprojectOL.ModelOL.ShopMall.ShopMallProxy;
	import MVCprojectOL.ModelOL.Vo.Evolution;
	import MVCprojectOL.ModelOL.Vo.EvolutionBox;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Evolution;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	import MVCprojectOL.ModelOL.Vo.ReturnMonster;
	import MVCprojectOL.ModelOL.Vo.Set.Set_Evolution;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class EvolutionProxy extends ProxY 
	{
		
		private var _netConnect:AmfConnector;
		private var _Evolution:EvolutionDataCenter;
		private var _checkFlag:int = 0;
		private var _monsterServerWrite:MonsterServerWrite;
		private var _ShopMallProxy:ShopMallProxy;
		
		//private var _systemMoney:uint;
		//--填入進化刷技能消費的KEY
		private const _skillKey:String = "SysCost_RANDSKILL_COST";
		
		private const _strRandomPay:String = "RandomSkillFactory";
		public function EvolutionProxy()
		{
			super(ProxyPVEStrList.MonsterEvolution_Proxy);
		}
		
		
		override public function onRegisteredProxy():void 
		{
		    this._Evolution = EvolutionDataCenter.GetInstance(this.SendNotify,this.ConnectVOCall);
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler, this );
			this._monsterServerWrite = MonsterServerWrite.GetMonsterServerWrite();
			this._netConnect = AmfConnector.GetInstance();
			this.SendNotify(ProxyPVEStrList.MonsterEvolution_ProxyReady);
			//this._monsterServerWrite = MonsterServerWrite.GetMonsterServerWrite();
			//--SysCost_RANDSKILL_COST
			//this._systemMoney = PayBillDataCenter.GetInstance().Inquiry(_skillKey);
		}
		
		override public function onRemovedProxy():void 
		{
			
			
		}
		
		
		
		//----連線
		private function ConnectVOCall(_type:String,_evoID:String="",_monster:String="",_otherID:String=""):void 
		{
			
			var _class:*;
			
			switch(_type) {
			  
			  //---取列表---
			  case ProxyPVEStrList.MonsterEvolution_GetList:
				_class = new Get_Evolution; 
				this._netConnect.VoCall(_class);
				
			  break;
			  //-----進化----
		      case ProxyPVEStrList.MonsterEvolution_SetEvo:
			    //_class = new Set_Evolution(_evoID, _monster, _otherID);
				//this._netConnect.VoCallGroup(_class);
				this._netConnect.VoCallGroup(new Set_Evolution(_evoID, _monster, _otherID));
				AmfConnector.GetInstance().SendVoGroup();
			     
			  break;
			  //---刷技能----
		      case ProxyPVEStrList.MonsterEvolution_changeSkill:
			   //_class = new Set_Evolution("","",_monster);
			   
			  break;
			  
			}
			/*
			var _checkVoGroup:Array = this._netConnect.currentGroupRequestingList;
			if (_checkVoGroup == null) {
	
			}*/
			
			
			
		}
		
		
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//---switch/case---
			
			switch(_Result.Status) {
				
				case "EvolutionList":
					//trace("<----------------------------------------getMonsterList");
					var _ary:Array = _netResultPack._result as Array;
					this._Evolution.AddEvolutionList(_ary);
					
				break;
				
			    case"Set_Evolution":
				    //this._monsterServerWrite.WriteBack(ReturnMonster(_netResultPack._result));
					//if (_netResultPack._result is ReturnMonster) {
						//} else {
						//----進化回來----
						//---進化的技能擺在陣列的第2個位置--
						var _evoBox:EvolutionBox = _netResultPack._result as EvolutionBox; 
						var _monster:PlayerMonster = PlayerMonster(_evoBox._playerMonster);
						if (_evoBox._playerMonster != null) {
						   var _otherMonster:Object = this._Evolution.GetQueue(_evoBox._oldTargetID);
						   var _deleteMonster:Object = { _monster:_evoBox._oldTargetID , _teamGroup:_evoBox._playerMonster._teamGroup, _newMonster:_evoBox._playerMonster._guid };
						   //--準備塞進去組隊了--
						   CrewProxy.GetInstance().EvolutionCrewVary(_deleteMonster,_otherMonster);
						   this._monsterServerWrite.AddVoMonster([_monster]);		
						}
						//if(_evoBox._evolution!=null)this._Evolution.AddEvolutionList([Evolution(_evoBox._evolution)],"EvoBack",_monster._guid);
						var _aryEvo:Array = (_evoBox._evolution!=null)?[Evolution(_evoBox._evolution)]:null;
						var _strIndex:String = (_aryEvo==null)?"":"EvoBack";
						this._Evolution.AddEvolutionList(_aryEvo,_strIndex,_monster._guid,_monster._arySkill[1]);
						
					//}
					//---更新
					//if (this._checkFlag > 0) this.UpdateList();
					//this._checkFlag++;
				break;
				
				/*
			    case "RandomEvo_Skill":
				   //----刷技能回來
				   //----要再補技能回送大輪盤---	
				   //this._monsterServerWrite.WriteBack(ReturnMonster(_netResultPack._result as ReturnMonster));
				   //this.SendNotify();
				break;
				*/
			}
		}
		
		
		//---進入系統更新清單---
		public function UpdateList():void 
		{
			this.ConnectVOCall(ProxyPVEStrList.MonsterEvolution_GetList);
		}
		
		
		//---取得進化表
		public function GetEvolutionList():Array 
		{
			return this._Evolution.GetEvolutionList();
		}
		
		//----小於1就代表不能進化
		//----[1=成功/-1=查無怪獸資料  -2=怪獸不是處於閒置狀態 -3=查詢不到進化表 -98需要獻技的怪物]	
		public function checkEvolution(_targetID:String,_recipeID:String,_otherID:String=""):int 
		{
		  return this._Evolution.checkEvolution(_targetID,_recipeID,_otherID);	
		}
		
		//---進化*-----(小於1=條件不合法)
		public function GetEvolution(_targetGuid:String,_evoGuid:String,_otherGuid:String=""):int 
		{
			return this._Evolution.GetEvolution(_targetGuid,_evoGuid,_otherGuid);
		}
		
		//---金鑽重刷技能-----
		//-[ -4] > 玩家金鑽餘額不足 >
		public function ChangeSkill(_monsterID:String=""):void 
		{
			//this._Evolution.ReSetSkill(_monsterID);
			//ProxyPVEStrList.ShopMall_Proxy
			this._ShopMallProxy.Pay();
			//--準備金鑽消費----
		}
		
		//----撿查刷技能耗費金額
		public function CheckAndShowMoney(_monsterID:String):Object 
		{
			var _returnObj:Object = { };
			if (this._ShopMallProxy==null)this._ShopMallProxy=ShopMallProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.ShopMall_Proxy));
			var _targetObj:Object = {_tagretID:_monsterID,_type:2};
			var _payObj:Object = {_key:this._skillKey};
		    //var _checkPay:
			if (this._ShopMallProxy.CheckPay(this._strRandomPay,_targetObj,_payObj)) {
				_returnObj._flag = true;
				_returnObj._showMoney = this._ShopMallProxy.GetPayTotal();
				} else {
				//---消費金額不足
				_returnObj._flag = false;
				_returnObj._showMoney = -1;
			}
        	return 	_returnObj;
		}
		
		//----檢查完加持有金鑽是否符合條件進行操作-*---
		/*
		--[-1]>該怪獸查詢資料錯誤>
		[ -2] > 該怪獸不是進化怪獸不能刷技能 >
		[ -3] > 該怪獸不在閒置中
		
		[1] > 可以執行刷技能
		*/
		//---進化刷技能撿查怪獸狀態-----
		public function CheckMonsterStatus(_monsterID:String):int
		{
			return this._Evolution.CheckMonsterStatus(_monsterID);
		}
		
		
		
		
	}
	
}