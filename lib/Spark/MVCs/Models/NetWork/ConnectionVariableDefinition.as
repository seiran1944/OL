package Spark.MVCs.Models.NetWork {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 12.11.23.11.52
	 */
	
	/*import NetWorkVO.*;
	import NetWorkVO.Get.*;
	import NetWorkVO.Set.*;*/
	
	import flash.net.registerClassAlias;
	
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.MVCs.Models.NetWork.GroupCall.NetResultPackGroup;
	import Spark.MVCs.Models.NetWork.GroupCall.Get_ResultGroup;
	
	public class ConnectionVariableDefinition {
		public static var _ConnectionVariableDefinition:ConnectionVariableDefinition; 
		private var _GateWay:String = "http://ol-wg.web.runewaker.com/Amfphp/";//"http://127.0.0.1/amfphp2/gateway.php";
		public var _VoServiceFunction:String = "VoService/Send";//AmfPhp的Vo接口
		public var _VoGroupServiceFunction:String = "VoService/SendGroup";//AmfPhp的Vo接口
		public var _QueueExecutePeriod:uint = 100;
		
		public function ConnectionVariableDefinition( _InputGateWay:String = null ) {
			ConnectionVariableDefinition._ConnectionVariableDefinition = this;
			this._GateWay = ( _InputGateWay == null ) ? this._GateWay : _InputGateWay;
			
			//註冊預設的VO
			registerClassAlias( "NetResultPack" , NetResultPack );
			registerClassAlias( "NetResultPackGroup" , NetResultPackGroup );
			registerClassAlias( "Get_ResultGroup" , Get_ResultGroup );
		}
		
		public static function GetInstance():ConnectionVariableDefinition {
			return ConnectionVariableDefinition._ConnectionVariableDefinition = ( ConnectionVariableDefinition._ConnectionVariableDefinition == null ) ? new ConnectionVariableDefinition() : ConnectionVariableDefinition._ConnectionVariableDefinition; //singleton pattern
		}
		
		public function InitVoMapping():void {
			/*GetVoClassesMappingList();
			SetVoClassesMappingList();
			PropertiesVoClassesMappingList();*/
		}
		
		public function get GateWay():String 
		{
			return _GateWay;
		}
		
		public function set GateWay(value:String):void 
		{
			_GateWay = value;
		}
		
		/*private static function GetVoClassesMappingList():void {
			registerClassAlias( "Get_Monster" , Get_Monster );//取得玩家怪物資料
			registerClassAlias( "Get_PlayerInfo" , Get_PlayerInfo );//取得玩家資訊
			registerClassAlias( "Get_PlayerPackage" , Get_PlayerPackage );//取得玩家背包資訊
			registerClassAlias( "Get_Stone" , Get_Stone );//取得玩家魔法石
			
			registerClassAlias( "Get_NewMonster" , Get_NewMonster );//抽卡 取得新怪獸
			
			registerClassAlias( "Get_UpgradedMonster" , Get_UpgradedMonster );//升級 取得升級版怪獸
			
			registerClassAlias( "Get_SacrificeReward" , Get_SacrificeReward );//獻祭 取得獻祭獎勵(屬性石)
			
			//--------組隊
			registerClassAlias( "Get_CountryList" , Get_CountryList );//取得王國資訊
			registerClassAlias( "Get_FormInfo" , Get_FormInfo );//取得所有陣形資訊
			registerClassAlias( "Get_TeamGroup" , Get_TeamGroup );//取得玩家組隊資訊
			//-END----組隊
			
			
			//--------地圖
			registerClassAlias( "Get_EngageResult" , Get_EngageResult );//出征 取得交戰結果(更新地圖資訊)
			registerClassAlias( "Get_MapInfo" , Get_MapInfo );//取得地圖資訊
			//-END----地圖
		}
		
		private static function SetVoClassesMappingList():void {
			//--------組隊
			registerClassAlias( "Set_TeamGroup" , Set_TeamGroup );//回寫玩家組隊資訊
			
			registerClassAlias( "Set_Equipment" , Set_Equipment );//回寫玩家組隊資訊
			//-END----組隊
		}
		
		private static function PropertiesVoClassesMappingList():void {
			//registerClassAlias( "PersonVO.Person" , Person );//for test IP:127.0.0.1  	
			
			registerClassAlias( "VOPlayerInfo" , VOPlayerInfo );//玩家資訊
			
			//-------獸欄
			registerClassAlias( "VOMonster" , VOMonster );//玩家怪物
			registerClassAlias( "VOPlayerPackage" , VOPlayerPackage );//玩家背包資訊
			registerClassAlias( "VOStone" , VOStone );//玩家屬性石資訊
			registerClassAlias( "VoSkill" , VoSkill );//
			//--END--獸欄
			
			
			//-------組隊資訊
			registerClassAlias( "VOTeamGroup" , VOTeamGroup );//玩家隊伍資訊
			registerClassAlias( "VOFormInfo" , VOFormInfo );//所有陣形資訊
			registerClassAlias( "VOCountry" , VOCountry );//玩有國度資訊
			//registerClassAlias( "VOOrganize" , VOOrganize );//玩家組隊配置資訊	wasted	120703
			//--END--組隊資訊
			
			
			//-------地圖資訊
			registerClassAlias( "VOMapInfo" , VOMapInfo );//
				registerClassAlias( "VOCity" , VOCity );//
				registerClassAlias( "VOPatrol" , VOPatrol );//
			//--END--地圖資訊
		}*/
		
		
	}//end class

}//end package

/*public class MappingPack {
	
	private const _VoTitle:String = "VO";
	private const _GetTitle:String = "Get_";
	private const _SetTitle:String = "Set_";
	
	private const _PhpGetPath:String = "Get.";
	private const _PhpSetPath:String = "Set.";
	private const _PhpVoPath:String = "";
	
	private var _PackName:String = "";
	
	public function MappingPack( _InputPackName:String ) {
		this._PackName = _InputPackName;
	}
	
	public function RegisterMapping():void {
		
	}
	
	
	
	
}//end class*/





