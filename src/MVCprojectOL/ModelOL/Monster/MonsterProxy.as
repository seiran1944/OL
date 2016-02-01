package MVCprojectOL.ModelOL.Monster 
{
	//import MVCprojectOL.ModelOL.Vo.Get.Get_Monster;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerMonster;
	import MVCprojectOL.ModelOL.Vo.ReturnMonster;
	import MVCprojectOL.ModelOL.Vo.Set.Set_PlayerMonster;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ProxyMonsterStr;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  MonsterProxy extends ProxY
	{
		//---getMonster----
		private var _monsterdataCenter:PlayerMonsterDataCenter;
		//---setMonster------
		private var _monsterServerWrite:MonsterServerWrite;
		private var _netConnect:AmfConnector;
		private var _aryVoClall:Array;
		//private var _function:Function;
		public function MonsterProxy() 
		{
			super(ProxyMonsterStr.MONSTER_PROXY,this);
		}
		
		
		
		override public function onRegisteredProxy():void 
		{
			//trace("Monster_RegisteredProxy");
			//this._monsterdataCenter = PlayerMonsterDataCenter.GetMonsterData(this.SendNotifyHandler);
			//---getMonster------------
			this._monsterdataCenter = PlayerMonsterDataCenter.GetMonsterData();
			this._monsterdataCenter.SetBuildGuid(BuildingProxy.GetInstance().GetBuildingGuid(2), 2);
			
			//----setMonster------
			this._monsterServerWrite = MonsterServerWrite.GetMonsterServerWrite(this.SendNotifyHandler,this.ConnectVOCall);
			
			
			//---掛監聽EventExpress
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler,this );
			this._netConnect = AmfConnector.GetInstance();
			//----需要再擴增
			this._aryVoClall = [Get_PlayerMonster];
			this.ConnectVOCall(ProxyMonsterStr.CALL_MONSTERLIST);
		}
		
		override public function onRemovedProxy():void 
		{
			var _flag:Boolean = EventExpress.RevokeAddressRequest(this.SetNetResultHandler);
			trace("remove_monsterProxy>"+_flag);
			this._monsterdataCenter.OnRemoveClass();
			this._monsterdataCenter = null;
			
		}
		
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//---switch/case---
			
			switch(_Result.Status) {
				
				case "PlayerMonster":
					trace("<----------------------------------------getMonsterList");
					var _ary:Array = _netResultPack._result as Array;
					this.AddMonster(_ary );
					
				break;
				
			    case"SetMonster_replyDataType":
				    this._monsterServerWrite.WriteBack(ReturnMonster(_netResultPack._result));
				break;
				
			}
		}
		
		
		//----sendNotify
		private function SendNotifyHandler(_str:String,_obj:Object=null):void 
		{
			this.SendNotify(_str,_obj);
		}
		
		//----連線(持續擴增)
		private function ConnectVOCall(_type:String,_args:*=null):void 
		{
			var _class:Class;
			switch(_type) {
				
				case ProxyMonsterStr.CALL_MONSTERLIST:	
					trace("getMonsterCall");
					_class = this._aryVoClall[0];
					this._netConnect.VoCall(new _class);
					//this._netConnect.ConnectMode = "Manual";
					//this._netConnect.VoCall(new Get_PlayerMonster());
					//this._netConnect.StartQueue();
				break;
				
			    case ProxyMonsterStr.Monster_voGroup:
				    if (_args != null) {
					this._netConnect.VoCallGroup(_args);	
					}
				break;
				
			}
		}
		
		
	    //----取得怪獸的數量---
		public function GetMonsterNumber():int 
		{
			return this._monsterdataCenter.monsterNowNumber;
		}
		
		//---加入怪獸
		public function AddMonster(_ary:Array):void 
		{
			this._monsterServerWrite.AddVoMonster(_ary);
		    //this.SendNotify(ProxyMonsterStr.MONSTER_PROXY);
		}
		
		//----移除怪獸
		public function RemoveMonster(_index:String):void 
		{
			this._monsterServerWrite.RemoveMonster(_index);
			
		}
		//---Str=排序的指令
		public function GetMonsterList(_str:String):Array
		{
			return this._monsterdataCenter.GetMonsterList(_str);
		}
		
		//----設定怪物加入編隊
		public function SetMonsterTeam(_index:String,_team:String):void 
		{
			this._monsterServerWrite.SetMonsterTeam(_index,_team);
		}
		/*
		public function GetMonsterVauALL():void 
		{
		this._monsterdataCenter.getMonsterVauALL();	
		}
		*/
		//----吃石頭
		public function EatStoneChange(_monsterID:String,_stone:String):void 
		{
			this._monsterServerWrite.eatMonsterVauleHandler(_monsterID,_stone);
		}
		//---檢查怪獸是否可以吞石頭(true=可以/false=不可以)
		public function CheckStoneRange(_monsterID:String):Boolean 
		{
			return this._monsterdataCenter.CheckStoneRange(_monsterID);
		}
		
	    //----記錄改變的總值,並且回傳改變的數值
		//_Key:String,_Hp:int,_Exp:int,_Eng:int
		public function CalculateMonster(_ary:Array):Array
		{
			return this._monsterServerWrite.CalculateMonster(_ary);
		}
		
		//----經驗值的改變(定值)
		public function ChangeEXP(_monster:String,_exp:int):void 
		{
			this._monsterServerWrite.ChangeEXP(_monster, _exp);
			
		}
		
		
		
		
		
		//----疲勞值改變
		public function SetHpValue(_ary:Array):void 
		{
			this._monsterServerWrite.SetHpValue(_ary);
		}
		
		//----生命值改變(送進來的是物件陣列)-obj{_key:string,_vaule:int}
		//----要刪減就給負值
		public function SetFatigueValue(_ary:Array):void  
		{
			this._monsterServerWrite.SetFatigueValue(_ary);
		}
		
		
		//---註冊怪獸使用的時間
		public function RegisterUseMonster(_index:String,_times:uint):void  
		{
			this._monsterServerWrite.RegisterUseMonster(_index,_times);
		}
		
		//---取消使用狀態的怪獸
		public function UnRegisterMonster(_index:String):void  
		{
			this._monsterServerWrite.UnRegisterMonster(_index);
		}
		
		//-----替怪獸穿裝備-----
		
		public function AddEqu(_equGroupID:String,_equID:String,_monsterID:String):void 
		{
			this._monsterServerWrite.AddEqu(_equGroupID,_equID,_monsterID);
		}
		
		//-----脫單一裝備
		public function RemoveMonsterEquSingle(_monsterID:String,_equID:String):void 
		{
			this._monsterServerWrite.RemoveMonsterEquSingle(_monsterID,_equID);
		}
		
		
		//------取得註冊的function-----(tips使用的)
		public function GetTipsFunction():Function 
		{
			return this._monsterdataCenter.TipsCenterHandler;
		}
		
		//---探索回來
		public function ExploreBack(_ary:Array):Array 
		{
			return this._monsterServerWrite.ExploreBack(_ary);
		}
		
		//--------取得怪獸的學習群
		public function GetMonsterLearning(_monster:String):int 
		{
			return this._monsterdataCenter.GetMonsterLearning(_monster);
		}
		
	}
	
}